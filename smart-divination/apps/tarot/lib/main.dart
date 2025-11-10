import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide UserIdentity;

import 'package:common/l10n/common_strings.dart';
import 'package:common/shared/infrastructure/localization/common_strings_extensions.dart';

import 'api/draw_cards_api.dart';
import 'api/interpretation_api.dart';
import 'api/user_profile_api.dart';
import 'api/spread_recommendation_api.dart';
import 'api/question_format_api.dart';
import 'user_identity.dart';
import 'models/tarot_spread.dart';
import 'models/tarot_card.dart';
import 'widgets/spread_layout.dart';
import 'widgets/draw_fullscreen_flow.dart';
import 'widgets/spread_gallery_modal.dart';
import 'widgets/unified_lunar_widget.dart';
import 'widgets/daily_draw_panel.dart';
import 'widgets/smart_draws_panel.dart';
import 'widgets/learn_panel.dart';
import 'widgets/chat_banner.dart';
import 'widgets/archive_banner.dart';
import 'screens/chat_screen.dart';
import 'widgets/ask_moon_banner.dart';
import 'screens/spreads_screen.dart';
import 'screens/learn_screen.dart';
import 'screens/lunar_advisor_screen.dart';
import 'screens/daily_interpretation_screen.dart';
import 'screens/smart_selection_screen.dart';
import 'widgets/archive_screen.dart';
import 'theme/tarot_theme.dart';
import 'services/local_storage_service.dart';
import 'services/daily_quote_service.dart';
import 'services/audio_service.dart';
import 'services/credits_service.dart';
import 'utils/card_image_mapper.dart';
import 'utils/card_name_localizer.dart';
import 'state/full_screen_step.dart';
import 'state/lunar_cycle_controller.dart';
import 'screens/splash_screen.dart';

const String _supabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: 'https://vanrixxzaawybszeuivb.supabase.co',
);
const String _supabaseAnonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue:
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhbnJpeHh6YWF3eWJzemV1aXZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjcxMTQ5NjYsImV4cCI6MjA0MjY5MDk2Nn0.CpqfQBuNVEwMlWbYU1WEA0zFwWBo6RKpPxYi4oy3Xwc',
);
const String _passwordResetRedirectUrl = String.fromEnvironment(
  'SUPABASE_PASSWORD_RESET_REDIRECT',
  defaultValue: '',
);

Future<void> _initialiseSupabase() async {
  try {
    Supabase.instance.client;
    return;
  } catch (_) {
    final url = _supabaseUrl.trim();
    final anonKey = _supabaseAnonKey.trim();
    if (url.isEmpty || anonKey.isEmpty) {
      throw StateError(
        'Supabase configuration missing. Provide SUPABASE_URL and SUPABASE_ANON_KEY.',
      );
    }
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      authOptions: const FlutterAuthClientOptions(
        autoRefreshToken: true,
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initialiseSupabase();
  runApp(const SmartTarotApp());
}

enum _AuthFlow { anonymous, signedOut, passwordRecovery, signedIn }

class SmartTarotApp extends StatefulWidget {
  const SmartTarotApp({super.key});

  @override
  State<SmartTarotApp> createState() => _SmartTarotAppState();
}

class _SmartTarotAppState extends State<SmartTarotApp> {
  Session? _session;
  _AuthFlow _authFlow = _AuthFlow.anonymous;
  StreamSubscription<AuthState>? _authSubscription;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    final client = Supabase.instance.client;
    _session = client.auth.currentSession;
    _authFlow = _session == null ? _AuthFlow.anonymous : _AuthFlow.signedIn;
    _authSubscription = client.auth.onAuthStateChange.listen((event) {
      if (!mounted) {
        return;
      }
      setState(() {
        switch (event.event) {
          case AuthChangeEvent.passwordRecovery:
            _authFlow = _AuthFlow.passwordRecovery;
            _session = null;
            break;
          case AuthChangeEvent.signedOut:
            _session = null;
            _authFlow = _AuthFlow.anonymous;
            break;
          default:
            _session = event.session;
            _authFlow =
                _session == null ? _AuthFlow.anonymous : _AuthFlow.signedIn;
            break;
        }
      });
    });
  }

  void _completeSplash() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handlePasswordResetComplete() async {
    await Supabase.instance.client.auth.signOut();
    if (!mounted) {
      return;
    }
    setState(() {
      _session = null;
      _authFlow = _AuthFlow.anonymous;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show splash screen first
    if (_showSplash) {
      return MaterialApp(
        title: 'Smart Tarot',
        debugShowCheckedModeBanner: false,
        theme: TarotTheme.darkTheme,
        home: SplashScreen(onComplete: _completeSplash),
      );
    }

    final Widget home;
    switch (_authFlow) {
      case _AuthFlow.passwordRecovery:
        home = _PasswordResetView(onFinished: _handlePasswordResetComplete);
        break;
      case _AuthFlow.signedIn:
        home = const _Home();
        break;
      case _AuthFlow.anonymous:
        home = const _Home();
        break;
      case _AuthFlow.signedOut:
        home = const _SignInView();
        break;
    }

    return MaterialApp(
      title: 'Smart Tarot',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: CommonStrings.localizationsDelegates,
      supportedLocales: CommonStrings.supportedLocales,
      theme: TarotTheme.darkTheme,
      home: home,
    );
  }
}

class _SignInView extends StatefulWidget {
  const _SignInView();

  @override
  State<_SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<_SignInView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isRegisterMode = false;
  bool _submitting = false;
  bool _sendingPasswordReset = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final localisation = CommonStrings.of(context);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.length < 6) {
      setState(() {
        _errorMessage = localisation.authValidationError;
      });
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      final auth = Supabase.instance.client.auth;
      if (_isRegisterMode) {
        final response = await auth.signUp(email: email, password: password);
        if (!mounted) {
          return;
        }
        final message = response.session == null
            ? localisation.authSignUpConfirmationSent
            : localisation.authSignUpSuccess;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        setState(() {
          _isRegisterMode = false;
        });
      } else {
        await auth.signInWithPassword(email: email, password: password);
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localisation.authSignInSuccess)),
        );
      }
      _passwordController.clear();
    } on AuthException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = error.message.isNotEmpty
            ? error.message
            : localisation.authGenericError;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = localisation.authUnexpectedError('');
      });
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  void _toggleMode() {
    setState(() {
      _isRegisterMode = !_isRegisterMode;
      _errorMessage = null;
    });
  }

  Future<void> _promptPasswordReset() async {
    final localisation = CommonStrings.of(context);
    final controller =
        TextEditingController(text: _emailController.text.trim());
    String? dialogError;

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(localisation.authForgotPasswordTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(localisation.authForgotPasswordDescription),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const <String>[AutofillHints.email],
                    decoration: InputDecoration(
                      labelText: localisation.authEmailLabel,
                      errorText: dialogError,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(CommonStrings.of(dialogContext).cancel),
                ),
                FilledButton(
                  onPressed: () {
                    final value = controller.text.trim();
                    if (value.isEmpty) {
                      setDialogState(() {
                        dialogError =
                            localisation.authForgotPasswordMissingEmail;
                      });
                      return;
                    }
                    Navigator.of(dialogContext).pop(value);
                  },
                  child: Text(localisation.authForgotPasswordSubmit),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null || !mounted) {
      return;
    }

    await _sendPasswordReset(result);
  }

  Future<void> _sendPasswordReset(String email) async {
    final localisation = CommonStrings.of(context);
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      setState(() {
        _errorMessage = localisation.authForgotPasswordMissingEmail;
      });
      return;
    }

    setState(() {
      _sendingPasswordReset = true;
    });

    try {
      final redirect = _passwordResetRedirectUrl.trim();
      if (redirect.isEmpty) {
        await Supabase.instance.client.auth.resetPasswordForEmail(trimmedEmail);
      } else {
        await Supabase.instance.client.auth.resetPasswordForEmail(
          trimmedEmail,
          redirectTo: redirect,
        );
      }
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localisation.authForgotPasswordSuccess)),
      );
    } on AuthException catch (error) {
      if (!mounted) {
        return;
      }
      final message = error.message.isNotEmpty
          ? error.message
          : localisation.authGenericError;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localisation.authUnexpectedError(''))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sendingPasswordReset = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localisation = CommonStrings.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localisation.appTitle('tarot')),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isRegisterMode
                      ? localisation.authSignUpTitle
                      : localisation.authSignInTitle,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const <String>[AutofillHints.email],
                  enabled: !_submitting,
                  decoration: InputDecoration(
                    labelText: localisation.authEmailLabel,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  enabled: !_submitting,
                  autofillHints: const <String>[AutofillHints.password],
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: _isRegisterMode
                        ? localisation.authPasswordLabelWithHint
                        : localisation.authPasswordLabel,
                  ),
                ),
                if (!_isRegisterMode)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: (_submitting || _sendingPasswordReset)
                          ? null
                          : _promptPasswordReset,
                      child: Text(localisation.authForgotPasswordLink),
                    ),
                  ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _isRegisterMode
                              ? localisation.authSignUpButton
                              : localisation.authSignInButton,
                        ),
                ),
                const SizedBox(height: 0),
                TextButton(
                  onPressed: _submitting ? null : _toggleMode,
                  child: Text(
                    _isRegisterMode
                        ? localisation.authToggleToSignIn
                        : localisation.authToggleToSignUp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordResetView extends StatefulWidget {
  const _PasswordResetView({required this.onFinished});

  final Future<void> Function() onFinished;

  @override
  State<_PasswordResetView> createState() => _PasswordResetViewState();
}

class _PasswordResetViewState extends State<_PasswordResetView> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    final localisation = CommonStrings.of(context);
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (password.length < 6 || password != confirm) {
      setState(() {
        _errorMessage = localisation.authPasswordResetMismatch;
      });
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: password),
      );
      if (!mounted) {
        return;
      }
      final successMessage =
          '${localisation.authPasswordResetSuccess}\n${localisation.authPasswordResetSignOutNotice}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
      await widget.onFinished();
    } on AuthException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = error.message.isNotEmpty
            ? error.message
            : localisation.authPasswordResetError;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = localisation.authUnexpectedError('');
      });
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  Future<void> _cancel() async {
    await widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    final localisation = CommonStrings.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localisation.authPasswordResetTitle),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  localisation.authPasswordResetDescription,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  autofillHints: const <String>[AutofillHints.newPassword],
                  decoration: InputDecoration(
                    labelText: localisation.authPasswordResetNewPasswordLabel,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmController,
                  obscureText: true,
                  autofillHints: const <String>[AutofillHints.newPassword],
                  decoration: InputDecoration(
                    labelText:
                        localisation.authPasswordResetConfirmPasswordLabel,
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _submitting ? null : _updatePassword,
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(localisation.authPasswordResetButton),
                ),
                TextButton(
                  onPressed: _submitting ? null : _cancel,
                  child: Text(localisation.cancel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Home extends StatefulWidget {
  const _Home();

  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  String? _userId;
  bool _initialising = true;
  String? _error;
  UserProfile? _profile;
  List<TarotSession> _history = <TarotSession>[];
  CardsDrawResponse? _latestDraw;
  InterpretationResult? _latestInterpretation;
  int _dealtCardCount = 0;
  bool _dealingCards = false;
  int _revealedCardCount = 0;
  bool _revealingCards = false;
  String? _currentQuestion;
  bool _drawing = false;
  bool _requestingInterpretation = false;
  bool _showInterpretation =
      false; // Controls whether interpretation is visible
  TarotSpread _selectedSpread = TarotSpreads.threeCard;
  String? _spreadRecommendationReason; // AI reasoning for spread selection
  String? _spreadInterpretationGuide; // AI guide on how to interpret the spread
  String? _displayQuestion;
  String? _editedQuestion;
  String? _lastQuestionLocale;
  FullScreenStep? _fullScreenStep;
  Timer? _briefingAutoAdvanceTimer;
  final TextEditingController _seedController = TextEditingController();
  late final LunarCycleController _lunarController;
  List<TarotCard>? _dailyCards;
  CardsDrawResponse? _dailyDrawResponse;
  bool _loadingDailyDraw = false;
  final CreditsService _creditsService = CreditsService();
  late final ValueNotifier<DailyCredits> _creditsNotifier;
  int _selectedBottomNavIndex = 0; // 0=Home, 1=Chat, 2=Spreads, 3=Archive, 4=Learn
  late final Future<DailyQuote?> _dailyQuoteFuture;

  static const List<String> _supportedQuestionLocales = <String>[
    'ca',
    'es',
    'en'
  ];

  static const Set<String> _catalanPriorityTokens = {
    'perquÃ¨',
    'perque',
    'quÃ¨',
    'aquest',
    'aquesta',
    'aquests',
    'aquestes',
    'aixÃ²',
    'aixo',
    'doncs',
    'vosaltres',
    'nostre',
    'nostra',
    'camÃ­',
    'cami',
    'camins',
    'dubte',
    'dubtes',
    'consell',
    'guia',
    'relaciÃ³',
    'relacio',
    'energia',
    'llum',
    'projecte',
    'estimar',
    'vull',
    'necessito',
  };

  static const Set<String> _spanishPriorityTokens = {
    'porque',
    'porquÃ©',
    'quÃ©',
    'esta',
    'este',
    'estos',
    'estas',
    'maÃ±ana',
    'ayer',
    'pareja',
    'trabajo',
    'dinero',
    'salud',
    'amor',
    'necesito',
    'quiero',
    'ayuda',
    'situaciÃ³n',
    'situacion',
    'relaciÃ³n',
    'relacion',
    'decisiÃ³n',
    'decision',
    'cartas',
    'carta',
    'futuro',
    'familia',
    'prosperidad',
  };

  static const Set<String> _englishPriorityTokens = {
    'love',
    'career',
    'job',
    'money',
    'health',
    'future',
    'relationship',
    'help',
    'need',
    'should',
    'will',
    'feel',
    'today',
    'tomorrow',
    'cards',
    'card',
    'spread',
    'reading',
    'guidance',
    'work',
    'life',
    'change',
    'advice',
    'question',
    'answer',
    'clarity',
    'family',
  };

  @override
  void initState() {
    super.initState();
    _creditsNotifier = _creditsService.notifier;
    unawaited(_creditsService.initialize());
    _lunarController = LunarCycleController();
    // Memoize daily quote future to prevent repeated asset loads
    _dailyQuoteFuture = DailyQuoteService.getTodayQuote();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAll();
    });
  }

  @override
  void dispose() {
    _briefingAutoAdvanceTimer?.cancel();
    _briefingAutoAdvanceTimer = null;
    _seedController.dispose();
    _lunarController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() {
      _initialising = true;
      _error = null;
    });

    try {
      debugPrint('[Startup] Phase 1: Obtaining userId...');
      final userId = await UserIdentity.obtain();
      debugPrint('[Startup] Phase 1 complete: userId=$userId');

      if (!mounted) {
        return;
      }

      // Store userId immediately
      setState(() {
        _userId = userId;
      });

      final locale = CommonStrings.of(context).localeName;
      final isAnonymous = userId.startsWith('anon_');

      debugPrint('[Startup] Phase 2: Parallelizing essential loads (lunar + daily draw)...');

      // Essential parallel loads for first render
      final essentialFutures = <Future<void>>[
        // Lunar controller initialization
        _lunarController.initialise(locale: locale, userId: userId).then((_) {
          debugPrint('[Startup] Lunar controller initialized');
        }).catchError((e) {
          debugPrint('[Startup] Lunar controller error: $e');
          throw e;
        }),

        // Daily draw with userId to avoid re-fetch
        _generateDailyDraw(userId: userId).then((_) {
          debugPrint('[Startup] Daily draw generated');
        }).catchError((e) {
          debugPrint('[Startup] Daily draw error: $e');
          throw e;
        }),
      ];

      // Wait for essential items to complete
      await Future.wait(essentialFutures);

      if (!mounted) {
        return;
      }

      // Mark as ready for first render
      setState(() {
        _initialising = false;
      });

      debugPrint('[Startup] Phase 2 complete: App ready for first render');

      // Non-essential background loads (profile and history)
      if (!isAnonymous) {
        debugPrint('[Startup] Phase 3: Loading profile + history in background...');

        // Load profile in background
        fetchUserProfile(userId: userId).then((profile) {
          if (mounted) {
            setState(() {
              _profile = profile;
            });
            debugPrint('[Startup] Profile loaded');
          }
        }).catchError((e) {
          debugPrint('[Startup] Profile load failed (non-critical): $e');
        });

        // Load history in background
        fetchTarotSessions(userId: userId).then((history) {
          if (mounted) {
            setState(() {
              _history = history;
            });
            debugPrint('[Startup] History loaded (${history.length} sessions)');
          }
        }).catchError((e) {
          debugPrint('[Startup] History load failed (non-critical): $e');
        });
      } else {
        debugPrint('[Startup] Anonymous user - skipping profile/history load');
        setState(() {
          _profile = null;
          _history = <TarotSession>[];
        });
      }
    } catch (error, stackTrace) {
      if (!mounted) {
        return;
      }
      final localisation = CommonStrings.of(context);
      final formattedError = _formatError(localisation, error);
      setState(() {
        _error = formattedError;
        _initialising = false;
      });
      debugPrint('Failed to load initial data: $error');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> _generateDailyDraw({String? userId}) async {
    if (_loadingDailyDraw) {
      debugPrint('⏸️ Daily draw already loading, skipping');
      return;
    }

    debugPrint('🎴 Starting daily draw generation for userId: $userId');
    setState(() {
      _loadingDailyDraw = true;
    });

    try {
      // Draw 3 cards for the daily draw using the API
      // Pass userId to avoid re-fetching in drawCards
      final response = await drawCards(
        count: 3,
        allowReversed: true,
        spread: 'three_card',
        userId: userId,
      );

      if (!mounted) {
        debugPrint('⚠️ Widget unmounted, abandoning daily draw');
        return;
      }

      // Convert CardResults to TarotCards
      final cards = response.result.map((card) {
        final imagePath = _getCardImagePath(card);
        return TarotCard.fromCardResult(card, imagePath: imagePath);
      }).toList();

      debugPrint('✅ Daily draw generated successfully: ${cards.length} cards');
      setState(() {
        _dailyCards = cards;
        _dailyDrawResponse = response;
        _loadingDailyDraw = false;
      });
    } catch (error, stackTrace) {
      if (!mounted) {
        return;
      }
      debugPrint('❌ Failed to generate daily draw: $error');
      debugPrint('Stack trace: $stackTrace');
      setState(() {
        _dailyCards = null;
        _loadingDailyDraw = false;
      });
    }
  }

  Future<void> _refreshProfile() async {
    final userId = _userId;
    if (userId == null || userId.startsWith('anon_')) {
      return;
    }
    try {
      final profile = await fetchUserProfile(userId: userId);
      if (!mounted) {
        return;
      }
      setState(() {
        _profile = profile;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      final localisation = CommonStrings.of(context);
      setState(() {
        _error ??= _formatError(localisation, error);
      });
    }
  }

  Future<void> _refreshHistory() async {
    final userId = _userId;
    if (userId == null) {
      return;
    }
    // Skip history refresh for anonymous users
    if (userId.startsWith('anon_')) {
      return;
    }
    try {
      final history = await fetchTarotSessions(userId: userId);
      if (!mounted) {
        return;
      }
      setState(() {
        _history = history;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      final localisation = CommonStrings.of(context);
      setState(() {
        _error ??= _formatError(localisation, error);
      });
    }
  }

  Future<void> _drawCards() async {
    if (_drawing) {
      return;
    }
    final localisation = CommonStrings.of(context);
    setState(() {
      _drawing = true;
      _error = null;
    });

    try {
      final seed = _seedController.text.trim();
      final typedQuestion = '';
      final localeCode = _resolveQuestionLocale(typedQuestion);
      _lastQuestionLocale = localeCode;
      final baseQuestion = typedQuestion.isNotEmpty
          ? typedQuestion
          : _generalConsultationPrompt(localeCode);
      String? formattedQuestion;
      try {
        formattedQuestion = await formatQuestion(
          question: baseQuestion,
          locale: localeCode,
        );
      } catch (error) {
        // Question formatting failed, continue with fallback
      }
      final String formattedOrFallback =
          (formattedQuestion != null && formattedQuestion.trim().isNotEmpty)
              ? formattedQuestion.trim()
              : _formatQuestionLabel(baseQuestion);

      // Use formatted question directly (no autocorrection)
      final String finalQuestion = formattedOrFallback;
      final String displayQuestion = formattedOrFallback;

      TarotSpread selectedSpread = _selectedSpread;
      String? recommendationReason;
      String? interpretationGuide;

      // If no question provided, automatically use Celtic Cross
      if (typedQuestion.isEmpty) {
        selectedSpread = TarotSpreads.celticCross;
        recommendationReason = null;
        interpretationGuide = null;

        // Update UI immediately to show Celtic Cross selection
        if (mounted) {
          setState(() {
            _selectedSpread = selectedSpread;
            _spreadRecommendationReason = null;
            _spreadInterpretationGuide = null;
          });
        }
      } else {
        try {
          // Use non-streaming endpoint for now (streaming endpoint has deployment issues)
          final recommendation = await recommendSpread(
            question: finalQuestion,
            locale: localeCode,
            // Don't pass onReasoningChunk to use non-streaming endpoint
          );

          selectedSpread = recommendation.spread;
          recommendationReason = recommendation.reasoning;
          interpretationGuide = recommendation.interpretationGuide;

          debugPrint('ðŸŽ´ Spread recommendation received:');
          debugPrint('   - Spread: ${selectedSpread.id}');
          debugPrint(
              '   - Reasoning: ${recommendationReason?.substring(0, 50)}...');
          debugPrint(
              '   - Interpretation guide: ${interpretationGuide ?? "NULL"}');

          // Update UI immediately to show the AI-selected spread
          if (mounted) {
            setState(() {
              _selectedSpread = selectedSpread;
              _spreadRecommendationReason = recommendationReason;
              _spreadInterpretationGuide = interpretationGuide;
            });
          }
        } catch (e) {
          // If AI fails, continue with manually selected spread
        }
      }

      // Start drawing cards, but also pre-load interpretation in parallel

      await _performDrawFlow(
        spread: selectedSpread,
        localeCode: localeCode,
        finalQuestion: finalQuestion,
        displayQuestion: displayQuestion,
        recommendationReason: recommendationReason,
        interpretationGuide: interpretationGuide,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = _formatError(localisation, error);
      });
    } finally {
      if (mounted) {
        setState(() {
          _drawing = false;
        });
      }
    }
  }

  Future<String> _formatQuestionForLocale(
    String baseQuestion,
    String localeCode,
  ) async {
    try {
      final formatted = await formatQuestion(
        question: baseQuestion,
        locale: localeCode,
      );
      if (formatted.trim().isNotEmpty) {
        return formatted.trim();
      }
    } catch (_) {
      // Ignore formatting failures and fall back below.
    }
    return _formatQuestionLabel(baseQuestion);
  }

  Future<void> _performDrawFlow({
    required TarotSpread spread,
    required String localeCode,
    required String finalQuestion,
    required String displayQuestion,
    String? recommendationReason,
    String? interpretationGuide,
  }) async {
    final seed = _seedController.text.trim();
    final response = await drawCards(
      count: spread.cardCount,
      spread: spread.id,
      allowReversed: true,
      seed: seed.isEmpty ? null : seed,
      question: finalQuestion,
      locale: localeCode,
    );

    if (!mounted) {
      return;
    }
    setState(() {
      _latestDraw = response;
      _latestInterpretation = null;
      _dealtCardCount = 0;
      _dealingCards = false;
      _revealedCardCount = 0;
      _revealingCards = false;
      _requestingInterpretation = false;
      _showInterpretation = false;
      _currentQuestion = finalQuestion;
      _displayQuestion = displayQuestion;
      _selectedSpread = spread;
      _spreadRecommendationReason = recommendationReason;
      _spreadInterpretationGuide = interpretationGuide;
    });
    _enterFullScreenFlow();

    if (response.sessionId != null && response.sessionId!.isNotEmpty) {
      _preloadInterpretation(response, finalQuestion, localeCode);
    }

    await Future.wait([
      _refreshHistory(),
      _refreshProfile(),
    ]);
  }

  Future<void> _startThemeConsultation({
    required SpreadThemeOption theme,
    required TarotSpread spread,
    String? question,
    String? displayLabel,
  }) async {
    if (_drawing) {
      return;
    }
    final localisation = CommonStrings.of(context);
    setState(() {
      _drawing = true;
      _error = null;
    });

    try {
      final localeCode = _resolveQuestionLocale(question ?? '');
      final baseQuestion = (question != null && question.trim().isNotEmpty)
          ? question.trim()
          : _generalConsultationPrompt(localeCode);
      final formattedQuestion =
          await _formatQuestionForLocale(baseQuestion, localeCode);
      final displayQuestion =
          (displayLabel != null && displayLabel.trim().isNotEmpty)
              ? displayLabel.trim()
              : _formatQuestionLabel(formattedQuestion);

      await _performDrawFlow(
        spread: spread,
        localeCode: localeCode,
        finalQuestion: formattedQuestion,
        displayQuestion: displayQuestion,
      );

      if (!mounted) {
        return;
      }
      setState(() {
        _selectedBottomNavIndex = 0;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = _formatError(localisation, error);
      });
    } finally {
      if (mounted) {
        setState(() {
          _drawing = false;
        });
      }
    }
  }

  void _showSpreadGallery() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpreadGalleryPage(
          selectedSpread: _selectedSpread,
          onSpreadSelected: (spread) {
            setState(() {
              _selectedSpread = spread;
            });
          },
        ),
      ),
    );
  }

  void _enterFullScreenFlow() {
    _briefingAutoAdvanceTimer?.cancel();
    if (!mounted) {
      return;
    }
    setState(() {
      _fullScreenStep = FullScreenStep.spreadPresentation;
      _dealtCardCount = 0;
      _dealingCards = false;
      _revealedCardCount = 0;
      _revealingCards = false;
    });
  }

  void _exitFullScreenFlow({bool showInterpretation = false}) {
    _briefingAutoAdvanceTimer?.cancel();
    _briefingAutoAdvanceTimer = null;
    if (!mounted) {
      return;
    }
    setState(() {
      _fullScreenStep = null;
      if (showInterpretation) {
        _showInterpretation = true;
      }
    });
  }

  void _resetToHome() {
    _briefingAutoAdvanceTimer?.cancel();
    _briefingAutoAdvanceTimer = null;
    setState(() {
      _selectedBottomNavIndex = 0; // Set to Home tab
      _latestDraw = null;
      _latestInterpretation = null;
      _dealtCardCount = 0;
      _dealingCards = false;
      _revealedCardCount = 0;
      _revealingCards = false;
      _requestingInterpretation = false;
      _showInterpretation = false;
      _currentQuestion = null;
      _spreadRecommendationReason = null;
      _lastQuestionLocale = null;
      _displayQuestion = null;
      _fullScreenStep = null;
      _error = null;
    });
  }

  Future<void> _revealCardsSequentially() async {
    final draw = _latestDraw;
    if (draw == null || _revealingCards) {
      return;
    }
    setState(() {
      _revealingCards = true;
    });

    final totalCards = draw.result.length;
    const Duration flipDelay = Duration(milliseconds: 500);

    for (var i = 0; i < totalCards; i++) {
      if (!mounted) {
        return;
      }
      if (i > 0) {
        await Future.delayed(flipDelay);
      }
      if (!mounted) {
        return;
      }
      // Play card flip sound
      AudioService().playCardFlip();
      setState(() {
        _revealedCardCount = i + 1;
      });
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _revealingCards = false;
    });
  }

  Future<void> _requestInterpretation() async {
    if (_requestingInterpretation) {
      return;
    }
    final localisation = CommonStrings.of(context);
    final draw = _latestDraw;
    final sessionId = draw?.sessionId;
    if (draw == null || sessionId == null || sessionId.isEmpty) {
      return;
    }

    // If interpretation already loaded in background, just return
    if (_latestInterpretation != null) {
      return;
    }

    setState(() {
      _requestingInterpretation = true;
      _error = null;
    });

    try {
      final originalQuestion = _currentQuestion ?? '';
      final localeCode =
          _lastQuestionLocale ?? _resolveQuestionLocale(originalQuestion);
      final result = await submitInterpretation(
        sessionId: sessionId,
        draw: draw,
        question: originalQuestion.isEmpty ? null : originalQuestion,
        locale: localeCode,
      );
      _lastQuestionLocale = localeCode;
      if (!mounted) {
        return;
      }
      setState(() {
        _latestInterpretation = result;
      });
      await _refreshHistory();

      // Save conversation locally
      if (result != null) {
        await _saveConversationLocally(draw, result, originalQuestion);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = _formatError(localisation, error);
      });
    } finally {
      if (mounted) {
        setState(() {
          _requestingInterpretation = false;
        });
      }
    }
  }

  /// Pre-load interpretation in background without blocking UI
  Future<void> _preloadInterpretation(
    CardsDrawResponse draw,
    String question,
    String localeCode,
  ) async {
    final sessionId = draw.sessionId;
    if (sessionId == null || sessionId.isEmpty) {
      return;
    }

    try {
      final result = await submitInterpretation(
        sessionId: sessionId,
        draw: draw,
        question: question.isEmpty ? null : question,
        locale: localeCode,
      );

      // Only update if user hasn't already requested interpretation
      if (mounted && _latestInterpretation == null) {
        setState(() {
          _latestInterpretation = result;
        });

        // Save conversation locally
        if (result != null) {
          await _saveConversationLocally(draw, result, question);
        }
      }
    } catch (error) {
      // Don't show error to user since this is background operation
      // User can still request interpretation manually
    }
  }

  Future<void> _saveConversationLocally(
    CardsDrawResponse draw,
    InterpretationResult interpretation,
    String question,
  ) async {
    try {
      // Convert cards to JSON format
      final cardsJson = draw.result
          .map((card) => {
                'name': card.name,
                'suit': card.suit,
                'number': card.number,
                'upright': card.upright,
                'position': card.position,
              })
          .toList();

      await LocalStorageService.saveConversation(
        question: question.isEmpty ? 'No question' : question,
        spread: draw.spread,
        cards: cardsJson,
        interpretation: interpretation.interpretation,
        summary: interpretation.summary,
      );
    } catch (e) {
      debugPrint('Error saving conversation locally: $e');
    }
  }

  String _formatQuestionLabel(String question) {
    final trimmed = question.trim();
    if (trimmed.isEmpty) {
      return question;
    }
    final firstLetter = trimmed.substring(0, 1).toUpperCase();
    final rest = trimmed.substring(1);
    return '$firstLetter$rest';
  }

  String _generalConsultationPrompt(String locale) {
    final language = locale.split(RegExp('[_-]')).first.toLowerCase();
    switch (language) {
      case 'ca':
        return 'Consulta general: quÃ¨ necessito saber ara mateix per avanÃ§ar?';
      case 'es':
        return 'Consulta general: Â¿quÃ© necesito saber ahora mismo para avanzar?';
      case 'en':
        return 'General reading: what do I most need to understand right now?';
      default:
        return 'General reading: what guidance is most helpful right now?';
    }
  }

  String _generalConsultationLabel(String locale) {
    final language = locale.split(RegExp('[_-]')).first.toLowerCase();
    switch (language) {
      case 'ca':
      case 'es':
        return 'Consulta general';
      default:
        return 'General consultation';
    }
  }

  String _resolveQuestionLocale(String question) {
    final locale = Localizations.localeOf(context);
    final fallbackLanguage =
        _supportedQuestionLocales.contains(locale.languageCode)
            ? locale.languageCode
            : 'es';
    final trimmed = question.trim();
    if (trimmed.isEmpty) {
      return fallbackLanguage;
    }

    final detected = _detectLanguageCode(trimmed);
    if (detected != null && _supportedQuestionLocales.contains(detected)) {
      return detected;
    }
    return fallbackLanguage;
  }

  String? _detectLanguageCode(String text) {
    final lower = text.toLowerCase();

    final Map<String, int> scores = <String, int>{
      'ca': 0,
      'es': 0,
      'en': 0,
    };

    void addScore(String language, int value) {
      scores[language] = (scores[language] ?? 0) + value;
    }

    if (RegExp(r'[\u00F1\u00BF\u00A1]').hasMatch(lower)) {
      addScore('es', 4);
    }
    if (RegExp(r'[\u00E7\u00B7]').hasMatch(lower)) {
      addScore('ca', 4);
    }
    if (RegExp(
            r'\bperqu\u00E8\b|\bperque\b|\bqu\u00E8\b|\baquest[ae]s?\b|\baix[\u00F2o]\b|\bdoncs\b|\bvull\b|\bvosaltres\b|\bnostre\b|\bnostra\b')
        .hasMatch(lower)) {
      addScore('ca', 3);
    }
    if (RegExp(
            r'\bporque\b|\bqu\u00E9\b|\best[aeo]s?\b|\bma\u00F1ana\b|\bpareja\b|\btrabajo\b|\bdinero\b|\bnecesito\b|\bquiero\b|\bayuda\b')
        .hasMatch(lower)) {
      addScore('es', 3);
    }
    if (RegExp(
            r'\blove\b|\bcareer\b|\brelationship\b|\bhelp\b|\bneed\b|\bshould\b|\bwill\b|\bguidance\b|\bcards?\b|\bspread\b')
        .hasMatch(lower)) {
      addScore('en', 3);
    }
    if (RegExp(r'\bthe\b|\band\b|\bwill\b|\bshould\b|\bcan\b')
        .hasMatch(lower)) {
      addScore('en', 1);
    }

    final tokens = lower
        .split(RegExp(r'[^a-z\u00C0-\u00FF\u00B7]+'))
        .where((token) => token.isNotEmpty)
        .toList();

    for (final token in tokens) {
      if (_catalanPriorityTokens.contains(token)) {
        addScore('ca', 2);
      }
      if (_spanishPriorityTokens.contains(token)) {
        addScore('es', 2);
      }
      if (_englishPriorityTokens.contains(token)) {
        addScore('en', 2);
      }
    }

    if (tokens.isNotEmpty &&
        tokens.every((token) => RegExp(r'^[a-z]+$').hasMatch(token))) {
      if (RegExp(
              r'\b(what|when|where|who|why|how|is|are|do|does|can|should|would|could)\b')
          .hasMatch(lower)) {
        addScore('en', 2);
      }
    }

    final sorted = scores.entries.where((entry) => entry.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (sorted.isEmpty) {
      return null;
    }
    if (sorted.length > 1 && sorted[0].value == sorted[1].value) {
      return null;
    }
    return sorted.first.key;
  }

  String _formatError(CommonStrings localisation, Object error) {
    if (error is TimeoutException) {
      return localisation.networkError;
    }
    final raw = error.toString().trim();
    if (raw.isEmpty || raw == 'Exception') {
      return localisation.genericUnexpectedError;
    }
    if (raw.startsWith('Exception: ')) {
      final cleaned = raw.substring('Exception: '.length).trim();
      return cleaned.isEmpty ? localisation.genericUnexpectedError : cleaned;
    }
    if (raw.contains('SocketException') || raw.contains('NetworkException')) {
      return localisation.networkError;
    }
    return raw;
  }

  String _formatTimestamp(DateTime time) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(time.toLocal());
  }

  String _formatCardLabel(CardResult card, CommonStrings localisation) {
    final rawName = card.name.trim();
    final cardName = rawName.isEmpty
        ? localisation.unknownCardName
        : CardNameLocalizer.localize(rawName, localisation.localeName);
    final position = card.position + 1;
    final label = localisation.cardPositionLabel(cardName, position);
    if (!card.upright) {
      return '$label (${localisation.cardOrientationReversed})';
    }
    return label;
  }

  String? _getCardImagePath(CardResult card) {
    final name = card.name.trim();
    final suit = card.suit.trim();
    final number = card.number;

    // Major Arcana (0-21)
    final majorArcanaMap = {
      'The Fool': '00-TheFool',
      'The Magician': '01-TheMagician',
      'The High Priestess': '02-TheHighPriestess',
      'The Empress': '03-TheEmpress',
      'The Emperor': '04-TheEmperor',
      'The Hierophant': '05-TheHierophant',
      'The Lovers': '06-TheLovers',
      'The Chariot': '07-TheChariot',
      'Strength': '08-Strength',
      'The Hermit': '09-TheHermit',
      'Wheel of Fortune': '10-WheelOfFortune',
      'Justice': '11-Justice',
      'The Hanged Man': '12-TheHangedMan',
      'Death': '13-Death',
      'Temperance': '14-Temperance',
      'The Devil': '15-TheDevil',
      'The Tower': '16-TheTower',
      'The Star': '17-TheStar',
      'The Moon': '18-TheMoon',
      'The Sun': '19-TheSun',
      'Judgement': '20-Judgement',
      'The World': '21-TheWorld',
    };

    if (majorArcanaMap.containsKey(name)) {
      return 'assets/cards/${majorArcanaMap[name]}.jpg';
    }

    // Minor Arcana
    if (number != null && suit.isNotEmpty) {
      final suitPrefix =
          suit.substring(0, 1).toUpperCase() + suit.substring(1).toLowerCase();
      final numberStr = number.toString().padLeft(2, '0');
      return 'assets/cards/$suitPrefix$numberStr.jpg';
    }

    return null;
  }

  Widget _buildCardWidget(CardResult card, CommonStrings localisation) {
    final bool isReversed = !card.upright;
    final String? imagePath = _getCardImagePath(card);
    final cardName = _formatCardLabel(card, localisation);

    if (imagePath == null) {
      return Chip(label: Text(cardName));
    }

    final Widget cardFace = Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: Center(
            child: Icon(Icons.broken_image, color: Colors.grey[600]),
          ),
        );
      },
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 120,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: TarotTheme.blackOverlay20,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Transform.rotate(
                  angle: isReversed ? math.pi : 0,
                  child: cardFace,
                ),
                if (isReversed)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _buildMiniReversedBadge(),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 0),
        SizedBox(
          width: 120,
          child: Text(
            cardName,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniReversedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: TarotTheme.cosmicAccent90,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.visibility, size: 14, color: TarotTheme.deepNight),
          const SizedBox(width: 4),
          Text('REV',
              style: TextStyle(
                  color: TarotTheme.deepNight,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildDailyQuoteCard() {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return FutureBuilder<DailyQuote?>(
      future: _dailyQuoteFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }

        final quote = snapshot.data!;
        final text = quote.getText(locale);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                text,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: TarotTheme.cosmicBlue,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context, CommonStrings localisation) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionTile(
            icon: Icons.chat_bubble_outline,
            title: _qaText(localisation, en: 'Chat', es: 'Chat', ca: 'Xat'),
            onTap: () => _handleQuickActionChat(localisation),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _QuickActionTile(
            icon: Icons.archive_outlined,
            title: _qaText(localisation,
                en: 'Archive', es: 'Archivo', ca: 'Arxiu'),
            onTap: () => _handleQuickActionArchive(localisation),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _QuickActionTile(
            icon: Icons.auto_awesome_motion,
            title: _qaText(localisation,
                en: 'Spreads', es: 'Tiradas', ca: 'Tirades'),
            onTap: () => _handleQuickActionSpreads(localisation),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _QuickActionTile(
            icon: Icons.self_improvement,
            title: _qaText(localisation,
                en: 'Rituals', es: 'Rituales', ca: 'Rituals'),
            onTap: () => _handleQuickActionRituals(localisation),
          ),
        ),
      ],
    );
  }

  String _qaText(CommonStrings localisation,
      {required String en, required String es, required String ca}) {
    final language =
        localisation.localeName.split(RegExp('[_-]')).first.toLowerCase();
    switch (language) {
      case 'ca':
        return ca;
      case 'es':
        return es;
      default:
        return en;
    }
  }

  void _showQuickActionMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _handleQuickActionChat(CommonStrings localisation) {
    _showQuickActionMessage(
      _qaText(
        localisation,
        en: 'Chat mode is coming soon.',
        es: 'El modo chat llegarÃ¡ pronto.',
        ca: 'El mode xat arribarÃ  ben aviat.',
      ),
    );
  }

  void _handleQuickActionArchive(CommonStrings localisation) {
    setState(() {
      _selectedBottomNavIndex = 3;
    });
  }

  void _handleQuickActionSpreads(CommonStrings localisation) {
    setState(() {
      _selectedBottomNavIndex = 2;
    });
  }

  void _handleQuickActionRituals(CommonStrings localisation) {
    _showQuickActionMessage(
      _qaText(
        localisation,
        en: 'Guided rituals coming soon.',
        es: 'Rituales guiados prÃ³ximamente.',
        ca: 'Rituals guiats properament.',
      ),
    );
  }

  Widget _buildHeaderAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: Color(0xFF44385c).withValues(alpha: 0.6)),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: TarotTheme.stardust,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showLearnComingSoon(CommonStrings localisation) {
    _showQuickActionMessage(
      _qaText(
        localisation,
        en: 'Learning journeys coming soon.',
        es: 'Experiencias de aprendizaje proximamente.',
        ca: 'Experiencies d aprenentatge ben aviat.',
      ),
    );
  }

  void _openHeaderMenu(CommonStrings localisation) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _HeaderMenuItem(
                icon: Icons.person_outline,
                label: _qaText(localisation, en: 'Profile', es: 'Perfil', ca: 'Perfil'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _showQuickActionMessage(
                    _qaText(
                      localisation,
                      en: 'Profile coming soon.',
                      es: 'Perfil proximamente.',
                      ca: 'Perfil ben aviat.',
                    ),
                  );
                },
              ),
              _HeaderMenuItem(
                icon: Icons.notifications_none,
                label: _qaText(localisation, en: 'Notifications', es: 'Notificaciones', ca: 'Notificacions'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _showQuickActionMessage(
                    _qaText(
                      localisation,
                      en: 'Notifications coming soon.',
                      es: 'Notificaciones proximamente.',
                      ca: 'Notificacions ben aviat.',
                    ),
                  );
                },
              ),
              _HeaderMenuItem(
                icon: Icons.settings_outlined,
                label: _qaText(localisation, en: 'Settings', es: 'Ajustes', ca: 'Ajustos'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _showQuickActionMessage(
                    _qaText(
                      localisation,
                      en: 'Settings coming soon.',
                      es: 'Ajustes proximamente.',
                      ca: 'Ajustos ben aviat.',
                    ),
                  );
                },
              ),
              const Divider(height: 0),
              _HeaderMenuItem(
                icon: Icons.logout,
                label: _qaText(localisation, en: 'Sign out', es: 'Cerrar sesion', ca: 'Tancar sessio'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  try {
                    await Supabase.instance.client.auth.signOut();
                  } catch (_) {
                    if (!mounted) {
                      return;
                    }
                    _showQuickActionMessage(
                      _qaText(
                        localisation,
                        en: 'Unable to sign out.',
                        es: 'No se pudo cerrar sesion.',
                        ca: 'No s ha pogut tancar la sessio.',
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showSettingsDialog(CommonStrings localisation) {
    _showQuickActionMessage(
      _qaText(
        localisation,
        en: 'Settings coming soon.',
        es: 'Ajustes prÃ³ximamente.',
        ca: 'Ajustos properament.',
      ),
    );
  }

  Widget _buildLatestDrawCard(CommonStrings localisation) {
    final draw = _latestDraw;
    if (draw == null) {
      return const SizedBox.shrink();
    }

    final displayQuestion = _currentDisplayQuestion(localisation);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCardsMessage(draw, localisation, displayQuestion),
      ],
    );
  }

  Future<void> _handleStartDealing() async {
    if (_fullScreenStep != FullScreenStep.spreadPresentation) {
      return;
    }
    setState(() {
      _fullScreenStep = FullScreenStep.dealing;
      _dealtCardCount = 0;
      _dealingCards = true;
    });

    // Start card-by-card dealing with dynamic timing
    await _dealCardsSequentially();

    // After dealing completes, stay in dealing step
    // User must press "Reveal Cards" button to continue
  }

  Future<void> _handleRevealCards() async {
    if (_fullScreenStep != FullScreenStep.dealing) {
      return;
    }

    // Move to revealed step
    setState(() {
      _fullScreenStep = FullScreenStep.revealed;
    });
  }

  Future<void> _handleFullScreenInterpretationRequest() async {
    if (_fullScreenStep != FullScreenStep.interpretation) {
      setState(() {
        _fullScreenStep = FullScreenStep.interpretation;
      });
    }
    await _requestInterpretation();
  }

  Future<void> _dealCardsSequentially() async {
    final totalCards = _latestDraw?.result.length ?? 0;
    if (totalCards == 0) return;

    // Dynamic timing based on card count
    // User requested: more time for fewer cards, less time for more cards
    Duration delayPerCard;
    if (totalCards <= 5) {
      delayPerCard = const Duration(seconds: 1); // 3-5 cards: 1.0s each
    } else if (totalCards <= 7) {
      delayPerCard = const Duration(milliseconds: 600); // 6-7 cards: 0.6s each
    } else if (totalCards <= 10) {
      delayPerCard = const Duration(milliseconds: 400); // 8-10 cards: 0.4s each
    } else {
      delayPerCard = const Duration(milliseconds: 300); // 10+ cards: 0.3s each
    }

    // Deal cards one by one
    for (int i = 0; i < totalCards; i++) {
      await Future.delayed(delayPerCard);
      if (!mounted) return;
      setState(() {
        _dealtCardCount = i + 1;
      });
    }

    setState(() {
      _dealingCards = false;
    });
  }

  void _handleShowInterpretationView() {
    setState(() {
      _fullScreenStep = FullScreenStep.interpretation;
    });
  }

  void _closeFullScreenFlow() {
    _exitFullScreenFlow(showInterpretation: _latestInterpretation != null);
  }

  String _currentDisplayQuestion(CommonStrings localisation) {
    if (_displayQuestion != null && _displayQuestion!.trim().isNotEmpty) {
      return _displayQuestion!.trim();
    }
    if (_currentQuestion != null && _currentQuestion!.isNotEmpty) {
      return _formatQuestionLabel(_currentQuestion!);
    }
    return _generalConsultationLabel(localisation.localeName);
  }

  Widget _buildCardsMessage(
      CardsDrawResponse draw, CommonStrings localisation, String question) {
    final theme = Theme.of(context);
    final interpretation = _latestInterpretation;
    final accentColor = TarotTheme.cosmicBlue; // Corporate blue
    final int totalCards = draw.result.length;
    final bool allCardsRevealed = _revealedCardCount >= totalCards;

    return Card(
      color: TarotTheme.midnightBlue70,
      child: Column(
        children: [
          // Question header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: TarotTheme.midnightBlue,
              gradient: LinearGradient(
                colors: [
                  accentColor.withValues(alpha: 0.12),
                  accentColor.withValues(alpha: 0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(
                bottom: BorderSide(
                  color: TarotTheme.twilightPurpleFaint,
                  width: 1,
                ),
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.question_answer_outlined,
                  size: 20,
                  color: accentColor,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    question,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          // Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                    height: 8), // Extra spacing after question header
                // Show spread info always (not just when placeholders are visible)
                Builder(
                  builder: (context) {
                    final spread = TarotSpreads.getById(draw.spread) ??
                        TarotSpreads.threeCard;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: TarotTheme.midnightBlue,
                        gradient: LinearGradient(
                          colors: [
                            TarotTheme.cosmicAccent15,
                            TarotTheme.cosmicAccent08,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: TarotTheme.twilightPurpleFaint,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            spread.localizedName(localisation.localeName),
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: TarotTheme.cosmicAccent,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _spreadRecommendationReason ??
                                spread.localizedDescription(
                                    localisation.localeName),
                            style: TextStyle(
                              fontSize: 14,
                              color: TarotTheme.moonlight,
                              height: 1.6,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Get the selected spread or use threeCard as fallback
                    final spread = TarotSpreads.getById(draw.spread) ??
                        TarotSpreads.threeCard;

                    // Convert CardResult to TarotCard
                    final tarotCards = draw.result.map((card) {
                      final imagePath = _getCardImagePath(card);
                      return TarotCard.fromCardResult(card,
                          imagePath: imagePath);
                    }).toList();

                    final dealCount =
                        math.max(0, math.min(_dealtCardCount, totalCards));
                    final revealCount =
                        math.max(0, math.min(_revealedCardCount, totalCards));

                    final double spreadMaxHeight =
                        spread.id == 'celtic_cross' ? 660 : 500;

                    return Center(
                      child: SpreadLayout(
                        spread: spread,
                        cards: tarotCards,
                        maxWidth: constraints.maxWidth,
                        maxHeight: spreadMaxHeight,
                        dealtCardCount: dealCount,
                        revealedCardCount: revealCount,
                        locale: localisation.localeName,
                      ),
                    );
                  },
                ),
                // Phase-based buttons with colors and icons
                const SizedBox(height: 16),
                // Phase 1: Deal cards (Repartir)
                if (_dealtCardCount == 0 && !_dealingCards) ...[
                  FilledButton.icon(
                    onPressed: _dealCardsSequentially,
                    style: FilledButton.styleFrom(
                      backgroundColor: TarotTheme.cosmicAccent,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor:
                          TarotTheme.cosmicAccent.withValues(alpha: 0.4),
                    ),
                    icon: const Icon(Icons.style, size: 20),
                    label: const Text('Repartir'),
                  ),
                ]
                // Phase 1: Dealing in progress
                else if (_dealingCards) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: CircularProgressIndicator(),
                  ),
                ]
                // Phase 2: Reveal cards (Revelar)
                else if (_dealtCardCount > 0 &&
                    _revealedCardCount == 0 &&
                    !_revealingCards) ...[
                  FilledButton.icon(
                    onPressed: _revealCardsSequentially,
                    style: FilledButton.styleFrom(
                      backgroundColor: TarotTheme.cosmicAccent,
                      foregroundColor: TarotTheme.moonlight,
                    ),
                    icon: const Icon(Icons.visibility, size: 20),
                    label: const Text('Revelar'),
                  ),
                ]
                // Phase 2: Revealing in progress
                else if (_revealingCards) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: CircularProgressIndicator(),
                  ),
                ],
                // Phase 3: Request interpretation (Interpretar)
                // Show "Interpretar" button when cards revealed and interpretation not shown yet
                if (allCardsRevealed &&
                    draw.sessionId != null &&
                    draw.sessionId!.isNotEmpty &&
                    !_showInterpretation) ...[
                  if (_requestingInterpretation)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: CircularProgressIndicator(),
                    )
                  else
                    FilledButton.icon(
                      onPressed: () {
                        if (interpretation == null) {
                          _requestInterpretation();
                        }
                        setState(() {
                          _showInterpretation = true;
                        });
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: TarotTheme.cosmicAccent,
                        foregroundColor: TarotTheme.moonlight,
                      ),
                      icon: const Icon(Icons.auto_stories_outlined, size: 20),
                      label: const Text('Interpretar'),
                    ),
                ]
                // Phase 4: Show interpretation content when button clicked
                else if (allCardsRevealed &&
                    draw.sessionId != null &&
                    draw.sessionId!.isNotEmpty &&
                    _showInterpretation) ...[
                  const SizedBox(height: 12),
                  Builder(
                    builder: (context) {
                      String? interpretationSummary;
                      List<Map<String, dynamic>>? interpretationSections;
                      Map<String, dynamic>? interpretationSynthesis;
                      Map<String, dynamic>? interpretationGuide;

                      if (interpretation != null) {
                        final cardImages = _buildInterpretationCardImageLookup(
                          draw.result,
                          localisation,
                        );
                        final parsedInterpretation =
                            _parseInterpretationSections(
                          interpretation.interpretation,
                          cardImages,
                          localisation,
                        );

                        final providedSummary = interpretation.summary?.trim();
                        final parsedSummary =
                            (parsedInterpretation['summary'] as String?)
                                ?.trim();

                        if (providedSummary != null &&
                            providedSummary.isNotEmpty) {
                          interpretationSummary = providedSummary;
                        } else if (parsedSummary != null &&
                            parsedSummary.isNotEmpty) {
                          interpretationSummary = parsedSummary;
                        }

                        interpretationSections =
                            List<Map<String, dynamic>>.from(
                          (parsedInterpretation['cardSections'] as List).map(
                              (section) =>
                                  Map<String, dynamic>.from(section as Map)),
                        );

                        interpretationSynthesis =
                            parsedInterpretation['synthesis']
                                as Map<String, dynamic>?;

                        interpretationGuide = parsedInterpretation['guide']
                            as Map<String, dynamic>?;
                      }

                      // Show interpretation header bubble and content
                      return Column(
                        children: [
                          // Interpretation header bubble
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: TarotTheme.midnightBlue,
                              gradient: LinearGradient(
                                colors: [
                                  TarotTheme.cosmicAccent
                                      .withValues(alpha: 0.15),
                                  TarotTheme.cosmicAccent
                                      .withValues(alpha: 0.08),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: TarotTheme.twilightPurpleFaint,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.auto_stories_outlined,
                                      color: TarotTheme.cosmicAccent,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'InterpretaciÃ³n',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: TarotTheme.cosmicAccent,
                                          letterSpacing: 0.3,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                    if (_requestingInterpretation)
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            TarotTheme.cosmicAccent,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                if (interpretationSummary != null &&
                                    interpretationSummary.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    interpretationSummary,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: TarotTheme.moonlight,
                                      height: 1.6,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // Interpretation content
                          if (interpretation != null) ...[
                            const SizedBox(height: 16),
                            _buildInterpretationContent(
                              interpretation,
                              theme,
                              accentColor,
                              draw.result,
                              localisation,
                              precomputedSections: interpretationSections,
                              precomputedSynthesis: interpretationSynthesis,
                              precomputedGuide: interpretationGuide,
                            ),
                          ] else if (_requestingInterpretation) ...[
                            const SizedBox(height: 16),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> _buildInterpretationCardImageLookup(
    List<CardResult> cards,
    CommonStrings localisation,
  ) {
    final cardImages = <String, String>{};
    for (final card in cards) {
      final imagePath = CardImageMapper.getCardImagePath(card.name, card.suit);
      final originalLower = card.name.toLowerCase();
      final localizedKey =
          CardNameLocalizer.localize(card.name, localisation.localeName)
              .toLowerCase();

      cardImages[originalLower] = imagePath;
      cardImages[localizedKey] = imagePath;

      final withoutThe = originalLower.replaceFirst(RegExp(r'^the\s+'), '');
      if (withoutThe != originalLower) {
        cardImages[withoutThe] = imagePath;
      }

      final withoutArticle = localizedKey.replaceFirst(
          RegExp(r'^(el|la|els|les|the)\s+', caseSensitive: false), '');
      if (withoutArticle != localizedKey) {
        cardImages[withoutArticle] = imagePath;
      }
    }

    return cardImages;
  }

  Widget _buildInterpretationContent(
      InterpretationResult interpretation,
      ThemeData theme,
      Color accentColor,
      List<CardResult> cards,
      CommonStrings localisation,
      {List<Map<String, dynamic>>? precomputedSections,
      Map<String, dynamic>? precomputedSynthesis,
      Map<String, dynamic>? precomputedGuide}) {
    final parsed = _parseInterpretationSections(
      interpretation.interpretation,
      _buildInterpretationCardImageLookup(cards, localisation),
      localisation,
    );

    final List<Map<String, dynamic>> cardSections = precomputedSections ??
        List<Map<String, dynamic>>.from(
          (parsed['cardSections'] as List)
              .map((section) => Map<String, dynamic>.from(section as Map)),
        );

    final Map<String, dynamic>? synthesis =
        precomputedSynthesis ?? parsed['synthesis'] as Map<String, dynamic>?;

    final Map<String, dynamic>? guide =
        precomputedGuide ?? parsed['guide'] as Map<String, dynamic>?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Individual card interpretation bubbles
        ...cardSections.asMap().entries.map((entry) {
          final index = entry.key;
          final section = entry.value;
          return Column(
            children: [
              _buildCardInterpretationBubble(section, localisation, theme),
              if (index < cardSections.length - 1) const SizedBox(height: 12),
            ],
          );
        }),

        // SÃ­ntesis section (if present)
        if (synthesis != null) ...[
          const SizedBox(height: 12),
          _buildSpecialSectionBubble(
            synthesis['sectionName'] as String,
            synthesis['sectionText'] as String,
            Icons.check_circle_outline,
            theme,
          ),
        ],

        // GuÃ­a section (if present)
        if (guide != null) ...[
          const SizedBox(height: 12),
          _buildSpecialSectionBubble(
            guide['sectionName'] as String,
            guide['sectionText'] as String,
            Icons.lightbulb_outline,
            theme,
          ),
        ],

        const SizedBox(height: 16),
      ],
    );
  }

  /// Build a styled bubble for a single card interpretation
  /// Build text with an inline image that keeps flowing beneath it
  Widget _buildTextWithFloatedImage({
    required String cardImage,
    required bool isReversed,
    required String interpretationText,
  }) {
    // Capitalize first letter of text
    final capitalizedText = interpretationText.isNotEmpty
        ? interpretationText[0].toUpperCase() + interpretationText.substring(1)
        : interpretationText;

    const imageWidth = 62.0;
    const imageHeight = 108.0;
    const gap = 12.0;

    final textStyle = TextStyle(
      fontSize: 15,
      color: TarotTheme.moonlight,
      height: 1.6,
      letterSpacing: 0.2,
    );

    final imageWidget = Container(
      width: imageWidth,
      height: imageHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: TarotTheme.blackOverlay30,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Transform(
          alignment: Alignment.center,
          transform: isReversed
              ? (Matrix4.identity()..rotateZ(math.pi))
              : Matrix4.identity(),
          child: Image.asset(
            cardImage,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: TarotTheme.cosmicPurple,
                child: Icon(
                  Icons.image_not_supported,
                  color: TarotTheme.stardust,
                  size: 30,
                ),
              );
            },
          ),
        ),
      ),
    );

    return RichText(
      text: TextSpan(
        style: textStyle,
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.top,
            child: Padding(
              padding: const EdgeInsets.only(right: gap, bottom: 6),
              child: imageWidget,
            ),
          ),
          TextSpan(text: capitalizedText),
        ],
      ),
    );
  }

  Widget _buildCardInterpretationBubble(
    Map<String, dynamic> section,
    CommonStrings localisation,
    ThemeData theme,
  ) {
    final String cardName = section['cardName'];
    final String? cardImage = section['cardImage'];
    final bool isReversed = section['isReversed'];
    final String interpretationText = section['interpretationText'];

    // Check if this is a special section (ConclusiÃ³n, Consejo, etc.)
    final lowercardName = cardName.toLowerCase();
    final isSpecialSection = lowercardName.contains('conclusi') ||
        lowercardName.contains('consejo') ||
        lowercardName.contains('consell');

    // For special sections, use section name directly; for cards, localize
    final displayName = isSpecialSection
        ? cardName
        : () {
            final localizedCardName =
                CardNameLocalizer.localize(cardName, localisation.localeName);
            return isReversed
                ? '$localizedCardName (${localisation.cardOrientationReversed})'
                : localizedCardName;
          }();

    // Choose icon based on section type
    final IconData sectionIcon = isSpecialSection
        ? (lowercardName.contains('conclusi')
            ? Icons.check_circle_outline
            : Icons.lightbulb_outline)
        : Icons.style; // Card-related icon for tarot cards

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TarotTheme.midnightBlue,
        gradient: LinearGradient(
          colors: [
            TarotTheme.cosmicAccent.withValues(alpha: 0.15),
            TarotTheme.cosmicAccent.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TarotTheme.twilightPurpleFaint,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon + Card Name or Section Name
          Row(
            children: [
              Icon(
                sectionIcon,
                color: TarotTheme.cosmicAccent,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: TarotTheme.cosmicAccent,
                    letterSpacing: 0.3,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Body: Card Image (floated left) + Interpretation Text (wrapping around)
          if (!isSpecialSection && cardImage != null)
            // Newspaper-style layout: image on left, text wraps around
            _buildTextWithFloatedImage(
              cardImage: cardImage,
              isReversed: isReversed,
              interpretationText: interpretationText,
            )
          else
            // No image: just show text (for special sections or missing images)
            Text(
              interpretationText,
              style: TextStyle(
                fontSize: 15,
                color: TarotTheme.moonlight,
                height: 1.6,
                letterSpacing: 0.2,
              ),
            ),
        ],
      ),
    );
  }

  /// Build a styled bubble for special sections (SÃ­ntesis, GuÃ­a)
  Widget _buildSpecialSectionBubble(
    String sectionName,
    String sectionText,
    IconData icon,
    ThemeData theme,
  ) {
    // Capitalize first letter of text
    final capitalizedText = sectionText.isNotEmpty
        ? sectionText[0].toUpperCase() + sectionText.substring(1)
        : sectionText;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TarotTheme.midnightBlue,
        gradient: LinearGradient(
          colors: [
            TarotTheme.cosmicAccent.withValues(alpha: 0.15),
            TarotTheme.cosmicAccent.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TarotTheme.twilightPurpleFaint,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon + Section Name
          Row(
            children: [
              Icon(
                icon,
                color: TarotTheme.cosmicAccent,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  sectionName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: TarotTheme.cosmicAccent,
                    letterSpacing: 0.3,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Body: Section Text
          Text(
            capitalizedText,
            style: TextStyle(
              fontSize: 15,
              color: TarotTheme.moonlight,
              height: 1.6,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  /// Parse interpretation into summary, card sections, and special sections
  Map<String, dynamic> _parseInterpretationSections(
    String markdown,
    Map<String, String> cardImages,
    CommonStrings localisation,
  ) {
    // Pattern: **ðŸƒ Card Name** or **Card Name**
    final cardReferencePattern = RegExp(r'\*\*(.+?)\*\*');
    final matches = cardReferencePattern.allMatches(markdown).toList();

    if (matches.isEmpty) {
      // No cards found, everything is summary
      return {
        'summary': markdown,
        'cardSections': <Map<String, dynamic>>[],
        'synthesis': null,
        'guide': null,
      };
    }

    // Extract summary (text before first card)
    final firstCardStart = matches.first.start;
    final summary =
        firstCardStart > 0 ? markdown.substring(0, firstCardStart).trim() : '';

    // Extract card sections and special sections
    final List<Map<String, dynamic>> cardSections = [];
    Map<String, dynamic>? synthesis;
    Map<String, dynamic>? guide;

    for (int i = 0; i < matches.length; i++) {
      final match = matches[i];
      final fullCardName = match.group(1)!.trim();

      // Extract text after this card until next card (or end)
      final textStart = match.end;
      final textEnd =
          (i + 1 < matches.length) ? matches[i + 1].start : markdown.length;
      final interpretationText = markdown.substring(textStart, textEnd).trim();

      // Skip if this looks like it's just markdown bold, not a card
      // (card names typically have emojis or are proper nouns)
      if (interpretationText.isEmpty && fullCardName.length < 5) {
        continue;
      }

      // Process card name
      final loweredName = fullCardName.toLowerCase();
      final isReversed = loweredName.contains('(reversed)') ||
          loweredName.contains('(invertida)') ||
          loweredName.contains('(invertit)') ||
          loweredName.contains('reverso') ||
          loweredName.contains('invertida') ||
          loweredName.contains('invertit');

      final cardName = fullCardName
          .replaceAll(RegExp(r'[\u{1F000}-\u{1F9FF}]', unicode: true), '')
          .replaceAll(RegExp(r'\s*\(reversed\)', caseSensitive: false), '')
          .replaceAll(RegExp(r'\s*\(invertida\)', caseSensitive: false), '')
          .replaceAll(RegExp(r'\s*\(invertit\)', caseSensitive: false), '')
          .replaceAll(RegExp(r'\s*reverso\s*', caseSensitive: false), '')
          .replaceAll(RegExp(r'\s*invertida\s*', caseSensitive: false), '')
          .replaceAll(RegExp(r'\s*invertit\s*', caseSensitive: false), '')
          .trim();

      // Check if this is a special section (SÃ­ntesis or GuÃ­a)
      final isSpecialSection = loweredName.contains('sÃ­ntesi') ||
          loweredName.contains('sÃ­ntesis') ||
          loweredName.contains('guÃ­a') ||
          loweredName.contains('guia');

      if (isSpecialSection) {
        // Store as special section
        final sectionData = {
          'sectionName': cardName,
          'sectionText': interpretationText,
        };

        if (loweredName.contains('sÃ­ntesi') ||
            loweredName.contains('sÃ­ntesis')) {
          synthesis = sectionData;
        } else if (loweredName.contains('guÃ­a') ||
            loweredName.contains('guia')) {
          guide = sectionData;
        }
        continue; // Don't add to card sections
      }

      // Find card image
      final lookupKey = cardName.toLowerCase();
      String? cardImage = cardImages[lookupKey];

      if (cardImage == null) {
        final localizedCardName =
            CardNameLocalizer.localize(cardName, localisation.localeName);
        cardImage = cardImages[localizedCardName.toLowerCase()];
      }

      if (cardImage == null) {
        final withoutArticle = lookupKey.replaceFirst(
            RegExp(r'^(the|el|la|els|les)\s+', caseSensitive: false), '');
        cardImage = cardImages[withoutArticle];
      }

      cardSections.add({
        'cardName': cardName,
        'cardImage': cardImage,
        'isReversed': isReversed,
        'interpretationText': interpretationText,
      });
    }

    return {
      'summary': summary,
      'cardSections': cardSections,
      'synthesis': synthesis,
      'guide': guide,
    };
  }

  MarkdownStyleSheet _getMarkdownStyleSheet(
      ThemeData theme, Color accentColor) {
    return MarkdownStyleSheet(
      p: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface,
        height: 1.5,
        letterSpacing: 0.2,
      ),
      strong: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.bold,
        height: 1.5,
      ),
      em: theme.textTheme.bodyMedium?.copyWith(
        color: accentColor.withValues(alpha: 0.9),
        fontStyle: FontStyle.italic,
        height: 1.5,
      ),
      h1: theme.textTheme.titleLarge?.copyWith(
        color: accentColor,
        fontWeight: FontWeight.bold,
      ),
      h2: theme.textTheme.titleMedium?.copyWith(
        color: accentColor,
        fontWeight: FontWeight.bold,
      ),
      h3: theme.textTheme.titleSmall?.copyWith(
        color: accentColor,
        fontWeight: FontWeight.bold,
      ),
      blockSpacing: 8.0,
      listBullet: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localisation = CommonStrings.of(context);
    final hasDraw = _latestDraw != null;
    final mediaQuery = MediaQuery.of(context);
    const double extraBottomPadding = 8.0;
    final bottomSafeInset =
        math.max(mediaQuery.viewPadding.bottom, mediaQuery.padding.bottom);
    final bottomSpacing = bottomSafeInset + extraBottomPadding;
    const double topSpacing =
        12.0; // Reduced from 32.0 for less space below AppBar

    // Build content based on selected tab and draw state
    Widget bodyContent;
    Widget? fullScreenOverlay;

    if (_initialising) {
      bodyContent = const Center(child: CircularProgressIndicator());
    } else if (_selectedBottomNavIndex == 0) {
      // Today screen - always show home content with Daily Draw
      bodyContent = _buildTodayScreen(localisation, topSpacing);
    } else if (_selectedBottomNavIndex == 1 && _userId != null && _userId!.isNotEmpty) {
      // Chat screen (shown inside main scaffold, no app bar)
      bodyContent = ChatScreen(
        userId: _userId!,
        strings: localisation,
        showAppBar: false,
      );
    } else if (_selectedBottomNavIndex == 2) {
      bodyContent = SpreadsScreen(
        strings: localisation,
        selectedSpread: _selectedSpread,
        generalPrompt: _generalConsultationPrompt(localisation.localeName),
        generalLabel: _generalConsultationLabel(localisation.localeName),
        onSelectSpread: (spread) {
          setState(() {
            _selectedSpread = spread;
          });
        },
        onStartTheme: ({
          required theme,
          required spread,
          String? question,
          String? displayLabel,
        }) {
          _startThemeConsultation(
            theme: theme,
            spread: spread,
            question: question,
            displayLabel: displayLabel,
          );
        },
        onOpenGallery: _showSpreadGallery,
      );
    } else if (_selectedBottomNavIndex == 3) {
      // Archive/Journal screen
      final userId = _userId ?? '';
      final locale = localisation.localeName;
      bodyContent = ArchiveScreen(userId: userId, locale: locale);
    } else if (_selectedBottomNavIndex == 4) {
      bodyContent = LearnScreen(
        strings: localisation,
        onNavigateToCards: () => _showLearnComingSoon(localisation),
        onNavigateToKnowledge: () => _showLearnComingSoon(localisation),
        onNavigateToSpreads: () => _showLearnComingSoon(localisation),
        onNavigateToAstrology: () => _showLearnComingSoon(localisation),
        onNavigateToKabbalah: () => _showLearnComingSoon(localisation),
        onNavigateToMoonPowers: () => _showLearnComingSoon(localisation),
      );
    } else {
      // Fallback: should never happen but required for null safety
      bodyContent = _buildTodayScreen(localisation, topSpacing);
    }


    if (_fullScreenStep != null && _latestDraw != null) {
      final draw = _latestDraw!;
      final spread =
          TarotSpreads.getById(draw.spread) ?? TarotSpreads.threeCard;
      final cards = draw.result
          .map((card) => TarotCard.fromCardResult(
                card,
                imagePath: _getCardImagePath(card),
              ))
          .toList();
      Widget? interpretationContent;
      if (_latestInterpretation != null) {
        interpretationContent = _buildInterpretationContent(
          _latestInterpretation!,
          Theme.of(context),
          TarotTheme.cosmicBlue,
          draw.result,
          localisation,
        );
      }

      fullScreenOverlay = DrawFullScreenFlow(
        step: _fullScreenStep!,
        question: _currentDisplayQuestion(localisation),
        recommendation: _spreadRecommendationReason,
        interpretationGuide: _spreadInterpretationGuide,
        spread: spread,
        cards: cards,
        dealtCardCount: _dealtCardCount,
        dealingCards: _dealingCards,
        revealedCardCount: _revealedCardCount,
        revealingCards: _revealingCards,
        requestingInterpretation: _requestingInterpretation,
        interpretationAvailable: _latestInterpretation != null,
        interpretationContent: interpretationContent,
        localisation: localisation,
        onClose: _closeFullScreenFlow,
        onStartDealing: _handleStartDealing,
        onDeal: _dealCardsSequentially,
        onReveal: _handleRevealCards,
        onInterpret: _handleFullScreenInterpretationRequest,
        onShowInterpretation: _handleShowInterpretationView,
      );
    }

    return Scaffold(
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / 5;
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFEEEEEE),
                      width: 1,
                    ),
                  ),
                ),
                child: BottomNavigationBar(
          currentIndex: _selectedBottomNavIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF44385c),
          unselectedItemColor: const Color(0xFF44385c).withValues(alpha: 0.5),
          selectedFontSize: 13,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        onTap: (index) {
          setState(() {
            _selectedBottomNavIndex = index;
          });

          switch (index) {
            case 0: // Home
              _resetToHome();
              break;
            case 1: // Chat
              final userId = _userId;
              if (userId == null || userId.isEmpty) {
                _showQuickActionMessage(
                  _qaText(
                    localisation,
                    en: 'Please log in to use chat.',
                    es: 'Por favor inicia sesiÃ³n para usar el chat.',
                    ca: 'Si us plau inicia sessiÃ³ per utilitzar el xat.',
                  ),
                );
              } else {
                setState(() {
                  _selectedBottomNavIndex = 1;
                });
              }
              break;
            case 2: // Spreads
              _handleQuickActionSpreads(localisation);
              break;
            case 3: // Archive
              _handleQuickActionArchive(localisation);
              break;
            case 4: // Learn
              setState(() {
                _selectedBottomNavIndex = 4;
              });
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.wb_sunny_outlined),
            activeIcon: const Icon(Icons.wb_sunny),
            label: _qaText(localisation, en: 'Today', es: 'Hoy', ca: 'Avui'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble_outline),
            activeIcon: const Icon(Icons.chat_bubble),
            label: _qaText(localisation, en: 'Chat', es: 'Chat', ca: 'Xat'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.auto_awesome_motion),
            activeIcon: const Icon(Icons.auto_awesome),
            label: _qaText(localisation, en: 'Spreads', es: 'Tiradas', ca: 'Tirades'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.archive_outlined),
            activeIcon: const Icon(Icons.archive),
            label: _qaText(localisation, en: 'Archive', es: 'Archivo', ca: 'Arxiu'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book_outlined),
            activeIcon: const Icon(Icons.menu_book),
            label: _qaText(localisation, en: 'Learn', es: 'Aprende', ca: 'Apren'),
          ),
        ],
        ),
      ),
              // Top indicator line (drawn on top)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                left: _selectedBottomNavIndex * itemWidth,
                top: 0,
                child: Container(
                  width: itemWidth,
                  height: 3,
                  alignment: Alignment.center,
                  child: Container(
                    width: itemWidth * 0.8,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Color(0xFF44385c),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      body: Stack(
        children: [
          // Simple flat white background
          Container(
            color: Colors.white, // Pure white
          ),
          // NestedScrollView with floating header
          NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  floating: true,
                  snap: true,
                  pinned: false,
                  forceElevated: innerBoxIsScrolled,
                  toolbarHeight: 48,
                  title: const SizedBox.shrink(),
                  leading: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedBottomNavIndex = 0;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.home,
                            color: _selectedBottomNavIndex == 0
                                ? const Color(0xFF44385c)
                                : const Color(0xFF44385c).withValues(alpha: 0.5),
                            size: 26,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'HOME',
                            style: TextStyle(
                              color: _selectedBottomNavIndex == 0
                                  ? const Color(0xFF44385c)
                                  : const Color(0xFF44385c).withValues(alpha: 0.5),
                              fontSize: _selectedBottomNavIndex == 0 ? 13 : 12,
                              fontWeight: _selectedBottomNavIndex == 0 ? FontWeight.w700 : FontWeight.w400,
                              letterSpacing: _selectedBottomNavIndex == 0 ? 0.2 : 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    ValueListenableBuilder<DailyCredits>(
                      valueListenable: _creditsNotifier,
                      builder: (context, credits, _) {
                        final creditLabel = _qaText(
                          localisation,
                          en: 'Credits',
                          es: 'Creditos',
                          ca: 'Credits',
                        );
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _CreditsWithProBadge(
                            credits: credits,
                            label: creditLabel,
                            onCreditsTap: () => _showCreditsInfoDialog(credits, localisation),
                            onProTap: () => _showGoProModal(localisation),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.menu, color: Color(0xFF44385c).withValues(alpha: 0.6), size: 22),
                      tooltip: _qaText(localisation, en: 'Menu', es: 'Menu', ca: 'Menu'),
                      onPressed: () => _openHeaderMenu(localisation),
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1),
                    child: Container(
                      color: Colors.grey.withValues(alpha: 0.2),
                      height: 1,
                    ),
                  ),
                ),
              ];
            },
            body: bodyContent,
          ),
          if (fullScreenOverlay != null)
            Positioned.fill(child: fullScreenOverlay),
        ],
      ),
    );
  }

  String _formatTodayDate(String locale) {
    final now = DateTime.now();

    switch (locale) {
      case 'ca':
        return DateFormat('d \'de\' MMMM', 'ca').format(now);
      case 'es':
        return DateFormat('d \'de\' MMMM', 'es').format(now);
      default:
        return DateFormat('MMMM d', 'en').format(now);
    }
  }

  void _showCreditsInfoDialog(DailyCredits credits, CommonStrings localisation) {
    final countdown = _timeUntilNextResetString(localisation.localeName);
    final title = _qaText(localisation, en: 'Daily credits', es: 'Creditos diarios', ca: 'Credits diaris');
    final message = _qaText(
      localisation,
      en: 'You can use ${credits.max} credits per day.\n${credits.remaining} left today.\nResets in $countdown.',
      es: 'Puedes usar ${credits.max} creditos al dia.\nTe quedan ${credits.remaining} hoy.\nSe reinicia en $countdown.',
      ca: 'Pots usar ${credits.max} credits al dia.\nEt queden ${credits.remaining} avui.\nEs reinicia en $countdown.',
    );

    if (!mounted) {
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(_qaText(localisation, en: 'Close', es: 'Cerrar', ca: 'Tancar')),
            ),
          ],
        );
      },
    );
  }

  void _showGoProModal(CommonStrings localisation) {
    final title = _qaText(
      localisation,
      en: 'Upgrade to PRO',
      es: 'Pasa a PRO',
      ca: 'Passa a PRO',
    );

    final subtitle = _qaText(
      localisation,
      en: 'Unlock unlimited access',
      es: 'Desbloquea acceso ilimitado',
      ca: 'Desbloqueja accés il·limitat',
    );

    final benefitsTitle = _qaText(
      localisation,
      en: 'PRO Benefits:',
      es: 'Beneficios PRO:',
      ca: 'Beneficis PRO:',
    );

    final benefit1 = _qaText(
      localisation,
      en: 'Unlimited daily credits',
      es: 'Créditos diarios ilimitados',
      ca: 'Crèdits diaris il·limitats',
    );

    final benefit2 = _qaText(
      localisation,
      en: 'Access to all spreads',
      es: 'Acceso a todas las tiradas',
      ca: 'Accés a totes les tirades',
    );

    final benefit3 = _qaText(
      localisation,
      en: 'Priority AI interpretations',
      es: 'Interpretaciones IA prioritarias',
      ca: 'Interpretacions IA prioritàries',
    );

    final benefit4 = _qaText(
      localisation,
      en: 'Ad-free experience',
      es: 'Experiencia sin anuncios',
      ca: 'Experiència sense anuncis',
    );

    final freeInfo = _qaText(
      localisation,
      en: 'Free: 5 credits per day',
      es: 'Gratis: 5 créditos al día',
      ca: 'Gratis: 5 crèdits al dia',
    );

    final upgradeButton = _qaText(
      localisation,
      en: 'Upgrade Now',
      es: 'Mejorar Ahora',
      ca: 'Millorar Ara',
    );

    final closeButton = _qaText(
      localisation,
      en: 'Maybe Later',
      es: 'Quizás Luego',
      ca: 'Potser Més Tard',
    );

    if (!mounted) {
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with gradient
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Benefits
              Text(
                benefitsTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: TarotTheme.cosmicAccent,
                ),
              ),
              const SizedBox(height: 12),
              _buildBenefit(Icons.all_inclusive, benefit1),
              _buildBenefit(Icons.auto_awesome, benefit2),
              _buildBenefit(Icons.bolt, benefit3),
              _buildBenefit(Icons.block, benefit4),
              const SizedBox(height: 16),
              // Free info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TarotTheme.cosmicAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 18, color: TarotTheme.cosmicAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        freeInfo,
                        style: const TextStyle(
                          fontSize: 13,
                          color: TarotTheme.cosmicAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                closeButton,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // TODO: Implement upgrade flow
                _showQuickActionMessage(
                  _qaText(
                    localisation,
                    en: 'Upgrade feature coming soon!',
                    es: '¡Función de mejora próximamente!',
                    ca: 'Funció de millora properament!',
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA500),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                upgradeButton,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBenefit(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFFFFA500)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayScreen(CommonStrings localisation, double topSpacing) {
    return ListView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: topSpacing,
        bottom: 16,
      ),
      children: [
        // Daily Draw Panel - always shown on Today screen
        if (_dailyCards != null && _dailyCards!.isNotEmpty)
          DailyDrawPanel(
            cards: _dailyCards!,
            strings: localisation,
            isLoading: _loadingDailyDraw,
            onInterpret: () {
              final response = _dailyDrawResponse;
              if (response == null || response.sessionId == null || response.sessionId!.isEmpty) {
                debugPrint('No session ID available for daily draw interpretation');
                return;
              }

              // Navigate to daily interpretation screen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DailyInterpretationScreen(
                    cards: _dailyCards!,
                    draw: response,
                    sessionId: response.sessionId!,
                  ),
                ),
              );
            },
          )
        else if (_loadingDailyDraw)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    localisation.lunarPanelLoading,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        if ((_dailyCards != null && _dailyCards!.isNotEmpty) || _loadingDailyDraw)
          const SizedBox(height: 24),
        // Unified Lunar Wisdom Center
        UnifiedLunarWidget(
          controller: _lunarController,
          strings: localisation,
          userId: _userId,
          onSelectSpread: (spreadId) {
            final spread = TarotSpreads.getById(spreadId);
            if (spread != null) {
              setState(() {
                _selectedSpread = spread;
                _selectedBottomNavIndex = 2;
              });
            }
          },
          onRefresh: () => _lunarController.refresh(force: true),
        ),
        const SizedBox(height: 24),
        // Ask the Moon Banner
        AskMoonBanner(
          strings: localisation,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LunarAdvisorScreen(
                  strings: localisation,
                  userId: _userId,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        // Smart Draws Panel
        SmartDrawsPanel(
          strings: localisation,
          onSmartSelection: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SmartSelectionScreen(),
              ),
            );
          },
          onLove: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SpreadsScreen(
                  strings: localisation,
                  selectedSpread: _selectedSpread,
                  generalPrompt: '',
                  generalLabel: 'Love',
                  initialTheme: 'love',
                  onSelectSpread: (spread) => setState(() => _selectedSpread = spread),
                  onStartTheme: ({
                    required theme,
                    required spread,
                    String? question,
                    String? displayLabel,
                  }) {
                    _startThemeConsultation(
                      theme: theme,
                      spread: spread,
                      question: question,
                      displayLabel: displayLabel,
                    );
                  },
                  onOpenGallery: _showSpreadGallery,
                ),
              ),
            );
          },
          onCareer: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SpreadsScreen(
                  strings: localisation,
                  selectedSpread: _selectedSpread,
                  generalPrompt: '',
                  generalLabel: 'Career',
                  initialTheme: 'career',
                  onSelectSpread: (spread) => setState(() => _selectedSpread = spread),
                  onStartTheme: ({
                    required theme,
                    required spread,
                    String? question,
                    String? displayLabel,
                  }) {
                    _startThemeConsultation(
                      theme: theme,
                      spread: spread,
                      question: question,
                      displayLabel: displayLabel,
                    );
                  },
                  onOpenGallery: _showSpreadGallery,
                ),
              ),
            );
          },
          onFinances: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SpreadsScreen(
                  strings: localisation,
                  selectedSpread: _selectedSpread,
                  generalPrompt: '',
                  generalLabel: 'Money',
                  initialTheme: 'money',
                  onSelectSpread: (spread) => setState(() => _selectedSpread = spread),
                  onStartTheme: ({
                    required theme,
                    required spread,
                    String? question,
                    String? displayLabel,
                  }) {
                    _startThemeConsultation(
                      theme: theme,
                      spread: spread,
                      question: question,
                      displayLabel: displayLabel,
                    );
                  },
                  onOpenGallery: _showSpreadGallery,
                ),
              ),
            );
          },
          onPersonalGrowth: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SpreadsScreen(
                  strings: localisation,
                  selectedSpread: _selectedSpread,
                  generalPrompt: '',
                  generalLabel: 'Personal Growth',
                  initialTheme: 'wellbeing',
                  onSelectSpread: (spread) => setState(() => _selectedSpread = spread),
                  onStartTheme: ({
                    required theme,
                    required spread,
                    String? question,
                    String? displayLabel,
                  }) {
                    _startThemeConsultation(
                      theme: theme,
                      spread: spread,
                      question: question,
                      displayLabel: displayLabel,
                    );
                  },
                  onOpenGallery: _showSpreadGallery,
                ),
              ),
            );
          },
          onDecisions: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SpreadsScreen(
                  strings: localisation,
                  selectedSpread: _selectedSpread,
                  generalPrompt: '',
                  generalLabel: 'Decisions',
                  initialTheme: 'decisions',
                  onSelectSpread: (spread) => setState(() => _selectedSpread = spread),
                  onStartTheme: ({
                    required theme,
                    required spread,
                    String? question,
                    String? displayLabel,
                  }) {
                    _startThemeConsultation(
                      theme: theme,
                      spread: spread,
                      question: question,
                      displayLabel: displayLabel,
                    );
                  },
                  onOpenGallery: _showSpreadGallery,
                ),
              ),
            );
          },
          onGeneral: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SpreadsScreen(
                  strings: localisation,
                  selectedSpread: _selectedSpread,
                  generalPrompt: '',
                  generalLabel: 'General',
                  initialTheme: 'ai_auto',
                  onSelectSpread: (spread) => setState(() => _selectedSpread = spread),
                  onStartTheme: ({
                    required theme,
                    required spread,
                    String? question,
                    String? displayLabel,
                  }) {
                    _startThemeConsultation(
                      theme: theme,
                      spread: spread,
                      question: question,
                      displayLabel: displayLabel,
                    );
                  },
                  onOpenGallery: _showSpreadGallery,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        // Chat Banner
        ChatBanner(
          strings: localisation,
          onTap: () {
            final userId = _userId;
            if (userId == null || userId.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _qaText(
                      localisation,
                      en: 'Please log in to use chat.',
                      es: 'Por favor inicia sesión para usar el chat.',
                      ca: 'Si us plau inicia sessió per utilitzar el xat.',
                    ),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            } else {
              setState(() {
                _selectedBottomNavIndex = 1;
              });
            }
          },
        ),
        const SizedBox(height: 24),
        // Learn Panel
        LearnPanel(
          strings: localisation,
          onNavigateToCards: () => _showLearnComingSoon(localisation),
          onNavigateToKnowledge: () => _showLearnComingSoon(localisation),
          onNavigateToSpreads: () => _showLearnComingSoon(localisation),
          onNavigateToAstrology: () => _showLearnComingSoon(localisation),
          onNavigateToKabbalah: () => _showLearnComingSoon(localisation),
          onNavigateToMoonPowers: () => _showLearnComingSoon(localisation),
        ),
        const SizedBox(height: 24),
        // Archive Banner
        ArchiveBanner(
          strings: localisation,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ArchiveScreen(
                  userId: _userId ?? '',
                ),
              ),
            );
          },
        ),
        if (_error != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  String _timeUntilNextResetString(String locale) {
    final duration = _timeUntilNextReset();
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '$hours h ${minutes} m';
  }

  Duration _timeUntilNextReset() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    return nextMidnight.difference(now);
  }
}

// Custom painter for starry night background
class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: TarotTheme.cosmicBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StarryNightPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final random = math.Random(42); // Fixed seed for consistent stars

    // Draw stars
    for (int i = 0; i < 80; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.2 + 0.3;
      final opacity = random.nextDouble() * 0.4 + 0.2;

      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw a few brighter stars
    for (int i = 0; i < 15; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.8 + 0.8;
      final opacity = random.nextDouble() * 0.3 + 0.5;

      paint.color = TarotTheme.cosmicAccent.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);

      // Add a subtle glow
      paint.color = TarotTheme.cosmicAccent.withValues(alpha: opacity * 0.3);
      canvas.drawCircle(Offset(x, y), radius * 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CreditsBadge extends StatelessWidget {
  const _CreditsBadge({
    required this.credits,
    required this.label,
    required this.onTap,
  });

  final DailyCredits credits;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.diamond, color: Color(0xFF44385c).withValues(alpha: 0.6), size: 20),
          const SizedBox(width: 6),
          Text(
            '${credits.remaining}',
            style: TextStyle(
              color: Color(0xFF44385c).withValues(alpha: 0.6),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderMenuItem extends StatelessWidget {
  const _HeaderMenuItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF44385c).withValues(alpha: 0.6)),
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: TarotTheme.midnightBlue,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _CreditsWithProBadge extends StatelessWidget {
  const _CreditsWithProBadge({
    required this.credits,
    required this.label,
    required this.onCreditsTap,
    required this.onProTap,
  });

  final DailyCredits credits;
  final String label;
  final VoidCallback onCreditsTap;
  final VoidCallback onProTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Credits badge
        GestureDetector(
          onTap: onCreditsTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.diamond, color: Color(0xFF44385c).withValues(alpha: 0.6), size: 20),
              const SizedBox(width: 3),
              Text(
                '${credits.remaining}',
                style: TextStyle(
                  color: Color(0xFF44385c).withValues(alpha: 0.6),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // GO PRO badge
        GestureDetector(
          onTap: onProTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              'GO PRO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
