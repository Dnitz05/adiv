/// Authentic lunar and astrological guidance content
/// Based on documented traditions:
/// - Hellenistic Astrology (Chris Brennan, Demetra George)
/// - Western Modern Astrology (Liz Greene, Robert Hand)
/// - Traditional Moon Phase Wisdom (Wicca/Witchcraft tradition)
///
/// Source: AUTHENTICITY.md policy - Zero personal invention

class PhaseGuidanceContent {
  const PhaseGuidanceContent({
    required this.phaseId,
    required this.meaningEn,
    required this.meaningEs,
    required this.meaningCa,
    required this.energyEn,
    required this.energyEs,
    required this.energyCa,
    required this.bestForEn,
    required this.bestForEs,
    required this.bestForCa,
    required this.avoidEn,
    required this.avoidEs,
    required this.avoidCa,
  });

  final String phaseId;

  // Traditional meaning of the phase
  final String meaningEn;
  final String meaningEs;
  final String meaningCa;

  // Energetic quality
  final String energyEn;
  final String energyEs;
  final String energyCa;

  // What this phase is best for
  final List<String> bestForEn;
  final List<String> bestForEs;
  final List<String> bestForCa;

  // What to avoid
  final List<String> avoidEn;
  final List<String> avoidEs;
  final List<String> avoidCa;

  String getMeaning(String locale) {
    switch (locale) {
      case 'es': return meaningEs;
      case 'ca': return meaningCa;
      default: return meaningEn;
    }
  }

  String getEnergy(String locale) {
    switch (locale) {
      case 'es': return energyEs;
      case 'ca': return energyCa;
      default: return energyEn;
    }
  }

  List<String> getBestFor(String locale) {
    switch (locale) {
      case 'es': return bestForEs;
      case 'ca': return bestForCa;
      default: return bestForEn;
    }
  }

  List<String> getAvoid(String locale) {
    switch (locale) {
      case 'es': return avoidEs;
      case 'ca': return avoidCa;
      default: return avoidEn;
    }
  }
}

class ZodiacGuidanceContent {
  const ZodiacGuidanceContent({
    required this.signId,
    required this.element,
    required this.emotionalToneEn,
    required this.emotionalToneEs,
    required this.emotionalToneCa,
    required this.focusAreasEn,
    required this.focusAreasEs,
    required this.focusAreasCa,
  });

  final String signId;
  final String element;

  final String emotionalToneEn;
  final String emotionalToneEs;
  final String emotionalToneCa;

  final List<String> focusAreasEn;
  final List<String> focusAreasEs;
  final List<String> focusAreasCa;

  String getEmotionalTone(String locale) {
    switch (locale) {
      case 'es': return emotionalToneEs;
      case 'ca': return emotionalToneCa;
      default: return emotionalToneEn;
    }
  }

  List<String> getFocusAreas(String locale) {
    switch (locale) {
      case 'es': return focusAreasEs;
      case 'ca': return focusAreasCa;
      default: return focusAreasEn;
    }
  }
}

/// Repository of authentic lunar phase guidance
/// Source: Traditional Wicca, Witchcraft, and Western Astrology
class LunarGuidanceRepository {
  static const Map<String, PhaseGuidanceContent> _phaseGuidance = {
    'new_moon': PhaseGuidanceContent(
      phaseId: 'new_moon',
      meaningEn: 'Time of new beginnings, planting seeds of intention, and starting fresh. In traditional astrology, the New Moon marks the beginning of the lunar cycle.',
      meaningEs: 'Tiempo de nuevos comienzos, plantar semillas de intención y empezar de nuevo. En astrología tradicional, la Luna Nueva marca el inicio del ciclo lunar.',
      meaningCa: 'Temps de nous començaments, plantar llavors d\'intenció i començar de nou. En astrologia tradicional, la Lluna Nova marca l\'inici del cicle lunar.',
      energyEn: 'Receptive, introspective, potential-filled',
      energyEs: 'Receptiva, introspectiva, llena de potencial',
      energyCa: 'Receptiva, introspectiva, plena de potencial',
      bestForEn: [
        'Setting intentions and goals',
        'Beginning new projects or ventures',
        'Meditation and inner reflection',
        'Planning and visioning',
      ],
      bestForEs: [
        'Establecer intenciones y objetivos',
        'Comenzar nuevos proyectos o empresas',
        'Meditación y reflexión interior',
        'Planificación y visualización',
      ],
      bestForCa: [
        'Establir intencions i objectius',
        'Començar nous projectes o empreses',
        'Meditació i reflexió interior',
        'Planificació i visualització',
      ],
      avoidEn: [
        'Rushing into action without planning',
        'Making final decisions without reflection',
      ],
      avoidEs: [
        'Actuar precipitadamente sin planificar',
        'Tomar decisiones finales sin reflexionar',
      ],
      avoidCa: [
        'Actuar precipitadament sense planificar',
        'Prendre decisions finals sense reflexionar',
      ],
    ),
    'waxing_crescent': PhaseGuidanceContent(
      phaseId: 'waxing_crescent',
      meaningEn: 'Phase of emergence and forward movement. Seeds planted during New Moon begin to sprout. Traditional astrology sees this as a building phase.',
      meaningEs: 'Fase de emergencia y movimiento hacia adelante. Las semillas plantadas durante la Luna Nueva comienzan a brotar. La astrología tradicional ve esto como una fase de construcción.',
      meaningCa: 'Fase d\'emergència i moviment endavant. Les llavors plantades durant la Lluna Nova comencen a brotar. L\'astrologia tradicional veu això com una fase de construcció.',
      energyEn: 'Optimistic, proactive, growing',
      energyEs: 'Optimista, proactiva, creciente',
      energyCa: 'Optimista, proactiva, creixent',
      bestForEn: [
        'Taking first steps toward goals',
        'Building momentum',
        'Gathering resources and information',
        'Networking and connecting',
      ],
      bestForEs: [
        'Dar los primeros pasos hacia los objetivos',
        'Crear impulso',
        'Reunir recursos e información',
        'Crear redes y conectar',
      ],
      bestForCa: [
        'Fer els primers passos cap als objectius',
        'Crear impuls',
        'Reunir recursos i informació',
        'Crear xarxes i connectar',
      ],
      avoidEn: [
        'Giving up too early',
        'Expecting immediate results',
      ],
      avoidEs: [
        'Rendirse demasiado pronto',
        'Esperar resultados inmediatos',
      ],
      avoidCa: [
        'Rendir-se massa aviat',
        'Esperar resultats immediats',
      ],
    ),
    'first_quarter': PhaseGuidanceContent(
      phaseId: 'first_quarter',
      meaningEn: 'Phase of decision and action. Traditional astrology marks this as a crisis of action - time to commit fully to your intentions.',
      meaningEs: 'Fase de decisión y acción. La astrología tradicional marca esto como una crisis de acción - momento de comprometerse plenamente con tus intenciones.',
      meaningCa: 'Fase de decisió i acció. L\'astrologia tradicional marca això com una crisi d\'acció - moment de comprometre\'s plenament amb les teves intencions.',
      energyEn: 'Dynamic, challenging, decisive',
      energyEs: 'Dinámica, desafiante, decisiva',
      energyCa: 'Dinàmica, desafiant, decisiva',
      bestForEn: [
        'Making important decisions',
        'Overcoming obstacles',
        'Taking decisive action',
        'Pushing through resistance',
      ],
      bestForEs: [
        'Tomar decisiones importantes',
        'Superar obstáculos',
        'Tomar acción decisiva',
        'Superar la resistencia',
      ],
      bestForCa: [
        'Prendre decisions importants',
        'Superar obstacles',
        'Prendre acció decisiva',
        'Superar la resistència',
      ],
      avoidEn: [
        'Procrastination',
        'Avoiding necessary challenges',
      ],
      avoidEs: [
        'Procrastinación',
        'Evitar desafíos necesarios',
      ],
      avoidCa: [
        'Procrastinació',
        'Evitar desafiaments necessaris',
      ],
    ),
    'waxing_gibbous': PhaseGuidanceContent(
      phaseId: 'waxing_gibbous',
      meaningEn: 'Phase of refinement and adjustment. Traditional astrology emphasizes fine-tuning and perfecting your approach before culmination.',
      meaningEs: 'Fase de refinamiento y ajuste. La astrología tradicional enfatiza el ajuste fino y la perfección de tu enfoque antes de la culminación.',
      meaningCa: 'Fase de refinament i ajust. L\'astrologia tradicional emfatitza l\'ajust fi i la perfecció del teu enfocament abans de la culminació.',
      energyEn: 'Focused, dedicated, polishing',
      energyEs: 'Enfocada, dedicada, puliendo',
      energyCa: 'Enfocada, dedicada, polint',
      bestForEn: [
        'Refining and improving projects',
        'Attention to detail',
        'Preparation and practice',
        'Patience and persistence',
      ],
      bestForEs: [
        'Refinar y mejorar proyectos',
        'Atención al detalle',
        'Preparación y práctica',
        'Paciencia y persistencia',
      ],
      bestForCa: [
        'Refinar i millorar projectes',
        'Atenció al detall',
        'Preparació i pràctica',
        'Paciència i persistència',
      ],
      avoidEn: [
        'Perfectionism that prevents completion',
        'Losing sight of the bigger picture',
      ],
      avoidEs: [
        'Perfeccionismo que impide la finalización',
        'Perder de vista el panorama general',
      ],
      avoidCa: [
        'Perfeccionisme que impedeix la finalització',
        'Perdre de vista el panorama general',
      ],
    ),
    'full_moon': PhaseGuidanceContent(
      phaseId: 'full_moon',
      meaningEn: 'Phase of culmination, illumination, and manifestation. Traditional astrology sees the Full Moon as peak energy, maximum visibility, and harvest time.',
      meaningEs: 'Fase de culminación, iluminación y manifestación. La astrología tradicional ve la Luna Llena como energía máxima, máxima visibilidad y tiempo de cosecha.',
      meaningCa: 'Fase de culminació, il·luminació i manifestació. L\'astrologia tradicional veu la Lluna Plena com energia màxima, màxima visibilitat i temps de collita.',
      energyEn: 'Powerful, emotional, revealing',
      energyEs: 'Poderosa, emocional, reveladora',
      energyCa: 'Poderosa, emocional, reveladora',
      bestForEn: [
        'Celebrating achievements',
        'Releasing what no longer serves',
        'Clarity and insight',
        'Emotional healing and expression',
      ],
      bestForEs: [
        'Celebrar logros',
        'Liberar lo que ya no sirve',
        'Claridad y perspicacia',
        'Sanación y expresión emocional',
      ],
      bestForCa: [
        'Celebrar assoliments',
        'Alliberar el que ja no serveix',
        'Claredat i perspicàcia',
        'Sanació i expressió emocional',
      ],
      avoidEn: [
        'Starting major new projects',
        'Suppressing emotions',
      ],
      avoidEs: [
        'Comenzar proyectos nuevos importantes',
        'Suprimir emociones',
      ],
      avoidCa: [
        'Començar projectes nous importants',
        'Suprimir emocions',
      ],
    ),
    'waning_gibbous': PhaseGuidanceContent(
      phaseId: 'waning_gibbous',
      meaningEn: 'Phase of sharing and gratitude. Traditional astrology emphasizes giving back and sharing wisdom gained from the full moon illumination.',
      meaningEs: 'Fase de compartir y gratitud. La astrología tradicional enfatiza devolver y compartir la sabiduría obtenida de la iluminación de la luna llena.',
      meaningCa: 'Fase de compartir i gratitud. L\'astrologia tradicional emfatitza retornar i compartir la saviesa obtinguda de la il·luminació de la lluna plena.',
      energyEn: 'Generous, reflective, teaching',
      energyEs: 'Generosa, reflexiva, enseñante',
      energyCa: 'Generosa, reflexiva, ensenyant',
      bestForEn: [
        'Sharing knowledge and wisdom',
        'Teaching and mentoring',
        'Gratitude practices',
        'Community involvement',
      ],
      bestForEs: [
        'Compartir conocimiento y sabiduría',
        'Enseñar y mentorar',
        'Prácticas de gratitud',
        'Participación comunitaria',
      ],
      bestForCa: [
        'Compartir coneixement i saviesa',
        'Ensenyar i mentorar',
        'Pràctiques de gratitud',
        'Participació comunitària',
      ],
      avoidEn: [
        'Hoarding knowledge or resources',
        'Isolation',
      ],
      avoidEs: [
        'Acumular conocimiento o recursos',
        'Aislamiento',
      ],
      avoidCa: [
        'Acumular coneixement o recursos',
        'Aïllament',
      ],
    ),
    'last_quarter': PhaseGuidanceContent(
      phaseId: 'last_quarter',
      meaningEn: 'Phase of release and reorientation. Traditional astrology calls this the crisis of consciousness - letting go of what doesn\'t work.',
      meaningEs: 'Fase de liberación y reorientación. La astrología tradicional llama a esto la crisis de conciencia - dejar ir lo que no funciona.',
      meaningCa: 'Fase d\'alliberament i reorientació. L\'astrologia tradicional anomena això la crisi de consciència - deixar anar el que no funciona.',
      energyEn: 'Releasing, clearing, evaluating',
      energyEs: 'Liberadora, limpiadora, evaluadora',
      energyCa: 'Alliberadora, netejadora, avaluadora',
      bestForEn: [
        'Letting go of old patterns',
        'Clearing space (physical and emotional)',
        'Evaluating what worked and what didn\'t',
        'Breaking unhealthy habits',
      ],
      bestForEs: [
        'Dejar ir viejos patrones',
        'Limpiar espacio (físico y emocional)',
        'Evaluar qué funcionó y qué no',
        'Romper hábitos poco saludables',
      ],
      bestForCa: [
        'Deixar anar vells patrons',
        'Netejar espai (físic i emocional)',
        'Avaluar què va funcionar i què no',
        'Trencar hàbits poc saludables',
      ],
      avoidEn: [
        'Clinging to the past',
        'Starting new commitments',
      ],
      avoidEs: [
        'Aferrarse al pasado',
        'Comenzar nuevos compromisos',
      ],
      avoidCa: [
        'Aferrar-se al passat',
        'Començar nous compromisos',
      ],
    ),
    'waning_crescent': PhaseGuidanceContent(
      phaseId: 'waning_crescent',
      meaningEn: 'Phase of rest, surrender, and preparation. Traditional astrology emphasizes the importance of the void before rebirth at the New Moon.',
      meaningEs: 'Fase de descanso, rendición y preparación. La astrología tradicional enfatiza la importancia del vacío antes del renacimiento en la Luna Nueva.',
      meaningCa: 'Fase de descans, rendició i preparació. L\'astrologia tradicional emfatitza la importància del buit abans del renaixement a la Lluna Nova.',
      energyEn: 'Restorative, spiritual, surrendering',
      energyEs: 'Restauradora, espiritual, rendicional',
      energyCa: 'Restauradora, espiritual, rendicional',
      bestForEn: [
        'Rest and recuperation',
        'Spiritual practices and meditation',
        'Tying up loose ends',
        'Inner work and therapy',
      ],
      bestForEs: [
        'Descanso y recuperación',
        'Prácticas espirituales y meditación',
        'Atar cabos sueltos',
        'Trabajo interior y terapia',
      ],
      bestForCa: [
        'Descans i recuperació',
        'Pràctiques espirituals i meditació',
        'Lligar caps solts',
        'Treball interior i teràpia',
      ],
      avoidEn: [
        'Overexertion and burnout',
        'Major new initiatives',
      ],
      avoidEs: [
        'Sobreesfuerzo y agotamiento',
        'Nuevas iniciativas importantes',
      ],
      avoidCa: [
        'Sobresforç i esgotament',
        'Noves iniciatives importants',
      ],
    ),
  };

  /// Repository of zodiac sign guidance based on traditional astrology
  /// Sources: Hellenistic Astrology, Western Modern Astrology
  static const Map<String, ZodiacGuidanceContent> _zodiacGuidance = {
    'aries': ZodiacGuidanceContent(
      signId: 'aries',
      element: 'fire',
      emotionalToneEn: 'Impulsive, courageous, and direct. Moon in Aries brings fiery emotional energy and a desire for independence.',
      emotionalToneEs: 'Impulsivo, valiente y directo. La Luna en Aries trae energía emocional ardiente y un deseo de independencia.',
      emotionalToneCa: 'Impulsiu, valent i directe. La Lluna en Àries porta energia emocional ardent i un desig d\'independència.',
      focusAreasEn: ['New beginnings', 'Taking initiative', 'Physical activity', 'Leadership'],
      focusAreasEs: ['Nuevos comienzos', 'Tomar iniciativa', 'Actividad física', 'Liderazgo'],
      focusAreasCa: ['Nous començaments', 'Prendre iniciativa', 'Activitat física', 'Lideratge'],
    ),
    'taurus': ZodiacGuidanceContent(
      signId: 'taurus',
      element: 'earth',
      emotionalToneEn: 'Grounded, sensual, and stable. Moon in Taurus (exalted) brings emotional security and appreciation for physical comforts.',
      emotionalToneEs: 'Arraigado, sensual y estable. La Luna en Tauro (exaltada) trae seguridad emocional y aprecio por las comodidades físicas.',
      emotionalToneCa: 'Arrelat, sensual i estable. La Lluna en Taure (exaltada) porta seguretat emocional i apreciació per les comoditats físiques.',
      focusAreasEn: ['Financial matters', 'Nature and beauty', 'Building security', 'Sensory pleasures'],
      focusAreasEs: ['Asuntos financieros', 'Naturaleza y belleza', 'Construir seguridad', 'Placeres sensoriales'],
      focusAreasCa: ['Afers financers', 'Naturalesa i bellesa', 'Construir seguretat', 'Plaers sensorials'],
    ),
    'gemini': ZodiacGuidanceContent(
      signId: 'gemini',
      element: 'air',
      emotionalToneEn: 'Curious, communicative, and versatile. Moon in Gemini brings mental stimulation and social connectivity.',
      emotionalToneEs: 'Curioso, comunicativo y versátil. La Luna en Géminis trae estimulación mental y conectividad social.',
      emotionalToneCa: 'Curiosa, comunicativa i versàtil. La Lluna en Bessons porta estimulació mental i connectivitat social.',
      focusAreasEn: ['Communication', 'Learning', 'Social connections', 'Information gathering'],
      focusAreasEs: ['Comunicación', 'Aprendizaje', 'Conexiones sociales', 'Recopilación de información'],
      focusAreasCa: ['Comunicació', 'Aprenentatge', 'Connexions socials', 'Recopilació d\'informació'],
    ),
    'cancer': ZodiacGuidanceContent(
      signId: 'cancer',
      element: 'water',
      emotionalToneEn: 'Nurturing, protective, and deeply feeling. Moon in Cancer (domicile) is at home, bringing heightened emotional sensitivity.',
      emotionalToneEs: 'Nutritivo, protector y profundamente sensible. La Luna en Cáncer (domicilio) está en casa, trayendo mayor sensibilidad emocional.',
      emotionalToneCa: 'Nutritiva, protectora i profundament sensible. La Lluna en Cranc (domicili) està a casa, portant major sensibilitat emocional.',
      focusAreasEn: ['Family and home', 'Emotional healing', 'Self-care', 'Intuition'],
      focusAreasEs: ['Familia y hogar', 'Sanación emocional', 'Autocuidado', 'Intuición'],
      focusAreasCa: ['Família i llar', 'Sanació emocional', 'Autocura', 'Intuïció'],
    ),
    'leo': ZodiacGuidanceContent(
      signId: 'leo',
      element: 'fire',
      emotionalToneEn: 'Warm, creative, and expressive. Moon in Leo brings generous emotional energy and a need for recognition.',
      emotionalToneEs: 'Cálido, creativo y expresivo. La Luna en Leo trae energía emocional generosa y una necesidad de reconocimiento.',
      emotionalToneCa: 'Càlida, creativa i expressiva. La Lluna en Lleó porta energia emocional generosa i una necessitat de reconeixement.',
      focusAreasEn: ['Creative expression', 'Romance', 'Play and joy', 'Personal recognition'],
      focusAreasEs: ['Expresión creativa', 'Romance', 'Juego y alegría', 'Reconocimiento personal'],
      focusAreasCa: ['Expressió creativa', 'Romanç', 'Joc i alegria', 'Reconeixement personal'],
    ),
    'virgo': ZodiacGuidanceContent(
      signId: 'virgo',
      element: 'earth',
      emotionalToneEn: 'Analytical, helpful, and detail-oriented. Moon in Virgo brings emotional satisfaction through service and improvement.',
      emotionalToneEs: 'Analítico, servicial y orientado a los detalles. La Luna en Virgo trae satisfacción emocional a través del servicio y la mejora.',
      emotionalToneCa: 'Analítica, servicial i orientada als detalls. La Lluna en Verge porta satisfacció emocional a través del servei i la millora.',
      focusAreasEn: ['Organization', 'Health and wellness', 'Practical skills', 'Helpful service'],
      focusAreasEs: ['Organización', 'Salud y bienestar', 'Habilidades prácticas', 'Servicio útil'],
      focusAreasCa: ['Organització', 'Salut i benestar', 'Habilitats pràctiques', 'Servei útil'],
    ),
    'libra': ZodiacGuidanceContent(
      signId: 'libra',
      element: 'air',
      emotionalToneEn: 'Harmonious, diplomatic, and relationship-focused. Moon in Libra brings emotional balance through partnership.',
      emotionalToneEs: 'Armonioso, diplomático y enfocado en las relaciones. La Luna en Libra trae equilibrio emocional a través de la asociación.',
      emotionalToneCa: 'Harmoniosa, diplomàtica i enfocada en les relacions. La Lluna en Balança porta equilibri emocional a través de l\'associació.',
      focusAreasEn: ['Relationships', 'Beauty and art', 'Fairness and justice', 'Social harmony'],
      focusAreasEs: ['Relaciones', 'Belleza y arte', 'Equidad y justicia', 'Armonía social'],
      focusAreasCa: ['Relacions', 'Bellesa i art', 'Equitat i justícia', 'Harmonia social'],
    ),
    'scorpio': ZodiacGuidanceContent(
      signId: 'scorpio',
      element: 'water',
      emotionalToneEn: 'Intense, transformative, and probing. Moon in Scorpio (fall) brings deep emotional experiences and a desire for truth.',
      emotionalToneEs: 'Intenso, transformador y penetrante. La Luna en Escorpio (caída) trae experiencias emocionales profundas y un deseo de verdad.',
      emotionalToneCa: 'Intensa, transformadora i penetrant. La Lluna en Escorpí (caiguda) porta experiències emocionals profundes i un desig de veritat.',
      focusAreasEn: ['Transformation', 'Deep healing', 'Intimacy', 'Uncovering truth'],
      focusAreasEs: ['Transformación', 'Sanación profunda', 'Intimidad', 'Descubrir la verdad'],
      focusAreasCa: ['Transformació', 'Sanació profunda', 'Intimitat', 'Descobrir la veritat'],
    ),
    'sagittarius': ZodiacGuidanceContent(
      signId: 'sagittarius',
      element: 'fire',
      emotionalToneEn: 'Optimistic, adventurous, and philosophical. Moon in Sagittarius brings emotional freedom through exploration.',
      emotionalToneEs: 'Optimista, aventurero y filosófico. La Luna en Sagitario trae libertad emocional a través de la exploración.',
      emotionalToneCa: 'Optimista, aventurera i filosòfica. La Lluna en Sagitari porta llibertat emocional a través de l\'exploració.',
      focusAreasEn: ['Adventure and travel', 'Higher learning', 'Philosophy', 'Cultural exploration'],
      focusAreasEs: ['Aventura y viaje', 'Aprendizaje superior', 'Filosofía', 'Exploración cultural'],
      focusAreasCa: ['Aventura i viatge', 'Aprenentatge superior', 'Filosofia', 'Exploració cultural'],
    ),
    'capricorn': ZodiacGuidanceContent(
      signId: 'capricorn',
      element: 'earth',
      emotionalToneEn: 'Disciplined, ambitious, and responsible. Moon in Capricorn (detriment) brings emotional maturity through structure.',
      emotionalToneEs: 'Disciplinado, ambicioso y responsable. La Luna en Capricornio (detrimento) trae madurez emocional a través de la estructura.',
      emotionalToneCa: 'Disciplinada, ambiciosa i responsable. La Lluna en Capricorn (detriment) porta maduresa emocional a través de l\'estructura.',
      focusAreasEn: ['Career and goals', 'Long-term planning', 'Responsibility', 'Achievement'],
      focusAreasEs: ['Carrera y objetivos', 'Planificación a largo plazo', 'Responsabilidad', 'Logro'],
      focusAreasCa: ['Carrera i objectius', 'Planificació a llarg termini', 'Responsabilitat', 'Assoliment'],
    ),
    'aquarius': ZodiacGuidanceContent(
      signId: 'aquarius',
      element: 'air',
      emotionalToneEn: 'Innovative, humanitarian, and independent. Moon in Aquarius brings emotional fulfillment through community and ideals.',
      emotionalToneEs: 'Innovador, humanitario e independiente. La Luna en Acuario trae realización emocional a través de la comunidad y los ideales.',
      emotionalToneCa: 'Innovadora, humanitària i independent. La Lluna en Aquari porta realització emocional a través de la comunitat i els ideals.',
      focusAreasEn: ['Innovation', 'Community', 'Humanitarian causes', 'Friendship'],
      focusAreasEs: ['Innovación', 'Comunidad', 'Causas humanitarias', 'Amistad'],
      focusAreasCa: ['Innovació', 'Comunitat', 'Causes humanitàries', 'Amistat'],
    ),
    'pisces': ZodiacGuidanceContent(
      signId: 'pisces',
      element: 'water',
      emotionalToneEn: 'Compassionate, intuitive, and dreamy. Moon in Pisces brings heightened emotional sensitivity and spiritual connection.',
      emotionalToneEs: 'Compasivo, intuitivo y soñador. La Luna en Piscis trae mayor sensibilidad emocional y conexión espiritual.',
      emotionalToneCa: 'Compassiva, intuïtiva i somniadora. La Lluna en Peixos porta major sensibilitat emocional i connexió espiritual.',
      focusAreasEn: ['Spirituality', 'Creativity', 'Compassion', 'Imagination'],
      focusAreasEs: ['Espiritualidad', 'Creatividad', 'Compasión', 'Imaginación'],
      focusAreasCa: ['Espiritualitat', 'Creativitat', 'Compassió', 'Imaginació'],
    ),
  };

  static PhaseGuidanceContent? getPhaseGuidance(String phaseId) {
    return _phaseGuidance[phaseId];
  }

  static ZodiacGuidanceContent? getZodiacGuidance(String signId) {
    // Normalize the sign ID to lowercase
    final normalizedId = signId.toLowerCase();
    return _zodiacGuidance[normalizedId];
  }

  static List<PhaseGuidanceContent> getAllPhaseGuidance() {
    return _phaseGuidance.values.toList();
  }

  static List<ZodiacGuidanceContent> getAllZodiacGuidance() {
    return _zodiacGuidance.values.toList();
  }
}
