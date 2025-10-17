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
  defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhbnJpeHh6YWF3eWJzemV1aXZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjcxMTQ5NjYsImV4cCI6MjA0MjY5MDk2Nn0.CpqfQBuNVEwMlWbYU1WEA0zFwWBo6RKpPxYi4oy3Xwc',
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
  TarotSpread _selectedSpread = TarotSpreads.threeCard;
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _seedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAll();
    });
  }

  @override
  void dispose() {
    _questionController.dispose();
    _seedController.dispose();
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
      final question = _questionController.text.trim();
      final response = await drawCards(
        count: _selectedSpread.cardCount,
        spread: _selectedSpread.id,
        allowReversed: true,
        seed: seed.isEmpty ? null : seed,
        question: question.isEmpty ? null : question,
        locale: Localizations.localeOf(context).languageCode,
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
        _currentQuestion = question.isEmpty ? null : question;
      });
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SpreadGalleryModal(
        selectedSpread: _selectedSpread,
        onSpreadSelected: (spread) {
          setState(() {
            _selectedSpread = spread;
          });
          Navigator.pop(context);
        },
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
      _currentQuestion = null;
      _questionController.clear();
      _error = null;
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
    const Duration dealDelay = Duration(milliseconds: 250);

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
    const Duration flipDelay = Duration(milliseconds: 320);

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

    setState(() {
      _requestingInterpretation = true;
      _error = null;
    });

    try {
      final question = _questionController.text.trim();
      final result = await submitInterpretation(
        sessionId: sessionId,
        draw: draw,
        question: question.isEmpty ? null : question,
        locale: Localizations.localeOf(context).languageCode,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _latestInterpretation = result;
      });
      await _refreshHistory();

      // Save conversation locally
      if (result != null) {
        await _saveConversationLocally(draw, result, question);
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '¿Qué quieres consultar?',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _questionController,
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
              label: const Text('Consulta'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestDrawCard(CommonStrings localisation) {
    final draw = _latestDraw;
    if (draw == null) {
      return const SizedBox.shrink();
    }

    final displayQuestion =
        (_currentQuestion != null && _currentQuestion!.isNotEmpty)
            ? _currentQuestion!
            : 'Consulta general';

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
      child: Column(
        children: [
          // Question header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Show spread info when showing placeholders
                if (_dealtCardCount == 0) ...[
                  Builder(
                    builder: (context) {
                      final spread = TarotSpreads.getById(draw.spread) ??
                          TarotSpreads.threeCard;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                color: TarotTheme.moonlight,
                                height: 1.5,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Tirada escogida: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: TarotTheme.cosmicAccent,
                                  ),
                                ),
                                TextSpan(
                                  text: spread.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                color: TarotTheme.moonlight,
                                height: 1.5,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Motivo: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: TarotTheme.cosmicAccent,
                                  ),
                                ),
                                TextSpan(
                                  text: spread.description,
                                  style: TextStyle(
                                    color: TarotTheme.stardust,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                ],
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

                    final dealCount = math.max(0, math.min(_dealtCardCount, totalCards));
                    final revealCount = math.max(0, math.min(_revealedCardCount, totalCards));

                    return Center(
                      child: SpreadLayout(
                        spread: spread,
                        cards: tarotCards,
                        maxWidth: constraints.maxWidth,
                        maxHeight: 500,
                        dealtCardCount: dealCount,
                        revealedCardCount: revealCount,
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
                      backgroundColor: TarotTheme.cosmicPurple,
                      foregroundColor: TarotTheme.moonlight,
                    ),
                    icon: const Icon(Icons.style, size: 20),
                    label: const Text('Repartir cartas'),
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
                else if (_dealtCardCount > 0 && _revealedCardCount == 0 && !_revealingCards) ...[
                  FilledButton.icon(
                    onPressed: _revealCardsSequentially,
                    style: FilledButton.styleFrom(
                      backgroundColor: TarotTheme.cosmicAccent,
                      foregroundColor: TarotTheme.moonlight,
                    ),
                    icon: const Icon(Icons.flip_to_front, size: 20),
                    label: Text(localisation.revealCards),
                  ),
                ]
                // Phase 2: Revealing in progress
                else if (_revealingCards) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: CircularProgressIndicator(),
                  ),
                ]
                // Phase 3: Request interpretation (Interpretar)
                else if (allCardsRevealed &&
                    interpretation == null &&
                    draw.sessionId != null &&
                    draw.sessionId!.isNotEmpty) ...[
                  FilledButton.icon(
                    onPressed: _requestInterpretation,
                    style: FilledButton.styleFrom(
                      backgroundColor: TarotTheme.cosmicBlue,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.auto_awesome, size: 20),
                    label: Text(localisation.interpretationHeading),
                  ),
                ],
                // Show interpretation below cards if available
                if (allCardsRevealed && interpretation != null) ...[
                  const SizedBox(height: 24),
                  _buildInterpretationSection(interpretation, theme,
                      accentColor, draw.result, localisation),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterpretationSection(
      InterpretationResult interpretation,
      ThemeData theme,
      Color accentColor,
      List<CardResult> cards,
      CommonStrings localisation) {
    // Create map of card names to their images for quick lookup
    final cardImages = <String, String>{};
    for (final card in cards) {
      final imagePath = CardImageMapper.getCardImagePath(card.name, card.suit);
      cardImages[card.name.toLowerCase()] = imagePath;
      final localizedKey =
          CardNameLocalizer.localize(card.name, localisation.localeName)
              .toLowerCase();
      cardImages[localizedKey] = imagePath;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Summary as title
        if (interpretation.summary != null &&
            interpretation.summary!.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor.withOpacity(0.15),
                  accentColor.withOpacity(0.08),
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
          const SizedBox(height: 16),
        ],
        // Full interpretation text with card images
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildInterpretationWithCardImages(
            localisation,
            interpretation.interpretation,
            cardImages,
            theme,
            accentColor,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
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
          loweredName.contains('(invertit)');
      final cardName = fullCardName
          .replaceAll(RegExp(r'\s*\(reversed\)', caseSensitive: false), '')
          .replaceAll(RegExp(r'\s*\(invertida\)', caseSensitive: false), '')
          .replaceAll(RegExp(r'\s*\(invertit\)', caseSensitive: false), '')
          .trim();
      final localizedCardName = CardNameLocalizer.localize(
          cardName, Localizations.localeOf(context).languageCode);
      final displayName = isReversed
          ? '$localizedCardName (${localisation.cardOrientationReversed})'
          : localizedCardName;

      // Find card image
      final lookupKey = cardName.toLowerCase();
      final cardImage =
          cardImages[lookupKey] ?? cardImages[localizedCardName.toLowerCase()];

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
                  width: 50,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: isReversed
                          ? (Matrix4.identity()..rotateZ(math.pi))
                          : Matrix4.identity(),
                      child: Image.asset(
                        cardImage,
                        fit: BoxFit.cover,
                      ),
                    ),
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
                profile.recentQuestion!,
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
                            session.question!,
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
    const double topSpacing = 24.0;

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
                const SizedBox(height: 16),
                // Daily quote card at top
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 0.0),
                  child: _buildDailyQuoteCard(),
                ),
                const SizedBox(height: 16),
                // Banner image below quote
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
        title: GestureDetector(
          onTap: _resetToHome,
          child: Image.asset(
            'assets/branding/logo-header.png',
            height: 40,
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.grid_view_rounded,
              color: TarotTheme.cosmicAccent,
            ),
            onPressed: _showSpreadGallery,
            tooltip: 'Seleccionar Tirada',
          ),
          IconButton(
            icon: Icon(
              Icons.history_rounded,
              color: TarotTheme.twilightPurple,
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





