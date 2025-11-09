// Externalized lunar phase translation data
// Extracted from today_tab.dart to reduce inline translations

/// Phase keywords for all 8 lunar phases in 3 locales
const Map<String, Map<String, List<String>>> phaseKeywords = {
  'new_moon': {
    'en': ['New Beginnings', 'Intention Setting', 'Fresh Start'],
    'es': ['Nuevos Comienzos', 'Intenciones', 'Inicio Fresco'],
    'ca': ['Nous Inicis', 'Intencions', 'Començament Fresc'],
  },
  'waxing_crescent': {
    'en': ['Growth', 'Building', 'Momentum'],
    'es': ['Crecimiento', 'Construcción', 'Impulso'],
    'ca': ['Creixement', 'Construcció', 'Impuls'],
  },
  'first_quarter': {
    'en': ['Action', 'Decision', 'Commitment'],
    'es': ['Acción', 'Decisión', 'Compromiso'],
    'ca': ['Acció', 'Decisió', 'Compromís'],
  },
  'waxing_gibbous': {
    'en': ['Refinement', 'Adjustment', 'Perfection'],
    'es': ['Refinamiento', 'Ajuste', 'Perfección'],
    'ca': ['Refinament', 'Ajust', 'Perfecció'],
  },
  'full_moon': {
    'en': ['Illumination', 'Culmination', 'Gratitude'],
    'es': ['Iluminación', 'Culminación', 'Gratitud'],
    'ca': ['Il·luminació', 'Culminació', 'Gratitud'],
  },
  'waning_gibbous': {
    'en': ['Sharing', 'Teaching', 'Reflection'],
    'es': ['Compartir', 'Enseñar', 'Reflexión'],
    'ca': ['Compartir', 'Ensenyar', 'Reflexió'],
  },
  'last_quarter': {
    'en': ['Release', 'Forgiveness', 'Letting Go'],
    'es': ['Liberación', 'Perdón', 'Soltar'],
    'ca': ['Alliberament', 'Perdó', 'Deixar Anar'],
  },
  'waning_crescent': {
    'en': ['Rest', 'Surrender', 'Preparation'],
    'es': ['Descanso', 'Rendición', 'Preparación'],
    'ca': ['Descans', 'Rendició', 'Preparació'],
  },
};

/// Phase descriptions for all 8 lunar phases in 3 locales
const Map<String, Map<String, String>> phaseDescriptions = {
  'new_moon': {
    'en': 'A time of new beginnings and fresh starts. Plant the seeds of your intentions.',
    'es': 'Un tiempo de nuevos comienzos y comienzos frescos. Planta las semillas de tus intenciones.',
    'ca': 'Un temps de nous començaments i inicis frescos. Planta les llavors de les teves intencions.'
  },
  'waxing_crescent': {
    'en': 'Building energy and momentum. Take action on your goals.',
    'es': 'Construyendo energía y momentum. Toma acción en tus objetivos.',
    'ca': 'Construint energia i momentum. Pren acció en els teus objectius.'
  },
  'first_quarter': {
    'en': 'A time of decision and action. Overcome obstacles with determination.',
    'es': 'Un tiempo de decisión y acción. Supera obstáculos con determinación.',
    'ca': 'Un temps de decisió i acció. Supera obstacles amb determinació.'
  },
  'waxing_gibbous': {
    'en': 'Refine and adjust your plans. Perfect your approach.',
    'es': 'Refina y ajusta tus planes. Perfecciona tu enfoque.',
    'ca': 'Refina i ajusta els teus plans. Perfecciona el teu enfocament.'
  },
  'full_moon': {
    'en': 'Peak energy and illumination. Celebrate achievements and harvest results.',
    'es': 'Energía e iluminación máxima. Celebra logros y cosecha resultados.',
    'ca': 'Energia i il·luminació màxima. Celebra assoliments i collita resultats.'
  },
  'waning_gibbous': {
    'en': 'Share wisdom and gratitude. Give back to others.',
    'es': 'Comparte sabiduría y gratitud. Devuelve a otros.',
    'ca': 'Comparteix saviesa i gratitud. Retorna als altres.'
  },
  'last_quarter': {
    'en': 'Release what no longer serves. Forgive and let go.',
    'es': 'Libera lo que ya no sirve. Perdona y deja ir.',
    'ca': 'Allibera el que ja no serveix. Perdona i deixa anar.'
  },
  'waning_crescent': {
    'en': 'Rest, reflect, and prepare. Turn inward for wisdom.',
    'es': 'Descansa, reflexiona y prepárate. Gira hacia adentro por sabiduría.',
    'ca': 'Descansa, reflexiona i prepara\'t. Gira cap a dins per saviesa.'
  },
};

/// Phase activities (favored and avoid) for all 8 lunar phases in 3 locales
const Map<String, Map<String, Map<String, List<String>>>> phaseActivities = {
  'new_moon': {
    'en': {
      'favored': [
        'Setting clear intentions',
        'Starting new projects',
        'Inner reflection and meditation',
        'Vision boarding'
      ],
      'avoid': ['Major confrontations', 'Rushing decisions']
    },
    'es': {
      'favored': [
        'Establecer intenciones claras',
        'Iniciar nuevos proyectos',
        'Reflexión interior y meditación',
        'Crear tableros de visión'
      ],
      'avoid': ['Confrontaciones importantes', 'Apresurar decisiones']
    },
    'ca': {
      'favored': [
        'Establir intencions clares',
        'Iniciar nous projectes',
        'Reflexió interior i meditació',
        'Crear taulers de visió'
      ],
      'avoid': ['Confrontacions importants', 'Prendre decisions precipitades']
    },
  },
  'waxing_crescent': {
    'en': {
      'favored': [
        'Taking first steps toward goals',
        'Building momentum',
        'Learning new skills',
        'Networking'
      ],
      'avoid': ['Giving up too soon', 'Overcommitting']
    },
    'es': {
      'favored': [
        'Dar primeros pasos hacia objetivos',
        'Construir impulso',
        'Aprender nuevas habilidades',
        'Hacer networking'
      ],
      'avoid': ['Rendirse demasiado pronto', 'Sobrecomprometerse']
    },
    'ca': {
      'favored': [
        'Fer els primers passos cap als objectius',
        'Construir impuls',
        'Aprendre noves habilitats',
        'Fer networking'
      ],
      'avoid': ['Rendir-se massa aviat', 'Comprometre\'s en excés']
    },
  },
  'first_quarter': {
    'en': {
      'favored': [
        'Making important decisions',
        'Taking bold action',
        'Overcoming obstacles',
        'Problem-solving'
      ],
      'avoid': ['Procrastination', 'Avoiding challenges']
    },
    'es': {
      'favored': [
        'Tomar decisiones importantes',
        'Actuar con audacia',
        'Superar obstáculos',
        'Resolver problemas'
      ],
      'avoid': ['Procrastinación', 'Evitar desafíos']
    },
    'ca': {
      'favored': [
        'Prendre decisions importants',
        'Actuar amb audàcia',
        'Superar obstacles',
        'Resoldre problemes'
      ],
      'avoid': ['Procrastinació', 'Evitar reptes']
    },
  },
  'waxing_gibbous': {
    'en': {
      'favored': [
        'Refining details',
        'Making adjustments',
        'Perfecting your craft',
        'Quality improvements'
      ],
      'avoid': ['Rushing to completion', 'Ignoring details']
    },
    'es': {
      'favored': [
        'Refinar detalles',
        'Hacer ajustes',
        'Perfeccionar tu oficio',
        'Mejoras de calidad'
      ],
      'avoid': ['Apresurar la finalización', 'Ignorar detalles']
    },
    'ca': {
      'favored': [
        'Refinar detalls',
        'Fer ajustos',
        'Perfeccionar el teu ofici',
        'Millores de qualitat'
      ],
      'avoid': ['Precipitar la finalització', 'Ignorar detalls']
    },
  },
  'full_moon': {
    'en': {
      'favored': [
        'Celebrating achievements',
        'Expressing gratitude',
        'Completing projects',
        'Emotional release'
      ],
      'avoid': ['Starting major new ventures', 'Suppressing emotions']
    },
    'es': {
      'favored': [
        'Celebrar logros',
        'Expresar gratitud',
        'Completar proyectos',
        'Liberar emociones'
      ],
      'avoid': ['Iniciar grandes proyectos nuevos', 'Reprimir emociones']
    },
    'ca': {
      'favored': [
        'Celebrar èxits',
        'Expressar gratitud',
        'Completar projectes',
        'Alliberar emocions'
      ],
      'avoid': ['Iniciar grans projectes nous', 'Reprimir emocions']
    },
  },
  'waning_gibbous': {
    'en': {
      'favored': [
        'Sharing knowledge',
        'Teaching others',
        'Giving back',
        'Reflecting on lessons'
      ],
      'avoid': ['Hoarding resources', 'Ignoring insights']
    },
    'es': {
      'favored': [
        'Compartir conocimiento',
        'Enseñar a otros',
        'Devolver a la comunidad',
        'Reflexionar sobre lecciones'
      ],
      'avoid': ['Acaparar recursos', 'Ignorar conocimientos']
    },
    'ca': {
      'favored': [
        'Compartir coneixement',
        'Ensenyar altres',
        'Retornar a la comunitat',
        'Reflexionar sobre lliçons'
      ],
      'avoid': ['Acaparar recursos', 'Ignorar coneixements']
    },
  },
  'last_quarter': {
    'en': {
      'favored': [
        'Releasing what no longer serves',
        'Forgiveness work',
        'Decluttering',
        'Endings and closures'
      ],
      'avoid': ['Clinging to the past', 'Starting new commitments']
    },
    'es': {
      'favored': [
        'Soltar lo que ya no sirve',
        'Trabajo de perdón',
        'Ordenar y limpiar',
        'Finales y cierres'
      ],
      'avoid': ['Aferrarse al pasado', 'Iniciar nuevos compromisos']
    },
    'ca': {
      'favored': [
        'Deixar anar allò que ja no serveix',
        'Treball de perdó',
        'Ordenar i netejar',
        'Finals i tancaments'
      ],
      'avoid': ['Aferrar-se al passat', 'Iniciar nous compromisos']
    },
  },
  'waning_crescent': {
    'en': {
      'favored': [
        'Rest and recuperation',
        'Deep introspection',
        'Spiritual practices',
        'Preparing for new cycle'
      ],
      'avoid': ['Overexertion', 'Making major plans']
    },
    'es': {
      'favored': [
        'Descanso y recuperación',
        'Introspección profunda',
        'Prácticas espirituales',
        'Prepararse para nuevo ciclo'
      ],
      'avoid': ['Sobresfuerzo', 'Hacer planes importantes']
    },
    'ca': {
      'favored': [
        'Descans i recuperació',
        'Introspecció profunda',
        'Pràctiques espirituals',
        'Preparar-se per nou cicle'
      ],
      'avoid': ['Esforç excessiu', 'Fer plans importants']
    },
  },
};

/// Helper function to get phase keywords for a given phase and locale
List<String> getPhaseKeywords(String phaseId, String locale) {
  return phaseKeywords[phaseId]?[locale] ??
         phaseKeywords[phaseId]?['en'] ??
         [];
}

/// Helper function to get phase description for a given phase and locale
String getPhaseDescription(String phaseId, String locale) {
  return phaseDescriptions[phaseId]?[locale] ??
         phaseDescriptions[phaseId]?['en'] ??
         'The current lunar phase offers unique energies and opportunities.';
}

/// Helper function to get phase activities for a given phase and locale
Map<String, List<String>> getPhaseActivities(String phaseId, String locale) {
  final Map<String, List<String>> defaults = {
    'favored': ['Inner work', 'Meditation'],
    'avoid': <String>[]
  };

  return phaseActivities[phaseId]?[locale] ??
         phaseActivities[phaseId]?['en'] ??
         defaults;
}
