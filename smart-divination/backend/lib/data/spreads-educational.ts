/**
 * Educational content for spreads - Knowledge base for AI
 * Based on traditional tarot teachings and verified sources
 */

/**
 * Position interaction describes how positions relate semantically
 */
export interface PositionInteraction {
  description: {
    en: string;
    es: string;
    ca: string;
  };
  positions: string[]; // Semantic codes like ["PAST", "PRESENT"]
  aiGuidance: string; // Guidance for AI interpretation
}

/**
 * AI selection criteria to help AI choose appropriate spread
 */
export interface AISelectionCriteria {
  questionPatterns: string[]; // Keywords that suggest this spread
  emotionalStates: string[]; // User emotional states that fit
  preferWhen: {
    cardCountPreference?: string;
    complexityLevel?: string;
    experienceLevel?: string;
    timeframe?: string;
  };
}

/**
 * Educational content structure for each spread
 */
export interface SpreadEducationalContent {
  purpose: {
    en: string;
    es: string;
    ca: string;
  };
  whenToUse: {
    en: string;
    es: string;
    ca: string;
  };
  whenToAvoid: {
    en: string;
    es: string;
    ca: string;
  };
  interpretationMethod: {
    en: string;
    es: string;
    ca: string;
  };
  traditionalOrigin?: {
    en: string;
    es: string;
    ca: string;
  };
  positionInteractions: PositionInteraction[];
  aiSelectionCriteria: AISelectionCriteria;
}

/**
 * THREE CARD SPREAD
 * The most versatile foundational spread
 */
const THREE_CARD_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "The Three Card Spread is the most versatile foundational spread in tarot, revealing the natural flow of time and causation. It shows how past influences shape present circumstances and future possibilities, creating a clear narrative arc that anyone can understand. Perfect for both beginners and experienced readers seeking clarity without overwhelming complexity.",

    es: "La Tirada de Tres Cartas es la tirada fundacional más versátil del tarot, revelando el flujo natural del tiempo y la causación. Muestra cómo las influencias pasadas moldean las circunstancias presentes y las posibilidades futuras, creando un arco narrativo claro que cualquiera puede entender. Perfecta tanto para principiantes como para lectores experimentados que buscan claridad sin complejidad abrumadora.",

    ca: "La Tirada de Tres Cartes és la tirada fundacional més versàtil del tarot, revelant el flux natural del temps i la causació. Mostra com les influències passades modelen les circumstàncies presents i les possibilitats futures, creant un arc narratiu clar que qualsevol pot entendre. Perfecta tant per a principiants com per a lectors experimentats que busquen claredat sense complexitat aclaparadora.",
  },

  whenToUse: {
    en: "Choose the Three Card Spread when you need a clear, focused answer about a specific situation or decision. Ideal for daily guidance, understanding the progression of events, or when you feel confused about how you arrived at your current circumstances. Perfect for questions like 'How did I get here and where am I heading?' Use it when you want insight without feeling overwhelmed by too many cards. This spread works beautifully for first-time readings, quick check-ins, or when you need to see the thread connecting your past actions to future outcomes.",

    es: "Escoge la Tirada de Tres Cartas cuando necesitas una respuesta clara y enfocada sobre una situación o decisión específica. Ideal para orientación diaria, entender la progresión de eventos, o cuando te sientes confundido sobre cómo llegaste a tus circunstancias actuales. Perfecta para preguntas como '¿Cómo llegué aquí y hacia dónde me dirijo?' Úsala cuando quieras perspectiva sin sentirte abrumado por demasiadas cartas. Esta tirada funciona maravillosamente para primeras lecturas, chequeos rápidos, o cuando necesitas ver el hilo que conecta tus acciones pasadas con resultados futuros.",

    ca: "Tria la Tirada de Tres Cartes quan necessitis una resposta clara i enfocada sobre una situació o decisió específica. Ideal per a orientació diària, entendre la progressió d'esdeveniments, o quan et sents confós sobre com vas arribar a les teves circumstàncies actuals. Perfecta per a preguntes com 'Com vaig arribar aquí i cap on em dirigeixo?' Usa-la quan vulguis perspectiva sense sentir-te aclaparat per masses cartes. Aquesta tirada funciona meravellosament per a primeres lectures, revisions ràpides, o quan necessites veure el fil que connecta les teves accions passades amb resultats futurs.",
  },

  whenToAvoid: {
    en: "Avoid the Three Card Spread for extremely complex situations involving multiple people, long-term planning beyond 3-6 months, or questions requiring deep psychological analysis. Skip it if you're seeking comprehensive life guidance or need to examine multiple aspects of a situation simultaneously (career + love + health). Not ideal for yes/no questions—use Single Card instead. If your situation feels tangled with many interconnected factors, consider Celtic Cross or Horseshoe for more nuanced insight.",

    es: "Evita la Tirada de Tres Cartas para situaciones extremadamente complejas que involucran múltiples personas, planificación a largo plazo más allá de 3-6 meses, o preguntas que requieren análisis psicológico profundo. Omítela si buscas orientación vital integral o necesitas examinar múltiples aspectos de una situación simultáneamente (carrera + amor + salud). No es ideal para preguntas de sí/no—usa Una Carta en su lugar. Si tu situación se siente enredada con muchos factores interconectados, considera la Cruz Celta o la Herradura para una perspectiva más matizada.",

    ca: "Evita la Tirada de Tres Cartes per a situacions extremadament complexes que involucren múltiples persones, planificació a llarg termini més enllà de 3-6 mesos, o preguntes que requereixen anàlisi psicològica profunda. Omet-la si busques orientació vital integral o necessites examinar múltiples aspectes d'una situació simultàniament (carrera + amor + salut). No és ideal per a preguntes de sí/no—usa Una Carta en el seu lloc. Si la teva situació es sent embolicada amb molts factors interconnectats, considera la Creu Celta o la Ferradura per a una perspectiva més matisada.",
  },

  interpretationMethod: {
    en: "Begin by reading each card individually in sequence, then synthesize the narrative. Position 1 (PAST) reveals the root causes, foundational influences, or recent events that led to the current situation—look for patterns of behavior, past decisions, or karmic influences. Position 2 (PRESENT) shows the current energy, what's actively manifesting now, and the querent's current state of consciousness. Position 3 (FUTURE) indicates the natural outcome if the present path continues. The magic happens in the CONNECTIONS: Does the Past card explain the Present? Does the Present align with or contradict the Future? Look for elemental flow (Fire→Water = steam/transformation), numerological progression (3→5→8 = growth), and Major Arcana presence (fated vs chosen). If all three are Major Arcana, the situation is destined and beyond the querent's control. If all Minor, it's practical and within their power to change. Court Cards often represent actual people or aspects of self appearing in that timeframe.",

    es: "Comienza leyendo cada carta individualmente en secuencia, luego sintetiza la narrativa. Posición 1 (PASADO) revela las causas raíz, influencias fundacionales, o eventos recientes que llevaron a la situación actual—busca patrones de comportamiento, decisiones pasadas, o influencias kármicas. Posición 2 (PRESENTE) muestra la energía actual, lo que está manifestándose activamente ahora, y el estado de consciencia actual del consultante. Posición 3 (FUTURO) indica el resultado natural si el camino presente continúa. La magia ocurre en las CONEXIONES: ¿La carta del Pasado explica el Presente? ¿El Presente se alinea o contradice el Futuro? Busca flujo elemental (Fuego→Agua = vapor/transformación), progresión numerológica (3→5→8 = crecimiento), y presencia de Arcanos Mayores (destinado vs elegido). Si las tres son Arcanos Mayores, la situación es predestinada y fuera del control del consultante. Si todas son Menores, es práctica y está en su poder cambiarla. Las Cartas de la Corte a menudo representan personas reales o aspectos del yo apareciendo en ese marco temporal.",

    ca: "Comença llegint cada carta individualment en seqüència, després sintetitza la narrativa. Posició 1 (PASSAT) revela les causes arrel, influències fundacionals, o esdeveniments recents que van portar a la situació actual—busca patrons de comportament, decisions passades, o influències kàrmiques. Posició 2 (PRESENT) mostra l'energia actual, el que s'està manifestant activament ara, i l'estat de consciència actual del consultant. Posició 3 (FUTUR) indica el resultat natural si el camí present continua. La màgia passa a les CONNEXIONS: La carta del Passat explica el Present? El Present s'alinea o contradiu el Futur? Busca flux elemental (Foc→Aigua = vapor/transformació), progressió numerològica (3→5→8 = creixement), i presència d'Arcans Majors (destinat vs triat). Si les tres són Arcans Majors, la situació és predestinada i fora del control del consultant. Si totes són Menors, és pràctica i està en el seu poder canviar-la. Les Cartes de la Cort sovint representen persones reals o aspectes del jo apareixent en aquest marc temporal.",
  },

  traditionalOrigin: {
    en: "The Three Card Spread is one of the oldest and most universal tarot layouts, appearing in various forms across different tarot traditions since the 18th century. Its simplicity and effectiveness have made it a staple in both Rider-Waite-Smith and Marseille traditions. The past-present-future interpretation is deeply rooted in the Western esoteric tradition of understanding time as a linear progression with karmic connections.",

    es: "La Tirada de Tres Cartas es uno de los diseños de tarot más antiguos y universales, apareciendo en diversas formas a través de diferentes tradiciones del tarot desde el siglo XVIII. Su simplicidad y efectividad la han convertido en un pilar tanto en las tradiciones Rider-Waite-Smith como Marsella. La interpretación pasado-presente-futuro está profundamente arraigada en la tradición esotérica occidental de entender el tiempo como una progresión lineal con conexiones kármicas.",

    ca: "La Tirada de Tres Cartes és un dels dissenys de tarot més antics i universals, apareixent en diverses formes a través de diferents tradicions del tarot des del segle XVIII. La seva simplicitat i efectivitat l'han convertit en un pilar tant a les tradicions Rider-Waite-Smith com Marsella. La interpretació passat-present-futur està profundament arrelada en la tradició esotèrica occidental d'entendre el temps com una progressió lineal amb connexions kàrmiques.",
  },

  positionInteractions: [
    {
      description: {
        en: "PAST → PRESENT connection reveals causation and karmic patterns",
        es: "Conexión PASADO → PRESENTE revela causación y patrones kármicos",
        ca: "Connexió PASSAT → PRESENT revela causació i patrons kàrmics",
      },
      positions: ["PAST", "PRESENT"],
      aiGuidance: "Explain how the PAST card's energy naturally led to the PRESENT situation. If they seem contradictory, explore what shifted or what lesson wasn't learned. Look for suit progression or reversal patterns.",
    },
    {
      description: {
        en: "PRESENT → FUTURE trajectory shows natural progression if current path continues",
        es: "Trayectoria PRESENTE → FUTURO muestra progresión natural si el camino actual continúa",
        ca: "Trajectòria PRESENT → FUTUR mostra progressió natural si el camí actual continua",
      },
      positions: ["PRESENT", "FUTURE"],
      aiGuidance: "If PRESENT and FUTURE align harmoniously (same suit, ascending numbers), affirm the current path. If they conflict (opposing suits, Major to Minor), point out what needs to change NOW to alter the outcome.",
    },
    {
      description: {
        en: "Full arc PAST → PRESENT → FUTURE reveals the complete story and timeline",
        es: "Arco completo PASADO → PRESENTE → FUTURO revela la historia completa y línea temporal",
        ca: "Arc complet PASSAT → PRESENT → FUTUR revela la història completa i línia temporal",
      },
      positions: ["PAST", "PRESENT", "FUTURE"],
      aiGuidance: "Create a cohesive narrative showing evolution. Look for repeating numbers (e.g., all 3s = communication theme), suit progression (Cups→Swords = emotion→thought), or reversal pattern (e.g., all reversed = internal work needed). Mention if all are Major Arcana (fated) vs all Minor (choice).",
    },
  ],

  aiSelectionCriteria: {
    questionPatterns: [
      "how did i get here",
      "where am i heading",
      "what's happening",
      "daily guidance",
      "understand my situation",
      "quick reading",
      "past present future",
      "what led to this",
      "where is this going",
      "timeline",
      "progression",
      "evolution",
    ],
    emotionalStates: [
      "seeking clarity",
      "feeling stuck",
      "need direction",
      "want to understand timeline",
      "confused about progression",
      "need quick insight",
    ],
    preferWhen: {
      cardCountPreference: "3-5",
      complexityLevel: "simple",
      experienceLevel: "any",
      timeframe: "present to near future (weeks to months)",
    },
  },
};

/**
 * SINGLE CARD SPREAD
 * The purest, most direct form of tarot divination
 */
const SINGLE_CARD_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "The Single Card is the purest and most direct form of tarot divination, distilling the wisdom of 78 cards into one powerful message. Despite its apparent simplicity, it demands the deepest skill from the reader—to extract the full depth, nuance, and multi-layered meaning from a single archetypal image. Perfect for daily guidance, immediate clarity, or when you need the universe to speak directly without complexity.",

    es: "La Una Carta es la forma más pura y directa de adivinación del tarot, destilando la sabiduría de 78 cartas en un mensaje poderoso. A pesar de su aparente simplicidad, demanda la habilidad más profunda del lector—extraer toda la profundidad, matices y significado multicapa de una única imagen arquetípica. Perfecta para orientación diaria, claridad inmediata, o cuando necesitas que el universo hable directamente sin complejidad.",

    ca: "La Una Carta és la forma més pura i directa d'endevinació del tarot, destil·lant la saviesa de 78 cartes en un missatge poderós. Malgrat la seva aparent simplicitat, exigeix l'habilitat més profunda del lector—extreure tota la profunditat, matisos i significat multicapa d'una única imatge arquetípica. Perfecta per a orientació diària, claredat immediata, o quan necessites que l'univers parli directament sense complexitat.",
  },

  whenToUse: {
    en: "Draw a Single Card when you need immediate, focused guidance without the noise of multiple perspectives. Ideal for your daily spiritual practice, morning intention-setting, or as a 'card of the day' to meditate on. Use it when your question is clear and direct, when you're seeking a simple yes/no indicator (though never reduce tarot to mere fortune-telling), or when you want to check in with your energy quickly. The Single Card excels at cutting through mental chatter to reveal the core truth. It's perfect for beginners building relationship with the deck, yet masters still use it for its crystalline clarity.",

    es: "Saca una Una Carta cuando necesites orientación inmediata y enfocada sin el ruido de múltiples perspectivas. Ideal para tu práctica espiritual diaria, establecer intención por la mañana, o como 'carta del día' para meditar. Úsala cuando tu pregunta sea clara y directa, cuando busques un indicador simple de sí/no (aunque nunca reduzcas el tarot a mera adivinación), o cuando quieras consultar tu energía rápidamente. La Una Carta sobresale cortando el parloteo mental para revelar la verdad esencial. Es perfecta para principiantes construyendo relación con el mazo, pero los maestros aún la usan por su claridad cristalina.",

    ca: "Extreu una Una Carta quan necessitis orientació immediata i enfocada sense el soroll de múltiples perspectives. Ideal per a la teva pràctica espiritual diària, establir intenció al matí, o com a 'carta del dia' per meditar. Usa-la quan la teva pregunta sigui clara i directa, quan busquis un indicador simple de sí/no (encara que mai redueixis el tarot a mera endevinació), o quan vulguis consultar la teva energia ràpidament. La Una Carta excel·leix tallant la xerrameca mental per revelar la veritat essencial. És perfecta per a principiants construint relació amb el mazo, però els mestres encara la fan servir per la seva claredat cristal·lina.",
  },

  whenToAvoid: {
    en: "Avoid the Single Card when your situation involves multiple interconnected factors that need to be examined separately—career, love, family, finances all tangled together require more positions. Skip it if you're looking for a detailed timeline or step-by-step guidance through a complex process. Not ideal when you need to compare options (use Two Card instead) or understand cause-and-effect chains (use Three Card). Also avoid if you're emotionally fragile and might project too much onto one card—sometimes we need the balance of multiple perspectives to avoid catastrophizing a difficult card.",

    es: "Evita la Una Carta cuando tu situación involucre múltiples factores interconectados que necesitan examinarse por separado—carrera, amor, familia, finanzas todo enredado requiere más posiciones. Omítela si buscas una línea temporal detallada o orientación paso a paso por un proceso complejo. No es ideal cuando necesitas comparar opciones (usa Dos Cartas en su lugar) o entender cadenas de causa-efecto (usa Tres Cartas). También evítala si estás emocionalmente frágil y podrías proyectar demasiado en una carta—a veces necesitamos el balance de múltiples perspectivas para evitar catastrofizar una carta difícil.",

    ca: "Evita la Una Carta quan la teva situació involucri múltiples factors interconnectats que necessiten examinar-se per separat—carrera, amor, família, finances tot embolicat requereix més posicions. Omet-la si busques una línia temporal detallada o orientació pas a pas per un procés complex. No és ideal quan necessites comparar opcions (usa Dues Cartes en el seu lloc) o entendre cadenes de causa-efecte (usa Tres Cartes). També evita-la si estàs emocionalment fràgil i podries projectar massa en una carta—a vegades necessitem l'equilibri de múltiples perspectives per evitar catastrofitzar una carta difícil.",
  },

  interpretationMethod: {
    en: "With a Single Card, go deeper than you ever would in a multi-card spread. Spend time with the imagery—what colors dominate? What symbols call to you? Notice the figure's posture, gaze direction, and emotional expression. Consider the card's numerology (if numbered), elemental correspondence, and astrological associations. Ask: What is this card's core essence? How does it mirror my current energy? What is it asking me to embody or release? Read the card through multiple lenses: literal (what's shown), symbolic (what it represents), emotional (what it evokes), and spiritual (what wisdom it offers). If it's a Major Arcana, recognize you're dealing with a significant life lesson or archetypal force. If it's a Minor Arcana, look at the suit and number—Wands speak to action, Cups to emotion, Swords to thought, Pentacles to material reality. Court Cards often represent people or aspects of yourself. Don't rush. A Single Card reading can take as long as a ten-card spread if you truly listen to what it's revealing across all its dimensions.",

    es: "Con una Una Carta, profundiza más de lo que harías en una tirada de múltiples cartas. Pasa tiempo con la imagen—¿qué colores dominan? ¿Qué símbolos te llaman? Observa la postura de la figura, dirección de la mirada, y expresión emocional. Considera la numerología de la carta (si está numerada), correspondencia elemental, y asociaciones astrológicas. Pregunta: ¿Cuál es la esencia central de esta carta? ¿Cómo refleja mi energía actual? ¿Qué me pide encarnar o soltar? Lee la carta a través de múltiples lentes: literal (lo que muestra), simbólica (lo que representa), emocional (lo que evoca), y espiritual (qué sabiduría ofrece). Si es un Arcano Mayor, reconoce que estás tratando con una lección de vida significativa o fuerza arquetípica. Si es un Arcano Menor, mira el palo y número—Bastos hablan de acción, Copas de emoción, Espadas de pensamiento, Oros de realidad material. Las Cartas de la Corte a menudo representan personas o aspectos de ti mismo. No te apresures. Una lectura de Una Carta puede tomar tanto como una tirada de diez cartas si realmente escuchas lo que revela en todas sus dimensiones.",

    ca: "Amb una Una Carta, aprofundeix més del que faries en una tirada de múltiples cartes. Passa temps amb la imatge—quins colors dominen? Quins símbols et criden? Observa la postura de la figura, direcció de la mirada, i expressió emocional. Considera la numerologia de la carta (si està numerada), correspondència elemental, i associacions astrològiques. Pregunta: Quina és l'essència central d'aquesta carta? Com reflecteix la meva energia actual? Què em demana encarnar o deixar anar? Llegeix la carta a través de múltiples lents: literal (el que mostra), simbòlica (el que representa), emocional (el que evoca), i espiritual (quina saviesa ofereix). Si és un Arcà Major, reconeix que estàs tractant amb una lliçó de vida significativa o força arquetípica. Si és un Arcà Menor, mira el pal i número—Bastons parlen d'acció, Copes d'emoció, Espases de pensament, Ors de realitat material. Les Cartes de la Cort sovint representen persones o aspectes de tu mateix. No t'afanyis. Una lectura d'Una Carta pot prendre tant com una tirada de deu cartes si realment escoltes el que revela en totes les seves dimensions.",
  },

  traditionalOrigin: {
    en: "The Single Card draw is as old as cartomancy itself, dating back to the earliest uses of playing cards for divination in 15th-century Europe. Before elaborate spreads were codified, fortune-tellers would draw a single card to answer direct questions. This practice continued through the development of tarot-specific decks in the 18th century and remains the most common form of tarot consultation worldwide. The 'card of the day' practice, popularized in the 20th century by teachers like Eden Gray and Mary K. Greer, transformed the Single Card from mere fortune-telling into a daily spiritual practice.",

    es: "El sorteo de Una Carta es tan antiguo como la cartomancia misma, datando de los primeros usos de naipes para adivinación en la Europa del siglo XV. Antes de que se codificaran tiradas elaboradas, los adivinos sacaban una sola carta para responder preguntas directas. Esta práctica continuó a través del desarrollo de mazos específicos de tarot en el siglo XVIII y sigue siendo la forma más común de consulta de tarot en todo el mundo. La práctica de la 'carta del día', popularizada en el siglo XX por maestras como Eden Gray y Mary K. Greer, transformó la Una Carta de mera adivinación en una práctica espiritual diaria.",

    ca: "El sorteig d'Una Carta és tan antic com la cartomància mateixa, datant dels primers usos de naips per a endevinació a l'Europa del segle XV. Abans que es codifiquessin tirades elaborades, els endevins treien una sola carta per respondre preguntes directes. Aquesta pràctica va continuar a través del desenvolupament de mazos específics de tarot al segle XVIII i segueix sent la forma més comuna de consulta de tarot a tot el món. La pràctica de la 'carta del dia', popularitzada al segle XX per mestres com Eden Gray i Mary K. Greer, va transformar la Una Carta de mera endevinació en una pràctica espiritual diària.",
  },

  positionInteractions: [
    {
      description: {
        en: "The Single Card as Mirror - One card reflects all aspects of your situation",
        es: "La Una Carta como Espejo - Una carta refleja todos los aspectos de tu situación",
        ca: "La Una Carta com a Mirall - Una carta reflecteix tots els aspectes de la teva situació",
      },
      positions: ["ANSWER"],
      aiGuidance: "With only one card, the AI must extract maximum depth. Read the card on multiple levels: literal imagery, symbolic meaning, emotional resonance, spiritual lesson, practical action. Consider suit/number/court/Major Arcana significance. Look for how the card mirrors the querent's current energy and what transformation it's inviting.",
    },
  ],

  aiSelectionCriteria: {
    questionPatterns: [
      "daily card",
      "card of the day",
      "quick guidance",
      "what do i need to know",
      "simple question",
      "yes or no",
      "should i",
      "direct answer",
      "immediate",
      "focus for today",
      "energy check",
      "oracle",
    ],
    emotionalStates: [
      "seeking clarity",
      "need simplicity",
      "overwhelmed by options",
      "want direct guidance",
      "daily practice",
      "beginner",
    ],
    preferWhen: {
      cardCountPreference: "1",
      complexityLevel: "simple",
      experienceLevel: "any",
      timeframe: "immediate, today, now",
    },
  },
};

/**
 * TWO CARD SPREAD
 * The dialectic spread for comparing, contrasting, and integrating dualities
 */
const TWO_CARD_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "The Two Card Spread is the essential dialectic tool in tarot, designed to explore dualities, compare options, and reveal the dynamic tension between opposing or complementary forces. It's the simplest structure for examining 'either/or' questions, understanding relationships between two people or energies, or exploring the dialogue between two aspects of a situation. This spread's power lies in its focus on relationship and interaction—not just two separate answers, but the conversation between them.",

    es: "La Tirada de Dos Cartas es la herramienta dialéctica esencial en el tarot, diseñada para explorar dualidades, comparar opciones, y revelar la tensión dinámica entre fuerzas opuestas o complementarias. Es la estructura más simple para examinar preguntas de 'esto o aquello', entender relaciones entre dos personas o energías, o explorar el diálogo entre dos aspectos de una situación. El poder de esta tirada reside en su enfoque en la relación e interacción—no solo dos respuestas separadas, sino la conversación entre ellas.",

    ca: "La Tirada de Dues Cartes és l'eina dialèctica essencial en el tarot, dissenyada per explorar dualitats, comparar opcions, i revelar la tensió dinàmica entre forces oposades o complementàries. És l'estructura més simple per examinar preguntes de 'això o allò', entendre relacions entre dues persones o energies, o explorar el diàleg entre dos aspectes d'una situació. El poder d'aquesta tirada resideix en el seu enfocament en la relació i interacció—no només dues respostes separades, sinó la conversa entre elles.",
  },

  whenToUse: {
    en: "Choose the Two Card Spread when facing a binary decision—Job A or Job B? Stay or leave? Speak or stay silent? It's perfect for comparing two distinct options where you need to see the energy, outcome, or nature of each path. Use it to explore relationship dynamics (you vs. them, how you see each other, your energy + their energy). Excellent for before/after questions (past vs. future, old pattern vs. new pattern), problem/solution pairings, or conscious/shadow work. The Two Card Spread also works beautifully for daily practice when you want slightly more nuance than a Single Card but don't need the full narrative of Three Cards.",

    es: "Escoge la Tirada de Dos Cartas cuando enfrentes una decisión binaria—¿Trabajo A o Trabajo B? ¿Quedarse o irse? ¿Hablar o permanecer en silencio? Es perfecta para comparar dos opciones distintas donde necesitas ver la energía, resultado, o naturaleza de cada camino. Úsala para explorar dinámicas de relación (tú vs. ellos, cómo os veis mutuamente, tu energía + su energía). Excelente para preguntas de antes/después (pasado vs. futuro, viejo patrón vs. nuevo patrón), parejas de problema/solución, o trabajo consciente/sombra. La Tirada de Dos Cartas también funciona maravillosamente para práctica diaria cuando quieres ligeramente más matiz que una Una Carta pero no necesitas la narrativa completa de Tres Cartas.",

    ca: "Tria la Tirada de Dues Cartes quan enfrontis una decisió binària—Feina A o Feina B? Quedar-se o marxar? Parlar o romandre en silenci? És perfecta per comparar dues opcions diferents on necessites veure l'energia, resultat, o naturalesa de cada camí. Usa-la per explorar dinàmiques de relació (tu vs. ells, com us veieu mútuament, la teva energia + la seva energia). Excel·lent per a preguntes d'abans/després (passat vs. futur, vell patró vs. nou patró), parelles de problema/solució, o treball conscient/ombra. La Tirada de Dues Cartes també funciona meravellosament per a pràctica diària quan vols lleugerament més matís que una Una Carta però no necessites la narrativa completa de Tres Cartes.",
  },

  whenToAvoid: {
    en: "Avoid the Two Card Spread when you're facing more than two options—if you have three or more paths, you'll need a different structure. Skip it if you need detailed context or timeline (Three Card or larger spreads are better). Not ideal for complex situations with many interconnected factors—Two Cards will oversimplify. Also avoid when the question isn't truly binary; sometimes what seems like 'A or B' is actually a false dichotomy, and the Two Card Spread might reinforce either/or thinking when you actually need a more nuanced approach. If one option clearly feels wrong, you don't need tarot to confirm it.",

    es: "Evita la Tirada de Dos Cartas cuando enfrentes más de dos opciones—si tienes tres o más caminos, necesitarás una estructura diferente. Omítela si necesitas contexto o línea temporal detallada (Tres Cartas o tiradas más grandes son mejores). No es ideal para situaciones complejas con muchos factores interconectados—Dos Cartas sobresimplificará. También evítala cuando la pregunta no sea verdaderamente binaria; a veces lo que parece 'A o B' es en realidad una dicotomía falsa, y la Tirada de Dos Cartas podría reforzar pensamiento de esto/aquello cuando en realidad necesitas un enfoque más matizado. Si una opción claramente se siente mal, no necesitas tarot para confirmarlo.",

    ca: "Evita la Tirada de Dues Cartes quan enfrontis més de dues opcions—si tens tres o més camins, necessitaràs una estructura diferent. Omet-la si necessites context o línia temporal detallada (Tres Cartes o tirades més grans són millors). No és ideal per a situacions complexes amb molts factors interconnectats—Dues Cartes sobresimplificarà. També evita-la quan la pregunta no sigui veritablement binària; a vegades el que sembla 'A o B' és en realitat una dicotomia falsa, i la Tirada de Dues Cartes podria reforçar pensament d'això/allò quan en realitat necessites un enfocament més matitzat. Si una opció clarament es sent malament, no necessites tarot per confirmar-ho.",
  },

  interpretationMethod: {
    en: "Read each card individually first, giving full attention to Option A, then Option B. Notice the energy quality of each: Is one lighter, one heavier? More active vs. passive? Challenging vs. easy? Then—and this is crucial—read the relationship BETWEEN the cards. Do they complement each other (Fire + Earth = action grounded in reality)? Oppose each other (conflict to resolve)? Does one card answer or resolve the other? Look at the visual dialogue: Are figures facing each other or looking away? Similar or contrasting colors? If comparing options, notice which feels more aligned with your highest good (not just easiest or most comfortable). For relationship readings, the space BETWEEN the cards is where the real insight lives—that's where the dynamic plays out. If both cards are difficult, the message might be 'neither path as currently conceived,' inviting you to find a third way. Trust your intuition about which card draws your eye more strongly.",

    es: "Lee cada carta individualmente primero, dando plena atención a Opción A, luego Opción B. Observa la cualidad energética de cada una: ¿Es una más ligera, una más pesada? ¿Más activa vs. pasiva? ¿Desafiante vs. fácil? Entonces—y esto es crucial—lee la relación ENTRE las cartas. ¿Se complementan mutuamente (Fuego + Tierra = acción arraigada en realidad)? ¿Se oponen (conflicto a resolver)? ¿Responde o resuelve una carta la otra? Mira el diálogo visual: ¿Las figuras se miran mutuamente o apartan la mirada? ¿Colores similares o contrastantes? Si comparas opciones, nota cuál se siente más alineada con tu mayor bien (no solo más fácil o cómoda). Para lecturas de relación, el espacio ENTRE las cartas es donde vive la verdadera percepción—ahí es donde se desarrolla la dinámica. Si ambas cartas son difíciles, el mensaje podría ser 'ningún camino como actualmente concebido,' invitándote a encontrar una tercera vía. Confía en tu intuición sobre qué carta atrae tu mirada más fuertemente.",

    ca: "Llegeix cada carta individualment primer, donant plena atenció a Opció A, després Opció B. Observa la qualitat energètica de cada una: És una més lleugera, una més pesada? Més activa vs. passiva? Desafiant vs. fàcil? Aleshores—i això és crucial—llegeix la relació ENTRE les cartes. Es complementen mútuament (Foc + Terra = acció arrelada en realitat)? S'oposen (conflicte a resoldre)? Respon o resol una carta l'altra? Mira el diàleg visual: Les figures es miren mútuament o aparten la mirada? Colors similars o contrastants? Si compares opcions, nota quina es sent més alineada amb el teu major bé (no només més fàcil o còmoda). Per a lectures de relació, l'espai ENTRE les cartes és on viu la veritable percepció—allà és on es desenvolupa la dinàmica. Si totes dues cartes són difícils, el missatge podria ser 'cap camí com actualment concebut,' convidant-te a trobar una tercera via. Confia en la teva intuïció sobre quina carta atrau la teva mirada més fortament.",
  },

  traditionalOrigin: {
    en: "The Two Card Spread is one of the oldest comparative techniques in cartomancy, used by Italian and French fortune-tellers as early as the 16th century to answer 'this or that' questions. In tarot tradition, it gained prominence in the 19th century for relationship consultations and decision-making. Modern tarot innovators like Angeles Arrien and Rachel Pollack have expanded its use beyond simple choice comparison to explore psychological dualities, shadow work, and the integration of opposites—a concept deeply rooted in Jungian psychology and alchemical symbolism that tarot naturally embodies.",

    es: "La Tirada de Dos Cartas es una de las técnicas comparativas más antiguas en cartomancia, usada por adivinos italianos y franceses ya en el siglo XVI para responder preguntas de 'esto o aquello'. En la tradición del tarot, ganó prominencia en el siglo XIX para consultas de relaciones y toma de decisiones. Innovadoras modernas del tarot como Angeles Arrien y Rachel Pollack han expandido su uso más allá de simple comparación de opciones para explorar dualidades psicológicas, trabajo de sombra, e integración de opuestos—un concepto profundamente arraigado en psicología junguiana y simbolismo alquímico que el tarot naturalmente encarna.",

    ca: "La Tirada de Dues Cartes és una de les tècniques comparatives més antigues en cartomància, usada per endevins italians i francesos ja al segle XVI per respondre preguntes de 'això o allò'. En la tradició del tarot, va guanyar prominència al segle XIX per a consultes de relacions i presa de decisions. Innovadores modernes del tarot com Angeles Arrien i Rachel Pollack han expandit el seu ús més enllà de simple comparació d'opcions per explorar dualitats psicològiques, treball d'ombra, i integració d'oposats—un concepte profundament arrelat en psicologia junguiana i simbolisme alquímic que el tarot naturalment encarna.",
  },

  positionInteractions: [
    {
      description: {
        en: "OPTION_A ↔ OPTION_B reveals the comparative energy and outcomes of two choices",
        es: "OPCIÓN_A ↔ OPCIÓN_B revela la energía comparativa y resultados de dos opciones",
        ca: "OPCIÓ_A ↔ OPCIÓ_B revela l'energia comparativa i resultats de dues opcions",
      },
      positions: ["OPTION_A", "OPTION_B"],
      aiGuidance: "Compare the cards directly: Which has more positive energy? Which challenges or activates the querent more? Look for elemental harmony/conflict (Fire+Fire=amplification, Water+Fire=tension). If one is Major Arcana and one Minor, the Major suggests a fated or more significant path. Notice if the cards create a narrative (one leads to the other) or contrast (opposition to integrate). The relationship BETWEEN cards matters as much as individual meanings.",
    },
  ],

  aiSelectionCriteria: {
    questionPatterns: [
      "should i choose",
      "this or that",
      "option a or b",
      "which path",
      "compare",
      "versus",
      "stay or go",
      "yes or no with context",
      "relationship dynamic",
      "me and them",
      "before and after",
      "problem and solution",
    ],
    emotionalStates: [
      "torn between two choices",
      "need comparison",
      "exploring options",
      "relationship question",
      "seeking clarity on decision",
      "understanding duality",
    ],
    preferWhen: {
      cardCountPreference: "2",
      complexityLevel: "simple",
      experienceLevel: "any",
      timeframe: "immediate decision, present dynamics",
    },
  },
};

/**
 * FIVE CARD CROSS
 * Classic cross layout examining past-present-future with obstacles and advice
 */
const FIVE_CARD_CROSS_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "The Five Card Cross is a time-tested layout that maps your journey through time while illuminating the hidden forces at play. This cross formation creates a sacred intersection where past influences, present circumstances, and future potentials meet—with the vertical axis revealing what holds you back below and what guidance lifts you up above. It's the perfect balance of temporal insight and practical wisdom.",
    es: "La Cruz de Cinco Cartas es una disposición probada en el tiempo que mapea tu viaje a través del tiempo mientras ilumina las fuerzas ocultas en juego. Esta formación en cruz crea una intersección sagrada donde se encuentran las influencias del pasado, las circunstancias presentes y los potenciales futuros, con el eje vertical revelando lo que te retiene abajo y qué guía te eleva arriba. Es el equilibrio perfecto entre visión temporal y sabiduría práctica.",
    ca: "La Creu de Cinc Cartes és una disposició provada en el temps que mapeja el teu viatge a través del temps mentre il·lumina les forces ocultes en joc. Aquesta formació en creu crea una intersecció sagrada on es troben les influències del passat, les circumstàncies presents i els potencials futurs, amb l'eix vertical revelant el que et reté a baix i quina guia t'eleva a dalt. És l'equilibri perfecte entre visió temporal i saviesa pràctica.",
  },
  whenToUse: {
    en: "Draw the Five Card Cross when you're navigating a significant life transition and need to understand the full arc of your journey—where you've been, where you are, where you're heading. Perfect when you sense obstacles or blocks but can't identify them, when past patterns keep repeating, or when you need not just prediction but actionable guidance. This spread shines when the situation has temporal depth (not just 'today' but weeks or months of development) and when you're ready to hear both challenges and solutions. Ideal for career crossroads, relationship inflection points, major decisions, or when you feel stuck and need a roadmap forward.",
    es: "Despliega la Cruz de Cinco Cartas cuando estés navegando una transición vital significativa y necesites comprender el arco completo de tu viaje: de dónde vienes, dónde estás, hacia dónde te diriges. Perfecta cuando percibes obstáculos o bloqueos pero no puedes identificarlos, cuando los patrones del pasado siguen repitiéndose, o cuando necesitas no solo predicción sino guía accionable. Esta tirada brilla cuando la situación tiene profundidad temporal (no solo 'hoy' sino semanas o meses de desarrollo) y cuando estás lista para escuchar tanto desafíos como soluciones. Ideal para encrucijadas profesionales, puntos de inflexión en relaciones, decisiones importantes, o cuando te sientes atascada y necesitas un mapa hacia adelante.",
    ca: "Desplega la Creu de Cinc Cartes quan estiguis navegant una transició vital significativa i necessitis comprendre l'arc complet del teu viatge: d'on vens, on ets, cap a on et dirigeixes. Perfecta quan percebs obstacles o bloquejos però no pots identificar-los, quan els patrons del passat continuen repetint-se, o quan necessites no només predicció sinó guia accionable. Aquesta tirada brilla quan la situació té profunditat temporal (no només 'avui' sinó setmanes o mesos de desenvolupament) i quan estàs preparat per escoltar tant desafiaments com solucions. Ideal per a encreuaments professionals, punts d'inflexió en relacions, decisions importants, o quan et sents encallat i necessites un mapa cap endavant.",
  },
  whenToAvoid: {
    en: "Skip the Five Card Cross for simple yes/no questions, daily guidance, or purely exploratory readings where you're just curious. If your question is already crystal clear and you only need confirmation (not investigation), use a simpler spread. Also avoid this when comparing multiple options side-by-side—it reads one path's timeline, not parallel choices.",
    es: "Omite la Cruz de Cinco Cartas para preguntas simples de sí/no, guía diaria, o lecturas puramente exploratorias donde solo tienes curiosidad. Si tu pregunta ya está cristalina y solo necesitas confirmación (no investigación), usa una tirada más simple. También evítala cuando compares múltiples opciones lado a lado: lee la línea temporal de un camino, no elecciones paralelas.",
    ca: "Omet la Creu de Cinc Cartes per a preguntes simples de sí/no, guia diària, o lectures purament exploratòries on només tens curiositat. Si la teva pregunta ja està cristal·lina i només necessites confirmació (no investigació), usa una tirada més simple. També evita-la quan comparis múltiples opcions costat a costat: llegeix la línia temporal d'un camí, no eleccions paral·leles.",
  },
  interpretationMethod: {
    en: "Read the Five Card Cross in sacred order: first establish your timeline (Past → Present → Future as the horizontal beam), grounding yourself in the narrative arc. Then examine the vertical axis: What Holds You Back (below, the weight pulling down) and Advice (above, the light guiding up). The Present card is your anchor—all other cards revolve around this central moment. Look for dialogues: Does the Past explain the block? Does the Advice address the Future? Does the obstacle stem from old patterns (Past) or fears about what's coming (Future)? Notice if cards are predominantly Major Arcana (fated, significant) or Minor (everyday, within your control). Court cards in Past/Present suggest people still influencing the situation; in Future, people you'll encounter. The cross shape itself is protective—it holds your question in sacred geometry. If the Future card is challenging, the Advice card becomes crucial. If the block is a Major Arcana, the work is soul-level. The Present card's suit (Wands = action, Cups = emotion, Swords = thought, Pentacles = material) tells you which realm is dominant right now.",
    es: "Lee la Cruz de Cinco Cartas en orden sagrado: primero establece tu línea temporal (Pasado → Presente → Futuro como la viga horizontal), arraigándote en el arco narrativo. Luego examina el eje vertical: Lo que te Retiene (abajo, el peso que tira hacia abajo) y el Consejo (arriba, la luz que guía hacia arriba). La carta del Presente es tu ancla: todas las demás cartas giran alrededor de este momento central. Busca diálogos: ¿El Pasado explica el bloqueo? ¿El Consejo responde al Futuro? ¿El obstáculo proviene de patrones antiguos (Pasado) o miedos sobre lo que viene (Futuro)? Observa si las cartas son predominantemente Arcanos Mayores (destinados, significativos) o Menores (cotidianos, bajo tu control). Cartas de corte en Pasado/Presente sugieren personas que aún influyen en la situación; en Futuro, personas que encontrarás. La forma de cruz en sí es protectora: sostiene tu pregunta en geometría sagrada. Si la carta del Futuro es desafiante, la carta de Consejo se vuelve crucial. Si el bloqueo es un Arcano Mayor, el trabajo es a nivel del alma. El palo de la carta del Presente (Bastos = acción, Copas = emoción, Espadas = pensamiento, Oros = material) te dice qué reino es dominante ahora mismo.",
    ca: "Llegeix la Creu de Cinc Cartes en ordre sagrat: primer estableix la teva línia temporal (Passat → Present → Futur com la biga horitzontal), arrelant-te en l'arc narratiu. Després examina l'eix vertical: El que et Reté (a baix, el pes que tira cap avall) i el Consell (a dalt, la llum que guia cap amunt). La carta del Present és la teva àncora: totes les altres cartes giren al voltant d'aquest moment central. Busca diàlegs: El Passat explica el bloqueig? El Consell respon al Futur? L'obstacle prové de patrons antics (Passat) o pors sobre el que ve (Futur)? Observa si les cartes són predominantment Arcans Majors (destinats, significatius) o Menors (quotidians, sota el teu control). Cartes de cort en Passat/Present suggereixen persones que encara influeixen en la situació; en Futur, persones que trobaràs. La forma de creu en si és protectora: sosté la teva pregunta en geometria sagrada. Si la carta del Futur és desafiant, la carta de Consell es torna crucial. Si el bloqueig és un Arcà Major, el treball és a nivell de l'ànima. El pal de la carta del Present (Bastos = acció, Copes = emoció, Espases = pensament, Oros = material) et diu quin regne és dominant ara mateix.",
  },
  traditionalOrigin: {
    en: "The cross formation is one of the oldest and most universal layouts in cartomancy, appearing in European fortune-telling traditions as early as the 16th century. The symbolic power of the cross—representing the intersection of heaven and earth, time and eternity, fate and free will—made it a natural choice for divination. The Five Card Cross specifically evolved as a streamlined version of larger cross spreads (like the Celtic Cross), retaining the essential temporal and spiritual dimensions while remaining accessible for intermediate readers.",
    es: "La formación en cruz es una de las disposiciones más antiguas y universales en la cartomancia, apareciendo en las tradiciones de adivinación europeas ya en el siglo XVI. El poder simbólico de la cruz—representando la intersección del cielo y la tierra, el tiempo y la eternidad, el destino y el libre albedrío—la convirtió en una elección natural para la adivinación. La Cruz de Cinco Cartas específicamente evolucionó como una versión simplificada de cruces más grandes (como la Cruz Céltica), reteniendo las dimensiones temporales y espirituales esenciales mientras permanece accesible para lectores intermedios.",
    ca: "La formació en creu és una de les disposicions més antigues i universals en la cartomància, apareixent en les tradicions d'endevinació europees ja al segle XVI. El poder simbòlic de la creu—representant la intersecció del cel i la terra, el temps i l'eternitat, el destí i el lliure albir—la va convertir en una elecció natural per a l'endevinació. La Creu de Cinc Cartes específicament va evolucionar com una versió simplificada de creus més grans (com la Creu Cèltica), retenint les dimensions temporals i espirituals essencials mentre roman accessible per a lectors intermedis.",
  },
  positionInteractions: [
    {
      description: {
        en: "Past → Present: The Foundation Arc - How history shapes now",
        es: "Pasado → Presente: El Arco Fundacional - Cómo la historia moldea el ahora",
        ca: "Passat → Present: L'Arc Fundacional - Com la història moldeja l'ara",
      },
      positions: ["PAST", "PRESENT"],
      aiGuidance: "Examine whether the Past card explains, justifies, or contradicts the Present. If they're harmonious (same suit or complementary energies), the querent has integrated lessons. If conflicting, old patterns are still disrupting current reality. Past Major Arcana = unavoidable influences; Past Minor = everyday events that shaped today.",
    },
    {
      description: {
        en: "Present → Future: The Trajectory Arc - Where current energy leads",
        es: "Presente → Futuro: El Arco de Trayectoria - Hacia dónde conduce la energía actual",
        ca: "Present → Futur: L'Arc de Trajectòria - Cap a on condueix l'energia actual",
      },
      positions: ["PRESENT", "FUTURE"],
      aiGuidance: "This shows the natural outcome if the current course continues unchanged. If Present and Future are both positive or both challenging, the path is clear. If they contrast (positive Present → challenging Future, or vice versa), something will shift. The Advice card becomes critical when the Future concerns the querent.",
    },
    {
      description: {
        en: "What Holds You Back ↔ Present: The Obstacle Dynamic",
        es: "Lo que te Retiene ↔ Presente: La Dinámica del Obstáculo",
        ca: "El que et Reté ↔ Present: La Dinàmica de l'Obstacle",
      },
      positions: ["BLOCK", "PRESENT"],
      aiGuidance: "The block card sits below the Present, literally 'underneath' the current situation—it's the hidden weight, the unconscious pattern, the fear or limitation not fully acknowledged. If it mirrors the Past, the block is old and entrenched. If it echoes a reversed card elsewhere, it's an inverted strength. Pay attention to whether the querent recognizes this block or is blind to it.",
    },
    {
      description: {
        en: "Advice ↔ Future: The Guidance-Outcome Dialogue",
        es: "Consejo ↔ Futuro: El Diálogo Guía-Resultado",
        ca: "Consell ↔ Futur: El Diàleg Guia-Resultat",
      },
      positions: ["ADVICE", "FUTURE"],
      aiGuidance: "The Advice card sits above the Present, offering elevation and spiritual guidance. Does it directly address what's needed to reach (or avoid) the Future? If Future is challenging and Advice is empowering, there's hope for redirection. If Future is positive and Advice reinforces it, the path is blessed. The Advice should always be actionable—translate mystical imagery into concrete steps.",
    },
    {
      description: {
        en: "The Full Cross: Sacred Intersection of Time and Spirit",
        es: "La Cruz Completa: Intersección Sagrada de Tiempo y Espíritu",
        ca: "La Creu Completa: Intersecció Sagrada de Temps i Esperit",
      },
      positions: ["PAST", "PRESENT", "FUTURE", "BLOCK", "ADVICE"],
      aiGuidance: "Step back and see the cross as a whole. Horizontal axis = the river of time flowing left to right. Vertical axis = the spiritual dimension, from shadow (below) to light (above). The Present card is the nexus where everything meets. Count Major vs Minor Arcana to gauge fate vs free will. Note dominant suits to identify the primary realm (emotional, mental, material, spiritual). If all five cards tell one cohesive story, the reading has strong clarity. If they seem disconnected, look deeper for the hidden thread.",
    },
  ],
  aiSelectionCriteria: {
    questionPatterns: [
      "what's blocking me",
      "why am i stuck",
      "where is this going",
      "what should i do about",
      "help me understand this situation",
      "career transition",
      "relationship issue",
      "major decision",
      "life crossroads",
      "past affecting present",
      "how did i get here",
      "what happens next",
    ],
    emotionalStates: [
      "feeling stuck or blocked",
      "confused about direction",
      "need clarity on obstacles",
      "seeking guidance and advice",
      "navigating transition",
      "need practical wisdom",
      "ready for deeper insight",
    ],
    preferWhen: {
      cardCountPreference: "4-6",
      complexityLevel: "medium",
      experienceLevel: "intermediate",
      timeframe: "weeks to months, past-present-future arc",
    },
  },
};

/**
 * RELATIONSHIP SPREAD
 * Seven-card exploration of relationship dynamics between two people
 */
const RELATIONSHIP_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "The Relationship Spread is a comprehensive seven-card mirror that reflects the intricate dance between two souls. It honors both individuals' unique positions while illuminating the shared space they create together—examining strengths that bind, challenges that divide, the present dynamic, and the often-unspoken needs each person carries. This spread doesn't predict 'will we stay together?' but instead offers profound insight into 'who are we together, and what does each of us truly need?'",
    es: "La Tirada de Relación es un espejo integral de siete cartas que refleja la danza intrincada entre dos almas. Honra las posiciones únicas de ambos individuos mientras ilumina el espacio compartido que crean juntos, examinando las fortalezas que unen, los desafíos que dividen, la dinámica presente y las necesidades a menudo no expresadas que cada persona lleva. Esta tirada no predice '¿seguiremos juntos?' sino que ofrece una visión profunda de '¿quiénes somos juntos y qué necesita verdaderamente cada uno de nosotros?'",
    ca: "La Tirada de Relació és un mirall integral de set cartes que reflecteix la dansa intricada entre dues ànimes. Honora les posicions úniques de tots dos individus mentre il·lumina l'espai compartit que creen junts, examinant les fortaleses que uneixen, els desafiaments que divideixen, la dinàmica present i les necessitats sovint no expressades que cada persona porta. Aquesta tirada no prediu 'continuarem junts?' sinó que ofereix una visió profunda de 'qui som junts i què necessita veritablement cadascun de nosaltres?'",
  },
  whenToUse: {
    en: "Draw the Relationship Spread when you need to understand the deeper dynamics of a significant connection—romantic partnership, close friendship, family bond, or even a complex work relationship. Perfect when communication has broken down and you need perspective on what the other person might be experiencing. Use this spread when you're contemplating the relationship's health, when conflicts keep arising without resolution, when you sense a shift in the dynamic but can't name it, or when you need clarity on whether your needs and theirs can coexist. Especially powerful when both people are willing to hear truths about themselves and each other. This spread works for established relationships with history—it has less to offer for brand-new connections that haven't yet developed complexity.",
    es: "Despliega la Tirada de Relación cuando necesites comprender las dinámicas más profundas de una conexión significativa: pareja romántica, amistad cercana, vínculo familiar, o incluso una relación laboral compleja. Perfecta cuando la comunicación se ha roto y necesitas perspectiva sobre lo que la otra persona podría estar experimentando. Usa esta tirada cuando estés contemplando la salud de la relación, cuando los conflictos sigan surgiendo sin resolución, cuando percibas un cambio en la dinámica pero no puedas nombrarlo, o cuando necesites claridad sobre si tus necesidades y las suyas pueden coexistir. Especialmente poderosa cuando ambas personas están dispuestas a escuchar verdades sobre sí mismas y la otra. Esta tirada funciona para relaciones establecidas con historia: tiene menos que ofrecer para conexiones nuevas que aún no han desarrollado complejidad.",
    ca: "Desplega la Tirada de Relació quan necessitis comprendre les dinàmiques més profundes d'una connexió significativa: parella romàntica, amistat propera, vincle familiar, o fins i tot una relació laboral complexa. Perfecta quan la comunicació s'ha trencat i necessites perspectiva sobre el que l'altra persona podria estar experimentant. Usa aquesta tirada quan estiguis contemplant la salut de la relació, quan els conflictes continuïn sorgint sense resolució, quan percebs un canvi en la dinàmica però no puguis nomenar-lo, o quan necessitis claredat sobre si les teves necessitats i les seves poden coexistir. Especialment poderosa quan totes dues persones estan disposades a escoltar veritats sobre si mateixes i l'altra. Aquesta tirada funciona per a relacions establertes amb història: té menys a oferir per a connexions noves que encara no han desenvolupat complexitat.",
  },
  whenToAvoid: {
    en: "Avoid this spread for 'will they come back?' or 'do they love me?' questions—those are predictive, not exploratory. Skip it if you're not ready to see your own role in the relationship's challenges (the 'You' card can be confronting). Don't use this for casual dating or crushes where there's no established dynamic yet. Also inappropriate if you're using it to manipulate or control the other person—tarot should empower both parties, not just one.",
    es: "Evita esta tirada para preguntas de '¿volverán?' o '¿me aman?': esas son predictivas, no exploratorias. Omítela si no estás lista para ver tu propio papel en los desafíos de la relación (la carta de 'Tú' puede ser confrontante). No la uses para citas casuales o enamoramientos donde aún no hay una dinámica establecida. También es inapropiada si la usas para manipular o controlar a la otra persona: el tarot debe empoderar a ambas partes, no solo a una.",
    ca: "Evita aquesta tirada per a preguntes de 'tornaran?' o 'm'estimen?': aquestes són predictives, no exploratòries. Omet-la si no estàs preparat per veure el teu propi paper en els desafiaments de la relació (la carta de 'Tu' pot ser confrontant). No l'usis per a cites casuals o enamoraments on encara no hi ha una dinàmica establerta. També és inapropiada si l'uses per manipular o controlar l'altra persona: el tarot ha d'apoderar totes dues parts, no només una.",
  },
  interpretationMethod: {
    en: "Begin by reading 'You' and 'Partner' as portraits—what energy does each person bring to the relationship right now? Notice if one is Major Arcana and the other Minor (imbalance of significance or power). Then examine 'Strengths' and 'Challenges' as the push-pull forces. Do the Strengths genuinely connect to both partners, or is the bond one-sided? Are the Challenges external (Tower, Devil) or internal emotional patterns (Five of Cups, Three of Swords)? The 'Current Dynamic' card is the heart of the reading—it shows the relationship's present state as an entity of its own, beyond the individuals. If it's harmonious, the relationship is healthy even if the partners are struggling individually. If it's fractured, even compatible people are creating toxicity together. Finally, read 'Your Needs' and 'Their Needs'—this is where most relationships falter. If the needs are compatible (both Cups for emotional intimacy, both Pentacles for security), there's potential. If they're opposed (you need freedom/Wands, they need commitment/Pentacles), honest conversation is required. Look for Court cards representing real people (ex-partners, family members, friends) who might be influencing the dynamic. Reversed cards in 'Needs' positions often show unspoken or suppressed desires. The absence of a specific suit across all seven cards can be significant—no Cups = emotional disconnect, no Swords = avoiding difficult truths.",
    es: "Comienza leyendo 'Tú' y 'Pareja' como retratos: ¿qué energía aporta cada persona a la relación ahora mismo? Observa si uno es Arcano Mayor y el otro Menor (desequilibrio de significado o poder). Luego examina 'Fortalezas' y 'Desafíos' como las fuerzas de empuje y tracción. ¿Las Fortalezas realmente conectan con ambos compañeros, o el vínculo es unilateral? ¿Los Desafíos son externos (Torre, Diablo) o patrones emocionales internos (Cinco de Copas, Tres de Espadas)? La carta de 'Dinámica Actual' es el corazón de la lectura: muestra el estado presente de la relación como una entidad propia, más allá de los individuos. Si es armoniosa, la relación es saludable incluso si los compañeros luchan individualmente. Si está fracturada, incluso personas compatibles están creando toxicidad juntas. Finalmente, lee 'Tus Necesidades' y 'Sus Necesidades': aquí es donde la mayoría de las relaciones fallan. Si las necesidades son compatibles (ambas Copas para intimidad emocional, ambos Oros para seguridad), hay potencial. Si están opuestas (tú necesitas libertad/Bastos, ellos necesitan compromiso/Oros), se requiere conversación honesta. Busca Cartas de Corte que representen personas reales (ex-parejas, familiares, amigos) que podrían estar influenciando la dinámica. Las cartas invertidas en posiciones de 'Necesidades' a menudo muestran deseos no expresados o suprimidos. La ausencia de un palo específico en las siete cartas puede ser significativa: sin Copas = desconexión emocional, sin Espadas = evitar verdades difíciles.",
    ca: "Comença llegint 'Tu' i 'Parella' com a retrats: quina energia aporta cada persona a la relació ara mateix? Observa si un és Arcà Major i l'altre Menor (desequilibri de significat o poder). Després examina 'Fortaleses' i 'Desafiaments' com les forces d'empenta i tracció. Les Fortaleses realment connecten amb tots dos companys, o el vincle és unilateral? Els Desafiaments són externs (Torre, Diable) o patrons emocionals interns (Cinc de Copes, Tres d'Espases)? La carta de 'Dinàmica Actual' és el cor de la lectura: mostra l'estat present de la relació com una entitat pròpia, més enllà dels individus. Si és harmoniosa, la relació és saludable fins i tot si els companys lluiten individualment. Si està fracturada, fins i tot persones compatibles estan creant toxicitat juntes. Finalment, llegeix 'Les Teves Necessitats' i 'Les Seves Necessitats': aquí és on la majoria de les relacions fallen. Si les necessitats són compatibles (totes dues Copes per intimitat emocional, tots dos Oros per seguretat), hi ha potencial. Si estan oposades (tu necessites llibertat/Bastos, ells necessiten compromís/Oros), es requereix conversa honesta. Busca Cartes de Cort que representin persones reals (ex-parelles, familiars, amics) que podrien estar influenciant la dinàmica. Les cartes invertides en posicions de 'Necessitats' sovint mostren desitjos no expressats o suprimits. L'absència d'un pal específic en les set cartes pot ser significativa: sense Copes = desconnexió emocional, sense Espases = evitar veritats difícils.",
  },
  traditionalOrigin: {
    en: "Relationship spreads evolved in the 19th and early 20th centuries as tarot reading shifted from fortune-telling toward psychological insight and interpersonal understanding. The seven-card relationship layout specifically became popular in the 1970s-80s during the tarot renaissance, when readers began focusing on emotional wellness and self-awareness rather than purely predictive readings. The symmetrical positioning of 'You' and 'Partner' honors the equality of both perspectives—a modern departure from older hierarchical relationship readings.",
    es: "Las tiradas de relación evolucionaron en los siglos XIX y principios del XX cuando la lectura del tarot pasó de la adivinación a la percepción psicológica y la comprensión interpersonal. La disposición de relación de siete cartas específicamente se popularizó en los años 1970-80 durante el renacimiento del tarot, cuando los lectores comenzaron a enfocarse en el bienestar emocional y la autoconciencia en lugar de lecturas puramente predictivas. El posicionamiento simétrico de 'Tú' y 'Pareja' honra la igualdad de ambas perspectivas: una desviación moderna de las lecturas relacionales jerárquicas antiguas.",
    ca: "Les tirades de relació van evolucionar als segles XIX i principis del XX quan la lectura del tarot va passar de l'endevinació a la percepció psicològica i la comprensió interpersonal. La disposició de relació de set cartes específicament es va popularitzar als anys 1970-80 durant el renaixement del tarot, quan els lectors van començar a enfocar-se en el benestar emocional i l'autoconsciència en lloc de lectures purament predictives. El posicionament simètric de 'Tu' i 'Parella' honra la igualtat de totes dues perspectives: una desviació moderna de les lectures relacionals jeràrquiques antigues.",
  },
  positionInteractions: [
    {
      description: {
        en: "You ↔ Partner: The Individual Portraits",
        es: "Tú ↔ Pareja: Los Retratos Individuales",
        ca: "Tu ↔ Parella: Els Retrats Individuals",
      },
      positions: ["YOU", "PARTNER"],
      aiGuidance: "Compare these two cards to assess compatibility and contrast. Are they complementary (Empress + Emperor, Two of Cups + Ace of Wands) or conflicting (Five of Pentacles + Ten of Cups)? If both are Court cards, they're acting out roles or personas rather than authentic selves. If both are Swords, the relationship is dominated by mental energy, possibly overthinking. Notice which card feels more powerful or active—that person is currently driving the relationship dynamic.",
    },
    {
      description: {
        en: "Strengths ↔ Challenges: The Push-Pull Balance",
        es: "Fortalezas ↔ Desafíos: El Equilibrio de Empuje y Tracción",
        ca: "Fortaleses ↔ Desafiaments: L'Equilibri d'Empenta i Tracció",
      },
      positions: ["STRENGTHS", "CHALLENGES"],
      aiGuidance: "These two cards define the relationship's core tension. If Strengths outweigh Challenges (Major Arcana strength vs Minor challenge), the relationship can weather storms. If Challenges are Major and Strengths Minor, survival is difficult. Look for cards that mirror each other (Ten of Cups as strength, Five of Cups as challenge = emotional focus). Reversed Challenges may indicate internal sabotage rather than external obstacles.",
    },
    {
      description: {
        en: "Current Dynamic: The Relationship as Its Own Entity",
        es: "Dinámica Actual: La Relación como Su Propia Entidad",
        ca: "Dinàmica Actual: La Relació com a Pròpia Entitat",
      },
      positions: ["DYNAMIC"],
      aiGuidance: "This single card is crucial—it transcends the individuals to show the relationship's living energy right now. If it's positive (Sun, Star, Ten of Cups), the relationship itself is healthy even if individuals struggle. If negative (Tower, Three of Swords, Five of Pentacles), the relationship creates suffering even if the people are compatible. Major Arcana here = destiny or karma; Minor = everyday interactions creating the vibe.",
    },
    {
      description: {
        en: "Your Needs ↔ Their Needs: The Negotiation Space",
        es: "Tus Necesidades ↔ Sus Necesidades: El Espacio de Negociación",
        ca: "Les Teves Necessitats ↔ Les Seves Necessitats: L'Espai de Negociació",
      },
      positions: ["YOUR_NEEDS", "THEIR_NEEDS"],
      aiGuidance: "These cards reveal what each person truly requires to feel fulfilled—and whether those needs can coexist. Compatible suits (both Cups, both Pentacles) = aligned needs. Opposing suits (Wands/Pentacles or Cups/Swords) = tension requiring compromise. Major Arcana in needs = non-negotiable soul requirements. Reversed needs = unspoken, denied, or misunderstood desires. If one need is clearly being met (resonates with Strengths or Dynamic) and the other isn't, there's imbalance.",
    },
    {
      description: {
        en: "Full Relationship Ecosystem: All Seven Cards in Dialogue",
        es: "Ecosistema Completo de Relación: Las Siete Cartas en Diálogo",
        ca: "Ecosistema Complet de Relació: Les Set Cartes en Diàleg",
      },
      positions: ["YOU", "PARTNER", "STRENGTHS", "CHALLENGES", "DYNAMIC", "YOUR_NEEDS", "THEIR_NEEDS"],
      aiGuidance: "Step back and view the entire spread as a system. Count Major vs Minor Arcana to gauge whether this is a fated soul connection or an everyday companionship. Notice if certain suits dominate (all Swords = communication/conflict focus, all Cups = emotional realm, etc). Look for narrative threads: Do the needs cards explain the challenge card? Does the dynamic reflect both portraits, or just one person's energy? Are there repeated numbers (multiple Threes, Fives, Tens) suggesting a thematic lesson? The most powerful readings are when all seven cards tell one cohesive, undeniable story.",
    },
  ],
  aiSelectionCriteria: {
    questionPatterns: [
      "my relationship with",
      "relationship dynamics",
      "partner and i",
      "we keep fighting",
      "relationship problems",
      "understand my partner",
      "are we compatible",
      "relationship health",
      "what does my partner need",
      "what do we need",
      "relationship guidance",
      "couple reading",
    ],
    emotionalStates: [
      "relationship confusion",
      "communication breakdown",
      "seeking relationship insight",
      "conflict with partner",
      "need relationship clarity",
      "contemplating relationship",
      "want to understand partner",
    ],
    preferWhen: {
      cardCountPreference: "6-8",
      complexityLevel: "medium",
      experienceLevel: "any",
      timeframe: "present dynamics, established relationships",
    },
  },
};

/**
 * PYRAMID SPREAD
 * Holistic six-card structure for goal manifestation
 */
const PYRAMID_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "The Pyramid Spread is an ancient sacred geometry that maps the holistic path to manifesting your desires. Like the Great Pyramids themselves, this spread builds from a solid three-card foundation (Action, Resources, Foundation) up through the integrated duality of Mind and Heart, culminating in the apex Goal—your North Star. It recognizes that true achievement requires alignment across all dimensions: mental clarity, emotional resonance, practical action, available tools, and unshakable roots. This isn't just 'what will happen' but 'how to make it happen.'",
    es: "La Tirada Piramidal es una geometría sagrada antigua que mapea el camino holístico para manifestar tus deseos. Como las Grandes Pirámides mismas, esta tirada se construye desde una base sólida de tres cartas (Acción, Recursos, Fundamento) a través de la dualidad integrada de Mente y Corazón, culminando en el Objetivo del ápice, tu Estrella del Norte. Reconoce que el logro verdadero requiere alineación en todas las dimensiones: claridad mental, resonancia emocional, acción práctica, herramientas disponibles y raíces inquebrantables. No es solo 'qué pasará' sino 'cómo hacerlo suceder.'",
    ca: "La Tirada Piramidal és una geometria sagrada antiga que mapeja el camí holístic per manifestar els teus desitjos. Com les Grans Piràmides mateixes, aquesta tirada es construeix des d'una base sòlida de tres cartes (Acció, Recursos, Fonament) a través de la dualitat integrada de Ment i Cor, culminant en l'Objectiu de l'àpex, la teva Estrella del Nord. Reconeix que l'assoliment vertader requereix alineació en totes les dimensions: claredat mental, ressonància emocional, acció pràctica, eines disponibles i arrels inquebrantables. No és només 'què passarà' sinó 'com fer-ho succeir.'",
  },
  whenToUse: {
    en: "Draw the Pyramid when you have a clear goal or aspiration and need a comprehensive map of how to achieve it—especially when you've tried before and hit invisible blocks. Perfect for ambitious projects (career goals, creative endeavors, relationship aspirations, personal transformation) where you know WHAT you want but struggle with HOW to get there. This spread shines when you need to check all systems: Are your thoughts supporting your goal? Do your emotions align with it? Are you taking effective action? Do you have the right resources? Is your foundation stable? Use this when you're ready to do the inner and outer work required for manifestation. Ideal for New Moon intentions, quarterly goal-setting, or when starting a new chapter.",
    es: "Despliega la Pirámide cuando tengas un objetivo o aspiración clara y necesites un mapa completo de cómo lograrlo, especialmente cuando lo has intentado antes y has encontrado bloqueos invisibles. Perfecta para proyectos ambiciosos (objetivos profesionales, esfuerzos creativos, aspiraciones relacionales, transformación personal) donde sabes QUÉ quieres pero luchas con CÓMO llegar allí. Esta tirada brilla cuando necesitas verificar todos los sistemas: ¿Tus pensamientos apoyan tu objetivo? ¿Tus emociones se alinean con él? ¿Estás tomando acción efectiva? ¿Tienes los recursos correctos? ¿Tu fundamento es estable? Úsala cuando estés lista para hacer el trabajo interno y externo requerido para la manifestación. Ideal para intenciones de Luna Nueva, establecimiento de objetivos trimestrales, o cuando inicias un nuevo capítulo.",
    ca: "Desplega la Piràmide quan tinguis un objectiu o aspiració clara i necessitis un mapa complet de com aconseguir-ho, especialment quan ho has intentat abans i has trobat bloquejos invisibles. Perfecta per a projectes ambiciosos (objectius professionals, esforços creatius, aspiracions relacionals, transformació personal) on saps QUÈ vols però lluites amb COM arribar-hi. Aquesta tirada brilla quan necessites verificar tots els sistemes: Els teus pensaments recolzen el teu objectiu? Les teves emocions s'alineen amb ell? Estàs prenent acció efectiva? Tens els recursos correctes? El teu fonament és estable? Usa-la quan estiguis preparat per fer el treball intern i extern requerit per a la manifestació. Ideal per a intencions de Lluna Nova, establiment d'objectius trimestrals, o quan inicies un nou capítol.",
  },
  whenToAvoid: {
    en: "Skip the Pyramid if you don't actually have a goal in mind—this spread requires a clear aspiration as the focal point. Avoid it for questions about other people's choices or situations outside your control (the Pyramid is about YOUR agency). Don't use this for yes/no questions, past explorations, or when you're in crisis mode and need immediate triage rather than strategic planning.",
    es: "Omite la Pirámide si no tienes realmente un objetivo en mente: esta tirada requiere una aspiración clara como punto focal. Evítala para preguntas sobre las elecciones de otras personas o situaciones fuera de tu control (la Pirámide trata sobre TU agencia). No la uses para preguntas de sí/no, exploraciones del pasado, o cuando estés en modo crisis y necesites triaje inmediato en lugar de planificación estratégica.",
    ca: "Omet la Piràmide si no tens realment un objectiu al cap: aquesta tirada requereix una aspiració clara com a punt focal. Evita-la per a preguntes sobre les eleccions d'altres persones o situacions fora del teu control (la Piràmide tracta sobre la TEVA agència). No l'usis per a preguntes de sí/no, exploracions del passat, o quan estiguis en mode crisi i necessitis triatge immediat en lloc de planificació estratègica.",
  },
  interpretationMethod: {
    en: "Start at the apex: the Goal card reveals not just your conscious desire but the soul lesson or archetype you're embodying through this pursuit. A Major Arcana goal = spiritual initiation; a court card = identity transformation; a numbered Minor = skill development. Then read the Mind-Heart duality: these must work together, not war. Mind shows your mental approach (strategy, beliefs, blocks). Heart reveals emotional truth (desires, fears, motivations). If Mind and Heart conflict (Three of Swords + Ten of Cups), you have cognitive dissonance to resolve. Now descend to the Foundation layer, reading left to right: Action (what you must DO—this should be immediately actionable), Resources (internal gifts or external tools you possess or can access), Foundation (the bedrock supporting everything—past experiences, core values, relationships, stability). If the Foundation is shaky (Tower, Five of Pentacles), address this BEFORE pursuing the Goal. The sacred geometry matters: the pyramid shape channels energy upward. Reversed cards in the foundation suggest unstable ground. Court cards show people who will be key allies or teachers. The ideal reading has all six cards in conversation, telling one coherent story of manifestation. If disconnected, identify the missing link—often it's emotional resistance (Heart) or lack of foundational support.",
    es: "Comienza en el ápice: la carta del Objetivo revela no solo tu deseo consciente sino la lección del alma o arquetipo que estás encarnando a través de esta búsqueda. Un objetivo de Arcano Mayor = iniciación espiritual; una carta de corte = transformación de identidad; un Menor numerado = desarrollo de habilidades. Luego lee la dualidad Mente-Corazón: estas deben trabajar juntas, no guerrear. La Mente muestra tu enfoque mental (estrategia, creencias, bloqueos). El Corazón revela la verdad emocional (deseos, miedos, motivaciones). Si Mente y Corazón entran en conflicto (Tres de Espadas + Diez de Copas), tienes disonancia cognitiva por resolver. Ahora desciende a la capa de Fundamento, leyendo de izquierda a derecha: Acción (lo que DEBES HACER—esto debe ser inmediatamente accionable), Recursos (dones internos o herramientas externas que posees o puedes acceder), Fundamento (la roca madre que sostiene todo—experiencias pasadas, valores centrales, relaciones, estabilidad). Si el Fundamento es inestable (Torre, Cinco de Oros), aborda esto ANTES de perseguir el Objetivo. La geometría sagrada importa: la forma piramidal canaliza energía hacia arriba. Cartas invertidas en el fundamento sugieren terreno inestable. Cartas de corte muestran personas que serán aliados clave o maestros. La lectura ideal tiene las seis cartas en conversación, contando una historia coherente de manifestación. Si están desconectadas, identifica el eslabón perdido—a menudo es resistencia emocional (Corazón) o falta de apoyo fundacional.",
    ca: "Comença a l'àpex: la carta de l'Objectiu revela no només el teu desig conscient sinó la lliçó de l'ànima o arquetip que estàs encarnant a través d'aquesta cerca. Un objectiu d'Arcà Major = iniciació espiritual; una carta de cort = transformació d'identitat; un Menor numerat = desenvolupament d'habilitats. Després llegeix la dualitat Ment-Cor: aquestes han de treballar juntes, no guerrejar. La Ment mostra el teu enfocament mental (estratègia, creences, bloquejos). El Cor revela la veritat emocional (desitjos, pors, motivacions). Si Ment i Cor entren en conflicte (Tres d'Espases + Deu de Copes), tens dissonància cognitiva per resoldre. Ara descendeix a la capa de Fonament, llegint d'esquerra a dreta: Acció (el que HAS DE FER—això ha de ser immediatament accionable), Recursos (dons interns o eines externes que posseïxes o pots accedir), Fonament (la roca mare que sosté tot—experiències passades, valors centrals, relacions, estabilitat). Si el Fonament és inestable (Torre, Cinc d'Oros), aborda això ABANS de perseguir l'Objectiu. La geometria sagrada importa: la forma piramidal canalitza energia cap amunt. Cartes invertides al fonament suggereixen terreny inestable. Cartes de cort mostren persones que seran aliats clau o mestres. La lectura ideal té les sis cartes en conversa, comptant una història coherent de manifestació. Si estan desconnectades, identifica l'enllaç perdut—sovint és resistència emocional (Cor) o manca de suport fundacional.",
  },
  traditionalOrigin: {
    en: "The Pyramid spread draws from ancient esoteric traditions that revered triangular and pyramidal structures as symbols of manifestation, ascension, and divine proportion. The pyramid shape appears in mystical texts from ancient Egypt to Renaissance alchemy, always representing the journey from earthly matter to spiritual perfection. This particular six-card configuration emerged in modern tarot practice (mid-20th century) as readers sought spreads that honored both practical and spiritual dimensions of goal-setting—a synthesis of Western occultism's emphasis on Will and manifestation with Eastern philosophies of aligned action.",
    es: "La tirada Piramidal se nutre de tradiciones esotéricas antiguas que reverenciaban las estructuras triangulares y piramidales como símbolos de manifestación, ascensión y proporción divina. La forma piramidal aparece en textos místicos desde el antiguo Egipto hasta la alquimia renacentista, siempre representando el viaje desde la materia terrenal a la perfección espiritual. Esta configuración particular de seis cartas surgió en la práctica moderna del tarot (mediados del siglo XX) cuando los lectores buscaban tiradas que honraran tanto las dimensiones prácticas como espirituales del establecimiento de objetivos—una síntesis del énfasis del ocultismo occidental en la Voluntad y la manifestación con las filosofías orientales de acción alineada.",
    ca: "La tirada Piramidal es nodreix de tradicions esotèriques antigues que reverenciaven les estructures triangulars i piramidals com a símbols de manifestació, ascensió i proporció divina. La forma piramidal apareix en textos místics des de l'antic Egipte fins a l'alquímia renaixentista, sempre representant el viatge des de la matèria terrenal a la perfecció espiritual. Aquesta configuració particular de sis cartes va sorgir en la pràctica moderna del tarot (mitjans del segle XX) quan els lectors buscaven tirades que honressin tant les dimensions pràctiques com espirituals de l'establiment d'objectius—una síntesi de l'èmfasi de l'ocultisme occidental en la Voluntat i la manifestació amb les filosofies orientals d'acció alineada.",
  },
  positionInteractions: [
    {
      description: {
        en: "Mind ↔ Heart: The Inner Alignment",
        es: "Mente ↔ Corazón: La Alineación Interna",
        ca: "Ment ↔ Cor: L'Alineació Interna",
      },
      positions: ["MIND", "HEART"],
      aiGuidance: "These two must harmonize for manifestation to occur. If Mind is strategic (Swords, Emperor) but Heart is fearful (Five of Cups, Three of Swords), emotional work is needed. If Heart is eager (Ace of Wands, Lovers) but Mind is blocked (Eight of Swords, Moon), limiting beliefs require examination. Complementary suits (Mind=Swords, Heart=Cups) is natural. Same suit in both suggests imbalance—all head or all heart.",
    },
    {
      description: {
        en: "Goal ↔ Mind ↔ Heart: The Alignment Triangle",
        es: "Objetivo ↔ Mente ↔ Corazón: El Triángulo de Alineación",
        ca: "Objectiu ↔ Ment ↔ Cor: El Triangle d'Alineació",
      },
      positions: ["GOAL", "MIND", "HEART"],
      aiGuidance: "The upper triangle reveals whether the goal is truly aligned with the querent's authentic self. If the Goal resonates with both Mind and Heart (compatible energies, similar numerology), manifestation flows naturally. If the Goal contradicts Mind or Heart, this may be a false goal imposed by external expectations or ego. A reversed Goal with upright Mind/Heart suggests the aspiration needs reframing.",
    },
    {
      description: {
        en: "The Foundation Triad: Action → Resources → Foundation",
        es: "La Tríada Fundacional: Acción → Recursos → Fundamento",
        ca: "La Tríada Fundacional: Acció → Recursos → Fonament",
      },
      positions: ["ACTION", "RESOURCES", "FOUNDATION"],
      aiGuidance: "Read these as a sequence of practical steps. Action (left) = first move to take. Resources (center) = what you can leverage. Foundation (right) = what sustains you. If Action is clear but Resources are lacking (Five of Pentacles, Three of Swords), the querent needs to gather tools first. If Foundation is unstable (Tower, Devil), address root issues before ambitious action. Pentacles and Wands in this layer = practical, grounded approach. Too many Swords/Cups = need more tangible strategy.",
    },
    {
      description: {
        en: "Vertical Channels: Mind→Action, Heart→Resources, Goal→Foundation",
        es: "Canales Verticales: Mente→Acción, Corazón→Recursos, Objetivo→Fundamento",
        ca: "Canals Verticals: Ment→Acció, Cor→Recursos, Objectiu→Fonament",
      },
      positions: ["MIND", "ACTION", "HEART", "RESOURCES", "GOAL", "FOUNDATION"],
      aiGuidance: "Advanced reading: draw invisible lines connecting top to bottom. Does the Mind card's energy flow into the Action card? Does the Heart's desire manifest in available Resources? Does the Goal rest naturally on the Foundation, or is it built on sand? Harmonious vertical channels = aligned manifestation. Contradictions reveal where internal and external worlds clash.",
    },
    {
      description: {
        en: "The Complete Pyramid: Sacred Geometry of Manifestation",
        es: "La Pirámide Completa: Geometría Sagrada de Manifestación",
        ca: "La Piràmide Completa: Geometria Sagrada de Manifestació",
      },
      positions: ["GOAL", "MIND", "HEART", "ACTION", "RESOURCES", "FOUNDATION"],
      aiGuidance: "Step back and see the structure as a whole. Count Major Arcana to gauge spiritual significance (3+ Majors = karmic or destined goal). Notice dominant suits: Wands = passion-driven, Cups = emotion-led, Swords = intellect-focused, Pentacles = material-grounded. The apex Goal should feel supported by the five cards below—if it seems disconnected or unrealistic given the foundation, the querent may need to adjust expectations or build more groundwork. Reversed cards show areas needing healing before manifestation. The most powerful pyramids have structural integrity: each card makes sense in relation to the others.",
    },
  ],
  aiSelectionCriteria: {
    questionPatterns: [
      "how do i achieve",
      "how can i manifest",
      "reaching my goal",
      "make this happen",
      "what do i need to",
      "path to success",
      "building my dream",
      "career goal",
      "create",
      "manifest",
      "accomplish",
      "achieve my aspiration",
    ],
    emotionalStates: [
      "ambitious and goal-oriented",
      "seeking practical guidance",
      "need holistic strategy",
      "ready for manifestation work",
      "want to align mind and heart",
      "need comprehensive plan",
      "committed to taking action",
    ],
    preferWhen: {
      cardCountPreference: "5-7",
      complexityLevel: "medium",
      experienceLevel: "intermediate to advanced",
      timeframe: "goal pursuit, strategic planning, manifestation work",
    },
  },
};

/**
 * HORSESHOE SPREAD
 * Classic seven-card arc for comprehensive situation guidance
 */
const HORSESHOE_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "The Horseshoe Spread is one of tarot's most elegant and time-honored layouts, curved like a protective arc that channels good fortune and reveals the full spectrum of your situation. Reading from left to right, it traces a narrative journey from Past through Present, illuminates Hidden and External Influences most readers overlook, confronts Obstacles head-on, offers wise Advice, and culminates in the likely Outcome. The horseshoe shape itself—open side facing the querent—symbolically 'catches' cosmic guidance and protective energy. This spread doesn't just predict; it empowers you with deep situational awareness and actionable next steps.",
    es: "La Tirada Herradura es una de las disposiciones más elegantes y veneradas del tarot, curvada como un arco protector que canaliza la buena fortuna y revela el espectro completo de tu situación. Leyendo de izquierda a derecha, traza un viaje narrativo desde el Pasado a través del Presente, ilumina Influencias Ocultas y Externas que la mayoría de lectores pasan por alto, confronta los Obstáculos de frente, ofrece Consejo sabio, y culmina en el Resultado probable. La forma de herradura misma—lado abierto hacia el consultante—simbólicamente 'atrapa' guía cósmica y energía protectora. Esta tirada no solo predice; te empodera con conciencia situacional profunda y pasos accionables siguientes.",
    ca: "La Tirada Ferradura és una de les disposicions més elegants i venerades del tarot, corba com un arc protector que canalitza la bona fortuna i revela l'espectre complet de la teva situació. Llegint d'esquerra a dreta, traça un viatge narratiu des del Passat a través del Present, il·lumina Influències Ocultes i Externes que la majoria de lectors passen per alt, confronta els Obstacles de front, ofereix Consell savi, i culmina en el Resultat probable. La forma de ferradura mateixa—costat obert cap al consultant—simbòlicament 'atrapa' guia còsmica i energia protectora. Aquesta tirada no només prediu; t'apodera amb consciència situacional profunda i passos accionables següents.",
  },
  whenToUse: {
    en: "Draw the Horseshoe when you're facing a complex situation with multiple moving parts and need a comprehensive 360-degree view—not just 'what will happen' but 'what's really going on, including what I can't see.' Perfect for situations where you feel confused, where surface appearances don't match your intuition, or where you sense invisible forces (other people's agendas, hidden factors, unconscious patterns) at play. This spread excels at revealing the complete picture: career dilemmas where office politics matter, relationship dynamics with multiple influences, creative projects that feel blocked, financial decisions with many variables, or major life transitions where the path forward isn't clear. Use this when you're ready for truth and guidance, even if it challenges your assumptions. The Horseshoe works for both immediate concerns and slow-burn situations unfolding over weeks or months.",
    es: "Despliega la Herradura cuando enfrentes una situación compleja con múltiples piezas en movimiento y necesites una vista completa de 360 grados—no solo 'qué pasará' sino 'qué está realmente ocurriendo, incluyendo lo que no puedo ver.' Perfecta para situaciones donde te sientes confundida, donde las apariencias superficiales no coinciden con tu intuición, o donde percibes fuerzas invisibles (agendas de otras personas, factores ocultos, patrones inconscientes) en juego. Esta tirada sobresale revelando el panorama completo: dilemas profesionales donde la política de oficina importa, dinámicas relacionales con múltiples influencias, proyectos creativos que se sienten bloqueados, decisiones financieras con muchas variables, o transiciones vitales mayores donde el camino adelante no está claro. Úsala cuando estés lista para la verdad y la guía, incluso si desafía tus supuestos. La Herradura funciona tanto para preocupaciones inmediatas como situaciones de combustión lenta que se desarrollan durante semanas o meses.",
    ca: "Desplega la Ferradura quan enfrontis una situació complexa amb múltiples peces en moviment i necessitis una vista completa de 360 graus—no només 'què passarà' sinó 'què està realment ocorrent, incloent el que no puc veure.' Perfecta per a situacions on et sents confús, on les aparences superficials no coincideixen amb la teva intuïció, o on percebs forces invisibles (agendes d'altres persones, factors ocults, patrons inconscients) en joc. Aquesta tirada sobresurt revelant el panorama complet: dilemes professionals on la política d'oficina importa, dinàmiques relacionals amb múltiples influències, projectes creatius que es senten bloquejats, decisions financeres amb moltes variables, o transicions vitals majors on el camí endavant no està clar. Usa-la quan estiguis preparat per a la veritat i la guia, fins i tot si desafia els teus supòsits. La Ferradura funciona tant per a preocupacions immediates com situacions de combustió lenta que es desenvolupen durant setmanes o mesos.",
  },
  whenToAvoid: {
    en: "Skip the Horseshoe for simple yes/no questions, daily card pulls, or when you just want a quick vibe check. Avoid it if you're not ready to face uncomfortable truths—positions 3 (Hidden Influences) and 4 (Obstacles) can be confronting. Don't use this for comparing multiple options side-by-side (it reads ONE situation deeply, not parallel paths). Also inappropriate for beginners overwhelmed by seven-card complexity or when you need purely predictive fortune-telling without guidance.",
    es: "Omite la Herradura para preguntas simples de sí/no, tiradas de carta diaria, o cuando solo quieras un chequeo rápido de vibra. Evítala si no estás lista para enfrentar verdades incómodas—las posiciones 3 (Influencias Ocultas) y 4 (Obstáculos) pueden ser confrontantes. No la uses para comparar múltiples opciones lado a lado (lee UNA situación profundamente, no caminos paralelos). También inapropiada para principiantes abrumados por la complejidad de siete cartas o cuando necesitas adivinación puramente predictiva sin guía.",
    ca: "Omet la Ferradura per a preguntes simples de sí/no, tirades de carta diària, o quan només vulguis un xec ràpid de vibra. Evita-la si no estàs preparat per enfrontar veritats incòmodes—les posicions 3 (Influències Ocultes) i 4 (Obstacles) poden ser confrontants. No l'usis per comparar múltiples opcions costat a costat (llegeix UNA situació profundament, no camins paral·lels). També inapropiada per a principiants aclaparats per la complexitat de set cartes o quan necessites endevinació purament predictiva sense guia.",
  },
  interpretationMethod: {
    en: "Read the Horseshoe as a story unfolding from left to right, like a book. Begin with Past-Present (positions 1-2) to establish the timeline and how you arrived here—these are your context cards. Then dive into the revelation layer: Hidden Influences (position 3) exposes what's operating beneath the surface (unconscious motivations, secrets, spiritual forces, unacknowledged emotions). Obstacles (position 4) names the challenge directly—this card is your wake-up call. External Influences (position 5) shows forces beyond your control affecting the situation (other people, economic conditions, timing, luck). Now you understand the full playing field. Position 6 (Advice) is crucial—this is your guidance card, telling you how to navigate wisely. Finally, Outcome (position 7) reveals where things are headed IF current energies continue and IF you heed the advice (not set in stone, but probable trajectory). Pay special attention to the relationship between Obstacles and Advice—the Advice should directly address how to overcome or work with the obstacle. If Outcome is unfavorable, the Advice card is your key to changing course. Notice patterns: multiple Swords = mental/communication realm, multiple Cups = emotional waters, Wands = drive and conflict, Pentacles = material/practical concerns. Reversed cards often appear in Hidden Influences (repressed issues) or Obstacles (internal blocks). Court cards in External Influences usually represent specific people affecting your situation. The arc shape creates a protective container—trust that whatever the cards reveal, you're held in divine guidance.",
    es: "Lee la Herradura como una historia que se despliega de izquierda a derecha, como un libro. Comienza con Pasado-Presente (posiciones 1-2) para establecer la línea temporal y cómo llegaste aquí—estas son tus cartas de contexto. Luego sumérgete en la capa de revelación: Influencias Ocultas (posición 3) expone lo que opera bajo la superficie (motivaciones inconscientes, secretos, fuerzas espirituales, emociones no reconocidas). Obstáculos (posición 4) nombra el desafío directamente—esta carta es tu llamada de atención. Influencias Externas (posición 5) muestra fuerzas más allá de tu control que afectan la situación (otras personas, condiciones económicas, timing, suerte). Ahora entiendes el campo de juego completo. Posición 6 (Consejo) es crucial—esta es tu carta de guía, diciéndote cómo navegar sabiamente. Finalmente, Resultado (posición 7) revela hacia dónde se dirigen las cosas SI las energías actuales continúan y SI sigues el consejo (no está escrito en piedra, pero es la trayectoria probable). Presta especial atención a la relación entre Obstáculos y Consejo—el Consejo debe abordar directamente cómo superar o trabajar con el obstáculo. Si el Resultado es desfavorable, la carta de Consejo es tu clave para cambiar de rumbo. Nota patrones: múltiples Espadas = reino mental/comunicación, múltiples Copas = aguas emocionales, Bastos = impulso y conflicto, Oros = preocupaciones materiales/prácticas. Las cartas invertidas a menudo aparecen en Influencias Ocultas (problemas reprimidos) u Obstáculos (bloqueos internos). Cartas de corte en Influencias Externas usualmente representan personas específicas que afectan tu situación. La forma de arco crea un contenedor protector—confía en que lo que las cartas revelen, estás sostenida en guía divina.",
    ca: "Llegeix la Ferradura com una història que es desplega d'esquerra a dreta, com un llibre. Comença amb Passat-Present (posicions 1-2) per establir la línia temporal i com vas arribar aquí—aquestes són les teves cartes de context. Després submergeix-te en la capa de revelació: Influències Ocultes (posició 3) exposa el que opera sota la superfície (motivacions inconscients, secrets, forces espirituals, emocions no reconegudes). Obstacles (posició 4) anomena el desafiament directament—aquesta carta és la teva crida d'atenció. Influències Externes (posició 5) mostra forces més enllà del teu control que afecten la situació (altres persones, condicions econòmiques, timing, sort). Ara entens el camp de joc complet. Posició 6 (Consell) és crucial—aquesta és la teva carta de guia, dient-te com navegar sàviament. Finalment, Resultat (posició 7) revela cap a on es dirigeixen les coses SI les energies actuals continuen i SI segueixes el consell (no està escrit en pedra, però és la trajectòria probable). Presta especial atenció a la relació entre Obstacles i Consell—el Consell ha d'abordar directament com superar o treballar amb l'obstacle. Si el Resultat és desfavorable, la carta de Consell és la teva clau per canviar de rumb. Nota patrons: múltiples Espases = regne mental/comunicació, múltiples Copes = aigües emocionals, Bastos = impuls i conflicte, Oros = preocupacions materials/pràctiques. Les cartes invertides sovint apareixen en Influències Ocultes (problemes reprimits) o Obstacles (bloquejos interns). Cartes de cort en Influències Externes usualment representen persones específiques que afecten la teva situació. La forma d'arc crea un contenidor protector—confia que el que les cartes revelin, estàs sostingut en guia divina.",
  },
  traditionalOrigin: {
    en: "The Horseshoe spread descends from 19th-century European cartomancy, when seven-card layouts gained popularity for their balance of comprehensiveness and manageability. The horseshoe shape, an ancient symbol of protection and luck across cultures, was a natural fit for tarot's divinatory purposes. Some occult historians trace its structure to the seven classical planets or the seven chakras, though this may be modern retrofitting. What's certain is that by the early 20th century, the Horseshoe had become a standard in both fortune-telling parlors and serious occult practice, praised for its ability to reveal 'the whole story' while maintaining a clear narrative flow. It's endured as a classic precisely because it works—the seven-position arc covers all essential angles without overwhelming the reader.",
    es: "La tirada Herradura desciende de la cartomancia europea del siglo XIX, cuando las disposiciones de siete cartas ganaron popularidad por su equilibrio entre amplitud y manejabilidad. La forma de herradura, un símbolo antiguo de protección y suerte en todas las culturas, fue un ajuste natural para los propósitos adivinatorios del tarot. Algunos historiadores ocultistas rastrean su estructura a los siete planetas clásicos o los siete chakras, aunque esto puede ser adaptación moderna. Lo que es seguro es que para principios del siglo XX, la Herradura se había convertido en un estándar tanto en salones de adivinación como en práctica oculta seria, elogiada por su capacidad de revelar 'la historia completa' mientras mantiene un flujo narrativo claro. Ha perdurado como un clásico precisamente porque funciona—el arco de siete posiciones cubre todos los ángulos esenciales sin abrumar al lector.",
    ca: "La tirada Ferradura descendeix de la cartomància europea del segle XIX, quan les disposicions de set cartes van guanyar popularitat pel seu equilibri entre amplitud i manejabilitat. La forma de ferradura, un símbol antic de protecció i sort en totes les cultures, va ser un ajust natural per als propòsits endevinatoris del tarot. Alguns historiadors ocultistes rastreen la seva estructura als set planetes clàssics o els set chakres, tot i que això pot ser adaptació moderna. El que és segur és que per principis del segle XX, la Ferradura s'havia convertit en un estàndard tant en salons d'endevinació com en pràctica oculta seriosa, elogiada per la seva capacitat de revelar 'la història completa' mentre manté un flux narratiu clar. Ha perdurat com un clàssic precisament perquè funciona—l'arc de set posicions cobreix tots els angles essencials sense aclaparar el lector.",
  },
  positionInteractions: [
    {
      description: {
        en: "Past → Present: The Timeline Foundation",
        es: "Pasado → Presente: La Fundación Temporal",
        ca: "Passat → Present: La Fundació Temporal",
      },
      positions: ["PAST", "PRESENT"],
      aiGuidance: "These establish causality and context. Does the Past card logically lead to the Present? If harmonious (same suit, complementary energies), the querent has processed their history well. If conflicting (Ten of Cups past, Five of Pentacles present), examine what changed. Past as Major Arcana = significant karmic influence; Past as Minor = everyday events that snowballed. The Present card is the anchor—everything else relates to THIS moment.",
    },
    {
      description: {
        en: "Hidden Influences ↔ Obstacles: The Shadow Dialogue",
        es: "Influencias Ocultas ↔ Obstáculos: El Diálogo de la Sombra",
        ca: "Influències Ocultes ↔ Obstacles: El Diàleg de l'Ombra",
      },
      positions: ["HIDDEN", "OBSTACLES"],
      aiGuidance: "Often these cards are deeply connected—the hidden influence IS the obstacle, or explains WHY the obstacle exists. If Hidden Influences is Moon (fear, illusion) and Obstacles is Eight of Swords (mental prison), the obstacle is self-created through unconscious beliefs. Reversed cards here signal repression or denial. Court cards in Hidden might be people working behind the scenes (not always negatively).",
    },
    {
      description: {
        en: "Obstacles ↔ Advice: The Solution Key",
        es: "Obstáculos ↔ Consejo: La Clave de Solución",
        ca: "Obstacles ↔ Consell: La Clau de Solució",
      },
      positions: ["OBSTACLES", "ADVICE"],
      aiGuidance: "The Advice card should directly address the Obstacle—this is the reading's strategic core. If Obstacle is Tower (sudden upheaval) and Advice is Temperance (patience, integration), the guidance is to weather the storm with grace. If Advice seems disconnected from Obstacle, look deeper for the symbolic link. Strong Advice (Emperor, Strength, Star) can overcome difficult Obstacles. Weak or reversed Advice with Major Arcana Obstacles = the querent needs external support.",
    },
    {
      description: {
        en: "Advice → Outcome: The Agency Check",
        es: "Consejo → Resultado: El Chequeo de Agencia",
        ca: "Consell → Resultat: El Xec d'Agència",
      },
      positions: ["ADVICE", "OUTCOME"],
      aiGuidance: "If the Outcome resonates with the energy of the Advice, this suggests the querent will heed the guidance and manifest that result. If Outcome contradicts Advice (Advice=Temperance/moderation, Outcome=Five of Pentacles/loss), either the querent won't follow the advice or external forces will override personal choices. A positive Outcome with challenging Advice = worth the effort. A negative Outcome can be changed by following the Advice card's wisdom.",
    },
    {
      description: {
        en: "External Influences ↔ Outcome: Fate vs Free Will",
        es: "Influencias Externas ↔ Resultado: Destino vs Libre Albedrío",
        ca: "Influències Externes ↔ Resultat: Destí vs Lliure Albir",
      },
      positions: ["EXTERNAL", "OUTCOME"],
      aiGuidance: "How much does the External Influences card shape the Outcome? If they're strongly linked (same suit, similar energy), external forces are driving the result—the querent has less control. If they're disconnected, the querent's choices (Advice) matter more. Major Arcana in both positions = fated situation. Minor Arcana = more malleable circumstances.",
    },
    {
      description: {
        en: "The Complete Arc: Seven-Point Narrative",
        es: "El Arco Completo: Narrativa de Siete Puntos",
        ca: "L'Arc Complet: Narrativa de Set Punts",
      },
      positions: ["PAST", "PRESENT", "HIDDEN", "OBSTACLES", "EXTERNAL", "ADVICE", "OUTCOME"],
      aiGuidance: "Read all seven as a cohesive story. The best Horseshoe readings have clear cause-and-effect, where each card's meaning flows into the next. Count Major Arcana (3+ = significant, fated situation). Notice dominant suits (Cups = emotional focus, Swords = mental/communication, Wands = passion/conflict, Pentacles = practical/material). Reversed cards show internal or blocked energies. The arc should feel complete—like watching a film with beginning, middle, challenges, resolution, and ending. If the narrative feels disjointed, identify the gap: often it's between Obstacles and Advice, suggesting the querent doesn't yet see the solution.",
    },
  ],
  aiSelectionCriteria: {
    questionPatterns: [
      "what's really going on",
      "comprehensive guidance",
      "situation analysis",
      "what should i know about",
      "help me understand",
      "obstacles",
      "hidden influences",
      "full picture",
      "complex situation",
      "need guidance",
      "what's the outcome",
      "advice for",
    ],
    emotionalStates: [
      "seeking comprehensive understanding",
      "feeling confused or uncertain",
      "need full picture",
      "ready for truth",
      "want guidance and prediction",
      "navigating complexity",
      "need situational awareness",
    ],
    preferWhen: {
      cardCountPreference: "6-8",
      complexityLevel: "medium",
      experienceLevel: "any",
      timeframe: "weeks to months, comprehensive analysis",
    },
  },
};

/**
 * STAR SPREAD
 * Seven-point star for holistic self-discovery and spiritual dimensions
 */
const STAR_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "The Star Spread maps the seven dimensions of the human experience radiating from your Core Self like a celestial star. This isn't a reading about external events—it's a profound mirror of your inner landscape and spiritual ecosystem. Each point of the star represents a sacred aspect of life: Spirit (your connection to the divine), Abundance (material and energetic prosperity), Love (emotional fulfillment and relationships), Grounding (stability and embodiment), Creativity (self-expression and passion), Wisdom (knowledge and intuition), and at the center, Core Self (your essential truth). Together, these seven cards create a holistic snapshot of your soul's current state, revealing where you shine brightly and where you need healing or attention.",
    es: "La Tirada Estrella mapea las siete dimensiones de la experiencia humana irradiando desde tu Esencia como una estrella celestial. Esta no es una lectura sobre eventos externos—es un espejo profundo de tu paisaje interior y ecosistema espiritual. Cada punto de la estrella representa un aspecto sagrado de la vida: Espíritu (tu conexión con lo divino), Abundancia (prosperidad material y energética), Amor (satisfacción emocional y relaciones), Enraizamiento (estabilidad y encarnación), Creatividad (autoexpresión y pasión), Sabiduría (conocimiento e intuición), y en el centro, Esencia (tu verdad esencial). Juntas, estas siete cartas crean una instantánea holística del estado actual de tu alma, revelando dónde brillas intensamente y dónde necesitas sanación o atención.",
    ca: "La Tirada Estrella mapeja les set dimensions de l'experiència humana irradiant des de la teva Essència com una estrella celestial. Aquesta no és una lectura sobre esdeveniments externs—és un mirall profund del teu paisatge interior i ecosistema espiritual. Cada punt de l'estrella representa un aspecte sagrat de la vida: Esperit (la teva connexió amb el diví), Abundància (prosperitat material i energètica), Amor (satisfacció emocional i relacions), Enrellat (estabilitat i encarnació), Creativitat (autoexpressió i passió), Saviesa (coneixement i intuïció), i al centre, Essència (la teva veritat essencial). Juntes, aquestes set cartes creen una instantània holística de l'estat actual de la teva ànima, revelant on brilles intensament i on necessites sanació o atenció.",
  },
  whenToUse: {
    en: "Draw the Star when you're in a season of self-reflection, spiritual growth, or life assessment—not when you need answers about someone else or external outcomes. Perfect for major life transitions (Saturn returns, midlife passages, spiritual awakenings), New Year or birthday self-inquiry, times of confusion about identity or purpose, or when you've been so focused on doing that you've lost touch with being. Use this spread for soul inventory: 'Who am I right now? Where am I aligned? Where am I out of balance?' It's especially powerful during liminal times (between jobs, after a breakup, before a big move) when you're in the chrysalis and need to understand the transformation occurring. The Star spread works beautifully for quarterly check-ins with your spiritual practice, shadow work sessions, or whenever you need to reconnect with your wholeness.",
    es: "Despliega la Estrella cuando estés en una temporada de auto-reflexión, crecimiento espiritual o evaluación vital—no cuando necesites respuestas sobre alguien más o resultados externos. Perfecta para transiciones vitales mayores (retornos de Saturno, pasos de mediana edad, despertares espirituales), indagación de Año Nuevo o cumpleaños, tiempos de confusión sobre identidad o propósito, o cuando has estado tan enfocada en hacer que has perdido contacto con ser. Usa esta tirada para inventario del alma: '¿Quién soy ahora mismo? ¿Dónde estoy alineada? ¿Dónde estoy desequilibrada?' Es especialmente poderosa durante tiempos liminales (entre trabajos, después de una ruptura, antes de una mudanza grande) cuando estás en la crisálida y necesitas entender la transformación que ocurre. La tirada Estrella funciona bellamente para chequeos trimestrales con tu práctica espiritual, sesiones de trabajo de sombra, o cuando necesites reconectar con tu totalidad.",
    ca: "Desplega l'Estrella quan estiguis en una temporada d'auto-reflexió, creixement espiritual o avaluació vital—no quan necessitis respostes sobre algú més o resultats externs. Perfecta per a transicions vitals majors (retorns de Saturn, passos de mitjana edat, despertars espirituals), indagació de Cap d'Any o aniversari, temps de confusió sobre identitat o propòsit, o quan has estat tan enfocat en fer que has perdut contacte amb ser. Usa aquesta tirada per a inventari de l'ànima: 'Qui sóc ara mateix? On estic alineat? On estic desequilibrat?' És especialment poderosa durant temps liminals (entre feines, després d'una ruptura, abans d'un trasllat gran) quan estàs a la crisàlide i necessites entendre la transformació que ocorre. La tirada Estrella funciona bellament per a xecs trimestrals amb la teva pràctica espiritual, sessions de treball d'ombra, o quan necessitis reconnectar amb la teva totalitat.",
  },
  whenToAvoid: {
    en: "Skip the Star for questions about specific events, other people's choices, timing, or practical decisions. This isn't the spread for 'should I take this job?' or 'when will I meet my soulmate?'—it's internal, not external. Avoid if you're looking for quick answers or fortune-telling rather than deep self-inquiry. Also not suitable when you're in acute crisis and need immediate practical guidance (use Horseshoe or Five Card Cross instead). The Star requires contemplative space and emotional readiness to see yourself fully.",
    es: "Omite la Estrella para preguntas sobre eventos específicos, elecciones de otras personas, timing, o decisiones prácticas. Esta no es la tirada para '¿debería tomar este trabajo?' o '¿cuándo conoceré a mi alma gemela?'—es interna, no externa. Evita si buscas respuestas rápidas o adivinación en lugar de indagación profunda. Tampoco es adecuada cuando estás en crisis aguda y necesitas guía práctica inmediata (usa Herradura o Cruz de Cinco Cartas en su lugar). La Estrella requiere espacio contemplativo y preparación emocional para verte completamente.",
    ca: "Omet l'Estrella per a preguntes sobre esdeveniments específics, eleccions d'altres persones, timing, o decisions pràctiques. Aquesta no és la tirada per a 'hauria de prendre aquesta feina?' o 'quan trobaré la meva ànima bessona?'—és interna, no externa. Evita si busques respostes ràpides o endevinació en lloc d'indagació profunda. Tampoc és adequada quan estàs en crisi aguda i necessites guia pràctica immediata (usa Ferradura o Creu de Cinc Cartes en el seu lloc). L'Estrella requereix espai contemplatiu i preparació emocional per veure't completament.",
  },
  interpretationMethod: {
    en: "Begin at the center: the Core Self card is your anchor, revealing your essential nature right now (not who you were or will be, but who you ARE). If it's a Major Arcana, you're embodying a powerful archetype. If reversed, you're disconnected from your truth. Now read the six outer points in any order that feels intuitive (clockwise from top, or by jumping to cards that call you). Spirit (top) shows your current relationship with the divine/universe/higher self—are you connected or cut off? Abundance (upper right) reveals your prosperity consciousness and material reality. Love (lower right) exposes your heart's state—emotional fulfillment, relationships, capacity to give and receive love. Grounding (bottom) shows your rootedness, physical health, sense of safety. Creativity (lower left) illuminates self-expression, passion projects, life force energy. Wisdom (upper left) reflects your knowledge, intuition, and mental clarity. Look for balance: Are some points shining (upright Majors, positive Minors) while others struggle (reversed cards, challenging suits)? Ideally, all seven should feel interconnected—the star shape suggests that each dimension affects the others. If one point is drastically out of sync (Ten of Swords in Love while everything else is positive), that's where healing work is needed. Major Arcana in multiple points = you're in a spiritually significant phase. All Minor Arcana = everyday human experience, less fated. Notice if the Core Self card resonates with the outer points—if the center is Sun but all outer cards are dark (Tower, Five of Pentacles, etc.), there's a disconnect between inner light and outer expression. The star itself is a mandala—step back and feel the overall energy. Does it glow with vitality or does it feel dim and contracted?",
    es: "Comienza en el centro: la carta de Esencia es tu ancla, revelando tu naturaleza esencial ahora mismo (no quién eras o serás, sino quién ERES). Si es un Arcano Mayor, estás encarnando un arquetipo poderoso. Si está invertida, estás desconectada de tu verdad. Ahora lee los seis puntos exteriores en cualquier orden que se sienta intuitivo (en sentido horario desde arriba, o saltando a cartas que te llamen). Espíritu (arriba) muestra tu relación actual con lo divino/universo/ser superior—¿estás conectada o aislada? Abundancia (arriba a la derecha) revela tu conciencia de prosperidad y realidad material. Amor (abajo a la derecha) expone el estado de tu corazón—satisfacción emocional, relaciones, capacidad de dar y recibir amor. Enraizamiento (abajo) muestra tu arraigo, salud física, sentido de seguridad. Creatividad (abajo a la izquierda) ilumina autoexpresión, proyectos de pasión, energía de fuerza vital. Sabiduría (arriba a la izquierda) refleja tu conocimiento, intuición y claridad mental. Busca equilibrio: ¿Algunos puntos brillan (Mayores derechos, Menores positivos) mientras otros luchan (cartas invertidas, palos desafiantes)? Idealmente, los siete deben sentirse interconectados—la forma de estrella sugiere que cada dimensión afecta a las otras. Si un punto está drásticamente fuera de sincronía (Diez de Espadas en Amor mientras todo lo demás es positivo), ahí es donde se necesita trabajo de sanación. Arcanos Mayores en múltiples puntos = estás en una fase espiritualmente significativa. Todos Arcanos Menores = experiencia humana cotidiana, menos destinada. Observa si la carta de Esencia resuena con los puntos exteriores—si el centro es Sol pero todas las cartas exteriores son oscuras (Torre, Cinco de Oros, etc.), hay desconexión entre luz interior y expresión exterior. La estrella misma es un mandala—retrocede y siente la energía general. ¿Brilla con vitalidad o se siente tenue y contraída?",
    ca: "Comença al centre: la carta d'Essència és la teva àncora, revelant la teva naturalesa essencial ara mateix (no qui eres o seràs, sinó qui ETS). Si és un Arcà Major, estàs encarnant un arquetip poderós. Si està invertida, estàs desconnectat de la teva veritat. Ara llegeix els sis punts exteriors en qualsevol ordre que se senti intuïtiu (en sentit horari des de dalt, o saltant a cartes que et cridin). Esperit (a dalt) mostra la teva relació actual amb el diví/univers/ser superior—estàs connectat o aïllat? Abundància (a dalt a la dreta) revela la teva consciència de prosperitat i realitat material. Amor (a baix a la dreta) exposa l'estat del teu cor—satisfacció emocional, relacions, capacitat de donar i rebre amor. Enrellat (a baix) mostra el teu arrelament, salut física, sentit de seguretat. Creativitat (a baix a l'esquerra) il·lumina autoexpressió, projectes de passió, energia de força vital. Saviesa (a dalt a l'esquerra) reflecteix el teu coneixement, intuïció i claredat mental. Busca equilibri: Alguns punts brillen (Majors rectes, Menors positius) mentre altres lluiten (cartes invertides, pals desafiants)? Idealment, els set han de sentir-se interconnectats—la forma d'estrella suggereix que cada dimensió afecta les altres. Si un punt està dràsticament fora de sincronia (Deu d'Espases en Amor mentre tot la resta és positiu), aquí és on es necessita treball de sanació. Arcans Majors en múltiples punts = estàs en una fase espiritualment significativa. Tots Arcans Menors = experiència humana quotidiana, menys destinada. Observa si la carta d'Essència ressona amb els punts exteriors—si el centre és Sol però totes les cartes exteriors són fosques (Torre, Cinc d'Oros, etc.), hi ha desconnexió entre llum interior i expressió exterior. L'estrella mateixa és un mandala—retrocedeix i sent l'energia general. Brilla amb vitalitat o se sent tènue i contreta?",
  },
  traditionalOrigin: {
    en: "The seven-pointed star (heptagram) carries deep esoteric significance across mystical traditions—from the seven classical planets in astrology to the seven chakras in Eastern philosophy, the seven days of creation in Abrahamic faiths, and the seven virtues in medieval Christianity. The Star spread as a tarot layout emerged in late 20th-century New Age tarot practice, developed by readers seeking a spread that honored the wholeness of human experience beyond problem-solving. It represents a shift from divination as prediction toward divination as self-knowledge—reflecting modern tarot's evolution into a tool for psychological and spiritual insight.",
    es: "La estrella de siete puntas (heptagrama) lleva un significado esotérico profundo en tradiciones místicas—desde los siete planetas clásicos en astrología hasta los siete chakras en filosofía oriental, los siete días de creación en las fes abrahamicas, y las siete virtudes en el cristianismo medieval. La tirada Estrella como disposición de tarot surgió en la práctica del tarot de la Nueva Era de finales del siglo XX, desarrollada por lectores que buscaban una tirada que honrara la totalidad de la experiencia humana más allá de la resolución de problemas. Representa un cambio de la adivinación como predicción hacia la adivinación como autoconocimiento—reflejando la evolución del tarot moderno hacia una herramienta de percepción psicológica y espiritual.",
    ca: "L'estrella de set puntes (heptàgram) porta un significat esotèric profund en tradicions místiques—des dels set planetes clàssics en astrologia fins als set chakres en filosofia oriental, els set dies de creació en les fes abrahamiques, i les set virtuts en el cristianisme medieval. La tirada Estrella com a disposició de tarot va sorgir en la pràctica del tarot de la Nova Era de finals del segle XX, desenvolupada per lectors que buscaven una tirada que honorés la totalitat de l'experiència humana més enllà de la resolució de problemes. Representa un canvi de l'endevinació com a predicció cap a l'endevinació com a autoconeixement—reflectint l'evolució del tarot modern cap a una eina de percepció psicològica i espiritual.",
  },
  positionInteractions: [
    {
      description: {
        en: "Core Self → All Points: The Radiating Center",
        es: "Esencia → Todos los Puntos: El Centro Radiante",
        ca: "Essència → Tots els Punts: El Centre Radiant",
      },
      positions: ["CORE_SELF", "SPIRIT", "ABUNDANCE", "LOVE", "GROUNDING", "CREATIVITY", "WISDOM"],
      aiGuidance: "The Core Self card is the sun at the center of this solar system—all other cards should relate back to it. If Core Self is Empress (nurturing, creative feminine) but Creativity is Five of Wands (blocked, frustrated), there's a disconnect between essence and expression. If Core Self and all outer points are harmonious (similar suits, complementary energies), the querent is living authentically. Major Arcana in Core Self = strong sense of self; Minor = more fluid identity; Court card = identifying with a role rather than true self.",
    },
    {
      description: {
        en: "Spirit ↔ Wisdom: The Divine-Knowledge Axis",
        es: "Espíritu ↔ Sabiduría: El Eje Divino-Conocimiento",
        ca: "Esperit ↔ Saviesa: L'Eix Diví-Coneixement",
      },
      positions: ["SPIRIT", "WISDOM"],
      aiGuidance: "These two represent the upper realm—transcendent connection (Spirit) and integrated knowledge (Wisdom). Ideally they work together: Spirit provides intuitive downloads, Wisdom processes and applies them. If Spirit is strong (Star, High Priestess) but Wisdom is weak (Moon, Seven of Cups), the querent receives guidance but can't discern truth. If Wisdom is sharp (Ace of Swords, Magician) but Spirit is blocked (Five of Pentacles, reversed Hierophant), the querent is brilliant but spiritually disconnected.",
    },
    {
      description: {
        en: "Abundance ↔ Grounding: The Material World Axis",
        es: "Abundancia ↔ Enraizamiento: El Eje del Mundo Material",
        ca: "Abundància ↔ Enrellat: L'Eix del Món Material",
      },
      positions: ["ABUNDANCE", "GROUNDING"],
      aiGuidance: "These govern earthly reality. Abundance (upper right) is flow and prosperity; Grounding (bottom) is stability and embodiment. If Abundance is lush (Empress, Nine/Ten of Pentacles) but Grounding is unstable (Tower, Five of Pentacles), resources are flowing but not being rooted—money comes and goes. If Grounding is solid (Four of Wands, Emperor) but Abundance is lacking (Five of Pentacles, Eight of Swords), the querent is stable but not expanding. Both strong = material mastery.",
    },
    {
      description: {
        en: "Love ↔ Creativity: The Heart-Passion Channel",
        es: "Amor ↔ Creatividad: El Canal Corazón-Pasión",
        ca: "Amor ↔ Creativitat: El Canal Cor-Passió",
      },
      positions: ["LOVE", "CREATIVITY"],
      aiGuidance: "These are the fire and water of the soul—emotional fulfillment (Love) and expressive passion (Creativity). When both are vibrant (Two of Cups, Three of Wands), the querent is emotionally nourished and creatively alive. If Love is full but Creativity is blocked (Ten of Cups + Five of Wands), contentment has led to stagnation. If Creativity is wild but Love is empty (Ace of Wands + Three of Swords), passion burns without emotional support. Reversed cards here suggest repressed emotions or unexpressed gifts.",
    },
    {
      description: {
        en: "The Whole Star: Seven Sacred Dimensions",
        es: "La Estrella Completa: Siete Dimensiones Sagradas",
        ca: "L'Estrella Completa: Set Dimensions Sagrades",
      },
      positions: ["SPIRIT", "ABUNDANCE", "LOVE", "GROUNDING", "CREATIVITY", "WISDOM", "CORE_SELF"],
      aiGuidance: "Zoom out to see the mandala as a unified whole. The star should feel balanced—not all points need to be perfect, but there should be overall harmony. Count the suits: Cups-heavy = emotional/intuitive life, Swords-heavy = mental/intellectual focus, Wands-heavy = passionate/driven nature, Pentacles-heavy = grounded/practical orientation. Major Arcana count: 0-1 = everyday human experience, 2-3 = spiritually significant time, 4+ = major soul transformation underway. Look for patterns: All upright = authenticity and alignment. Multiple reversals = areas needing shadow work. The most powerful Star readings reveal a coherent self-portrait—this is who you are, in all your complexity and beauty.",
    },
  ],
  aiSelectionCriteria: {
    questionPatterns: [
      "who am i",
      "self-discovery",
      "spiritual growth",
      "where am i in my life",
      "soul journey",
      "check-in with myself",
      "personal assessment",
      "spiritual state",
      "inner landscape",
      "self-reflection",
      "life review",
      "wholeness",
    ],
    emotionalStates: [
      "seeking self-knowledge",
      "spiritual exploration",
      "need inner clarity",
      "life transition",
      "soul-searching",
      "reconnecting with self",
      "contemplative mood",
    ],
    preferWhen: {
      cardCountPreference: "6-8",
      complexityLevel: "medium",
      experienceLevel: "intermediate to advanced",
      timeframe: "present state, ongoing spiritual journey",
    },
  },
};

/**
 * CELTIC CROSS SPREAD
 * The master 10-card spread - most iconic and comprehensive in tarot
 */
const CELTIC_CROSS_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "The Celtic Cross is the undisputed master of tarot spreads—the most iconic, comprehensive, and deeply layered layout in the entire cartomantic tradition. First codified by Arthur Edward Waite and the Golden Dawn in the early 20th century, this ten-card masterpiece weaves together temporal progression (past-present-future), spatial awareness (internal-external), and psychological depth (conscious-unconscious) into a unified tapestry of insight. It examines not just 'what will happen' but the complete existential landscape: where you've been, where you are, what crosses you, what crowns and grounds you, what lies ahead, how you see yourself, how others see you, what you secretly hope and fear, and ultimately, where all roads lead. This is the spread you turn to when a situation demands the full power of the tarot's wisdom—when nothing less than complete understanding will suffice.",
    es: "La Cruz Celta es la indiscutida maestra de las tiradas de tarot—la disposición más icónica, completa y profundamente estratificada de toda la tradición cartomántica. Codificada por primera vez por Arthur Edward Waite y la Golden Dawn a principios del siglo XX, esta obra maestra de diez cartas entrelaza progresión temporal (pasado-presente-futuro), conciencia espacial (interno-externo) y profundidad psicológica (consciente-inconsciente) en un tapiz unificado de percepción. Examina no solo 'qué pasará' sino el paisaje existencial completo: de dónde vienes, dónde estás, qué te atraviesa, qué te corona y arraiga, qué yace adelante, cómo te ves a ti misma, cómo te ven los demás, qué esperas y temes secretamente, y en última instancia, hacia dónde conducen todos los caminos. Esta es la tirada a la que recurres cuando una situación demanda el poder completo de la sabiduría del tarot—cuando nada menos que comprensión completa será suficiente.",
    ca: "La Creu Cèltica és la mestra indiscutible de les tirades de tarot—la disposició més icònica, completa i profundament estratificada de tota la tradició cartomàntica. Codificada per primera vegada per Arthur Edward Waite i la Golden Dawn a principis del segle XX, aquesta obra mestra de deu cartes entrellaça progressió temporal (passat-present-futur), consciència espacial (intern-extern) i profunditat psicològica (conscient-inconscient) en un tapís unificat de percepció. Examina no només 'què passarà' sinó el paisatge existencial complet: d'on véns, on ets, què et travessa, què et corona i arrela, què jeu endavant, com et veus a tu mateix, com et veuen els altres, què esperes i tems secretament, i en última instància, cap a on condueixen tots els camins. Aquesta és la tirada a la qual recorres quan una situació demanda el poder complet de la saviesa del tarot—quan res menys que comprensió completa serà suficient.",
  },
  whenToUse: {
    en: "Deploy the Celtic Cross for life's most significant questions and complex situations—the kind that keep you awake at night, that have multiple layers, that require seeing the whole chessboard before making your move. Perfect for major life decisions (career changes, relationship commitments, relocations, spiritual awakenings), situations with long histories and uncertain futures, times when you need to understand not just the external facts but your own psychology around the issue. Use this spread when simpler layouts feel insufficient, when you sense there are hidden dimensions you're not seeing, or when you're willing to invest the time and contemplation that ten cards demand. The Celtic Cross excels at revealing the 'why' behind the 'what'—not just predicting outcomes but illuminating the forces, patterns, and choices that create those outcomes. Ideal for quarterly life reviews, before major commitments, during dark nights of the soul, or whenever you need the tarot's full diagnostic and prognostic power. This is advanced work—respect the spread's depth.",
    es: "Despliega la Cruz Celta para las preguntas más significativas de la vida y situaciones complejas—del tipo que te mantienen despierta por la noche, que tienen múltiples capas, que requieren ver todo el tablero de ajedrez antes de hacer tu movimiento. Perfecta para decisiones vitales mayores (cambios de carrera, compromisos relacionales, mudanzas, despertares espirituales), situaciones con largas historias y futuros inciertos, momentos en que necesitas entender no solo los hechos externos sino tu propia psicología en torno al tema. Usa esta tirada cuando disposiciones más simples se sientan insuficientes, cuando percibas que hay dimensiones ocultas que no estás viendo, o cuando estés dispuesta a invertir el tiempo y contemplación que diez cartas demandan. La Cruz Celta sobresale revelando el 'por qué' detrás del 'qué'—no solo prediciendo resultados sino iluminando las fuerzas, patrones y elecciones que crean esos resultados. Ideal para revisiones de vida trimestrales, antes de compromisos mayores, durante noches oscuras del alma, o cuando necesites el poder diagnóstico y pronóstico completo del tarot. Este es trabajo avanzado—respeta la profundidad de la tirada.",
    ca: "Desplega la Creu Cèltica per a les preguntes més significatives de la vida i situacions complexes—del tipus que et mantenen despert per la nit, que tenen múltiples capes, que requereixen veure tot el tauler d'escacs abans de fer el teu moviment. Perfecta per a decisions vitals majors (canvis de carrera, compromisos relacionals, mudances, despertars espirituals), situacions amb llargues històries i futurs incerts, moments en què necessites entendre no només els fets externs sinó la teva pròpia psicologia entorn del tema. Usa aquesta tirada quan disposicions més simples se sentin insuficients, quan percebs que hi ha dimensions ocultes que no estàs veient, o quan estiguis disposat a invertir el temps i contemplació que deu cartes demanen. La Creu Cèltica sobresurt revelant el 'per què' darrere del 'què'—no només predint resultats sinó il·luminant les forces, patrons i eleccions que creen aquests resultats. Ideal per a revisions de vida trimestrals, abans de compromisos majors, durant nits fosques de l'ànima, o quan necessitis el poder diagnòstic i pronòstic complet del tarot. Aquest és treball avançat—respecta la profunditat de la tirada.",
  },
  whenToAvoid: {
    en: "Skip the Celtic Cross for simple questions, daily guidance, or when you want a quick answer—this spread demands time, focus, and interpretive skill. Avoid it if you're a complete beginner (start with Three Card or Five Card Cross first). Don't use it for trivial matters or when you're too emotionally overwhelmed to process ten cards' worth of information. Also inappropriate when you need immediate triage rather than deep analysis, or when the question is narrow and specific (use a targeted spread instead). The Celtic Cross can feel overwhelming if you're not ready for its complexity or if the situation doesn't warrant such thorough examination.",
    es: "Omite la Cruz Celta para preguntas simples, guía diaria, o cuando quieras una respuesta rápida—esta tirada demanda tiempo, enfoque y habilidad interpretativa. Evítala si eres completamente principiante (empieza con Tres Cartas o Cruz de Cinco Cartas primero). No la uses para asuntos triviales o cuando estés demasiado abrumada emocionalmente para procesar diez cartas de información. También inapropiada cuando necesitas triaje inmediato en lugar de análisis profundo, o cuando la pregunta es estrecha y específica (usa una tirada específica en su lugar). La Cruz Celta puede sentirse abrumadora si no estás lista para su complejidad o si la situación no justifica un examen tan exhaustivo.",
    ca: "Omet la Creu Cèltica per a preguntes simples, guia diària, o quan vulguis una resposta ràpida—aquesta tirada demanda temps, enfocament i habilitat interpretativa. Evita-la si ets completament principiant (comença amb Tres Cartes o Creu de Cinc Cartes primer). No l'usis per a assumptes trivials o quan estiguis massa aclaparat emocionalment per processar deu cartes d'informació. També inapropiada quan necessites triatge immediat en lloc d'anàlisi profunda, o quan la pregunta és estreta i específica (usa una tirada específica en el seu lloc). La Creu Cèltica pot sentir-se aclaparadora si no estàs preparat per a la seva complexitat o si la situació no justifica un examen tan exhaustiu.",
  },
  interpretationMethod: {
    en: "Read the Celtic Cross in structural layers, not just linearly. **Layer 1: The Cross (positions 1-6)** forms the heart. Start with the Present (1) and Challenge (2) together—the Challenge literally crosses the Present, showing what opposes or complicates your current situation. If Challenge is reversed, the obstacle is internal; upright, it's external. Now read the temporal axis: Distant Past (3, below) → Present (1, center) → Near Future (6, right) traces the timeline. Recent Past (4, above) shows what's just passed. Goal (5, left) reveals the best possible outcome or deeper aspiration. The cross creates a mandala of the situation's core. **Layer 2: The Staff (positions 7-10)** stands to the right like a pillar, showing the querent's relationship to the situation. Read bottom to top: Self (7) = how you see yourself; Environment (8) = how others/circumstances see you; Hopes & Fears (9) = your secret emotional truth (often paradoxical—you may fear what you hope for); Outcome (10) = where everything leads. The Staff is psychological X-ray. **Key Interactions:** Present ↔ Challenge (the core conflict), Distant Past → Recent Past → Present (causal chain), Goal ↔ Outcome (alignment check: does what you want match where you're headed?), Self ↔ Environment (internal vs external perception), Hopes & Fears ↔ Outcome (do your fears create the outcome, or do your hopes?). **Advanced Reading:** Count Major Arcana across all 10 (0-3 = everyday situation, 4-6 = significant life event, 7+ = fated/spiritual crisis). Note dominant suits. Look for 'dialogues' between cards (e.g., if Challenge is Five of Pentacles and Environment is Ten of Cups, others see success while you struggle). The Challenge card is often the key—if you can resolve or accept what crosses you, the path clears. If Goal and Outcome align, you're on track. If they conflict, course correction is needed. The Celtic Cross should tell one cohesive story when all 10 cards are synthesized—if it feels scattered, look for the hidden thread connecting them.",
    es: "Lee la Cruz Celta en capas estructurales, no solo linealmente. **Capa 1: La Cruz (posiciones 1-6)** forma el corazón. Comienza con el Presente (1) y el Desafío (2) juntos—el Desafío literalmente cruza el Presente, mostrando qué se opone o complica tu situación actual. Si el Desafío está invertido, el obstáculo es interno; derecho, es externo. Ahora lee el eje temporal: Pasado Lejano (3, abajo) → Presente (1, centro) → Futuro Próximo (6, derecha) traza la línea temporal. Pasado Reciente (4, arriba) muestra lo que acaba de pasar. Objetivo (5, izquierda) revela el mejor resultado posible o aspiración más profunda. La cruz crea un mandala del núcleo de la situación. **Capa 2: El Bastón (posiciones 7-10)** está a la derecha como un pilar, mostrando la relación del consultante con la situación. Lee de abajo hacia arriba: Yo (7) = cómo te ves a ti misma; Entorno (8) = cómo te ven otros/circunstancias; Esperanzas y Miedos (9) = tu verdad emocional secreta (a menudo paradójica—puedes temer lo que esperas); Resultado (10) = hacia dónde conduce todo. El Bastón es radiografía psicológica. **Interacciones Clave:** Presente ↔ Desafío (el conflicto central), Pasado Lejano → Pasado Reciente → Presente (cadena causal), Objetivo ↔ Resultado (verificación de alineación: ¿lo que quieres coincide con hacia dónde te diriges?), Yo ↔ Entorno (percepción interna vs externa), Esperanzas y Miedos ↔ Resultado (¿tus miedos crean el resultado, o tus esperanzas?). **Lectura Avanzada:** Cuenta Arcanos Mayores en los 10 (0-3 = situación cotidiana, 4-6 = evento vital significativo, 7+ = crisis destinada/espiritual). Nota palos dominantes. Busca 'diálogos' entre cartas (ej., si Desafío es Cinco de Oros y Entorno es Diez de Copas, otros ven éxito mientras tú luchas). La carta de Desafío es a menudo la clave—si puedes resolver o aceptar lo que te cruza, el camino se despeja. Si Objetivo y Resultado se alinean, estás en el camino correcto. Si entran en conflicto, se necesita corrección de curso. La Cruz Celta debe contar una historia cohesiva cuando las 10 cartas se sintetizan—si se siente dispersa, busca el hilo oculto que las conecta.",
    ca: "Llegeix la Creu Cèltica en capes estructurals, no només linealment. **Capa 1: La Creu (posicions 1-6)** forma el cor. Comença amb el Present (1) i el Desafiament (2) junts—el Desafiament literalment creua el Present, mostrant què s'oposa o complica la teva situació actual. Si el Desafiament està invertit, l'obstacle és intern; recte, és extern. Ara llegeix l'eix temporal: Passat Llunyà (3, a baix) → Present (1, centre) → Futur Proper (6, dreta) traça la línia temporal. Passat Recent (4, a dalt) mostra el que acaba de passar. Objectiu (5, esquerra) revela el millor resultat possible o aspiració més profunda. La creu crea un mandala del nucli de la situació. **Capa 2: El Bastó (posicions 7-10)** està a la dreta com un pilar, mostrant la relació del consultant amb la situació. Llegeix de baix cap a dalt: Jo (7) = com et veus a tu mateix; Entorn (8) = com et veuen altres/circumstàncies; Esperances i Pors (9) = la teva veritat emocional secreta (sovint paradoxal—pots témer el que esperes); Resultat (10) = cap a on condueix tot. El Bastó és radiografia psicològica. **Interaccions Clau:** Present ↔ Desafiament (el conflicte central), Passat Llunyà → Passat Recent → Present (cadena causal), Objectiu ↔ Resultat (verificació d'alineació: el que vols coincideix amb cap a on et dirigeixes?), Jo ↔ Entorn (percepció interna vs externa), Esperances i Pors ↔ Resultat (les teves pors creen el resultat, o les teves esperances?). **Lectura Avançada:** Compta Arcans Majors en els 10 (0-3 = situació quotidiana, 4-6 = esdeveniment vital significatiu, 7+ = crisi destinada/espiritual). Nota pals dominants. Busca 'diàlegs' entre cartes (ex., si Desafiament és Cinc d'Oros i Entorn és Deu de Copes, altres veuen èxit mentre tu lluites). La carta de Desafiament és sovint la clau—si pots resoldre o acceptar el que et creua, el camí es desemmascara. Si Objectiu i Resultat s'alineen, estàs en el camí correcte. Si entren en conflicte, es necessita correcció de curs. La Creu Cèltica ha de comptar una història cohesiva quan les 10 cartes es sintetitzen—si se sent dispersa, busca el fil ocult que les connecta.",
  },
  traditionalOrigin: {
    en: "The Celtic Cross as we know it was popularized by Arthur Edward Waite in his seminal 1910 book *The Pictorial Key to the Tarot*, though its exact origins remain debated among occult historians. The Golden Dawn (late 19th century) used a similar 10-card cross layout, and some trace elements back to even older cartomantic traditions. The name 'Celtic' likely references the cross's resemblance to Celtic stone crosses found in Ireland and Scotland, imbuing it with mystical gravitas. What's indisputable is that by the early 20th century, this spread had become *the* definitive tarot layout—the one taught in every serious occult school, the one professional readers mastered, the one that appeared in countless films and novels as the iconic image of tarot divination. Its endurance stems from its brilliance: the cross structure mirrors both Christian symbolism (accessible to Western audiences) and pre-Christian mandalas (appealing to esotericists), while the 10 positions cover every essential dimension of human experience. It's survived a century because it works—consistently, profoundly, undeniably.",
    es: "La Cruz Celta tal como la conocemos fue popularizada por Arthur Edward Waite en su libro seminal de 1910 *The Pictorial Key to the Tarot*, aunque sus orígenes exactos permanecen debatidos entre historiadores ocultistas. La Golden Dawn (finales del siglo XIX) usaba una disposición de cruz de 10 cartas similar, y algunos rastrean elementos a tradiciones cartománticas aún más antiguas. El nombre 'Celta' probablemente hace referencia a la semejanza de la cruz con las cruces de piedra celtas encontradas en Irlanda y Escocia, imbuíéndola con gravitas místico. Lo indiscutible es que para principios del siglo XX, esta tirada se había convertido en *la* disposición de tarot definitiva—la que se enseñaba en cada escuela oculta seria, la que los lectores profesionales dominaban, la que apareció en incontables películas y novelas como la imagen icónica de la adivinación del tarot. Su perdurabilidad proviene de su brillantez: la estructura de cruz refleja tanto el simbolismo cristiano (accesible a audiencias occidentales) como mandalas pre-cristianos (atractivos para esotéricos), mientras que las 10 posiciones cubren cada dimensión esencial de la experiencia humana. Ha sobrevivido un siglo porque funciona—consistentemente, profundamente, innegablemente.",
    ca: "La Creu Cèltica tal com la coneixem va ser popularitzada per Arthur Edward Waite en el seu llibre seminal de 1910 *The Pictorial Key to the Tarot*, tot i que els seus orígens exactes romanen debatuts entre historiadors ocultistes. La Golden Dawn (finals del segle XIX) usava una disposició de creu de 10 cartes similar, i alguns rastreen elements a tradicions cartomàntiques encara més antigues. El nom 'Celta' probablement fa referència a la semblança de la creu amb les creus de pedra celtes trobades a Irlanda i Escòcia, imbuint-la amb gravitas místic. L'indiscutible és que per principis del segle XX, aquesta tirada s'havia convertit en *la* disposició de tarot definitiva—la que s'ensenyava en cada escola oculta seriosa, la que els lectors professionals dominaven, la que va aparèixer en innombrables pel·lícules i novel·les com la imatge icònica de l'endevinació del tarot. La seva perdurabilitat prové de la seva brillantor: l'estructura de creu reflecteix tant el simbolisme cristià (accessible a audiències occidentals) com mandalas pre-cristians (atractius per a esotèrics), mentre que les 10 posicions cobreixen cada dimensió essencial de l'experiència humana. Ha sobreviscut un segle perquè funciona—consistentment, profundament, innegablement.",
  },
  positionInteractions: [
    {
      description: {
        en: "Present ↔ Challenge: The Core Conflict - What you face vs what crosses it",
        es: "Presente ↔ Desafío: El Conflicto Central - Lo que enfrentas vs lo que lo cruza",
        ca: "Present ↔ Desafiament: El Conflicte Central - El que enfronte vs el que el creua",
      },
      positions: ["PRESENT", "CHALLENGE"],
      aiGuidance: "This is the heart of the reading. The Challenge literally crosses the Present—it's the obstacle, complication, or opposing force. If they're harmonious (complementary suits/energies), the challenge is actually an opportunity. If conflicting (Tower crosses Ten of Cups), there's real tension. Reversed Challenge = internal block; upright = external. Major Arcana Challenge = significant, possibly fated obstacle. The Challenge shows what must be worked with or through to move forward.",
    },
    {
      description: {
        en: "Distant Past → Recent Past → Present: The Causal Timeline",
        es: "Pasado Lejano → Pasado Reciente → Presente: La Línea Temporal Causal",
        ca: "Passat Llunyà → Passat Recent → Present: La Línia Temporal Causal",
      },
      positions: ["DISTANT_PAST", "RECENT_PAST", "PRESENT"],
      aiGuidance: "Read these as a causal chain showing how you got here. Distant Past = root cause, foundation, sometimes childhood or years ago. Recent Past = what just happened (days to months). Present = now. If the Distant Past is a Major Arcana, this situation has deep roots or karmic significance. If Recent Past directly leads to Present (logical progression), there's clear causality. If they seem disconnected, something's being overlooked.",
    },
    {
      description: {
        en: "Present → Near Future: The Immediate Trajectory",
        es: "Presente → Futuro Próximo: La Trayectoria Inmediata",
        ca: "Present → Futur Proper: La Trajectòria Immediata",
      },
      positions: ["PRESENT", "NEAR_FUTURE"],
      aiGuidance: "Near Future shows what's coming soon (days to weeks) if current energies continue. If Present and Near Future are harmonious, momentum is positive. If they contrast sharply (positive Present, challenging Near Future), prepare for a shift. This is NOT the final outcome (that's position 10), just the next chapter. Use this to anticipate and prepare.",
    },
    {
      description: {
        en: "Goal ↔ Outcome: The Aspiration vs Reality Check",
        es: "Objetivo ↔ Resultado: La Aspiración vs Verificación de Realidad",
        ca: "Objectiu ↔ Resultat: L'Aspiració vs Verificació de Realitat",
      },
      positions: ["GOAL", "OUTCOME"],
      aiGuidance: "Goal = best possible outcome or deeper aspiration (sometimes unconscious). Outcome = where you're actually headed. If they align (same suit, complementary energy), you're on track. If they conflict, course correction is needed—what you want and where you're going don't match. If Goal is challenging but Outcome is positive, you'll exceed expectations. If Goal is positive but Outcome is dark, the path needs redirection.",
    },
    {
      description: {
        en: "Self ↔ Environment: Internal vs External Perception",
        es: "Yo ↔ Entorno: Percepción Interna vs Externa",
        ca: "Jo ↔ Entorn: Percepció Interna vs Externa",
      },
      positions: ["SELF", "ENVIRONMENT"],
      aiGuidance: "Self = how you see yourself in this situation. Environment = how others/circumstances see you. If they align, there's honesty and clarity. If they conflict (you see yourself as Hermit, others see you as Three of Swords), there's a perception gap. Court cards here often show roles being played. Reversed cards suggest denial or distortion. This reveals authenticity vs facade.",
    },
    {
      description: {
        en: "Hopes & Fears ↔ Outcome: The Psychological Wildcard",
        es: "Esperanzas y Miedos ↔ Resultado: El Comodín Psicológico",
        ca: "Esperances i Pors ↔ Resultat: El Comodí Psicològic",
      },
      positions: ["HOPES_FEARS", "OUTCOME"],
      aiGuidance: "Hopes & Fears is the most psychologically complex position—it holds what you secretly hope for AND what you secretly fear, often intertwined (you fear what you hope for, or hope for what you fear). If this card resonates with the Outcome, your unconscious is creating your reality (for better or worse). If Hopes & Fears is the same as Challenge, you're your own obstacle. This is shadow work territory—bring what's hidden into light.",
    },
    {
      description: {
        en: "The Complete Cross: 10-Card Symphonic Reading",
        es: "La Cruz Completa: Lectura Sinfónica de 10 Cartas",
        ca: "La Creu Completa: Lectura Simfònica de 10 Cartes",
      },
      positions: ["PRESENT", "CHALLENGE", "DISTANT_PAST", "RECENT_PAST", "GOAL", "NEAR_FUTURE", "SELF", "ENVIRONMENT", "HOPES_FEARS", "OUTCOME"],
      aiGuidance: "Synthesize all 10 cards into one cohesive narrative. The cross (1-6) shows the situation's objective landscape. The staff (7-10) shows your subjective relationship to it. Count Major Arcana (high count = fated/significant). Note dominant suits (Cups = emotional, Swords = mental, Wands = active, Pentacles = material). Look for repeated themes or numbers. The Challenge often holds the key to everything. If Goal and Outcome align, the path is clear. If Self and Environment align, you're authentic. If Hopes & Fears mirrors the Outcome, the unconscious is steering. The Celtic Cross at its best tells an undeniable story—past trauma (Distant Past) led to recent crisis (Recent Past) creating current struggle (Present) complicated by fear (Challenge) but with hope ahead (Near Future) if you can claim your power (Self) despite judgment (Environment) and transcend your shadow (Hopes & Fears) to reach destiny (Outcome). Read it as poetry, not prose.",
    },
  ],
  aiSelectionCriteria: {
    questionPatterns: [
      "comprehensive analysis",
      "major life decision",
      "complex situation",
      "need complete understanding",
      "everything about",
      "deep insight",
      "master spread",
      "full reading",
      "complex question",
      "life-changing",
      "big picture",
      "thorough analysis",
    ],
    emotionalStates: [
      "facing major decision",
      "need deep understanding",
      "complex situation",
      "ready for full insight",
      "major life crossroads",
      "seeking comprehensive guidance",
      "prepared for depth work",
    ],
    preferWhen: {
      cardCountPreference: "8-10",
      complexityLevel: "complex",
      experienceLevel: "advanced",
      timeframe: "comprehensive - past, present, and future",
    },
  },
};

/**
 * ═══════════════════════════════════════════════════════════════════════════
 * 10. ASTROLOGICAL HOUSES - Extended 12-Card Spread
 * ═══════════════════════════════════════════════════════════════════════════
 *
 * Ancient synthesis of tarot and astrology mapping life's 12 domains
 * through the timeless wheel of houses
 */
const ASTROLOGICAL_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "The Astrological Houses spread is an ancient synthesis of tarot and astrology—a 12-card cosmic blueprint that maps every dimension of your life through the timeless wheel of the zodiac's houses. Each position corresponds to one of the 12 astrological houses, revealing how cosmic energies manifest in different life areas from identity to career to spirituality. This is astrology through the tarot lens—holistic, comprehensive, and deeply illuminating.",
    es: "La tirada de las Casas Astrológicas es una síntesis ancestral de tarot y astrología—un plano cósmico de 12 cartas que mapea cada dimensión de tu vida a través de la rueda intemporal de las casas zodiacales. Cada posición corresponde a una de las 12 casas astrológicas, revelando cómo las energías cósmicas se manifiestan en diferentes áreas vitales desde la identidad hasta la carrera hasta la espiritualidad. Esto es astrología a través de la lente del tarot—holística, comprehensiva y profundamente iluminadora.",
    ca: "La tirada de les Cases Astrològiques és una síntesi ancestral de tarot i astrologia—un plànol còsmic de 12 cartes que mapeja cada dimensió de la teva vida a través de la roda intemporal de les cases zodiacals. Cada posició correspon a una de les 12 cases astrològiques, revelant com les energies còsmiques es manifesten en diferents àrees vitals des de la identitat fins a la carrera fins a l'espiritualitat. Això és astrologia a través de la lent del tarot—holística, comprehensiva i profundament il·luminadora.",
  },
  whenToUse: {
    en: "Deploy the Astrological Houses for comprehensive life assessments, annual reviews (birthdays, New Year, solar returns), major life transitions, spiritual mapping, or when you need to see ALL areas of life in one integrated reading. Perfect for 'what's happening in my life overall?' questions, for understanding how different life domains interact, for astrology enthusiasts wanting tarot perspective on their natal chart themes, or for annual planning sessions where you want cosmic guidance across all 12 houses. Particularly powerful during astrological milestones (Saturn returns, Jupiter transits, eclipses) or when seeking a holistic snapshot of your current life landscape.",
    es: "Despliega las Casas Astrológicas para evaluaciones de vida comprehensivas, revisiones anuales (cumpleaños, Año Nuevo, retornos solares), transiciones vitales importantes, mapeo espiritual, o cuando necesitas ver TODAS las áreas de la vida en una lectura integrada. Perfecta para preguntas de '¿qué está pasando en mi vida en general?', para entender cómo interactúan diferentes dominios vitales, para entusiastas de la astrología que quieren perspectiva tarot sobre los temas de su carta natal, o para sesiones de planificación anual donde quieres orientación cósmica a través de las 12 casas. Particularmente poderosa durante hitos astrológicos (retornos de Saturno, tránsitos de Júpiter, eclipses) o cuando buscas una instantánea holística de tu paisaje vital actual.",
    ca: "Desplega les Cases Astrològiques per a avaluacions de vida comprehensives, revisions anuals (aniversaris, Any Nou, retorns solars), transicions vitals importants, mapeig espiritual, o quan necessites veure TOTES les àrees de la vida en una lectura integrada. Perfecta per a preguntes de 'què està passant a la meva vida en general?', per entendre com interactuen diferents dominis vitals, per a entusiastes de l'astrologia que volen perspectiva tarot sobre els temes de la seva carta natal, o per a sessions de planificació anual on vols orientació còsmica a través de les 12 cases. Particularment poderosa durant fites astrològiques (retorns de Saturn, trànsits de Júpiter, eclipsis) o quan busques una instantània holística del teu paisatge vital actual.",
  },
  whenToAvoid: {
    en: "Skip the Astrological Houses for single-issue questions ('should I take this job?'), quick daily guidance, simple yes/no decisions, urgent matters requiring immediate clarity, or when the querent is unfamiliar with astrological concepts and would find 12 house positions overwhelming or confusing. Also avoid for querents seeking rapid answers or those new to tarot who might feel lost in 12 distinct life areas. Not ideal for relationship-only questions (use Relationship spread instead) or timeline-focused queries (use Year Ahead). This spread requires time, astrological literacy, and readiness for comprehensive insight.",
    es: "Evita las Casas Astrológicas para preguntas de un solo tema ('¿debería aceptar este trabajo?'), orientación diaria rápida, decisiones simples de sí/no, asuntos urgentes que requieren claridad inmediata, o cuando el consultante no está familiarizado con conceptos astrológicos y encontraría las 12 posiciones de casas abrumadoras o confusas. También evita para consultantes que buscan respuestas rápidas o principiantes en tarot que podrían sentirse perdidos en 12 áreas vitales distintas. No es ideal para preguntas únicamente de relaciones (usa la tirada de Relación en su lugar) o consultas enfocadas en cronología (usa Año Por Delante). Esta tirada requiere tiempo, alfabetización astrológica y disposición para perspectiva comprehensiva.",
    ca: "Evita les Cases Astrològiques per a preguntes d'un sol tema ('hauria d'acceptar aquesta feina?'), orientació diària ràpida, decisions simples de sí/no, assumptes urgents que requereixen claredat immediata, o quan el consultant no està familiaritzat amb conceptes astrològics i trobaria les 12 posicions de cases aclaparadores o confuses. També evita per a consultants que busquen respostes ràpides o principiants en tarot que podrien sentir-se perduts en 12 àrees vitals distintes. No és ideal per a preguntes únicament de relacions (usa la tirada de Relació en el seu lloc) o consultes enfocades en cronologia (usa Any Endavant). Aquesta tirada requereix temps, alfabetització astrològica i disposició per a perspectiva comprehensiva.",
  },
  interpretationMethod: {
    en: "Read the Astrological Houses as a cosmic clock, starting at 1st House (9 o'clock position) and moving counterclockwise through all 12 houses, just as astrologers read a natal chart. **Begin with personal houses (1-6)** which govern your immediate life and inner world: 1st (identity/appearance), 2nd (money/values), 3rd (communication/learning), 4th (home/roots), 5th (creativity/pleasure), 6th (health/work). **Then move to interpersonal houses (7-12)** which govern relationships and spiritual evolution: 7th (partnerships), 8th (transformation/shared resources), 9th (philosophy/travel), 10th (career/reputation), 11th (community/aspirations), 12th (spirituality/unconscious). Look for **house themes**: which houses have Major Arcana (fated areas), which have Court cards (people influencing those areas), which suits dominate (element emphasis). Notice **angular houses** (1st, 4th, 7th, 10th) as power points—these are your life's cardinal directions. The 1st and 7th form an axis (self vs others), as do 4th and 10th (private vs public). Read these oppositions for balance. Finally, synthesize: What's the overall story? Which life areas are thriving (upright positive cards) vs struggling (reversed or challenging cards)? Where is growth needed?",
    es: "Lee las Casas Astrológicas como un reloj cósmico, comenzando en la 1ª Casa (posición 9 en punto) y moviéndote en sentido antihorario a través de las 12 casas, tal como los astrólogos leen una carta natal. **Comienza con las casas personales (1-6)** que gobiernan tu vida inmediata y mundo interior: 1ª (identidad/apariencia), 2ª (dinero/valores), 3ª (comunicación/aprendizaje), 4ª (hogar/raíces), 5ª (creatividad/placer), 6ª (salud/trabajo). **Luego muévete a las casas interpersonales (7-12)** que gobiernan las relaciones y evolución espiritual: 7ª (parejas), 8ª (transformación/recursos compartidos), 9ª (filosofía/viajes), 10ª (carrera/reputación), 11ª (comunidad/aspiraciones), 12ª (espiritualidad/inconsciente). Busca **temas de casas**: qué casas tienen Arcanos Mayores (áreas predestinadas), qué tienen Figuras (personas que influyen en esas áreas), qué palos dominan (énfasis elemental). Nota las **casas angulares** (1ª, 4ª, 7ª, 10ª) como puntos de poder—estas son las direcciones cardinales de tu vida. La 1ª y 7ª forman un eje (yo vs otros), al igual que la 4ª y 10ª (privado vs público). Lee estas oposiciones para equilibrio. Finalmente, sintetiza: ¿Cuál es la historia general? ¿Qué áreas vitales prosperan (cartas positivas al derecho) vs luchan (invertidas o desafiantes)? ¿Dónde se necesita crecimiento?",
    ca: "Llegeix les Cases Astrològiques com un rellotge còsmic, començant a la 1a Casa (posició 9 en punt) i movent-te en sentit antihorari a través de les 12 cases, tal com els astròlegs llegeixen una carta natal. **Comença amb les cases personals (1-6)** que governen la teva vida immediata i món interior: 1a (identitat/aparença), 2a (diners/valors), 3a (comunicació/aprenentatge), 4a (llar/arrels), 5a (creativitat/plaer), 6a (salut/treball). **Després mou-te a les cases interpersonals (7-12)** que governen les relacions i evolució espiritual: 7a (parelles), 8a (transformació/recursos compartits), 9a (filosofia/viatges), 10a (carrera/reputació), 11a (comunitat/aspiracions), 12a (espiritualitat/inconscient). Busca **temes de cases**: quines cases tenen Arcans Majors (àrees predestinades), quines tenen Figures (persones que influeixen en aquestes àrees), quins pals dominen (èmfasi elemental). Nota les **cases angulars** (1a, 4a, 7a, 10a) com a punts de poder—aquestes són les direccions cardinals de la teva vida. La 1a i 7a formen un eix (jo vs altres), igual que la 4a i 10a (privat vs públic). Llegeix aquestes oposicions per equilibri. Finalment, sintetitza: Quina és la història general? Quines àrees vitals prosperen (cartes positives al dret) vs lluiten (invertides o desafiants)? On es necessita creixement?",
  },
  traditionalOrigin: {
    en: "The Astrological Houses spread emerged in the late 19th and early 20th centuries as tarot practitioners began integrating astrology and tarot—two parallel divinatory systems both rooted in Hermetic and Neoplatonic philosophy. The 12-house system itself dates to Hellenistic astrology (2nd century BCE), systematized by Claudius Ptolemy in the *Tetrabiblos*. Each house represents a life domain: the 1st House (Ascendant) is the self, the 10th (Midheaven) is public life, etc. By the Golden Dawn era (1888-1900), esotericists like A.E. Waite and Aleister Crowley were explicitly linking tarot cards to astrological correspondences (e.g., The Emperor to Aries, The Moon to Pisces). The Astrological Houses spread takes this synthesis to its logical conclusion: using 12 tarot cards to illuminate the 12 houses, creating a 'tarot natal chart' that shows not your birth potentials but your current life energies across all domains. It's a modern spread built on ancient foundations—popular among astrologers who read tarot and tarotists who study astrology.",
    es: "La tirada de las Casas Astrológicas surgió a finales del siglo XIX y principios del XX cuando los practicantes de tarot comenzaron a integrar astrología y tarot—dos sistemas adivinatorios paralelos arraigados en la filosofía hermética y neoplatónica. El sistema de 12 casas data de la astrología helenística (siglo II a.C.), sistematizado por Claudio Ptolomeo en el *Tetrabiblos*. Cada casa representa un dominio vital: la 1ª Casa (Ascendente) es el yo, la 10ª (Medio Cielo) es la vida pública, etc. Para la era Golden Dawn (1888-1900), esoteristas como A.E. Waite y Aleister Crowley vinculaban explícitamente cartas de tarot con correspondencias astrológicas (ej. El Emperador con Aries, La Luna con Piscis). La tirada de Casas Astrológicas lleva esta síntesis a su conclusión lógica: usando 12 cartas de tarot para iluminar las 12 casas, creando una 'carta natal tarot' que muestra no tus potenciales de nacimiento sino tus energías vitales actuales en todos los dominios. Es una tirada moderna construida sobre fundamentos ancestrales—popular entre astrólogos que leen tarot y tarotistas que estudian astrología.",
    ca: "La tirada de les Cases Astrològiques va sorgir a finals del segle XIX i principis del XX quan els practicants de tarot van començar a integrar astrologia i tarot—dos sistemes endivinatoris paral·lels arrelats en la filosofia hermètica i neoplatònica. El sistema de 12 cases data de l'astrologia hel·lenística (segle II aC), sistematitzat per Claudi Ptolemeu al *Tetrabiblos*. Cada casa representa un domini vital: la 1a Casa (Ascendent) és el jo, la 10a (Mig Cel) és la vida pública, etc. Per l'era Golden Dawn (1888-1900), esoteristes com A.E. Waite i Aleister Crowley vinculaven explícitament cartes de tarot amb correspondències astrològiques (ex. L'Emperador amb Àries, La Lluna amb Peixos). La tirada de Cases Astrològiques porta aquesta síntesi a la seva conclusió lògica: usant 12 cartes de tarot per il·luminar les 12 cases, creant una 'carta natal tarot' que mostra no els teus potencials de naixement sinó les teves energies vitals actuals en tots els dominis. És una tirada moderna construïda sobre fonaments ancestrals—popular entre astròlegs que llegeixen tarot i tarotistes que estudien astrologia.",
  },
  positionInteractions: [
    {
      description: {
        en: "1st House ↔ 7th House: Self vs Partnership - The balance between individuality and relationship",
        es: "1ª Casa ↔ 7ª Casa: Yo vs Pareja - El equilibrio entre individualidad y relación",
        ca: "1a Casa ↔ 7a Casa: Jo vs Parella - L'equilibri entre individualitat i relació",
      },
      positions: ["HOUSE_1", "HOUSE_7"],
      aiGuidance: "This is the fundamental axis of identity. The 1st House shows how the querent sees themselves and presents to the world (the Ascendant in astrology). The 7th House shows what they seek in partnerships and how they relate to others (the Descendant). These houses mirror each other. If the 1st is strong (Major Arcana, Court cards, Aces) but the 7th is weak or reversed, the querent may struggle to maintain identity in relationships. If both are balanced, there's healthy autonomy AND connection. Look for what the 1st projects vs what the 7th attracts—often they're complementary (e.g., Strength in 1st, Two of Cups in 7th = self-assured person attracting harmonious partnership).",
    },
    {
      description: {
        en: "4th House ↔ 10th House: Private vs Public - The tension between home life and career ambition",
        es: "4ª Casa ↔ 10ª Casa: Privado vs Público - La tensión entre vida hogareña y ambición profesional",
        ca: "4a Casa ↔ 10a Casa: Privat vs Públic - La tensió entre vida domèstica i ambició professional",
      },
      positions: ["HOUSE_4", "HOUSE_10"],
      aiGuidance: "This is the axis of foundation and achievement. The 4th House (IC) represents home, family, emotional roots, the private self. The 10th House (MC) represents career, reputation, public image, worldly success. These are often in tension—time devoted to career detracts from home and vice versa. If the 4th is challenged (Tower, Five of Pentacles reversed, difficult cards) while the 10th is strong, success may come at the cost of personal life. If the 4th is nurturing (Empress, Ten of Cups) but the 10th is stagnant (Four of Cups, Eight of Pentacles reversed), they may be too comfortable at home to pursue ambition. Ideal: both houses supported, indicating work-life balance.",
    },
    {
      description: {
        en: "2nd House → 8th House: Personal Resources → Shared Transformation - How individual values evolve through deep connections",
        es: "2ª Casa → 8ª Casa: Recursos Personales → Transformación Compartida - Cómo los valores individuales evolucionan a través de conexiones profundas",
        ca: "2a Casa → 8a Casa: Recursos Personals → Transformació Compartida - Com els valors individuals evolucionen a través de connexions profundes",
      },
      positions: ["HOUSE_2", "HOUSE_8"],
      aiGuidance: "The 2nd and 8th Houses both deal with resources, but differently. The 2nd is YOUR money, values, self-worth, what you earn and own. The 8th is SHARED resources, inheritance, taxes, partner's money, transformation through intimacy, death/rebirth. The 2nd → 8th flow shows how personal wealth becomes entangled with others (marriage, business partnerships, inheritance). If 2nd is abundant (Ace of Pentacles, Ten of Pentacles) but 8th is difficult (Five of Swords, Seven of Swords), beware of financial exploitation or power struggles over money. If both are strong, there's prosperity through collaboration. The 8th can also transform 2nd House values—what you value alone shifts when deeply connected to another.",
    },
    {
      description: {
        en: "Angular Houses (1st, 4th, 7th, 10th): The Four Cardinal Points - Major life structures and turning points",
        es: "Casas Angulares (1ª, 4ª, 7ª, 10ª): Los Cuatro Puntos Cardinales - Estructuras vitales mayores y puntos de inflexión",
        ca: "Cases Angulars (1a, 4a, 7a, 10a): Els Quatre Punts Cardinals - Estructures vitals majors i punts d'inflexió",
      },
      positions: ["HOUSE_1", "HOUSE_4", "HOUSE_7", "HOUSE_10"],
      aiGuidance: "The angular houses are the most powerful in astrology—they mark the four angles of the chart (Ascendant, IC, Descendant, MC). In this spread, they represent the four pillars of life: Self (1st), Home (4th), Partnership (7th), Career (10th). Count Major Arcana in these positions—high count indicates a life defined by fate and significant events in these areas. If all four are upright and positive, the querent's foundational life structures are solid. If multiple are reversed or challenging (Tower, Five of Pentacles, Ten of Swords), major life restructuring is underway or needed. These houses set the tone—if they're strong, the querent can weather challenges in other houses.",
    },
    {
      description: {
        en: "Succedent Houses (2nd, 5th, 8th, 11th): Resource Accumulation and Creative Expression - How we build and share value",
        es: "Casas Sucedentes (2ª, 5ª, 8ª, 11ª): Acumulación de Recursos y Expresión Creativa - Cómo construimos y compartimos valor",
        ca: "Cases Succedents (2a, 5a, 8a, 11a): Acumulació de Recursos i Expressió Creativa - Com construïm i compartim valor",
      },
      positions: ["HOUSE_2", "HOUSE_5", "HOUSE_8", "HOUSE_11"],
      aiGuidance: "Succedent houses follow angular houses and represent what we build and accumulate: 2nd (personal wealth), 5th (creative output/children/joy), 8th (shared transformation/intimacy), 11th (social networks/future vision). These show how the querent creates value and legacy. If succedent houses are strong with Pentacles (material building), Wands (creative fire), or Cups (emotional fulfillment), the querent is in a productive, generative phase. If weak or reversed, they may struggle to build or sustain. The 5th and 11th are particularly important for creatives and visionaries—5th is personal creative joy, 11th is collective creative impact.",
    },
    {
      description: {
        en: "Cadent Houses (3rd, 6th, 9th, 12th): Learning, Service, and Spiritual Growth - The journey of wisdom and transcendence",
        es: "Casas Cadentes (3ª, 6ª, 9ª, 12ª): Aprendizaje, Servicio y Crecimiento Espiritual - El viaje de sabiduría y trascendencia",
        ca: "Cases Cadents (3a, 6a, 9a, 12a): Aprenentatge, Servei i Creixement Espiritual - El viatge de saviesa i transcendència",
      },
      positions: ["HOUSE_3", "HOUSE_6", "HOUSE_9", "HOUSE_12"],
      aiGuidance: "Cadent houses represent preparation, learning, and evolution: 3rd (communication/education), 6th (daily work/health/service), 9th (higher learning/philosophy/travel), 12th (spirituality/unconscious/transcendence). These are the 'background' houses—less visible than angular but essential for growth. If cadent houses are strong with Swords (mental clarity) or Major Arcana (spiritual lessons), the querent is in a learning/healing phase. The 3rd → 6th → 9th → 12th progression is a journey from basic skills to daily practice to higher wisdom to spiritual surrender. The 12th House is especially potent—it reveals hidden influences, karmic patterns, and what must be released or transcended. If the 12th has reversed cards or the Moon/Hanged Man, unconscious blocks need attention.",
  },
  ],
  aiSelectionCriteria: {
    questionPatterns: [
      "what's happening in my life",
      "comprehensive life assessment",
      "annual review",
      "all areas of life",
      "holistic reading",
      "life overview",
      "astrological spread",
      "houses",
      "cosmic guidance",
      "life domains",
      "major life review",
      "comprehensive snapshot",
      "yearly forecast for all areas",
      "complete life picture",
    ],
    emotionalStates: [
      "seeking comprehensive understanding",
      "annual reflection time",
      "major life transition",
      "needing holistic perspective",
      "astrologically curious",
      "birthday or New Year reflection",
      "ready for in-depth life review",
    ],
    preferWhen: {
      cardCountPreference: "10-12",
      complexityLevel: "extended",
      experienceLevel: "intermediate to advanced",
      timeframe: "comprehensive present snapshot across all life areas",
    },
  },
};

/**
 * ═══════════════════════════════════════════════════════════════════════════
 * 11. YEAR AHEAD - Extended 12-Card Monthly Forecast Spread
 * ═══════════════════════════════════════════════════════════════════════════
 *
 * Ancient tradition of monthly divination mapping the year's journey
 * through 12 cards representing 12 months
 */
const YEAR_AHEAD_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "The Year Ahead spread is a beloved annual ritual—a 12-card roadmap that illuminates the coming year month by month, revealing the themes, challenges, and opportunities each month holds. Unlike the Astrological Houses which map life areas, the Year Ahead maps TIME, offering a chronological forecast from January through December (or from your current month forward). Each card becomes a monthly compass, a preview of energies to embrace or obstacles to prepare for. This is tarot as temporal prophecy—practical, forward-looking, and deeply empowering for planning and manifestation.",
    es: "La tirada del Año Por Delante es un ritual anual amado—un mapa de 12 cartas que ilumina el año venidero mes a mes, revelando los temas, desafíos y oportunidades que cada mes contiene. A diferencia de las Casas Astrológicas que mapean áreas vitales, el Año Por Delante mapea el TIEMPO, ofreciendo un pronóstico cronológico de enero a diciembre (o desde tu mes actual en adelante). Cada carta se convierte en una brújula mensual, una vista previa de las energías a abrazar o los obstáculos para los que prepararse. Esto es tarot como profecía temporal—práctica, orientada al futuro y profundamente empoderante para planificación y manifestación.",
    ca: "La tirada de l'Any Endavant és un ritual anual estimat—un mapa de 12 cartes que il·lumina l'any vinent mes a mes, revelant els temes, desafiaments i oportunitats que cada mes conté. A diferència de les Cases Astrològiques que mapegen àrees vitals, l'Any Endavant mapeja el TEMPS, oferint un pronòstic cronològic de gener a desembre (o des del teu mes actual endavant). Cada carta es converteix en una brúixola mensual, una previsualització de les energies a abraçar o els obstacles per als quals preparar-se. Això és tarot com a profecia temporal—pràctica, orientada al futur i profundament empoderadora per a planificació i manifestació.",
  },
  whenToUse: {
    en: "Deploy the Year Ahead at natural transition points—New Year's Day, birthdays, solar returns, the start of a new astrological year (Aries season), or any moment you're ready to look forward and plan intentionally. Perfect for goal-setting sessions, annual planning, when you want to know 'what does this year hold for me?', for identifying the best timing for major initiatives (which month to launch a project, travel, focus on relationships), or for spiritual preparation (knowing challenging months in advance allows for readiness). Especially powerful combined with journaling—revisit each month's card as that month arrives to reflect on accuracy and adjust course. Ideal for those who love foresight, planning, and working WITH time rather than against it.",
    es: "Despliega el Año Por Delante en puntos de transición naturales—Día de Año Nuevo, cumpleaños, retornos solares, el inicio de un nuevo año astrológico (temporada de Aries), o cualquier momento en que estés listo para mirar hacia adelante y planificar intencionalmente. Perfecta para sesiones de establecimiento de metas, planificación anual, cuando quieres saber '¿qué me depara este año?', para identificar el mejor momento para iniciativas mayores (qué mes lanzar un proyecto, viajar, enfocarse en relaciones), o para preparación espiritual (conocer meses desafiantes con anticipación permite estar listo). Especialmente poderosa combinada con diario—revisita la carta de cada mes cuando ese mes llega para reflexionar sobre precisión y ajustar el rumbo. Ideal para quienes aman la previsión, la planificación y trabajar CON el tiempo en lugar de contra él.",
    ca: "Desplega l'Any Endavant en punts de transició naturals—Dia d'Any Nou, aniversaris, retorns solars, l'inici d'un nou any astrològic (temporada d'Àries), o qualsevol moment en què estiguis preparat per mirar endavant i planificar intencionalment. Perfecta per a sessions d'establiment d'objectius, planificació anual, quan vols saber 'què m'ofereix aquest any?', per identificar el millor moment per a iniciatives majors (quin mes llançar un projecte, viatjar, enfocar-se en relacions), o per a preparació espiritual (conèixer mesos desafiants amb anticipació permet estar preparat). Especialment poderosa combinada amb diari—revisita la carta de cada mes quan aquest mes arriba per reflexionar sobre precisió i ajustar el rumb. Ideal per a aquells que estimen la previsió, la planificació i treballar AMB el temps en lloc de contra ell.",
  },
  whenToAvoid: {
    en: "Skip the Year Ahead for immediate questions needing quick answers, for querents who find forecasts anxiety-inducing (some people prefer present-focused readings), for simple yes/no decisions, or when you're seeking guidance about a specific issue rather than an overall yearly preview. Avoid if the querent is new to tarot and might misinterpret a challenging card (e.g., The Tower in August) as doom rather than growth opportunity. Not suitable for relationship-specific questions (use Relationship spread) or career-only queries (use Celtic Cross or single-domain spreads). This spread requires trust in timing, readiness to plan long-term, and emotional maturity to receive both positive and challenging monthly forecasts without panic.",
    es: "Evita el Año Por Delante para preguntas inmediatas que necesitan respuestas rápidas, para consultantes que encuentran los pronósticos generadores de ansiedad (algunas personas prefieren lecturas enfocadas en el presente), para decisiones simples de sí/no, o cuando buscas orientación sobre un tema específico en lugar de una vista previa anual general. Evita si el consultante es nuevo en tarot y podría malinterpretar una carta desafiante (p. ej., La Torre en agosto) como condenación en lugar de oportunidad de crecimiento. No es adecuada para preguntas específicas de relaciones (usa la tirada de Relación) o consultas solo de carrera (usa Cruz Celta o tiradas de un solo dominio). Esta tirada requiere confianza en el tiempo, disposición para planificar a largo plazo y madurez emocional para recibir pronósticos mensuales tanto positivos como desafiantes sin pánico.",
    ca: "Evita l'Any Endavant per a preguntes immediates que necessiten respostes ràpides, per a consultants que troben els pronòstics generadors d'ansietat (algunes persones prefereixen lectures enfocades en el present), per a decisions simples de sí/no, o quan busques orientació sobre un tema específic en lloc d'una previsualització anual general. Evita si el consultant és nou en tarot i podria malinterpretar una carta desafiant (p. ex., La Torre a l'agost) com a condemna en lloc d'oportunitat de creixement. No és adequada per a preguntes específiques de relacions (usa la tirada de Relació) o consultes només de carrera (usa Creu Cèltica o tirades d'un sol domini). Aquesta tirada requereix confiança en el temps, disposició per planificar a llarg termini i maduresa emocional per rebre pronòstics mensuals tant positius com desafiants sense pànic.",
  },
  interpretationMethod: {
    en: "Read the Year Ahead as a narrative arc—a 12-chapter story with each month as a chapter. **Start with Position 1 (January or current month)** and read sequentially through Position 12 (December or 12 months forward). Each card reveals that month's PRIMARY ENERGY: What theme will dominate? What challenges or opportunities arise? For example, The Chariot in April suggests a month of decisive action and momentum, while The Hanged Man in July indicates a pause for reflection. **Look for patterns across months**: Do certain suits cluster (e.g., lots of Cups in spring = emotional/relational focus)? Are there multiple Major Arcana (significant karmic months)? Do reversed cards concentrate in certain seasons (difficult period)? Notice **the flow**: How does one month lead to the next? A Three of Swords in February (heartbreak) might flow into the Four of Cups in March (withdrawal) then the Star in April (healing hope). **Mark significant months** with Major Arcana, Aces (new beginnings), or Tens (completions) as power months for planning. Finally, synthesize the year's overall theme: Is it a year of building (Pentacles), creativity (Wands), relationships (Cups), or mental clarity (Swords)? Use this spread to plan accordingly—schedule big projects in strong months, practice self-care in challenging ones.",
    es: "Lee el Año Por Delante como un arco narrativo—una historia de 12 capítulos con cada mes como un capítulo. **Comienza con la Posición 1 (enero o mes actual)** y lee secuencialmente hasta la Posición 12 (diciembre o 12 meses hacia adelante). Cada carta revela la ENERGÍA PRIMARIA de ese mes: ¿Qué tema dominará? ¿Qué desafíos u oportunidades surgen? Por ejemplo, El Carro en abril sugiere un mes de acción decisiva y momentum, mientras que El Colgado en julio indica una pausa para reflexión. **Busca patrones a través de los meses**: ¿Se agrupan ciertos palos (p. ej., muchas Copas en primavera = enfoque emocional/relacional)? ¿Hay múltiples Arcanos Mayores (meses kármicos significativos)? ¿Se concentran cartas invertidas en ciertas estaciones (período difícil)? Nota **el flujo**: ¿Cómo lleva un mes al siguiente? Un Tres de Espadas en febrero (desamor) podría fluir al Cuatro de Copas en marzo (retraimiento) luego la Estrella en abril (esperanza sanadora). **Marca meses significativos** con Arcanos Mayores, Ases (nuevos comienzos) o Dieces (completaciones) como meses de poder para planificar. Finalmente, sintetiza el tema general del año: ¿Es un año de construcción (Oros), creatividad (Bastos), relaciones (Copas) o claridad mental (Espadas)? Usa esta tirada para planificar en consecuencia—programa grandes proyectos en meses fuertes, practica autocuidado en los desafiantes.",
    ca: "Llegeix l'Any Endavant com un arc narratiu—una història de 12 capítols amb cada mes com un capítol. **Comença amb la Posició 1 (gener o mes actual)** i llegeix seqüencialment fins a la Posició 12 (desembre o 12 mesos endavant). Cada carta revela l'ENERGIA PRIMÀRIA d'aquest mes: Quin tema dominarà? Quins desafiaments o oportunitats sorgeixen? Per exemple, El Carro a l'abril suggereix un mes d'acció decisiva i momentum, mentre que El Penjat al juliol indica una pausa per a reflexió. **Busca patrons a través dels mesos**: S'agrupen certs pals (p. ex., moltes Copes a la primavera = enfocament emocional/relacional)? Hi ha múltiples Arcans Majors (mesos kàrmics significatius)? Es concentren cartes invertides en certes estacions (període difícil)? Nota **el flux**: Com porta un mes al següent? Un Tres d'Espases al febrer (desamor) podria fluir al Quatre de Copes al març (retraïment) després l'Estrella a l'abril (esperança sanadora). **Marca mesos significatius** amb Arcans Majors, Asos (nous començaments) o Deus (completacions) com a mesos de poder per planificar. Finalment, sintetitza el tema general de l'any: És un any de construcció (Ors), creativitat (Bastons), relacions (Copes) o claredat mental (Espases)? Usa aquesta tirada per planificar en conseqüència—programa grans projectes en mesos forts, practica autocura en els desafiants.",
  },
  traditionalOrigin: {
    en: "The Year Ahead spread is a modern iteration of an ancient practice: monthly divination for forecasting the year. Historical records show that Renaissance cartomancers (15th-17th centuries) would draw cards on New Year's Day or at the winter solstice to divine the year's fortunes, often assigning one card per month. This practice parallels agricultural almanacs and astrological ephemerides that guided farmers and rulers in timing planting, harvests, and decisions. The 12-month structure mirrors both the 12 zodiac signs and the 12 lunar cycles, connecting tarot to natural and cosmic rhythms. By the 19th and 20th centuries, as tarot became more systematized for divination (thanks to Etteilla, Éliphas Lévi, and the Golden Dawn), the Year Ahead solidified as a standard spread for annual readings. Today it's a staple of professional tarot practice, offered widely around New Year's and birthdays as a 'roadmap reading.' Its enduring popularity stems from its practical utility—people want to know what's coming so they can prepare, plan, and align with time's flow.",
    es: "La tirada del Año Por Delante es una iteración moderna de una práctica ancestral: adivinación mensual para pronosticar el año. Los registros históricos muestran que los cartománticos renacentistas (siglos XV-XVII) sacaban cartas el Día de Año Nuevo o en el solsticio de invierno para adivinar las fortunas del año, asignando a menudo una carta por mes. Esta práctica paralela a los almanaques agrícolas y las efemérides astrológicas que guiaban a agricultores y gobernantes en el momento de plantar, cosechar y tomar decisiones. La estructura de 12 meses refleja tanto los 12 signos zodiacales como los 12 ciclos lunares, conectando el tarot con ritmos naturales y cósmicos. Para los siglos XIX y XX, cuando el tarot se sistematizó más para adivinación (gracias a Etteilla, Éliphas Lévi y la Golden Dawn), el Año Por Delante se solidificó como tirada estándar para lecturas anuales. Hoy es un pilar de la práctica profesional del tarot, ofrecida ampliamente en Año Nuevo y cumpleaños como 'lectura de hoja de ruta'. Su popularidad duradera proviene de su utilidad práctica—la gente quiere saber qué viene para prepararse, planificar y alinearse con el flujo del tiempo.",
    ca: "La tirada de l'Any Endavant és una iteració moderna d'una pràctica ancestral: endevinació mensual per pronosticar l'any. Els registres històrics mostren que els cartomàntics renaixentistes (segles XV-XVII) trèien cartes el Dia d'Any Nou o al solstici d'hivern per endevinar les fortunes de l'any, assignant sovint una carta per mes. Aquesta pràctica paral·lela als almanacs agrícoles i les efemèrides astrològiques que guiaven agricultors i governants en el moment de plantar, collir i prendre decisions. L'estructura de 12 mesos reflecteix tant els 12 signes zodiacals com els 12 cicles lunars, connectant el tarot amb ritmes naturals i còsmics. Per als segles XIX i XX, quan el tarot es va sistematitzar més per a endevinació (gràcies a Etteilla, Éliphas Lévi i la Golden Dawn), l'Any Endavant es va solidificar com a tirada estàndard per a lectures anuals. Avui és un pilar de la pràctica professional del tarot, oferida àmpliament a Any Nou i aniversaris com a 'lectura de full de ruta'. La seva popularitat duradora prové de la seva utilitat pràctica—la gent vol saber què ve per preparar-se, planificar i alinear-se amb el flux del temps.",
  },
  positionInteractions: [
    {
      description: {
        en: "January → February → March: The First Quarter - How the year begins sets momentum for the first arc",
        es: "Enero → Febrero → Marzo: El Primer Trimestre - Cómo comienza el año establece el momentum para el primer arco",
        ca: "Gener → Febrer → Març: El Primer Trimestre - Com comença l'any estableix el momentum per al primer arc",
      },
      positions: ["MONTH_1", "MONTH_2", "MONTH_3"],
      aiGuidance: "The first three months establish the year's opening energy. If January is an Ace (new beginning), February might be a Two (partnership/choice), and March a Three (initial growth)—this shows a building narrative. If all three are Major Arcana, the first quarter is fated and significant. If all three are reversed or challenging cards (Five of Pentacles, Three of Swords, Tower), warn the querent that the year starts rough but can improve later (look to April-June for relief). The January card especially sets tone—it's the 'prologue' of the year's story.",
    },
    {
      description: {
        en: "April → May → June: The Second Quarter - Spring energies of growth, action, and blossoming",
        es: "Abril → Mayo → Junio: El Segundo Trimestre - Energías primaverales de crecimiento, acción y floración",
        ca: "Abril → Maig → Juny: El Segon Trimestre - Energies primave rals de creixement, acció i floració",
      },
      positions: ["MONTH_4", "MONTH_5", "MONTH_6"],
      aiGuidance: "Spring months often carry energies of renewal, growth, and manifestation in the Northern Hemisphere (or harvest in Southern). Look for Wands (creative action), Pentacles (material growth), or fertility cards (Empress, Ace of Wands, Three of Cups) as indicators of productive months. If this quarter is strong while Q1 was challenging, the year improves after a rough start. If Q2 is stagnant (Four of Cups, Hanged Man, Eight of Swords), the querent may feel stuck mid-year despite spring's promises.",
    },
    {
      description: {
        en: "July → August → September: The Third Quarter - Summer peak and preparation for harvest",
        es: "Julio → Agosto → Septiembre: El Tercer Trimestre - Pico veraniego y preparación para la cosecha",
        ca: "Juliol → Agost → Setembre: El Tercer Trimestre - Pic estiuenc i preparació per a la collita",
      },
      positions: ["MONTH_7", "MONTH_8", "MONTH_9"],
      aiGuidance: "Mid-year often represents peak energy and then transition. Look for culmination cards (Tens, The World, Judgment) indicating achievements or completions. September, as the traditional harvest month, often shows what you've reaped from the year's first two-thirds. If July-September are strong, the querent is in their power. If challenging, mid-year crises or burnout may occur. The September card is especially telling—it's the 'harvest' of what was planted in January.",
    },
    {
      description: {
        en: "October → November → December: The Fourth Quarter - Completion, release, and preparation for the new cycle",
        es: "Octubre → Noviembre → Diciembre: El Cuarto Trimestre - Completación, liberación y preparación para el nuevo ciclo",
        ca: "Octubre → Novembre → Desembre: El Quart Trimestre - Completació, alliberament i preparació per al nou cicle",
      },
      positions: ["MONTH_10", "MONTH_11", "MONTH_12"],
      aiGuidance: "The final quarter is about endings, integration, and preparing for the next year. Look for Death, The World, Tens, or the Hermit as indicators of completion and wisdom. December, as the year's final month, shows how the year ends and what carries forward. If December is the Fool, a new cycle begins immediately. If it's the Hanged Man or Four of Swords, rest and reflection close the year. If Q4 is challenging while earlier quarters were strong, the year fades rather than crescendos (prepare for a quiet ending). If Q4 is triumphant after a hard year, there's redemption and hope.",
    },
    {
      description: {
        en: "Major Arcana Months: Fated Turning Points - Months with Major Arcana carry significant life lessons and karmic weight",
        es: "Meses de Arcanos Mayores: Puntos de Inflexión Predestinados - Los meses con Arcanos Mayores llevan lecciones de vida significativas y peso kármico",
        ca: "Mesos d'Arcans Majors: Punts d'Inflexió Predestinats - Els mesos amb Arcans Majors porten lliçons de vida significatives i pes kàrmic",
      },
      positions: ["MONTH_1", "MONTH_2", "MONTH_3", "MONTH_4", "MONTH_5", "MONTH_6", "MONTH_7", "MONTH_8", "MONTH_9", "MONTH_10", "MONTH_11", "MONTH_12"],
      aiGuidance: "Count the Major Arcana across all 12 months. 0-2 Major Arcana = a relatively 'normal' year focused on daily life (Minor Arcana = minor events). 3-5 Major Arcana = a significant year with notable life lessons and turning points. 6+ Major Arcana = a HIGHLY karmic year—the querent is living through major soul curriculum. Mark which months have Major Arcana and prepare the querent: These are the power months, the months that will be remembered, the months that change things. The Tower in any month = disruption/breakthrough. Death = transformation/endings. The World = achievement/completion. The Fool = new beginning. Communicate these as opportunities for growth, not doom.",
    },
    {
      description: {
        en: "Suit Distribution: The Year's Elemental Themes - Which element (Fire/Earth/Air/Water) dominates the year's energy",
        es: "Distribución de Palos: Los Temas Elementales del Año - Qué elemento (Fuego/Tierra/Aire/Agua) domina la energía del año",
        ca: "Distribució de Pals: Els Temes Elementals de l'Any - Quin element (Foc/Terra/Aire/Aigua) domina l'energia de l'any",
      },
      positions: ["MONTH_1", "MONTH_2", "MONTH_3", "MONTH_4", "MONTH_5", "MONTH_6", "MONTH_7", "MONTH_8", "MONTH_9", "MONTH_10", "MONTH_11", "MONTH_12"],
      aiGuidance: "Count which suit appears most frequently across the 12 months. Wands majority (5+ Wands) = a year of action, creativity, passion, projects, entrepreneurship. Cups majority = a year of emotions, relationships, intuition, spiritual/creative flow. Swords majority = a year of mental work, decisions, conflicts, communication, clarity. Pentacles majority = a year of material building, career, health, stability, practical matters. No dominant suit (even distribution) = a balanced year touching all life areas. Use this insight to advise the querent: 'This is a Wands year—say yes to adventures and creative risks. Don't overthink (Swords) or wait for perfect circumstances (Pentacles)—just ACT.' Tailor guidance to the elemental dominance.",
    },
  ],
  aiSelectionCriteria: {
    questionPatterns: [
      "what does this year hold",
      "yearly forecast",
      "year ahead",
      "annual reading",
      "monthly predictions",
      "what's coming this year",
      "next 12 months",
      "year preview",
      "new year reading",
      "birthday reading",
      "solar return",
      "yearly guidance",
      "when should I",
      "timing for the year",
      "monthly themes",
    ],
    emotionalStates: [
      "planning ahead",
      "New Year anticipation",
      "birthday reflection",
      "wanting foresight",
      "ready to plan intentionally",
      "seeking temporal roadmap",
      "goal-setting mindset",
    ],
    preferWhen: {
      cardCountPreference: "10-12",
      complexityLevel: "extended",
      experienceLevel: "intermediate",
      timeframe: "future-focused - next 12 months chronologically",
    },
  },
};

/**
 * Educational content registry
 */
export const SPREADS_EDUCATIONAL: Record<string, SpreadEducationalContent> = {
  single: SINGLE_CARD_EDUCATIONAL,
  two_card: TWO_CARD_EDUCATIONAL,
  three_card: THREE_CARD_EDUCATIONAL,
  five_card_cross: FIVE_CARD_CROSS_EDUCATIONAL,
  relationship: RELATIONSHIP_EDUCATIONAL,
  pyramid: PYRAMID_EDUCATIONAL,
  horseshoe: HORSESHOE_EDUCATIONAL,
  star: STAR_EDUCATIONAL,
  celtic_cross: CELTIC_CROSS_EDUCATIONAL,
  astrological: ASTROLOGICAL_EDUCATIONAL,
  year_ahead: YEAR_AHEAD_EDUCATIONAL,
};
