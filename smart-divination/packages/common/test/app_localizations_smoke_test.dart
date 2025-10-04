import 'package:flutter_test/flutter_test.dart';
import 'package:common/l10n/common_strings.dart';
import 'package:common/l10n/common_strings_en.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('generated localizations expose expected data', () {
    final strings = CommonStringsEn();
    expect(strings.appTitleTarot.isNotEmpty, isTrue);
    expect(CommonStrings.supportedLocales, isNotEmpty);
  });
}
