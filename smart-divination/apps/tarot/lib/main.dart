
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide UserIdentity;

import 'package:common/l10n/common_strings.dart';
import 'package:common/shared/infrastructure/localization/common_strings_extensions.dart';

import 'api/draw_cards_api.dart';
import 'api/interpretation_api.dart';
import 'api/session_limits_api.dart';
import 'api/user_profile_api.dart';
import 'user_identity.dart';

const String _supabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: '',
);
const String _supabaseAnonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue: '',
);
const String _passwordResetRedirectUrl = String.fromEnvironment(
  'SUPABASE_PASSWORD_RESET_REDIRECT',
  defaultValue: '',
);

Future<void> _initialiseSupabase() async {
  // Initialize Supabase for anonymous/freemium mode
  // Authentication is optional - app works without valid credentials
  try {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        autoRefreshToken: false, // Disable auto-refresh for anonymous mode
      ),
    );
  } catch (_) {
    // Ignore initialization errors - app works in fully anonymous mode
    // Token validation errors will be caught in buildAuthenticatedHeaders
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initialiseSupabase();
  runApp(const SmartTarotApp());
}

enum _AuthFlow { signedOut, passwordRecovery, signedIn }

class SmartTarotApp extends StatefulWidget {
  const SmartTarotApp({super.key});

  @override
  State<SmartTarotApp> createState() => _SmartTarotAppState();
}

class _SmartTarotAppState extends State<SmartTarotApp> {
  Session? _session;
  _AuthFlow _authFlow = _AuthFlow.signedOut;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    // TEMPORARY: Skip auth for design/UX testing
    // TODO: Re-enable auth flow before production release
    _authFlow = _AuthFlow.signedIn;
    _session = null;

    // Original auth flow (commented out for testing)
    /*
    final client = Supabase.instance.client;
    _session = client.auth.currentSession;
    _authFlow = _session == null ? _AuthFlow.signedOut : _AuthFlow.signedIn;
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
            _authFlow = _AuthFlow.signedOut;
            break;
          default:
            _session = event.session;
            _authFlow =
                _session == null ? _AuthFlow.signedOut : _AuthFlow.signedIn;
            break;
        }
      });
    });
    */
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
      _authFlow = _AuthFlow.signedOut;
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
        home = const _Home(); // Now works with guest mode
        break;
      case _AuthFlow.signedOut:
        home = const _SignInView();
        break;
    }

    return MaterialApp(
      title: 'Real Tarot',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: CommonStrings.localizationsDelegates,
      supportedLocales: CommonStrings.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C5CE7)),
        useMaterial3: true,
      ),
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
                const SizedBox(height: 8),
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
  SessionEligibility? _eligibility;
  UserProfile? _profile;
  List<TarotSession> _history = <TarotSession>[];
  CardsDrawResponse? _latestDraw;
  InterpretationResult? _latestInterpretation;
  bool _allowReversed = true;
  bool _drawing = false;
  bool _requestingInterpretation = false;
  final TextEditingController _questionController = TextEditingController();

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
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() {
      _initialising = true;
      _error = null;
    });
    try {
      final userId = await UserIdentity.obtain();
      final eligibility = await fetchSessionEligibility(userId: userId);
      final profile = await fetchUserProfile(userId: userId);
      final history = await fetchTarotSessions(userId: userId);
      if (!mounted) {
        return;
      }
      setState(() {
        _userId = userId;
        _eligibility = eligibility;
        _profile = profile;
        _history = history;
        _initialising = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      final localisation = CommonStrings.of(context);
      setState(() {
        _error = _formatError(localisation, error);
        _initialising = false;
      });
    }
  }

  Future<void> _refreshEligibility() async {
    final userId = _userId;
    if (userId == null) {
      return;
    }
    try {
      final eligibility = await fetchSessionEligibility(userId: userId);
      if (!mounted) {
        return;
      }
      setState(() {
        _eligibility = eligibility;
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

  Future<void> _refreshProfile() async {
    final userId = _userId;
    if (userId == null) {
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
      final question = _questionController.text.trim();
      final response = await drawCards(
        allowReversed: _allowReversed,
        seed: null,
        question: question.isEmpty ? null : question,
        locale: Localizations.localeOf(context).languageCode,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _latestDraw = response;
        _latestInterpretation = null;
      });

      // Start interpretation request immediately in background if we have a sessionId
      Future<InterpretationResult?>? interpretationFuture;
      if (response.sessionId != null && response.sessionId!.isNotEmpty) {
        setState(() {
          _requestingInterpretation = true;
        });
        interpretationFuture = submitInterpretation(
          sessionId: response.sessionId!,
          draw: response,
          question: question.isEmpty ? null : question,
          locale: Localizations.localeOf(context).languageCode,
        );
      }

      await Future.wait([
        _refreshHistory(),
        _refreshEligibility(),
        _refreshProfile(),
      ]);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localisation.drawSuccessMessage)),
      );

      // Wait for interpretation to complete if it was started
      if (interpretationFuture != null) {
        try {
          final interpretation = await interpretationFuture;
          if (!mounted) {
            return;
          }
          setState(() {
            _latestInterpretation = interpretation;
            _requestingInterpretation = false;
          });
        } catch (interpretationError) {
          if (!mounted) {
            return;
          }
          setState(() {
            _requestingInterpretation = false;
          });
          // Don't show error for interpretation failure, just log it
          print('Interpretation failed: $interpretationError');
        }
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

  Future<void> _signOut() async {
    await UserIdentity.signOut();
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
      return cleaned.isEmpty
          ? localisation.genericUnexpectedError
          : cleaned;
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
    final cardName = rawName.isEmpty ? localisation.unknownCardName : rawName;
    final position = card.position + 1;
    final label = localisation.cardPositionLabel(cardName, position);
    if (!card.upright) {
      return '$label (${localisation.cardOrientationReversed})';
    }
    return label;
  }

  String? _getCardImagePath(CardResult card) {
    // Major Arcana (0-21): 00-TheFool.jpg, 01-TheMagician.jpg, etc.
    // Minor Arcana: Cups01.jpg, Pentacles01.jpg, Swords01.jpg, Wands01.jpg
    final name = card.name.trim();
    final suit = card.suit.trim().toLowerCase();
    final number = card.number;

    // Major Arcana detection
    if (suit == 'major' || suit == 'major arcana' || suit.isEmpty && number != null && number >= 0 && number <= 21) {
      // Map card names to filenames
      final majorArcanaMap = {
        'the fool': '00-TheFool',
        'the magician': '01-TheMagician',
        'the high priestess': '02-TheHighPriestess',
        'the empress': '03-TheEmpress',
        'the emperor': '04-TheEmperor',
        'the hierophant': '05-TheHierophant',
        'the lovers': '06-TheLovers',
        'the chariot': '07-TheChariot',
        'strength': '08-Strength',
        'the hermit': '09-TheHermit',
        'wheel of fortune': '10-WheelOfFortune',
        'justice': '11-Justice',
        'the hanged man': '12-TheHangedMan',
        'death': '13-Death',
        'temperance': '14-Temperance',
        'the devil': '15-TheDevil',
        'the tower': '16-TheTower',
        'the star': '17-TheStar',
        'the moon': '18-TheMoon',
        'the sun': '19-TheSun',
        'judgement': '20-Judgement',
        'the world': '21-TheWorld',
      };
      final fileName = majorArcanaMap[name.toLowerCase()];
      if (fileName != null) {
        return 'assets/cards/$fileName.jpg';
      }
    }

    // Minor Arcana detection
    if (number != null && number >= 1 && number <= 14) {
      final suitCapitalized = suit[0].toUpperCase() + suit.substring(1);
      final numberFormatted = number.toString().padLeft(2, '0');
      return 'assets/cards/$suitCapitalized$numberFormatted.jpg';
    }

    return null;
  }

  Widget _buildEligibilityCard(
    CommonStrings localisation,
    SessionEligibility eligibility,
  ) {
    final theme = Theme.of(context);
    final limits = eligibility.limits;
    final usage = eligibility.usage;
    final nextAllowed = eligibility.nextAllowedAt;
    final subtitle = <String>[
      localisation.tierLabel(eligibility.tier),
      localisation.usageToday(usage.today, limits.perDay),
      localisation.usageWeek(usage.thisWeek, limits.perWeek),
      localisation.usageMonth(usage.thisMonth, limits.perMonth),
      if (nextAllowed != null)
        localisation.nextWindow(_formatTimestamp(nextAllowed)),
      if (!eligibility.canStart && eligibility.reason != null)
        eligibility.reason!,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localisation.settings,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...subtitle.map(
              (line) => Text(
                line,
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
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
              localisation.startSession,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: localisation.askQuestion,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: Text(localisation.allowReversed),
              value: _allowReversed,
              onChanged: _drawing
                  ? null
                  : (value) {
                      setState(() {
                        _allowReversed = value;
                      });
                    },
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _drawing ? null : _drawCards,
              icon: _drawing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(localisation.startSession),
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
    final theme = Theme.of(context);
    final interpretation = _latestInterpretation;

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
            const SizedBox(height: 8),
            Text(
              localisation.spreadLabel(draw.spread),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: draw.result
                  .map(
                    (card) {
                      final imagePath = _getCardImagePath(card);
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (imagePath != null)
                            Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..rotateZ(card.upright ? 0 : 3.14159),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  imagePath,
                                  width: 80,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 80,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.image_not_supported),
                                    );
                                  },
                                ),
                              ),
                            )
                          else
                            Chip(
                              label: Text(
                                _formatCardLabel(card, localisation),
                              ),
                            ),
                          if (imagePath != null) ...[
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 80,
                              child: Text(
                                card.name,
                                style: theme.textTheme.bodySmall,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            if (interpretation != null) ...[
              Text(
                interpretation.interpretation,
                style: theme.textTheme.bodyMedium,
              ),
              if (interpretation.summary != null) ...[
                const SizedBox(height: 8),
                Text(
                  interpretation.summary!,
                  style: theme.textTheme.bodySmall,
                ),
              ],
              if (interpretation.keywords.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: interpretation.keywords
                      .map((keyword) => Chip(label: Text(keyword)))
                      .toList(),
                ),
              ],
            ] else if (_requestingInterpretation) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text(
                        'Generating interpretation...',
                        style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (!_requestingInterpretation &&
                (draw.sessionId != null && draw.sessionId!.isNotEmpty)) ...[
              FilledButton(
                onPressed: _requestInterpretation,
                child: Text(localisation.interpretationHeading),
              ),
            ],
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
    final keywordChips = profile.topKeywords
        .take(6)
        .map((keyword) => Chip(
              label: Text(keyword.value),
              avatar: CircleAvatar(
                child: Text(''),
              ),
            ))
        .toList();

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
            const SizedBox(height: 8),
            Text(
              localisation.latestDrawTitle(profile.sessionCount),
              style: theme.textTheme.bodySmall,
            ),
            if (profile.recentQuestion != null &&
                profile.recentQuestion!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                profile.recentQuestion!,
                style: theme.textTheme.bodySmall,
              ),
            ],
            if (profile.recentInterpretation != null &&
                profile.recentInterpretation!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                profile.recentInterpretation!,
                style: theme.textTheme.bodySmall,
              ),
            ],
            if (keywordChips.isNotEmpty) ...[
              const SizedBox(height: 8),
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
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: session.cards
                              .map(
                                (card) {
                                  final imagePath = _getCardImagePath(card);
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (imagePath != null)
                                        Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.identity()
                                            ..rotateZ(card.upright ? 0 : 3.14159),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.asset(
                                              imagePath,
                                              width: 60,
                                              height: 90,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  width: 60,
                                                  height: 90,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: const Icon(Icons.image_not_supported, size: 20),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      else
                                        Chip(
                                          label: Text(
                                            _formatCardLabel(card, localisation),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              )
                              .toList(),
                        ),
                        if (session.question != null &&
                            session.question!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            session.question!,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                        if (session.interpretation != null &&
                            session.interpretation!.isNotEmpty) ...[
                          const SizedBox(height: 4),
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

    final eligibility = _eligibility;
    if (eligibility != null) {
      children.add(_buildEligibilityCard(localisation, eligibility));
    }

    children.add(_buildDrawFormCard(localisation));
    children.add(_buildLatestDrawCard(localisation));
    children.add(_buildProfileCard(localisation));
    children.add(_buildHistoryCard(localisation));

    return Scaffold(
      appBar: AppBar(
        title: Text(localisation.appTitle('tarot')),
        actions: [
          IconButton(
            onPressed: _initialising ? null : _loadAll,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _initialising
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAll,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: children,
              ),
            ),
    );
  }
}

// TEMPORARY: Design preview screen for UX testing
class _DesignPreview extends StatefulWidget {
  const _DesignPreview();

  @override
  State<_DesignPreview> createState() => _DesignPreviewState();
}

class _DesignPreviewState extends State<_DesignPreview> {
  int _selectedIndex = 0;
  final TextEditingController _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localisation = CommonStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localisation.appTitle('tarot')),
        elevation: 0,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(context, theme, localisation),
          _buildHistoryTab(context, theme, localisation),
          _buildProfileTab(context, theme, localisation),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: localisation.appTitle('tarot'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: localisation.historyHeading,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: localisation.settings,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab(BuildContext context, ThemeData theme, CommonStrings localisation) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Hero section
        Card(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.secondaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  localisation.startSession,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  localisation.askQuestion,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Question input
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    labelText: localisation.askQuestion,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.question_answer),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(localisation.drawSuccessMessage)),
                    );
                  },
                  icon: const Icon(Icons.auto_awesome),
                  label: Text(localisation.startSession),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Spread options
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Spread Types', // TODO: localize
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _buildSpreadOption(theme, 'Single Card', 'Quick insight', Icons.filter_1),
                const SizedBox(height: 8),
                _buildSpreadOption(theme, 'Three Card', 'Past, present, future', Icons.filter_3),
                const SizedBox(height: 8),
                _buildSpreadOption(theme, 'Celtic Cross', 'Detailed reading', Icons.grid_on),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpreadOption(ThemeData theme, String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
    );
  }

  Widget _buildHistoryTab(BuildContext context, ThemeData theme, CommonStrings localisation) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          localisation.historyHeading,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Today, 10:30 AM', // Demo data
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    Chip(label: Text('The Fool')),
                    Chip(label: Text('The Magician')),
                    Chip(label: Text('The High Priestess')),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Your question: What should I focus on today?', // Demo data
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTab(BuildContext context, ThemeData theme, CommonStrings localisation) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          localisation.settings,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                subtitle: const Text('English'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                trailing: Switch(value: true, onChanged: (v) {}),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Theme'),
                subtitle: const Text('System default'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help & Support'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
