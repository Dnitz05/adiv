/**
 * Authentic lunar and astrological knowledge for AI guidance
 * Based on documented traditions per AUTHENTICITY.md policy
 *
 * Sources:
 * - Hellenistic Astrology (Chris Brennan, Demetra George)
 * - Western Modern Astrology (Liz Greene, Robert Hand)
 * - Traditional Moon Phase Wisdom (Wicca/Witchcraft tradition)
 *
 * ZERO PERSONAL INVENTION
 */

export interface PhaseKnowledge {
  phaseId: string;
  meaning: { en: string; es: string; ca: string };
  energy: { en: string; es: string; ca: string };
  bestFor: { en: string[]; es: string[]; ca: string[] };
  avoid: { en: string[]; es: string[]; ca: string[] };
}

export interface ZodiacKnowledge {
  signId: string;
  element: string;
  emotionalTone: { en: string; es: string; ca: string };
  focusAreas: { en: string[]; es: string[]; ca: string[] };
}

/**
 * Traditional moon phase knowledge
 * Source: Wicca tradition, Western Astrology
 */
export const PHASE_KNOWLEDGE: Record<string, PhaseKnowledge> = {
  new_moon: {
    phaseId: 'new_moon',
    meaning: {
      en: 'Time of new beginnings, planting seeds of intention, and starting fresh. In traditional astrology, the New Moon marks the beginning of the lunar cycle.',
      es: 'Tiempo de nuevos comienzos, plantar semillas de intención y empezar de nuevo. En astrología tradicional, la Luna Nueva marca el inicio del ciclo lunar.',
      ca: 'Temps de nous començaments, plantar llavors d\'intenció i començar de nou. En astrologia tradicional, la Lluna Nova marca l\'inici del cicle lunar.',
    },
    energy: {
      en: 'Receptive, introspective, potential-filled',
      es: 'Receptiva, introspectiva, llena de potencial',
      ca: 'Receptiva, introspectiva, plena de potencial',
    },
    bestFor: {
      en: ['Setting intentions and goals', 'Beginning new projects', 'Meditation and inner reflection', 'Planning and visioning'],
      es: ['Establecer intenciones y objetivos', 'Comenzar nuevos proyectos', 'Meditación y reflexión interior', 'Planificación y visualización'],
      ca: ['Establir intencions i objectius', 'Començar nous projectes', 'Meditació i reflexió interior', 'Planificació i visualització'],
    },
    avoid: {
      en: ['Rushing into action without planning', 'Making final decisions without reflection'],
      es: ['Actuar precipitadamente sin planificar', 'Tomar decisiones finales sin reflexionar'],
      ca: ['Actuar precipitadament sense planificar', 'Prendre decisions finals sense reflexionar'],
    },
  },

  waxing_crescent: {
    phaseId: 'waxing_crescent',
    meaning: {
      en: 'Phase of emergence and forward movement. Seeds planted during New Moon begin to sprout. Traditional astrology sees this as a building phase.',
      es: 'Fase de emergencia y movimiento hacia adelante. Las semillas plantadas durante la Luna Nueva comienzan a brotar. La astrología tradicional ve esto como una fase de construcción.',
      ca: 'Fase d\'emergència i moviment endavant. Les llavors plantades durant la Lluna Nova comencen a brotar. L\'astrologia tradicional veu això com una fase de construcció.',
    },
    energy: {
      en: 'Optimistic, proactive, growing',
      es: 'Optimista, proactiva, creciente',
      ca: 'Optimista, proactiva, creixent',
    },
    bestFor: {
      en: ['Taking first steps toward goals', 'Building momentum', 'Gathering resources', 'Networking and connecting'],
      es: ['Dar los primeros pasos hacia los objetivos', 'Crear impulso', 'Reunir recursos', 'Crear redes y conectar'],
      ca: ['Fer els primers passos cap als objectius', 'Crear impuls', 'Reunir recursos', 'Crear xarxes i connectar'],
    },
    avoid: {
      en: ['Giving up too early', 'Expecting immediate results'],
      es: ['Rendirse demasiado pronto', 'Esperar resultados inmediatos'],
      ca: ['Rendir-se massa aviat', 'Esperar resultats immediats'],
    },
  },

  first_quarter: {
    phaseId: 'first_quarter',
    meaning: {
      en: 'Phase of decision and action. Traditional astrology marks this as a crisis of action - time to commit fully to your intentions.',
      es: 'Fase de decisión y acción. La astrología tradicional marca esto como una crisis de acción - momento de comprometerse plenamente con tus intenciones.',
      ca: 'Fase de decisió i acció. L\'astrologia tradicional marca això com una crisi d\'acció - moment de comprometre\'s plenament amb les teves intencions.',
    },
    energy: {
      en: 'Dynamic, challenging, decisive',
      es: 'Dinámica, desafiante, decisiva',
      ca: 'Dinàmica, desafiant, decisiva',
    },
    bestFor: {
      en: ['Making important decisions', 'Overcoming obstacles', 'Taking decisive action', 'Pushing through resistance'],
      es: ['Tomar decisiones importantes', 'Superar obstáculos', 'Tomar acción decisiva', 'Superar la resistencia'],
      ca: ['Prendre decisions importants', 'Superar obstacles', 'Prendre acció decisiva', 'Superar la resistència'],
    },
    avoid: {
      en: ['Procrastination', 'Avoiding necessary challenges'],
      es: ['Procrastinación', 'Evitar desafíos necesarios'],
      ca: ['Procrastinació', 'Evitar desafiaments necessaris'],
    },
  },

  waxing_gibbous: {
    phaseId: 'waxing_gibbous',
    meaning: {
      en: 'Phase of refinement and adjustment. Traditional astrology emphasizes fine-tuning and perfecting your approach before culmination.',
      es: 'Fase de refinamiento y ajuste. La astrología tradicional enfatiza el ajuste fino y la perfección de tu enfoque antes de la culminación.',
      ca: 'Fase de refinament i ajust. L\'astrologia tradicional emfatitza l\'ajust fi i la perfecció del teu enfocament abans de la culminació.',
    },
    energy: {
      en: 'Focused, dedicated, polishing',
      es: 'Enfocada, dedicada, puliendo',
      ca: 'Enfocada, dedicada, polint',
    },
    bestFor: {
      en: ['Refining and improving projects', 'Attention to detail', 'Preparation and practice', 'Patience and persistence'],
      es: ['Refinar y mejorar proyectos', 'Atención al detalle', 'Preparación y práctica', 'Paciencia y persistencia'],
      ca: ['Refinar i millorar projectes', 'Atenció al detall', 'Preparació i pràctica', 'Paciència i persistència'],
    },
    avoid: {
      en: ['Perfectionism preventing completion', 'Losing sight of bigger picture'],
      es: ['Perfeccionismo que impide finalización', 'Perder de vista el panorama general'],
      ca: ['Perfeccionisme que impedeix finalització', 'Perdre de vista el panorama general'],
    },
  },

  full_moon: {
    phaseId: 'full_moon',
    meaning: {
      en: 'Phase of culmination, illumination, and manifestation. Traditional astrology sees the Full Moon as peak energy, maximum visibility, and harvest time.',
      es: 'Fase de culminación, iluminación y manifestación. La astrología tradicional ve la Luna Llena como energía máxima, máxima visibilidad y tiempo de cosecha.',
      ca: 'Fase de culminació, il·luminació i manifestació. L\'astrologia tradicional veu la Lluna Plena com energia màxima, màxima visibilitat i temps de collita.',
    },
    energy: {
      en: 'Powerful, emotional, revealing',
      es: 'Poderosa, emocional, reveladora',
      ca: 'Poderosa, emocional, reveladora',
    },
    bestFor: {
      en: ['Celebrating achievements', 'Releasing what no longer serves', 'Clarity and insight', 'Emotional healing'],
      es: ['Celebrar logros', 'Liberar lo que ya no sirve', 'Claridad y perspicacia', 'Sanación emocional'],
      ca: ['Celebrar assoliments', 'Alliberar el que ja no serveix', 'Claredat i perspicàcia', 'Sanació emocional'],
    },
    avoid: {
      en: ['Starting major new projects', 'Suppressing emotions'],
      es: ['Comenzar proyectos nuevos importantes', 'Suprimir emociones'],
      ca: ['Començar projectes nous importants', 'Suprimir emocions'],
    },
  },

  waning_gibbous: {
    phaseId: 'waning_gibbous',
    meaning: {
      en: 'Phase of sharing and gratitude. Traditional astrology emphasizes giving back and sharing wisdom gained from full moon illumination.',
      es: 'Fase de compartir y gratitud. La astrología tradicional enfatiza devolver y compartir la sabiduría obtenida de la iluminación de la luna llena.',
      ca: 'Fase de compartir i gratitud. L\'astrologia tradicional emfatitza retornar i compartir la saviesa obtinguda de la il·luminació de la lluna plena.',
    },
    energy: {
      en: 'Generous, reflective, teaching',
      es: 'Generosa, reflexiva, enseñante',
      ca: 'Generosa, reflexiva, ensenyant',
    },
    bestFor: {
      en: ['Sharing knowledge', 'Teaching and mentoring', 'Gratitude practices', 'Community involvement'],
      es: ['Compartir conocimiento', 'Enseñar y mentorar', 'Prácticas de gratitud', 'Participación comunitaria'],
      ca: ['Compartir coneixement', 'Ensenyar i mentorar', 'Pràctiques de gratitud', 'Participació comunitària'],
    },
    avoid: {
      en: ['Hoarding knowledge', 'Isolation'],
      es: ['Acumular conocimiento', 'Aislamiento'],
      ca: ['Acumular coneixement', 'Aïllament'],
    },
  },

  last_quarter: {
    phaseId: 'last_quarter',
    meaning: {
      en: 'Phase of release and reorientation. Traditional astrology calls this the crisis of consciousness - letting go of what doesn\'t work.',
      es: 'Fase de liberación y reorientación. La astrología tradicional llama a esto la crisis de conciencia - dejar ir lo que no funciona.',
      ca: 'Fase d\'alliberament i reorientació. L\'astrologia tradicional anomena això la crisi de consciència - deixar anar el que no funciona.',
    },
    energy: {
      en: 'Releasing, clearing, evaluating',
      es: 'Liberadora, limpiadora, evaluadora',
      ca: 'Alliberadora, netejadora, avaluadora',
    },
    bestFor: {
      en: ['Letting go of old patterns', 'Clearing space', 'Evaluating what worked', 'Breaking unhealthy habits'],
      es: ['Dejar ir viejos patrones', 'Limpiar espacio', 'Evaluar qué funcionó', 'Romper hábitos poco saludables'],
      ca: ['Deixar anar vells patrons', 'Netejar espai', 'Avaluar què va funcionar', 'Trencar hàbits poc saludables'],
    },
    avoid: {
      en: ['Clinging to the past', 'Starting new commitments'],
      es: ['Aferrarse al pasado', 'Comenzar nuevos compromisos'],
      ca: ['Aferrar-se al passat', 'Començar nous compromisos'],
    },
  },

  waning_crescent: {
    phaseId: 'waning_crescent',
    meaning: {
      en: 'Phase of rest, surrender, and preparation. Traditional astrology emphasizes the importance of the void before rebirth at New Moon.',
      es: 'Fase de descanso, rendición y preparación. La astrología tradicional enfatiza la importancia del vacío antes del renacimiento en la Luna Nueva.',
      ca: 'Fase de descans, rendició i preparació. L\'astrologia tradicional emfatitza la importància del buit abans del renaixement a la Lluna Nova.',
    },
    energy: {
      en: 'Restorative, spiritual, surrendering',
      es: 'Restauradora, espiritual, rendicional',
      ca: 'Restauradora, espiritual, rendicional',
    },
    bestFor: {
      en: ['Rest and recuperation', 'Spiritual practices', 'Tying up loose ends', 'Inner work and therapy'],
      es: ['Descanso y recuperación', 'Prácticas espirituales', 'Atar cabos sueltos', 'Trabajo interior y terapia'],
      ca: ['Descans i recuperació', 'Pràctiques espirituals', 'Lligar caps solts', 'Treball interior i teràpia'],
    },
    avoid: {
      en: ['Overexertion and burnout', 'Major new initiatives'],
      es: ['Sobreesfuerzo y agotamiento', 'Nuevas iniciativas importantes'],
      ca: ['Sobresforç i esgotament', 'Noves iniciatives importants'],
    },
  },
};

/**
 * Traditional zodiac sign knowledge
 * Source: Hellenistic Astrology, Western Modern Astrology
 */
export const ZODIAC_KNOWLEDGE: Record<string, ZodiacKnowledge> = {
  aries: {
    signId: 'aries',
    element: 'fire',
    emotionalTone: {
      en: 'Impulsive, courageous, direct. Moon in Aries brings fiery emotional energy and desire for independence.',
      es: 'Impulsivo, valiente, directo. La Luna en Aries trae energía emocional ardiente y deseo de independencia.',
      ca: 'Impulsiu, valent, directe. La Lluna en Àries porta energia emocional ardent i desig d\'independència.',
    },
    focusAreas: {
      en: ['New beginnings', 'Taking initiative', 'Physical activity', 'Leadership'],
      es: ['Nuevos comienzos', 'Tomar iniciativa', 'Actividad física', 'Liderazgo'],
      ca: ['Nous començaments', 'Prendre iniciativa', 'Activitat física', 'Lideratge'],
    },
  },

  taurus: {
    signId: 'taurus',
    element: 'earth',
    emotionalTone: {
      en: 'Grounded, sensual, stable. Moon in Taurus (exalted) brings emotional security and appreciation for physical comforts.',
      es: 'Arraigado, sensual, estable. La Luna en Tauro (exaltada) trae seguridad emocional y aprecio por comodidades físicas.',
      ca: 'Arrelat, sensual, estable. La Lluna en Taure (exaltada) porta seguretat emocional i apreciació per comoditats físiques.',
    },
    focusAreas: {
      en: ['Financial matters', 'Nature and beauty', 'Building security', 'Sensory pleasures'],
      es: ['Asuntos financieros', 'Naturaleza y belleza', 'Construir seguridad', 'Placeres sensoriales'],
      ca: ['Afers financers', 'Naturalesa i bellesa', 'Construir seguretat', 'Plaers sensorials'],
    },
  },

  gemini: {
    signId: 'gemini',
    element: 'air',
    emotionalTone: {
      en: 'Curious, communicative, versatile. Moon in Gemini brings mental stimulation and social connectivity.',
      es: 'Curioso, comunicativo, versátil. La Luna en Géminis trae estimulación mental y conectividad social.',
      ca: 'Curiosa, comunicativa, versàtil. La Lluna en Bessons porta estimulació mental i connectivitat social.',
    },
    focusAreas: {
      en: ['Communication', 'Learning', 'Social connections', 'Information gathering'],
      es: ['Comunicación', 'Aprendizaje', 'Conexiones sociales', 'Recopilación de información'],
      ca: ['Comunicació', 'Aprenentatge', 'Connexions socials', 'Recopilació d\'informació'],
    },
  },

  cancer: {
    signId: 'cancer',
    element: 'water',
    emotionalTone: {
      en: 'Nurturing, protective, deeply feeling. Moon in Cancer (domicile) is at home, bringing heightened emotional sensitivity.',
      es: 'Nutritivo, protector, profundamente sensible. La Luna en Cáncer (domicilio) está en casa, trayendo mayor sensibilidad emocional.',
      ca: 'Nutritiva, protectora, profundament sensible. La Lluna en Cranc (domicili) està a casa, portant major sensibilitat emocional.',
    },
    focusAreas: {
      en: ['Family and home', 'Emotional healing', 'Self-care', 'Intuition'],
      es: ['Familia y hogar', 'Sanación emocional', 'Autocuidado', 'Intuición'],
      ca: ['Família i llar', 'Sanació emocional', 'Autocura', 'Intuïció'],
    },
  },

  leo: {
    signId: 'leo',
    element: 'fire',
    emotionalTone: {
      en: 'Warm, creative, expressive. Moon in Leo brings generous emotional energy and need for recognition.',
      es: 'Cálido, creativo, expresivo. La Luna en Leo trae energía emocional generosa y necesidad de reconocimiento.',
      ca: 'Càlida, creativa, expressiva. La Lluna en Lleó porta energia emocional generosa i necessitat de reconeixement.',
    },
    focusAreas: {
      en: ['Creative expression', 'Romance', 'Play and joy', 'Personal recognition'],
      es: ['Expresión creativa', 'Romance', 'Juego y alegría', 'Reconocimiento personal'],
      ca: ['Expressió creativa', 'Romanç', 'Joc i alegria', 'Reconeixement personal'],
    },
  },

  virgo: {
    signId: 'virgo',
    element: 'earth',
    emotionalTone: {
      en: 'Analytical, helpful, detail-oriented. Moon in Virgo brings emotional satisfaction through service and improvement.',
      es: 'Analítico, servicial, orientado a detalles. La Luna en Virgo trae satisfacción emocional a través del servicio y la mejora.',
      ca: 'Analítica, servicial, orientada als detalls. La Lluna en Verge porta satisfacció emocional a través del servei i la millora.',
    },
    focusAreas: {
      en: ['Organization', 'Health and wellness', 'Practical skills', 'Helpful service'],
      es: ['Organización', 'Salud y bienestar', 'Habilidades prácticas', 'Servicio útil'],
      ca: ['Organització', 'Salut i benestar', 'Habilitats pràctiques', 'Servei útil'],
    },
  },

  libra: {
    signId: 'libra',
    element: 'air',
    emotionalTone: {
      en: 'Harmonious, diplomatic, relationship-focused. Moon in Libra brings emotional balance through partnership.',
      es: 'Armonioso, diplomático, enfocado en relaciones. La Luna en Libra trae equilibrio emocional a través de la asociación.',
      ca: 'Harmoniosa, diplomàtica, enfocada en relacions. La Lluna en Balança porta equilibri emocional a través de l\'associació.',
    },
    focusAreas: {
      en: ['Relationships', 'Beauty and art', 'Fairness and justice', 'Social harmony'],
      es: ['Relaciones', 'Belleza y arte', 'Equidad y justicia', 'Armonía social'],
      ca: ['Relacions', 'Bellesa i art', 'Equitat i justícia', 'Harmonia social'],
    },
  },

  scorpio: {
    signId: 'scorpio',
    element: 'water',
    emotionalTone: {
      en: 'Intense, transformative, probing. Moon in Scorpio (fall) brings deep emotional experiences and desire for truth.',
      es: 'Intenso, transformador, penetrante. La Luna en Escorpio (caída) trae experiencias emocionales profundas y deseo de verdad.',
      ca: 'Intensa, transformadora, penetrant. La Lluna en Escorpí (caiguda) porta experiències emocionals profundes i desig de veritat.',
    },
    focusAreas: {
      en: ['Transformation', 'Deep healing', 'Intimacy', 'Uncovering truth'],
      es: ['Transformación', 'Sanación profunda', 'Intimidad', 'Descubrir verdad'],
      ca: ['Transformació', 'Sanació profunda', 'Intimitat', 'Descobrir veritat'],
    },
  },

  sagittarius: {
    signId: 'sagittarius',
    element: 'fire',
    emotionalTone: {
      en: 'Optimistic, adventurous, philosophical. Moon in Sagittarius brings emotional freedom through exploration.',
      es: 'Optimista, aventurero, filosófico. La Luna en Sagitario trae libertad emocional a través de la exploración.',
      ca: 'Optimista, aventurera, filosòfica. La Lluna en Sagitari porta llibertat emocional a través de l\'exploració.',
    },
    focusAreas: {
      en: ['Adventure and travel', 'Higher learning', 'Philosophy', 'Cultural exploration'],
      es: ['Aventura y viaje', 'Aprendizaje superior', 'Filosofía', 'Exploración cultural'],
      ca: ['Aventura i viatge', 'Aprenentatge superior', 'Filosofia', 'Exploració cultural'],
    },
  },

  capricorn: {
    signId: 'capricorn',
    element: 'earth',
    emotionalTone: {
      en: 'Disciplined, ambitious, responsible. Moon in Capricorn (detriment) brings emotional maturity through structure.',
      es: 'Disciplinado, ambicioso, responsable. La Luna en Capricornio (detrimento) trae madurez emocional a través de la estructura.',
      ca: 'Disciplinada, ambiciosa, responsable. La Lluna en Capricorn (detriment) porta maduresa emocional a través de l\'estructura.',
    },
    focusAreas: {
      en: ['Career and goals', 'Long-term planning', 'Responsibility', 'Achievement'],
      es: ['Carrera y objetivos', 'Planificación a largo plazo', 'Responsabilidad', 'Logro'],
      ca: ['Carrera i objectius', 'Planificació a llarg termini', 'Responsabilitat', 'Assoliment'],
    },
  },

  aquarius: {
    signId: 'aquarius',
    element: 'air',
    emotionalTone: {
      en: 'Innovative, humanitarian, independent. Moon in Aquarius brings emotional fulfillment through community and ideals.',
      es: 'Innovador, humanitario, independiente. La Luna en Acuario trae realización emocional a través de la comunidad y los ideales.',
      ca: 'Innovadora, humanitària, independent. La Lluna en Aquari porta realització emocional a través de la comunitat i els ideals.',
    },
    focusAreas: {
      en: ['Innovation', 'Community', 'Humanitarian causes', 'Friendship'],
      es: ['Innovación', 'Comunidad', 'Causas humanitarias', 'Amistad'],
      ca: ['Innovació', 'Comunitat', 'Causes humanitàries', 'Amistat'],
    },
  },

  pisces: {
    signId: 'pisces',
    element: 'water',
    emotionalTone: {
      en: 'Compassionate, intuitive, dreamy. Moon in Pisces brings heightened emotional sensitivity and spiritual connection.',
      es: 'Compasivo, intuitivo, soñador. La Luna en Piscis trae mayor sensibilidad emocional y conexión espiritual.',
      ca: 'Compassiva, intuïtiva, somniadora. La Lluna en Peixos porta major sensibilitat emocional i connexió espiritual.',
    },
    focusAreas: {
      en: ['Spirituality', 'Creativity', 'Compassion', 'Imagination'],
      es: ['Espiritualidad', 'Creatividad', 'Compasión', 'Imaginación'],
      ca: ['Espiritualitat', 'Creativitat', 'Compassió', 'Imaginació'],
    },
  },
};

/**
 * Get phase knowledge for a given phase ID
 */
export function getPhaseKnowledge(phaseId: string): PhaseKnowledge | null {
  return PHASE_KNOWLEDGE[phaseId] || null;
}

/**
 * Get zodiac knowledge for a given sign ID
 */
export function getZodiacKnowledge(signId: string): ZodiacKnowledge | null {
  const normalizedId = signId.toLowerCase();
  return ZODIAC_KNOWLEDGE[normalizedId] || null;
}
