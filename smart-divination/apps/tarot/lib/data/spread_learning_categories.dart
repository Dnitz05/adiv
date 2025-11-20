/// Learning categories for the Spreads & Methods journey
///
/// This file organizes all 101 spreads into 6 pedagogical categories
/// for progressive learning in the Learn section.

class SpreadLearningCategory {
  const SpreadLearningCategory({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.spreadIds,
    required this.complexity,
  });

  final String id;
  final String icon;
  final Map<String, String> title;
  final Map<String, String> description;
  final String color; // Hex color
  final List<String> spreadIds; // IDs of spreads in this category
  final String complexity; // 'beginner', 'intermediate', 'advanced'
}

/// All learning categories for the Spreads & Methods journey
const List<SpreadLearningCategory> SPREAD_LEARNING_CATEGORIES = [
  // ============================================================================
  // 1. BEGINNER SPREADS
  // ============================================================================
  SpreadLearningCategory(
    id: 'beginner_spreads',
    icon: '🌱',
    title: {
      'en': 'Beginner Spreads',
      'es': 'Tiradas para Principiantes',
      'ca': 'Tirades per Principiants',
    },
    description: {
      'en':
          'Start your journey with simple, foundational spreads perfect for daily practice and learning the basics.',
      'es':
          'Comienza tu viaje con tiradas simples y fundamentales, perfectas para la práctica diaria y aprender lo básico.',
      'ca':
          'Comença el teu viatge amb tirades simples i fonamentals, perfectes per a la pràctica diària i aprendre el bàsic.',
    },
    color: '#10B981', // Green
    complexity: 'beginner',
    spreadIds: [
      'single',
      'three_card',
      'five_card_cross',
      'past_present_future',
      'situation_action_outcome',
      'yes_no',
      'daily_draw',
      'morning_guidance',
      'evening_reflection',
      'weekly_overview',
      'quick_insight',
      'simple_cross',
      'four_directions',
      'mind_body_spirit',
      'advice_spread',
      'choice_spread',
      'two_paths',
      'opportunity_evaluation',
      'next_steps_timeline',
      'chakra_alignment',
      'elemental_balance',
      'dream_interpretation',
      'moon_cycle',
      'manifestation',
      'gratitude_practice',
      'energy_check',
    ],
  ),

  // ============================================================================
  // 2. LOVE & RELATIONSHIPS
  // ============================================================================
  SpreadLearningCategory(
    id: 'love_relationships',
    icon: '💕',
    title: {
      'en': 'Love & Relationships',
      'es': 'Amor y Relaciones',
      'ca': 'Amor i Relacions',
    },
    description: {
      'en':
          'Explore matters of the heart with spreads designed for romance, partnerships, and emotional connections.',
      'es':
          'Explora asuntos del corazón con tiradas diseñadas para el romance, las parejas y las conexiones emocionales.',
      'ca':
          'Explora els assumptes del cor amb tirades dissenyades per al romanç, les parelles i les connexions emocionals.',
    },
    color: '#EC4899', // Pink
    complexity: 'intermediate',
    spreadIds: [
      'relationship',
      'new_love_potential',
      'healing_breakup',
      'soulmate_search',
      'compatibility_check',
      'marriage_decision',
      'toxic_relationship',
      'self_love_journey',
      'intimacy_issues',
      'partnership_balance',
      'relationship_harmony',
      'true_love',
      'twin_flame',
      'friendship',
      'family_dynamics',
    ],
  ),

  // ============================================================================
  // 3. CAREER & FINANCES
  // ============================================================================
  SpreadLearningCategory(
    id: 'career_finances',
    icon: '💼',
    title: {
      'en': 'Career & Finances',
      'es': 'Carrera y Finanzas',
      'ca': 'Carrera i Finances',
    },
    description: {
      'en':
          'Navigate professional paths and financial decisions with clarity and confidence.',
      'es':
          'Navega por caminos profesionales y decisiones financieras con claridad y confianza.',
      'ca':
          'Navega per camins professionals i decisions financeres amb claredat i confiança.',
    },
    color: '#F59E0B', // Amber
    complexity: 'intermediate',
    spreadIds: [
      'career_path',
      'job_search',
      'work_conflict',
      'promotion_potential',
      'career_change',
      'business_venture',
      'financial_overview',
      'investment_decision',
      'debt_management',
      'salary_negotiation',
      'abundance_mindset',
      'business_finances',
      'savings_goals',
      'financial_blocks',
      'money_flow',
      'prosperity_path',
      'success_strategy',
      'professional_growth',
      'leadership_potential',
      'teamwork_dynamics',
      'creative_project',
      'education_study',
    ],
  ),

  // ============================================================================
  // 4. PERSONAL GROWTH
  // ============================================================================
  SpreadLearningCategory(
    id: 'personal_growth',
    icon: '🌟',
    title: {
      'en': 'Personal Growth',
      'es': 'Crecimiento Personal',
      'ca': 'Creixement Personal',
    },
    description: {
      'en':
          'Deepen self-awareness and unlock your potential through introspective spreads.',
      'es':
          'Profundiza tu autoconciencia y desbloquea tu potencial con tiradas introspectivas.',
      'ca':
          'Aprofundeix la teva autoconsciència i desbloqueja el teu potencial amb tirades introspectives.',
    },
    color: '#8B5CF6', // Purple
    complexity: 'intermediate',
    spreadIds: [
      'life_path',
      'hidden_talents',
      'psychological_blocks',
      'behavior_patterns',
      'inner_child',
      'shadow_self',
      'authentic_self',
      'values_clarification',
      'strengths_weaknesses',
      'personal_identity',
      'life_purpose',
      'soul_mission',
      'sacred_calling',
      'personal_power',
      'confidence_building',
      'overcoming_fear',
      'breaking_habits',
      'mindset_shift',
    ],
  ),

  // ============================================================================
  // 5. SPIRITUAL GUIDANCE
  // ============================================================================
  SpreadLearningCategory(
    id: 'spiritual_guidance',
    icon: '✨',
    title: {
      'en': 'Spiritual Guidance',
      'es': 'Guía Espiritual',
      'ca': 'Guia Espiritual',
    },
    description: {
      'en':
          'Connect with higher wisdom and explore spiritual dimensions of your journey.',
      'es':
          'Conecta con la sabiduría superior y explora las dimensiones espirituales de tu viaje.',
      'ca':
          'Connecta amb la saviesa superior i explora les dimensions espirituals del teu viatge.',
    },
    color: '#6366F1', // Indigo
    complexity: 'intermediate',
    spreadIds: [
      'spiritual_path',
      'shadow_work',
      'spiritual_awakening',
      'past_life',
      'psychic_development',
      'meditation_journey',
      'divine_guidance',
      'karmic_lessons',
      'soul_purpose',
      'energy_healing',
      'spiritual_gifts',
      'higher_self',
      'spirit_guides',
      'intuition_development',
      'chakra_healing',
      'aura_reading',
      'healing_journey',
      'holistic_wellness',
    ],
  ),

  // ============================================================================
  // 6. ADVANCED SPREADS
  // ============================================================================
  SpreadLearningCategory(
    id: 'advanced_spreads',
    icon: '🎓',
    title: {
      'en': 'Advanced Spreads',
      'es': 'Tiradas Avanzadas',
      'ca': 'Tirades Avançades',
    },
    description: {
      'en':
          'Master complex spreads for comprehensive insights and professional-level readings.',
      'es':
          'Domina tiradas complejas para obtener perspectivas integrales y lecturas de nivel profesional.',
      'ca':
          'Domina tirades complexes per obtenir perspectives integrals i lectures de nivell professional.',
    },
    color: '#DC2626', // Red
    complexity: 'advanced',
    spreadIds: [
      'celtic_cross',
      'tree_of_life',
      'astrological',
      'horseshoe',
      'star',
      'pyramid',
      'calendar',
      'year_ahead',
      'major_life_change',
      'moving_relocation',
      'travel_planning',
      'legal_issues',
      'health_check',
      'mental_health',
      'stress_relief',
      'burnout_recovery',
      'body_wisdom',
      'six_month_outlook',
      'specific_event_timing',
      'four_seasons',
      'decision',
      'risk_assessment',
      'life_crossroads',
      'home_life',
      'parenting',
    ],
  ),
];

/// Get category by ID
SpreadLearningCategory? getCategoryById(String categoryId) {
  try {
    return SPREAD_LEARNING_CATEGORIES.firstWhere(
      (category) => category.id == categoryId,
    );
  } catch (e) {
    return null;
  }
}

/// Get all spread IDs across all categories
List<String> getAllSpreadIds() {
  return SPREAD_LEARNING_CATEGORIES.expand((category) => category.spreadIds)
      .toList();
}

/// Find which category a spread belongs to
SpreadLearningCategory? getCategoryForSpread(String spreadId) {
  try {
    return SPREAD_LEARNING_CATEGORIES.firstWhere(
      (category) => category.spreadIds.contains(spreadId),
    );
  } catch (e) {
    return null;
  }
}

/// Get total number of spreads across all categories
int getTotalSpreadCount() {
  return SPREAD_LEARNING_CATEGORIES.fold(
    0,
    (sum, category) => sum + category.spreadIds.length,
  );
}
