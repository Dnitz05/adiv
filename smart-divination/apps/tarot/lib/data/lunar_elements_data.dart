import '../models/lunar_element.dart';

/// Repository for Lunar Elements wisdom
/// Based on classical elemental astrology and tarot correspondences
/// Source: lunar_astrology_reference.md and traditional correspondences
class LunarElementsData {
  static const List<LunarElement> elements = [
    // Fire
    LunarElement(
      id: 'fire',
      name: 'Fire',
      icon: '🔥',
      localizedNames: {
        'en': 'Fire',
        'es': 'Fuego',
        'ca': 'Foc',
      },
      description: {
        'en': 'Fire is the element of passion, action and creative force. It represents pure energy, transformation and the spark of life itself. Fire signs are driven by inspiration, courage and the desire to express their authentic selves. Like flame, they illuminate and inspire, bringing warmth and vitality to everything they touch.',
        'es': 'El Fuego es el elemento de la pasión, la acción y la fuerza creativa. Representa la energía pura, la transformación y la chispa de la vida misma. Los signos de fuego son impulsados por la inspiración, el coraje y el deseo de expresar su ser auténtico. Como una llama, iluminan e inspiran, aportando calidez y vitalidad a todo lo que tocan.',
        'ca': 'El Foc és l\'element de la passió, l\'acció i la força creativa. Representa l\'energia pura, la transformació i l\'espurna de la vida mateixa. Els signes de foc són impulsats per la inspiració, el coratge i el desig d\'expressar el seu ser autèntic. Com una flama, il·luminen i inspiren, aportant calor i vitalitat a tot el que toquen.',
      },
      zodiacSigns: {
        'en': ['Aries', 'Leo', 'Sagittarius'],
        'es': ['Aries', 'Leo', 'Sagitario'],
        'ca': ['Àries', 'Lleó', 'Sagitari'],
      },
      modalities: {
        'en': ['Cardinal (Aries)', 'Fixed (Leo)', 'Mutable (Sagittarius)'],
        'es': ['Cardinal (Aries)', 'Fijo (Leo)', 'Mutable (Sagitario)'],
        'ca': ['Cardinal (Àries)', 'Fix (Lleó)', 'Mutable (Sagitari)'],
      },
      qualities: {
        'en': [
          'Hot, Dry, Active',
          'Passionate and enthusiastic',
          'Courageous and bold',
          'Creative and inspirational',
          'Independent and confident',
        ],
        'es': [
          'Caliente, Seco, Activo',
          'Apasionado y entusiasta',
          'Valiente y audaz',
          'Creativo e inspirador',
          'Independiente y confiado',
        ],
        'ca': [
          'Calent, Sec, Actiu',
          'Apassionat i entusiasta',
          'Coratjós i audaç',
          'Creatiu i inspirador',
          'Independent i confiat',
        ],
      },
      moonInfluence: {
        'en': [
          'Emotions are intense and dramatic',
          'Time for bold action and courage',
          'Creative energy is high',
          'Great for starting new projects',
          'Express yourself authentically',
        ],
        'es': [
          'Las emociones son intensas y dramáticas',
          'Tiempo para acción audaz y coraje',
          'La energía creativa está alta',
          'Ideal para comenzar nuevos proyectos',
          'Exprésate auténticamente',
        ],
        'ca': [
          'Les emocions són intenses i dramàtiques',
          'Temps per acció audaç i coratge',
          'L\'energia creativa està alta',
          'Ideal per començar nous projectes',
          'Expressa\'t autènticament',
        ],
      },
      tarotSuit: 'Wands',
      color: '#FF4500',
      energyDescription: {
        'en': 'Dynamic, expansive, and transformative. Fire energy moves upward and outward.',
        'es': 'Dinámico, expansivo y transformador. La energía del fuego se mueve hacia arriba y hacia afuera.',
        'ca': 'Dinàmic, expansiu i transformador. L\'energia del foc es mou cap amunt i cap a fora.',
      },
    ),

    // Earth
    LunarElement(
      id: 'earth',
      name: 'Earth',
      icon: '🌍',
      localizedNames: {
        'en': 'Earth',
        'es': 'Tierra',
        'ca': 'Terra',
      },
      description: {
        'en': 'Earth is the element of manifestation, stability and physical form. It represents the material world, practical wisdom and the body. Earth signs are grounded in reality, focused on building lasting structures and appreciating sensory experience. Like the soil, they nurture growth and provide a stable foundation for all life.',
        'es': 'La Tierra es el elemento de la manifestación, la estabilidad y la forma física. Representa el mundo material, la sabiduría práctica y el cuerpo. Los signos de tierra están arraigados en la realidad, enfocados en construir estructuras duraderas y apreciar la experiencia sensorial. Como el suelo, nutren el crecimiento y proporcionan una base estable para toda la vida.',
        'ca': 'La Terra és l\'element de la manifestació, l\'estabilitat i la forma física. Representa el món material, la saviesa pràctica i el cos. Els signes de terra estan arrelats a la realitat, enfocats a construir estructures duradores i apreciar l\'experiència sensorial. Com el sòl, nodreixen el creixement i proporcionen una base estable per a tota la vida.',
      },
      zodiacSigns: {
        'en': ['Taurus', 'Virgo', 'Capricorn'],
        'es': ['Tauro', 'Virgo', 'Capricornio'],
        'ca': ['Taure', 'Verge', 'Capricorn'],
      },
      modalities: {
        'en': ['Fixed (Taurus)', 'Mutable (Virgo)', 'Cardinal (Capricorn)'],
        'es': ['Fijo (Tauro)', 'Mutable (Virgo)', 'Cardinal (Capricornio)'],
        'ca': ['Fix (Taure)', 'Mutable (Verge)', 'Cardinal (Capricorn)'],
      },
      qualities: {
        'en': [
          'Heavy, Cold, Dry',
          'Practical and reliable',
          'Patient and stable',
          'Sensual and grounded',
          'Focused on manifestation',
        ],
        'es': [
          'Pesado, Frío, Seco',
          'Práctico y confiable',
          'Paciente y estable',
          'Sensual y arraigado',
          'Enfocado en la manifestación',
        ],
        'ca': [
          'Pesant, Fred, Sec',
          'Pràctic i fiable',
          'Pacient i estable',
          'Sensual i arrelat',
          'Enfocat en la manifestació',
        ],
      },
      moonInfluence: {
        'en': [
          'Emotions are grounded and stable',
          'Time to manifest and build',
          'Focus on practical matters',
          'Connect with your body and senses',
          'Work with tangible results',
        ],
        'es': [
          'Las emociones están arraigadas y estables',
          'Tiempo para manifestar y construir',
          'Enfócate en asuntos prácticos',
          'Conecta con tu cuerpo y sentidos',
          'Trabaja con resultados tangibles',
        ],
        'ca': [
          'Les emocions estan arrelades i estables',
          'Temps per manifestar i construir',
          'Centra\'t en assumptes pràctics',
          'Connecta amb el teu cos i sentits',
          'Treballa amb resultats tangibles',
        ],
      },
      tarotSuit: 'Pentacles',
      color: '#228B22',
      energyDescription: {
        'en': 'Stable, grounding, and solidifying. Earth energy moves downward and inward.',
        'es': 'Estable, enraizadora y solidificadora. La energía de la tierra se mueve hacia abajo y hacia adentro.',
        'ca': 'Estable, arreladora i solidificadora. L\'energia de la terra es mou cap avall i cap a dins.',
      },
    ),

    // Air
    LunarElement(
      id: 'air',
      name: 'Air',
      icon: '💨',
      localizedNames: {
        'en': 'Air',
        'es': 'Aire',
        'ca': 'Aire',
      },
      description: {
        'en': 'Air is the element of mind, communication and connection. It represents thought, ideas and the power of the word. Air signs are intellectual, social and curious about everything. Like wind, they move freely, carrying ideas and connecting people across distances. They excel at seeing patterns and understanding systems.',
        'es': 'El Aire es el elemento de la mente, la comunicación y la conexión. Representa el pensamiento, las ideas y el poder de la palabra. Los signos de aire son intelectuales, sociales y curiosos sobre todo. Como el viento, se mueven libremente, llevando ideas y conectando personas a través de las distancias. Sobresalen en ver patrones y entender sistemas.',
        'ca': 'L\'Aire és l\'element de la ment, la comunicació i la connexió. Representa el pensament, les idees i el poder de la paraula. Els signes d\'aire són intel·lectuals, socials i curiosos sobre tot. Com el vent, es mouen lliurement, portant idees i connectant persones a través de les distàncies. Excel·leixen a veure patrons i entendre sistemes.',
      },
      zodiacSigns: {
        'en': ['Gemini', 'Libra', 'Aquarius'],
        'es': ['Géminis', 'Libra', 'Acuario'],
        'ca': ['Bessons', 'Balança', 'Aquari'],
      },
      modalities: {
        'en': ['Mutable (Gemini)', 'Cardinal (Libra)', 'Fixed (Aquarius)'],
        'es': ['Mutable (Géminis)', 'Cardinal (Libra)', 'Fijo (Acuario)'],
        'ca': ['Mutable (Bessons)', 'Cardinal (Balança)', 'Fix (Aquari)'],
      },
      qualities: {
        'en': [
          'Light, Hot, Moist',
          'Intellectual and logical',
          'Communicative and social',
          'Curious and adaptable',
          'Focused on ideas and concepts',
        ],
        'es': [
          'Ligero, Caliente, Húmedo',
          'Intelectual y lógico',
          'Comunicativo y social',
          'Curioso y adaptable',
          'Enfocado en ideas y conceptos',
        ],
        'ca': [
          'Lleuger, Calent, Humit',
          'Intel·lectual i lògic',
          'Comunicatiu i social',
          'Curiosa i adaptable',
          'Enfocat en idees i conceptes',
        ],
      },
      moonInfluence: {
        'en': [
          'Emotions are intellectual and detached',
          'Time to communicate and connect',
          'Think clearly and objectively',
          'Share ideas and learn new things',
          'Socialize and network',
        ],
        'es': [
          'Las emociones son intelectuales y desapegadas',
          'Tiempo para comunicar y conectar',
          'Piensa claramente y objetivamente',
          'Comparte ideas y aprende cosas nuevas',
          'Socializa y haz networking',
        ],
        'ca': [
          'Les emocions són intel·lectuals i desapegades',
          'Temps per comunicar i connectar',
          'Pensa clarament i objectivament',
          'Comparteix idees i aprèn coses noves',
          'Socialitza i fes networking',
        ],
      },
      tarotSuit: 'Swords',
      color: '#87CEEB',
      energyDescription: {
        'en': 'Quick, dispersive, and connective. Air energy moves horizontally and in all directions.',
        'es': 'Rápido, dispersivo y conectivo. La energía del aire se mueve horizontalmente y en todas direcciones.',
        'ca': 'Ràpid, dispersiu i connectiu. L\'energia de l\'aire es mou horitzontalment i en totes direccions.',
      },
    ),

    // Water
    LunarElement(
      id: 'water',
      name: 'Water',
      icon: '💧',
      localizedNames: {
        'en': 'Water',
        'es': 'Agua',
        'ca': 'Aigua',
      },
      description: {
        'en': 'Water is the element of emotion, intuition and the subconscious. It represents feelings, dreams and the realm of the soul. Water signs are sensitive, empathic and deeply connected to the emotional currents of life. Like the ocean, they contain great depth and mystery, flowing and adapting while holding ancient wisdom.',
        'es': 'El Agua es el elemento de la emoción, la intuición y el subconsciente. Representa los sentimientos, los sueños y el reino del alma. Los signos de agua son sensibles, empáticos y profundamente conectados con las corrientes emocionales de la vida. Como el océano, contienen gran profundidad y misterio, fluyendo y adaptándose mientras guardan sabiduría antigua.',
        'ca': 'L\'Aigua és l\'element de l\'emoció, la intuïció i el subconscient. Representa els sentiments, els somnis i el regne de l\'ànima. Els signes d\'aigua són sensibles, empàtics i profundament connectats amb els corrents emocionals de la vida. Com l\'oceà, contenen gran profunditat i misteri, fluint i adaptant-se mentre guarden saviesa antiga.',
      },
      zodiacSigns: {
        'en': ['Cancer', 'Scorpio', 'Pisces'],
        'es': ['Cáncer', 'Escorpio', 'Piscis'],
        'ca': ['Cranc', 'Escorpí', 'Peixos'],
      },
      modalities: {
        'en': ['Cardinal (Cancer)', 'Fixed (Scorpio)', 'Mutable (Pisces)'],
        'es': ['Cardinal (Cáncer)', 'Fijo (Escorpio)', 'Mutable (Piscis)'],
        'ca': ['Cardinal (Cranc)', 'Fix (Escorpí)', 'Mutable (Peixos)'],
      },
      qualities: {
        'en': [
          'Cold, Moist, Flowing',
          'Emotional and intuitive',
          'Sensitive and empathic',
          'Deep and mysterious',
          'Focused on feelings and connection',
        ],
        'es': [
          'Frío, Húmedo, Fluido',
          'Emocional e intuitivo',
          'Sensible y empático',
          'Profundo y misterioso',
          'Enfocado en sentimientos y conexión',
        ],
        'ca': [
          'Fred, Humit, Fluid',
          'Emocional i intuïtiu',
          'Sensible i empàtic',
          'Profund i misteriós',
          'Enfocat en sentiments i connexió',
        ],
      },
      moonInfluence: {
        'en': [
          'Emotions are deep and intuitive',
          'Time to feel and connect emotionally',
          'Trust your intuition',
          'Explore your inner world',
          'Practice compassion and empathy',
        ],
        'es': [
          'Las emociones son profundas e intuitivas',
          'Tiempo para sentir y conectar emocionalmente',
          'Confía en tu intuición',
          'Explora tu mundo interior',
          'Practica compasión y empatía',
        ],
        'ca': [
          'Les emocions són profundes i intuïtives',
          'Temps per sentir i connectar emocionalment',
          'Confia en la teva intuïció',
          'Explora el teu món interior',
          'Practica compassió i empatia',
        ],
      },
      tarotSuit: 'Cups',
      color: '#4169E1',
      energyDescription: {
        'en': 'Flowing, receptive, and dissolving. Water energy moves downward and seeks its level.',
        'es': 'Fluido, receptivo y disolvente. La energía del agua se mueve hacia abajo y busca su nivel.',
        'ca': 'Fluid, receptiu i dissolent. L\'energia de l\'aigua es mou cap avall i cerca el seu nivell.',
      },
    ),
  ];

  /// Get element by ID
  static LunarElement? getElementById(String id) {
    try {
      return elements.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get element by name
  static LunarElement? getElementByName(String name) {
    try {
      return elements.firstWhere(
        (element) => element.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
