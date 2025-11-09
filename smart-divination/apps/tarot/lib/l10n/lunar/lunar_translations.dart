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
