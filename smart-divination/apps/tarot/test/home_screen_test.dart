import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:common/l10n/common_strings_en.dart';
import 'package:smart_tarot/main.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    try {
      Supabase.instance.client;
    } catch (_) {
      await Supabase.initialize(
        url: 'https://example.supabase.co',
        anonKey: 'public-anon-key',
      );
    }
  });

  testWidgets('shows auth screen by default', (tester) async {
    const app = SmartTarotApp();
    final strings = CommonStringsEn();

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.text(strings.authSignInTitle), findsOneWidget);
    expect(find.text(strings.authEmailLabel), findsOneWidget);
    expect(find.text(strings.authPasswordLabel), findsOneWidget);
  });

  testWidgets('forgot password link is rendered', (tester) async {
    const app = SmartTarotApp();
    final strings = CommonStringsEn();

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.text(strings.authForgotPasswordLink), findsOneWidget);
  });

  testWidgets('toggle changes to sign up copy', (tester) async {
    const app = SmartTarotApp();
    final strings = CommonStringsEn();

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    await tester.tap(find.text(strings.authToggleToSignUp));
    await tester.pumpAndSettle();

    expect(find.text(strings.authSignUpTitle), findsOneWidget);
    expect(find.text(strings.authSignUpButton), findsOneWidget);
    expect(find.text(strings.authPasswordLabelWithHint), findsOneWidget);
  });
}
