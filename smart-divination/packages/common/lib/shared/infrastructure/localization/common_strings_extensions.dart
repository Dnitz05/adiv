import 'package:common/l10n/common_strings.dart';

/// Convenience helpers for mapping technique identifiers.
extension CommonStringsTechniqueHelpers on CommonStrings {
  String appTitle(String technique) {
    switch (technique) {
      case 'tarot':
        return appTitleTarot;
      case 'iching':
        return appTitleIching;
      case 'runes':
        return appTitleRunes;
      default:
        return technique;
    }
  }

  String getTechniqueName(String technique) {
    switch (technique) {
      case 'tarot':
        return tarot;
      case 'iching':
        return iching;
      case 'runes':
        return runes;
      default:
        return technique;
    }
  }

  String getTechniqueDescription(String technique) {
    switch (technique) {
      case 'tarot':
        return tarotDescription;
      case 'iching':
        return ichingDescription;
      case 'runes':
        return runesDescription;
      default:
        return '';
    }
  }
}
