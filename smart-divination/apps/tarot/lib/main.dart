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
import 'widgets/spread_gallery_modal.dart';
import 'theme/tarot_theme.dart';
import 'services/local_storage_service.dart';
import 'services/daily_quote_service.dart';
import 'services/audio_service.dart';
import 'utils/card_image_mapper.dart';
import 'utils/card_name_localizer.dart';

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
  bool _showInterpretation = false; // Controls whether interpretation is visible
  TarotSpread _selectedSpread = TarotSpreads.threeCard;
  String? _spreadRecommendationReason; // AI reasoning for spread selection
  String? _lastQuestionLocale;
  String? _displayQuestion;
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
      final bool shouldNudgeUser = typedQuestion.isEmpty;
      String? formattedQuestion;
      try {
        formattedQuestion = await formatQuestion(
          question: baseQuestion,
          locale: localeCode,
        );
      } catch (error) {
        print('⚠️  Question formatting failed: $error');
      }
      final String displayQuestion =
          (formattedQuestion != null && formattedQuestion.trim().isNotEmpty)
              ? formattedQuestion.trim()
              : _formatQuestionLabel(baseQuestion);

      // Use displayQuestion for everything (both UI and backend)
      final String finalQuestion = displayQuestion;

      TarotSpread selectedSpread = _selectedSpread;
      String? recommendationReason;
      try {
        print(
            '🔮 Calling AI spread recommendation for question: $finalQuestion');

        // Use non-streaming endpoint for now (streaming endpoint has deployment issues)
        final recommendation = await recommendSpread(
          question: finalQuestion,
          locale: localeCode,
          // Don't pass onReasoningChunk to use non-streaming endpoint
        );

        selectedSpread = recommendation.spread;
        recommendationReason = recommendation.reasoning;
        print(
            '🔮 AI recommended spread: ${selectedSpread.id} - $recommendationReason');

        // Update UI immediately to show the AI-selected spread
        if (mounted) {
          print(
              '🔮 DEBUG: Updating _selectedSpread to: ${selectedSpread.id} (${selectedSpread.name})');
          setState(() {
            _selectedSpread = selectedSpread;
            _spreadRecommendationReason = recommendationReason;
          });
          print(
              '🔮 DEBUG: After setState, _selectedSpread is now: ${_selectedSpread.id} (${_selectedSpread.name})');
        }
      } catch (e) {
        print('⚠️  AI spread recommendation failed, using selected spread: $e');
        // If AI fails, continue with manually selected spread
      }

      // Start drawing cards, but also pre-load interpretation in parallel
      print(
          '🔮 Starting drawCards and pre-loading interpretation in parallel...');

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

      // Pre-load interpretation in background immediately after cards are available
      if (response.sessionId != null && response.sessionId!.isNotEmpty) {
        print('🔮 Pre-loading AI interpretation in background...');
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

  void _resetToHome() {
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

  Future<void> _dealCardsSequentially() async {
    final draw = _latestDraw;
    if (draw == null || _dealingCards) {
      return;
    }
    setState(() {
      _dealingCards = true;
    });

    final totalCards = draw.result.length;
    const Duration dealDelay = Duration(milliseconds: 650);

    for (var i = 0; i < totalCards; i++) {
      if (!mounted) {
        return;
      }
      if (i > 0) {
        await Future.delayed(dealDelay);
      }
      if (!mounted) {
        return;
      }
      // Play card flip sound (same as when revealing)
      AudioService().playCardFlip();
      setState(() {
        _dealtCardCount = i + 1;
      });
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _dealingCards = false;
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
      print('✅ Using pre-loaded interpretation');
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
      print('🔮 Starting background interpretation request...');
      final result = await submitInterpretation(
        sessionId: sessionId,
        draw: draw,
        question: question.isEmpty ? null : question,
        locale: localeCode,
      );

      // Only update if user hasn't already requested interpretation
      if (mounted && _latestInterpretation == null) {
        print('✅ Background interpretation loaded successfully!');
        setState(() {
          _latestInterpretation = result;
        });

        // Save conversation locally
        if (result != null) {
          await _saveConversationLocally(draw, result, question);
        }
      } else {
        print(
            'ℹ️  Background interpretation completed but UI already has interpretation');
      }
    } catch (error) {
      print('⚠️  Background interpretation pre-load failed: $error');
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
                color: Colors.black.withOpacity(0.2),
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
        color: TarotTheme.cosmicAccent.withOpacity(0.9),
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
              if (quote.author.isNotEmpty) ...[
                const SizedBox(height: 0),
                Text(
                  quote.author,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
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
        Text(
          '¿Qué quieres consultar?',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.normal,
            color: TarotTheme.moonlight.withOpacity(0.85),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Card(
          color: TarotTheme.midnightBlue.withOpacity(0.70),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _questionController,
                  focusNode: _questionFocusNode,
                  decoration: InputDecoration(
                    labelText: localisation.askQuestion,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _drawing ? null : _drawCards,
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

  Widget _buildLatestDrawCard(CommonStrings localisation) {
    final draw = _latestDraw;
    if (draw == null) {
      return const SizedBox.shrink();
    }

    final displayQuestion = _displayQuestion?.trim().isNotEmpty == true
        ? _displayQuestion!.trim()
        : (_currentQuestion != null && _currentQuestion!.isNotEmpty)
            ? _formatQuestionLabel(_currentQuestion!)
            : _generalConsultationLabel(localisation.localeName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCardsMessage(draw, localisation, displayQuestion),
      ],
    );
  }

  Widget _buildCardsMessage(
      CardsDrawResponse draw, CommonStrings localisation, String question) {
    final theme = Theme.of(context);
    final interpretation = _latestInterpretation;
    final accentColor = TarotTheme.cosmicBlue; // Corporate blue
    final int totalCards = draw.result.length;
    final bool allCardsRevealed = _revealedCardCount >= totalCards;

    return Card(
      color: TarotTheme.midnightBlue.withOpacity(0.70),
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
                  accentColor.withOpacity(0.12),
                  accentColor.withOpacity(0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(
                bottom: BorderSide(
                  color: TarotTheme.twilightPurple.withOpacity(0.2),
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
                const SizedBox(height: 8), // Extra spacing after question header
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
                            TarotTheme.cosmicAccent.withOpacity(0.15),
                            TarotTheme.cosmicAccent.withOpacity(0.08),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: TarotTheme.twilightPurple.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.style_outlined,
                                color: TarotTheme.cosmicAccent,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  spread.localizedName(localisation.localeName),
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

                    return Center(
                      child: SpreadLayout(
                        spread: spread,
                        cards: tarotCards,
                        maxWidth: constraints.maxWidth,
                        maxHeight: 500,
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
                      shadowColor: TarotTheme.cosmicAccent.withOpacity(0.4),
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
                            parsedInterpretation['synthesis'] as Map<String, dynamic>?;

                        interpretationGuide =
                            parsedInterpretation['guide'] as Map<String, dynamic>?;
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
                                  TarotTheme.cosmicAccent.withOpacity(0.15),
                                  TarotTheme.cosmicAccent.withOpacity(0.08),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: TarotTheme.twilightPurple.withOpacity(0.2),
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
                                    interpretationSummary!.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    interpretationSummary!,
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

  Widget _buildDashedDivider() {
    return CustomPaint(
      size: const Size(double.infinity, 1),
      painter: _DashedLinePainter(
        color: TarotTheme.cosmicAccent.withOpacity(0.3),
        strokeWidth: 1.5,
        dashWidth: 8,
        dashSpace: 6,
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
        }).toList(),

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
  /// Build text with floated image (newspaper-style layout)
  /// Image floats on the left, text flows next to it and continues below
  Widget _buildTextWithFloatedImage({
    required String cardImage,
    required bool isReversed,
    required String interpretationText,
  }) {
    // Capitalize first letter of text
    final capitalizedText = interpretationText.isNotEmpty
        ? interpretationText[0].toUpperCase() + interpretationText.substring(1)
        : interpretationText;

    const imageWidth = 70.0;
    const imageHeight = 112.0;
    const gap = 12.0;

    final textStyle = TextStyle(
      fontSize: 15,
      color: TarotTheme.moonlight,
      height: 1.6,
      letterSpacing: 0.2,
    );

    // Build the image widget
    final imageWidget = Container(
      width: imageWidth,
      height: imageHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
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

    // Use Row for text beside image, then full-width text below
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageWidget,
            const SizedBox(width: gap),
            Expanded(
              child: Text(
                capitalizedText,
                style: textStyle,
                maxLines: null, // Allow text to wrap and continue below if needed
              ),
            ),
          ],
        ),
      ],
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
            TarotTheme.cosmicAccent.withOpacity(0.15),
            TarotTheme.cosmicAccent.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TarotTheme.twilightPurple.withOpacity(0.2),
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
            TarotTheme.cosmicAccent.withOpacity(0.15),
            TarotTheme.cosmicAccent.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TarotTheme.twilightPurple.withOpacity(0.2),
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

        if (loweredName.contains('síntesi') || loweredName.contains('síntesis')) {
          synthesis = sectionData;
        } else if (loweredName.contains('guía') || loweredName.contains('guia')) {
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

  Widget _buildInterpretationWithCardImages(
    CommonStrings localisation,
    String markdown,
    Map<String, String> cardImages,
    ThemeData theme,
    Color accentColor,
  ) {
    // Parse markdown and identify card references
    // Pattern: **Card Name** (bold markdown)
    final cardReferencePattern = RegExp(r'\*\*(.+?)\*\*');
    final matches = cardReferencePattern.allMatches(markdown);

    if (matches.isEmpty) {
      // No card references found, use regular markdown
      return MarkdownBody(
        data: markdown,
        selectable: true,
        styleSheet: _getMarkdownStyleSheet(theme, accentColor),
      );
    }

    // Build widgets with card images
    final List<Widget> widgets = [];
    int lastIndex = 0;

    for (final match in matches) {
      // Add text before the card reference
      if (match.start > lastIndex) {
        final beforeText = markdown.substring(lastIndex, match.start);
        widgets.add(
          MarkdownBody(
            data: beforeText,
            selectable: true,
            styleSheet: _getMarkdownStyleSheet(theme, accentColor),
          ),
        );
      }

      // Extract card name and check if it's reversed
      final fullCardName = match.group(1)!.trim();
      final loweredName = fullCardName.toLowerCase();
      final isReversed = loweredName.contains('(reversed)') ||
          loweredName.contains('(invertida)') ||
          loweredName.contains('(invertit)') ||
          loweredName.contains('reverso') ||
          loweredName.contains('invertida') ||
          loweredName.contains('invertit');
      final cardName = fullCardName
          // Remove emojis (card emoji 🃏 and others)
          .replaceAll(RegExp(r'[\u{1F000}-\u{1F9FF}]', unicode: true), '')
          // Remove reversed markers
          .replaceAll(RegExp(r'\s*\(reversed\)', caseSensitive: false), '')
          .replaceAll(RegExp(r'\s*\(invertida\)', caseSensitive: false), '')
          .replaceAll(RegExp(r'\s*\(invertit\)', caseSensitive: false), '')
          .replaceAll(RegExp(r'\s*reverso\s*', caseSensitive: false), '')
          .replaceAll(RegExp(r'\s*invertida\s*', caseSensitive: false), '')
          .replaceAll(RegExp(r'\s*invertit\s*', caseSensitive: false), '')
          .trim();
      final localizedCardName = CardNameLocalizer.localize(
          cardName, Localizations.localeOf(context).languageCode);
      final displayName = isReversed
          ? '$localizedCardName (${localisation.cardOrientationReversed})'
          : localizedCardName;

      // Find card image with multiple fallback strategies
      final lookupKey = cardName.toLowerCase();
      String? cardImage = cardImages[lookupKey];

      // Fallback 1: try localized name
      if (cardImage == null) {
        cardImage = cardImages[localizedCardName.toLowerCase()];
      }

      // Fallback 2: try without articles
      if (cardImage == null) {
        final withoutArticle = lookupKey.replaceFirst(
            RegExp(r'^(the|el|la|els|les)\s+', caseSensitive: false), '');
        cardImage = cardImages[withoutArticle];
      }

      // Add card header with image
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card image thumbnail
              if (cardImage != null)
                Container(
                  width: 70,
                  height: 112,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
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
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Show icon if image fails to load
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
                )
              else
                // Show icon if no image found
                Container(
                  width: 70,
                  height: 112,
                  decoration: BoxDecoration(
                    color: TarotTheme.cosmicPurple,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: TarotTheme.twilightPurple,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.style,
                    color: TarotTheme.cosmicAccent,
                    size: 30,
                  ),
                ),
              const SizedBox(width: 12),
              // Card name
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    displayName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < markdown.length) {
      final remainingText = markdown.substring(lastIndex);
      widgets.add(
        MarkdownBody(
          data: remainingText,
          selectable: true,
          styleSheet: _getMarkdownStyleSheet(theme, accentColor),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
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
        color: accentColor.withOpacity(0.9),
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

  Widget _buildAIInterpretationBubble(
      CardsDrawResponse draw, CommonStrings localisation) {
    final theme = Theme.of(context);
    final interpretation = _latestInterpretation;
    final accentColor = TarotTheme.cosmicBlue; // Corporate blue

    // Only show if we have an interpretation
    if (interpretation == null) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: TarotTheme.midnightBlue,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: TarotTheme.cosmicAccent.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Summary as prominent header/title
            if (interpretation.summary != null &&
                interpretation.summary!.isNotEmpty) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withOpacity(0.15),
                      accentColor.withOpacity(0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: TarotTheme.twilightPurple.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: accentColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        interpretation.summary!,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Full interpretation text with markdown support
            Padding(
              padding: const EdgeInsets.all(16),
              child: MarkdownBody(
                data: interpretation.interpretation,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
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
                    color: accentColor.withOpacity(0.9),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(CommonStrings localisation) {
    final profile = _profile;
    if (profile == null) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    // Keyword chips hidden per request
    final List<Widget> keywordChips = const [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localisation.history,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 0),
            Text(
              localisation.latestDrawTitle(profile.sessionCount),
              style: theme.textTheme.bodySmall,
            ),
            if (profile.recentQuestion != null &&
                profile.recentQuestion!.isNotEmpty) ...[
              const SizedBox(height: 0),
              Text(
                _formatQuestionLabel(profile.recentQuestion!),
                style: theme.textTheme.bodySmall,
              ),
            ],
            if (profile.recentInterpretation != null &&
                profile.recentInterpretation!.isNotEmpty) ...[
              const SizedBox(height: 0),
              Text(
                profile.recentInterpretation!,
                style: theme.textTheme.bodySmall,
              ),
            ],
            if (keywordChips.isNotEmpty) ...[
              const SizedBox(height: 0),
              Wrap(
                spacing: 6,
                children: keywordChips,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(CommonStrings localisation) {
    final theme = Theme.of(context);
    if (_history.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            localisation.drawPlaceholder,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localisation.historyHeading,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ..._history.take(5).map(
                  (session) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatTimestamp(session.createdAt),
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 0),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: session.cards
                                .map(
                                  (card) => Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: _buildCardWidget(card, localisation),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        if (session.question != null &&
                            session.question!.isNotEmpty) ...[
                          const SizedBox(height: 0),
                          Text(
                            _formatQuestionLabel(session.question!),
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                        if (session.interpretation != null &&
                            session.interpretation!.isNotEmpty) ...[
                          const SizedBox(height: 0),
                          Text(
                            session.interpretation!,
                            style: theme.textTheme.bodySmall,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
          ],
        ),
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
                // Daily quote card at top
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 0.0),
                  child: _buildDailyQuoteCard(),
                ),
                const SizedBox(height: 0),
                // Banner image below quote (compensate spacing to keep original position)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Image.asset(
                      'assets/home_banner.png',
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        if (frame == null) {
                          debugPrint('Banner loading...');
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        debugPrint('Banner loaded successfully!');
                        return child;
                      },
                      width: MediaQuery.of(context).size.width * 0.8,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                ),
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.grid_view_rounded,
            color: TarotTheme.cosmicAccent,
          ),
          onPressed: _showSpreadGallery,
          tooltip: 'Seleccionar Tirada',
        ),
        title: GestureDetector(
          onTap: _resetToHome,
          child: Image.asset(
            'assets/branding/logo-header.png',
            height: 32,
            fit: BoxFit.contain,
            color: TarotTheme.cosmicAccent,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.history_rounded,
              color: TarotTheme.cosmicAccent,
            ),
            onPressed: () {
              // TODO: Implementar historial
            },
            tooltip: 'Historial de Consultas',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Cosmic gradient background
          Container(
            decoration: BoxDecoration(
              gradient: TarotTheme.subtleBackgroundGradient,
            ),
          ),
          // Starry overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _StarryNightPainter(),
            ),
          ),
          // Content
          bodyContent,
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

      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw a few brighter stars
    for (int i = 0; i < 15; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.8 + 0.8;
      final opacity = random.nextDouble() * 0.3 + 0.5;

      paint.color = TarotTheme.cosmicAccent.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);

      // Add a subtle glow
      paint.color = TarotTheme.cosmicAccent.withOpacity(opacity * 0.3);
      canvas.drawCircle(Offset(x, y), radius * 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for dashed horizontal line
class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  _DashedLinePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startX = 0;
    final y = size.height / 2;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + dashWidth, y),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
