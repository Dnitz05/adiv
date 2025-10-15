
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide UserIdentity;

import 'package:common/l10n/common_strings.dart';
import 'package:common/shared/infrastructure/localization/common_strings_extensions.dart';

import 'api/draw_cards_api.dart';
import 'api/interpretation_api.dart';
import 'api/session_limits_api.dart';
import 'api/user_profile_api.dart';
import 'user_identity.dart';
import 'models/tarot_spread.dart';
import 'models/tarot_card.dart';
import 'widgets/spread_selector.dart';
import 'widgets/spread_layout.dart';
import 'theme/tarot_theme.dart';

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
      final eligibility = await fetchSessionEligibility(userId: userId);

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
      });
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
      final suitPrefix = suit.substring(0, 1).toUpperCase() + suit.substring(1).toLowerCase();
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
          height: 180,
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
        const SizedBox(height: 4),
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
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(
        Icons.rotate_left,
        size: 16,
        color: Colors.white,
      ),
    );
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
            SpreadSelector(
              selectedSpread: _selectedSpread,
              onSpreadChanged: _drawing
                  ? (_) {}
                  : (spread) {
                      setState(() {
                        _selectedSpread = spread;
                      });
                    },
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
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                // Get the selected spread or use threeCard as fallback
                final spread = TarotSpreads.getById(draw.spread) ?? TarotSpreads.threeCard;

                // Convert CardResult to TarotCard
                final tarotCards = draw.result.map((card) {
                  final imagePath = _getCardImagePath(card);
                  return TarotCard.fromCardResult(card, imagePath: imagePath);
                }).toList();

                return Center(
                  child: SpreadLayout(
                    spread: spread,
                    cards: tarotCards,
                    maxWidth: constraints.maxWidth,
                    maxHeight: 500,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Text(
              localisation.methodLabel(draw.method),
              style: theme.textTheme.bodySmall,
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
                        const SizedBox(height: 8),
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
    final hasDraw = _latestDraw != null;

    // Build content based on whether there's a draw or not
    Widget bodyContent;

    if (_initialising) {
      bodyContent = const Center(child: CircularProgressIndicator());
    } else if (!hasDraw) {
      // Initial state: centered logo and draw form
      bodyContent = RefreshIndicator(
        onRefresh: _loadAll,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Draw form card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildDrawFormCard(localisation),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _error!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
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

      children.add(_buildLatestDrawCard(localisation));

      bodyContent = RefreshIndicator(
        onRefresh: _loadAll,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: children,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _initialising ? null : _loadAll,
          child: Image.asset(
            'assets/branding/logo-header.png',
            height: 40,
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _initialising ? null : _loadAll,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/fondo.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.25),
            ),
          ),
          bodyContent,
        ],
      ),
    );
  }
}

