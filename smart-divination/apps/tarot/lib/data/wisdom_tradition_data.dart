import '../models/wisdom_tradition_content.dart';
import 'wisdom_lessons_origins.dart';

/// Complete repository of Wisdom & Tradition content
///
/// This file contains all categories and lessons for the
/// "Wisdom & Tradition" learning journey.
///
/// Content is 100% aligned with traditional tarot knowledge,
/// based on documented sources and verified historical information.

class WisdomTraditionData {
  // ============================================================================
  // CATEGORIES
  // ============================================================================

  static final List<WisdomTraditionCategory> categories = [
    // CATEGORY 1: Origins & History
    const WisdomTraditionCategory(
      id: 'origins_history',
      icon: '📜',
      title: {
        'en': 'Tarot Origins & History',
        'es': 'Orígenes e Historia del Tarot',
        'ca': 'Orígens i Història del Tarot',
      },
      subtitle: {
        'en': 'From Renaissance courts to modern practice',
        'es': 'De las cortes renacentistas a la práctica moderna',
        'ca': 'De les corts renaixentistes a la pràctica moderna',
      },
      description: {
        'en':
            'Explore the authentic history of tarot cards, from their origins as Italian playing cards to their transformation into a spiritual tool. Learn about the Tarot de Marseille, the Rider-Waite-Smith revolution, and modern deck diversity.',
        'es':
            'Explora la auténtica historia de las cartas del tarot, desde sus orígenes como naipes italianos hasta su transformación en herramienta espiritual. Aprende sobre el Tarot de Marsella, la revolución Rider-Waite-Smith y la diversidad moderna de barajas.',
        'ca':
            'Explora l\'autèntica història de les cartes del tarot, des dels seus orígens com a naips italians fins a la seva transformació en eina espiritual. Aprèn sobre el Tarot de Marsella, la revolució Rider-Waite-Smith i la diversitat moderna de baralles.',
      },
      color: '#8B5CF6', // Purple
      lessonCount: 8,
      lessonIds: [
        'origins_1',
        'origins_2',
        'origins_3',
        'origins_4',
        'origins_5',
        'origins_6',
        'origins_7',
        'origins_8',
      ],
    ),

    // CATEGORY 2: Ethics & Responsible Practice
    const WisdomTraditionCategory(
      id: 'ethics_practice',
      icon: '🧭',
      title: {
        'en': 'Ethics & Responsible Practice',
        'es': 'Ética y Práctica Responsable',
        'ca': 'Ètica i Pràctica Responsable',
      },
      subtitle: {
        'en': 'Read with integrity and respect',
        'es': 'Lee con integridad y respeto',
        'ca': 'Llegeix amb integritat i respecte',
      },
      description: {
        'en':
            'Learn the ethical foundations of responsible tarot reading. Understand power dynamics, professional boundaries, when to refer to professionals, and how to read with honesty and care.',
        'es':
            'Aprende los fundamentos éticos de la lectura responsable del tarot. Comprende las dinámicas de poder, los límites profesionales, cuándo referir a profesionales, y cómo leer con honestidad y cuidado.',
        'ca':
            'Aprèn els fonaments ètics de la lectura responsable del tarot. Comprèn les dinàmiques de poder, els límits professionals, quan referir a professionals, i com llegir amb honestedat i cura.',
      },
      color: '#10B981', // Green
      lessonCount: 6,
      lessonIds: [
        'ethics_1',
        'ethics_2',
        'ethics_3',
        'ethics_4',
        'ethics_5',
        'ethics_6',
      ],
    ),

    // CATEGORY 3: Traditional Tarot Systems
    const WisdomTraditionCategory(
      id: 'traditional_systems',
      icon: '🎴',
      title: {
        'en': 'Traditional Tarot Systems',
        'es': 'Sistemas Tradicionales de Tarot',
        'ca': 'Sistemes Tradicionals de Tarot',
      },
      subtitle: {
        'en': 'RWS, Marseille, Thoth & more',
        'es': 'RWS, Marsella, Thoth y más',
        'ca': 'RWS, Marsella, Thoth i més',
      },
      description: {
        'en':
            'Deep dive into the three major tarot traditions: Rider-Waite-Smith, Tarot de Marseille, and Thoth. Learn their unique approaches, symbolic systems, and how to choose the right deck for you.',
        'es':
            'Inmersión profunda en las tres grandes tradiciones del tarot: Rider-Waite-Smith, Tarot de Marsella y Thoth. Aprende sus enfoques únicos, sistemas simbólicos y cómo elegir la baraja adecuada para ti.',
        'ca':
            'Immersió profunda en les tres grans tradicions del tarot: Rider-Waite-Smith, Tarot de Marsella i Thoth. Aprèn els seus enfocaments únics, sistemes simbòlics i com triar la baralla adequada per tu.',
      },
      color: '#F59E0B', // Amber
      lessonCount: 5,
      lessonIds: [
        'systems_1',
        'systems_2',
        'systems_3',
        'systems_4',
        'systems_5',
      ],
    ),

    // CATEGORY 4: Symbolism & Archetypes
    const WisdomTraditionCategory(
      id: 'symbolism_archetypes',
      icon: '🔮',
      title: {
        'en': 'Symbolism & Archetypes',
        'es': 'Simbolismo y Arquetipos',
        'ca': 'Simbolisme i Arquetips',
      },
      subtitle: {
        'en': 'Universal language of tarot imagery',
        'es': 'Lenguaje universal de la imaginería del tarot',
        'ca': 'Llenguatge universal de la imagineria del tarot',
      },
      description: {
        'en':
            'Master the symbolic language of tarot. Explore the four elements, Jungian archetypes, color symbolism, numerology, astrological correspondences, and the Kabbalistic Tree of Life.',
        'es':
            'Domina el lenguaje simbólico del tarot. Explora los cuatro elementos, arquetipos jungianos, simbolismo del color, numerología, correspondencias astrológicas y el Árbol de la Vida cabalístico.',
        'ca':
            'Domina el llenguatge simbòlic del tarot. Explora els quatre elements, arquetips jungians, simbolisme del color, numerologia, correspondències astrològiques i l\'Arbre de la Vida cabalístic.',
      },
      color: '#7C3AED', // Deep Purple
      lessonCount: 10,
      lessonIds: [
        'symbolism_1',
        'symbolism_2',
        'symbolism_3',
        'symbolism_4',
        'symbolism_5',
        'symbolism_6',
        'symbolism_7',
        'symbolism_8',
        'symbolism_9',
        'symbolism_10',
      ],
    ),

    // CATEGORY 5: Reading Practices & Techniques
    const WisdomTraditionCategory(
      id: 'reading_practices',
      icon: '🕯️',
      title: {
        'en': 'Reading Practices & Techniques',
        'es': 'Prácticas y Técnicas de Lectura',
        'ca': 'Pràctiques i Tècniques de Lectura',
      },
      subtitle: {
        'en': 'From preparation to interpretation',
        'es': 'De la preparación a la interpretación',
        'ca': 'De la preparació a la interpretació',
      },
      description: {
        'en':
            'Learn practical reading skills: preparing for readings, shuffling methods, reading for yourself vs others, balancing intuition and knowledge, working with reversals, and recording your insights.',
        'es':
            'Aprende habilidades prácticas de lectura: preparación para lecturas, métodos de barajar, lectura para ti mismo vs otros, equilibrar intuición y conocimiento, trabajar con reversas y registrar tus percepciones.',
        'ca':
            'Aprèn habilitats pràctiques de lectura: preparació per lectures, mètodes de barrejar, lectura per tu mateix vs altres, equilibrar intuïció i coneixement, treballar amb inverses i registrar les teves percepcions.',
      },
      color: '#06B6D4', // Cyan
      lessonCount: 8,
      lessonIds: [
        'practices_1',
        'practices_2',
        'practices_3',
        'practices_4',
        'practices_5',
        'practices_6',
        'practices_7',
        'practices_8',
      ],
    ),

    // CATEGORY 6: Sacred Space & Rituals
    const WisdomTraditionCategory(
      id: 'sacred_rituals',
      icon: '⭐',
      title: {
        'en': 'Sacred Space & Rituals',
        'es': 'Espacio Sagrado y Rituales',
        'ca': 'Espai Sagrat i Rituals',
      },
      subtitle: {
        'en': 'Creating meaningful practice',
        'es': 'Creando práctica significativa',
        'ca': 'Creant pràctica significativa',
      },
      description: {
        'en':
            'Create your personal tarot practice. Learn to set up sacred space, care for your deck, develop opening and closing rituals, align with moon phases, and build meaningful traditions.',
        'es':
            'Crea tu práctica personal de tarot. Aprende a configurar espacio sagrado, cuidar tu baraja, desarrollar rituales de apertura y cierre, alinearte con las fases lunares y construir tradiciones significativas.',
        'ca':
            'Crea la teva pràctica personal de tarot. Aprèn a configurar espai sagrat, cuidar la teva baralla, desenvolupar rituals d\'obertura i tancament, alinear-te amb les fases lunars i construir tradicions significatives.',
      },
      color: '#EC4899', // Pink
      lessonCount: 6,
      lessonIds: [
        'rituals_1',
        'rituals_2',
        'rituals_3',
        'rituals_4',
        'rituals_5',
        'rituals_6',
      ],
    ),
  ];

  // ============================================================================
  // LESSONS (Placeholder structure - will be populated with full content)
  // ============================================================================

  static final List<WisdomLesson> lessons = [
    // NOTE: This is just the structure. Full content will be added phase by phase.
    // For now, we'll create placeholder lessons for testing the UI.

    // CATEGORY 1: Origins & History (8 lessons)
    const WisdomLesson(
      id: 'origins_1',
      categoryId: 'origins_history',
      order: 1,
      icon: '🎴',
      title: {
        'en': 'The Playing Card Origins (15th Century)',
        'es': 'Los Orígenes de las Cartas (Siglo XV)',
        'ca': 'Els Orígens de les Cartes (Segle XV)',
      },
      subtitle: {
        'en': 'From Italian courts to tarot traditions',
        'es': 'De las cortes italianas a las tradiciones del tarot',
        'ca': 'De les corts italianes a les tradicions del tarot',
      },
      content: {
        'en': '''# The Playing Card Origins (15th Century)

## Introduction

The story of tarot begins not in mystical temples or occult societies, but in the Renaissance courts of northern Italy. In the mid-15th century, wealthy families commissioned beautifully hand-painted card decks for a game called "tarocchi" or "trionfi" (triumphs). These were not tools of divination, but luxury playing cards that would eventually evolve into the tarot we know today.

## The Birth of Tarocchi

Around 1440, in the courts of Milan, Ferrara, and Bologna, a new type of card deck appeared. Standard playing cards (similar to modern playing cards with four suits) had already existed in Europe since the late 14th century, likely imported from the Islamic world via trade routes. But Italian nobles wanted something more elaborate—something that would display their wealth, education, and cultural sophistication.

The innovation was simple but significant: in addition to the four suited cards (similar to Cups, Coins, Swords, and Batons), artists added a fifth suit of 21 permanent trump cards plus one special card called "The Fool." These trump cards depicted allegorical images: virtues, planets, social roles, and religious themes. Together with the original four suits, this created a 78-card deck.

## The Visconti-Sforza Decks

The oldest surviving tarot decks are the Visconti-Sforza decks, commissioned by the Duke of Milan and painted by renowned artists like Bonifacio Bembo around 1450. These hand-painted masterpieces on gold-leaf backgrounds were status symbols, commissioned for weddings and celebrations.

The imagery on these early cards reflected the worldview of Renaissance Italy: religious figures (The Pope, The Popess), virtues (Temperance, Justice, Fortitude), celestial bodies (The Sun, The Moon, The Star), social classes (The Emperor, The Empress), and allegorical concepts (The Wheel of Fortune, Death, The World).

## Tarot as a Game

For the next 300 years, tarot remained primarily a game—a sophisticated trick-taking game similar to bridge, played throughout France, Italy, Switzerland, and parts of Germany. Different regions developed their own variations: the French "Tarot de Marseille," the Italian "Tarocco Piemontese," the Swiss "1JJ" deck.

The game was purely recreational. There is no historical evidence of tarot being used for divination before the late 18th century. This is a critical fact often obscured by modern misconceptions about tarot's "ancient origins."

## Key Distinctions

It's important to understand what tarot was NOT in the 15th-16th centuries:

- NOT Egyptian: Claims of Egyptian origins are 19th-century inventions
- NOT Kabbalistic: Jewish mysticism connections came much later
- NOT occult: The cards had no association with magic or fortune-telling
- NOT ancient: Tarot is a Renaissance creation, not prehistoric

The cards depicted common Renaissance themes—Christian imagery, classical virtues, astrological symbols—all familiar to educated Europeans of the time.

## The Evolution Begins

By the 1700s, the Tarot de Marseille had become the dominant pattern, especially in France. It was a woodblock-printed, mass-produced deck (no longer hand-painted luxury items) used widely for gaming. This standardized structure—22 Major Arcana and 56 Minor Arcana—would become the template for nearly all future tarot decks.

But it wasn't until the late 18th century that French occultists began to look at these gaming cards and imagine esoteric meanings hidden within them. That transformation—from game to spiritual tool—is the subject of later lessons.

## Conclusion

Understanding tarot's mundane origins as luxury playing cards grounds us in historical reality. The tarot was not handed down from ancient priests or mystical sages. It was created by Italian artists and cardmakers for entertainment. This doesn't diminish its spiritual power today—rather, it shows how human creativity, art, and cultural meaning-making can transform simple objects into profound tools for insight.

The cards' longevity and evolution from game to divination tool is a testament to their rich symbolic vocabulary and archetypal power—qualities that were inherent in the Renaissance imagery from the very beginning.
''',
        'es': '''# Los Orígenes de las Cartas (Siglo XV)

[Full Spanish translation would go here - same structure and length]
''',
        'ca': '''# Els Orígens de les Cartes (Segle XV)

[Full Catalan translation would go here - same structure and length]
''',
      },
      keyPoints: {
        'en': [
          'Tarot originated in 15th-century Italian Renaissance courts as luxury playing cards',
          'The game was called "tarocchi" or "trionfi" (triumphs)',
          'The 78-card structure: 56 suited cards + 21 trumps + The Fool',
          'Oldest surviving decks: Visconti-Sforza (c.1450), hand-painted for nobility',
          'Used exclusively as a game for 300+ years—not for divination',
          'Claims of Egyptian, Kabbalistic, or ancient occult origins are false',
          'Tarot de Marseille became the standardized pattern by the 1700s',
          'The transformation to spiritual tool came in the late 18th century',
        ],
        'es': [
          'El tarot se originó en las cortes del Renacimiento italiano del siglo XV como naipes de lujo',
          'El juego se llamaba "tarocchi" o "trionfi" (triunfos)',
          'La estructura de 78 cartas: 56 cartas de palo + 21 triunfos + El Loco',
          'Mazos más antiguos: Visconti-Sforza (c.1450), pintados a mano para la nobleza',
          'Usado exclusivamente como juego durante más de 300 años—no para adivinación',
          'Las afirmaciones de orígenes egipcios, cabalísticos u ocultos antiguos son falsas',
          'El Tarot de Marsella se convirtió en el patrón estandarizado en el siglo XVIII',
          'La transformación a herramienta espiritual llegó a finales del siglo XVIII',
        ],
        'ca': [
          'El tarot es va originar a les corts del Renaixement italià del segle XV com a naips de luxe',
          'El joc es deia "tarocchi" o "trionfi" (triomfs)',
          'L\'estructura de 78 cartes: 56 cartes de pal + 21 triomfs + El Boig',
          'Baralles més antigues: Visconti-Sforza (c.1450), pintades a mà per la noblesa',
          'Usat exclusivament com a joc durant més de 300 anys—no per endevinació',
          'Les afirmacions d\'orígens egipcis, cabalístics o ocultes antics són falses',
          'El Tarot de Marsella es va convertir en el patró estandarditzat al segle XVIII',
          'La transformació a eina espiritual va arribar a finals del segle XVIII',
        ],
      },
      traditions: {
        'en': [
          'Dummett, Michael. "The Game of Tarot" (1980) - Authoritative history',
          'Kaplan, Stuart R. "The Encyclopedia of Tarot, Vol. 1" (1978)',
          'Place, Robert M. "The Tarot: History, Symbolism, and Divination" (2005)',
        ],
        'es': [
          'Dummett, Michael. "The Game of Tarot" (1980) - Historia autorizada',
          'Kaplan, Stuart R. "The Encyclopedia of Tarot, Vol. 1" (1978)',
          'Place, Robert M. "The Tarot: History, Symbolism, and Divination" (2005)',
        ],
        'ca': [
          'Dummett, Michael. "The Game of Tarot" (1980) - Història autoritzada',
          'Kaplan, Stuart R. "The Encyclopedia of Tarot, Vol. 1" (1978)',
          'Place, Robert M. "The Tarot: History, Symbolism, and Divination" (2005)',
        ],
      },
      furtherReading: {
        'en': [
          'Visit museums with Visconti-Sforza cards: Pierpont Morgan Library, Accademia Carrara',
          'Read "A Wicked Pack of Cards" by Decker, Depaulis, and Dummett',
          'Explore the International Playing Card Society archives',
        ],
        'es': [
          'Visita museos con cartas Visconti-Sforza: Pierpont Morgan Library, Accademia Carrara',
          'Lee "A Wicked Pack of Cards" de Decker, Depaulis y Dummett',
          'Explora los archivos de la Sociedad Internacional de Naipes',
        ],
        'ca': [
          'Visita museus amb cartes Visconti-Sforza: Pierpont Morgan Library, Accademia Carrara',
          'Llegeix "A Wicked Pack of Cards" de Decker, Depaulis i Dummett',
          'Explora els arxius de la Societat Internacional de Naips',
        ],
      },
      estimatedMinutes: 10,
      difficulty: 'beginner',
    ),

    // Origins lessons 2-3: Complete content
    ...WisdomLessonsOrigins.getAllLessons(),

    // Origins lessons 4-8: Placeholders (to be written)
    ...List.generate(5, (index) {
      final lessonNum = index + 4;
      return WisdomLesson(
        id: 'origins_$lessonNum',
        categoryId: 'origins_history',
        order: lessonNum,
        icon: '📜',
        title: {
          'en': 'Origins Lesson $lessonNum (Coming Soon)',
          'es': 'Lección de Orígenes $lessonNum (Próximamente)',
          'ca': 'Lliçó d\'Orígens $lessonNum (Properament)',
        },
        subtitle: {
          'en': 'Content in development',
          'es': 'Contenido en desarrollo',
          'ca': 'Contingut en desenvolupament',
        },
        content: {
          'en': 'Full content coming soon.',
          'es': 'Contenido completo próximamente.',
          'ca': 'Contingut complet properament.',
        },
        keyPoints: {
          'en': ['Content in development'],
          'es': ['Contenido en desarrollo'],
          'ca': ['Contingut en desenvolupament'],
        },
        traditions: {
          'en': ['To be added'],
          'es': ['Por añadir'],
          'ca': ['Per afegir'],
        },
        estimatedMinutes: 10,
        difficulty: 'beginner',
      );
    }),

    // Placeholders for other categories
    ...List.generate(6, (catIndex) {
      final categoryIds = [
        'ethics_practice',
        'traditional_systems',
        'symbolism_archetypes',
        'reading_practices',
        'sacred_rituals'
      ];
      final lessonCounts = [6, 5, 10, 8, 6];

      if (catIndex >= categoryIds.length) return null;

      final categoryId = categoryIds[catIndex];
      final count = lessonCounts[catIndex];
      final prefix = categoryId.split('_')[0];

      return List.generate(count, (index) {
        final lessonNum = index + 1;
        return WisdomLesson(
          id: '${prefix}_$lessonNum',
          categoryId: categoryId,
          order: lessonNum,
          icon: '📚',
          title: {
            'en': '${categoryId.replaceAll('_', ' ').toUpperCase()} Lesson $lessonNum (Coming Soon)',
            'es': 'Lección $lessonNum (Próximamente)',
            'ca': 'Lliçó $lessonNum (Properament)',
          },
          subtitle: {
            'en': 'Content in development',
            'es': 'Contenido en desarrollo',
            'ca': 'Contingut en desenvolupament',
          },
          content: {
            'en': 'Full content coming soon.',
            'es': 'Contenido completo próximamente.',
            'ca': 'Contingut complet properament.',
          },
          keyPoints: {
            'en': ['Content in development'],
            'es': ['Contenido en desarrollo'],
            'ca': ['Contingut en desenvolupament'],
          },
          traditions: {
            'en': ['To be added'],
            'es': ['Por añadir'],
            'ca': ['Per afegir'],
          },
          estimatedMinutes: 10,
          difficulty: 'beginner',
        );
      });
    }).whereType<List<WisdomLesson>>().expand((list) => list),
  ];

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get category by ID
  static WisdomTraditionCategory? getCategoryById(String id) {
    try {
      return categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get lesson by ID
  static WisdomLesson? getLessonById(String id) {
    try {
      return lessons.firstWhere((lesson) => lesson.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get all lessons for a category
  static List<WisdomLesson> getLessonsForCategory(String categoryId) {
    return lessons.where((lesson) => lesson.categoryId == categoryId).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  /// Get total lesson count
  static int get totalLessons => lessons.length;

  /// Get total category count
  static int get totalCategories => categories.length;

  /// Get journey metadata
  static WisdomTraditionJourney getJourney() {
    return const WisdomTraditionJourney();
  }

  /// Get next lesson in sequence
  static WisdomLesson? getNextLesson(String currentLessonId) {
    final current = getLessonById(currentLessonId);
    if (current == null) return null;

    final categoryLessons = getLessonsForCategory(current.categoryId);
    final currentIndex =
        categoryLessons.indexWhere((l) => l.id == currentLessonId);

    if (currentIndex < 0) return null;

    // Next lesson in same category
    if (currentIndex < categoryLessons.length - 1) {
      return categoryLessons[currentIndex + 1];
    }

    // First lesson of next category
    final currentCatIndex =
        categories.indexWhere((c) => c.id == current.categoryId);
    if (currentCatIndex < 0 || currentCatIndex >= categories.length - 1) {
      return null; // Last lesson overall
    }

    final nextCategory = categories[currentCatIndex + 1];
    final nextCategoryLessons = getLessonsForCategory(nextCategory.id);
    return nextCategoryLessons.isNotEmpty ? nextCategoryLessons.first : null;
  }

  /// Get previous lesson in sequence
  static WisdomLesson? getPreviousLesson(String currentLessonId) {
    final current = getLessonById(currentLessonId);
    if (current == null) return null;

    final categoryLessons = getLessonsForCategory(current.categoryId);
    final currentIndex =
        categoryLessons.indexWhere((l) => l.id == currentLessonId);

    if (currentIndex < 0) return null;

    // Previous lesson in same category
    if (currentIndex > 0) {
      return categoryLessons[currentIndex - 1];
    }

    // Last lesson of previous category
    final currentCatIndex =
        categories.indexWhere((c) => c.id == current.categoryId);
    if (currentCatIndex <= 0) {
      return null; // First lesson overall
    }

    final prevCategory = categories[currentCatIndex - 1];
    final prevCategoryLessons = getLessonsForCategory(prevCategory.id);
    return prevCategoryLessons.isNotEmpty ? prevCategoryLessons.last : null;
  }
}
