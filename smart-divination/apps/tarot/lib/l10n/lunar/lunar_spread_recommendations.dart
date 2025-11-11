/// Lunar phase-based spread recommendations
/// Maps phase IDs to recommended tarot spreads

Map<int, List<Map<String, String>>> getLunarSpreadRecommendations(String locale) {
  switch (locale) {
    case 'es':
      return _spanishRecommendations;
    case 'ca':
      return _catalanRecommendations;
    default:
      return _englishRecommendations;
  }
}

// English recommendations
final Map<int, List<Map<String, String>>> _englishRecommendations = {
  0: [ // New Moon
    {'name': 'New Beginnings', 'icon': '🌱'},
    {'name': 'Intention Setting', 'icon': '🎯'},
    {'name': 'Three Card Path', 'icon': '🃏'},
  ],
  1: [ // Waxing Crescent
    {'name': 'Growth Spread', 'icon': '📈'},
    {'name': 'Path Forward', 'icon': '🛤️'},
    {'name': 'Building Blocks', 'icon': '🧱'},
  ],
  2: [ // First Quarter
    {'name': 'Decision Spread', 'icon': '⚖️'},
    {'name': 'Action Plan', 'icon': '⚡'},
    {'name': 'Obstacle Clearing', 'icon': '🚧'},
  ],
  3: [ // Waxing Gibbous
    {'name': 'Refinement Spread', 'icon': '✨'},
    {'name': 'Preparation Check', 'icon': '📋'},
    {'name': 'Celtic Cross', 'icon': '✝️'},
  ],
  4: [ // Full Moon
    {'name': 'Full Moon Illumination', 'icon': '🌕'},
    {'name': 'Celtic Cross', 'icon': '✝️'},
    {'name': 'Relationship Mirror', 'icon': '💞'},
  ],
  5: [ // Waning Gibbous
    {'name': 'Gratitude Spread', 'icon': '🙏'},
    {'name': 'Release What Served', 'icon': '🍃'},
    {'name': 'Wisdom Harvest', 'icon': '🌾'},
  ],
  6: [ // Last Quarter
    {'name': 'Letting Go', 'icon': '🎈'},
    {'name': 'Shadow Work', 'icon': '🌑'},
    {'name': 'Past-Present-Future', 'icon': '⏳'},
  ],
  7: [ // Waning Crescent
    {'name': 'Rest & Restore', 'icon': '😴'},
    {'name': 'Inner Wisdom', 'icon': '🦉'},
    {'name': 'Dream Reflection', 'icon': '💭'},
  ],
};

// Spanish recommendations
final Map<int, List<Map<String, String>>> _spanishRecommendations = {
  0: [
    {'name': 'Nuevos Comienzos', 'icon': '🌱'},
    {'name': 'Establecer Intenciones', 'icon': '🎯'},
    {'name': 'Tres Cartas Camino', 'icon': '🃏'},
  ],
  1: [
    {'name': 'Crecimiento', 'icon': '📈'},
    {'name': 'Camino Adelante', 'icon': '🛤️'},
    {'name': 'Construcción', 'icon': '🧱'},
  ],
  2: [
    {'name': 'Decisión', 'icon': '⚖️'},
    {'name': 'Plan de Acción', 'icon': '⚡'},
    {'name': 'Superar Obstáculos', 'icon': '🚧'},
  ],
  3: [
    {'name': 'Refinamiento', 'icon': '✨'},
    {'name': 'Preparación', 'icon': '📋'},
    {'name': 'Cruz Celta', 'icon': '✝️'},
  ],
  4: [
    {'name': 'Iluminación Luna Llena', 'icon': '🌕'},
    {'name': 'Cruz Celta', 'icon': '✝️'},
    {'name': 'Espejo Relacional', 'icon': '💞'},
  ],
  5: [
    {'name': 'Gratitud', 'icon': '🙏'},
    {'name': 'Soltar lo Servido', 'icon': '🍃'},
    {'name': 'Cosecha de Sabiduría', 'icon': '🌾'},
  ],
  6: [
    {'name': 'Dejar Ir', 'icon': '🎈'},
    {'name': 'Trabajo de Sombras', 'icon': '🌑'},
    {'name': 'Pasado-Presente-Futuro', 'icon': '⏳'},
  ],
  7: [
    {'name': 'Descanso y Restauración', 'icon': '😴'},
    {'name': 'Sabiduría Interior', 'icon': '🦉'},
    {'name': 'Reflexión de Sueños', 'icon': '💭'},
  ],
};

// Catalan recommendations
final Map<int, List<Map<String, String>>> _catalanRecommendations = {
  0: [
    {'name': 'Nous Començaments', 'icon': '🌱'},
    {'name': 'Establir Intencions', 'icon': '🎯'},
    {'name': 'Tres Cartes Camí', 'icon': '🃏'},
  ],
  1: [
    {'name': 'Creixement', 'icon': '📈'},
    {'name': 'Camí Endavant', 'icon': '🛤️'},
    {'name': 'Construcció', 'icon': '🧱'},
  ],
  2: [
    {'name': 'Decisió', 'icon': '⚖️'},
    {'name': 'Pla d\'Acció', 'icon': '⚡'},
    {'name': 'Superar Obstacles', 'icon': '🚧'},
  ],
  3: [
    {'name': 'Refinament', 'icon': '✨'},
    {'name': 'Preparació', 'icon': '📋'},
    {'name': 'Creu Celta', 'icon': '✝️'},
  ],
  4: [
    {'name': 'Il·luminació Lluna Plena', 'icon': '🌕'},
    {'name': 'Creu Celta', 'icon': '✝️'},
    {'name': 'Mirall Relacional', 'icon': '💞'},
  ],
  5: [
    {'name': 'Gratitud', 'icon': '🙏'},
    {'name': 'Alliberar el Servit', 'icon': '🍃'},
    {'name': 'Collita de Saviesa', 'icon': '🌾'},
  ],
  6: [
    {'name': 'Deixar Anar', 'icon': '🎈'},
    {'name': 'Treball d\'Ombres', 'icon': '🌑'},
    {'name': 'Passat-Present-Futur', 'icon': '⏳'},
  ],
  7: [
    {'name': 'Descans i Restauració', 'icon': '😴'},
    {'name': 'Saviesa Interior', 'icon': '🦉'},
    {'name': 'Reflexió de Somnis', 'icon': '💭'},
  ],
};
