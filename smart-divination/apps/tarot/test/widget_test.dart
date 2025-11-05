import 'package:flutter_test/flutter_test.dart';

import 'package:smart_tarot/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartTarotApp());
    expect(find.byType(SmartTarotApp), findsOneWidget);
  });
}
