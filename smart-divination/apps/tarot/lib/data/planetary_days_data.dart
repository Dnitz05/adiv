import '../models/planetary_day.dart';

/// Repository for Planetary Days wisdom
/// Based on Chaldean Order and traditional astrological correspondences
/// Source: planetary_weekday_correspondences.md
class PlanetaryDaysData {
  static const List<PlanetaryDay> days = [
    // Sunday - Sun
    PlanetaryDay(
      id: 'sunday',
      weekday: 'sunday',
      planet: 'Sun',
      icon: '🌞',
      localizedNames: {
        'en': 'Sunday',
        'es': 'Domingo',
        'ca': 'Diumenge',
      },
      element: 'Fire',
      themes: {
        'en': 'Vitality, Identity, Creativity, Leadership',
        'es': 'Vitalidad, Identidad, Creatividad, Liderazgo',
        'ca': 'Vitalitat, Identitat, Creativitat, Lideratge',
      },
      activities: {
        'en': [
          'Rituals to increase personal confidence',
          'Work to gain recognition',
          'Plan important projects',
          'Connect with life purpose',
          'Artistic creativity',
        ],
        'es': [
          'Rituales para aumentar la confianza personal',
          'Trabajos para obtener reconocimiento',
          'Planificar proyectos importantes',
          'Conectar con el propósito vital',
          'Creatividad artística',
        ],
        'ca': [
          'Rituals per augmentar la confiança personal',
          'Treballs per obtenir reconeixement',
          'Planificar projectes importants',
          'Connectar amb el propòsit vital',
          'Creativitat artística',
        ],
      },
      qualities: {
        'en': [
          'Vital energy and life force',
          'Ego and self-expression',
          'Authority and leadership',
          'Purpose and direction',
          'Radiant creativity',
        ],
        'es': [
          'Energía vital y fuerza de vida',
          'Ego y auto-expresión',
          'Autoridad y liderazgo',
          'Propósito y dirección',
          'Creatividad radiante',
        ],
        'ca': [
          'Energia vital i força de vida',
          'Ego i auto-expressió',
          'Autoritat i lideratge',
          'Propòsit i direcció',
          'Creativitat radiant',
        ],
      },
      color: '#FFD700', // Gold
      tarotCard: 'The Sun',
      tarotNumber: 19,
      description: {
        'en': 'Sunday is ruled by the Sun, representing vital force, identity and radiant creativity. This is the day of the conscious self, personal power and life purpose. The Sun brings clarity, confidence and recognition. It\'s a powerful day for setting intentions and connecting with your authentic expression.',
        'es': 'El domingo está regido por el Sol, representando la fuerza vital, la identidad y la creatividad radiante. Es el día del yo consciente, el poder personal y el propósito de vida. El Sol trae claridad, confianza y reconocimiento. Es un día poderoso para establecer intenciones y conectar con tu expresión auténtica.',
        'ca': 'El diumenge està regit pel Sol, representant la força vital, la identitat i la creativitat radiant. És el dia del jo conscient, el poder personal i el propòsit de vida. El Sol porta claredat, confiança i reconeixement. És un dia poderós per establir intencions i connectar amb la teva expressió autèntica.',
      },
      energyDescription: {
        'en': 'Hot, Dry, Yang. The energy of Sunday is radiant, expansive and life-affirming.',
        'es': 'Caliente, Seco, Yang. La energía del domingo es radiante, expansiva y afirmadora de vida.',
        'ca': 'Calor, Sec, Yang. L\'energia del diumenge és radiant, expansiva i afirmadora de vida.',
      },
    ),

    // Monday - Moon
    PlanetaryDay(
      id: 'monday',
      weekday: 'monday',
      planet: 'Moon',
      icon: '🌙',
      localizedNames: {
        'en': 'Monday',
        'es': 'Lunes',
        'ca': 'Dilluns',
      },
      element: 'Water',
      themes: {
        'en': 'Emotions, Intuition, Memory, Nurturing',
        'es': 'Emociones, Intuición, Memoria, Nutrición',
        'ca': 'Emocions, Intuïció, Memòria, Nutrició',
      },
      activities: {
        'en': [
          'Work with dreams and intuition',
          'Emotional cleansing rituals',
          'Connect with family and roots',
          'Meditation and introspection',
          'Divination (tarot, oracles)',
        ],
        'es': [
          'Trabajar con sueños e intuición',
          'Rituales de limpieza emocional',
          'Conectar con familia y raíces',
          'Meditación e introspección',
          'Adivinación (tarot, oráculos)',
        ],
        'ca': [
          'Treballar amb somnis i intuïció',
          'Rituals de neteja emocional',
          'Connectar amb família i arrels',
          'Meditació i introspeccio',
          'Endevinació (tarot, oracles)',
        ],
      },
      qualities: {
        'en': [
          'Emotions and feelings',
          'Intuition and psychic perception',
          'Memory and past',
          'Nurturing and care',
          'Cycles and rhythms',
        ],
        'es': [
          'Emociones y sentimientos',
          'Intuición y percepción psíquica',
          'Memoria y pasado',
          'Nutrición y cuidado',
          'Ciclos y ritmos',
        ],
        'ca': [
          'Emocions i sentiments',
          'Intuïció i percepció psíquica',
          'Memòria i passat',
          'Nutrició i cura',
          'Cicles i ritmes',
        ],
      },
      color: '#C0C0C0', // Silver
      tarotCard: 'The Moon',
      tarotNumber: 18,
      description: {
        'en': 'Monday is ruled by the Moon, governing emotions, intuition and the inner world. This is the day of the soul, dreams and psychic perception. The Moon connects us with our emotional depths, family roots and the rhythms of nature. It\'s a powerful day for divination, emotional healing and connecting with your intuition.',
        'es': 'El lunes está regido por la Luna, gobernando las emociones, la intuición y el mundo interior. Es el día del alma, los sueños y la percepción psíquica. La Luna nos conecta con nuestras profundidades emocionales, raíces familiares y los ritmos de la naturaleza. Es un día poderoso para la adivinación, sanación emocional y conectar con tu intuición.',
        'ca': 'El dilluns està regit per la Lluna, governant les emocions, la intuïció i el món interior. És el dia de l\'ànima, els somnis i la percepció psíquica. La Lluna ens connecta amb les nostres profunditats emocionals, arrels familiars i els ritmes de la natura. És un dia poderós per a l\'endevinació, sanació emocional i connectar amb la teva intuïció.',
      },
      energyDescription: {
        'en': 'Cold, Moist, Yin. The energy of Monday is receptive, flowing and emotionally deep.',
        'es': 'Frío, Húmedo, Yin. La energía del lunes es receptiva, fluida y emocionalmente profunda.',
        'ca': 'Fred, Humit, Yin. L\'energia del dilluns és receptiva, fluida i emocionalment profunda.',
      },
    ),

    // Tuesday - Mars
    PlanetaryDay(
      id: 'tuesday',
      weekday: 'tuesday',
      planet: 'Mars',
      icon: '♂️',
      localizedNames: {
        'en': 'Tuesday',
        'es': 'Martes',
        'ca': 'Dimarts',
      },
      element: 'Fire',
      themes: {
        'en': 'Action, Courage, Passion, Independence',
        'es': 'Acción, Coraje, Pasión, Independencia',
        'ca': 'Acció, Coratge, Passió, Independència',
      },
      activities: {
        'en': [
          'Rituals to increase courage',
          'Establish boundaries and say "no"',
          'Start projects requiring action',
          'Intense physical exercise',
          'Defend against injustice',
        ],
        'es': [
          'Rituales para aumentar el coraje',
          'Establecer límites y decir "no"',
          'Comenzar proyectos que requieren acción',
          'Ejercicio físico intenso',
          'Defender contra la injusticia',
        ],
        'ca': [
          'Rituals per augmentar el coratge',
          'Establir límits i dir "no"',
          'Començar projectes que requereixen acció',
          'Exercici físic intens',
          'Defensar-se d\'injustícies',
        ],
      },
      qualities: {
        'en': [
          'Action and initiative',
          'Courage and bravery',
          'Conflict and competition',
          'Passion and desire',
          'Independence and self-defense',
        ],
        'es': [
          'Acción e iniciativa',
          'Coraje y valentía',
          'Conflicto y competición',
          'Pasión y deseo',
          'Independencia y autodefensa',
        ],
        'ca': [
          'Acció i iniciativa',
          'Coratge i bravura',
          'Conflicte i competició',
          'Passió i desig',
          'Independència i autodefensa',
        ],
      },
      color: '#DC143C', // Crimson red
      tarotCard: 'The Tower',
      tarotNumber: 16,
      description: {
        'en': 'Tuesday is ruled by Mars, the planet of action, courage and warrior energy. This is the day of kinetic force, passion and assertiveness. Mars gives us the strength to take action, defend our boundaries and pursue our desires. It\'s a powerful day for beginning projects that require bold action and facing challenges with courage.',
        'es': 'El martes está regido por Marte, el planeta de la acción, el coraje y la energía guerrera. Es el día de la fuerza cinética, la pasión y la asertividad. Marte nos da la fuerza para tomar acción, defender nuestros límites y perseguir nuestros deseos. Es un día poderoso para comenzar proyectos que requieren acción audaz y enfrentar desafíos con coraje.',
        'ca': 'El dimarts està regit per Mart, el planeta de l\'acció, el coratge i l\'energia guerrera. És el dia de la força cinètica, la passió i l\'assertivitat. Mart ens dóna la força per prendre acció, defensar els nostres límits i perseguir els nostres desigs. És un dia poderós per començar projectes que requereixen acció audaç i enfrontar desafiaments amb coratge.',
      },
      energyDescription: {
        'en': 'Hot, Dry, Yang. The energy of Tuesday is active, assertive and dynamic.',
        'es': 'Caliente, Seco, Yang. La energía del martes es activa, asertiva y dinámica.',
        'ca': 'Calor, Sec, Yang. L\'energia del dimarts és activa, assertiva i dinàmica.',
      },
    ),

    // Wednesday - Mercury
    PlanetaryDay(
      id: 'wednesday',
      weekday: 'wednesday',
      planet: 'Mercury',
      icon: '☿',
      localizedNames: {
        'en': 'Wednesday',
        'es': 'Miércoles',
        'ca': 'Dimecres',
      },
      element: 'Air',
      themes: {
        'en': 'Communication, Intelligence, Learning, Commerce',
        'es': 'Comunicación, Inteligencia, Aprendizaje, Comercio',
        'ca': 'Comunicació, Intel·ligència, Aprenentatge, Comerç',
      },
      activities: {
        'en': [
          'Writing, studying, teaching',
          'Negotiations and contracts',
          'Start courses or classes',
          'Social networking',
          'Organize information',
        ],
        'es': [
          'Escribir, estudiar, enseñar',
          'Negociaciones y contratos',
          'Comenzar cursos o clases',
          'Networking social',
          'Organizar información',
        ],
        'ca': [
          'Escriure, estudiar, ensenyar',
          'Negociacions i contractes',
          'Començar cursos o classes',
          'Networking social',
          'Organitzar informació',
        ],
      },
      qualities: {
        'en': [
          'Communication and language',
          'Intellect and reasoning',
          'Learning and education',
          'Commerce and business',
          'Short journeys',
        ],
        'es': [
          'Comunicación y lenguaje',
          'Intelecto y razonamiento',
          'Aprendizaje y educación',
          'Comercio y negocios',
          'Viajes cortos',
        ],
        'ca': [
          'Comunicació i llenguatge',
          'Intel·lecte i raonament',
          'Aprenentatge i educació',
          'Comerç i negocis',
          'Viatges curts',
        ],
      },
      color: '#FF8C00', // Dark orange
      tarotCard: 'The Magician',
      tarotNumber: 1,
      description: {
        'en': 'Wednesday is ruled by Mercury, the messenger of the gods and planet of communication. This is the day of the mind, intellect and exchange of information. Mercury favors writing, learning, negotiation and all forms of communication. It\'s a powerful day for studying, teaching, signing contracts and making connections.',
        'es': 'El miércoles está regido por Mercurio, el mensajero de los dioses y planeta de la comunicación. Es el día de la mente, el intelecto y el intercambio de información. Mercurio favorece la escritura, el aprendizaje, la negociación y todas las formas de comunicación. Es un día poderoso para estudiar, enseñar, firmar contratos y hacer conexiones.',
        'ca': 'El dimecres està regit per Mercuri, el missatger dels déus i planeta de la comunicació. És el dia de la ment, l\'intel·lecte i l\'intercanvi d\'informació. Mercuri afavoreix l\'escriptura, l\'aprenentatge, la negociació i totes les formes de comunicació. És un dia poderós per estudiar, ensenyar, signar contractes i fer connexions.',
      },
      energyDescription: {
        'en': 'Neutral, Adaptable. The energy of Wednesday is quick, versatile and communicative.',
        'es': 'Neutro, Adaptable. La energía del miércoles es rápida, versátil y comunicativa.',
        'ca': 'Neutre, Adaptable. L\'energia del dimecres és ràpida, versàtil i comunicativa.',
      },
    ),

    // Thursday - Jupiter
    PlanetaryDay(
      id: 'thursday',
      weekday: 'thursday',
      planet: 'Jupiter',
      icon: '♃',
      localizedNames: {
        'en': 'Thursday',
        'es': 'Jueves',
        'ca': 'Dijous',
      },
      element: 'Fire',
      themes: {
        'en': 'Expansion, Wisdom, Justice, Generosity',
        'es': 'Expansión, Sabiduría, Justicia, Generosidad',
        'ca': 'Expansió, Saviesa, Justícia, Generositat',
      },
      activities: {
        'en': [
          'Rituals to attract abundance',
          'Begin higher education',
          'Plan long journeys',
          'Gratitude rituals',
          'Seek guidance from teachers',
        ],
        'es': [
          'Rituales para atraer abundancia',
          'Comenzar educación superior',
          'Planificar viajes largos',
          'Rituales de gratitud',
          'Buscar guía de maestros',
        ],
        'ca': [
          'Rituals per atraure abundància',
          'Començar educació superior',
          'Planificar viatges llargs',
          'Rituals de gratitud',
          'Cercar guia de mestres',
        ],
      },
      qualities: {
        'en': [
          'Expansion and growth',
          'Wisdom and philosophy',
          'Justice and law',
          'Generosity and kindness',
          'Faith and hope',
        ],
        'es': [
          'Expansión y crecimiento',
          'Sabiduría y filosofía',
          'Justicia y ley',
          'Generosidad y bondad',
          'Fe y esperanza',
        ],
        'ca': [
          'Expansió i creixement',
          'Saviesa i filosofia',
          'Justícia i llei',
          'Generositat i bondat',
          'Fe i esperança',
        ],
      },
      color: '#4B0082', // Indigo/Purple
      tarotCard: 'Wheel of Fortune',
      tarotNumber: 10,
      description: {
        'en': 'Thursday is ruled by Jupiter, the king of the gods and planet of expansion. This is the day of growth, abundance and higher wisdom. Jupiter brings opportunities, optimism and benevolence. It\'s a powerful day for attracting prosperity, beginning studies, expressing gratitude and connecting with philosophical or spiritual teachings.',
        'es': 'El jueves está regido por Júpiter, el rey de los dioses y planeta de la expansión. Es el día del crecimiento, la abundancia y la sabiduría superior. Júpiter trae oportunidades, optimismo y benevolencia. Es un día poderoso para atraer prosperidad, comenzar estudios, expresar gratitud y conectar con enseñanzas filosóficas o espirituales.',
        'ca': 'El dijous està regit per Júpiter, el rei dels déus i planeta de l\'expansió. És el dia del creixement, l\'abundància i la saviesa superior. Júpiter porta oportunitats, optimisme i benevolència. És un dia poderós per atraure prosperitat, començar estudis, expressar gratitud i connectar amb ensenyaments filosòfics o espirituals.',
      },
      energyDescription: {
        'en': 'Hot, Moist. The energy of Thursday is expansive, generous and optimistic.',
        'es': 'Caliente, Húmedo. La energía del jueves es expansiva, generosa y optimista.',
        'ca': 'Calor, Humit. L\'energia del dijous és expansiva, generosa i optimista.',
      },
    ),

    // Friday - Venus
    PlanetaryDay(
      id: 'friday',
      weekday: 'friday',
      planet: 'Venus',
      icon: '♀',
      localizedNames: {
        'en': 'Friday',
        'es': 'Viernes',
        'ca': 'Divendres',
      },
      element: 'Earth & Water',
      themes: {
        'en': 'Love, Beauty, Pleasure, Harmony',
        'es': 'Amor, Belleza, Placer, Armonía',
        'ca': 'Amor, Bellesa, Plaer, Harmonia',
      },
      activities: {
        'en': [
          'Love and attraction rituals',
          'Create beauty (art, music)',
          'Self-care and spa',
          'Socialize with friends',
          'Buy clothing or jewelry',
          'Plant flowers',
        ],
        'es': [
          'Rituales de amor y atracción',
          'Crear belleza (arte, música)',
          'Cuidado personal y spa',
          'Socializar con amigos',
          'Comprar ropa o joyas',
          'Plantar flores',
        ],
        'ca': [
          'Rituals d\'amor i atracció',
          'Crear bellesa (art, música)',
          'Cura personal i spa',
          'Socialitzar amb amics',
          'Comprar ropa o joies',
          'Plantar flors',
        ],
      },
      qualities: {
        'en': [
          'Love and relationships',
          'Beauty and aesthetics',
          'Pleasure and enjoyment',
          'Values and money',
          'Peace and harmony',
        ],
        'es': [
          'Amor y relaciones',
          'Belleza y estética',
          'Placer y disfrute',
          'Valores y dinero',
          'Paz y armonía',
        ],
        'ca': [
          'Amor i relacions',
          'Bellesa i estètica',
          'Plaer i gaudiment',
          'Valors i diners',
          'Pau i harmonia',
        ],
      },
      color: '#FF69B4', // Hot pink
      tarotCard: 'The Empress',
      tarotNumber: 3,
      description: {
        'en': 'Friday is ruled by Venus, the goddess of love and beauty. This is the day of relationships, pleasure and aesthetic harmony. Venus favors romance, art, socializing and self-care. It\'s a powerful day for love rituals, creating beauty, enjoying sensory pleasures and cultivating harmony in relationships.',
        'es': 'El viernes está regido por Venus, la diosa del amor y la belleza. Es el día de las relaciones, el placer y la armonía estética. Venus favorece el romance, el arte, la socialización y el cuidado personal. Es un día poderoso para rituales de amor, crear belleza, disfrutar placeres sensoriales y cultivar armonía en las relaciones.',
        'ca': 'El divendres està regit per Venus, la deessa de l\'amor i la bellesa. És el dia de les relacions, el plaer i l\'harmonia estètica. Venus afavoreix el romanç, l\'art, la socialització i la cura personal. És un dia poderós per rituals d\'amor, crear bellesa, gaudir de plaers sensorials i cultivar harmonia en les relacions.',
      },
      energyDescription: {
        'en': 'Cold, Moist, Yin. The energy of Friday is loving, harmonious and pleasure-seeking.',
        'es': 'Frío, Húmedo, Yin. La energía del viernes es amorosa, armoniosa y buscadora de placer.',
        'ca': 'Fred, Humit, Yin. L\'energia del divendres és amorosa, harmoniosa i cercadora de plaer.',
      },
    ),

    // Saturday - Saturn
    PlanetaryDay(
      id: 'saturday',
      weekday: 'saturday',
      planet: 'Saturn',
      icon: '♄',
      localizedNames: {
        'en': 'Saturday',
        'es': 'Sábado',
        'ca': 'Dissabte',
      },
      element: 'Earth',
      themes: {
        'en': 'Structure, Discipline, Time, Responsibility',
        'es': 'Estructura, Disciplina, Tiempo, Responsabilidad',
        'ca': 'Estructura, Disciplina, Temps, Responsabilitat',
      },
      activities: {
        'en': [
          'Long-term planning',
          'Organization and deep cleaning',
          'Establish healthy boundaries',
          'Work with ancestors',
          'Meditation on life lessons',
          'Complete old projects',
        ],
        'es': [
          'Planificación a largo plazo',
          'Organización y limpieza profunda',
          'Establecer límites saludables',
          'Trabajar con ancestros',
          'Meditación sobre lecciones de vida',
          'Completar proyectos antiguos',
        ],
        'ca': [
          'Planificació a llarg termini',
          'Organització i neteja profunda',
          'Establir límits saludables',
          'Treballar amb avantpassats',
          'Meditació sobre lliçons de vida',
          'Completar projectes antics',
        ],
      },
      qualities: {
        'en': [
          'Structure and discipline',
          'Limits and boundaries',
          'Responsibility and duty',
          'Time and aging',
          'Wisdom of experience',
        ],
        'es': [
          'Estructura y disciplina',
          'Límites y fronteras',
          'Responsabilidad y deber',
          'Tiempo y envejecimiento',
          'Sabiduría de la experiencia',
        ],
        'ca': [
          'Estructura i disciplina',
          'Límits i fronteres',
          'Responsabilitat i deure',
          'Temps i envelliment',
          'Saviesa de l\'experiència',
        ],
      },
      color: '#2F4F4F', // Dark slate gray
      tarotCard: 'The World',
      tarotNumber: 21,
      description: {
        'en': 'Saturday is ruled by Saturn, the god of time and karmic teacher. This is the day of structure, discipline and mature wisdom. Saturn brings necessary limitations, long-term planning and lessons learned through experience. It\'s a powerful day for organization, completing unfinished business, honoring elders and ancestors, and reflecting on life\'s deeper lessons.',
        'es': 'El sábado está regido por Saturno, el dios del tiempo y maestro kármico. Es el día de la estructura, la disciplina y la sabiduría madura. Saturno trae limitaciones necesarias, planificación a largo plazo y lecciones aprendidas a través de la experiencia. Es un día poderoso para la organización, completar asuntos pendientes, honrar a los ancianos y ancestros, y reflexionar sobre las lecciones más profundas de la vida.',
        'ca': 'El dissabte està regit per Saturn, el déu del temps i mestre kàrmic. És el dia de l\'estructura, la disciplina i la saviesa madura. Saturn porta limitacions necessàries, planificació a llarg termini i lliçons apreses a través de l\'experiència. És un dia poderós per a l\'organització, completar assumptes pendents, honrar els ancians i avantpassats, i reflexionar sobre les lliçons més profundes de la vida.',
      },
      energyDescription: {
        'en': 'Cold, Dry, Yin. The energy of Saturday is grounding, structured and reflective.',
        'es': 'Frío, Seco, Yin. La energía del sábado es arraigadora, estructurada y reflexiva.',
        'ca': 'Fred, Sec, Yin. L\'energia del dissabte és arreladora, estructurada i reflexiva.',
      },
    ),
  ];

  /// Get day by ID
  static PlanetaryDay? getDayById(String id) {
    try {
      return days.firstWhere((day) => day.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get day by weekday name
  static PlanetaryDay? getDayByWeekday(String weekday) {
    try {
      return days.firstWhere((day) => day.weekday == weekday.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  /// Get today's planetary day
  static PlanetaryDay getTodaysPlanetaryDay() {
    final now = DateTime.now();
    // DateTime.weekday: Monday = 1, Sunday = 7
    // Convert to our weekday names
    final weekdayNames = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    final weekdayName = weekdayNames[now.weekday - 1];
    return getDayByWeekday(weekdayName) ?? days.first;
  }

  /// Get day by index (0 = Sunday, 6 = Saturday)
  static PlanetaryDay getDayByIndex(int index) {
    final weekdayNames = [
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
    ];
    if (index < 0 || index >= weekdayNames.length) {
      return days.first;
    }
    return getDayByWeekday(weekdayNames[index]) ?? days.first;
  }
}
