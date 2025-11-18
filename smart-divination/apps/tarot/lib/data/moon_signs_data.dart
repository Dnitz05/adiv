import '../models/moon_sign.dart';

/// Repository for Moon in Signs wisdom
/// Based on traditional astrological correspondences
/// Source: lunar_astrology_reference.md and traditional astrology
class MoonSignsData {
  static const List<MoonSign> signs = [
    // Aries
    MoonSign(
      id: 'aries',
      name: 'Aries',
      symbol: '♈',
      icon: '🐏',
      localizedNames: {
        'en': 'Aries',
        'es': 'Aries',
        'ca': 'Àries',
      },
      element: 'Fire',
      modality: 'Cardinal',
      rulingPlanet: 'Mars',
      archetype: {
        'en': 'The Warrior, The Pioneer',
        'es': 'El Guerrero, El Pionero',
        'ca': 'El Guerrer, El Pioner',
      },
      description: {
        'en': 'When the Moon is in Aries, emotions are direct, impulsive and courageous. This is a time of emotional independence and the desire to take action. Aries Moon brings fiery passion and the courage to express feelings boldly. The focus is on new beginnings, spontaneity and authentic self-expression.',
        'es': 'Cuando la Luna está en Aries, las emociones son directas, impulsivas y valientes. Es un tiempo de independencia emocional y el deseo de tomar acción. La Luna en Aries trae pasión ardiente y el coraje de expresar los sentimientos con audacia. El enfoque está en nuevos comienzos, espontaneidad y auto-expresión auténtica.',
        'ca': 'Quan la Lluna està en Àries, les emocions són directes, impulsives i coratjoses. És un temps d\'independència emocional i el desig de prendre acció. La Lluna en Àries porta passió ardent i el coratge d\'expressar els sentiments amb audàcia. L\'enfocament està en nous començaments, espontaneïtat i auto-expressió autèntica.',
      },
      emotionalNature: {
        'en': 'Impulsive, brave, independent, direct, passionate',
        'es': 'Impulsivo, valiente, independiente, directo, apasionado',
        'ca': 'Impulsiu, coratjós, independent, directe, apassionat',
      },
      moonQualities: {
        'en': [
          'Emotions are expressed immediately and directly',
          'Quick to anger but also quick to forgive',
          'Need for emotional freedom and independence',
          'Courage to face emotional challenges head-on',
          'Pioneer spirit in emotional matters',
        ],
        'es': [
          'Las emociones se expresan inmediata y directamente',
          'Rápido para enfadarse pero también para perdonar',
          'Necesidad de libertad e independencia emocional',
          'Coraje para enfrentar desafíos emocionales de frente',
          'Espíritu pionero en asuntos emocionales',
        ],
        'ca': [
          'Les emocions s\'expressen immediatament i directament',
          'Ràpid per enfadar-se però també per perdonar',
          'Necessitat de llibertat i independència emocional',
          'Coratge per enfrontar desafiaments emocionals de front',
          'Esperit pioner en assumptes emocionals',
        ],
      },
      bestActivities: {
        'en': [
          'Start new projects with passion',
          'Physical exercise and sports',
          'Take bold action on something you\'ve been postponing',
          'Stand up for yourself or others',
          'Express anger or frustration in healthy ways',
        ],
        'es': [
          'Comenzar nuevos proyectos con pasión',
          'Ejercicio físico y deportes',
          'Tomar acción audaz en algo que has pospuesto',
          'Defenderte a ti mismo o a otros',
          'Expresar ira o frustración de formas saludables',
        ],
        'ca': [
          'Començar nous projectes amb passió',
          'Exercici físic i esports',
          'Prendre acció audaç en alguna cosa que has posposat',
          'Defensar-te a tu mateix o als altres',
          'Expressar ira o frustració de formes saludables',
        ],
      },
      tarotCard: 'The Emperor',
      tarotNumber: 4,
      color: '#FF0000',
      dateRange: '21 Mar - 19 Apr',
    ),

    // Taurus
    MoonSign(
      id: 'taurus',
      name: 'Taurus',
      symbol: '♉',
      icon: '🐂',
      localizedNames: {
        'en': 'Taurus',
        'es': 'Tauro',
        'ca': 'Taure',
      },
      element: 'Earth',
      modality: 'Fixed',
      rulingPlanet: 'Venus',
      archetype: {
        'en': 'The Builder, The Gardener',
        'es': 'El Constructor, El Jardinero',
        'ca': 'El Constructor, El Jardiner',
      },
      description: {
        'en': 'When the Moon is in Taurus, emotions are stable, grounded and sensual. This is a time of emotional security through tangible comforts and pleasures. Taurus Moon brings appreciation for beauty, nature and physical touch. The focus is on building stability, enjoying sensory experiences and cultivating patience.',
        'es': 'Cuando la Luna está en Tauro, las emociones son estables, arraigadas y sensuales. Es un tiempo de seguridad emocional a través de comodidades y placeres tangibles. La Luna en Tauro trae apreciación por la belleza, la naturaleza y el tacto físico. El enfoque está en construir estabilidad, disfrutar experiencias sensoriales y cultivar paciencia.',
        'ca': 'Quan la Lluna està en Taure, les emocions són estables, arrelades i sensuals. És un temps de seguretat emocional a través de comoditats i plaers tangibles. La Lluna en Taure porta apreciació per la bellesa, la natura i el tacte físic. L\'enfocament està en construir estabilitat, gaudir experiències sensorials i cultivar paciència.',
      },
      emotionalNature: {
        'en': 'Stable, patient, sensual, stubborn, loyal',
        'es': 'Estable, paciente, sensual, terco, leal',
        'ca': 'Estable, pacient, sensual, tossut, lleial',
      },
      moonQualities: {
        'en': [
          'Emotions are steady and enduring',
          'Need for physical comfort and security',
          'Strong connection to nature and beauty',
          'Stubborn about emotional boundaries',
          'Loyal and reliable in relationships',
        ],
        'es': [
          'Las emociones son firmes y duraderas',
          'Necesidad de comodidad física y seguridad',
          'Fuerte conexión con la naturaleza y la belleza',
          'Terco sobre los límites emocionales',
          'Leal y confiable en las relaciones',
        ],
        'ca': [
          'Les emocions són fermes i duradores',
          'Necessitat de comoditat física i seguretat',
          'Forta connexió amb la natura i la bellesa',
          'Tossut sobre els límits emocionals',
          'Lleial i fiable en les relacions',
        ],
      },
      bestActivities: {
        'en': [
          'Garden or work with plants',
          'Enjoy good food and sensory pleasures',
          'Create or appreciate art and beauty',
          'Physical touch and massage',
          'Build or organize something tangible',
        ],
        'es': [
          'Jardinar o trabajar con plantas',
          'Disfrutar buena comida y placeres sensoriales',
          'Crear o apreciar arte y belleza',
          'Tacto físico y masaje',
          'Construir u organizar algo tangible',
        ],
        'ca': [
          'Jardinar o treballar amb plantes',
          'Gaudir bona menjar i plaers sensorials',
          'Crear o apreciar art i bellesa',
          'Tacte físic i massatge',
          'Construir o organitzar alguna cosa tangible',
        ],
      },
      tarotCard: 'The Hierophant',
      tarotNumber: 5,
      color: '#228B22',
      dateRange: '20 Apr - 20 May',
    ),

    // Gemini
    MoonSign(
      id: 'gemini',
      name: 'Gemini',
      symbol: '♊',
      icon: '👯',
      localizedNames: {
        'en': 'Gemini',
        'es': 'Géminis',
        'ca': 'Bessons',
      },
      element: 'Air',
      modality: 'Mutable',
      rulingPlanet: 'Mercury',
      archetype: {
        'en': 'The Messenger, The Twins',
        'es': 'El Mensajero, Los Gemelos',
        'ca': 'El Missatger, Els Bessons',
      },
      description: {
        'en': 'When the Moon is in Gemini, emotions are light, curious and communicative. This is a time of mental stimulation and the desire to connect through words. Gemini Moon brings versatility and the ability to see multiple perspectives. The focus is on learning, socializing and expressing feelings through conversation.',
        'es': 'Cuando la Luna está en Géminis, las emociones son ligeras, curiosas y comunicativas. Es un tiempo de estimulación mental y el deseo de conectar a través de palabras. La Luna en Géminis trae versatilidad y la capacidad de ver múltiples perspectivas. El enfoque está en aprender, socializar y expresar sentimientos a través de la conversación.',
        'ca': 'Quan la Lluna està en Bessons, les emocions són lleugeres, curioses i comunicatives. És un temps d\'estimulació mental i el desig de connectar a través de paraules. La Lluna en Bessons porta versatilitat i la capacitat de veure múltiples perspectives. L\'enfocament està en aprendre, socialitzar i expressar sentiments a través de la conversa.',
      },
      emotionalNature: {
        'en': 'Curious, adaptable, communicative, restless, intellectual',
        'es': 'Curioso, adaptable, comunicativo, inquieto, intelectual',
        'ca': 'Curiosa, adaptable, comunicatiu, inquiet, intel·lectual',
      },
      moonQualities: {
        'en': [
          'Emotions are analyzed and verbalized',
          'Need for mental stimulation and variety',
          'Quick wit and sense of humor',
          'Can feel emotionally detached at times',
          'Dual nature - seeing both sides',
        ],
        'es': [
          'Las emociones son analizadas y verbalizadas',
          'Necesidad de estimulación mental y variedad',
          'Ingenio rápido y sentido del humor',
          'Puede sentirse emocionalmente distante a veces',
          'Naturaleza dual - viendo ambos lados',
        ],
        'ca': [
          'Les emocions són analitzades i verbalitzades',
          'Necessitat d\'estimulació mental i varietat',
          'Enginy ràpid i sentit de l\'humor',
          'Pot sentir-se emocionalment distant a vegades',
          'Naturalesa dual - veient ambdós costats',
        ],
      },
      bestActivities: {
        'en': [
          'Read, write, or study something new',
          'Have deep conversations',
          'Social networking and connecting',
          'Puzzle-solving or word games',
          'Short trips or local exploration',
        ],
        'es': [
          'Leer, escribir o estudiar algo nuevo',
          'Tener conversaciones profundas',
          'Networking social y conexión',
          'Resolver puzzles o juegos de palabras',
          'Viajes cortos o exploración local',
        ],
        'ca': [
          'Llegir, escriure o estudiar alguna cosa nova',
          'Tenir converses profundes',
          'Networking social i connexió',
          'Resoldre puzzles o jocs de paraules',
          'Viatges curts o exploració local',
        ],
      },
      tarotCard: 'The Lovers',
      tarotNumber: 6,
      color: '#FFD700',
      dateRange: '21 May - 20 Jun',
    ),

    // Cancer
    MoonSign(
      id: 'cancer',
      name: 'Cancer',
      symbol: '♋',
      icon: '🦀',
      localizedNames: {
        'en': 'Cancer',
        'es': 'Cáncer',
        'ca': 'Cranc',
      },
      element: 'Water',
      modality: 'Cardinal',
      rulingPlanet: 'Moon',
      archetype: {
        'en': 'The Mother, The Nurturer',
        'es': 'La Madre, La Nutricia',
        'ca': 'La Mare, La Nodridora',
      },
      description: {
        'en': 'When the Moon is in Cancer, it is in its home sign, and emotions are deep, protective and nurturing. This is a time of heightened intuition and emotional sensitivity. Cancer Moon brings strong connection to family, home and the past. The focus is on emotional safety, caring for others and honoring feelings.',
        'es': 'Cuando la Luna está en Cáncer, está en su signo natal, y las emociones son profundas, protectoras y nutricias. Es un tiempo de intuición aumentada y sensibilidad emocional. La Luna en Cáncer trae fuerte conexión con la familia, el hogar y el pasado. El enfoque está en la seguridad emocional, cuidar de otros y honrar los sentimientos.',
        'ca': 'Quan la Lluna està en Cranc, està en el seu signe natal, i les emocions són profundes, protectores i nodridores. És un temps d\'intuïció augmentada i sensibilitat emocional. La Lluna en Cranc porta forta connexió amb la família, la llar i el passat. L\'enfocament està en la seguretat emocional, cuidar dels altres i honrar els sentiments.',
      },
      emotionalNature: {
        'en': 'Nurturing, sensitive, protective, moody, intuitive',
        'es': 'Nutricio, sensible, protector, temperamental, intuitivo',
        'ca': 'Nodridor, sensible, protector, temperamental, intuïtiu',
      },
      moonQualities: {
        'en': [
          'Emotions are deep and changeable like tides',
          'Strong intuition and psychic sensitivity',
          'Need for emotional security and home',
          'Protective of loved ones',
          'Connection to memory and the past',
        ],
        'es': [
          'Las emociones son profundas y cambiantes como las mareas',
          'Fuerte intuición y sensibilidad psíquica',
          'Necesidad de seguridad emocional y hogar',
          'Protector de los seres queridos',
          'Conexión con la memoria y el pasado',
        ],
        'ca': [
          'Les emocions són profundes i canviants com les marees',
          'Forta intuïció i sensibilitat psíquica',
          'Necessitat de seguretat emocional i llar',
          'Protector dels éssers estimats',
          'Connexió amb la memòria i el passat',
        ],
      },
      bestActivities: {
        'en': [
          'Spend time with family',
          'Cook comfort food',
          'Create a cozy home environment',
          'Work with emotions and intuition',
          'Connect with ancestral roots',
        ],
        'es': [
          'Pasar tiempo con la familia',
          'Cocinar comida reconfortante',
          'Crear un ambiente hogareño acogedor',
          'Trabajar con emociones e intuición',
          'Conectar con raíces ancestrales',
        ],
        'ca': [
          'Passar temps amb la família',
          'Cuinar menjar reconfortant',
          'Crear un ambient acollidor a la llar',
          'Treballar amb emocions i intuïció',
          'Connectar amb arrels ancestrals',
        ],
      },
      tarotCard: 'The Chariot',
      tarotNumber: 7,
      color: '#C0C0C0',
      dateRange: '21 Jun - 22 Jul',
    ),

    // Leo
    MoonSign(
      id: 'leo',
      name: 'Leo',
      symbol: '♌',
      icon: '🦁',
      localizedNames: {
        'en': 'Leo',
        'es': 'Leo',
        'ca': 'Lleó',
      },
      element: 'Fire',
      modality: 'Fixed',
      rulingPlanet: 'Sun',
      archetype: {
        'en': 'The King, The Performer',
        'es': 'El Rey, El Intérprete',
        'ca': 'El Rei, L\'Intèrpret',
      },
      description: {
        'en': 'When the Moon is in Leo, emotions are dramatic, warm and generous. This is a time of creative self-expression and the desire to be seen and appreciated. Leo Moon brings playfulness, confidence and a big heart. The focus is on joy, creativity, romance and sharing your gifts with the world.',
        'es': 'Cuando la Luna está en Leo, las emociones son dramáticas, cálidas y generosas. Es un tiempo de auto-expresión creativa y el deseo de ser visto y apreciado. La Luna en Leo trae juego, confianza y un gran corazón. El enfoque está en la alegría, la creatividad, el romance y compartir tus dones con el mundo.',
        'ca': 'Quan la Lluna està en Lleó, les emocions són dramàtiques, càlides i generoses. És un temps d\'auto-expressió creativa i el desig de ser vist i apreciat. La Lluna en Lleó porta joc, confiança i un gran cor. L\'enfocament està en l\'alegria, la creativitat, el romanç i compartir els teus dons amb el món.',
      },
      emotionalNature: {
        'en': 'Dramatic, generous, proud, creative, warm-hearted',
        'es': 'Dramático, generoso, orgulloso, creativo, de corazón cálido',
        'ca': 'Dramàtic, generós, orgullós, creatiu, de cor càlid',
      },
      moonQualities: {
        'en': [
          'Emotions are expressed dramatically and openly',
          'Need for recognition and appreciation',
          'Generous and warm-hearted',
          'Pride can be wounded easily',
          'Natural performer and entertainer',
        ],
        'es': [
          'Las emociones se expresan dramática y abiertamente',
          'Necesidad de reconocimiento y apreciación',
          'Generoso y de corazón cálido',
          'El orgullo puede herirse fácilmente',
          'Intérprete y animador natural',
        ],
        'ca': [
          'Les emocions s\'expressen dramàticament i obertament',
          'Necessitat de reconeixement i apreciació',
          'Generós i de cor càlid',
          'L\'orgull pot ferir-se fàcilment',
          'Intèrpret i animador natural',
        ],
      },
      bestActivities: {
        'en': [
          'Creative projects and artistic expression',
          'Play, fun and entertainment',
          'Romance and expressing affection',
          'Shine your light and share your talents',
          'Activities with children',
        ],
        'es': [
          'Proyectos creativos y expresión artística',
          'Juego, diversión y entretenimiento',
          'Romance y expresar afecto',
          'Brillar tu luz y compartir tus talentos',
          'Actividades con niños',
        ],
        'ca': [
          'Projectes creatius i expressió artística',
          'Joc, diversió i entreteniment',
          'Romanç i expressar afecte',
          'Brillar la teva llum i compartir els teus talents',
          'Activitats amb nens',
        ],
      },
      tarotCard: 'Strength',
      tarotNumber: 8,
      color: '#FFD700',
      dateRange: '23 Jul - 22 Aug',
    ),

    // Virgo
    MoonSign(
      id: 'virgo',
      name: 'Virgo',
      symbol: '♍',
      icon: '👸',
      localizedNames: {
        'en': 'Virgo',
        'es': 'Virgo',
        'ca': 'Verge',
      },
      element: 'Earth',
      modality: 'Mutable',
      rulingPlanet: 'Mercury',
      archetype: {
        'en': 'The Healer, The Analyst',
        'es': 'El Sanador, El Analista',
        'ca': 'El Sanador, L\'Analista',
      },
      description: {
        'en': 'When the Moon is in Virgo, emotions are analyzed, refined and put to practical use. This is a time of emotional healing through service and order. Virgo Moon brings attention to detail, desire for improvement and a practical approach to feelings. The focus is on health, organization, helping others and perfecting daily routines.',
        'es': 'Cuando la Luna está en Virgo, las emociones son analizadas, refinadas y puestas en uso práctico. Es un tiempo de sanación emocional a través del servicio y el orden. La Luna en Virgo trae atención al detalle, deseo de mejora y un enfoque práctico a los sentimientos. El enfoque está en la salud, la organización, ayudar a otros y perfeccionar las rutinas diarias.',
        'ca': 'Quan la Lluna està en Verge, les emocions són analitzades, refinades i posades en ús pràctic. És un temps de sanació emocional a través del servei i l\'ordre. La Lluna en Verge porta atenció al detall, desig de millora i un enfocament pràctic als sentiments. L\'enfocament està en la salut, l\'organització, ajudar als altres i perfeccionar les rutines diàries.',
      },
      emotionalNature: {
        'en': 'Analytical, perfectionist, helpful, practical, critical',
        'es': 'Analítico, perfeccionista, servicial, práctico, crítico',
        'ca': 'Analític, perfeccionista, servicial, pràctic, crític',
      },
      moonQualities: {
        'en': [
          'Emotions are analyzed and categorized',
          'Need for order and cleanliness',
          'Desire to be useful and helpful',
          'Self-critical and worry-prone',
          'Health-conscious and detail-oriented',
        ],
        'es': [
          'Las emociones son analizadas y categorizadas',
          'Necesidad de orden y limpieza',
          'Deseo de ser útil y servicial',
          'Autocrítico y propenso a preocuparse',
          'Consciente de la salud y orientado a los detalles',
        ],
        'ca': [
          'Les emocions són analitzades i categoritzades',
          'Necessitat d\'ordre i neteja',
          'Desig de ser útil i servicial',
          'Autocrític i propens a preocupar-se',
          'Conscient de la salut i orientat als detalls',
        ],
      },
      bestActivities: {
        'en': [
          'Organize and declutter spaces',
          'Health routines and self-care',
          'Help others in practical ways',
          'Detailed work and crafts',
          'Meal planning and healthy cooking',
        ],
        'es': [
          'Organizar y ordenar espacios',
          'Rutinas de salud y autocuidado',
          'Ayudar a otros de formas prácticas',
          'Trabajo detallado y manualidades',
          'Planificación de comidas y cocina saludable',
        ],
        'ca': [
          'Organitzar i desembolicar espais',
          'Rutines de salut i autocura',
          'Ajudar als altres de formes pràctiques',
          'Treball detallat i manualitats',
          'Planificació de menjars i cuina saludable',
        ],
      },
      tarotCard: 'The Hermit',
      tarotNumber: 9,
      color: '#8B4513',
      dateRange: '23 Aug - 22 Sep',
    ),

    // Libra
    MoonSign(
      id: 'libra',
      name: 'Libra',
      symbol: '♎',
      icon: '⚖️',
      localizedNames: {
        'en': 'Libra',
        'es': 'Libra',
        'ca': 'Balança',
      },
      element: 'Air',
      modality: 'Cardinal',
      rulingPlanet: 'Venus',
      archetype: {
        'en': 'The Diplomat, The Artist',
        'es': 'El Diplomático, El Artista',
        'ca': 'El Diplomàtic, L\'Artista',
      },
      description: {
        'en': 'When the Moon is in Libra, emotions seek balance, harmony and partnership. This is a time of seeing all perspectives and creating peace. Libra Moon brings charm, fairness and appreciation for beauty and relationships. The focus is on cooperation, aesthetics, justice and finding emotional equilibrium.',
        'es': 'Cuando la Luna está en Libra, las emociones buscan equilibrio, armonía y asociación. Es un tiempo de ver todas las perspectivas y crear paz. La Luna en Libra trae encanto, justicia y apreciación por la belleza y las relaciones. El enfoque está en la cooperación, la estética, la justicia y encontrar el equilibrio emocional.',
        'ca': 'Quan la Lluna està en Balança, les emocions cerquen equilibri, harmonia i parella. És un temps de veure totes les perspectives i crear pau. La Lluna en Balança porta encant, justícia i apreciació per la bellesa i les relacions. L\'enfocament està en la cooperació, l\'estètica, la justícia i trobar l\'equilibri emocional.',
      },
      emotionalNature: {
        'en': 'Harmonious, diplomatic, indecisive, charming, fair-minded',
        'es': 'Armonioso, diplomático, indeciso, encantador, justo',
        'ca': 'Harmoniós, diplomàtic, indecís, encantador, just',
      },
      moonQualities: {
        'en': [
          'Emotions are balanced through partnership',
          'Need for harmony and peace',
          'Sees both sides of every situation',
          'Can be indecisive about feelings',
          'Appreciates beauty and aesthetics',
        ],
        'es': [
          'Las emociones se equilibran a través de la asociación',
          'Necesidad de armonía y paz',
          'Ve ambos lados de cada situación',
          'Puede ser indeciso sobre los sentimientos',
          'Aprecia la belleza y la estética',
        ],
        'ca': [
          'Les emocions s\'equilibren a través de la parella',
          'Necessitat d\'harmonia i pau',
          'Veu ambdós costats de cada situació',
          'Pot ser indecís sobre els sentiments',
          'Aprecia la bellesa i l\'estètica',
        ],
      },
      bestActivities: {
        'en': [
          'Relationship building and cooperation',
          'Create or appreciate art and beauty',
          'Mediate conflicts and find compromise',
          'Social gatherings and networking',
          'Balance and harmonize your environment',
        ],
        'es': [
          'Construcción de relaciones y cooperación',
          'Crear o apreciar arte y belleza',
          'Mediar conflictos y encontrar compromisos',
          'Reuniones sociales y networking',
          'Equilibrar y armonizar tu entorno',
        ],
        'ca': [
          'Construcció de relacions i cooperació',
          'Crear o apreciar art i bellesa',
          'Mediar conflictes i trobar compromisos',
          'Reunions socials i networking',
          'Equilibrar i harmonitzar el teu entorn',
        ],
      },
      tarotCard: 'Justice',
      tarotNumber: 11,
      color: '#FFB6C1',
      dateRange: '23 Sep - 22 Oct',
    ),

    // Scorpio
    MoonSign(
      id: 'scorpio',
      name: 'Scorpio',
      symbol: '♏',
      icon: '🦂',
      localizedNames: {
        'en': 'Scorpio',
        'es': 'Escorpio',
        'ca': 'Escorpí',
      },
      element: 'Water',
      modality: 'Fixed',
      rulingPlanet: 'Pluto',
      archetype: {
        'en': 'The Phoenix, The Mystic',
        'es': 'El Fénix, El Místico',
        'ca': 'El Fènix, El Místic',
      },
      description: {
        'en': 'When the Moon is in Scorpio, emotions are intense, deep and transformative. This is a time of emotional power, psychic depth and the desire for truth. Scorpio Moon brings passion, mystery and the ability to transform through crisis. The focus is on emotional intensity, intimacy, power and facing the shadow.',
        'es': 'Cuando la Luna está en Escorpio, las emociones son intensas, profundas y transformadoras. Es un tiempo de poder emocional, profundidad psíquica y el deseo de verdad. La Luna en Escorpio trae pasión, misterio y la capacidad de transformarse a través de la crisis. El enfoque está en la intensidad emocional, la intimidad, el poder y enfrentar la sombra.',
        'ca': 'Quan la Lluna està en Escorpí, les emocions són intenses, profundes i transformadores. És un temps de poder emocional, profunditat psíquica i el desig de veritat. La Lluna en Escorpí porta passió, misteri i la capacitat de transformar-se a través de la crisi. L\'enfocament està en la intensitat emocional, la intimitat, el poder i enfrontar l\'ombra.',
      },
      emotionalNature: {
        'en': 'Intense, passionate, mysterious, transformative, powerful',
        'es': 'Intenso, apasionado, misterioso, transformador, poderoso',
        'ca': 'Intens, apassionat, misteriós, transformador, poderós',
      },
      moonQualities: {
        'en': [
          'Emotions are felt intensely and deeply',
          'Need for emotional truth and authenticity',
          'Powerful psychic and intuitive abilities',
          'Can be secretive or controlling',
          'Transforms through emotional crisis',
        ],
        'es': [
          'Las emociones se sienten intensa y profundamente',
          'Necesidad de verdad y autenticidad emocional',
          'Poderosas habilidades psíquicas e intuitivas',
          'Puede ser secreto o controlador',
          'Se transforma a través de crisis emocionales',
        ],
        'ca': [
          'Les emocions se senten intensa i profundament',
          'Necessitat de veritat i autenticitat emocional',
          'Poderoses habilitats psíquiques i intuïtives',
          'Pot ser secret o controlador',
          'Es transforma a través de crisis emocionals',
        ],
      },
      bestActivities: {
        'en': [
          'Deep emotional work and therapy',
          'Shadow work and transformation',
          'Intimacy and deep connection',
          'Research and investigation',
          'Power rituals and occult studies',
        ],
        'es': [
          'Trabajo emocional profundo y terapia',
          'Trabajo de sombra y transformación',
          'Intimidad y conexión profunda',
          'Investigación e indagación',
          'Rituales de poder y estudios ocultos',
        ],
        'ca': [
          'Treball emocional profund i teràpia',
          'Treball d\'ombra i transformació',
          'Intimitat i connexió profunda',
          'Investigació i indagació',
          'Rituals de poder i estudis ocults',
        ],
      },
      tarotCard: 'Death',
      tarotNumber: 13,
      color: '#8B0000',
      dateRange: '23 Oct - 21 Nov',
    ),

    // Sagittarius
    MoonSign(
      id: 'sagittarius',
      name: 'Sagittarius',
      symbol: '♐',
      icon: '🏹',
      localizedNames: {
        'en': 'Sagittarius',
        'es': 'Sagitario',
        'ca': 'Sagitari',
      },
      element: 'Fire',
      modality: 'Mutable',
      rulingPlanet: 'Jupiter',
      archetype: {
        'en': 'The Philosopher, The Explorer',
        'es': 'El Filósofo, El Explorador',
        'ca': 'El Filòsof, L\'Explorador',
      },
      description: {
        'en': 'When the Moon is in Sagittarius, emotions are optimistic, adventurous and freedom-loving. This is a time of philosophical exploration and the desire for meaning. Sagittarius Moon brings enthusiasm, humor and a quest for truth. The focus is on expansion, learning, travel and connecting with higher wisdom.',
        'es': 'Cuando la Luna está en Sagitario, las emociones son optimistas, aventureras y amantes de la libertad. Es un tiempo de exploración filosófica y el deseo de significado. La Luna en Sagitario trae entusiasmo, humor y una búsqueda de la verdad. El enfoque está en la expansión, el aprendizaje, los viajes y la conexión con la sabiduría superior.',
        'ca': 'Quan la Lluna està en Sagitari, les emocions són optimistes, aventureres i amants de la llibertat. És un temps d\'exploració filosòfica i el desig de significat. La Lluna en Sagitari porta entusiasme, humor i una cerca de la veritat. L\'enfocament està en l\'expansió, l\'aprenentatge, els viatges i la connexió amb la saviesa superior.',
      },
      emotionalNature: {
        'en': 'Optimistic, adventurous, philosophical, freedom-loving, restless',
        'es': 'Optimista, aventurero, filosófico, amante de la libertad, inquieto',
        'ca': 'Optimista, aventurer, filosòfic, amant de la llibertat, inquiet',
      },
      moonQualities: {
        'en': [
          'Emotions are optimistic and expansive',
          'Need for freedom and adventure',
          'Philosophical approach to feelings',
          'Can be blunt or tactless',
          'Seeks meaning and truth',
        ],
        'es': [
          'Las emociones son optimistas y expansivas',
          'Necesidad de libertad y aventura',
          'Enfoque filosófico a los sentimientos',
          'Puede ser directo o desconsiderado',
          'Busca significado y verdad',
        ],
        'ca': [
          'Les emocions són optimistes i expansives',
          'Necessitat de llibertat i aventura',
          'Enfocament filosòfic als sentiments',
          'Pot ser directe o desconsiderat',
          'Cerca significat i veritat',
        ],
      },
      bestActivities: {
        'en': [
          'Travel or plan adventures',
          'Study philosophy or spirituality',
          'Outdoor activities and nature',
          'Teaching or sharing wisdom',
          'Expand your horizons',
        ],
        'es': [
          'Viajar o planear aventuras',
          'Estudiar filosofía o espiritualidad',
          'Actividades al aire libre y naturaleza',
          'Enseñar o compartir sabiduría',
          'Expandir tus horizontes',
        ],
        'ca': [
          'Viatjar o planificar aventures',
          'Estudiar filosofia o espiritualitat',
          'Activitats a l\'aire lliure i natura',
          'Ensenyar o compartir saviesa',
          'Expandir els teus horitzons',
        ],
      },
      tarotCard: 'Temperance',
      tarotNumber: 14,
      color: '#9370DB',
      dateRange: '22 Nov - 21 Dec',
    ),

    // Capricorn
    MoonSign(
      id: 'capricorn',
      name: 'Capricorn',
      symbol: '♑',
      icon: '🐐',
      localizedNames: {
        'en': 'Capricorn',
        'es': 'Capricornio',
        'ca': 'Capricorn',
      },
      element: 'Earth',
      modality: 'Cardinal',
      rulingPlanet: 'Saturn',
      archetype: {
        'en': 'The Elder, The Mountain',
        'es': 'El Anciano, La Montaña',
        'ca': 'L\'Ancià, La Muntanya',
      },
      description: {
        'en': 'When the Moon is in Capricorn, emotions are controlled, ambitious and responsible. This is a time of emotional maturity and building lasting structures. Capricorn Moon brings discipline, wisdom and the ability to endure. The focus is on achievement, responsibility, long-term goals and mastering emotions.',
        'es': 'Cuando la Luna está en Capricornio, las emociones son controladas, ambiciosas y responsables. Es un tiempo de madurez emocional y construcción de estructuras duraderas. La Luna en Capricornio trae disciplina, sabiduría y la capacidad de resistir. El enfoque está en el logro, la responsabilidad, las metas a largo plazo y dominar las emociones.',
        'ca': 'Quan la Lluna està en Capricorn, les emocions són controlades, ambicioses i responsables. És un temps de maduresa emocional i construcció d\'estructures duradores. La Lluna en Capricorn porta disciplina, saviesa i la capacitat de resistir. L\'enfocament està en l\'assoliment, la responsabilitat, les metes a llarg termini i dominar les emocions.',
      },
      emotionalNature: {
        'en': 'Disciplined, ambitious, reserved, responsible, practical',
        'es': 'Disciplinado, ambicioso, reservado, responsable, práctico',
        'ca': 'Disciplinat, ambiciós, reservat, responsable, pràctic',
      },
      moonQualities: {
        'en': [
          'Emotions are controlled and practical',
          'Need for structure and achievement',
          'Reserved and cautious emotionally',
          'Strong sense of duty and responsibility',
          'Mature and wise approach to feelings',
        ],
        'es': [
          'Las emociones son controladas y prácticas',
          'Necesidad de estructura y logro',
          'Reservado y cauteloso emocionalmente',
          'Fuerte sentido del deber y responsabilidad',
          'Enfoque maduro y sabio a los sentimientos',
        ],
        'ca': [
          'Les emocions són controlades i pràctiques',
          'Necessitat d\'estructura i assoliment',
          'Reservat i cautelós emocionalment',
          'Fort sentit del deure i responsabilitat',
          'Enfocament madur i savi als sentiments',
        ],
      },
      bestActivities: {
        'en': [
          'Long-term planning and goal setting',
          'Career advancement and achievement',
          'Build lasting structures',
          'Work with discipline and focus',
          'Honor elders and traditions',
        ],
        'es': [
          'Planificación a largo plazo y establecimiento de metas',
          'Avance profesional y logro',
          'Construir estructuras duraderas',
          'Trabajar con disciplina y enfoque',
          'Honrar a los ancianos y tradiciones',
        ],
        'ca': [
          'Planificació a llarg termini i establiment de metes',
          'Avenç professional i assoliment',
          'Construir estructures duradores',
          'Treballar amb disciplina i enfocament',
          'Honrar els ancians i tradicions',
        ],
      },
      tarotCard: 'The Devil',
      tarotNumber: 15,
      color: '#2F4F4F',
      dateRange: '22 Dec - 19 Jan',
    ),

    // Aquarius
    MoonSign(
      id: 'aquarius',
      name: 'Aquarius',
      symbol: '♒',
      icon: '🏺',
      localizedNames: {
        'en': 'Aquarius',
        'es': 'Acuario',
        'ca': 'Aquari',
      },
      element: 'Air',
      modality: 'Fixed',
      rulingPlanet: 'Uranus',
      archetype: {
        'en': 'The Innovator, The Humanitarian',
        'es': 'El Innovador, El Humanitario',
        'ca': 'L\'Innovador, L\'Humanitari',
      },
      description: {
        'en': 'When the Moon is in Aquarius, emotions are detached, innovative and humanitarian. This is a time of intellectual approach to feelings and desire for freedom. Aquarius Moon brings originality, friendship and vision for the future. The focus is on community, innovation, independence and progressive ideals.',
        'es': 'Cuando la Luna está en Acuario, las emociones son distantes, innovadoras y humanitarias. Es un tiempo de enfoque intelectual a los sentimientos y deseo de libertad. La Luna en Acuario trae originalidad, amistad y visión para el futuro. El enfoque está en la comunidad, la innovación, la independencia y los ideales progresistas.',
        'ca': 'Quan la Lluna està en Aquari, les emocions són distants, innovadores i humanitàries. És un temps d\'enfocament intel·lectual als sentiments i desig de llibertat. La Lluna en Aquari porta originalitat, amistat i visió per al futur. L\'enfocament està en la comunitat, la innovació, la independència i els ideals progressistes.',
      },
      emotionalNature: {
        'en': 'Detached, innovative, idealistic, eccentric, humanitarian',
        'es': 'Distante, innovador, idealista, excéntrico, humanitario',
        'ca': 'Distant, innovador, idealista, excèntric, humanitari',
      },
      moonQualities: {
        'en': [
          'Emotions are intellectualized and detached',
          'Need for freedom and independence',
          'Friendships are more comfortable than intimacy',
          'Original and unconventional approach',
          'Focus on collective and humanitarian concerns',
        ],
        'es': [
          'Las emociones son intelectualizadas y distantes',
          'Necesidad de libertad e independencia',
          'Las amistades son más cómodas que la intimidad',
          'Enfoque original y poco convencional',
          'Enfoque en preocupaciones colectivas y humanitarias',
        ],
        'ca': [
          'Les emocions són intel·lectualitzades i distants',
          'Necessitat de llibertat i independència',
          'Les amistats són més còmodes que la intimitat',
          'Enfocament original i poc convencional',
          'Enfocament en preocupacions col·lectives i humanitàries',
        ],
      },
      bestActivities: {
        'en': [
          'Community and group activities',
          'Innovation and technology',
          'Friendship and networking',
          'Progressive causes and activism',
          'Think about the future',
        ],
        'es': [
          'Actividades comunitarias y grupales',
          'Innovación y tecnología',
          'Amistad y networking',
          'Causas progresistas y activismo',
          'Pensar en el futuro',
        ],
        'ca': [
          'Activitats comunitàries i grupals',
          'Innovació i tecnologia',
          'Amistat i networking',
          'Causes progressistes i activisme',
          'Pensar en el futur',
        ],
      },
      tarotCard: 'The Star',
      tarotNumber: 17,
      color: '#00CED1',
      dateRange: '20 Jan - 18 Feb',
    ),

    // Pisces
    MoonSign(
      id: 'pisces',
      name: 'Pisces',
      symbol: '♓',
      icon: '🐟',
      localizedNames: {
        'en': 'Pisces',
        'es': 'Piscis',
        'ca': 'Peixos',
      },
      element: 'Water',
      modality: 'Mutable',
      rulingPlanet: 'Neptune',
      archetype: {
        'en': 'The Dreamer, The Mystic',
        'es': 'El Soñador, El Místico',
        'ca': 'El Somiador, El Místic',
      },
      description: {
        'en': 'When the Moon is in Pisces, emotions are boundless, compassionate and mystical. This is a time of deep sensitivity, spiritual connection and unity with all. Pisces Moon brings empathy, imagination and the ability to dissolve boundaries. The focus is on compassion, dreams, spirituality and transcendence.',
        'es': 'Cuando la Luna está en Piscis, las emociones son ilimitadas, compasivas y místicas. Es un tiempo de sensibilidad profunda, conexión espiritual y unidad con todo. La Luna en Piscis trae empatía, imaginación y la capacidad de disolver fronteras. El enfoque está en la compasión, los sueños, la espiritualidad y la trascendencia.',
        'ca': 'Quan la Lluna està en Peixos, les emocions són il·limitades, compassives i místiques. És un temps de sensibilitat profunda, connexió espiritual i unitat amb tot. La Lluna en Peixos porta empatia, imaginació i la capacitat de dissoldre fronteres. L\'enfocament està en la compassió, els somnis, l\'espiritualitat i la transcendència.',
      },
      emotionalNature: {
        'en': 'Sensitive, compassionate, dreamy, escapist, spiritual',
        'es': 'Sensible, compasivo, soñador, escapista, espiritual',
        'ca': 'Sensible, compassiu, somiador, escapista, espiritual',
      },
      moonQualities: {
        'en': [
          'Emotions are boundless and flowing',
          'Deeply empathic and compassionate',
          'Strong intuition and psychic sensitivity',
          'Can be overwhelmed by feelings',
          'Spiritual and transcendent approach',
        ],
        'es': [
          'Las emociones son ilimitadas y fluidas',
          'Profundamente empático y compasivo',
          'Fuerte intuición y sensibilidad psíquica',
          'Puede ser abrumado por los sentimientos',
          'Enfoque espiritual y trascendente',
        ],
        'ca': [
          'Les emocions són il·limitades i fluides',
          'Profundament empàtic i compassiu',
          'Forta intuïció i sensibilitat psíquica',
          'Pot ser aclaparat pels sentiments',
          'Enfocament espiritual i transcendent',
        ],
      },
      bestActivities: {
        'en': [
          'Meditation and spiritual practice',
          'Creative arts and music',
          'Compassionate service to others',
          'Dream work and imagination',
          'Water activities and swimming',
        ],
        'es': [
          'Meditación y práctica espiritual',
          'Artes creativas y música',
          'Servicio compasivo a otros',
          'Trabajo de sueños e imaginación',
          'Actividades acuáticas y natación',
        ],
        'ca': [
          'Meditació i pràctica espiritual',
          'Arts creatives i música',
          'Servei compassiu als altres',
          'Treball de somnis i imaginació',
          'Activitats aquàtiques i natació',
        ],
      },
      tarotCard: 'The Moon',
      tarotNumber: 18,
      color: '#9370DB',
      dateRange: '19 Feb - 20 Mar',
    ),
  ];

  /// Get sign by ID
  static MoonSign? getSignById(String id) {
    try {
      return signs.firstWhere((sign) => sign.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get signs by element
  static List<MoonSign> getSignsByElement(String element) {
    return signs.where((sign) => sign.element == element).toList();
  }

  /// Get signs by modality
  static List<MoonSign> getSignsByModality(String modality) {
    return signs.where((sign) => sign.modality == modality).toList();
  }

  /// Get current sun sign (approximately)
  static MoonSign? getCurrentSunSign() {
    try {
      return signs.firstWhere((sign) => sign.isCurrentSunSign);
    } catch (e) {
      return null;
    }
  }
}
