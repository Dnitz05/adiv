// Externalized lunar UI translation data
// Extracted from today_tab.dart and unified_lunar_widget.dart

/// UI labels for lunar widgets in 3 locales
const Map<String, Map<String, String>> lunarLabels = {
  'phase_guide': {
    'en': 'Phase Guide',
    'es': 'Guía de Fase',
    'ca': 'Guia de Fase'
  },
  'optimal': {
    'en': 'OPTIMAL',
    'es': 'ÓPTIMO',
    'ca': 'ÒPTIM'
  },
  'avoid': {
    'en': 'AVOID',
    'es': 'EVITAR',
    'ca': 'EVITAR'
  },
  'phase_essence': {
    'en': 'Phase Essence',
    'es': 'Esencia de la Fase',
    'ca': 'Essència de la Fase'
  },
  'optimal_activities': {
    'en': 'Optimal Activities',
    'es': 'Actividades Óptimas',
    'ca': 'Activitats Òptimes'
  },
  'power_hours': {
    'en': 'Power Hours',
    'es': 'Horas de Poder',
    'ca': 'Hores de Poder'
  },
  'power_hours_subtitle': {
    'en': 'Best times today for important activities',
    'es': 'Mejores momentos hoy para actividades importantes',
    'ca': 'Millors moments avui per activitats importants'
  },
};

/// Tab labels for lunar widget tabs in 3 locales
const Map<String, Map<String, String>> lunarTabLabels = {
  'today': {
    'en': 'Today',
    'es': 'Hoy',
    'ca': 'Avui'
  },
  'calendar': {
    'en': 'Calendar',
    'es': 'Calendario',
    'ca': 'Calendari'
  },
  'phases': {
    'en': 'Phases',
    'es': 'Fases',
    'ca': 'Fases'
  },
  'rituals': {
    'en': 'Rituals',
    'es': 'Rituales',
    'ca': 'Rituals'
  },
  'spreads': {
    'en': 'Spreads',
    'es': 'Tiradas',
    'ca': 'Tirades'
  },
};

/// Month names for date formatting in 3 locales
const Map<String, List<String>> monthNames = {
  'en': [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ],
  'es': [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ],
  'ca': [
    'Gener',
    'Febrer',
    'Març',
    'Abril',
    'Maig',
    'Juny',
    'Juliol',
    'Agost',
    'Setembre',
    'Octubre',
    'Novembre',
    'Desembre'
  ],
};

/// Helper function to get a localized UI label
String getLunarLabel(String key, String locale) {
  return lunarLabels[key]?[locale] ??
         lunarLabels[key]?['en'] ??
         key;
}

/// Helper function to get a localized tab label
String getLunarTabLabel(String key, String locale) {
  return lunarTabLabels[key]?[locale] ??
         lunarTabLabels[key]?['en'] ??
         key;
}

/// Helper function to format a date with localized month names
String formatLocalizedDate(String isoDate, String locale) {
  try {
    final date = DateTime.parse(isoDate);
    final months = monthNames[locale] ?? monthNames['en']!;
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  } catch (_) {
    return isoDate;
  }
}

/// Short month names (3 letters) for compact date display
const Map<String, List<String>> shortMonthNames = {
  'en': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
  'es': ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
  'ca': ['Gen', 'Feb', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Oct', 'Nov', 'Des'],
};

/// Header-specific labels (compact unified header)
const Map<String, Map<String, String>> lunarHeaderLabels = {
  'lunar_phase': {
    'en': 'Lunar phase',
    'es': 'Fase lunar',
    'ca': 'Fase lunar'
  },
  'moon_in': {
    'en': 'Moon in',
    'es': 'Luna en',
    'ca': 'Lluna en'
  },
  'day': {
    'en': 'Day',
    'es': 'Día',
    'ca': 'Dia'
  },
  'in': {
    'en': 'in',
    'es': 'en',
    'ca': 'en'
  },
  'd': {
    'en': 'd',
    'es': 'd',
    'ca': 'd'
  },
};

/// Moon trend translations
const Map<String, Map<String, String>> moonTrends = {
  'waxing': {
    'en': 'Waxing',
    'es': 'Creciente',
    'ca': 'Creixent'
  },
  'waning': {
    'en': 'Waning',
    'es': 'Menguante',
    'ca': 'Minvant'
  },
};

/// Zodiac quality translations
const Map<String, Map<String, String>> zodiacQualities = {
  'cardinal': {
    'en': 'Cardinal',
    'es': 'Cardinal',
    'ca': 'Cardinal'
  },
  'fixed': {
    'en': 'Fixed',
    'es': 'Fijo',
    'ca': 'Fix'
  },
  'mutable': {
    'en': 'Mutable',
    'es': 'Mutable',
    'ca': 'Mutable'
  },
};

/// Polarity translations
const Map<String, Map<String, String>> polarities = {
  'yang': {
    'en': 'Yang',
    'es': 'Yang',
    'ca': 'Yang'
  },
  'yin': {
    'en': 'Yin',
    'es': 'Yin',
    'ca': 'Yin'
  },
};

/// Element translations
const Map<String, Map<String, String>> elements = {
  'fire': {
    'en': 'Fire',
    'es': 'Fuego',
    'ca': 'Foc'
  },
  'earth': {
    'en': 'Earth',
    'es': 'Tierra',
    'ca': 'Terra'
  },
  'air': {
    'en': 'Air',
    'es': 'Aire',
    'ca': 'Aire'
  },
  'water': {
    'en': 'Water',
    'es': 'Agua',
    'ca': 'Aigua'
  },
};

/// Next phase name translations (short versions for compact header)
const Map<String, Map<String, String>> nextPhaseNames = {
  'new_moon': {
    'en': 'New',
    'es': 'Nueva',
    'ca': 'Nova'
  },
  'first_quarter': {
    'en': 'First Q.',
    'es': 'Cuarto C.',
    'ca': 'Quart C.'
  },
  'full_moon': {
    'en': 'Full',
    'es': 'Llena',
    'ca': 'Plena'
  },
  'last_quarter': {
    'en': 'Last Q.',
    'es': 'Cuarto M.',
    'ca': 'Quart M.'
  },
};

/// Helper function to format a date with short month names
String formatShortDate(DateTime date, String locale) {
  final months = shortMonthNames[locale] ?? shortMonthNames['en']!;
  return '${date.day} ${months[date.month - 1]}';
}

/// Helper function to get a header-specific label
String getLunarHeaderLabel(String key, String locale) {
  return lunarHeaderLabels[key]?[locale] ??
         lunarHeaderLabels[key]?['en'] ??
         key;
}

/// Helper function to get a moon trend translation
String getMoonTrendLabel(String key, String locale) {
  return moonTrends[key]?[locale] ??
         moonTrends[key]?['en'] ??
         key;
}

/// Helper function to get a zodiac quality translation
String getZodiacQualityLabel(String key, String locale) {
  return zodiacQualities[key]?[locale] ??
         zodiacQualities[key]?['en'] ??
         key;
}

/// Helper function to get a polarity translation
String getPolarityLabel(String key, String locale) {
  return polarities[key]?[locale] ??
         polarities[key]?['en'] ??
         key;
}

/// Helper function to get an element translation
String getElementLabel(String key, String locale) {
  return elements[key]?[locale] ??
         elements[key]?['en'] ??
         key;
}

/// Helper function to get a next phase name translation
String getNextPhaseLabel(String key, String locale) {
  return nextPhaseNames[key]?[locale] ??
         nextPhaseNames[key]?['en'] ??
         key;
}
