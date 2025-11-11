/// Lunar phase-based ritual recommendations
/// Maps phase IDs to recommended rituals

Map<int, List<Map<String, String>>> getLunarRitualRecommendations(String locale) {
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
    {'name': 'Intention Setting Ceremony', 'icon': '🕯️'},
    {'name': 'Vision Board Creation', 'icon': '🎨'},
    {'name': 'Seed Planting Ritual', 'icon': '🌱'},
  ],
  1: [ // Waxing Crescent
    {'name': 'Affirmation Practice', 'icon': '💬'},
    {'name': 'Goal Visualization', 'icon': '👁️'},
    {'name': 'Crystal Charging', 'icon': '💎'},
  ],
  2: [ // First Quarter
    {'name': 'Action Ritual', 'icon': '⚡'},
    {'name': 'Obstacle Release', 'icon': '🔓'},
    {'name': 'Energy Alignment', 'icon': '⚖️'},
  ],
  3: [ // Waxing Gibbous
    {'name': 'Refinement Meditation', 'icon': '🧘'},
    {'name': 'Gratitude Journaling', 'icon': '📖'},
    {'name': 'Preparation Ritual', 'icon': '🎯'},
  ],
  4: [ // Full Moon
    {'name': 'Moon Water Creation', 'icon': '💧'},
    {'name': 'Release Ceremony', 'icon': '🔥'},
    {'name': 'Abundance Ritual', 'icon': '🌕'},
  ],
  5: [ // Waning Gibbous
    {'name': 'Gratitude Meditation', 'icon': '🙏'},
    {'name': 'Wisdom Integration', 'icon': '📚'},
    {'name': 'Sharing Circle', 'icon': '🔮'},
  ],
  6: [ // Last Quarter
    {'name': 'Letting Go Ceremony', 'icon': '🍂'},
    {'name': 'Shadow Work Ritual', 'icon': '🌑'},
    {'name': 'Forgiveness Practice', 'icon': '💜'},
  ],
  7: [ // Waning Crescent
    {'name': 'Rest & Restoration', 'icon': '🛏️'},
    {'name': 'Dream Journaling', 'icon': '📓'},
    {'name': 'Quiet Reflection', 'icon': '🤫'},
  ],
};

// Spanish recommendations
final Map<int, List<Map<String, String>>> _spanishRecommendations = {
  0: [
    {'name': 'Ceremonia de Intenciones', 'icon': '🕯️'},
    {'name': 'Creación de Tablero', 'icon': '🎨'},
    {'name': 'Ritual de Siembra', 'icon': '🌱'},
  ],
  1: [
    {'name': 'Práctica de Afirmaciones', 'icon': '💬'},
    {'name': 'Visualización de Metas', 'icon': '👁️'},
    {'name': 'Carga de Cristales', 'icon': '💎'},
  ],
  2: [
    {'name': 'Ritual de Acción', 'icon': '⚡'},
    {'name': 'Liberación de Obstáculos', 'icon': '🔓'},
    {'name': 'Alineación Energética', 'icon': '⚖️'},
  ],
  3: [
    {'name': 'Meditación de Refinamiento', 'icon': '🧘'},
    {'name': 'Diario de Gratitud', 'icon': '📖'},
    {'name': 'Ritual de Preparación', 'icon': '🎯'},
  ],
  4: [
    {'name': 'Agua de Luna', 'icon': '💧'},
    {'name': 'Ceremonia de Liberación', 'icon': '🔥'},
    {'name': 'Ritual de Abundancia', 'icon': '🌕'},
  ],
  5: [
    {'name': 'Meditación de Gratitud', 'icon': '🙏'},
    {'name': 'Integración de Sabiduría', 'icon': '📚'},
    {'name': 'Círculo de Compartir', 'icon': '🔮'},
  ],
  6: [
    {'name': 'Ceremonia de Soltar', 'icon': '🍂'},
    {'name': 'Ritual de Sombras', 'icon': '🌑'},
    {'name': 'Práctica de Perdón', 'icon': '💜'},
  ],
  7: [
    {'name': 'Descanso y Restauración', 'icon': '🛏️'},
    {'name': 'Diario de Sueños', 'icon': '📓'},
    {'name': 'Reflexión Silenciosa', 'icon': '🤫'},
  ],
};

// Catalan recommendations
final Map<int, List<Map<String, String>>> _catalanRecommendations = {
  0: [
    {'name': 'Cerimònia d\'Intencions', 'icon': '🕯️'},
    {'name': 'Creació de Tauler', 'icon': '🎨'},
    {'name': 'Ritual de Sembra', 'icon': '🌱'},
  ],
  1: [
    {'name': 'Pràctica d\'Afirmacions', 'icon': '💬'},
    {'name': 'Visualització d\'Objectius', 'icon': '👁️'},
    {'name': 'Càrrega de Cristalls', 'icon': '💎'},
  ],
  2: [
    {'name': 'Ritual d\'Acció', 'icon': '⚡'},
    {'name': 'Alliberament d\'Obstacles', 'icon': '🔓'},
    {'name': 'Alineació Energètica', 'icon': '⚖️'},
  ],
  3: [
    {'name': 'Meditació de Refinament', 'icon': '🧘'},
    {'name': 'Diari de Gratitud', 'icon': '📖'},
    {'name': 'Ritual de Preparació', 'icon': '🎯'},
  ],
  4: [
    {'name': 'Aigua de Lluna', 'icon': '💧'},
    {'name': 'Cerimònia d\'Alliberament', 'icon': '🔥'},
    {'name': 'Ritual d\'Abundància', 'icon': '🌕'},
  ],
  5: [
    {'name': 'Meditació de Gratitud', 'icon': '🙏'},
    {'name': 'Integració de Saviesa', 'icon': '📚'},
    {'name': 'Cercle de Compartir', 'icon': '🔮'},
  ],
  6: [
    {'name': 'Cerimònia de Deixar Anar', 'icon': '🍂'},
    {'name': 'Ritual d\'Ombres', 'icon': '🌑'},
    {'name': 'Pràctica de Perdó', 'icon': '💜'},
  ],
  7: [
    {'name': 'Descans i Restauració', 'icon': '🛏️'},
    {'name': 'Diari de Somnis', 'icon': '📓'},
    {'name': 'Reflexió Silenciosa', 'icon': '🤫'},
  ],
};
