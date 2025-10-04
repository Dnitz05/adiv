import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide UserIdentity;

import 'package:common/shared/infrastructure/localization/app_localizations.dart';

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
        home = const _Home();
        break;
      case _AuthFlow.signedOut:
      default:
        home = const _SignInView();
        break;
    }

    return MaterialApp(
      title: 'Smart Tarot',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
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
    final localisation = AppLocalizations.of(context);
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
    final localisation = AppLocalizations.of(context);
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
                  child: Text(AppLocalizations.of(dialogContext).cancel),
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
    final localisation = AppLocalizations.of(context);
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
    final localisation = AppLocalizations.of(context);
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
    final localisation = AppLocalizations.of(context);
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
    final localisation = AppLocalizations.of(context);
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

class _TarotDrawRecord {
  _TarotDrawRecord({
    required this.moment,
    required this.cards,
    required this.spread,
    required this.seed,
    required this.method,
    this.question,
    this.interpretation,
    this.summary,
    this.keywords = const <String>[],
    this.sessionId,
  });

  final DateTime moment;
  final List<CardResult> cards;
  final String spread;
  final String seed;
  final String method;
  final String? question;
  final String? interpretation;
  final String? summary;
  final List<String> keywords;
  final String? sessionId;
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
      setState(() {
        _error = _formatError(error);
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
      setState(() {
        _error ??= _formatError(error);
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
      setState(() {
        _error ??= _formatError(error);
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
      setState(() {
        _error ??= _formatError(error);
      });
    }
  }

  Future<void> _drawCards() async {
    if (_drawing) {
      return;
    }
    final localisation = AppLocalizations.of(context);
    setState(() {
      _drawing = true;
      _error = null;
    });

    try {
      final seed = _seedController.text.trim();
      final question = _questionController.text.trim();
      final response = await drawCards(
        allowReversed: _allowReversed,
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
      });
      await Future.wait([
        _refreshHistory(),
        _refreshEligibility(),
        _refreshProfile(),
      ]);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localisation.authSignInSuccess)),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = _formatError(error);
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
        _error = _formatError(error);
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

  String _formatError(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '').trim();
    if (message.isEmpty) {
      return 'Unexpected error';
    }
    return message;
  }

  String _formatTimestamp(DateTime time) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(time.toLocal());
  }

  Widget _buildEligibilityCard(
    AppLocalizations localisation,
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

  Widget _buildDrawFormCard(AppLocalizations localisation) {
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
            TextField(
              controller: _seedController,
              decoration: InputDecoration(
                labelText: localisation.seedOptionalLabel,
              ),
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

  Widget _buildLatestDrawCard(AppLocalizations localisation) {
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
              spacing: 6,
              runSpacing: 4,
              children: draw.result
                  .map(
                    (card) => Chip(
                      label: Text(' ()'),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localisation.seedLabel(draw.seed),
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  localisation.methodLabel(draw.method),
                  style: theme.textTheme.bodySmall,
                ),
              ],
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
            ] else if (!_requestingInterpretation &&
                (draw.sessionId != null && draw.sessionId!.isNotEmpty)) ...[
              FilledButton(
                onPressed:
                    _requestingInterpretation ? null : _requestInterpretation,
                child: Text(localisation.interpretationHeading),
              ),
            ] else if (_requestingInterpretation) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(AppLocalizations localisation) {
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

  Widget _buildHistoryCard(AppLocalizations localisation) {
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
                          spacing: 6,
                          runSpacing: 4,
                          children: session.cards
                              .map((card) => Chip(label: Text(card.name)))
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
    final localisation = AppLocalizations.of(context);
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
