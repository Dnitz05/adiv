import '../models/seasonal_wisdom.dart';

/// Complete repository of Seasonal Wisdom content
/// Based on wheel_of_the_year.md documentation

class SeasonalWisdomData {
  // ============================================================================
  // THE 4 SEASONS
  // ============================================================================

  static final List<Season> seasons = [
    // SPRING
    Season(
      id: 'spring',
      icon: '🌱',
      name: 'Spring',
      localizedNames: {
        'en': 'Spring',
        'es': 'Primavera',
        'ca': 'Primavera',
      },
      archetype: {
        'en': 'The Maiden, the Seed, the Child',
        'es': 'La Doncella, la Semilla, el Niño',
        'ca': 'La Donzella, la Llavor, el Nen',
      },
      description: {
        'en':
            'Spring is the season of awakening and renewal. After the long winter sleep, life bursts forth with unstoppable energy. It\'s a time of fresh starts, hope, and unlimited potential.',
        'es':
            'La Primavera es la estación del despertar y la renovación. Tras el largo sueño invernal, la vida brota con energía imparable. Es tiempo de nuevos comienzos, esperanza y potencial ilimitado.',
        'ca':
            'La Primavera és l\'estació del despertar i la renovació. Després del llarg son hivernal, la vida brolla amb energia imparable. És temps de nous començaments, esperança i potencial il·limitat.',
      },
      energy: {
        'en': 'Expansion, growth, renewal, initiation',
        'es': 'Expansión, crecimiento, renovación, iniciación',
        'ca': 'Expansió, creixement, renovació, iniciació',
      },
      themes: {
        'en': [
          'New beginnings and fresh starts',
          'Hope and optimism',
          'Youth and vitality',
          'Planting seeds (literal and metaphorical)',
          'Action and courage'
        ],
        'es': [
          'Nuevos comienzos y arranques frescos',
          'Esperanza y optimismo',
          'Juventud y vitalidad',
          'Plantar semillas (literal y metafórico)',
          'Acción y coraje'
        ],
        'ca': [
          'Nous començaments i arranques frescos',
          'Esperança i optimisme',
          'Joventut i vitalitat',
          'Plantar llavors (literal i metafòric)',
          'Acció i coratge'
        ],
      },
      zodiacSigns: {
        'en': ['Aries', 'Taurus', 'Gemini'],
        'es': ['Aries', 'Tauro', 'Géminis'],
        'ca': ['Àries', 'Taure', 'Bessons'],
      },
      elements: {
        'en': ['Fire (Aries)', 'Earth (Taurus)', 'Air (Gemini)'],
        'es': ['Fuego (Aries)', 'Tierra (Tauro)', 'Aire (Géminis)'],
        'ca': ['Foc (Àries)', 'Terra (Taure)', 'Aire (Bessons)'],
      },
      color: '#10B981', // Emerald green
      sabbatIds: ['ostara', 'beltane'],
    ),

    // SUMMER
    Season(
      id: 'summer',
      icon: '☀️',
      name: 'Summer',
      localizedNames: {
        'en': 'Summer',
        'es': 'Verano',
        'ca': 'Estiu',
      },
      archetype: {
        'en': 'The Mother, the Flower in Full Bloom, the Adult',
        'es': 'La Madre, la Flor en Plena Floración, el Adulto',
        'ca': 'La Mare, la Flor en Plena Floració, l\'Adult',
      },
      description: {
        'en':
            'Summer is the season of fullness and abundance. The sun reaches its peak power, and life flourishes in all its glory. It\'s a time to celebrate, nurture, and enjoy the fruits of our efforts.',
        'es':
            'El Verano es la estación de plenitud y abundancia. El sol alcanza su máximo poder, y la vida florece en todo su esplendor. Es tiempo de celebrar, nutrir y disfrutar los frutos de nuestro esfuerzo.',
        'ca':
            'L\'Estiu és l\'estació de plenitud i abundància. El sol arriba al seu màxim poder, i la vida floreix en tot el seu esplendor. És temps de celebrar, nodrir i gaudir dels fruits del nostre esforç.',
      },
      energy: {
        'en': 'Culmination, fullness, abundance, maximum light',
        'es': 'Culminación, plenitud, abundancia, luz máxima',
        'ca': 'Culminació, plenitud, abundància, llum màxima',
      },
      themes: {
        'en': [
          'Nurturing and care',
          'Celebration and joy',
          'Creativity and expression',
          'Protection and strength',
          'Gratitude for abundance'
        ],
        'es': [
          'Nutrición y cuidado',
          'Celebración y alegría',
          'Creatividad y expresión',
          'Protección y fuerza',
          'Gratitud por la abundancia'
        ],
        'ca': [
          'Nutrició i cura',
          'Celebració i alegria',
          'Creativitat i expressió',
          'Protecció i força',
          'Gratitud per l\'abundància'
        ],
      },
      zodiacSigns: {
        'en': ['Cancer', 'Leo', 'Virgo'],
        'es': ['Cáncer', 'Leo', 'Virgo'],
        'ca': ['Cranc', 'Lleó', 'Verge'],
      },
      elements: {
        'en': ['Water (Cancer)', 'Fire (Leo)', 'Earth (Virgo)'],
        'es': ['Agua (Cáncer)', 'Fuego (Leo)', 'Tierra (Virgo)'],
        'ca': ['Aigua (Cranc)', 'Foc (Lleó)', 'Terra (Verge)'],
      },
      color: '#F59E0B', // Amber
      sabbatIds: ['litha', 'lughnasadh'],
    ),

    // AUTUMN
    Season(
      id: 'autumn',
      icon: '🍁',
      name: 'Autumn',
      localizedNames: {
        'en': 'Autumn',
        'es': 'Otoño',
        'ca': 'Tardor',
      },
      archetype: {
        'en': 'The Crone, the Harvest, the Elder',
        'es': 'La Anciana, la Cosecha, el Anciano',
        'ca': 'La Crone, la Collita, l\'Avi',
      },
      description: {
        'en':
            'Autumn is the season of gratitude and letting go. As nature prepares for winter, we gather the harvest and release what no longer serves. It\'s a time of wisdom, transformation, and deep appreciation.',
        'es':
            'El Otoño es la estación de gratitud y soltar. Mientras la naturaleza se prepara para el invierno, recogemos la cosecha y soltamos lo que ya no sirve. Es tiempo de sabiduría, transformación y apreciación profunda.',
        'ca':
            'La Tardor és l\'estació de gratitud i deixar anar. Mentre la naturalesa es prepara per l\'hivern, recollim la collita i alliberem el que ja no serveix. És temps de saviesa, transformació i apreciació profunda.',
      },
      energy: {
        'en': 'Decline, preparation, wisdom, letting go',
        'es': 'Declive, preparación, sabiduría, soltar',
        'ca': 'Declivi, preparació, saviesa, deixar anar',
      },
      themes: {
        'en': [
          'Harvesting fruits of labor',
          'Gratitude and appreciation',
          'Letting go of what no longer serves',
          'Preparation for difficult times',
          'Deep transformation'
        ],
        'es': [
          'Cosechar frutos del trabajo',
          'Gratitud y apreciación',
          'Soltar lo que ya no sirve',
          'Preparación para tiempos difíciles',
          'Transformación profunda'
        ],
        'ca': [
          'Collir fruits del treball',
          'Gratitud i apreciació',
          'Deixar anar el que ja no serveix',
          'Preparació per temps difícils',
          'Transformació profunda'
        ],
      },
      zodiacSigns: {
        'en': ['Libra', 'Scorpio', 'Sagittarius'],
        'es': ['Libra', 'Escorpio', 'Sagitario'],
        'ca': ['Balança', 'Escorpió', 'Sagitari'],
      },
      elements: {
        'en': ['Air (Libra)', 'Water (Scorpio)', 'Fire (Sagittarius)'],
        'es': ['Aire (Libra)', 'Agua (Escorpio)', 'Fuego (Sagitario)'],
        'ca': ['Aire (Balança)', 'Aigua (Escorpió)', 'Foc (Sagitari)'],
      },
      color: '#DC2626', // Red
      sabbatIds: ['mabon', 'samhain'],
    ),

    // WINTER
    Season(
      id: 'winter',
      icon: '❄️',
      name: 'Winter',
      localizedNames: {
        'en': 'Winter',
        'es': 'Invierno',
        'ca': 'Hivern',
      },
      archetype: {
        'en': 'The Elder, the Dormant Seed, the Spirit',
        'es': 'El Anciano, la Semilla Dormida, el Espíritu',
        'ca': 'L\'Ancià, la Llavor Adormida, l\'Esperit',
      },
      description: {
        'en':
            'Winter is the season of introspection and renewal. In the quiet darkness, life rests and regenerates. It\'s a time for deep reflection, inner work, and trusting in natural cycles.',
        'es':
            'El Invierno es la estación de introspección y renovación. En la quieta oscuridad, la vida descansa y se regenera. Es tiempo de reflexión profunda, trabajo interior y confiar en los ciclos naturales.',
        'ca':
            'L\'Hivern és l\'estació d\'introspecció i renovació. En la quieta foscor, la vida descansa i es regenera. És temps de reflexió profunda, treball interior i confiar en els cicles naturals.',
      },
      energy: {
        'en': 'Introspection, rest, death, incubation',
        'es': 'Introspección, descanso, muerte, incubación',
        'ca': 'Introspecció, descans, mort, incubació',
      },
      themes: {
        'en': [
          'Rest and recuperation',
          'Deep reflection',
          'Inner planning',
          'Trusting natural cycles',
          'Finding light in darkness'
        ],
        'es': [
          'Descanso y recuperación',
          'Reflexión profunda',
          'Planificación interior',
          'Confiar en los ciclos naturales',
          'Encontrar luz en la oscuridad'
        ],
        'ca': [
          'Descans i recuperació',
          'Reflexió profunda',
          'Planificació interior',
          'Confiar en els cicles naturals',
          'Trobar llum en la foscor'
        ],
      },
      zodiacSigns: {
        'en': ['Capricorn', 'Aquarius', 'Pisces'],
        'es': ['Capricornio', 'Acuario', 'Piscis'],
        'ca': ['Capricorn', 'Aquari', 'Peixos'],
      },
      elements: {
        'en': ['Earth (Capricorn)', 'Air (Aquarius)', 'Water (Pisces)'],
        'es': ['Tierra (Capricornio)', 'Aire (Acuario)', 'Agua (Piscis)'],
        'ca': ['Terra (Capricorn)', 'Aire (Aquari)', 'Aigua (Peixos)'],
      },
      color: '#3B82F6', // Blue
      sabbatIds: ['yule', 'imbolc'],
    ),
  ];

  // ============================================================================
  // THE 8 SABBATS
  // ============================================================================

  static final List<Sabbat> sabbats = [
    // YULE - Winter Solstice
    Sabbat(
      id: 'yule',
      icon: '❄️',
      name: 'Yule',
      localizedNames: {
        'en': 'Yule',
        'es': 'Yule',
        'ca': 'Yule',
      },
      type: 'solar',
      date: '~21 December',
      astrological: {
        'en': 'Sun enters Capricorn (0° Capricorn)',
        'es': 'El Sol entra en Capricornio (0° Capricornio)',
        'ca': 'El Sol entra a Capricorn (0° Capricorn)',
      },
      element: 'Earth',
      modality: 'Cardinal',
      meaning: {
        'en': 'Rebirth of the Sun - Longest Night, Return of Light',
        'es': 'Renacimiento del Sol - Noche Más Larga, Retorno de la Luz',
        'ca': 'Renaixement del Sol - Nit Més Llarga, Retorn de la Llum',
      },
      description: {
        'en':
            'Yule marks the longest night of the year and the rebirth of the sun. From this point forward, days begin to lengthen. In the darkest moment, we celebrate the return of light and hold faith that warmth will return. Ancient traditions include burning yule logs to call back the sun, decorating with evergreens as symbols of eternal life, and gathering with family to share warmth and hope.',
        'es':
            'Yule marca la noche más larga del año y el renacimiento del sol. A partir de este punto, los días comienzan a alargarse. En el momento más oscuro, celebramos el retorno de la luz y mantenemos la fe en que el calor regresará. Las tradiciones antiguas incluyen quemar troncos de yule para llamar al sol, decorar con plantas perennes como símbolos de vida eterna, y reunirse en familia para compartir calor y esperanza.',
        'ca':
            'Yule marca la nit més llarga de l\'any i el renaixement del sol. A partir d\'aquest punt, els dies comencen a allargar-se. En el moment més fosc, celebrem el retorn de la llum i mantenim la fe que la calor tornarà. Les tradicions antigues inclouen cremar tronques de yule per cridar el sol, decorar amb plantes perennes com a símbols de vida eterna, i reunir-se en família per compartir calor i esperança.',
      },
      traditions: {
        'en': [
          'Burning yule logs to call the sun',
          'Decorating with evergreens (symbol of eternal life)',
          'Family feasts and gatherings',
          'Gift giving (generosity in times of scarcity)',
          'Lighting candles in darkness'
        ],
        'es': [
          'Quemar troncos de yule para llamar al sol',
          'Decorar con perennes (símbolo de vida eterna)',
          'Festines y reuniones familiares',
          'Dar regalos (generosidad en tiempos de escasez)',
          'Encender velas en la oscuridad'
        ],
        'ca': [
          'Cremar tronques de yule per cridar el sol',
          'Decorar amb perennes (símbol de vida eterna)',
          'Festins i reunions familiars',
          'Donar regals (generositat en temps de mancança)',
          'Encendre espelmes en la foscor'
        ],
      },
      themes: {
        'en': [
          'Finding inner light in dark moments',
          'Planting seeds of intentions for spring',
          'Valuing rest and recovery',
          'Celebrating persistence and hope',
          'Family and home'
        ],
        'es': [
          'Encontrar luz interior en momentos oscuros',
          'Plantar semillas de intenciones para primavera',
          'Valorar el descanso y la recuperación',
          'Celebrar la persistencia y la esperanza',
          'Familia y hogar'
        ],
        'ca': [
          'Trobar llum interior en moments foscos',
          'Plantar llavors d\'intencions per primavera',
          'Valorar el descans i la recuperació',
          'Celebrar la persistència i l\'esperança',
          'Família i llar'
        ],
      },
      color: '#3B82F6',
      seasonId: 'winter',
    ),

    // IMBOLC
    Sabbat(
      id: 'imbolc',
      icon: '🕯️',
      name: 'Imbolc',
      localizedNames: {
        'en': 'Imbolc',
        'es': 'Imbolc',
        'ca': 'Imbolc',
      },
      type: 'fire',
      date: '~1-2 February',
      astrological: {
        'en': 'Midpoint between Capricorn and Aries (~15° Aquarius)',
        'es': 'Punto medio entre Capricornio y Aries (~15° Acuario)',
        'ca': 'Punt mig entre Capricorn i Àries (~15° Aquari)',
      },
      element: 'Air',
      modality: 'Fixed',
      meaning: {
        'en': 'First Signs of Spring - Purification and Renewal',
        'es': 'Primeros Signos de Primavera - Purificación y Renovación',
        'ca': 'Primers Signes de Primavera - Purificació i Renovació',
      },
      description: {
        'en':
            'Imbolc celebrates the first stirrings of spring. Light is growing, days are lengthening, and life begins to awaken. Associated with the Celtic goddess Brigid (fire, poetry, healing, smithcraft), this is a time of purification and preparation. Traditionally, it marks the first lambing of sheep (beginning of lactation - "Imbolc" means "in the belly"). This is when we clean and prepare for new life to come.',
        'es':
            'Imbolc celebra los primeros movimientos de la primavera. La luz está creciendo, los días se alargan, y la vida comienza a despertar. Asociado con la diosa celta Brigid (fuego, poesía, curación, herrería), es un tiempo de purificación y preparación. Tradicionalmente, marca el primer parto de las ovejas (inicio de lactancia - "Imbolc" significa "en el vientre"). Es cuando limpiamos y preparamos para la nueva vida que vendrá.',
        'ca':
            'Imbolc celebra els primers moviments de la primavera. La llum està creixent, els dies s\'allarguen, i la vida comença a despertar. Associat amb la deessa celta Brigid (foc, poesia, curació, ferreria), és un temps de purificació i preparació. Tradicionalment, marca el primer part de les ovelles (inici de lactància - "Imbolc" significa "a la panxa"). És quan netegem i preparem per la nova vida que vindrà.',
      },
      traditions: {
        'en': [
          'Lighting candles to honor Brigid',
          'Spring cleaning (anticipating new growth)',
          'Blessing seeds for planting',
          'Rituals of renewal and purification',
          'Making Brigid\'s crosses from reeds'
        ],
        'es': [
          'Encender velas para honrar a Brigid',
          'Limpieza de primavera (anticipando nuevo crecimiento)',
          'Bendecir semillas para plantar',
          'Rituales de renovación y purificación',
          'Hacer cruces de Brigid con juncos'
        ],
        'ca': [
          'Encendre espelmes per honrar a Brigid',
          'Neteja de primavera (anticipant nou creixement)',
          'Beneir llavors per plantar',
          'Rituals de renovació i purificació',
          'Fer creus de Brigid amb joncs'
        ],
      },
      themes: {
        'en': [
          'Gradual awakening after winter',
          'Cleaning and preparation for new beginnings',
          'Nurturing nascent creativity',
          'Hope and anticipation',
          'Inner fire and inspiration'
        ],
        'es': [
          'Despertar gradual después del invierno',
          'Limpieza y preparación para nuevos comienzos',
          'Nutrir la creatividad naciente',
          'Esperanza y anticipación',
          'Fuego interior e inspiración'
        ],
        'ca': [
          'Despertar gradual després de l\'hivern',
          'Neteja i preparació per nous començaments',
          'Nodrir la creativitat naixent',
          'Esperança i anticipació',
          'Foc interior i inspiració'
        ],
      },
      color: '#EC4899',
      seasonId: 'winter',
    ),

    // OSTARA - Spring Equinox
    Sabbat(
      id: 'ostara',
      icon: '🌸',
      name: 'Ostara',
      localizedNames: {
        'en': 'Ostara',
        'es': 'Ostara',
        'ca': 'Ostara',
      },
      type: 'solar',
      date: '~20-21 March',
      astrological: {
        'en': 'Sun enters Aries (0° Aries) - ASTROLOGICAL NEW YEAR',
        'es': 'El Sol entra en Aries (0° Aries) - AÑO NUEVO ASTROLÓGICO',
        'ca': 'El Sol entra a Àries (0° Àries) - ANY NOU ASTROLÒGIC',
      },
      element: 'Fire',
      modality: 'Cardinal',
      meaning: {
        'en': 'Perfect Balance of Light and Dark - Burst of New Life',
        'es': 'Equilibrio Perfecto de Luz y Oscuridad - Estallido de Nueva Vida',
        'ca': 'Equilibri Perfecte de Llum i Foscor - Esclat de Vida Nova',
      },
      description: {
        'en':
            'Ostara marks the spring equinox when day equals night - perfect balance before light overtakes darkness. Named after the Germanic goddess Eostre (from which "Easter" derives), this is a celebration of fertility, renewal, and explosive growth. Seeds germinate, flowers bloom, and life bursts forth. Eggs and hares are ancient fertility symbols. This is the astrological new year when the sun enters Aries - time for courageous new beginnings.',
        'es':
            'Ostara marca el equinoccio de primavera cuando el día iguala la noche - equilibrio perfecto antes de que la luz supere la oscuridad. Nombrado por la diosa germánica Eostre (de la cual deriva "Easter/Pascua"), es una celebración de fertilidad, renovación y crecimiento explosivo. Las semillas germinan, las flores florecen, y la vida brota con fuerza. Huevos y liebres son símbolos antiguos de fertilidad. Es el año nuevo astrológico cuando el sol entra en Aries - tiempo de nuevos comienzos valientes.',
        'ca':
            'Ostara marca l\'equinocci de primavera quan el dia iguala la nit - equilibri perfecte abans que la llum superi la foscor. Anomenat per la deessa germànica Eostre (de la qual deriva "Easter"), és una celebració de fertilitat, renovació i creixement explosiu. Les llavors germinen, les flors floreixen, i la vida brolla amb força. Ous i llebres són símbols antics de fertilitat. És l\'any nou astrològic quan el sol entra a Àries - temps de nous començaments valents.',
      },
      traditions: {
        'en': [
          'Painting eggs (symbol of new life)',
          'Planting gardens',
          'Balance ritual (light/dark, masculine/feminine)',
          'Celebrating rebirth and renewal',
          'Welcoming the return of warmth'
        ],
        'es': [
          'Pintar huevos (símbolo de nueva vida)',
          'Plantar jardines',
          'Ritual de equilibrio (luz/oscuridad, masculino/femenino)',
          'Celebrar el renacimiento y la renovación',
          'Dar la bienvenida al retorno del calor'
        ],
        'ca': [
          'Pintar ous (símbol de vida nova)',
          'Plantar jardins',
          'Ritual d\'equilibri (llum/foscor, masculí/femení)',
          'Celebrar el renaixement i la renovació',
          'Donar la benvinguda al retorn de la calor'
        ],
      },
      themes: {
        'en': [
          'NEW BEGINNINGS (Aries energy!)',
          'Courage to start projects',
          'Balancing polarities in life',
          'Celebrating potential and possibility',
          'Decisive action toward dreams'
        ],
        'es': [
          'NUEVOS COMIENZOS (¡energía de Aries!)',
          'Coraje para empezar proyectos',
          'Equilibrar polaridades en la vida',
          'Celebrar potencial y posibilidad',
          'Acción decidida hacia los sueños'
        ],
        'ca': [
          'NOUS COMENÇAMENTS (energia d\'Àries!)',
          'Coratge per començar projectes',
          'Equilibrar polaritats en la vida',
          'Celebrar potencial i possibilitat',
          'Acció decidida cap a somnis'
        ],
      },
      color: '#10B981',
      seasonId: 'spring',
    ),

    // BELTANE
    Sabbat(
      id: 'beltane',
      icon: '🔥',
      name: 'Beltane',
      localizedNames: {
        'en': 'Beltane',
        'es': 'Beltane',
        'ca': 'Beltane',
      },
      type: 'fire',
      date: '~30 April - 1 May',
      astrological: {
        'en': 'Midpoint between Aries and Cancer (~15° Taurus)',
        'es': 'Punto medio entre Aries y Cáncer (~15° Tauro)',
        'ca': 'Punt mig entre Àries i Cranc (~15° Taure)',
      },
      element: 'Earth',
      modality: 'Fixed',
      meaning: {
        'en': 'Fullness of Spring - Fertility and Passion',
        'es': 'Plenitud de Primavera - Fertilidad y Pasión',
        'ca': 'Plenitud de Primavera - Fertilitat i Passió',
      },
      description: {
        'en':
            'Beltane celebrates spring at its peak - maximum flowering and vitality. This is the most sensual and passionate of the sabbats, honoring sexuality, fertility, and life force. Traditionally marked by bonfires (bel-fires), the maypole dance (phallic and yoni union), and the Great Rite (sacred sexual union). Young people would crown May Queens and Kings. It\'s about celebrating passion, pleasure, and the creative life force in all its forms.',
        'es':
            'Beltane celebra la primavera en su apogeo - máxima floración y vitalidad. Es el más sensual y apasionado de los sabbats, honrando la sexualidad, fertilidad y fuerza vital. Tradicionalmente marcado por hogueras (fuegos-bel), la danza del maypole (unión fálica y yónica), y el Gran Rito (unión sexual sagrada). Los jóvenes coronaban Reinas y Reyes de Mayo. Se trata de celebrar la pasión, el placer y la fuerza vital creativa en todas sus formas.',
        'ca':
            'Beltane celebra la primavera en el seu apogeu - màxima floració i vitalitat. És el més sensual i apassionat dels sabbats, honorant la sexualitat, fertilitat i força vital. Tradicionalment marcat per fogueres (focs-bel), la dansa del maypole (unió fàl·lica i iònica), i el Gran Ritu (unió sexual sagrada). Els joves coronaven Reines i Reis de Maig. Es tracta de celebrar la passió, el plaer i la força vital creativa en totes les seves formes.',
      },
      traditions: {
        'en': [
          'Jumping over Beltane fires',
          'Maypole dancing',
          'Crowning May Queens and Kings',
          'Collecting May dew (for beauty)',
          'Sacred union ritual (Great Rite)'
        ],
        'es': [
          'Saltar sobre fuegos de Beltane',
          'Danza del maypole',
          'Coronar Reinas y Reyes de Mayo',
          'Recoger rocío de mayo (para belleza)',
          'Ritual de unión sagrada (Gran Rito)'
        ],
        'ca': [
          'Saltar sobre focs de Beltane',
          'Dansa del maypole',
          'Coronar Reines i Reis de Maig',
          'Recollir rosada de maig (per bellesa)',
          'Ritual d\'unió sagrada (Gran Ritu)'
        ],
      },
      themes: {
        'en': [
          'Celebrating passion and desire',
          'Union and connection (with others, with nature)',
          'Fertility (literal and metaphorical)',
          'Joy and sensory pleasure',
          'Creativity in full bloom'
        ],
        'es': [
          'Celebrar pasión y deseo',
          'Unión y conexión (con otros, con la naturaleza)',
          'Fertilidad (literal y metafórica)',
          'Alegría y placer sensorial',
          'Creatividad en plena floración'
        ],
        'ca': [
          'Celebrar passió i desig',
          'Unió i connexió (amb altres, amb la naturalesa)',
          'Fertilitat (literal i metafòrica)',
          'Alegria i plaer sensorial',
          'Creativitat en plena floració'
        ],
      },
      color: '#EC4899',
      seasonId: 'spring',
    ),

    // LITHA - Summer Solstice
    Sabbat(
      id: 'litha',
      icon: '☀️',
      name: 'Litha',
      localizedNames: {
        'en': 'Litha',
        'es': 'Litha',
        'ca': 'Litha',
      },
      type: 'solar',
      date: '~20-21 June',
      astrological: {
        'en': 'Sun enters Cancer (0° Cancer)',
        'es': 'El Sol entra en Cáncer (0° Cáncer)',
        'ca': 'El Sol entra a Cranc (0° Cranc)',
      },
      element: 'Water',
      modality: 'Cardinal',
      meaning: {
        'en': 'Longest Day - Peak of Solar Power',
        'es': 'Día Más Largo - Pico del Poder Solar',
        'ca': 'Dia Més Llarg - Pic del Poder Solar',
      },
      description: {
        'en':
            'Litha marks the summer solstice - the longest day and shortest night of the year. The sun reaches its maximum power, yet from this moment, it begins to decline. This bittersweet celebration honors both triumph and the knowledge that all things are cyclical. Midsummer is associated with magic, fairies (Shakespeare!), and enchantment. Traditionally, this is the best time to gather medicinal herbs at their peak potency, especially St. John\'s Wort.',
        'es':
            'Litha marca el solsticio de verano - el día más largo y la noche más corta del año. El sol alcanza su máximo poder, pero desde este momento, comienza a declinar. Esta celebración agridulce honra tanto el triunfo como el conocimiento de que todas las cosas son cíclicas. El solsticio de verano se asocia con magia, hadas (¡Shakespeare!), y encantamiento. Tradicionalmente, es el mejor momento para recoger hierbas medicinales en su máxima potencia, especialmente la hierba de San Juan.',
        'ca':
            'Litha marca el solstici d\'estiu - el dia més llarg i la nit més curta de l\'any. El sol arriba al seu màxim poder, però des d\'aquest moment, comença a declinar. Aquesta celebració agredolça honra tant el triomf com el coneixement que totes les coses són cícliques. El solstici d\'estiu s\'associa amb màgia, fades (Shakespeare!), i encantament. Tradicionalment, és el millor moment per recollir herbes medicinals en la seva màxima potència, especialment l\'herba de Sant Joan.',
      },
      traditions: {
        'en': [
          'Making bonfires of solstice',
          'Gathering herbs (St. John\'s Wort)',
          'Watching the sun rise',
          'Celebrations at Stonehenge',
          'Gratitude ritual to the sun'
        ],
        'es': [
          'Hacer hogueras de solsticio',
          'Recoger hierbas (Hierba de San Juan)',
          'Ver el sol salir',
          'Celebraciones en Stonehenge',
          'Ritual de gratitud al sol'
        ],
        'ca': [
          'Fer fogueres de solstici',
          'Recollir herbes (Herba de Sant Joan)',
          'Veure el sol sortir',
          'Celebracions a Stonehenge',
          'Ritual de gratitud al sol'
        ],
      },
      themes: {
        'en': [
          'Celebrating successes and culminations',
          'Recognizing that nothing lasts forever (all has cycles)',
          'Gratitude for abundance',
          'Magic and wonder',
          'Protection and strength'
        ],
        'es': [
          'Celebrar éxitos y culminaciones',
          'Reconocer que nada dura para siempre (todo tiene ciclos)',
          'Gratitud por la abundancia',
          'Magia y maravilla',
          'Protección y fuerza'
        ],
        'ca': [
          'Celebrar èxits i culminacions',
          'Reconèixer que res dura per sempre (tot té cicles)',
          'Gratitud per l\'abundància',
          'Màgia i meravella',
          'Protecció i força'
        ],
      },
      color: '#F59E0B',
      seasonId: 'summer',
    ),

    // LUGHNASADH
    Sabbat(
      id: 'lughnasadh',
      icon: '🌾',
      name: 'Lughnasadh',
      localizedNames: {
        'en': 'Lughnasadh (Lammas)',
        'es': 'Lughnasadh (Lammas)',
        'ca': 'Lughnasadh (Lammas)',
      },
      type: 'fire',
      date: '~1 August',
      astrological: {
        'en': 'Midpoint between Cancer and Libra (~15° Leo)',
        'es': 'Punto medio entre Cáncer y Libra (~15° Leo)',
        'ca': 'Punt mig entre Cranc i Balança (~15° Lleó)',
      },
      element: 'Fire',
      modality: 'Fixed',
      meaning: {
        'en': 'First Harvest - Grain and Gratitude',
        'es': 'Primera Cosecha - Grano y Gratitud',
        'ca': 'Primera Collita - Gra i Gratitud',
      },
      description: {
        'en':
            'Lughnasadh celebrates the first harvest - grain, wheat, and bread. Named after the Celtic solar god Lugh (skills, craftsmanship), this is when we reap what we\'ve sown. The Grain God dies to feed us - a sacred sacrifice theme. Traditionally marked by baking bread from the first grain, making corn dollies, athletic games (Tailteann Games), and sharing the harvest with community. It\'s about gratitude, skill, and recognizing necessary sacrifices.',
        'es':
            'Lughnasadh celebra la primera cosecha - grano, trigo y pan. Nombrado por el dios solar celta Lugh (habilidades, artesanía), es cuando cosechamos lo que hemos sembrado. El Dios del Grano muere para alimentarnos - tema de sacrificio sagrado. Tradicionalmente marcado por hornear pan del primer grano, hacer muñecos de maíz, juegos atléticos (Juegos de Tailteann), y compartir la cosecha con la comunidad. Se trata de gratitud, habilidad y reconocer sacrificios necesarios.',
        'ca':
            'Lughnasadh celebra la primera collita - gra, blat i pa. Anomenat pel déu solar celta Lugh (habilitats, artesania), és quan collim el que hem sembrat. El Déu del Gra mor per alimentar-nos - tema de sacrifici sagrat. Tradicionalment marcat per coure pa del primer gra, fer monyecos de blat, jocs atlètics (Jocs de Tailteann), i compartir la collita amb la comunitat. Es tracta de gratitud, habilitat i reconèixer sacrificis necessaris.',
      },
      traditions: {
        'en': [
          'Baking bread from first grain',
          'Making corn dollies',
          'Athletic competitions (Tailteann Games)',
          'Sharing first harvest',
          'Giving thanks for abundance'
        ],
        'es': [
          'Hornear pan del primer grano',
          'Hacer muñecos de maíz',
          'Competiciones atléticas (Juegos de Tailteann)',
          'Compartir primera cosecha',
          'Dar gracias por la abundancia'
        ],
        'ca': [
          'Coure pa del primer gra',
          'Fer monyecos de blat',
          'Competicions atlètiques (Jocs de Tailteann)',
          'Compartir primera collita',
          'Donar gràcies per l\'abundància'
        ],
      },
      themes: {
        'en': [
          'Harvesting fruits of labor (metaphorical and literal)',
          'Gratitude for successes',
          'Necessary sacrifice (giving up something to gain something)',
          'Sharing with community',
          'Celebrating talents and skills'
        ],
        'es': [
          'Cosechar frutos del trabajo (metafórico y literal)',
          'Gratitud por los éxitos',
          'Sacrificio necesario (renunciar a algo para ganar algo)',
          'Compartir con la comunidad',
          'Celebrar talentos y habilidades'
        ],
        'ca': [
          'Collir fruits del treball (metafòric i literal)',
          'Gratitud per èxits',
          'Sacrifici necessari (renunciar a algo per guanyar algo)',
          'Compartir amb la comunitat',
          'Celebrar talents i habilitats'
        ],
      },
      color: '#F59E0B',
      seasonId: 'summer',
    ),

    // MABON - Autumn Equinox
    Sabbat(
      id: 'mabon',
      icon: '🍂',
      name: 'Mabon',
      localizedNames: {
        'en': 'Mabon',
        'es': 'Mabon',
        'ca': 'Mabon',
      },
      type: 'solar',
      date: '~21-23 September',
      astrological: {
        'en': 'Sun enters Libra (0° Libra)',
        'es': 'El Sol entra en Libra (0° Libra)',
        'ca': 'El Sol entra a Balança (0° Balança)',
      },
      element: 'Air',
      modality: 'Cardinal',
      meaning: {
        'en': 'Second Balance - Preparation and Thanksgiving',
        'es': 'Segundo Equilibrio - Preparación y Acción de Gracias',
        'ca': 'Segon Equilibri - Preparació i Acció de Gràcies',
      },
      description: {
        'en':
            'Mabon marks the autumn equinox - the second time in the year when day equals night. This is the balance before darkness overtakes light. The second harvest of fruits, vegetables, and wine is gathered. This is the "Pagan Thanksgiving" - a time of deep gratitude for what we\'ve received and preparation for the difficult months ahead. We preserve food, balance aspects of our lives, and appreciate the abundance we have.',
        'es':
            'Mabon marca el equinoccio de otoño - la segunda vez en el año cuando el día iguala la noche. Es el equilibrio antes de que la oscuridad supere la luz. Se recoge la segunda cosecha de frutas, verduras y vino. Es el "Día de Acción de Gracias Pagano" - un tiempo de profunda gratitud por lo que hemos recibido y preparación para los meses difíciles que vienen. Conservamos alimentos, equilibramos aspectos de nuestras vidas, y apreciamos la abundancia que tenemos.',
        'ca':
            'Mabon marca l\'equinocci de tardor - la segona vegada a l\'any quan el dia iguala la nit. És l\'equilibri abans que la foscor superi la llum. Es recull la segona collita de fruites, verdures i vi. És el "Dia d\'Acció de Gràcies Pagà" - un temps de profunda gratitud pel que hem rebut i preparació per als mesos difícils que vénen. Conservem aliments, equilibrem aspectes de les nostres vides, i apreciem l\'abundància que tenim.',
      },
      traditions: {
        'en': [
          'Making wine and preserves',
          'Decorating with autumn fruits',
          'Thanksgiving ritual',
          'Balancing aspects of life',
          'Preparing for difficult times'
        ],
        'es': [
          'Hacer vino y conservas',
          'Decorar con frutas de otoño',
          'Ritual de acción de gracias',
          'Equilibrar aspectos de la vida',
          'Preparar para tiempos difíciles'
        ],
        'ca': [
          'Fer vi i conserves',
          'Decorar amb fruites de tardor',
          'Ritual d\'acció de gràcies',
          'Equilibrar aspectes de la vida',
          'Preparar per temps difícils'
        ],
      },
      themes: {
        'en': [
          'Balance and harmony (Libra!)',
          'Deep gratitude',
          'Preparation and planning',
          'Letting go of what you don\'t need',
          'Sharing abundance with others'
        ],
        'es': [
          'Equilibrio y armonía (¡Libra!)',
          'Gratitud profunda',
          'Preparación y planificación',
          'Soltar lo que no necesitas',
          'Compartir abundancia con otros'
        ],
        'ca': [
          'Equilibri i harmonia (Balança!)',
          'Gratitud profunda',
          'Preparació i planificació',
          'Deixar anar el que no necessites',
          'Compartir abundància amb altres'
        ],
      },
      color: '#DC2626',
      seasonId: 'autumn',
    ),

    // SAMHAIN
    Sabbat(
      id: 'samhain',
      icon: '🎃',
      name: 'Samhain',
      localizedNames: {
        'en': 'Samhain',
        'es': 'Samhain',
        'ca': 'Samhain',
      },
      type: 'fire',
      date: '~31 October - 1 November',
      astrological: {
        'en': 'Midpoint between Libra and Capricorn (~15° Scorpio)',
        'es': 'Punto medio entre Libra y Capricornio (~15° Escorpio)',
        'ca': 'Punt mig entre Balança i Capricorn (~15° Escorpió)',
      },
      element: 'Water',
      modality: 'Fixed',
      meaning: {
        'en': 'Celtic New Year - The Veil is Thin',
        'es': 'Año Nuevo Celta - El Velo es Delgado',
        'ca': 'Any Nou Celta - El Vel és Prim',
      },
      description: {
        'en':
            'Samhain marks the Celtic New Year and the beginning of winter. This is the third and final harvest - the slaughter of animals for winter survival. Most importantly, this is when the veil between worlds is thinnest, allowing communication with the dead and spirit world. It\'s a time to honor ancestors, accept death as part of life, and embrace transformation. The origins of modern Halloween come from Samhain traditions of warding off spirits and honoring the dead.',
        'es':
            'Samhain marca el Año Nuevo Celta y el comienzo del invierno. Esta es la tercera y última cosecha - el sacrificio de animales para sobrevivir al invierno. Más importante aún, es cuando el velo entre mundos es más delgado, permitiendo la comunicación con los muertos y el mundo espiritual. Es un tiempo para honrar a los ancestros, aceptar la muerte como parte de la vida, y abrazar la transformación. Los orígenes del Halloween moderno vienen de tradiciones de Samhain de protegerse de espíritus y honrar a los muertos.',
        'ca':
            'Samhain marca l\'Any Nou Celta i el començament de l\'hivern. Aquesta és la tercera i última collita - el sacrifici d\'animals per sobreviure a l\'hivern. Més important encara, és quan el vel entre mons és més prim, permetent la comunicació amb els morts i el món espiritual. És un temps per honrar els ancestres, acceptar la mort com a part de la vida, i abraçar la transformació. Els orígens del Halloween modern vénen de tradicions de Samhain de protegir-se dels esperits i honorar als morts.',
      },
      traditions: {
        'en': [
          'Leaving food for the dead',
          'Lighting bonfires to guide spirits',
          'Divination (especially marriage)',
          'Carving turnips (predecessors of jack-o\'-lanterns)',
          'Ancestral ritual'
        ],
        'es': [
          'Dejar comida para los muertos',
          'Encender hogueras para guiar espíritus',
          'Adivinación (especialmente matrimonio)',
          'Tallar nabos (predecesores de jack-o\'-lanterns)',
          'Ritual ancestral'
        ],
        'ca': [
          'Deixar menjar per als morts',
          'Encendre fogueres per guiar esperits',
          'Endevinació (especialment matrimoni)',
          'Tallar naps (predecessors de jack-o\'-lanterns)',
          'Ritual d\'ancestres'
        ],
      },
      themes: {
        'en': [
          'Deep transformation (Scorpio!)',
          'Honoring ancestors and roots',
          'Letting die what no longer serves',
          'Mystery and the unknown',
          'End and beginning (complete cycle)'
        ],
        'es': [
          'Transformación profunda (¡Escorpio!)',
          'Honrar ancestros y raíces',
          'Dejar morir lo que ya no sirve',
          'Misterio y lo desconocido',
          'Fin y comienzo (ciclo completo)'
        ],
        'ca': [
          'Transformació profunda (Escorpió!)',
          'Honrar ancestres i arrels',
          'Deixar morir el que ja no serveix',
          'Misteri i allò desconegut',
          'Fi i inici (cicle complet)'
        ],
      },
      color: '#7C3AED',
      seasonId: 'autumn',
    ),
  ];

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  static Season? getSeasonById(String id) {
    try {
      return seasons.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  static Sabbat? getSabbatById(String id) {
    try {
      return sabbats.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Sabbat> getSabbatsForSeason(String seasonId) {
    return sabbats.where((s) => s.seasonId == seasonId).toList();
  }

  static List<Sabbat> getSolarFestivals() {
    return sabbats.where((s) => s.type == 'solar').toList();
  }

  static List<Sabbat> getFireFestivals() {
    return sabbats.where((s) => s.type == 'fire').toList();
  }
}
