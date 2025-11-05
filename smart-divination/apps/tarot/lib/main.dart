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
import 'theme/tarot_theme.dart';
import 'services/local_storage_service.dart';
import 'services/daily_quote_service.dart';
import 'services/audio_service.dart';
import 'utils/card_image_mapper.dart';
import 'utils/card_name_localizer.dart';
import 'state/full_screen_step.dart';
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
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _seedController = TextEditingController();
  final FocusNode _questionFocusNode = FocusNode();

  static const List<String> _supportedQuestionLocales = <String>[
    'ca',
    'es',
    'en'
  ];

  static const Set<String> _catalanPriorityTokens = {
    'perquè',
    'perque',
    'què',
    'aquest',
    'aquesta',
    'aquests',
    'aquestes',
    'això',
    'aixo',
    'doncs',
    'vosaltres',
    'nostre',
    'nostra',
    'camí',
    'cami',
    'camins',
    'dubte',
    'dubtes',
    'consell',
    'guia',
    'relació',
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
    'porqué',
    'qué',
    'esta',
    'este',
    'estos',
    'estas',
    'mañana',
    'ayer',
    'pareja',
    'trabajo',
    'dinero',
    'salud',
    'amor',
    'necesito',
    'quiero',
    'ayuda',
    'situación',
    'situacion',
    'relación',
    'relacion',
    'decisión',
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAll();
      // Auto-focus on question field when on home (no draw active)
      if (_latestDraw == null) {
        _questionFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _briefingAutoAdvanceTimer?.cancel();
    _briefingAutoAdvanceTimer = null;
    _questionController.dispose();
    _seedController.dispose();
    _questionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() {
      _initialising = true;
      _error = null;
    });

    try {
      final userId = await UserIdentity.obtain();

      // Session eligibility check disabled - not needed for anonymous users
      // final eligibility = await fetchSessionEligibility(userId: userId);

      // Skip profile and history for anonymous users
      final UserProfile? profile;
      final List<TarotSession> history;
      if (userId.startsWith('anon_')) {
        profile = null;
        history = <TarotSession>[];
      } else {
        profile = await fetchUserProfile(userId: userId);
        history = await fetchTarotSessions(userId: userId);
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _userId = userId;
        _profile = profile;
        _history = history;
        _initialising = false;
      });
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
      final typedQuestion = _questionController.text.trim();
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

          debugPrint('🎴 Spread recommendation received:');
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

      final drawFuture = drawCards(
        count: selectedSpread.cardCount,
        spread: selectedSpread.id,
        allowReversed: true,
        seed: seed.isEmpty ? null : seed,
        question: finalQuestion,
        locale: localeCode,
      );

      // Wait for cards to be drawn
      final response = await drawFuture;

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
        _selectedSpread = selectedSpread; // Update to AI-selected spread
        _spreadRecommendationReason = recommendationReason;
      });
      _enterFullScreenFlow();

      _enterFullScreenFlow();

      // Pre-load interpretation in background immediately after cards are available
      if (response.sessionId != null && response.sessionId!.isNotEmpty) {
        _preloadInterpretation(response, finalQuestion, localeCode);
      }

      await Future.wait([
        _refreshHistory(),
        _refreshProfile(),
      ]);
      if (!mounted) {
        return;
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
      _questionController.clear();
      _error = null;
    });
    // Auto-focus on question field after reset
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _questionFocusNode.requestFocus();
      }
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
      final originalQuestion =
          _currentQuestion ?? _questionController.text.trim();
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
        return 'Consulta general: què necessito saber ara mateix per avançar?';
      case 'es':
        return 'Consulta general: ¿qué necesito saber ahora mismo para avanzar?';
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
      future: DailyQuoteService.getTodayQuote(),
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

  Widget _buildDrawFormCard(CommonStrings localisation) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          color: TarotTheme.midnightBlue70,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _questionController,
                  focusNode: _questionFocusNode,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 18, // 2 punts més gran que el default (16)
                  ),
                  decoration: InputDecoration(
                    labelText: localisation.askQuestion,
                    labelStyle: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _drawing ? null : _drawCards,
                  style: FilledButton.styleFrom(
                    backgroundColor: TarotTheme.cosmicPurple,
                  ),
                  icon: _drawing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.auto_awesome),
                  label: const Text('Consultar'),
                ),
              ],
            ),
          ),
        ),
      ],
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
        es: 'El modo chat llegará pronto.',
        ca: 'El mode xat arribarà ben aviat.',
      ),
    );
  }

  void _handleQuickActionArchive(CommonStrings localisation) {
    _showQuickActionMessage(
      _qaText(
        localisation,
        en: 'Archive will be available shortly.',
        es: 'El archivo estará disponible en breve.',
        ca: 'L\'arxiu estarà disponible ben aviat.',
      ),
    );
  }

  void _handleQuickActionSpreads(CommonStrings localisation) {
    _showQuickActionMessage(
      _qaText(
        localisation,
        en: 'Spread explorer coming soon.',
        es: 'Explorador de tiradas próximamente.',
        ca: 'Explorador de tirades properament.',
      ),
    );
  }

  void _handleQuickActionRituals(CommonStrings localisation) {
    _showQuickActionMessage(
      _qaText(
        localisation,
        en: 'Guided rituals coming soon.',
        es: 'Rituales guiados próximamente.',
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
            Icon(icon, size: 24, color: TarotTheme.cosmicAccent),
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

  void _showSettingsDialog(CommonStrings localisation) {
    _showQuickActionMessage(
      _qaText(
        localisation,
        en: 'Settings coming soon.',
        es: 'Ajustes próximamente.',
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
                                        'Interpretación',
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

        // Síntesis section (if present)
        if (synthesis != null) ...[
          const SizedBox(height: 12),
          _buildSpecialSectionBubble(
            synthesis['sectionName'] as String,
            synthesis['sectionText'] as String,
            Icons.check_circle_outline,
            theme,
          ),
        ],

        // Guía section (if present)
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

    // Check if this is a special section (Conclusión, Consejo, etc.)
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

  /// Build a styled bubble for special sections (Síntesis, Guía)
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
    // Pattern: **🃏 Card Name** or **Card Name**
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

      // Check if this is a special section (Síntesis or Guía)
      final isSpecialSection = loweredName.contains('síntesi') ||
          loweredName.contains('síntesis') ||
          loweredName.contains('guía') ||
          loweredName.contains('guia');

      if (isSpecialSection) {
        // Store as special section
        final sectionData = {
          'sectionName': cardName,
          'sectionText': interpretationText,
        };

        if (loweredName.contains('síntesi') ||
            loweredName.contains('síntesis')) {
          synthesis = sectionData;
        } else if (loweredName.contains('guía') ||
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
    const double extraBottomPadding = 32.0;
    final bottomSafeInset =
        math.max(mediaQuery.viewPadding.bottom, mediaQuery.padding.bottom);
    final bottomSpacing = bottomSafeInset + extraBottomPadding;
    const double topSpacing =
        12.0; // Reduced from 32.0 for less space below AppBar

    // Build content based on whether there's a draw or not
    Widget bodyContent;
    Widget? fullScreenOverlay;

    if (_initialising) {
      bodyContent = const Center(child: CircularProgressIndicator());
    } else if (!hasDraw) {
      // Initial state: centered logo and draw form
      bodyContent = CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                const SizedBox(height: 60),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      _error!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(height: bottomSpacing),
              ],
            ),
          ),
        ],
      );
    } else {
      // After draw: show question at top and spread below
      final children = <Widget>[];

      if (_error != null) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              _error!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
        );
      }

      // Place AI recommendation first when available
      children.add(_buildLatestDrawCard(localisation));

      bodyContent = ListView(
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          top: topSpacing,
          bottom: bottomSpacing,
        ),
        children: children,
      );
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildHeaderAction(
              icon: Icons.home_outlined,
              label:
                  _qaText(localisation, en: 'Home', es: 'Inicio', ca: 'Inici'),
              onTap: () => _resetToHome(),
            ),
            _buildHeaderAction(
              icon: Icons.chat_bubble_outline,
              label: _qaText(localisation, en: 'Chat', es: 'Chat', ca: 'Xat'),
              onTap: () => _handleQuickActionChat(localisation),
            ),
            _buildHeaderAction(
              icon: Icons.auto_awesome_motion,
              label: _qaText(localisation,
                  en: 'Spreads', es: 'Tiradas', ca: 'Tirades'),
              onTap: () => _handleQuickActionSpreads(localisation),
            ),
            _buildHeaderAction(
              icon: Icons.archive_outlined,
              label: _qaText(localisation,
                  en: 'Archive', es: 'Archivo', ca: 'Arxiu'),
              onTap: () => _handleQuickActionArchive(localisation),
            ),
            _buildHeaderAction(
              icon: Icons.settings_outlined,
              label: _qaText(localisation,
                  en: 'Settings', es: 'Ajustes', ca: 'Ajustos'),
              onTap: () => _showSettingsDialog(localisation),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Plain light background
          Container(
            decoration: BoxDecoration(
              color: Colors.purple[50],
            ),
          ),
          // Content
          bodyContent,
          if (fullScreenOverlay != null)
            Positioned.fill(child: fullScreenOverlay),
          // Form card fixed at bottom (above button) - only show on home page
          if (!hasDraw)
            Positioned(
              bottom: bottomSafeInset + extraBottomPadding,
              left: 8,
              right: 8,
              child: _buildDrawFormCard(localisation),
            ),
        ],
      ),
    );
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
