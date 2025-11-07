// Model for lunar tarot spreads - ALL SPREADS FROM DOCUMENTED SOURCES
// IMPORTANT: Every spread must include source attribution to maintain authenticity

class SpreadPosition {
  final int order;
  final String questionEn;
  final String questionEs;
  final String questionCa;

  const SpreadPosition({
    required this.order,
    required this.questionEn,
    required this.questionEs,
    required this.questionCa,
  });

  String getQuestion(String locale) {
    switch (locale) {
      case 'es':
        return questionEs;
      case 'ca':
        return questionCa;
      default:
        return questionEn;
    }
  }
}

class LunarSpread {
  final String id;
  final String nameEn;
  final String nameEs;
  final String nameCa;
  final String descriptionEn;
  final String descriptionEs;
  final String descriptionCa;
  final List<String> phases; // Which moon phases this spread is for
  final int numberOfCards;
  final List<SpreadPosition> positions;
  final String sourceEn; // Source attribution - REQUIRED
  final String sourceEs;
  final String sourceCa;
  final String sourceUrl; // URL to original source
  final String iconEmoji;

  const LunarSpread({
    required this.id,
    required this.nameEn,
    required this.nameEs,
    required this.nameCa,
    required this.descriptionEn,
    required this.descriptionEs,
    required this.descriptionCa,
    required this.phases,
    required this.numberOfCards,
    required this.positions,
    required this.sourceEn,
    required this.sourceEs,
    required this.sourceCa,
    required this.sourceUrl,
    required this.iconEmoji,
  });

  String getName(String locale) {
    switch (locale) {
      case 'es':
        return nameEs;
      case 'ca':
        return nameCa;
      default:
        return nameEn;
    }
  }

  String getDescription(String locale) {
    switch (locale) {
      case 'es':
        return descriptionEs;
      case 'ca':
        return descriptionCa;
      default:
        return descriptionEn;
    }
  }

  String getSource(String locale) {
    switch (locale) {
      case 'es':
        return sourceEs;
      case 'ca':
        return sourceCa;
      default:
        return sourceEn;
    }
  }
}

// Repository with authentic lunar tarot spreads from documented sources
class LunarSpreadRepository {
  static final List<LunarSpread> allSpreads = [
    // BIDDY TAROT - Brigit Esselmont (highly respected tarot authority)
    LunarSpread(
      id: 'biddy_full_moon_release',
      nameEn: 'Full Moon Release & Gratitude',
      nameEs: 'Liberación y Gratitud de Luna Llena',
      nameCa: 'Alliberament i Gratitud de Lluna Plena',
      descriptionEn: 'Honor achievements and release what no longer serves during the full moon\'s peak energy',
      descriptionEs: 'Honra logros y libera lo que ya no sirve durante la energía pico de la luna llena',
      descriptionCa: 'Honra assoliments i allibera el que ja no serveix durant l\'energia pic de la lluna plena',
      phases: ['full_moon'],
      numberOfCards: 6,
      positions: [
        SpreadPosition(
          order: 1,
          questionEn: 'What have I created and manifested since the new moon?',
          questionEs: '¿Qué he creado y manifestado desde la luna nueva?',
          questionCa: 'Què he creat i manifestat des de la lluna nova?',
        ),
        SpreadPosition(
          order: 2,
          questionEn: 'Where am I now?',
          questionEs: '¿Dónde estoy ahora?',
          questionCa: 'On estic ara?',
        ),
        SpreadPosition(
          order: 3,
          questionEn: 'What is coming into my conscious awareness?',
          questionEs: '¿Qué está llegando a mi consciencia?',
          questionCa: 'Què està arribant a la meva consciència?',
        ),
        SpreadPosition(
          order: 4,
          questionEn: 'What is no longer serving me?',
          questionEs: '¿Qué ya no me sirve?',
          questionCa: 'Què ja no em serveix?',
        ),
        SpreadPosition(
          order: 5,
          questionEn: 'How can I release and let go of these energies?',
          questionEs: '¿Cómo puedo liberar y soltar estas energías?',
          questionCa: 'Com puc alliberar i deixar anar aquestes energies?',
        ),
        SpreadPosition(
          order: 6,
          questionEn: 'What additional resources are available to me as I release and let go?',
          questionEs: '¿Qué recursos adicionales están disponibles mientras libero y suelto?',
          questionCa: 'Quins recursos addicionals estan disponibles mentre allibero i deixo anar?',
        ),
      ],
      sourceEn: 'Source: Biddy Tarot (Brigit Esselmont)',
      sourceEs: 'Fuente: Biddy Tarot (Brigit Esselmont)',
      sourceCa: 'Font: Biddy Tarot (Brigit Esselmont)',
      sourceUrl: 'https://www.biddytarot.com/blog/full-moon-tarot-spread-and-ritual/',
      iconEmoji: '🌕',
    ),

    // WAYFINDER TAROT - New Moon Spread
    LunarSpread(
      id: 'wayfinder_new_moon',
      nameEn: 'New Moon Intention Setting',
      nameEs: 'Establecer Intenciones de Luna Nueva',
      nameCa: 'Establir Intencions de Lluna Nova',
      descriptionEn: 'Set intentions and plant seeds for the lunar cycle ahead during the new moon\'s dark phase',
      descriptionEs: 'Establece intenciones y planta semillas para el ciclo lunar durante la fase oscura de la luna nueva',
      descriptionCa: 'Estableix intencions i planta llavors per al cicle lunar durant la fase fosca de la lluna nova',
      phases: ['new_moon'],
      numberOfCards: 3,
      positions: [
        SpreadPosition(
          order: 1,
          questionEn: 'What am I metaphorically bleeding away? Letting go of?',
          questionEs: '¿Qué estoy dejando ir metafóricamente?',
          questionCa: 'Què estic deixant anar metafòricament?',
        ),
        SpreadPosition(
          order: 2,
          questionEn: 'What dreams or intentions should I set?',
          questionEs: '¿Qué sueños o intenciones debo establecer?',
          questionCa: 'Quins somnis o intencions hauria d\'establir?',
        ),
        SpreadPosition(
          order: 3,
          questionEn: 'What wisdom am I bringing forth from within me during this dark time of rest?',
          questionEs: '¿Qué sabiduría estoy sacando de dentro durante este tiempo oscuro de descanso?',
          questionCa: 'Quina saviesa estic traient de dins durant aquest temps fosc de descans?',
        ),
      ],
      sourceEn: 'Source: Wayfinder Tarot',
      sourceEs: 'Fuente: Wayfinder Tarot',
      sourceCa: 'Font: Wayfinder Tarot',
      sourceUrl: 'https://wayfindertarot.com/tarot-spreads-for-the-new-and-full-moon/',
      iconEmoji: '🌑',
    ),

    // WAYFINDER TAROT - Full Moon Spread
    LunarSpread(
      id: 'wayfinder_full_moon',
      nameEn: 'Full Moon Illumination',
      nameEs: 'Iluminación de Luna Llena',
      nameCa: 'Il·luminació de Lluna Plena',
      descriptionEn: 'Discover what the full moon illuminates and what to celebrate during lunar peak',
      descriptionEs: 'Descubre lo que la luna llena ilumina y qué celebrar durante el pico lunar',
      descriptionCa: 'Descobreix el que la lluna plena il·lumina i què celebrar durant el pic lunar',
      phases: ['full_moon'],
      numberOfCards: 5,
      positions: [
        SpreadPosition(
          order: 1,
          questionEn: 'What is this full moon illuminating for you?',
          questionEs: '¿Qué está iluminando esta luna llena para ti?',
          questionCa: 'Què està il·luminant aquesta lluna plena per a tu?',
        ),
        SpreadPosition(
          order: 2,
          questionEn: 'What is this moon casting a shadow on? A weak spot or something for you to work on?',
          questionEs: '¿Sobre qué está proyectando sombra esta luna? ¿Un punto débil o algo en lo que trabajar?',
          questionCa: 'Sobre què està projectant ombra aquesta lluna? Un punt dèbil o alguna cosa en què treballar?',
        ),
        SpreadPosition(
          order: 3,
          questionEn: 'What to draw into your life at this moment',
          questionEs: 'Qué atraer a tu vida en este momento',
          questionCa: 'Què atreure a la teva vida en aquest moment',
        ),
        SpreadPosition(
          order: 4,
          questionEn: 'What do you need to know for the rest of this cycle leading to the next new moon?',
          questionEs: '¿Qué necesitas saber para el resto de este ciclo hasta la próxima luna nueva?',
          questionCa: 'Què necessites saber per a la resta d\'aquest cicle fins a la propera lluna nova?',
        ),
        SpreadPosition(
          order: 5,
          questionEn: 'Something to celebrate',
          questionEs: 'Algo que celebrar',
          questionCa: 'Alguna cosa a celebrar',
        ),
      ],
      sourceEn: 'Source: Wayfinder Tarot',
      sourceEs: 'Fuente: Wayfinder Tarot',
      sourceCa: 'Font: Wayfinder Tarot',
      sourceUrl: 'https://wayfindertarot.com/tarot-spreads-for-the-new-and-full-moon/',
      iconEmoji: '🌕',
    ),

    // THE EMBROIDERED FOREST - Waxing Moon
    LunarSpread(
      id: 'embroidered_waxing_moon',
      nameEn: 'Waxing Moon Manifestation',
      nameEs: 'Manifestación de Luna Creciente',
      nameCa: 'Manifestació de Lluna Creixent',
      descriptionEn: 'Build momentum and overcome obstacles as the moon waxes toward fullness',
      descriptionEs: 'Construye impulso y supera obstáculos mientras la luna crece hacia la plenitud',
      descriptionCa: 'Construeix impuls i supera obstacles mentre la lluna creix cap a la plenitud',
      phases: ['waxing_crescent', 'first_quarter', 'waxing_gibbous'],
      numberOfCards: 5,
      positions: [
        SpreadPosition(
          order: 1,
          questionEn: 'How can I stay motivated to achieve my goals?',
          questionEs: '¿Cómo puedo mantenerme motivado para lograr mis metas?',
          questionCa: 'Com puc mantenir-me motivat per aconseguir els meus objectius?',
        ),
        SpreadPosition(
          order: 2,
          questionEn: 'What is a personal strength that I often forget to utilize?',
          questionEs: '¿Cuál es una fortaleza personal que a menudo olvido utilizar?',
          questionCa: 'Quina és una fortalesa personal que sovint oblido utilitzar?',
        ),
        SpreadPosition(
          order: 3,
          questionEn: 'What is causing my procrastination or what is holding me back?',
          questionEs: '¿Qué está causando mi procrastinación o qué me está frenando?',
          questionCa: 'Què està causant la meva procrastinació o què m\'està frenant?',
        ),
        SpreadPosition(
          order: 4,
          questionEn: 'Where do I need more guidance or expert help?',
          questionEs: '¿Dónde necesito más orientación o ayuda experta?',
          questionCa: 'On necessito més orientació o ajuda experta?',
        ),
        SpreadPosition(
          order: 5,
          questionEn: 'How can I free up more time or energy so I can commit more consistently to my goals?',
          questionEs: '¿Cómo puedo liberar más tiempo o energía para comprometerme más consistentemente con mis metas?',
          questionCa: 'Com puc alliberar més temps o energia per comprometre\'m més consistentment amb els meus objectius?',
        ),
      ],
      sourceEn: 'Source: The Embroidered Forest',
      sourceEs: 'Fuente: The Embroidered Forest',
      sourceCa: 'Font: The Embroidered Forest',
      sourceUrl: 'https://theembroideredforest.com/blogs/tarot-spreads/waxing-moon',
      iconEmoji: '🌓',
    ),

    // THE EMBROIDERED FOREST - Waning Moon
    LunarSpread(
      id: 'embroidered_waning_moon',
      nameEn: 'Waning Moon Relaxation',
      nameEs: 'Relajación de Luna Menguante',
      nameCa: 'Relaxació de Lluna Minvant',
      descriptionEn: 'Find peace and release stress as the moon wanes toward darkness',
      descriptionEs: 'Encuentra paz y libera estrés mientras la luna mengua hacia la oscuridad',
      descriptionCa: 'Troba pau i allibera estrès mentre la lluna minva cap a la foscor',
      phases: ['waning_gibbous', 'last_quarter', 'waning_crescent'],
      numberOfCards: 5,
      positions: [
        SpreadPosition(
          order: 1,
          questionEn: 'How can I feel more at peace in myself throughout the month?',
          questionEs: '¿Cómo puedo sentirme más en paz conmigo durante el mes?',
          questionCa: 'Com puc sentir-me més en pau amb mi mateix durant el mes?',
        ),
        SpreadPosition(
          order: 2,
          questionEn: 'What do I need to let go of to be able to relax?',
          questionEs: '¿De qué necesito soltar para poder relajarme?',
          questionCa: 'De què necessito deixar anar per poder relaxar-me?',
        ),
        SpreadPosition(
          order: 3,
          questionEn: 'Which part(s) of my life are contributing to my stress the most and what can I do to reduce their impact?',
          questionEs: '¿Qué parte(s) de mi vida contribuyen más a mi estrés y qué puedo hacer para reducir su impacto?',
          questionCa: 'Quina part(s) de la meva vida contribueixen més al meu estrès i què puc fer per reduir el seu impacte?',
        ),
        SpreadPosition(
          order: 4,
          questionEn: 'How can I create a schedule that allows me to work on my goal sustainably and allows me enough time to rest?',
          questionEs: '¿Cómo puedo crear un horario que me permita trabajar en mi meta de forma sostenible y me dé tiempo suficiente para descansar?',
          questionCa: 'Com puc crear un horari que em permeti treballar en el meu objectiu de forma sostenible i em doni temps suficient per descansar?',
        ),
        SpreadPosition(
          order: 5,
          questionEn: 'What am I missing or not seeing that can aid me in relaxing?',
          questionEs: '¿Qué me estoy perdiendo o no veo que pueda ayudarme a relajarme?',
          questionCa: 'Què m\'estic perdent o no veig que pugui ajudar-me a relaxar-me?',
        ),
      ],
      sourceEn: 'Source: The Embroidered Forest',
      sourceEs: 'Fuente: The Embroidered Forest',
      sourceCa: 'Font: The Embroidered Forest',
      sourceUrl: 'https://theembroideredforest.com/blogs/tarot-spreads/waning-moon',
      iconEmoji: '🌗',
    ),

    // THE NUMINOUS - New Moon: New Beginnings
    LunarSpread(
      id: 'numinous_new_moon',
      nameEn: 'New Moon: New Beginnings',
      nameEs: 'Luna Nueva: Nuevos Comienzos',
      nameCa: 'Lluna Nova: Nous Començaments',
      descriptionEn: 'Navigate from where you\'ve been to where you want to be',
      descriptionEs: 'Navega desde donde has estado hasta donde quieres estar',
      descriptionCa: 'Navega des d\'on has estat fins on vols estar',
      phases: ['new_moon'],
      numberOfCards: 3,
      positions: [
        SpreadPosition(
          order: 1,
          questionEn: 'Where you have been',
          questionEs: 'Dónde has estado',
          questionCa: 'On has estat',
        ),
        SpreadPosition(
          order: 2,
          questionEn: 'Where you are',
          questionEs: 'Dónde estás',
          questionCa: 'On estàs',
        ),
        SpreadPosition(
          order: 3,
          questionEn: 'Where you want to be',
          questionEs: 'Dónde quieres estar',
          questionCa: 'On vols estar',
        ),
      ],
      sourceEn: 'Source: The Numinous',
      sourceEs: 'Fuente: The Numinous',
      sourceCa: 'Font: The Numinous',
      sourceUrl: 'https://www.the-numinous.com/2017/02/07/moon-tarot/',
      iconEmoji: '🌑',
    ),

    // THE NUMINOUS - Waxing Crescent: Setting Foundations
    LunarSpread(
      id: 'numinous_waxing_crescent',
      nameEn: 'Waxing Crescent: Setting Foundations',
      nameEs: 'Luna Creciente: Establecer Fundamentos',
      nameCa: 'Lluna Creixent: Establir Fonaments',
      descriptionEn: 'Identify your resources and talents for building your intentions',
      descriptionEs: 'Identifica tus recursos y talentos para construir tus intenciones',
      descriptionCa: 'Identifica els teus recursos i talents per construir les teves intencions',
      phases: ['waxing_crescent'],
      numberOfCards: 4,
      positions: [
        SpreadPosition(
          order: 1,
          questionEn: 'Your source of energy & willpower',
          questionEs: 'Tu fuente de energía y fuerza de voluntad',
          questionCa: 'La teva font d\'energia i força de voluntat',
        ),
        SpreadPosition(
          order: 2,
          questionEn: 'Your talents',
          questionEs: 'Tus talentos',
          questionCa: 'Els teus talents',
        ),
        SpreadPosition(
          order: 3,
          questionEn: 'The environment',
          questionEs: 'El entorno',
          questionCa: 'L\'entorn',
        ),
        SpreadPosition(
          order: 4,
          questionEn: 'Your resources',
          questionEs: 'Tus recursos',
          questionCa: 'Els teus recursos',
        ),
      ],
      sourceEn: 'Source: The Numinous',
      sourceEs: 'Fuente: The Numinous',
      sourceCa: 'Font: The Numinous',
      sourceUrl: 'https://www.the-numinous.com/2017/02/07/moon-tarot/',
      iconEmoji: '🌒',
    ),

    // THE NUMINOUS - First Quarter: Actions & Obstacles
    LunarSpread(
      id: 'numinous_first_quarter',
      nameEn: 'First Quarter: Actions & Obstacles',
      nameEs: 'Cuarto Creciente: Acciones y Obstáculos',
      nameCa: 'Quart Creixent: Accions i Obstacles',
      descriptionEn: 'Overcome obstacles and take action toward your goals',
      descriptionEs: 'Supera obstáculos y toma acción hacia tus metas',
      descriptionCa: 'Supera obstacles i pren acció cap als teus objectius',
      phases: ['first_quarter'],
      numberOfCards: 4,
      positions: [
        SpreadPosition(
          order: 1,
          questionEn: 'Your self-perception',
          questionEs: 'Tu autopercepción',
          questionCa: 'La teva autopercepció',
        ),
        SpreadPosition(
          order: 2,
          questionEn: 'Your obstacle',
          questionEs: 'Tu obstáculo',
          questionCa: 'El teu obstacle',
        ),
        SpreadPosition(
          order: 3,
          questionEn: 'What will help you overcome',
          questionEs: 'Lo que te ayudará a superar',
          questionCa: 'El que t\'ajudarà a superar',
        ),
        SpreadPosition(
          order: 4,
          questionEn: 'What holds you back',
          questionEs: 'Lo que te frena',
          questionCa: 'El que et frena',
        ),
      ],
      sourceEn: 'Source: The Numinous',
      sourceEs: 'Fuente: The Numinous',
      sourceCa: 'Font: The Numinous',
      sourceUrl: 'https://www.the-numinous.com/2017/02/07/moon-tarot/',
      iconEmoji: '🌓',
    ),

    // THE NUMINOUS - Waxing Gibbous: Pivot Point
    LunarSpread(
      id: 'numinous_waxing_gibbous',
      nameEn: 'Waxing Gibbous: Pivot Point',
      nameEs: 'Gibosa Creciente: Punto de Giro',
      nameCa: 'Gibosa Creixent: Punt de Gir',
      descriptionEn: 'Adjust expectations and pivot toward reality',
      descriptionEs: 'Ajusta expectativas y gira hacia la realidad',
      descriptionCa: 'Ajusta expectatives i gira cap a la realitat',
      phases: ['waxing_gibbous'],
      numberOfCards: 4,
      positions: [
        SpreadPosition(
          order: 1,
          questionEn: 'The problem',
          questionEs: 'El problema',
          questionCa: 'El problema',
        ),
        SpreadPosition(
          order: 2,
          questionEn: 'Our expectation',
          questionEs: 'Nuestra expectativa',
          questionCa: 'La nostra expectativa',
        ),
        SpreadPosition(
          order: 3,
          questionEn: 'The reality',
          questionEs: 'La realidad',
          questionCa: 'La realitat',
        ),
        SpreadPosition(
          order: 4,
          questionEn: 'Guidance',
          questionEs: 'Guía',
          questionCa: 'Guia',
        ),
      ],
      sourceEn: 'Source: The Numinous',
      sourceEs: 'Fuente: The Numinous',
      sourceCa: 'Font: The Numinous',
      sourceUrl: 'https://www.the-numinous.com/2017/02/07/moon-tarot/',
      iconEmoji: '🌔',
    ),

    // THE NUMINOUS - Full Moon: Celebration
    LunarSpread(
      id: 'numinous_full_moon',
      nameEn: 'Full Moon: Celebration',
      nameEs: 'Luna Llena: Celebración',
      nameCa: 'Lluna Plena: Celebració',
      descriptionEn: 'Celebrate your gifts and recognize your potential',
      descriptionEs: 'Celebra tus dones y reconoce tu potencial',
      descriptionCa: 'Celebra els teus dons i reconeix el teu potencial',
      phases: ['full_moon'],
      numberOfCards: 3,
      positions: [
        SpreadPosition(
          order: 1,
          questionEn: 'What gives you joy',
          questionEs: 'Qué te da alegría',
          questionCa: 'Què et dóna alegria',
        ),
        SpreadPosition(
          order: 2,
          questionEn: 'Your gifts to world',
          questionEs: 'Tus dones al mundo',
          questionCa: 'Els teus dons al món',
        ),
        SpreadPosition(
          order: 3,
          questionEn: 'Your unrecognized potential',
          questionEs: 'Tu potencial no reconocido',
          questionCa: 'El teu potencial no reconegut',
        ),
      ],
      sourceEn: 'Source: The Numinous',
      sourceEs: 'Fuente: The Numinous',
      sourceCa: 'Font: The Numinous',
      sourceUrl: 'https://www.the-numinous.com/2017/02/07/moon-tarot/',
      iconEmoji: '🌕',
    ),

    // THE NUMINOUS - Waning Gibbous: Turning Inward
    LunarSpread(
      id: 'numinous_waning_gibbous',
      nameEn: 'Waning Gibbous: Turning Inward',
      nameEs: 'Gibosa Menguante: Girar Hacia Adentro',
      nameCa: 'Gibosa Minvant: Girar Cap Endins',
      descriptionEn: 'Confront fears, secrets, lies and regrets',
      descriptionEs: 'Confronta miedos, secretos, mentiras y arrepentimientos',
      descriptionCa: 'Confronta pors, secrets, mentides i penediments',
      phases: ['waning_gibbous'],
      numberOfCards: 4,
      positions: [
        SpreadPosition(
          order: 1,
          questionEn: 'Fears',
          questionEs: 'Miedos',
          questionCa: 'Pors',
        ),
        SpreadPosition(
          order: 2,
          questionEn: 'Secrets',
          questionEs: 'Secretos',
          questionCa: 'Secrets',
        ),
        SpreadPosition(
          order: 3,
          questionEn: 'Lies',
          questionEs: 'Mentiras',
          questionCa: 'Mentides',
        ),
        SpreadPosition(
          order: 4,
          questionEn: 'Regrets',
          questionEs: 'Arrepentimientos',
          questionCa: 'Penediments',
        ),
      ],
      sourceEn: 'Source: The Numinous',
      sourceEs: 'Fuente: The Numinous',
      sourceCa: 'Font: The Numinous',
      sourceUrl: 'https://www.the-numinous.com/2017/02/07/moon-tarot/',
      iconEmoji: '🌖',
    ),

    // THE NUMINOUS - Last Quarter: Letting Go
    LunarSpread(
      id: 'numinous_last_quarter',
      nameEn: 'Last Quarter: Letting Go',
      nameEs: 'Cuarto Menguante: Soltar',
      nameCa: 'Quart Minvant: Deixar Anar',
      descriptionEn: 'Accept, forgive and learn from the cycle',
      descriptionEs: 'Acepta, perdona y aprende del ciclo',
      descriptionCa: 'Accepta, perdona i aprèn del cicle',
      phases: ['last_quarter'],
      numberOfCards: 3,
      positions: [
        SpreadPosition(
          order: 1,
          questionEn: 'What to accept',
          questionEs: 'Qué aceptar',
          questionCa: 'Què acceptar',
        ),
        SpreadPosition(
          order: 2,
          questionEn: 'What to forgive',
          questionEs: 'Qué perdonar',
          questionCa: 'Què perdonar',
        ),
        SpreadPosition(
          order: 3,
          questionEn: 'What to learn',
          questionEs: 'Qué aprender',
          questionCa: 'Què aprendre',
        ),
      ],
      sourceEn: 'Source: The Numinous',
      sourceEs: 'Fuente: The Numinous',
      sourceCa: 'Font: The Numinous',
      sourceUrl: 'https://www.the-numinous.com/2017/02/07/moon-tarot/',
      iconEmoji: '🌗',
    ),
  ];

  static List<LunarSpread> getSpreadsForPhase(String phaseId) {
    return allSpreads.where((s) => s.phases.contains(phaseId)).toList();
  }

  static LunarSpread? getSpreadById(String id) {
    try {
      return allSpreads.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<LunarSpread> getAllSpreads() {
    return allSpreads;
  }
}
