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
 * MORNING GUIDANCE SPREAD
 * Three-card ritual for setting daily intention and focus
 */
const MORNING_GUIDANCE_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "The Morning Guidance Spread is a powerful three-card ritual designed to align your consciousness with the day's highest potential before the world's demands begin. Unlike a predictive reading, this spread is prescriptive—it tells you what energy to embody, where to direct your attention, and what outcome you're co-creating through your choices today. Think of it as your daily spiritual compass, grounding you in intentional living rather than reactive survival. Perfect for building a consistent tarot practice that transforms random card pulls into meaningful dialogue with your higher self.",

    es: "La Tirada de Orientación Matutina es un poderoso ritual de tres cartas diseñado para alinear tu consciencia con el potencial más elevado del día antes de que comiencen las demandas del mundo. A diferencia de una lectura predictiva, esta tirada es prescriptiva: te dice qué energía encarnar, dónde dirigir tu atención, y qué resultado estás co-creando a través de tus elecciones hoy. Piénsala como tu brújula espiritual diaria, arraigándote en vivir intencionalmente en lugar de supervivencia reactiva. Perfecta para construir una práctica de tarot consistente que transforma tiradas aleatorias de cartas en diálogo significativo con tu yo superior.",

    ca: "La Tirada d'Orientació Matinal és un poderós ritual de tres cartes dissenyat per alinear la teva consciència amb el potencial més elevat del dia abans que comencin les demandes del món. A diferència d'una lectura predictiva, aquesta tirada és prescriptiva: et diu quina energia encarnar, on dirigir la teva atenció, i quin resultat estàs co-creant a través de les teves eleccions avui. Pensa-la com la teva brúixola espiritual diària, arrelant-te en viure intencionalment en lloc de supervivència reactiva. Perfecta per construir una pràctica de tarot consistent que transforma tirades aleatòries de cartes en diàleg significatiu amb el teu jo superior.",
  },

  whenToUse: {
    en: "Draw the Morning Guidance Spread as part of your morning ritual—ideally before checking your phone, before coffee, in that liminal space between sleep and day. Use it when you want to set conscious intention rather than stumble through your day on autopilot. Perfect for mornings when you have important meetings, difficult conversations, creative work, or simply want to live more mindfully. This spread shines when you're committed to personal growth and understand that tarot isn't fortune-telling but a tool for conscious co-creation. Especially powerful on Mondays (setting the week's tone), before job interviews or first dates, during Mercury retrograde when clarity is essential, or whenever you feel scattered and need centering. The consistency matters more than perfection—even pulling these three cards while half-awake builds your relationship with daily guidance.",

    es: "Despliega la Tirada de Orientación Matutina como parte de tu ritual matutino, idealmente antes de revisar tu teléfono, antes del café, en ese espacio liminal entre el sueño y el día. Úsala cuando quieras establecer intención consciente en lugar de tropezar por tu día en piloto automático. Perfecta para mañanas cuando tienes reuniones importantes, conversaciones difíciles, trabajo creativo, o simplemente quieres vivir más conscientemente. Esta tirada brilla cuando estás comprometida al crecimiento personal y entiendes que el tarot no es adivinación sino una herramienta para co-creación consciente. Especialmente poderosa los lunes (estableciendo el tono de la semana), antes de entrevistas de trabajo o primeras citas, durante Mercurio retrógrado cuando la claridad es esencial, o cuando te sientes dispersa y necesitas centrarte. La consistencia importa más que la perfección: incluso sacar estas tres cartas medio dormida construye tu relación con la guía diaria.",

    ca: "Desplega la Tirada d'Orientació Matinal com a part del teu ritual matinal, idealment abans de revisar el teu telèfon, abans del cafè, en aquest espai liminal entre el son i el dia. Usa-la quan vulguis establir intenció conscient en lloc d'ensopegar pel teu dia en pilot automàtic. Perfecta per a matins quan tens reunions importants, converses difícils, treball creatiu, o simplement vols viure més conscientment. Aquesta tirada brilla quan estàs compromès al creixement personal i entens que el tarot no és endevinació sinó una eina per a co-creació conscient. Especialment poderosa els dilluns (establint el to de la setmana), abans d'entrevistes de feina o primeres cites, durant Mercuri retrògrad quan la claredat és essencial, o quan et sents dispersat i necessites centrar-te. La consistència importa més que la perfecció: fins i tot treure aquestes tres cartes mig adormit construeix la teva relació amb la guia diària.",
  },

  whenToAvoid: {
    en: "Skip the Morning Guidance Spread if you're rushed or stressed—pulling cards while anxious creates anxious readings. Don't use this for specific questions about other people or situations outside your control; morning guidance is about YOUR energy and agency, not predicting what your boss will do. Avoid it if you're looking for yes/no answers or want to know 'what will happen today' in a fortune-telling sense. This spread requires a mindset shift from passive prediction to active intention-setting. Also skip it if you're emotionally fragile and might catastrophize a challenging card—start with affirmations instead, returning to tarot when you're more grounded.",

    es: "Omite la Tirada de Orientación Matutina si estás apresurada o estresada: sacar cartas mientras estás ansiosa crea lecturas ansiosas. No la uses para preguntas específicas sobre otras personas o situaciones fuera de tu control; la orientación matutina trata sobre TU energía y agencia, no predecir qué hará tu jefe. Evítala si buscas respuestas de sí/no o quieres saber 'qué pasará hoy' en sentido de adivinación. Esta tirada requiere un cambio de mentalidad de predicción pasiva a establecimiento activo de intención. También omítela si estás emocionalmente frágil y podrías catastrofizar una carta desafiante: comienza con afirmaciones en su lugar, regresando al tarot cuando estés más arraigada.",

    ca: "Omet la Tirada d'Orientació Matinal si estàs apressat o estressat: treure cartes mentre estàs ansiós crea lectures ansioses. No l'usis per a preguntes específiques sobre altres persones o situacions fora del teu control; l'orientació matinal tracta sobre LA TEVA energia i agència, no predir què farà el teu cap. Evita-la si busques respostes de sí/no o vols saber 'què passarà avui' en sentit d'endevinació. Aquesta tirada requereix un canvi de mentalitat de predicció passiva a establiment actiu d'intenció. També omet-la si estàs emocionalment fràgil i podries catastrofitzar una carta desafiant: comença amb afirmacions en el seu lloc, retornant al tarot quan estiguis més arrelat.",
  },

  interpretationMethod: {
    en: "Read the three positions as a sacred sequence of embodiment. ENERGY (position 1) reveals the archetypal quality to embody today—not what will happen TO you, but what you're called to BE. If you draw The Empress, you're invited to nurture, create, and embrace abundance consciousness. If you draw Five of Pentacles, you're working with themes of lack, resilience, and asking for help. Don't resist difficult cards; they're showing you the energy to transmute or the shadow to integrate. FOCUS (position 2) directs your attention—what deserves your mental and emotional bandwidth today? This card shows where to invest your limited resources of time and energy. Ace of Swords = mental clarity and new ideas; Four of Cups = examining what you've been taking for granted. Finally, OUTCOME (position 3) reveals the result you're actively creating through your choices today when aligned with the first two cards. This isn't fate; it's potential. If the Outcome is challenging, return to Energy and Focus to see what needs adjustment. Notice the flow: Does Energy support Focus? Does Focus logically lead to Outcome? If all three are harmonious (complementary suits, ascending numbers, visual coherence), you're in alignment. If they conflict, there's a teaching about where you're out of integrity. Major Arcana in Energy = significant soul work today. Court cards often represent aspects of yourself to embody or people who will mirror your growth. Before you start your day, sit with all three cards—let them become mantras you return to when stress arises.",

    es: "Lee las tres posiciones como una secuencia sagrada de encarnación. ENERGÍA (posición 1) revela la cualidad arquetípica a encarnar hoy: no lo que te pasará, sino lo que estás llamada a SER. Si sacas La Emperatriz, estás invitada a nutrir, crear, y abrazar consciencia de abundancia. Si sacas Cinco de Oros, estás trabajando con temas de carencia, resiliencia, y pedir ayuda. No resistas cartas difíciles; te están mostrando la energía a transmutar o la sombra a integrar. ENFOQUE (posición 2) dirige tu atención: ¿qué merece tu ancho de banda mental y emocional hoy? Esta carta muestra dónde invertir tus recursos limitados de tiempo y energía. As de Espadas = claridad mental e ideas nuevas; Cuatro de Copas = examinar lo que has estado dando por sentado. Finalmente, RESULTADO (posición 3) revela el resultado que estás creando activamente a través de tus elecciones hoy cuando te alineas con las primeras dos cartas. Esto no es destino; es potencial. Si el Resultado es desafiante, regresa a Energía y Enfoque para ver qué necesita ajuste. Observa el flujo: ¿La Energía apoya el Enfoque? ¿El Enfoque conduce lógicamente al Resultado? Si las tres son armoniosas (palos complementarios, números ascendentes, coherencia visual), estás en alineación. Si entran en conflicto, hay una enseñanza sobre dónde estás fuera de integridad. Arcanos Mayores en Energía = trabajo significativo del alma hoy. Cartas de corte a menudo representan aspectos de ti misma a encarnar o personas que reflejarán tu crecimiento. Antes de comenzar tu día, siéntate con las tres cartas: déjalas convertirse en mantras a los que regresas cuando surja el estrés.",

    ca: "Llegeix les tres posicions com una seqüència sagrada d'encarnació. ENERGIA (posició 1) revela la qualitat arquetípica a encarnar avui: no el que et passarà, sinó el que estàs cridat a SER. Si treus L'Emperadriu, estàs convidat a nodrir, crear, i abraçar consciència d'abundància. Si treus Cinc d'Ors, estàs treballant amb temes de mancança, resiliència, i demanar ajuda. No resisteixis cartes difícils; t'estan mostrant l'energia a transmutar o l'ombra a integrar. ENFOCAMENT (posició 2) dirigeix la teva atenció: què mereix el teu ample de banda mental i emocional avui? Aquesta carta mostra on invertir els teus recursos limitats de temps i energia. As d'Espases = claredat mental i idees noves; Quatre de Copes = examinar el que has estat donant per descomptat. Finalment, RESULTAT (posició 3) revela el resultat que estàs creant activament a través de les teves eleccions avui quan t'alineas amb les primeres dues cartes. Això no és destí; és potencial. Si el Resultat és desafiant, retorna a Energia i Enfocament per veure què necessita ajust. Observa el flux: L'Energia recolza l'Enfocament? L'Enfocament condueix lògicament al Resultat? Si les tres són harmonioses (pals complementaris, números ascendents, coherència visual), estàs en alineació. Si entren en conflicte, hi ha un ensenyament sobre on estàs fora d'integritat. Arcans Majors a Energia = treball significatiu de l'ànima avui. Cartes de cort sovint representen aspectes de tu mateix a encarnar o persones que reflectiran el teu creixement. Abans de començar el teu dia, seu amb les tres cartes: deixa-les convertir-se en mantres als quals retornes quan sorgeixi l'estrés.",
  },

  traditionalOrigin: {
    en: "The Morning Guidance Spread is a modern standard variation of the foundational Three Card Spread, adapted for daily spiritual practice in the late 20th century as tarot shifted from fortune-telling to self-development tool. The practice of morning intention-setting has roots in ancient spiritual traditions—from Buddhist morning prayers to Renaissance alchemical 'operations of the day'—making this a natural synthesis of tarot's temporal structure (past-present-future) reimagined as prescriptive guidance (energy-focus-outcome). Teachers like Mary K. Greer and Angeles Arrien championed daily tarot practice as transformative ritual, elevating the morning card pull from superstition to sacred mindfulness.",

    es: "La Tirada de Orientación Matutina es una variación estándar moderna de la Tirada de Tres Cartas fundacional, adaptada para práctica espiritual diaria a finales del siglo XX cuando el tarot pasó de adivinación a herramienta de autodesarrollo. La práctica de establecer intención matutina tiene raíces en tradiciones espirituales antiguas, desde oraciones matutinas budistas hasta 'operaciones del día' alquímicas renacentistas, haciendo de esto una síntesis natural de la estructura temporal del tarot (pasado-presente-futuro) reimaginada como guía prescriptiva (energía-enfoque-resultado). Maestras como Mary K. Greer y Angeles Arrien defendieron la práctica diaria de tarot como ritual transformador, elevando la tirada matutina de carta de superstición a mindfulness sagrado.",

    ca: "La Tirada d'Orientació Matinal és una variació estàndard moderna de la Tirada de Tres Cartes fundacional, adaptada per a pràctica espiritual diària a finals del segle XX quan el tarot va passar d'endevinació a eina d'autodesenvolvament. La pràctica d'establir intenció matinal té arrels en tradicions espirituals antigues, des d'oracions matinals budistes fins a 'operacions del dia' alquímiques renaixentistes, fent d'això una síntesi natural de l'estructura temporal del tarot (passat-present-futur) reimaginada com a guia prescriptiva (energia-enfocament-resultat). Mestres com Mary K. Greer i Angeles Arrien van defensar la pràctica diària de tarot com a ritual transformador, elevant la tirada matinal de carta de superstició a mindfulness sagrat.",
  },

  positionInteractions: [
    {
      description: {
        en: "ENERGY → FOCUS: From Being to Doing - Alignment of essence and action",
        es: "ENERGÍA → ENFOQUE: Del Ser al Hacer - Alineación de esencia y acción",
        ca: "ENERGIA → ENFOCAMENT: Del Ser al Fer - Alineació d'essència i acció",
      },
      positions: ["ENERGY", "FOCUS"],
      aiGuidance: "The ENERGY card sets the vibrational frequency; the FOCUS card shows how to apply it practically. If Energy is Empress (nurturing) and Focus is Three of Pentacles (collaborative work), nurture your team today. If they conflict (Energy = solitary Hermit, Focus = social Three of Cups), explore the tension—maybe you need solitary recharge BEFORE socializing, or you're being called to bring hermit wisdom into community. Harmonious flow (same element, complementary numbers) = easy alignment. Tension = growth edge.",
    },
    {
      description: {
        en: "FOCUS → OUTCOME: The Manifestation Channel - Where attention goes, energy flows",
        es: "ENFOQUE → RESULTADO: El Canal de Manifestación - Donde va la atención, fluye la energía",
        ca: "ENFOCAMENT → RESULTAT: El Canal de Manifestació - On va l'atenció, flueix l'energia",
      },
      positions: ["FOCUS", "OUTCOME"],
      aiGuidance: "This connection reveals cause-and-effect. If FOCUS is clear (Ace of Swords) and OUTCOME is success (Six of Wands), mental clarity leads to victory. If FOCUS is scattered (Seven of Cups) and OUTCOME is confusion (Moon), the reading warns of fantasy vs reality. When OUTCOME seems disconnected from FOCUS, check if the querent is sabotaging their own intentions—the cards reveal subconscious patterns. A challenging OUTCOME invites revisiting FOCUS: where should attention shift?",
    },
    {
      description: {
        en: "The Morning Trinity: ENERGY → FOCUS → OUTCOME as daily creation cycle",
        es: "La Trinidad Matutina: ENERGÍA → ENFOQUE → RESULTADO como ciclo de creación diario",
        ca: "La Trinitat Matinal: ENERGIA → ENFOCAMENT → RESULTAT com a cicle de creació diari",
      },
      positions: ["ENERGY", "FOCUS", "OUTCOME"],
      aiGuidance: "Read all three as one breath: I embody [ENERGY], I direct my attention to [FOCUS], I create [OUTCOME]. This isn't fortune-telling but spell-casting through consciousness. If all three align harmoniously (ascending arc, complementary energies), the day flows naturally. If there's discord, it reveals inner fragmentation—mental desire conflicting with emotional truth, or spiritual calling at odds with practical reality. Multiple Major Arcana = significant soul work day, not just routine. All Minor = practical, grounded focus. Court cards = personas to embody or people who'll play key roles. Use the narrative to set intention: 'Today I am [Energy], focusing on [Focus], to create [Outcome].' Return to this statement throughout the day as your anchor.",
    },
  ],

  aiSelectionCriteria: {
    questionPatterns: [
      "morning guidance",
      "daily intention",
      "start my day",
      "what energy should i bring",
      "where should i focus today",
      "morning ritual",
      "daily practice",
      "set intention",
      "guidance for today",
      "today's energy",
      "how should i approach today",
      "morning reading",
    ],
    emotionalStates: [
      "seeking daily guidance",
      "wanting to set intention",
      "need morning clarity",
      "building spiritual practice",
      "desire mindful living",
      "ready for conscious day",
      "seeking alignment",
    ],
    preferWhen: {
      cardCountPreference: "3",
      complexityLevel: "simple",
      experienceLevel: "any",
      timeframe: "today, morning, daily practice",
    },
  },
};

/**
 * EVENING REFLECTION SPREAD
 * Three-card ritual for daily integration and release
 */
const EVENING_REFLECTION_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "The Evening Reflection Spread is the sacred bookend to your day, a three-card ritual of integration that transforms experiences into wisdom. While Morning Guidance sets intention forward, Evening Reflection processes what actually unfolded—harvesting lessons learned, releasing what no longer serves, and identifying what deserves to be carried into tomorrow. This isn't about judgment or self-criticism; it's about conscious digestion of your day's experiences, both 'good' and 'bad,' recognizing that every moment contains teaching. Perfect for building self-awareness, closing energetic loops, and preventing the accumulation of unprocessed emotional residue that leads to burnout or anxiety.",

    es: "La Tirada de Reflexión Vespertina es el cierre sagrado de tu día, un ritual de tres cartas de integración que transforma experiencias en sabiduría. Mientras la Orientación Matutina establece intención hacia adelante, la Reflexión Vespertina procesa lo que realmente se desarrolló: cosechando lecciones aprendidas, liberando lo que ya no sirve, e identificando lo que merece ser llevado al mañana. No se trata de juicio o autocrítica; se trata de digestión consciente de las experiencias de tu día, tanto 'buenas' como 'malas,' reconociendo que cada momento contiene enseñanza. Perfecta para construir autoconciencia, cerrar ciclos energéticos, y prevenir la acumulación de residuo emocional no procesado que lleva al agotamiento o ansiedad.",

    ca: "La Tirada de Reflexió Vespertina és el tancament sagrat del teu dia, un ritual de tres cartes d'integració que transforma experiències en saviesa. Mentre l'Orientació Matinal estableix intenció cap endavant, la Reflexió Vespertina processa el que realment es va desenvolupar: collint lliçons apreses, alliberant el que ja no serveix, i identificant el que mereix ser portat al demà. No es tracta de judici o autocrítica; es tracta de digestió conscient de les experiències del teu dia, tant 'bones' com 'dolentes,' reconeixent que cada moment conté ensenyament. Perfecta per construir autoconsciència, tancar cicles energètics, i prevenir l'acumulació de residu emocional no processat que porta a l'esgotament o ansietat.",
  },

  whenToUse: {
    en: "Draw the Evening Reflection Spread as part of your nightly wind-down ritual—after dinner, before bed, in that transitional space when the day's demands have quieted. Use it after challenging days when emotions ran high, after significant events (difficult conversations, job interviews, first dates, creative breakthroughs), or simply as a daily practice to cultivate self-awareness. Perfect for journaling companions who want to go deeper than 'what happened' to 'what did it mean?' This spread excels when you've been triggered emotionally and need to understand why, when you're processing relationship dynamics, or when you sense you learned something important but can't quite name it. Especially valuable on Sundays (closing the week), after conflict or breakthroughs, during therapy or shadow work periods, or whenever you feel emotionally cluttered and need to clear your psychic space before sleep. Unlike morning guidance which is forward-facing, this is backward-integrating—honoring what was.",

    es: "Despliega la Tirada de Reflexión Vespertina como parte de tu ritual nocturno de relajación: después de cenar, antes de dormir, en ese espacio transicional cuando las demandas del día se han calmado. Úsala después de días desafiantes cuando las emociones fueron intensas, después de eventos significativos (conversaciones difíciles, entrevistas de trabajo, primeras citas, avances creativos), o simplemente como práctica diaria para cultivar autoconciencia. Perfecta para compañeras de journaling que quieren ir más profundo que 'qué pasó' a '¿qué significó?' Esta tirada sobresale cuando has sido activada emocionalmente y necesitas entender por qué, cuando estás procesando dinámicas relacionales, o cuando percibes que aprendiste algo importante pero no puedes nombrarlo. Especialmente valiosa los domingos (cerrando la semana), después de conflictos o avances, durante periodos de terapia o trabajo de sombra, o cuando te sientes emocionalmente desordenada y necesitas limpiar tu espacio psíquico antes de dormir. A diferencia de la orientación matutina que mira hacia adelante, esta integra hacia atrás, honrando lo que fue.",

    ca: "Desplega la Tirada de Reflexió Vespertina com a part del teu ritual nocturn de relaxació: després de sopar, abans de dormir, en aquest espai transicional quan les demandes del dia s'han calmat. Usa-la després de dies desafiants quan les emocions van ser intenses, després d'esdeveniments significatius (converses difícils, entrevistes de feina, primeres cites, avenços creatius), o simplement com a pràctica diària per cultivar autoconsciència. Perfecta per a companys de journaling que volen anar més profund que 'què va passar' a 'què va significar?' Aquesta tirada sobresurt quan has estat activat emocionalment i necessites entendre per què, quan estàs processant dinàmiques relacionals, o quan percebs que vas aprendre alguna cosa important però no pots nomenar-la. Especialment valuosa els diumenges (tancant la setmana), després de conflictes o avenços, durant períodes de teràpia o treball d'ombra, o quan et sents emocionalment desordenat i necessites netejar el teu espai psíquic abans de dormir. A diferència de l'orientació matinal que mira cap endavant, aquesta integra cap enrere, honrant el que va ser.",
  },

  whenToAvoid: {
    en: "Skip the Evening Reflection if you're exhausted and just need sleep—forcing a reading when depleted creates distorted interpretations. Don't use this as self-punishment or to rehash what went wrong; the purpose is integration, not rumination. Avoid it if you're still emotionally activated and need to process through talking, movement, or therapy first—tarot works best from a slightly grounded state. Also skip if you're prone to anxiety spirals at night; some people need to disconnect from the day rather than analyze it. If you find yourself using this spread to beat yourself up over 'mistakes,' switch to gratitude journaling instead and return to tarot when you can hold self-compassion.",

    es: "Omite la Reflexión Vespertina si estás agotada y solo necesitas dormir: forzar una lectura cuando estás agotada crea interpretaciones distorsionadas. No la uses como auto-castigo o para revivir lo que salió mal; el propósito es integración, no rumiación. Evítala si aún estás emocionalmente activada y necesitas procesar primero hablando, moviéndote, o en terapia: el tarot funciona mejor desde un estado ligeramente arraigado. También omítela si eres propensa a espirales de ansiedad por la noche; algunas personas necesitan desconectarse del día en lugar de analizarlo. Si te encuentras usando esta tirada para castigarte por 'errores,' cambia a journaling de gratitud en su lugar y regresa al tarot cuando puedas sostener auto-compasión.",

    ca: "Omet la Reflexió Vespertina si estàs exhaust i només necessites dormir: forçar una lectura quan estàs esgotat crea interpretacions distorsionades. No l'usis com a auto-càstig o per reviscolar el que va anar malament; el propòsit és integració, no ruminació. Evita-la si encara estàs emocionalment activat i necessites processar primer parlant, movent-te, o en teràpia: el tarot funciona millor des d'un estat lleugerament arrelat. També omet-la si ets propens a espirals d'ansietat a la nit; algunes persones necessiten desconnectar-se del dia en lloc d'analitzar-lo. Si et trobes usant aquesta tirada per castigar-te per 'errors,' canvia a journaling de gratitud en el seu lloc i retorna al tarot quan puguis sostenir auto-compassió.",
  },

  interpretationMethod: {
    en: "Read the three positions as a sacred process of alchemical transformation—lead into gold, experience into wisdom. LESSON (position 1) reveals the day's primary teaching, the insight or growth edge you encountered. This might be obvious (you drew Strength and had to be brave in a meeting) or subtle (Ten of Cups appeared but you felt disconnected from joy—why?). Don't force the card to match events literally; sometimes the lesson is in the contrast between card and reality. If you drew Justice but acted unfairly, that's the teaching. RELEASE (position 2) shows what you're called to let go of tonight—emotions, beliefs, grudges, expectations that aren't serving you. Five of Cups = release the rumination over what didn't work. Eight of Swords = release the mental prison of limiting thoughts. Devil = release the attachment or addiction. This isn't about suppressing feelings but consciously choosing not to carry them into tomorrow. Reversed cards here often show what you're struggling to release. CARRY_FORWARD (position 3) identifies the gold to keep—the insight, strength, connection, or achievement that deserves to be integrated into your ongoing story. This is your harvest, your trophy from today's battles. Star = carry forward hope and vision. Three of Pentacles = carry forward collaborative success. Notice the arc: did you actually learn the LESSON the cards named? Can you genuinely RELEASE what's shown, or do you need support? What does CARRY_FORWARD ask you to remember tomorrow? The three cards together tell the story of integration: I learned [Lesson], I release [Release], I keep [Carry Forward]. Journal on these. Notice patterns over weeks—are you learning the same lesson repeatedly? Refusing to release the same patterns? This spread becomes a mirror of your growth trajectory when practiced consistently.",

    es: "Lee las tres posiciones como un proceso sagrado de transformación alquímica: plomo en oro, experiencia en sabiduría. LECCIÓN (posición 1) revela la enseñanza principal del día, la percepción o límite de crecimiento que encontraste. Esto podría ser obvio (sacaste Fuerza y tuviste que ser valiente en una reunión) o sutil (Diez de Copas apareció pero te sentiste desconectada de la alegría—¿por qué?). No fuerces la carta a coincidir con eventos literalmente; a veces la lección está en el contraste entre carta y realidad. Si sacaste Justicia pero actuaste injustamente, esa es la enseñanza. LIBERACIÓN (posición 2) muestra lo que estás llamada a soltar esta noche: emociones, creencias, rencores, expectativas que no te están sirviendo. Cinco de Copas = libera la rumiación sobre lo que no funcionó. Ocho de Espadas = libera la prisión mental de pensamientos limitantes. Diablo = libera el apego o adicción. No se trata de suprimir sentimientos sino de elegir conscientemente no llevarlos al mañana. Las cartas invertidas aquí a menudo muestran lo que estás luchando por liberar. LLEVAR_ADELANTE (posición 3) identifica el oro a mantener: la percepción, fuerza, conexión, o logro que merece ser integrado en tu historia continua. Esta es tu cosecha, tu trofeo de las batallas de hoy. Estrella = lleva adelante esperanza y visión. Tres de Oros = lleva adelante éxito colaborativo. Observa el arco: ¿realmente aprendiste la LECCIÓN que nombraron las cartas? ¿Puedes genuinamente LIBERAR lo que se muestra, o necesitas apoyo? ¿Qué te pide LLEVAR_ADELANTE recordar mañana? Las tres cartas juntas cuentan la historia de integración: Aprendí [Lección], libero [Liberación], mantengo [Llevar Adelante]. Escribe en tu diario sobre estas. Observa patrones durante semanas: ¿estás aprendiendo la misma lección repetidamente? ¿Negándote a liberar los mismos patrones? Esta tirada se convierte en un espejo de tu trayectoria de crecimiento cuando se practica consistentemente.",

    ca: "Llegeix les tres posicions com un procés sagrat de transformació alquímica: plom en or, experiència en saviesa. LLIÇÓ (posició 1) revela l'ensenyament principal del dia, la percepció o límit de creixement que vas trobar. Això podria ser obvi (vas treure Força i vas haver de ser valent en una reunió) o subtil (Deu de Copes va aparèixer però et vas sentir desconnectat de l'alegria—per què?). No forcis la carta a coincidir amb esdeveniments literalment; a vegades la lliçó està en el contrast entre carta i realitat. Si vas treure Justícia però vas actuar injustament, aquesta és l'ensenyament. ALLIBERAMENT (posició 2) mostra el que estàs cridat a deixar anar aquesta nit: emocions, creences, rancors, expectatives que no t'estan servint. Cinc de Copes = allibera la ruminació sobre el que no va funcionar. Vuit d'Espases = allibera la presó mental de pensaments limitants. Diable = allibera l'aferrament o addicció. No es tracta de suprimir sentiments sinó d'elegir conscientment no portar-los al demà. Les cartes invertides aquí sovint mostren el que estàs lluitant per alliberar. PORTAR_ENDAVANT (posició 3) identifica l'or a mantenir: la percepció, força, connexió, o assoliment que mereix ser integrat en la teva història contínua. Aquesta és la teva collita, el teu trofeu de les batalles d'avui. Estrella = porta endavant esperança i visió. Tres d'Ors = porta endavant èxit col·laboratiu. Observa l'arc: realment vas aprendre la LLIÇÓ que van nomenar les cartes? Pots genuïnament ALLIBERAR el que es mostra, o necessites suport? Què et demana PORTAR_ENDAVANT recordar demà? Les tres cartes juntes compten la història d'integració: Vaig aprendre [Lliçó], allibero [Alliberament], mantinc [Portar Endavant]. Escriu al teu diari sobre aquestes. Observa patrons durant setmanes: estàs aprenent la mateixa lliçó repetidament? Negant-te a alliberar els mateixos patrons? Aquesta tirada es converteix en un mirall de la teva trajectòria de creixement quan es practica consistentment.",
  },

  traditionalOrigin: {
    en: "The Evening Reflection Spread is a modern standard adaptation of the Three Card Spread, reimagined for contemplative practice in the late 20th century as tarot evolved into a self-development and mindfulness tool. The practice of evening examination of conscience has deep roots in spiritual traditions—from Jesuit Ignatian Examen to Buddhist evening meditation—making this a natural synthesis of tarot's reflective capacity with ancient practices of daily review. The specific focus on lesson-release-carry forward mirrors psychological concepts of integration and emotional processing, bringing tarot into dialogue with contemporary therapy and personal growth movements while honoring its divinatory heritage.",

    es: "La Tirada de Reflexión Vespertina es una adaptación estándar moderna de la Tirada de Tres Cartas, reimaginada para práctica contemplativa a finales del siglo XX cuando el tarot evolucionó hacia una herramienta de autodesarrollo y mindfulness. La práctica de examen de consciencia vespertino tiene raíces profundas en tradiciones espirituales, desde el Examen Ignaciano jesuita hasta la meditación vespertina budista, haciendo de esto una síntesis natural de la capacidad reflexiva del tarot con prácticas antiguas de revisión diaria. El enfoque específico en lección-liberación-llevar adelante refleja conceptos psicológicos de integración y procesamiento emocional, trayendo el tarot al diálogo con movimientos contemporáneos de terapia y crecimiento personal mientras honra su herencia adivinatoria.",

    ca: "La Tirada de Reflexió Vespertina és una adaptació estàndard moderna de la Tirada de Tres Cartes, reimaginada per a pràctica contemplativa a finals del segle XX quan el tarot va evolucionar cap a una eina d'autodesenvolvament i mindfulness. La pràctica d'examen de consciència vespertí té arrels profundes en tradicions espirituals, des de l'Examen Ignacià jesuïta fins a la meditació vespertina budista, fent d'això una síntesi natural de la capacitat reflexiva del tarot amb pràctiques antigues de revisió diària. L'enfocament específic en lliçó-alliberament-portar endavant reflecteix conceptes psicològics d'integració i processament emocional, portant el tarot al diàleg amb moviments contemporanis de teràpia i creixement personal mentre honra la seva herència endevinatòria.",
  },

  positionInteractions: [
    {
      description: {
        en: "LESSON → RELEASE: From Insight to Liberation - The integration pathway",
        es: "LECCIÓN → LIBERACIÓN: De la Percepción a la Liberación - El camino de integración",
        ca: "LLIÇÓ → ALLIBERAMENT: De la Percepció a l'Alliberament - El camí d'integració",
      },
      positions: ["LESSON", "RELEASE"],
      aiGuidance: "The LESSON often explains what needs to be RELEASED. If Lesson is Tower (sudden change/destruction) and Release is Four of Pentacles (holding on), the teaching is to release control. If Lesson is Temperance (balance) and Release is Seven of Swords (deception/strategy), release the manipulation and embrace authenticity. Sometimes they seem contradictory—Lesson is Ace of Cups (new love) but Release is Ten of Cups (contentment)—dig deeper: maybe you need to release OLD relationship patterns to welcome new love. The flow should feel like cause-and-effect leading to liberation.",
    },
    {
      description: {
        en: "RELEASE → CARRY_FORWARD: The Alchemical Transmutation - From letting go to integration",
        es: "LIBERACIÓN → LLEVAR_ADELANTE: La Transmutación Alquímica - De soltar a integración",
        ca: "ALLIBERAMENT → PORTAR_ENDAVANT: La Transmutació Alquímica - De deixar anar a integració",
      },
      positions: ["RELEASE", "CARRY_FORWARD"],
      aiGuidance: "These two cards show the exchange: what you release creates space for what you carry forward. If Release is Five of Cups (grief) and Carry Forward is Strength (courage), letting go of sorrow makes room for bravery. If both are challenging (Release = Tower, Carry Forward = Five of Pentacles), the message may be: even in loss, carry forward resilience and survival. Notice if Carry Forward feels genuinely earned—if the querent released what RELEASE showed, they've earned the harvest of CARRY_FORWARD. If not, that card becomes aspirational guidance for tomorrow.",
    },
    {
      description: {
        en: "The Evening Trinity: LESSON → RELEASE → CARRY_FORWARD as wisdom cycle",
        es: "La Trinidad Vespertina: LECCIÓN → LIBERACIÓN → LLEVAR_ADELANTE como ciclo de sabiduría",
        ca: "La Trinitat Vespertina: LLIÇÓ → ALLIBERAMENT → PORTAR_ENDAVANT com a cicle de saviesa",
      },
      positions: ["LESSON", "RELEASE", "CARRY_FORWARD"],
      aiGuidance: "Read all three as the complete cycle of integration: Today taught me [LESSON], so I release [RELEASE], and I carry forward [CARRY_FORWARD]. This should feel like a coherent story of transformation. If the three cards seem disconnected, explore hidden connections—often the LESSON is subtle, revealed through the relationship between what's released and what's kept. Multiple Major Arcana = significant soul lesson day. All Minor = practical learning. Reversed cards often appear in RELEASE (what's hard to let go) or LESSON (what hasn't fully landed). Track these spreads over time—patterns emerge showing recurring lessons, habitual attachments, and cumulative wisdom. The Evening Reflection becomes a longitudinal map of consciousness evolution.",
    },
  ],

  aiSelectionCriteria: {
    questionPatterns: [
      "evening reflection",
      "end of day",
      "what did i learn today",
      "process my day",
      "daily review",
      "what should i release",
      "evening ritual",
      "reflect on today",
      "integrate my day",
      "nightly practice",
      "close the day",
      "evening guidance",
    ],
    emotionalStates: [
      "processing the day",
      "need to release",
      "seeking integration",
      "want to learn from today",
      "evening contemplation",
      "ready to let go",
      "building evening practice",
    ],
    preferWhen: {
      cardCountPreference: "3",
      complexityLevel: "simple",
      experienceLevel: "any",
      timeframe: "today, evening, daily practice",
    },
  },
};

/**
 * WEEKLY OVERVIEW SPREAD
 * Seven-card calendar for weekly planning and awareness
 */
const WEEKLY_OVERVIEW_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "The Weekly Overview Spread is a seven-card calendar that maps the energetic weather of your week ahead, one card per day from Monday through Sunday. Unlike predictive fortune-telling, this spread reveals the dominant energy, theme, or focus for each day—empowering you to plan strategically, prepare emotionally, and navigate your week with consciousness rather than being blindsided by challenges. Think of it as your weekly forecast: not dictating what WILL happen, but showing what energies are active so you can work with them skillfully. Perfect for Sunday night planning, professional goal-setting, or anyone who wants to move through their week with intentionality and grace.",

    es: "La Tirada de Panorama Semanal es un calendario de siete cartas que mapea el clima energético de tu semana por delante, una carta por día de lunes a domingo. A diferencia de adivinación predictiva, esta tirada revela la energía dominante, tema, o enfoque para cada día, empoderándote para planificar estratégicamente, prepararte emocionalmente, y navegar tu semana con consciencia en lugar de ser sorprendida por desafíos. Piénsala como tu pronóstico semanal: no dictando lo que PASARÁ, sino mostrando qué energías están activas para que puedas trabajar con ellas hábilmente. Perfecta para planificación del domingo por la noche, establecimiento de objetivos profesionales, o cualquiera que quiera moverse a través de su semana con intencionalidad y gracia.",

    ca: "La Tirada de Panorama Setmanal és un calendari de set cartes que mapeja el clima energètic de la teva setmana per endavant, una carta per dia de dilluns a diumenge. A diferència d'endevinació predictiva, aquesta tirada revela l'energia dominant, tema, o enfocament per a cada dia, apoderant-te per planificar estratègicament, preparar-te emocionalment, i navegar la teva setmana amb consciència en lloc de ser sorprès per desafiaments. Pensa-la com el teu pronòstic setmanal: no dictant el que PASSARÀ, sinó mostrant quines energies estan actives perquè puguis treballar amb elles hàbilment. Perfecta per a planificació del diumenge a la nit, establiment d'objectius professionals, o qualsevol que vulgui moure's a través de la seva setmana amb intencionalitat i gràcia.",
  },

  whenToUse: {
    en: "Draw the Weekly Overview at the start of your week—Sunday evening is ideal, giving you Monday morning clarity, though Monday morning works too. Perfect for busy professionals who need to strategize their workweek, parents juggling complex family schedules, creatives planning project timelines, or anyone navigating a significant week (job interviews, travel, launches, difficult conversations). Use this when you want to allocate your energy wisely across seven days rather than being reactive. Especially valuable during busy seasons (back to school, year-end, tax season), when you're starting a new job or project, during relationship transitions, or when you simply want to feel more in control of your time. This spread also works beautifully for weekly goal-setting—seeing Wednesday's energy might inspire you to schedule that difficult conversation then rather than Friday. Unlike daily pulls which offer immediate guidance, this gives you the strategic advantage of seeing the whole arc of your week at once.",

    es: "Despliega el Panorama Semanal al inicio de tu semana—el domingo por la noche es ideal, dándote claridad para el lunes por la mañana, aunque el lunes por la mañana también funciona. Perfecta para profesionales ocupadas que necesitan estrategizar su semana laboral, padres haciendo malabarismos con horarios familiares complejos, creativos planificando cronogramas de proyectos, o cualquiera navegando una semana significativa (entrevistas de trabajo, viajes, lanzamientos, conversaciones difíciles). Úsala cuando quieras asignar tu energía sabiamente a través de siete días en lugar de ser reactiva. Especialmente valiosa durante temporadas ocupadas (regreso a clases, fin de año, temporada de impuestos), cuando estás comenzando un trabajo o proyecto nuevo, durante transiciones relacionales, o cuando simplemente quieres sentir más control de tu tiempo. Esta tirada también funciona maravillosamente para establecimiento de objetivos semanales: ver la energía del miércoles podría inspirarte a programar esa conversación difícil entonces en lugar del viernes. A diferencia de tiradas diarias que ofrecen guía inmediata, esto te da la ventaja estratégica de ver el arco completo de tu semana de una vez.",

    ca: "Desplega el Panorama Setmanal a l'inici de la teva setmana—el diumenge a la nit és ideal, donant-te claredat per al dilluns al matí, tot i que el dilluns al matí també funciona. Perfecta per a professionals ocupats que necessiten estrategitzar la seva setmana laboral, pares fent malabarismes amb horaris familiars complexos, creatius planificant cronogrames de projectes, o qualsevol navegant una setmana significativa (entrevistes de feina, viatges, llançaments, converses difícils). Usa-la quan vulguis assignar la teva energia sàviament a través de set dies en lloc de ser reactiu. Especialment valuosa durant temporades ocupades (tornada a l'escola, fi d'any, temporada d'impostos), quan estàs començant una feina o projecte nou, durant transicions relacionals, o quan simplement vols sentir més control del teu temps. Aquesta tirada també funciona meravellosament per a establiment d'objectius setmanals: veure l'energia del dimecres podria inspirar-te a programar aquella conversa difícil aleshores en lloc del divendres. A diferència de tirades diàries que ofereixen guia immediata, això et dóna l'avantatge estratègic de veure l'arc complet de la teva setmana d'una vegada.",
  },

  whenToAvoid: {
    en: "Skip the Weekly Overview if you prefer spontaneity and find planning restrictive—some people thrive on not knowing what's coming. Don't use this if you'll obsess over 'bad' cards and spend all week dreading Thursday just because Death appeared. Avoid it if you're already overwhelmed; seven cards of information can feel like homework rather than guidance. Also not ideal if your week is completely unstructured or unpredictable (freelancers with chaotic schedules might find daily pulls more useful). If you find yourself using the spread to avoid living (constantly checking 'what will Monday bring' instead of being present), pull back and focus on single daily cards instead.",

    es: "Omite el Panorama Semanal si prefieres espontaneidad y encuentras la planificación restrictiva—algunas personas prosperan no sabiendo qué viene. No la uses si obsesionarás sobre cartas 'malas' y pasarás toda la semana temiendo el jueves solo porque apareció la Muerte. Evítala si ya estás abrumada; siete cartas de información pueden sentirse como tarea en lugar de guía. Tampoco es ideal si tu semana está completamente desestructurada o impredecible (freelancers con horarios caóticos podrían encontrar tiradas diarias más útiles). Si te encuentras usando la tirada para evitar vivir (constantemente revisando 'qué traerá el lunes' en lugar de estar presente), retrocede y enfócate en cartas diarias únicas en su lugar.",

    ca: "Omet el Panorama Setmanal si prefereixes espontaneïtat i trobes la planificació restrictiva—algunes persones prosperen no sabent què ve. No l'usis si obsessionaràs sobre cartes 'dolentes' i passaràs tota la setmana tement el dijous només perquè va aparèixer la Mort. Evita-la si ja estàs aclaparat; set cartes d'informació poden sentir-se com a tasca en lloc de guia. Tampoc és ideal si la teva setmana està completament desestructurada o impredictible (freelancers amb horaris caòtics podrien trobar tirades diàries més útils). Si et trobes usant la tirada per evitar viure (constantment revisant 'què portarà el dilluns' en lloc d'estar present), retrocedeix i enfoca't en cartes diàries úniques en el seu lloc.",
  },

  interpretationMethod: {
    en: "Read the seven cards as a narrative arc—your week's story from beginning to end. Start by laying them out in sequence: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday. First, scan the entire week for patterns: Are there multiple cards of the same suit (all Cups = emotional week, all Pentacles = material/work focus, all Swords = mental challenges, all Wands = active/creative energy)? How many Major Arcana (3+ = significant, fated week)? Do you see an ascending or descending arc (getting better or more challenging)? Then read each day individually as the dominant energy or theme. Monday's Ace of Wands = initiate new projects with enthusiasm. Wednesday's Five of Cups = expect disappointment or need to process grief. Friday's Sun = celebration and success. Don't over-interpret—each card is a tone, not a detailed prediction. Next, notice the transitions: does Tuesday's energy lead logically into Wednesday's? If Tuesday is Ten of Pentacles (stability) and Wednesday is Tower (upheaval), prepare for sudden change midweek. Use this information strategically: if Thursday shows Strength, schedule difficult conversations or challenges then when you'll have courage. If Saturday is Four of Swords (rest), protect that day for recovery rather than overcommitting. Court Cards often indicate people you'll interact with that day or personas you'll need to embody. Reversed cards suggest internal or blocked energy—work on inner shifts rather than external action. The Weekly Overview isn't about passively accepting fate; it's about working skillfully with the energies present. If you see a challenging day coming, prepare mentally and emotionally. If you see opportunity, seize it. Track your accuracy over weeks—you'll learn how YOUR deck speaks about time.",

    es: "Lee las siete cartas como un arco narrativo: la historia de tu semana de principio a fin. Comienza desplegándolas en secuencia: lunes, martes, miércoles, jueves, viernes, sábado, domingo. Primero, escanea la semana entera buscando patrones: ¿Hay múltiples cartas del mismo palo (todas Copas = semana emocional, todos Oros = enfoque material/trabajo, todas Espadas = desafíos mentales, todos Bastos = energía activa/creativa)? ¿Cuántos Arcanos Mayores (3+ = semana significativa, destinada)? ¿Ves un arco ascendente o descendente (mejorando o más desafiante)? Luego lee cada día individualmente como la energía o tema dominante. El As de Bastos del lunes = inicia nuevos proyectos con entusiasmo. El Cinco de Copas del miércoles = espera decepción o necesidad de procesar duelo. El Sol del viernes = celebración y éxito. No sobre-interpretes—cada carta es un tono, no una predicción detallada. Luego, observa las transiciones: ¿la energía del martes conduce lógicamente a la del miércoles? Si el martes es Diez de Oros (estabilidad) y el miércoles es Torre (conmoción), prepárate para cambio repentino a mitad de semana. Usa esta información estratégicamente: si el jueves muestra Fuerza, programa conversaciones o desafíos difíciles entonces cuando tendrás coraje. Si el sábado es Cuatro de Espadas (descanso), protege ese día para recuperación en lugar de sobrecomprometerte. Las Cartas de Corte a menudo indican personas con las que interactuarás ese día o personas que necesitarás encarnar. Las cartas invertidas sugieren energía interna o bloqueada—trabaja en cambios internos en lugar de acción externa. El Panorama Semanal no se trata de aceptar pasivamente el destino; se trata de trabajar hábilmente con las energías presentes. Si ves un día desafiante venir, prepárate mental y emocionalmente. Si ves oportunidad, aprovéchala. Rastrea tu precisión durante semanas: aprenderás cómo TU mazo habla sobre el tiempo.",

    ca: "Llegeix les set cartes com un arc narratiu: la història de la teva setmana de principi a fi. Comença desplegant-les en seqüència: dilluns, dimarts, dimecres, dijous, divendres, dissabte, diumenge. Primer, escaneja tota la setmana cercant patrons: Hi ha múltiples cartes del mateix pal (totes Copes = setmana emocional, tots Ors = enfocament material/treball, totes Espases = desafiaments mentals, tots Bastons = energia activa/creativa)? Quants Arcans Majors (3+ = setmana significativa, destinada)? Veus un arc ascendent o descendent (millorant o més desafiant)? Després llegeix cada dia individualment com l'energia o tema dominant. L'As de Bastons del dilluns = inicia nous projectes amb entusiasme. El Cinc de Copes del dimecres = espera decepció o necessitat de processar dol. El Sol del divendres = celebració i èxit. No sobre-interpretis—cada carta és un to, no una predicció detallada. Després, observa les transicions: l'energia del dimarts condueix lògicament a la del dimecres? Si el dimarts és Deu d'Ors (estabilitat) i el dimecres és Torre (convulsió), prepara't per canvi sobtat a meitat de setmana. Usa aquesta informació estratègicament: si el dijous mostra Força, programa converses o desafiaments difícils aleshores quan tindràs coratge. Si el dissabte és Quatre d'Espases (descans), protegeix aquell dia per recuperació en lloc de sobrecomprometre't. Les Cartes de Cort sovint indiquen persones amb les que interactuaràs aquell dia o persones que necessitaràs encarnar. Les cartes invertides suggereixen energia interna o bloquejada—treballa en canvis interns en lloc d'acció externa. El Panorama Setmanal no es tracta d'acceptar passivament el destí; es tracta de treballar hàbilment amb les energies presents. Si veus un dia desafiant venir, prepara't mental i emocionalment. Si veus oportunitat, aprofita-la. Rastreja la teva precisió durant setmanes: aprendràs com EL TEU mazo parla sobre el temps.",
  },

  traditionalOrigin: {
    en: "The Weekly Overview is a modern standard spread that evolved naturally from the calendar-based tradition of tarot divination. The practice of assigning one card per time unit—whether day, week, or month—has roots in 19th-century European cartomancy, where fortune-tellers would lay cards for each day of the week to guide clients' planning. The seven-card structure also resonates with the symbolic significance of seven in Western esotericism (seven classical planets, seven days of creation, seven chakras), though the Weekly Overview is more practical than mystical. This spread gained prominence in the late 20th century as tarot shifted from occasional consultations to daily practice, and people sought tools for integrating spiritual guidance with modern calendar-based living.",

    es: "El Panorama Semanal es una tirada estándar moderna que evolucionó naturalmente de la tradición de adivinación del tarot basada en calendario. La práctica de asignar una carta por unidad de tiempo—ya sea día, semana, o mes—tiene raíces en la cartomancia europea del siglo XIX, donde los adivinos desplegaban cartas para cada día de la semana para guiar la planificación de los clientes. La estructura de siete cartas también resuena con el significado simbólico del siete en el esoterismo occidental (siete planetas clásicos, siete días de la creación, siete chakras), aunque el Panorama Semanal es más práctico que místico. Esta tirada ganó prominencia a finales del siglo XX cuando el tarot pasó de consultas ocasionales a práctica diaria, y la gente buscaba herramientas para integrar guía espiritual con vida basada en calendario moderno.",

    ca: "El Panorama Setmanal és una tirada estàndard moderna que va evolucionar naturalment de la tradició d'endevinació del tarot basada en calendari. La pràctica d'assignar una carta per unitat de temps—ja sigui dia, setmana, o mes—té arrels en la cartomància europea del segle XIX, on els endevins desplegaven cartes per a cada dia de la setmana per guiar la planificació dels clients. L'estructura de set cartes també ressona amb el significat simbòlic del set en l'esoterisme occidental (set planetes clàssics, set dies de la creació, set chakres), tot i que el Panorama Setmanal és més pràctic que místic. Aquesta tirada va guanyar prominència a finals del segle XX quan el tarot va passar de consultes ocasionals a pràctica diària, i la gent buscava eines per integrar guia espiritual amb vida basada en calendari modern.",
  },

  positionInteractions: [
    {
      description: {
        en: "MON → TUE → WED: The Opening Arc - How your week begins",
        es: "LUN → MAR → MIÉ: El Arco de Apertura - Cómo comienza tu semana",
        ca: "DIL → DIM → DIM: L'Arc d'Obertura - Com comença la teva setmana",
      },
      positions: ["MON", "TUE", "WED"],
      aiGuidance: "These first three days set the tone for the entire week. If they're ascending (challenge to ease, conflict to resolution), the week starts rough but improves. If descending (celebration to struggle), front-load your week with the good energy while you have it. Look for narrative flow: does Monday's action lead to Tuesday's consequence and Wednesday's resolution? A strong Monday (Magician, Ace of Wands) suggests taking initiative early. Multiple Majors here = significant first half of week.",
    },
    {
      description: {
        en: "THU: The Turning Point - Midweek pivot energy",
        es: "JUE: El Punto de Inflexión - Energía de pivote de mitad de semana",
        ca: "DIJ: El Punt d'Inflexió - Energia de pivot de meitat de setmana",
      },
      positions: ["THU"],
      aiGuidance: "Thursday is the fulcrum of the week—the hinge between early week momentum and weekend wind-down. A powerful Thursday card (Emperor, Strength, Sun) gives second wind for finishing strong. A challenging Thursday (Tower, Ten of Swords) warns of midweek crisis or breakthrough. Notice if Thursday's energy shifts the week's direction—does it resolve earlier tensions or introduce new challenges? This is often the 'truth' day where the week's real theme becomes clear.",
    },
    {
      description: {
        en: "FRI → SAT → SUN: The Closing Arc - How your week resolves",
        es: "VIE → SÁB → DOM: El Arco de Cierre - Cómo se resuelve tu semana",
        ca: "DIV → DIS → DIU: L'Arc de Tancament - Com es resol la teva setmana",
      },
      positions: ["FRI", "SAT", "SUN"],
      aiGuidance: "The weekend trilogy shows how the week lands and transitions into rest/recreation. Ideally, these cards feel lighter or more restorative than the workweek, but sometimes they reveal continued challenges or soul work. If Sunday is difficult (Five of Pentacles, Three of Swords), protect your Sunday for genuine self-care to recover before next week. If Sunday is inspiring (Star, World, Ace of anything), it's setting up Monday's fresh start. The FRI→SAT→SUN arc should feel like release, restoration, and preparation.",
    },
    {
      description: {
        en: "The Full Week: Seven-Day Symphony of Energy",
        es: "La Semana Completa: Sinfonía de Energía de Siete Días",
        ca: "La Setmana Completa: Simfonia d'Energia de Set Dies",
      },
      positions: ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"],
      aiGuidance: "Step back and view the entire week as one coherent energy pattern. Count dominant suits to identify the week's primary realm (4+ Cups = emotional focus week, 4+ Pentacles = material/work week, etc.). Track Major Arcana count (3+ = fated, significant week with soul lessons). Notice if there's a peak day (most powerful card) and valley day (most challenging)—this shows the week's climax and nadir. Look for bookend patterns: if MON and SUN mirror each other, the week is cyclical. If they contrast, you'll end very differently than you began. Recommend the querent identify the 1-2 most important cards (usually Majors or dramatic cards like Tower, Death, Sun) and build their week around those pivot points. The Weekly Overview should feel like a weather forecast—you can't control the weather, but you can dress appropriately and plan activities wisely.",
    },
  ],

  aiSelectionCriteria: {
    questionPatterns: [
      "weekly overview",
      "week ahead",
      "plan my week",
      "this coming week",
      "weekly forecast",
      "what to expect this week",
      "weekly guidance",
      "seven day",
      "upcoming week",
      "weekly reading",
      "monday through sunday",
      "week forecast",
    ],
    emotionalStates: [
      "planning the week",
      "need weekly guidance",
      "want strategic overview",
      "seeking week-long clarity",
      "organizing my time",
      "need to prepare",
      "weekly check-in",
    ],
    preferWhen: {
      cardCountPreference: "7",
      complexityLevel: "medium",
      experienceLevel: "any",
      timeframe: "one week, seven days, upcoming week",
    },
  },
};

/**
 * 15. Yes/No Spread Educational Content
 */
const YES_NO_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "The Yes/No Spread is the most direct divinatory tool in tarot—a single card drawn with the intention of receiving clear guidance on a binary question. This deceptively simple spread cuts through mental noise and indecision, allowing the cards to deliver an unambiguous energetic signal. Rather than offering complex narratives, this spread provides pure essence: affirmative flow or cautionary pause. It's particularly powerful for quick decision-making when you need immediate clarity without extensive analysis. The card's upright or reversed orientation, suit, and archetypal energy combine to convey the universe's response to your yes/no inquiry.",
    es: "La Tirada Sí/No es la herramienta divinatoria más directa del tarot: una sola carta extraída con la intención de recibir orientación clara sobre una pregunta binaria. Esta tirada engañosamente simple atraviesa el ruido mental y la indecisión, permitiendo que las cartas entreguen una señal energética inequívoca. En lugar de ofrecer narrativas complejas, esta tirada proporciona esencia pura: flujo afirmativo o pausa cautelar. Es particularmente poderosa para tomar decisiones rápidas cuando necesitas claridad inmediata sin análisis extenso. La orientación vertical o invertida de la carta, su palo y energía arquetípica se combinan para transmitir la respuesta del universo a tu consulta de sí/no.",
    ca: "La Tirada Sí/No és l'eina divinatòria més directa del tarot: una sola carta extreta amb la intenció de rebre orientació clara sobre una pregunta binària. Aquesta tirada enganyosament simple travessa el soroll mental i la indecisió, permetent que les cartes lliurin un senyal energètic inequívoc. En lloc d'oferir narratives complexes, aquesta tirada proporciona essència pura: flux afirmatiu o pausa cautelar. És particularment poderosa per prendre decisions ràpides quan necessites claredat immediata sense anàlisi extensa. L'orientació vertical o invertida de la carta, el seu pal i energia arquetípica es combinen per transmetre la resposta de l'univers a la teva consulta de sí/no.",
  },
  whenToUse: {
    en: "Draw the Yes/No Spread when you face a concrete binary decision requiring immediate clarity: \"Should I take this job?\" \"Is now the right time to move?\" \"Will this relationship work out?\" It's ideal when you're torn between two paths and need the universe's gentle nudge in one direction. Use it after meditation or when you've already analyzed the situation intellectually but need intuitive confirmation. This spread works best for questions where you're genuinely open to either answer—not when you're seeking validation for a decision you've already made. It's perfect for time-sensitive choices, gut-check moments, and when you need to bypass overthinking.",
    es: "Despliega la Tirada Sí/No cuando enfrentas una decisión binaria concreta que requiere claridad inmediata: \"¿Debería aceptar este trabajo?\" \"¿Es ahora el momento adecuado para mudarme?\" \"¿Funcionará esta relación?\" Es ideal cuando estás dividido entre dos caminos y necesitas el empujón suave del universo en una dirección. Úsala después de meditar o cuando ya has analizado la situación intelectualmente pero necesitas confirmación intuitiva. Esta tirada funciona mejor para preguntas donde estás genuinamente abierto a cualquier respuesta, no cuando buscas validación para una decisión que ya tomaste. Es perfecta para elecciones sensibles al tiempo, momentos de verificación intuitiva y cuando necesitas evitar pensar demasiado.",
    ca: "Desplega la Tirada Sí/No quan t'enfrontes a una decisió binària concreta que requereix claredat immediata: \"Hauria d'acceptar aquesta feina?\" \"És ara el moment adequat per traslladar-me?\" \"Funcionarà aquesta relació?\" És ideal quan estàs dividit entre dos camins i necessites l'empenta suau de l'univers en una direcció. Usa-la després de meditar o quan ja has analitzat la situació intel·lectualment però necessites confirmació intuïtiva. Aquesta tirada funciona millor per a preguntes on estàs genuïnament obert a qualsevol resposta, no quan cerques validació per a una decisió que ja has pres. És perfecta per a eleccions sensibles al temps, moments de verificació intuïtiva i quan necessites evitar pensar massa.",
  },
  whenToAvoid: {
    en: "Avoid the Yes/No Spread for complex situations requiring nuanced understanding—questions about \"how\" or \"why\" need multi-card spreads. Don't use it when you're emotionally charged or desperate for a specific answer, as your energy will cloud the reading. Skip this spread if the question isn't truly binary (multiple options require different spreads), or if you're asking about someone else's free will (\"Will they love me?\"). It's also inappropriate for ethical or life-altering decisions that deserve deeper exploration. If you find yourself repeatedly drawing cards hoping for a different answer, stop—that's ego override, not divination.",
    es: "Evita la Tirada Sí/No para situaciones complejas que requieren comprensión matizada: las preguntas sobre \"cómo\" o \"por qué\" necesitan tiradas de múltiples cartas. No la uses cuando estés emocionalmente cargado o desesperado por una respuesta específica, ya que tu energía nublará la lectura. Omite esta tirada si la pregunta no es verdaderamente binaria (múltiples opciones requieren tiradas diferentes), o si preguntas sobre el libre albedrío de otra persona (\"¿Me amarán?\"). También es inapropiada para decisiones éticas o que alteran la vida y merecen exploración más profunda. Si te encuentras extrayendo cartas repetidamente esperando una respuesta diferente, detente: eso es anulación del ego, no adivinación.",
    ca: "Evita la Tirada Sí/No per a situacions complexes que requereixen comprensió matisada: les preguntes sobre \"com\" o \"per què\" necessiten tirades de múltiples cartes. No l'usis quan estiguis emocionalment carregat o desesperat per una resposta específica, ja que la teva energia entorbirà la lectura. Omet aquesta tirada si la pregunta no és veritablement binària (múltiples opcions requereixen tirades diferents), o si preguntes sobre el lliure albir d'una altra persona (\"M'estimaran?\"). També és inapropiada per a decisions ètiques o que alteren la vida i mereixen exploració més profunda. Si et trobes extraient cartes repetidament esperant una resposta diferent, atura't: això és anul·lació de l'ego, no endevinació.",
  },
  interpretationMethod: {
    en: "Interpret the single card through multiple lenses simultaneously. First, note the orientation: upright generally signals affirmation (yes, proceed, green light), while reversed suggests caution, delay, or reconsideration (no, wait, red light). Second, consider the suit energy: Wands indicate passionate action (yes with enthusiasm), Cups affirm emotional rightness (yes from the heart), Swords suggest intellectual clarity (yes with logic), Pentacles confirm material stability (yes with security). Major Arcana cards carry archetypal weight—The Sun is an emphatic yes, The Tower warns against proceeding, The Hanged Man suggests waiting. Third, synthesize card-specific meanings: Page of Cups might say \"yes, but approach with innocence,\" while Five of Pentacles reversed could mean \"no, this leads to scarcity.\" Trust your first intuitive hit—the answer usually arrives as a visceral knowing before intellectual analysis.",
    es: "Interpreta la carta única a través de múltiples lentes simultáneamente. Primero, nota la orientación: vertical generalmente señala afirmación (sí, procede, luz verde), mientras que invertida sugiere precaución, retraso o reconsideración (no, espera, luz roja). Segundo, considera la energía del palo: Bastos indican acción apasionada (sí con entusiasmo), Copas afirman rectitud emocional (sí desde el corazón), Espadas sugieren claridad intelectual (sí con lógica), Oros confirman estabilidad material (sí con seguridad). Las cartas de Arcanos Mayores llevan peso arquetípico: El Sol es un sí enfático, La Torre advierte contra proceder, El Colgado sugiere esperar. Tercero, sintetiza significados específicos de la carta: Sota de Copas podría decir \"sí, pero acércate con inocencia,\" mientras que Cinco de Oros invertido podría significar \"no, esto lleva a la escasez.\" Confía en tu primer golpe intuitivo: la respuesta suele llegar como un saber visceral antes del análisis intelectual.",
    ca: "Interpreta la carta única a través de múltiples lents simultàniament. Primer, nota l'orientació: vertical generalment senyala afirmació (sí, procedeix, llum verda), mentre que invertida suggereix precaució, retard o reconsideració (no, espera, llum vermella). Segon, considera l'energia del pal: Bastos indiquen acció apassionada (sí amb entusiasme), Copes afirmen rectitud emocional (sí des del cor), Espases suggereixen claredat intel·lectual (sí amb lògica), Ors confirmen estabilitat material (sí amb seguretat). Les cartes d'Arcans Majors porten pes arquetípic: El Sol és un sí emfàtic, La Torre adverteix contra procedir, El Penjat suggereix esperar. Tercer, sintetitza significats específics de la carta: Sota de Copes podria dir \"sí, però acosta't amb innocència,\" mentre que Cinc d'Ors invertit podria significar \"no, això porta a l'escassetat.\" Confia en el teu primer colp intuïtiu: la resposta sol arribar com un saber visceral abans de l'anàlisi intel·lectual.",
  },
  traditionalOrigin: {
    en: "The Yes/No Spread represents tarot's oldest and most fundamental function: binary divination. From the earliest cartomancy practices of the 1700s, single-card draws were used for immediate yes/no answers—a practice predating complex spread structures. This method honors the original fortune-telling use of cards before esoteric systems (Qabalah, astrology) were overlaid. Every tarot tradition includes single-card consultation, making this a universally traditional (🏛️) practice verified across centuries of documented use.",
    es: "La Tirada Sí/No representa la función más antigua y fundamental del tarot: la adivinación binaria. Desde las prácticas más tempranas de cartomancia de los años 1700, las extracciones de carta única se usaban para respuestas inmediatas de sí/no, una práctica anterior a las estructuras de tiradas complejas. Este método honra el uso original de adivinación de las cartas antes de que se superpusieran sistemas esotéricos (Qabalá, astrología). Cada tradición del tarot incluye consulta de carta única, haciendo de esta una práctica universalmente tradicional (🏛️) verificada a través de siglos de uso documentado.",
    ca: "La Tirada Sí/No representa la funció més antiga i fonamental del tarot: l'endevinació binària. Des de les pràctiques més primerenques de cartomància dels anys 1700, les extraccions de carta única s'usaven per a respostes immediates de sí/no, una pràctica anterior a les estructures de tirades complexes. Aquest mètode honra l'ús original d'endevinació de les cartes abans que se sobreposessin sistemes esotèrics (Qabalà, astrologia). Cada tradició del tarot inclou consulta de carta única, fent d'aquesta una pràctica universalment tradicional (🏛️) verificada a través de segles d'ús documentat.",
  },
  positionInteractions: [],
  aiSelectionCriteria: {
    questionPatterns: [
      "yes or no",
      "should I",
      "will this",
      "is this the right",
      "quick answer",
      "simple yes/no",
      "binary decision",
      "straight answer",
    ],
    emotionalStates: [
      "need quick clarity",
      "binary decision point",
      "seeking immediate guidance",
      "torn between two options",
      "need confirmation",
      "gut check needed",
      "time-sensitive decision",
    ],
    preferWhen: {
      cardCountPreference: "1",
      complexityLevel: "simple",
      experienceLevel: "any",
      timeframe: "immediate, now, today",
    },
  },
};

/**
 * 16. Quick Insight Spread Educational Content
 */
const QUICK_INSIGHT_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "The Quick Insight Spread is a streamlined two-card oracle designed for rapid clarity when time or energy is limited. Unlike the traditional three-card Past/Present/Future spread, this distills tarot wisdom into its most essential components: Situation (what is) and Advice (what to do). It's perfect for moments when you need focused guidance without extended contemplation—a spiritual espresso shot rather than a full ceremony. This spread respects the principle that sometimes less is more, offering actionable wisdom in under five minutes. The two-card structure creates a powerful before-and-after dynamic: here's where you are, here's the key to moving forward.",
    es: "La Tirada de Perspicacia Rápida es un oráculo simplificado de dos cartas diseñado para claridad rápida cuando el tiempo o la energía son limitados. A diferencia de la tirada tradicional de tres cartas Pasado/Presente/Futuro, esto destila la sabiduría del tarot en sus componentes más esenciales: Situación (qué es) y Consejo (qué hacer). Es perfecta para momentos cuando necesitas orientación enfocada sin contemplación extendida, un shot de espresso espiritual en lugar de una ceremonia completa. Esta tirada respeta el principio de que a veces menos es más, ofreciendo sabiduría accionable en menos de cinco minutos. La estructura de dos cartas crea una poderosa dinámica de antes y después: aquí es donde estás, aquí está la clave para avanzar.",
    ca: "La Tirada de Perspicàcia Ràpida és un oracle simplificat de dues cartes dissenyat per a claredat ràpida quan el temps o l'energia són limitats. A diferència de la tirada tradicional de tres cartes Passat/Present/Futur, això destil·la la saviesa del tarot en els seus components més essencials: Situació (què és) i Consell (què fer). És perfecta per a moments quan necessites orientació enfocada sense contemplació estesa, un shot d'espresso espiritual en lloc d'una cerimònia completa. Aquesta tirada respecta el principi que de vegades menys és més, oferint saviesa accionable en menys de cinc minuts. L'estructura de dues cartes crea una poderosa dinàmica d'abans i després: aquí és on estàs, aquí està la clau per avançar.",
  },
  whenToUse: {
    en: "Draw the Quick Insight Spread when you're pressed for time but still need tarot's perspective—during a lunch break, before a meeting, or when making a minor decision that doesn't warrant a full spread. It's ideal for daily check-ins, travel consultations, or when you're new to tarot and building confidence with simpler layouts. Use it when you have a specific situation that's confusing or frustrating and you need one clear action step. This spread works beautifully for relationship micro-moments (\"How should I approach this conversation?\"), career pivots (\"What's my next move in this project?\"), or creative blocks (\"What will unlock my flow?\"). It's also perfect for teaching beginners the core structure of situational analysis + guidance.",
    es: "Despliega la Tirada de Perspicacia Rápida cuando tienes poco tiempo pero aún necesitas la perspectiva del tarot: durante un descanso para almorzar, antes de una reunión, o cuando tomas una decisión menor que no justifica una tirada completa. Es ideal para chequeos diarios, consultas de viaje, o cuando eres nuevo en el tarot y estás construyendo confianza con diseños más simples. Úsala cuando tienes una situación específica que es confusa o frustrante y necesitas un paso de acción claro. Esta tirada funciona bellamente para micro-momentos de relación (\"¿Cómo debería abordar esta conversación?\"), pivotes de carrera (\"¿Cuál es mi próximo movimiento en este proyecto?\"), o bloqueos creativos (\"¿Qué desbloqueará mi flujo?\"). También es perfecta para enseñar a principiantes la estructura central de análisis situacional + orientación.",
    ca: "Desplega la Tirada de Perspicàcia Ràpida quan tens poc temps però encara necessites la perspectiva del tarot: durant un descans per dinar, abans d'una reunió, o quan prens una decisió menor que no justifica una tirada completa. És ideal per a xecs diaris, consultes de viatge, o quan ets nou al tarot i estàs construint confiança amb dissenys més simples. Usa-la quan tens una situació específica que és confusa o frustrant i necessites un pas d'acció clar. Aquesta tirada funciona bellament per a micro-moments de relació (\"Com hauria d'abordar aquesta conversa?\"), pivots de carrera (\"Quin és el meu pròxim moviment en aquest projecte?\"), o bloquejos creatius (\"Què desbloquejarà el meu flux?\"). També és perfecta per ensenyar a principiants l'estructura central d'anàlisi situacional + orientació.",
  },
  whenToAvoid: {
    en: "Skip the Quick Insight Spread when the situation is genuinely complex and requires deeper exploration—relationship crises, career crossroads, or spiritual emergencies need more comprehensive spreads like Celtic Cross or Five Card Cross. Don't use it when you're seeking validation rather than guidance (if you've already decided and just want the cards to agree, choose a different practice). Avoid this spread for questions requiring temporal context (past influences, future outcomes)—those need three or more cards. If you're in deep emotional distress, the minimalism of two cards might feel unsatisfying; honor that need for more extensive support.",
    es: "Omite la Tirada de Perspicacia Rápida cuando la situación es genuinamente compleja y requiere exploración más profunda: crisis de relación, encrucijadas de carrera o emergencias espirituales necesitan tiradas más comprehensivas como la Cruz Celta o Cruz de Cinco Cartas. No la uses cuando buscas validación en lugar de orientación (si ya has decidido y solo quieres que las cartas estén de acuerdo, elige una práctica diferente). Evita esta tirada para preguntas que requieren contexto temporal (influencias pasadas, resultados futuros): esas necesitan tres o más cartas. Si estás en angustia emocional profunda, el minimalismo de dos cartas podría sentirse insatisfactorio; honra esa necesidad de apoyo más extenso.",
    ca: "Omet la Tirada de Perspicàcia Ràpida quan la situació és genuïnament complexa i requereix exploració més profunda: crisis de relació, encreuades de carrera o emergències espirituals necessiten tirades més comprensives com la Creu Celta o Creu de Cinc Cartes. No l'usis quan cerques validació en lloc d'orientació (si ja has decidit i només vols que les cartes estiguin d'acord, tria una pràctica diferent). Evita aquesta tirada per a preguntes que requereixen context temporal (influències passades, resultats futurs): aquestes necessiten tres o més cartes. Si estàs en angoixa emocional profunda, el minimalisme de dues cartes podria sentir-se insatisfactori; honra aquesta necessitat de suport més extens.",
  },
  interpretationMethod: {
    en: "Read the two positions as a dynamic dialogue between what is and what's needed. SITUATION (position 1) reveals the current energetic reality—not what you think is happening, but what the cards see beneath the surface. Look for hidden dynamics: if you're asking about a job opportunity and draw the Eight of Swords, the situation isn't \"good opportunity,\" it's \"perceived limitation and self-imposed restriction.\" ADVICE (position 2) then offers the medicine, the key, the next step. This isn't passive fortune-telling (\"this will happen\") but active co-creation (\"this is your power move\"). The magic happens in the synthesis: Eight of Swords (trapped) + The Chariot (directed will) means \"break free through focused action.\" Read the suit dialogue: Cups to Wands suggests moving from feeling to doing; Swords to Pentacles indicates manifesting thoughts into form. Court cards as advice often represent qualities to embody or people to consult.",
    es: "Lee las dos posiciones como un diálogo dinámico entre lo que es y lo que se necesita. SITUACIÓN (posición 1) revela la realidad energética actual, no lo que crees que está sucediendo, sino lo que las cartas ven bajo la superficie. Busca dinámicas ocultas: si preguntas sobre una oportunidad laboral y extraes el Ocho de Espadas, la situación no es \"buena oportunidad,\" es \"limitación percibida y restricción autoimpuesta.\" CONSEJO (posición 2) entonces ofrece la medicina, la clave, el siguiente paso. Esto no es adivinación pasiva (\"esto sucederá\") sino co-creación activa (\"este es tu movimiento de poder\"). La magia sucede en la síntesis: Ocho de Espadas (atrapado) + El Carro (voluntad dirigida) significa \"libérate a través de acción enfocada.\" Lee el diálogo de palos: Copas a Bastos sugiere moverse del sentir al hacer; Espadas a Oros indica manifestar pensamientos en forma. Cartas de corte como consejo a menudo representan cualidades para encarnar o personas a consultar.",
    ca: "Llegeix les dues posicions com un diàleg dinàmic entre el que és i el que es necessita. SITUACIÓ (posició 1) revela la realitat energètica actual, no el que creus que està succeint, sinó el que les cartes veuen sota la superfície. Busca dinàmiques ocultes: si preguntes sobre una oportunitat laboral i extreus el Vuit d'Espases, la situació no és \"bona oportunitat,\" és \"limitació percebuda i restricció autoimposada.\" CONSELL (posició 2) després ofereix la medicina, la clau, el següent pas. Això no és endevinació passiva (\"això succeirà\") sinó co-creació activa (\"aquest és el teu moviment de poder\"). La màgia succeeix en la síntesi: Vuit d'Espases (atrapat) + El Carro (voluntat dirigida) significa \"allibera't a través d'acció enfocada.\" Llegeix el diàleg de pals: Copes a Bastos suggereix moure's del sentir al fer; Espases a Ors indica manifestar pensaments en forma. Cartes de cort com a consell sovint representen qualitats per encarnar o persones a consultar.",
  },
  traditionalOrigin: {
    en: "The Quick Insight Spread is a logical variation (🔄) of the traditional Two Card Spread, which itself derives from the universal binary structure found throughout cartomancy history. The Situation + Advice format is a modern refinement that emphasizes actionable wisdom over passive prediction. While not historically documented in classic texts like Waite's \"Pictorial Key,\" it follows the established tarot principle of problem-solution pairing found in spreads like the traditional \"Challenge & Solution\" layout. This structure appears in multiple contemporary sources and represents the modern tarot trend toward empowerment-based readings rather than deterministic fortune-telling.",
    es: "La Tirada de Perspicacia Rápida es una variación lógica (🔄) de la Tirada de Dos Cartas tradicional, que en sí deriva de la estructura binaria universal encontrada a lo largo de la historia de la cartomancia. El formato Situación + Consejo es un refinamiento moderno que enfatiza sabiduría accionable sobre predicción pasiva. Aunque no está históricamente documentada en textos clásicos como la \"Clave Pictórica\" de Waite, sigue el principio establecido del tarot de emparejamiento problema-solución encontrado en tiradas como el diseño tradicional \"Desafío & Solución\". Esta estructura aparece en múltiples fuentes contemporáneas y representa la tendencia moderna del tarot hacia lecturas basadas en empoderamiento en lugar de adivinación determinística.",
    ca: "La Tirada de Perspicàcia Ràpida és una variació lògica (🔄) de la Tirada de Dues Cartes tradicional, que en si deriva de l'estructura binària universal trobada al llarg de la història de la cartomància. El format Situació + Consell és un refinament modern que emfatitza saviesa accionable sobre predicció passiva. Tot i que no està històricament documentada en textos clàssics com la \"Clau Pictòrica\" de Waite, segueix el principi establert del tarot d'emparellament problema-solució trobat en tirades com el disseny tradicional \"Desafiament & Solució\". Aquesta estructura apareix en múltiples fonts contemporànies i representa la tendència moderna del tarot cap a lectures basades en apoderament en lloc d'endevinació determinística.",
  },
  positionInteractions: [
    {
      description: {
        en: "SITUATION → ADVICE: From Diagnosis to Remedy - The core dynamic of actionable guidance",
        es: "SITUACIÓN → CONSEJO: Del Diagnóstico al Remedio - La dinámica central de orientación accionable",
        ca: "SITUACIÓ → CONSELL: Del Diagnòstic al Remei - La dinàmica central d'orientació accionable",
      },
      positions: ["SITUATION", "ADVICE"],
      aiGuidance: "The SITUATION card names the energetic reality beneath surface appearances; the ADVICE card provides the specific action, mindset, or approach needed to navigate it. This is problem-solution pairing at its most elegant. When interpreting, always connect the two: 'Given [SITUATION card], your power move is [ADVICE card].' Look for elemental dialogue between suits—water (Cups) to fire (Wands) suggests emotional understanding leading to passionate action; air (Swords) to earth (Pentacles) indicates mental clarity manifesting in material form. If both cards share a suit, the message is particularly focused in that elemental domain. Reversed cards in SITUATION signal internal blocks; in ADVICE, they suggest releasing or inverting expectations.",
    },
  ],
  aiSelectionCriteria: {
    questionPatterns: [
      "quick reading",
      "fast guidance",
      "what should I do",
      "need advice",
      "short reading",
      "situation and advice",
      "in a hurry",
      "brief insight",
    ],
    emotionalStates: [
      "need fast clarity",
      "time-limited",
      "want focused guidance",
      "overwhelmed by complex spreads",
      "beginner seeking simplicity",
      "need actionable advice",
      "specific problem to solve",
    ],
    preferWhen: {
      cardCountPreference: "2",
      complexityLevel: "simple",
      experienceLevel: "beginner to intermediate",
      timeframe: "immediate, today, right now",
    },
  },
};

const NEW_LOVE_POTENTIAL_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread illuminates the energies and dynamics in romantic relationships. This 5-card spread provides medium level insight into love, new relationship, dating. Five cards to discover new love opportunities",
    es: "Esta spread illuminates el energies and dynamics in romantic relationships. Esta 5-card spread provides medium level insight into love, new relationship, dating. Five cards to discover new love opportunities",
    ca: "Aquesta spread illuminates el energies and dynamics in romantic relationships. Aquesta 5-card spread provides medium level insight into love, new relationship, dating. Five cards to discover new love opportunities",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and new relationship.",
    es: "Elige this spread when tú need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and new relationship.",
    ca: "Tria this spread when tu need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and new relationship.",
  },
  whenToAvoid: {
    en: "Avoid this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
    es: "Evita this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
    ca: "Evita this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and OUTCOME positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and OUTCOME positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and OUTCOME positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Your Current State and What Blocks Love reveals the core dynamic of this situation",
        es: "La relación entre Tu Estado Actual y Qué Bloquea el Amor revela la dinámica central de esta situación",
        ca: "La relació entre El Teu Estat Actual i Què Bloqueja l'Amor revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_STATE", "BLOCKS"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Opportunities Ahead to Potential Outcome shows the natural flow toward resolution",
        es: "La progresión desde Oportunidades Por Venir hasta Resultado Potencial muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Oportunitats Davant fins a Resultat Potencial mostra el flux natural cap a la resolució",
      },
      positions: ["OPPORTUNITIES", "OUTCOME"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["relationship", "love", "partner", "connection", "heart", "romance"],
    emotionalStates: ["seeking connection"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const HEALING_BREAKUP_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread illuminates the energies and dynamics in romantic relationships. This 5-card spread provides medium level insight into love, breakup, healing. Five cards to heal and move forward after heartbreak",
    es: "Esta spread illuminates el energies and dynamics in romantic relationships. Esta 5-card spread provides medium level insight into love, breakup, healing. Five cards to heal and move forward after heartbreak",
    ca: "Aquesta spread illuminates el energies and dynamics in romantic relationships. Aquesta 5-card spread provides medium level insight into love, breakup, healing. Five cards to heal and move forward after heartbreak",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and breakup.",
    es: "Elige this spread when tú need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and breakup.",
    ca: "Tria this spread when tu need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and breakup.",
  },
  whenToAvoid: {
    en: "Avoid this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
    es: "Evita this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
    ca: "Evita this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between ROOT_CAUSE and NEW_BEGINNING positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between ROOT_CAUSE and NEW_BEGINNING positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between ROOT_CAUSE and NEW_BEGINNING positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Root Cause and Lesson to Learn reveals the core dynamic of this situation",
        es: "La relación entre Causa Raíz y Lección a Aprender revela la dinámica central de esta situación",
        ca: "La relació entre Causa Arrel i Lliçó a Aprendre revela la dinàmica central d'aquesta situació",
      },
      positions: ["ROOT_CAUSE", "LESSON"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Path to Healing to New Beginning shows the natural flow toward resolution",
        es: "La progresión desde Camino hacia la Sanación hasta Nuevo Comienzo muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Camí cap a la Curació fins a Nou Començament mostra el flux natural cap a la resolució",
      },
      positions: ["HEALING", "NEW_BEGINNING"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["relationship", "love", "partner", "connection", "heart", "romance"],
    emotionalStates: ["seeking connection"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const SOULMATE_SEARCH_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread illuminates the energies and dynamics in romantic relationships. This 7-card spread provides medium level insight into love, soulmate, twin flame. Seven cards to guide you toward your soulmate",
    es: "Esta spread illuminates el energies and dynamics in romantic relationships. Esta 7-card spread provides medium level insight into love, soulmate, twin flame. Seven cards to guide you toward your soulmate",
    ca: "Aquesta spread illuminates el energies and dynamics in romantic relationships. Aquesta 7-card spread provides medium level insight into love, soulmate, twin flame. Seven cards to guide you toward your soulmate",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and soulmate.",
    es: "Elige this spread when tú need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and soulmate.",
    ca: "Tria this spread when tu need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and soulmate.",
  },
  whenToAvoid: {
    en: "Avoid this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
    es: "Evita this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
    ca: "Evita this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_ENERGY and SIGN positions.",
    es: "Lee cartas sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_ENERGY and SIGN positions.",
    ca: "Llegeix cartes sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_ENERGY and SIGN positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Your Current Energy and Blocks reveals the core dynamic of this situation",
        es: "La relación entre Tu Energía Actual y Bloqueos revela la dinámica central de esta situación",
        ca: "La relació entre La Teva Energia Actual i Bloquejos revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_ENERGY", "BLOCKS"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Where to Look to Recognition Sign shows the natural flow toward resolution",
        es: "La progresión desde Dónde Buscar hasta Señal de Reconocimiento muestra el flujo natural hacia la resolución",
        ca: "La progressió des de On Buscar fins a Senyal de Reconeixement mostra el flux natural cap a la resolució",
      },
      positions: ["WHERE", "SIGN"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["relationship", "love", "partner", "connection", "heart", "romance"],
    emotionalStates: ["seeking connection"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const COMPATIBILITY_CHECK_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread illuminates the energies and dynamics in romantic relationships. This 8-card spread provides medium level insight into love, compatibility, relationship. Eight cards to assess relationship compatibility",
    es: "Esta spread illuminates el energies and dynamics in romantic relationships. Esta 8-card spread provides medium level insight into love, compatibility, relationship. Eight cards to assess relationship compatibility",
    ca: "Aquesta spread illuminates el energies and dynamics in romantic relationships. Aquesta 8-card spread provides medium level insight into love, compatibility, relationship. Eight cards to assess relationship compatibility",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and compatibility.",
    es: "Elige this spread when tú need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and compatibility.",
    ca: "Tria this spread when tu need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and compatibility.",
  },
  whenToAvoid: {
    en: "Avoid this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
    es: "Evita this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
    ca: "Evita this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between YOU and FUTURE positions.",
    es: "Lee cartas sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between YOU and FUTURE positions.",
    ca: "Llegeix cartes sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between YOU and FUTURE positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between You and Them reveals the core dynamic of this situation",
        es: "La relación entre Tú y Ellos revela la dinámica central de esta situación",
        ca: "La relació entre Tu i Ells revela la dinàmica central d'aquesta situació",
      },
      positions: ["YOU", "THEM"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Communication to Future Together shows the natural flow toward resolution",
        es: "La progresión desde Comunicación hasta Futuro Juntos muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Comunicació fins a Futur Junts mostra el flux natural cap a la resolució",
      },
      positions: ["COMMUNICATION", "FUTURE"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["relationship", "love", "partner", "connection", "heart", "romance"],
    emotionalStates: ["seeking connection"],
    preferWhen: {
      cardCountPreference: "comprehensive",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const MARRIAGE_DECISION_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread illuminates the energies and dynamics in romantic relationships. This 7-card spread provides medium level insight into love, marriage, commitment. Seven cards to explore commitment and marriage readiness",
    es: "Esta spread illuminates el energies and dynamics in romantic relationships. Esta 7-card spread provides medium level insight into love, marriage, commitment. Seven cards to explore commitment and marriage readiness",
    ca: "Aquesta spread illuminates el energies and dynamics in romantic relationships. Aquesta 7-card spread provides medium level insight into love, marriage, commitment. Seven cards to explore commitment and marriage readiness",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and marriage.",
    es: "Elige this spread when tú need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and marriage.",
    ca: "Tria this spread when tu need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and marriage.",
  },
  whenToAvoid: {
    en: "Avoid this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
    es: "Evita this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
    ca: "Evita this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_FOUNDATION and OUTCOME positions.",
    es: "Lee cartas sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_FOUNDATION and OUTCOME positions.",
    ca: "Llegeix cartes sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_FOUNDATION and OUTCOME positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current Foundation and Your Readiness reveals the core dynamic of this situation",
        es: "La relación entre Fundamento Actual y Tu Preparación revela la dinámica central de esta situación",
        ca: "La relació entre Fonament Actual i La Teva Preparació revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_FOUNDATION", "YOUR_READINESS"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Potential Challenges to Likely Outcome shows the natural flow toward resolution",
        es: "La progresión desde Desafíos Potenciales hasta Resultado Probable muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Desafiaments Potencials fins a Resultat Probable mostra el flux natural cap a la resolució",
      },
      positions: ["CHALLENGES", "OUTCOME"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["relationship", "love", "partner", "connection", "heart", "romance"],
    emotionalStates: ["seeking connection"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const DATING_GUIDANCE_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread illuminates the energies and dynamics in romantic relationships. This 4-card spread provides simple level insight into love, dating, new relationship. Four cards for navigating the dating world",
    es: "Esta spread illuminates el energies and dynamics in romantic relationships. Esta 4-card spread provides simple level insight into love, dating, new relationship. Four cards for navigating el dating world",
    ca: "Aquesta spread illuminates el energies and dynamics in romantic relationships. Aquesta 4-card spread provides simple level insight into love, dating, new relationship. Four cards for navigating el dating world",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on relationship, love, partner matters. Ideal for quick insight and clarity. Perfect for questions about love and dating.",
    es: "Elige this spread when tú need guidance on relationship, love, partner matters. Ideal for quick insight and clarity. Perfect for questions about love and dating.",
    ca: "Tria this spread when tu need guidance on relationship, love, partner matters. Ideal for quick insight and clarity. Perfect for questions about love and dating.",
  },
  whenToAvoid: {
    en: "Avoid this spread for career decisions, financial planning, health issues. If you need more detailed analysis, consider a medium or complex spread.",
    es: "Evita this spread for career decisions, financial planning, health issues. If you need more detailed analysis, consider a medium or complex spread.",
    ca: "Evita this spread for career decisions, financial planning, health issues. If you need more detailed analysis, consider a medium or complex spread.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 4, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between YOU_NOW and NEXT_STEP positions.",
    es: "Lee cartas sequentially from position 1 to 4, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between YOU_NOW and NEXT_STEP positions.",
    ca: "Llegeix cartes sequentially from position 1 to 4, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between YOU_NOW and NEXT_STEP positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between You Right Now and This Person's Potential reveals the core dynamic of this situation",
        es: "La relación entre Tú Ahora Mismo y Potencial de Esta Persona revela la dinámica central de esta situación",
        ca: "La relació entre Tu Ara Mateix i Potencial d'Aquesta Persona revela la dinàmica central d'aquesta situació",
      },
      positions: ["YOU_NOW", "POTENTIAL"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["relationship", "love", "partner", "connection", "heart", "romance"],
    emotionalStates: ["seeking connection"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "simple",
      experienceLevel: "beginner",
      timeframe: "medium-term",
    },
  },
};


const TOXIC_RELATIONSHIP_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread illuminates the energies and dynamics in romantic relationships. This 6-card spread provides medium level insight into love, toxic, unhealthy. Six cards to understand and heal from toxic patterns",
    es: "Esta spread illuminates el energies and dynamics in romantic relationships. Esta 6-card spread provides medium level insight into love, toxic, unhealthy. Six cards to understand and heal from toxic patterns",
    ca: "Aquesta spread illuminates el energies and dynamics in romantic relationships. Aquesta 6-card spread provides medium level insight into love, toxic, unhealthy. Six cards to understand and heal from toxic patterns",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and toxic.",
    es: "Elige this spread when tú need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and toxic.",
    ca: "Tria this spread when tu need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and toxic.",
  },
  whenToAvoid: {
    en: "Avoid this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
    es: "Evita this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
    ca: "Evita this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between PATTERN and FUTURE_PATH positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between PATTERN and FUTURE_PATH positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between PATTERN and FUTURE_PATH positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Toxic Pattern and Your Role reveals the core dynamic of this situation",
        es: "La relación entre Patrón Tóxico y Tu Rol revela la dinámica central de esta situación",
        ca: "La relació entre Patró Tòxic i El Teu Rol revela la dinàmica central d'aquesta situació",
      },
      positions: ["PATTERN", "YOUR_ROLE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Core Wound to Healthy Path Forward shows the natural flow toward resolution",
        es: "La progresión desde Herida Central hasta Camino Saludable Adelante muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Ferida Central fins a Camí Saludable Endavant mostra el flux natural cap a la resolució",
      },
      positions: ["WOUND", "FUTURE_PATH"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["relationship", "love", "partner", "connection", "heart", "romance"],
    emotionalStates: ["seeking connection"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const SELF_LOVE_JOURNEY_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread illuminates the energies and dynamics in romantic relationships. This 5-card spread provides medium level insight into love, self-love, self-care. Five cards to cultivate self-love and acceptance",
    es: "Esta spread illuminates el energies and dynamics in romantic relationships. Esta 5-card spread provides medium level insight into love, self-love, self-care. Five cards to cultivate self-love and acceptance",
    ca: "Aquesta spread illuminates el energies and dynamics in romantic relationships. Aquesta 5-card spread provides medium level insight into love, self-love, self-care. Five cards to cultivate self-love and acceptance",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and self-love.",
    es: "Elige this spread when tú need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and self-love.",
    ca: "Tria this spread when tu need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and self-love.",
  },
  whenToAvoid: {
    en: "Avoid this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
    es: "Evita this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
    ca: "Evita this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and TRANSFORMATION positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and TRANSFORMATION positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and TRANSFORMATION positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current Self-Love State and Wounds to Heal reveals the core dynamic of this situation",
        es: "La relación entre Estado Actual de Amor Propio y Heridas a Sanar revela la dinámica central de esta situación",
        ca: "La relació entre Estat Actual d'Amor Propi i Ferides a Curar revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_STATE", "WOUNDS"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Your Strengths to Transformation shows the natural flow toward resolution",
        es: "La progresión desde Tus Fortalezas hasta Transformación muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Les Teves Fortaleses fins a Transformació mostra el flux natural cap a la resolució",
      },
      positions: ["STRENGTHS", "TRANSFORMATION"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["relationship", "love", "partner", "connection", "heart", "romance"],
    emotionalStates: ["seeking connection"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const INTIMACY_ISSUES_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread illuminates the energies and dynamics in romantic relationships. This 6-card spread provides medium level insight into love, intimacy, connection. Six cards to deepen intimacy and connection",
    es: "Esta spread illuminates el energies and dynamics in romantic relationships. Esta 6-card spread provides medium level insight into love, intimacy, connection. Six cards to deepen intimacy and connection",
    ca: "Aquesta spread illuminates el energies and dynamics in romantic relationships. Aquesta 6-card spread provides medium level insight into love, intimacy, connection. Six cards to deepen intimacy and connection",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and intimacy.",
    es: "Elige this spread when tú need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and intimacy.",
    ca: "Tria this spread when tu need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and intimacy.",
  },
  whenToAvoid: {
    en: "Avoid this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
    es: "Evita this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
    ca: "Evita this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between ISSUE and DEEPENING positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between ISSUE and DEEPENING positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between ISSUE and DEEPENING positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Core Issue and Your Fear reveals the core dynamic of this situation",
        es: "La relación entre Problema Central y Tu Miedo revela la dinámica central de esta situación",
        ca: "La relació entre Problema Central i La Teva Por revela la dinàmica central d'aquesta situació",
      },
      positions: ["ISSUE", "YOUR_FEAR"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Building Bridge to Deepening Intimacy shows the natural flow toward resolution",
        es: "La progresión desde Construir Puente hasta Profundizar Intimidad muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Construir Pont fins a Aprofundir Intimitat mostra el flux natural cap a la resolució",
      },
      positions: ["BRIDGE", "DEEPENING"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["relationship", "love", "partner", "connection", "heart", "romance"],
    emotionalStates: ["seeking connection"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const PARTNERSHIP_BALANCE_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread illuminates the energies and dynamics in romantic relationships. This 6-card spread provides medium level insight into love, balance, partnership. Six cards to restore balance in your relationship",
    es: "Esta spread illuminates el energies and dynamics in romantic relationships. Esta 6-card spread provides medium level insight into love, balance, partnership. Six cards to restore balance in your relationship",
    ca: "Aquesta spread illuminates el energies and dynamics in romantic relationships. Aquesta 6-card spread provides medium level insight into love, balance, partnership. Six cards to restore balance in your relationship",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and balance.",
    es: "Elige this spread when tú need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and balance.",
    ca: "Tria this spread when tu need guidance on relationship, love, partner matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about love and balance.",
  },
  whenToAvoid: {
    en: "Avoid this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
    es: "Evita this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
    ca: "Evita this spread for career decisions, financial planning, health issues. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between GIVE and HARMONY positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between GIVE and HARMONY positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between GIVE and HARMONY positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between What You Give and What You Receive reveals the core dynamic of this situation",
        es: "La relación entre Lo Que Das y Lo Que Recibes revela la dinámica central de esta situación",
        ca: "La relació entre El Que Dones i El Que Reps revela la dinàmica central d'aquesta situació",
      },
      positions: ["GIVE", "RECEIVE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Needed Adjustment to Path to Harmony shows the natural flow toward resolution",
        es: "La progresión desde Ajuste Necesario hasta Camino hacia la Armonía muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Ajust Necessari fins a Camí cap a l'Harmonia mostra el flux natural cap a la resolució",
      },
      positions: ["ADJUSTMENT", "HARMONY"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["relationship", "love", "partner", "connection", "heart", "romance"],
    emotionalStates: ["seeking connection"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const LOVE_TRIANGLE_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread illuminates the energies and dynamics in romantic relationships. This 9-card spread provides complex level insight into love, choice, decision. Nine cards to navigate complex love situations",
    es: "Esta spread illuminates el energies and dynamics in romantic relationships. Esta 9-card spread provides complex level insight into love, choice, decision. Nine cards to navigate complex love situations",
    ca: "Aquesta spread illuminates el energies and dynamics in romantic relationships. Aquesta 9-card spread provides complex level insight into love, choice, decision. Nine cards to navigate complex love situations",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on relationship, love, partner matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about love and choice.",
    es: "Elige this spread when tú need guidance on relationship, love, partner matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about love and choice.",
    ca: "Tria this spread when tu need guidance on relationship, love, partner matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about love and choice.",
  },
  whenToAvoid: {
    en: "Avoid this spread for career decisions, financial planning, health issues. If you need quick simple answers, use a simpler spread instead.",
    es: "Evita this spread for career decisions, financial planning, health issues. If you need quick simple answers, use a simpler spread instead.",
    ca: "Evita this spread for career decisions, financial planning, health issues. If you need quick simple answers, use a simpler spread instead.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 9, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between YOU and GUIDANCE positions.",
    es: "Lee cartas sequentially from position 1 to 9, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between YOU and GUIDANCE positions.",
    ca: "Llegeix cartes sequentially from position 1 to 9, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between YOU and GUIDANCE positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between You and Person A reveals the core dynamic of this situation",
        es: "La relación entre Tú y Persona A revela la dinámica central de esta situación",
        ca: "La relació entre Tu i Persona A revela la dinàmica central d'aquesta situació",
      },
      positions: ["YOU", "PERSON_A"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from You & Person B to Guidance shows the natural flow toward resolution",
        es: "La progresión desde Tú y Persona B hasta Guía muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Tu i Persona B fins a Guia mostra el flux natural cap a la resolució",
      },
      positions: ["DYNAMIC_B", "GUIDANCE"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["relationship", "love", "partner", "connection", "heart", "romance"],
    emotionalStates: ["seeking connection"],
    preferWhen: {
      cardCountPreference: "comprehensive",
      complexityLevel: "complex",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const JOB_SEARCH_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread reveals professional path, work dynamics, and career development. This 5-card spread provides medium level insight into career, job, search. Navigate your job search with clarity on your strengths and timing",
    es: "Esta spread reveals professional path, work dynamics, and career development. Esta 5-card spread provides medium level insight into career, job, search. Navigate your job search with clarity on your strengths and timing",
    ca: "Aquesta spread reveals professional path, work dynamics, and career development. Aquesta 5-card spread provides medium level insight into career, job, search. Navigate your job search with clarity on your strengths and timing",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about career and job.",
    es: "Elige this spread when tú need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about career and job.",
    ca: "Tria this spread when tu need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about career and job.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    es: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_POSITION and OUTCOME positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_POSITION and OUTCOME positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_POSITION and OUTCOME positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current Position and Skills to Highlight reveals the core dynamic of this situation",
        es: "La relación entre Posición Actual y Habilidades a Destacar revela la dinámica central de esta situación",
        ca: "La relació entre Posició Actual i Habilitats a Destacar revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_POSITION", "SKILLS"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Where Opportunities Lie to Likely Outcome shows the natural flow toward resolution",
        es: "La progresión desde Dónde Hay Oportunidades hasta Resultado Probable muestra el flujo natural hacia la resolución",
        ca: "La progressió des de On Hi Ha Oportunitats fins a Resultat Probable mostra el flux natural cap a la resolució",
      },
      positions: ["OPPORTUNITIES", "OUTCOME"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["job", "career", "work", "professional", "vocation", "colleagues"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const INTERVIEW_PREP_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread reveals professional path, work dynamics, and career development. This 4-card spread provides simple level insight into interview, job, career. Get ready for your interview with insights on strengths and expectations",
    es: "Esta spread reveals professional path, work dynamics, and career development. Esta 4-card spread provides simple level insight into interview, job, career. Get ready for your interview with insights on strengths and expectations",
    ca: "Aquesta spread reveals professional path, work dynamics, and career development. Aquesta 4-card spread provides simple level insight into interview, job, career. Get ready for your interview with insights on strengths and expectations",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on job, career, work matters. Ideal for quick insight and clarity. Perfect for questions about interview and job.",
    es: "Elige this spread when tú need guidance on job, career, work matters. Ideal for quick insight and clarity. Perfect for questions about interview and job.",
    ca: "Tria this spread when tu need guidance on job, career, work matters. Ideal for quick insight and clarity. Perfect for questions about interview and job.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep emotional healing, relationship matters, health diagnosis. If you need more detailed analysis, consider a medium or complex spread.",
    es: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need more detailed analysis, consider a medium or complex spread.",
    ca: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need more detailed analysis, consider a medium or complex spread.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 4, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between YOUR_STRENGTH and OUTCOME positions.",
    es: "Lee cartas sequentially from position 1 to 4, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between YOUR_STRENGTH and OUTCOME positions.",
    ca: "Llegeix cartes sequentially from position 1 to 4, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between YOUR_STRENGTH and OUTCOME positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Your Strength and What They Need reveals the core dynamic of this situation",
        es: "La relación entre Tu Fortaleza y Lo Que Necesitan revela la dinámica central de esta situación",
        ca: "La relació entre La Teva Fortalesa i El Que Necessiten revela la dinàmica central d'aquesta situació",
      },
      positions: ["YOUR_STRENGTH", "THEIR_NEEDS"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["job", "career", "work", "professional", "vocation", "colleagues"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "simple",
      experienceLevel: "beginner",
      timeframe: "medium-term",
    },
  },
};


const PROMOTION_PATH_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread reveals professional path, work dynamics, and career development. This 6-card spread provides medium level insight into promotion, career, advancement. Map your path to advancement with clarity on gaps and timing",
    es: "Esta spread reveals professional path, work dynamics, and career development. Esta 6-card spread provides medium level insight into promotion, career, advancement. Map your path to advancement with clarity on gaps and timing",
    ca: "Aquesta spread reveals professional path, work dynamics, and career development. Aquesta 6-card spread provides medium level insight into promotion, career, advancement. Map your path to advancement with clarity on gaps and timing",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about promotion and career.",
    es: "Elige this spread when tú need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about promotion and career.",
    ca: "Tria this spread when tu need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about promotion and career.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    es: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STANDING and PATH positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STANDING and PATH positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STANDING and PATH positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current Standing and Your Strengths reveals the core dynamic of this situation",
        es: "La relación entre Posición Actual y Tus Fortalezas revela la dinámica central de esta situación",
        ca: "La relació entre Posició Actual i Les Teves Fortaleses revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_STANDING", "STRENGTHS"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Increasing Visibility to Path to Promotion shows the natural flow toward resolution",
        es: "La progresión desde Aumentar Visibilidad hasta Camino hacia la Promoción muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Augmentar Visibilitat fins a Camí cap a la Promoció mostra el flux natural cap a la resolució",
      },
      positions: ["VISIBILITY", "PATH"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["job", "career", "work", "professional", "vocation", "colleagues"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const CAREER_CHANGE_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread reveals professional path, work dynamics, and career development. This 7-card spread provides medium level insight into career, change, transition. Navigate a major career transition with insight into your calling and obstacles",
    es: "Esta spread reveals professional path, work dynamics, and career development. Esta 7-card spread provides medium level insight into career, change, transition. Navigate a major career transition with insight into your calling and obstacles",
    ca: "Aquesta spread reveals professional path, work dynamics, and career development. Aquesta 7-card spread provides medium level insight into career, change, transition. Navigate a major career transition with insight into your calling and obstacles",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about career and change.",
    es: "Elige this spread when tú need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about career and change.",
    ca: "Tria this spread when tu need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about career and change.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    es: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_DISSATISFACTION and OUTCOME positions.",
    es: "Lee cartas sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_DISSATISFACTION and OUTCOME positions.",
    ca: "Llegeix cartes sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_DISSATISFACTION and OUTCOME positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current Dissatisfaction and True Calling reveals the core dynamic of this situation",
        es: "La relación entre Insatisfacción Actual y Vocación Verdadera revela la dinámica central de esta situación",
        ca: "La relació entre Insatisfacció Actual i Vocació Veritable revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_DISSATISFACTION", "TRUE_CALLING"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Obstacles to Potential Outcome shows the natural flow toward resolution",
        es: "La progresión desde Obstáculos hasta Resultado Potencial muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Obstacles fins a Resultat Potencial mostra el flux natural cap a la resolució",
      },
      positions: ["OBSTACLES", "OUTCOME"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["job", "career", "work", "professional", "vocation", "colleagues"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const WORK_CONFLICTS_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread reveals professional path, work dynamics, and career development. This 5-card spread provides medium level insight into conflict, work, tension. Resolve workplace tensions with understanding of root causes and solutions",
    es: "Esta spread reveals professional path, work dynamics, and career development. Esta 5-card spread provides medium level insight into conflict, work, tension. Resolve workplace tensions with understanding of root causes and solutions",
    ca: "Aquesta spread reveals professional path, work dynamics, and career development. Aquesta 5-card spread provides medium level insight into conflict, work, tension. Resolve workplace tensions with understanding of root causes and solutions",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about conflict and work.",
    es: "Elige this spread when tú need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about conflict and work.",
    ca: "Tria this spread when tu need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about conflict and work.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    es: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between ROOT_CAUSE and OUTCOME positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between ROOT_CAUSE and OUTCOME positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between ROOT_CAUSE and OUTCOME positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Root Cause and Your Role reveals the core dynamic of this situation",
        es: "La relación entre Causa Raíz y Tu Rol revela la dinámica central de esta situación",
        ca: "La relació entre Causa Arrel i El Teu Rol revela la dinàmica central d'aquesta situació",
      },
      positions: ["ROOT_CAUSE", "YOUR_ROLE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Their Perspective to Likely Outcome shows the natural flow toward resolution",
        es: "La progresión desde Su Perspectiva hasta Resultado Probable muestra el flujo natural hacia la resolución",
        ca: "La progressió des de La Seva Perspectiva fins a Resultat Probable mostra el flux natural cap a la resolució",
      },
      positions: ["THEIR_PERSPECTIVE", "OUTCOME"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["job", "career", "work", "professional", "vocation", "colleagues"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const TEAM_DYNAMICS_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread reveals professional path, work dynamics, and career development. This 6-card spread provides medium level insight into team, collaboration, work. Understand and improve your team relationships and collaboration",
    es: "Esta spread reveals professional path, work dynamics, and career development. Esta 6-card spread provides medium level insight into team, collaboration, work. Understand and improve your team relationships and collaboration",
    ca: "Aquesta spread reveals professional path, work dynamics, and career development. Aquesta 6-card spread provides medium level insight into team, collaboration, work. Understand and improve your team relationships and collaboration",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about team and collaboration.",
    es: "Elige this spread when tú need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about team and collaboration.",
    ca: "Tria this spread when tu need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about team and collaboration.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    es: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between TEAM_ENERGY and HARMONY positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between TEAM_ENERGY and HARMONY positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between TEAM_ENERGY and HARMONY positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Team Energy and Your Contribution reveals the core dynamic of this situation",
        es: "La relación entre Energía del Equipo y Tu Contribución revela la dinámica central de esta situación",
        ca: "La relació entre Energia de l'Equip i La Teva Contribució revela la dinàmica central d'aquesta situació",
      },
      positions: ["TEAM_ENERGY", "YOUR_CONTRIBUTION"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Challenges to Creating Harmony shows the natural flow toward resolution",
        es: "La progresión desde Desafíos hasta Crear Armonía muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Desafiaments fins a Crear Harmonia mostra el flux natural cap a la resolució",
      },
      positions: ["CHALLENGES", "HARMONY"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["job", "career", "work", "professional", "vocation", "colleagues"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const ENTREPRENEURSHIP_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread reveals professional path, work dynamics, and career development. This 8-card spread provides complex level insight into entrepreneurship, business, startup. Comprehensive guidance for starting your own business venture",
    es: "Esta spread reveals professional path, work dynamics, and career development. Esta 8-card spread provides complex level insight into entrepreneurship, business, startup. Comprehensive guidance for starting your own business venture",
    ca: "Aquesta spread reveals professional path, work dynamics, and career development. Aquesta 8-card spread provides complex level insight into entrepreneurship, business, startup. Comprehensive guidance for starting your own business venture",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on job, career, work matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about entrepreneurship and business.",
    es: "Elige this spread when tú need guidance on job, career, work matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about entrepreneurship and business.",
    ca: "Tria this spread when tu need guidance on job, career, work matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about entrepreneurship and business.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep emotional healing, relationship matters, health diagnosis. If you need quick simple answers, use a simpler spread instead.",
    es: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need quick simple answers, use a simpler spread instead.",
    ca: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need quick simple answers, use a simpler spread instead.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between VISION and SUCCESS positions.",
    es: "Lee cartas sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between VISION and SUCCESS positions.",
    ca: "Llegeix cartes sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between VISION and SUCCESS positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Your Vision and Available Resources reveals the core dynamic of this situation",
        es: "La relación entre Tu Visión y Recursos Disponibles revela la dinámica central de esta situación",
        ca: "La relació entre La Teva Visió i Recursos Disponibles revela la dinàmica central d'aquesta situació",
      },
      positions: ["VISION", "RESOURCES"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Challenges Ahead to Path to Success shows the natural flow toward resolution",
        es: "La progresión desde Desafíos por Delante hasta Camino al Éxito muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Reptes per Davant fins a Camí cap a l'Èxit mostra el flux natural cap a la resolució",
      },
      positions: ["CHALLENGES", "SUCCESS"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["job", "career", "work", "professional", "vocation", "colleagues"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "comprehensive",
      complexityLevel: "complex",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const SIDE_HUSTLE_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread reveals professional path, work dynamics, and career development. This 5-card spread provides medium level insight into side-hustle, passion-project, extra-income. Explore turning your passion into a profitable side business",
    es: "Esta spread reveals professional path, work dynamics, and career development. Esta 5-card spread provides medium level insight into side-hustle, passion-project, extra-income. Explore turning your passion into a profitable side business",
    ca: "Aquesta spread reveals professional path, work dynamics, and career development. Aquesta 5-card spread provides medium level insight into side-hustle, passion-project, extra-income. Explore turning your passion into a profitable side business",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about side-hustle and passion-project.",
    es: "Elige this spread when tú need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about side-hustle and passion-project.",
    ca: "Tria this spread when tu need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about side-hustle and passion-project.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    es: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between PASSION and POTENTIAL positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between PASSION and POTENTIAL positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between PASSION and POTENTIAL positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Your Passion and Viability reveals the core dynamic of this situation",
        es: "La relación entre Tu Pasión y Viabilidad revela la dinámica central de esta situación",
        ca: "La relació entre La Teva Passió i Viabilitat revela la dinàmica central d'aquesta situació",
      },
      positions: ["PASSION", "VIABLE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Work-Life Balance to Growth Potential shows the natural flow toward resolution",
        es: "La progresión desde Equilibrio Vida-Trabajo hasta Potencial de Crecimiento muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Equilibri Vida-Treball fins a Potencial de Creixement mostra el flux natural cap a la resolució",
      },
      positions: ["BALANCE", "POTENTIAL"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["job", "career", "work", "professional", "vocation", "colleagues"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const WORK_LIFE_BALANCE_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread reveals professional path, work dynamics, and career development. This 7-card spread provides medium level insight into work-life-balance, burnout, boundaries. Find harmony between professional demands and personal wellbeing",
    es: "Esta spread reveals professional path, work dynamics, and career development. Esta 7-card spread provides medium level insight into work-life-balance, burnout, boundaries. Find harmony between professional demands and personal wellbeing",
    ca: "Aquesta spread reveals professional path, work dynamics, and career development. Aquesta 7-card spread provides medium level insight into work-life-balance, burnout, boundaries. Find harmony between professional demands and personal wellbeing",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about work-life-balance and burnout.",
    es: "Elige this spread when tú need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about work-life-balance and burnout.",
    ca: "Tria this spread when tu need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about work-life-balance and burnout.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    es: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and HARMONY positions.",
    es: "Lee cartas sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and HARMONY positions.",
    ca: "Llegeix cartes sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and HARMONY positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current State and Work Demands reveals the core dynamic of this situation",
        es: "La relación entre Estado Actual y Demandas Laborales revela la dinámica central de esta situación",
        ca: "La relació entre Estat Actual i Demandes Laborals revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_STATE", "WORK_DEMANDS"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from What You're Sacrificing to Path to Harmony shows the natural flow toward resolution",
        es: "La progresión desde Lo Que Estás Sacrificando hasta Camino a la Armonía muestra el flujo natural hacia la resolución",
        ca: "La progressió des de El Que Estàs Sacrificant fins a Camí cap a l'Harmonia mostra el flux natural cap a la resolució",
      },
      positions: ["SACRIFICE", "HARMONY"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["job", "career", "work", "professional", "vocation", "colleagues"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const CAREER_PURPOSE_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread reveals professional path, work dynamics, and career development. This 6-card spread provides medium level insight into purpose, calling, fulfillment. Discover your true calling and align your career with your soul purpose",
    es: "Esta spread reveals professional path, work dynamics, and career development. Esta 6-card spread provides medium level insight into purpose, calling, fulfillment. Discover your true calling and align your career with your soul purpose",
    ca: "Aquesta spread reveals professional path, work dynamics, and career development. Aquesta 6-card spread provides medium level insight into purpose, calling, fulfillment. Discover your true calling and align your career with your soul purpose",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about purpose and calling.",
    es: "Elige this spread when tú need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about purpose and calling.",
    ca: "Tria this spread when tu need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about purpose and calling.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    es: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_PATH and FULFILLMENT positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_PATH and FULFILLMENT positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_PATH and FULFILLMENT positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current Path and Your True Gifts reveals the core dynamic of this situation",
        es: "La relación entre Camino Actual y Tus Verdaderos Dones revela la dinámica central de esta situación",
        ca: "La relació entre Camí Actual i Els Teus Veritables Dons revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_PATH", "TRUE_GIFTS"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Creating Alignment to Path to Fulfillment shows the natural flow toward resolution",
        es: "La progresión desde Crear Alineación hasta Camino a la Realización muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Crear Alineació fins a Camí cap a la Realització mostra el flux natural cap a la resolució",
      },
      positions: ["ALIGNMENT", "FULFILLMENT"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["job", "career", "work", "professional", "vocation", "colleagues"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const NEGOTIATION_STRATEGY_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread reveals professional path, work dynamics, and career development. This 5-card spread provides medium level insight into negotiation, salary, deal. Strategic guidance for salary negotiations and professional deals",
    es: "Esta spread reveals professional path, work dynamics, and career development. Esta 5-card spread provides medium level insight into negotiation, salary, deal. Strategic guidance for salary negotiations and professional deals",
    ca: "Aquesta spread reveals professional path, work dynamics, and career development. Aquesta 5-card spread provides medium level insight into negotiation, salary, deal. Strategic guidance for salary negotiations and professional deals",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about negotiation and salary.",
    es: "Elige this spread when tú need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about negotiation and salary.",
    ca: "Tria this spread when tu need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about negotiation and salary.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    es: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between YOUR_POSITION and OUTCOME positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between YOUR_POSITION and OUTCOME positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between YOUR_POSITION and OUTCOME positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Your Position and Their Position reveals the core dynamic of this situation",
        es: "La relación entre Tu Posición y Su Posición revela la dinámica central de esta situación",
        ca: "La relació entre La Teva Posició i La Seva Posició revela la dinàmica central d'aquesta situació",
      },
      positions: ["YOUR_POSITION", "THEIR_POSITION"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Your Leverage to Likely Outcome shows the natural flow toward resolution",
        es: "La progresión desde Tu Ventaja hasta Resultado Probable muestra el flujo natural hacia la resolución",
        ca: "La progressió des de El Teu Avantatge fins a Resultat Probable mostra el flux natural cap a la resolució",
      },
      positions: ["LEVERAGE", "OUTCOME"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["job", "career", "work", "professional", "vocation", "colleagues"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const PROFESSIONAL_GROWTH_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread reveals professional path, work dynamics, and career development. This 6-card spread provides medium level insight into growth, development, learning. Chart your path to mastery and professional development",
    es: "Esta spread reveals professional path, work dynamics, and career development. Esta 6-card spread provides medium level insight into growth, development, learning. Chart your path to mastery and professional development",
    ca: "Aquesta spread reveals professional path, work dynamics, and career development. Aquesta 6-card spread provides medium level insight into growth, development, learning. Chart your path to mastery and professional development",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about growth and development.",
    es: "Elige this spread when tú need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about growth and development.",
    ca: "Tria this spread when tu need guidance on job, career, work matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about growth and development.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    es: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep emotional healing, relationship matters, health diagnosis. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_SKILLS and MASTERY positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_SKILLS and MASTERY positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_SKILLS and MASTERY positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current Skills and Growth Area reveals the core dynamic of this situation",
        es: "La relación entre Habilidades Actuales y Área de Crecimiento revela la dinámica central de esta situación",
        ca: "La relació entre Habilitats Actuals i Àrea de Creixement revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_SKILLS", "GROWTH_AREA"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Mentor/Resource to Path to Mastery shows the natural flow toward resolution",
        es: "La progresión desde Mentor/Recurso hasta Camino a la Maestría muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Mentor/Recurs fins a Camí cap a la Mestria mostra el flux natural cap a la resolució",
      },
      positions: ["MENTOR", "MASTERY"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["job", "career", "work", "professional", "vocation", "colleagues"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const FINANCIAL_OVERVIEW_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines financial energies, money flow, and material resources. This 5-card spread provides medium level insight into finance, money, budget. Comprehensive view of your current financial situation and opportunities",
    es: "Esta spread examines financial energies, money flow, and material resources. Esta 5-card spread provides medium level insight into finance, money, budget. Comprehensive view of your current financial situation and opportunities",
    ca: "Aquesta spread examines financial energies, money flow, and material resources. Aquesta 5-card spread provides medium level insight into finance, money, budget. Comprehensive view of your current financial situation and opportunities",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about finance and money.",
    es: "Elige this spread when tú need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about finance and money.",
    ca: "Tria this spread when tu need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about finance and money.",
  },
  whenToAvoid: {
    en: "Avoid this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
    es: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
    ca: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and ADVICE positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and ADVICE positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and ADVICE positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current Financial State and Income Flow reveals the core dynamic of this situation",
        es: "La relación entre Estado Financiero Actual y Flujo de Ingresos revela la dinámica central de esta situación",
        ca: "La relació entre Estat Financer Actual i Flux d'Ingressos revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_STATE", "INCOME"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Expense Patterns to Guidance shows the natural flow toward resolution",
        es: "La progresión desde Patrones de Gastos hasta Consejo muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Patrons de Despeses fins a Consell mostra el flux natural cap a la resolució",
      },
      positions: ["EXPENSES", "ADVICE"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["money", "finances", "income", "savings", "investment", "abundance"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const INVESTMENT_DECISION_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines financial energies, money flow, and material resources. This 6-card spread provides medium level insight into investment, finance, decision. Evaluate investment opportunities with insight into risks and potential",
    es: "Esta spread examines financial energies, money flow, and material resources. Esta 6-card spread provides medium level insight into investment, finance, decision. Evaluate investment opportunities with insight into risks and potential",
    ca: "Aquesta spread examines financial energies, money flow, and material resources. Aquesta 6-card spread provides medium level insight into investment, finance, decision. Evaluate investment opportunities with insight into risks and potential",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about investment and finance.",
    es: "Elige this spread when tú need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about investment and finance.",
    ca: "Tria this spread when tu need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about investment and finance.",
  },
  whenToAvoid: {
    en: "Avoid this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
    es: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
    ca: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between OPPORTUNITY and OUTCOME positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between OPPORTUNITY and OUTCOME positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between OPPORTUNITY and OUTCOME positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between The Opportunity and Growth Potential reveals the core dynamic of this situation",
        es: "La relación entre La Oportunidad y Potencial de Crecimiento revela la dinámica central de esta situación",
        ca: "La relació entre L'Oportunitat i Potencial de Creixement revela la dinàmica central d'aquesta situació",
      },
      positions: ["OPPORTUNITY", "POTENTIAL"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Timing to Likely Outcome shows the natural flow toward resolution",
        es: "La progresión desde Momento hasta Resultado Probable muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Moment fins a Resultat Probable mostra el flux natural cap a la resolució",
      },
      positions: ["TIMING", "OUTCOME"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["money", "finances", "income", "savings", "investment", "abundance"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const DEBT_MANAGEMENT_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines financial energies, money flow, and material resources. This 5-card spread provides medium level insight into debt, finance, freedom. Navigate your debt with clarity on causes and path to freedom",
    es: "Esta spread examines financial energies, money flow, and material resources. Esta 5-card spread provides medium level insight into debt, finance, freedom. Navigate your debt with clarity on causes and path to freedom",
    ca: "Aquesta spread examines financial energies, money flow, and material resources. Aquesta 5-card spread provides medium level insight into debt, finance, freedom. Navigate your debt with clarity on causes and path to freedom",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about debt and finance.",
    es: "Elige this spread when tú need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about debt and finance.",
    ca: "Tria this spread when tu need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about debt and finance.",
  },
  whenToAvoid: {
    en: "Avoid this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
    es: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
    ca: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between DEBT_ROOT and FREEDOM positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between DEBT_ROOT and FREEDOM positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between DEBT_ROOT and FREEDOM positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Root of Debt and Spending Patterns reveals the core dynamic of this situation",
        es: "La relación entre Raíz de la Deuda y Patrones de Gasto revela la dinámica central de esta situación",
        ca: "La relació entre Arrel del Deute i Patrons de Despesa revela la dinàmica central d'aquesta situació",
      },
      positions: ["DEBT_ROOT", "PATTERNS"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Priority Action to Path to Freedom shows the natural flow toward resolution",
        es: "La progresión desde Acción Prioritaria hasta Camino hacia la Libertad muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Acció Prioritària fins a Camí cap a la Llibertat mostra el flux natural cap a la resolució",
      },
      positions: ["PRIORITY", "FREEDOM"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["money", "finances", "income", "savings", "investment", "abundance"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const SALARY_NEGOTIATION_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines financial energies, money flow, and material resources. This 4-card spread provides simple level insight into salary, negotiation, raise. Prepare for salary discussions with insight into value and approach",
    es: "Esta spread examines financial energies, money flow, and material resources. Esta 4-card spread provides simple level insight into salary, negotiation, raise. Prepare for salary discussions with insight into value and approach",
    ca: "Aquesta spread examines financial energies, money flow, and material resources. Aquesta 4-card spread provides simple level insight into salary, negotiation, raise. Prepare for salary discussions with insight into value and approach",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on money, finances, income matters. Ideal for quick insight and clarity. Perfect for questions about salary and negotiation.",
    es: "Elige this spread when tú need guidance on money, finances, income matters. Ideal for quick insight and clarity. Perfect for questions about salary and negotiation.",
    ca: "Tria this spread when tu need guidance on money, finances, income matters. Ideal for quick insight and clarity. Perfect for questions about salary and negotiation.",
  },
  whenToAvoid: {
    en: "Avoid this spread for relationship counseling, career path discovery, spiritual awakening. If you need more detailed analysis, consider a medium or complex spread.",
    es: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need more detailed analysis, consider a medium or complex spread.",
    ca: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need more detailed analysis, consider a medium or complex spread.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 4, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between YOUR_VALUE and OUTCOME positions.",
    es: "Lee cartas sequentially from position 1 to 4, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between YOUR_VALUE and OUTCOME positions.",
    ca: "Llegeix cartes sequentially from position 1 to 4, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between YOUR_VALUE and OUTCOME positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Your Value and Employer Perspective reveals the core dynamic of this situation",
        es: "La relación entre Tu Valor y Perspectiva del Empleador revela la dinámica central de esta situación",
        ca: "La relació entre El Teu Valor i Perspectiva de l'Empleador revela la dinàmica central d'aquesta situació",
      },
      positions: ["YOUR_VALUE", "EMPLOYER_VIEW"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["money", "finances", "income", "savings", "investment", "abundance"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "simple",
      experienceLevel: "beginner",
      timeframe: "medium-term",
    },
  },
};


const ABUNDANCE_MINDSET_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines financial energies, money flow, and material resources. This 6-card spread provides medium level insight into abundance, mindset, prosperity. Transform your money mindset from scarcity to abundance",
    es: "Esta spread examines financial energies, money flow, and material resources. Esta 6-card spread provides medium level insight into abundance, mindset, prosperity. Transform your money mindset from scarcity to abundance",
    ca: "Aquesta spread examines financial energies, money flow, and material resources. Aquesta 6-card spread provides medium level insight into abundance, mindset, prosperity. Transform your money mindset from scarcity to abundance",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about abundance and mindset.",
    es: "Elige this spread when tú need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about abundance and mindset.",
    ca: "Tria this spread when tu need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about abundance and mindset.",
  },
  whenToAvoid: {
    en: "Avoid this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
    es: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
    ca: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_MINDSET and MANIFESTATION positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_MINDSET and MANIFESTATION positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_MINDSET and MANIFESTATION positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current Money Mindset and Scarcity Blocks reveals the core dynamic of this situation",
        es: "La relación entre Mentalidad Monetaria Actual y Bloqueos de Escasez revela la dinámica central de esta situación",
        ca: "La relació entre Mentalitat Monetària Actual i Bloquejos d'Escassetat revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_MINDSET", "SCARCITY_BLOCKS"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Mindset Shift to Manifesting Abundance shows the natural flow toward resolution",
        es: "La progresión desde Cambio de Mentalidad hasta Manifestar Abundancia muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Canvi de Mentalitat fins a Manifestar Abundància mostra el flux natural cap a la resolució",
      },
      positions: ["SHIFT", "MANIFESTATION"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["money", "finances", "income", "savings", "investment", "abundance"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const BUSINESS_FINANCES_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines financial energies, money flow, and material resources. This 7-card spread provides medium level insight into business, finance, revenue. Comprehensive financial guidance for your business venture",
    es: "Esta spread examines financial energies, money flow, and material resources. Esta 7-card spread provides medium level insight into business, finance, revenue. Comprehensive financial guidance for your business venture",
    ca: "Aquesta spread examines financial energies, money flow, and material resources. Aquesta 7-card spread provides medium level insight into business, finance, revenue. Comprehensive financial guidance for your business venture",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about business and finance.",
    es: "Elige this spread when tú need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about business and finance.",
    ca: "Tria this spread when tu need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about business and finance.",
  },
  whenToAvoid: {
    en: "Avoid this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
    es: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
    ca: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and PROJECTION positions.",
    es: "Lee cartas sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and PROJECTION positions.",
    ca: "Llegeix cartes sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and PROJECTION positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current Financial State and Revenue Streams reveals the core dynamic of this situation",
        es: "La relación entre Estado Financiero Actual y Fuentes de Ingresos revela la dinámica central de esta situación",
        ca: "La relació entre Estat Financer Actual i Fonts d'Ingressos revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_STATE", "REVENUE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Growth Opportunities to 6-Month Projection shows the natural flow toward resolution",
        es: "La progresión desde Oportunidades de Crecimiento hasta Proyección 6 Meses muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Oportunitats de Creixement fins a Projecció 6 Mesos mostra el flux natural cap a la resolució",
      },
      positions: ["GROWTH", "PROJECTION"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["money", "finances", "income", "savings", "investment", "abundance"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const SAVINGS_GOALS_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines financial energies, money flow, and material resources. This 5-card spread provides medium level insight into savings, goals, planning. Achieve your savings goals with clarity on obstacles and strategy",
    es: "Esta spread examines financial energies, money flow, and material resources. Esta 5-card spread provides medium level insight into savings, goals, planning. Achieve your savings goals with clarity on obstacles and strategy",
    ca: "Aquesta spread examines financial energies, money flow, and material resources. Aquesta 5-card spread provides medium level insight into savings, goals, planning. Achieve your savings goals with clarity on obstacles and strategy",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about savings and goals.",
    es: "Elige this spread when tú need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about savings and goals.",
    ca: "Tria this spread when tu need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about savings and goals.",
  },
  whenToAvoid: {
    en: "Avoid this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
    es: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
    ca: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between GOAL and SUCCESS positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between GOAL and SUCCESS positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between GOAL and SUCCESS positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Your Goal and Current Habits reveals the core dynamic of this situation",
        es: "La relación entre Tu Objetivo y Hábitos Actuales revela la dinámica central de esta situación",
        ca: "La relació entre El Teu Objectiu i Hàbits Actuals revela la dinàmica central d'aquesta situació",
      },
      positions: ["GOAL", "CURRENT_HABITS"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Obstacles to Path to Success shows the natural flow toward resolution",
        es: "La progresión desde Obstáculos hasta Camino hacia el Éxito muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Obstacles fins a Camí cap a l'Èxit mostra el flux natural cap a la resolució",
      },
      positions: ["OBSTACLES", "SUCCESS"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["money", "finances", "income", "savings", "investment", "abundance"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const FINANCIAL_BLOCKS_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines financial energies, money flow, and material resources. This 6-card spread provides medium level insight into blocks, beliefs, healing. Identify and release blocks preventing financial flow",
    es: "Esta spread examines financial energies, money flow, and material resources. Esta 6-card spread provides medium level insight into blocks, beliefs, healing. Identify and release blocks preventing financial flow",
    ca: "Aquesta spread examines financial energies, money flow, and material resources. Aquesta 6-card spread provides medium level insight into blocks, beliefs, healing. Identify and release blocks preventing financial flow",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about blocks and beliefs.",
    es: "Elige this spread when tú need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about blocks and beliefs.",
    ca: "Tria this spread when tu need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about blocks and beliefs.",
  },
  whenToAvoid: {
    en: "Avoid this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
    es: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
    ca: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between MAIN_BLOCK and FLOW positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between MAIN_BLOCK and FLOW positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between MAIN_BLOCK and FLOW positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Main Financial Block and Origin/Root Cause reveals the core dynamic of this situation",
        es: "La relación entre Principal Bloqueo Financiero y Origen/Causa Raíz revela la dinámica central de esta situación",
        ca: "La relació entre Principal Bloqueig Financer i Origen/Causa Arrel revela la dinàmica central d'aquesta situació",
      },
      positions: ["MAIN_BLOCK", "ORIGIN"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Releasing Process to Opening Financial Flow shows the natural flow toward resolution",
        es: "La progresión desde Proceso de Liberación hasta Abrir Flujo Financiero muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Procés d'Alliberament fins a Obrir Flux Financer mostra el flux natural cap a la resolució",
      },
      positions: ["RELEASE", "FLOW"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["money", "finances", "income", "savings", "investment", "abundance"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const MONEY_FLOW_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines financial energies, money flow, and material resources. This 5-card spread provides medium level insight into flow, circulation, energy. Understand and improve the flow of money in your life",
    es: "Esta spread examines financial energies, money flow, and material resources. Esta 5-card spread provides medium level insight into flow, circulation, energy. Understand and improve el flow of money in your life",
    ca: "Aquesta spread examines financial energies, money flow, and material resources. Aquesta 5-card spread provides medium level insight into flow, circulation, energy. Understand and improve el flow of money in your life",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about flow and circulation.",
    es: "Elige this spread when tú need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about flow and circulation.",
    ca: "Tria this spread when tu need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about flow and circulation.",
  },
  whenToAvoid: {
    en: "Avoid this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
    es: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
    ca: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_FLOW and INCREASE positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_FLOW and INCREASE positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_FLOW and INCREASE positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current Money Flow and Where Flow Blocks reveals the core dynamic of this situation",
        es: "La relación entre Flujo de Dinero Actual y Donde se Bloquea revela la dinámica central de esta situación",
        ca: "La relació entre Flux de Diners Actual i On es Bloqueja revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_FLOW", "BLOCKAGE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Inflow Opportunity to Increasing Flow shows the natural flow toward resolution",
        es: "La progresión desde Oportunidad de Entrada hasta Aumentar el Flujo muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Oportunitat d'Entrada fins a Augmentar el Flux mostra el flux natural cap a la resolució",
      },
      positions: ["OPPORTUNITY", "INCREASE"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["money", "finances", "income", "savings", "investment", "abundance"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const PROSPERITY_PATH_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines financial energies, money flow, and material resources. This 7-card spread provides medium level insight into prosperity, wealth, success. Map your journey to lasting prosperity and financial well-being",
    es: "Esta spread examines financial energies, money flow, and material resources. Esta 7-card spread provides medium level insight into prosperity, wealth, success. Map your journey to lasting prosperity and financial well-being",
    ca: "Aquesta spread examines financial energies, money flow, and material resources. Aquesta 7-card spread provides medium level insight into prosperity, wealth, success. Map your journey to lasting prosperity and financial well-being",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about prosperity and wealth.",
    es: "Elige this spread when tú need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about prosperity and wealth.",
    ca: "Tria this spread when tu need guidance on money, finances, income matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about prosperity and wealth.",
  },
  whenToAvoid: {
    en: "Avoid this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
    es: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
    ca: "Evita this spread for relationship counseling, career path discovery, spiritual awakening. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and PROSPERITY positions.",
    es: "Lee cartas sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and PROSPERITY positions.",
    ca: "Llegeix cartes sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and PROSPERITY positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current State and Financial Strengths reveals the core dynamic of this situation",
        es: "La relación entre Estado Actual y Fortalezas Financieras revela la dinámica central de esta situación",
        ca: "La relació entre Estat Actual i Fortaleses Financeres revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_STATE", "STRENGTHS"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Building Discipline to True Prosperity shows the natural flow toward resolution",
        es: "La progresión desde Construir Disciplina hasta Prosperidad Verdadera muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Construir Disciplina fins a Prosperitat Veritable mostra el flux natural cap a la resolució",
      },
      positions: ["DISCIPLINE", "PROSPERITY"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["money", "finances", "income", "savings", "investment", "abundance"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const SPIRITUAL_PATH_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread explores spiritual path, inner wisdom, and soul development. This 7-card spread provides medium level insight into spiritual, growth, journey. Seven card journey pattern revealing your spiritual ascension and growth",
    es: "Esta spread explores spiritual path, inner wisdom, and soul development. Esta 7-card spread provides medium level insight into spiritual, growth, journey. Seven card journey pattern revealing your spiritual ascension and growth",
    ca: "Aquesta spread explores spiritual path, inner wisdom, and soul development. Aquesta 7-card spread provides medium level insight into spiritual, growth, journey. Seven card journey pattern revealing your spiritual ascension and growth",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and growth.",
    es: "Elige this spread when tú need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and growth.",
    ca: "Tria this spread when tu need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and growth.",
  },
  whenToAvoid: {
    en: "Avoid this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
    es: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
    ca: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between STARTING_POINT and HIGHEST_POTENTIAL positions.",
    es: "Lee cartas sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between STARTING_POINT and HIGHEST_POTENTIAL positions.",
    ca: "Llegeix cartes sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between STARTING_POINT and HIGHEST_POTENTIAL positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Starting Point and First Lesson reveals the core dynamic of this situation",
        es: "La relación entre Punto de Partida y Primera Lección revela la dinámica central de esta situación",
        ca: "La relació entre Punt de Partida i Primera Lliçó revela la dinàmica central d'aquesta situació",
      },
      positions: ["STARTING_POINT", "FIRST_LESSON"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Breakthrough to Highest Potential shows the natural flow toward resolution",
        es: "La progresión desde Revelación hasta Máximo Potencial muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Revelació fins a Màxim Potencial mostra el flux natural cap a la resolució",
      },
      positions: ["BREAKTHROUGH", "HIGHEST_POTENTIAL"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["spiritual", "soul", "purpose", "awakening", "growth", "transcendence"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const CHAKRA_ALIGNMENT_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread explores spiritual path, inner wisdom, and soul development. This 7-card spread provides medium level insight into spiritual, chakra, energy. Seven card vertical layout examining each chakra from root to crown",
    es: "Esta spread explores spiritual path, inner wisdom, and soul development. Esta 7-card spread provides medium level insight into spiritual, chakra, energy. Seven card vertical layout examining each chakra from root to crown",
    ca: "Aquesta spread explores spiritual path, inner wisdom, and soul development. Aquesta 7-card spread provides medium level insight into spiritual, chakra, energy. Seven card vertical layout examining each chakra from root to crown",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and chakra.",
    es: "Elige this spread when tú need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and chakra.",
    ca: "Tria this spread when tu need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and chakra.",
  },
  whenToAvoid: {
    en: "Avoid this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
    es: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
    ca: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between ROOT_CHAKRA and CROWN_CHAKRA positions.",
    es: "Lee cartas sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between ROOT_CHAKRA and CROWN_CHAKRA positions.",
    ca: "Llegeix cartes sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between ROOT_CHAKRA and CROWN_CHAKRA positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Root Chakra and Sacral Chakra reveals the core dynamic of this situation",
        es: "La relación entre Chakra Raíz y Chakra Sacro revela la dinámica central de esta situación",
        ca: "La relació entre Chakra Arrel i Chakra Sacre revela la dinàmica central d'aquesta situació",
      },
      positions: ["ROOT_CHAKRA", "SACRAL_CHAKRA"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Heart Chakra to Crown Chakra shows the natural flow toward resolution",
        es: "La progresión desde Chakra Cardíaco hasta Chakra Corona muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Chakra Cardíac fins a Chakra Corona mostra el flux natural cap a la resolució",
      },
      positions: ["HEART_CHAKRA", "CROWN_CHAKRA"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["spiritual", "soul", "purpose", "awakening", "growth", "transcendence"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const SHADOW_WORK_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread explores spiritual path, inner wisdom, and soul development. This 6-card spread provides medium level insight into spiritual, shadow-work, healing. Six card circular pattern exploring hidden aspects and unconscious patterns",
    es: "Esta spread explores spiritual path, inner wisdom, and soul development. Esta 6-card spread provides medium level insight into spiritual, shadow-work, healing. Six card circular pattern exploring hidden aspects and unconscious patterns",
    ca: "Aquesta spread explores spiritual path, inner wisdom, and soul development. Aquesta 6-card spread provides medium level insight into spiritual, shadow-work, healing. Six card circular pattern exploring hidden aspects and unconscious patterns",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and shadow-work.",
    es: "Elige this spread when tú need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and shadow-work.",
    ca: "Tria this spread when tu need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and shadow-work.",
  },
  whenToAvoid: {
    en: "Avoid this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
    es: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
    ca: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CONSCIOUS_SELF and WHOLENESS positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CONSCIOUS_SELF and WHOLENESS positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CONSCIOUS_SELF and WHOLENESS positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Conscious Self and Hidden Shadow reveals the core dynamic of this situation",
        es: "La relación entre Yo Consciente y Sombra Oculta revela la dinámica central de esta situación",
        ca: "La relació entre Jo Conscient i Ombra Oculta revela la dinàmica central d'aquesta situació",
      },
      positions: ["CONSCIOUS_SELF", "HIDDEN_SHADOW"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Gift in Shadow to Wholeness shows the natural flow toward resolution",
        es: "La progresión desde Regalo en la Sombra hasta Totalidad muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Regal a l'Ombra fins a Totalitat mostra el flux natural cap a la resolució",
      },
      positions: ["GIFT_IN_SHADOW", "WHOLENESS"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["spiritual", "soul", "purpose", "awakening", "growth", "transcendence"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const LIFE_PURPOSE_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread explores spiritual path, inner wisdom, and soul development. This 8-card spread provides extended level insight into spiritual, purpose, calling. Eight card star pattern revealing your soul mission and calling",
    es: "Esta spread explores spiritual path, inner wisdom, and soul development. Esta 8-card spread provides extended level insight into spiritual, purpose, calling. Eight card star pattern revealing your soul mission and calling",
    ca: "Aquesta spread explores spiritual path, inner wisdom, and soul development. Aquesta 8-card spread provides extended level insight into spiritual, purpose, calling. Eight card star pattern revealing your soul mission and calling",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on spiritual, soul, purpose matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about spiritual and purpose.",
    es: "Elige this spread when tú need guidance on spiritual, soul, purpose matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about spiritual and purpose.",
    ca: "Tria this spread when tu need guidance on spiritual, soul, purpose matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about spiritual and purpose.",
  },
  whenToAvoid: {
    en: "Avoid this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
    es: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
    ca: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between SOUL_ESSENCE and FULFILLMENT positions.",
    es: "Lee cartas sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between SOUL_ESSENCE and FULFILLMENT positions.",
    ca: "Llegeix cartes sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between SOUL_ESSENCE and FULFILLMENT positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Soul Essence and Earthly Mission reveals the core dynamic of this situation",
        es: "La relación entre Esencia del Alma y Misión Terrenal revela la dinámica central de esta situación",
        ca: "La relació entre Essència de l'Ànima i Missió Terrenal revela la dinàmica central d'aquesta situació",
      },
      positions: ["SOUL_ESSENCE", "EARTHLY_MISSION"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Service to Fulfillment shows the natural flow toward resolution",
        es: "La progresión desde Servicio hasta Realización muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Servei fins a Realització mostra el flux natural cap a la resolució",
      },
      positions: ["SERVICE", "FULFILLMENT"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["spiritual", "soul", "purpose", "awakening", "growth", "transcendence"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "comprehensive",
      complexityLevel: "extended",
      experienceLevel: "advanced",
      timeframe: "medium-term",
    },
  },
};


const SPIRITUAL_AWAKENING_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread explores spiritual path, inner wisdom, and soul development. This 7-card spread provides medium level insight into spiritual, awakening, consciousness. Seven card spiral pattern tracking your consciousness expansion journey",
    es: "Esta spread explores spiritual path, inner wisdom, and soul development. Esta 7-card spread provides medium level insight into spiritual, awakening, consciousness. Seven card spiral pattern tracking your consciousness expansion journey",
    ca: "Aquesta spread explores spiritual path, inner wisdom, and soul development. Aquesta 7-card spread provides medium level insight into spiritual, awakening, consciousness. Seven card spiral pattern tracking your consciousness expansion journey",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and awakening.",
    es: "Elige this spread when tú need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and awakening.",
    ca: "Tria this spread when tu need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and awakening.",
  },
  whenToAvoid: {
    en: "Avoid this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
    es: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
    ca: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between SLEEP_STATE and NEW_BEING positions.",
    es: "Lee cartas sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between SLEEP_STATE and NEW_BEING positions.",
    ca: "Llegeix cartes sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between SLEEP_STATE and NEW_BEING positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Sleep State and Catalyst reveals the core dynamic of this situation",
        es: "La relación entre Estado de Sueño y Catalizador revela la dinámica central de esta situación",
        ca: "La relació entre Estat de Son i Catalitzador revela la dinàmica central d'aquesta situació",
      },
      positions: ["SLEEP_STATE", "CATALYST"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Dark Night to New Being shows the natural flow toward resolution",
        es: "La progresión desde Noche Oscura hasta Nuevo Ser muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Nit Fosca fins a Nou Ser mostra el flux natural cap a la resolució",
      },
      positions: ["DARK_NIGHT", "NEW_BEING"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["spiritual", "soul", "purpose", "awakening", "growth", "transcendence"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const PAST_LIFE_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread explores spiritual path, inner wisdom, and soul development. This 6-card spread provides medium level insight into spiritual, past-life, karma. Six card horizontal timeline exploring karmic patterns and soul memories",
    es: "Esta spread explores spiritual path, inner wisdom, and soul development. Esta 6-card spread provides medium level insight into spiritual, past-life, karma. Six card horizontal timeline exploring karmic patterns and soul memories",
    ca: "Aquesta spread explores spiritual path, inner wisdom, and soul development. Aquesta 6-card spread provides medium level insight into spiritual, past-life, karma. Six card horizontal timeline exploring karmic patterns and soul memories",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and past-life.",
    es: "Elige this spread when tú need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and past-life.",
    ca: "Tria this spread when tu need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and past-life.",
  },
  whenToAvoid: {
    en: "Avoid this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
    es: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
    ca: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between PAST_IDENTITY and LIBERATION positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between PAST_IDENTITY and LIBERATION positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between PAST_IDENTITY and LIBERATION positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Past Identity and Past Challenge reveals the core dynamic of this situation",
        es: "La relación entre Identidad Pasada y Desafío Pasado revela la dinámica central de esta situación",
        ca: "La relació entre Identitat Passada i Repte Passat revela la dinàmica central d'aquesta situació",
      },
      positions: ["PAST_IDENTITY", "PAST_CHALLENGE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Current Echo to Liberation shows the natural flow toward resolution",
        es: "La progresión desde Eco Actual hasta Liberación muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Eco Actual fins a Alliberament mostra el flux natural cap a la resolució",
      },
      positions: ["CURRENT_ECHO", "LIBERATION"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["spiritual", "soul", "purpose", "awakening", "growth", "transcendence"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const SPIRIT_GUIDES_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread explores spiritual path, inner wisdom, and soul development. This 5-card spread provides simple level insight into spiritual, guides, messages. Five card layout for connecting with spiritual guides and receiving messages",
    es: "Esta spread explores spiritual path, inner wisdom, and soul development. Esta 5-card spread provides simple level insight into spiritual, guides, messages. Five card layout for connecting with spiritual guides and receiving messages",
    ca: "Aquesta spread explores spiritual path, inner wisdom, and soul development. Aquesta 5-card spread provides simple level insight into spiritual, guides, messages. Five card layout for connecting with spiritual guides and receiving messages",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on spiritual, soul, purpose matters. Ideal for quick insight and clarity. Perfect for questions about spiritual and guides.",
    es: "Elige this spread when tú need guidance on spiritual, soul, purpose matters. Ideal for quick insight and clarity. Perfect for questions about spiritual and guides.",
    ca: "Tria this spread when tu need guidance on spiritual, soul, purpose matters. Ideal for quick insight and clarity. Perfect for questions about spiritual and guides.",
  },
  whenToAvoid: {
    en: "Avoid this spread for immediate practical decisions, financial transactions, legal matters. If you need more detailed analysis, consider a medium or complex spread.",
    es: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need more detailed analysis, consider a medium or complex spread.",
    ca: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need more detailed analysis, consider a medium or complex spread.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between GUIDE_IDENTITY and COLLABORATIVE_PATH positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between GUIDE_IDENTITY and COLLABORATIVE_PATH positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between GUIDE_IDENTITY and COLLABORATIVE_PATH positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Guide Identity and Guide Message reveals the core dynamic of this situation",
        es: "La relación entre Identidad del Guía y Mensaje del Guía revela la dinámica central de esta situación",
        ca: "La relació entre Identitat del Guia i Missatge del Guia revela la dinàmica central d'aquesta situació",
      },
      positions: ["GUIDE_IDENTITY", "GUIDE_MESSAGE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Guide Gift to Collaborative Path shows the natural flow toward resolution",
        es: "La progresión desde Regalo del Guía hasta Camino Colaborativo muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Regal del Guia fins a Camí Col·laboratiu mostra el flux natural cap a la resolució",
      },
      positions: ["GUIDE_GIFT", "COLLABORATIVE_PATH"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["spiritual", "soul", "purpose", "awakening", "growth", "transcendence"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "simple",
      experienceLevel: "beginner",
      timeframe: "medium-term",
    },
  },
};


const PSYCHIC_DEVELOPMENT_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread explores spiritual path, inner wisdom, and soul development. This 6-card spread provides medium level insight into spiritual, psychic, intuition. Six card layout examining and strengthening intuitive abilities",
    es: "Esta spread explores spiritual path, inner wisdom, and soul development. Esta 6-card spread provides medium level insight into spiritual, psychic, intuition. Six card layout examining and strengthening intuitive abilities",
    ca: "Aquesta spread explores spiritual path, inner wisdom, and soul development. Aquesta 6-card spread provides medium level insight into spiritual, psychic, intuition. Six card layout examining and strengthening intuitive abilities",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and psychic.",
    es: "Elige this spread when tú need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and psychic.",
    ca: "Tria this spread when tu need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and psychic.",
  },
  whenToAvoid: {
    en: "Avoid this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
    es: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
    ca: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_ABILITIES and HIGHEST_EXPRESSION positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_ABILITIES and HIGHEST_EXPRESSION positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_ABILITIES and HIGHEST_EXPRESSION positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current Abilities and Dormant Potential reveals the core dynamic of this situation",
        es: "La relación entre Habilidades Actuales y Potencial Latente revela la dinámica central de esta situación",
        ca: "La relació entre Habilitats Actuals i Potencial Latent revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_ABILITIES", "DORMANT_POTENTIAL"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Strengthening Practice to Highest Expression shows the natural flow toward resolution",
        es: "La progresión desde Práctica de Fortalecimiento hasta Expresión Más Alta muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Pràctica de Reforç fins a Expressió Més Alta mostra el flux natural cap a la resolució",
      },
      positions: ["STRENGTHENING_PRACTICE", "HIGHEST_EXPRESSION"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["spiritual", "soul", "purpose", "awakening", "growth", "transcendence"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const FULL_MOON_RITUAL_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread explores spiritual path, inner wisdom, and soul development. This 5-card spread provides simple level insight into spiritual, full-moon, release. Five card lunar release spread for releasing what no longer serves",
    es: "Esta spread explores spiritual path, inner wisdom, and soul development. Esta 5-card spread provides simple level insight into spiritual, full-moon, release. Five card lunar release spread for releasing what no longer serves",
    ca: "Aquesta spread explores spiritual path, inner wisdom, and soul development. Aquesta 5-card spread provides simple level insight into spiritual, full-moon, release. Five card lunar release spread for releasing what no longer serves",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on spiritual, soul, purpose matters. Ideal for quick insight and clarity. Perfect for questions about spiritual and full-moon.",
    es: "Elige this spread when tú need guidance on spiritual, soul, purpose matters. Ideal for quick insight and clarity. Perfect for questions about spiritual and full-moon.",
    ca: "Tria this spread when tu need guidance on spiritual, soul, purpose matters. Ideal for quick insight and clarity. Perfect for questions about spiritual and full-moon.",
  },
  whenToAvoid: {
    en: "Avoid this spread for immediate practical decisions, financial transactions, legal matters. If you need more detailed analysis, consider a medium or complex spread.",
    es: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need more detailed analysis, consider a medium or complex spread.",
    ca: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need more detailed analysis, consider a medium or complex spread.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between ILLUMINATION and SPACE_CREATED positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between ILLUMINATION and SPACE_CREATED positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between ILLUMINATION and SPACE_CREATED positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Illumination and What to Release reveals the core dynamic of this situation",
        es: "La relación entre Iluminación y Qué Liberar revela la dinámica central de esta situación",
        ca: "La relació entre Il·luminació i Què Alliberar revela la dinàmica central d'aquesta situació",
      },
      positions: ["ILLUMINATION", "WHAT_TO_RELEASE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Why You Hold On to Space Created shows the natural flow toward resolution",
        es: "La progresión desde Por Qué Te Aferras hasta Espacio Creado muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Per Què T'Aferres fins a Espai Creat mostra el flux natural cap a la resolució",
      },
      positions: ["WHY_HOLD_ON", "SPACE_CREATED"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["spiritual", "soul", "purpose", "awakening", "growth", "transcendence"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "simple",
      experienceLevel: "beginner",
      timeframe: "medium-term",
    },
  },
};


const NEW_MOON_INTENTIONS_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread explores spiritual path, inner wisdom, and soul development. This 5-card spread provides simple level insight into spiritual, new-moon, manifestation. Five card lunar manifestation spread for setting powerful intentions",
    es: "Esta spread explores spiritual path, inner wisdom, and soul development. Esta 5-card spread provides simple level insight into spiritual, new-moon, manifestation. Five card lunar manifestation spread for setting powerful intentions",
    ca: "Aquesta spread explores spiritual path, inner wisdom, and soul development. Aquesta 5-card spread provides simple level insight into spiritual, new-moon, manifestation. Five card lunar manifestation spread for setting powerful intentions",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on spiritual, soul, purpose matters. Ideal for quick insight and clarity. Perfect for questions about spiritual and new-moon.",
    es: "Elige this spread when tú need guidance on spiritual, soul, purpose matters. Ideal for quick insight and clarity. Perfect for questions about spiritual and new-moon.",
    ca: "Tria this spread when tu need guidance on spiritual, soul, purpose matters. Ideal for quick insight and clarity. Perfect for questions about spiritual and new-moon.",
  },
  whenToAvoid: {
    en: "Avoid this spread for immediate practical decisions, financial transactions, legal matters. If you need more detailed analysis, consider a medium or complex spread.",
    es: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need more detailed analysis, consider a medium or complex spread.",
    ca: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need more detailed analysis, consider a medium or complex spread.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between BLANK_SLATE and MOONTH_POTENTIAL positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between BLANK_SLATE and MOONTH_POTENTIAL positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between BLANK_SLATE and MOONTH_POTENTIAL positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Blank Slate and Heart Desire reveals the core dynamic of this situation",
        es: "La relación entre Pizarra En Blanco y Deseo del Corazón revela la dinámica central de esta situación",
        ca: "La relació entre Pissarra Buida i Desig del Cor revela la dinàmica central d'aquesta situació",
      },
      positions: ["BLANK_SLATE", "HEART_DESIRE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Aligned Action to Month Potential shows the natural flow toward resolution",
        es: "La progresión desde Acción Alineada hasta Potencial del Mes muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Acció Alineada fins a Potencial del Mes mostra el flux natural cap a la resolució",
      },
      positions: ["ALIGNED_ACTION", "MOONTH_POTENTIAL"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["spiritual", "soul", "purpose", "awakening", "growth", "transcendence"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "simple",
      experienceLevel: "beginner",
      timeframe: "medium-term",
    },
  },
};


const MEDITATION_JOURNEY_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread explores spiritual path, inner wisdom, and soul development. This 7-card spread provides medium level insight into spiritual, meditation, inner-journey. Seven card inner path layout for deepening contemplative practice",
    es: "Esta spread explores spiritual path, inner wisdom, and soul development. Esta 7-card spread provides medium level insight into spiritual, meditation, inner-journey. Seven card inner path layout for deepening contemplative practice",
    ca: "Aquesta spread explores spiritual path, inner wisdom, and soul development. Aquesta 7-card spread provides medium level insight into spiritual, meditation, inner-journey. Seven card inner path layout for deepening contemplative practice",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and meditation.",
    es: "Elige this spread when tú need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and meditation.",
    ca: "Tria this spread when tu need guidance on spiritual, soul, purpose matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about spiritual and meditation.",
  },
  whenToAvoid: {
    en: "Avoid this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
    es: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
    ca: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between ENTRY_POINT and INTEGRATION positions.",
    es: "Lee cartas sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between ENTRY_POINT and INTEGRATION positions.",
    ca: "Llegeix cartes sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between ENTRY_POINT and INTEGRATION positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Entry Point and Breath Gate reveals the core dynamic of this situation",
        es: "La relación entre Punto de Entrada y Portal de la Respiración revela la dinámica central de esta situación",
        ca: "La relació entre Punt d'Entrada i Portal de la Respiració revela la dinàmica central d'aquesta situació",
      },
      positions: ["ENTRY_POINT", "BREATH_GATE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Heart Opening to Integration shows the natural flow toward resolution",
        es: "La progresión desde Apertura del Corazón hasta Integración muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Obertura del Cor fins a Integració mostra el flux natural cap a la resolució",
      },
      positions: ["HEART_OPENING", "INTEGRATION"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["spiritual", "soul", "purpose", "awakening", "growth", "transcendence"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const SACRED_CALLING_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread explores spiritual path, inner wisdom, and soul development. This 8-card spread provides extended level insight into spiritual, calling, vocation. Eight card vocation pattern exploring spiritual work and divine service",
    es: "Esta spread explores spiritual path, inner wisdom, and soul development. Esta 8-card spread provides extended level insight into spiritual, calling, vocation. Eight card vocation pattern exploring spiritual work and divine service",
    ca: "Aquesta spread explores spiritual path, inner wisdom, and soul development. Aquesta 8-card spread provides extended level insight into spiritual, calling, vocation. Eight card vocation pattern exploring spiritual work and divine service",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on spiritual, soul, purpose matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about spiritual and calling.",
    es: "Elige this spread when tú need guidance on spiritual, soul, purpose matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about spiritual and calling.",
    ca: "Tria this spread when tu need guidance on spiritual, soul, purpose matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about spiritual and calling.",
  },
  whenToAvoid: {
    en: "Avoid this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
    es: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
    ca: "Evita this spread for immediate practical decisions, financial transactions, legal matters. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between DIVINE_CALL and IMPACT positions.",
    es: "Lee cartas sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between DIVINE_CALL and IMPACT positions.",
    ca: "Llegeix cartes sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between DIVINE_CALL and IMPACT positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Divine Call and Sacred Wounds reveals the core dynamic of this situation",
        es: "La relación entre Llamado Divino y Heridas Sagradas revela la dinámica central de esta situación",
        ca: "La relació entre Crida Divina i Ferides Sagrades revela la dinàmica central d'aquesta situació",
      },
      positions: ["DIVINE_CALL", "SACRED_WOUNDS"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from How You Serve to Impact shows the natural flow toward resolution",
        es: "La progresión desde Cómo Sirves hasta Impacto muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Com Serveixes fins a Impacte mostra el flux natural cap a la resolució",
      },
      positions: ["HOW_YOU_SERVE", "IMPACT"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["spiritual", "soul", "purpose", "awakening", "growth", "transcendence"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "comprehensive",
      complexityLevel: "extended",
      experienceLevel: "advanced",
      timeframe: "medium-term",
    },
  },
};


const HEALTH_CHECK_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines physical, mental, and energetic well-being. This 5-card spread provides medium level insight into health, wellness, balance. Body, mind, and spirit wellness assessment",
    es: "Esta spread examines physical, mental, and energetic well-being. Esta 5-card spread provides medium level insight into health, wellness, balance. Body, mind, and spirit wellness assessment",
    ca: "Aquesta spread examines physical, mental, and energetic well-being. Aquesta 5-card spread provides medium level insight into health, wellness, balance. Body, mind, and spirit wellness assessment",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about health and wellness.",
    es: "Elige this spread when tú need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about health and wellness.",
    ca: "Tria this spread when tu need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about health and wellness.",
  },
  whenToAvoid: {
    en: "Avoid this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
    es: "Evita this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
    ca: "Evita this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between PHYSICAL_BODY and INTEGRATION positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between PHYSICAL_BODY and INTEGRATION positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between PHYSICAL_BODY and INTEGRATION positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Physical Body and Mental State reveals the core dynamic of this situation",
        es: "La relación entre Cuerpo Físico y Estado Mental revela la dinámica central de esta situación",
        ca: "La relació entre Cos Físic i Estat Mental revela la dinàmica central d'aquesta situació",
      },
      positions: ["PHYSICAL_BODY", "MENTAL_STATE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Emotional Wellbeing to Integration shows the natural flow toward resolution",
        es: "La progresión desde Bienestar Emocional hasta Integración muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Benestar Emocional fins a Integració mostra el flux natural cap a la resolució",
      },
      positions: ["EMOTIONAL_WELLBEING", "INTEGRATION"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["health", "wellness", "body", "energy", "healing", "vitality"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const MENTAL_HEALTH_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines physical, mental, and energetic well-being. This 6-card spread provides medium level insight into mental, emotions, thoughts. Deep exploration of mental and emotional wellness",
    es: "Esta spread examines physical, mental, and energetic well-being. Esta 6-card spread provides medium level insight into mental, emotions, thoughts. Deep exploration of mental and emotional wellness",
    ca: "Aquesta spread examines physical, mental, and energetic well-being. Aquesta 6-card spread provides medium level insight into mental, emotions, thoughts. Deep exploration of mental and emotional wellness",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about mental and emotions.",
    es: "Elige this spread when tú need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about mental and emotions.",
    ca: "Tria this spread when tu need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about mental and emotions.",
  },
  whenToAvoid: {
    en: "Avoid this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
    es: "Evita this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
    ca: "Evita this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_MENTAL_STATE and FUTURE_OUTLOOK positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_MENTAL_STATE and FUTURE_OUTLOOK positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_MENTAL_STATE and FUTURE_OUTLOOK positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current Mental State and Thought Patterns reveals the core dynamic of this situation",
        es: "La relación entre Estado Mental Actual y Patrones de Pensamiento revela la dinámica central de esta situación",
        ca: "La relació entre Estat Mental Actual i Patrons de Pensament revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_MENTAL_STATE", "THOUGHT_PATTERNS"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Healing Path to Future Outlook shows the natural flow toward resolution",
        es: "La progresión desde Camino de Sanación hasta Perspectiva Futura muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Camí de Curació fins a Perspectiva Futura mostra el flux natural cap a la resolució",
      },
      positions: ["HEALING_PATH", "FUTURE_OUTLOOK"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["health", "wellness", "body", "energy", "healing", "vitality"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const ENERGY_HEALING_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines physical, mental, and energetic well-being. This 7-card spread provides medium level insight into energy, chakra, healing. Chakra and energy flow alignment reading",
    es: "Esta spread examines physical, mental, and energetic well-being. Esta 7-card spread provides medium level insight into energy, chakra, healing. Chakra and energy flow alignment reading",
    ca: "Aquesta spread examines physical, mental, and energetic well-being. Aquesta 7-card spread provides medium level insight into energy, chakra, healing. Chakra and energy flow alignment reading",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about energy and chakra.",
    es: "Elige this spread when tú need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about energy and chakra.",
    ca: "Tria this spread when tu need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about energy and chakra.",
  },
  whenToAvoid: {
    en: "Avoid this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
    es: "Evita this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
    ca: "Evita this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between ROOT_ENERGY and DIVINE_CONNECTION positions.",
    es: "Lee cartas sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between ROOT_ENERGY and DIVINE_CONNECTION positions.",
    ca: "Llegeix cartes sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between ROOT_ENERGY and DIVINE_CONNECTION positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Root Energy and Creative Flow reveals the core dynamic of this situation",
        es: "La relación entre Energía Raíz y Flujo Creativo revela la dinámica central de esta situación",
        ca: "La relació entre Energia Arrel i Flux Creatiu revela la dinàmica central d'aquesta situació",
      },
      positions: ["ROOT_ENERGY", "CREATIVE_FLOW"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Heart Center to Divine Connection shows the natural flow toward resolution",
        es: "La progresión desde Centro del Corazón hasta Conexión Divina muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Centre del Cor fins a Connexió Divina mostra el flux natural cap a la resolució",
      },
      positions: ["HEART_CENTER", "DIVINE_CONNECTION"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["health", "wellness", "body", "energy", "healing", "vitality"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const STRESS_RELIEF_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines physical, mental, and energetic well-being. This 5-card spread provides medium level insight into stress, anxiety, tension. Find peace and release tension from your life",
    es: "Esta spread examines physical, mental, and energetic well-being. Esta 5-card spread provides medium level insight into stress, anxiety, tension. Find peace and release tension from your life",
    ca: "Aquesta spread examines physical, mental, and energetic well-being. Aquesta 5-card spread provides medium level insight into stress, anxiety, tension. Find peace and release tension from your life",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about stress and anxiety.",
    es: "Elige this spread when tú need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about stress and anxiety.",
    ca: "Tria this spread when tu need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about stress and anxiety.",
  },
  whenToAvoid: {
    en: "Avoid this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
    es: "Evita this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
    ca: "Evita this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between STRESS_SOURCE and ONGOING_SUPPORT positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between STRESS_SOURCE and ONGOING_SUPPORT positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between STRESS_SOURCE and ONGOING_SUPPORT positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Stress Source and Physical Impact reveals the core dynamic of this situation",
        es: "La relación entre Fuente de Estrés y Impacto Físico revela la dinámica central de esta situación",
        ca: "La relació entre Font d'Estrès i Impacte Físic revela la dinàmica central d'aquesta situació",
      },
      positions: ["STRESS_SOURCE", "PHYSICAL_IMPACT"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Release Strategy to Ongoing Support shows the natural flow toward resolution",
        es: "La progresión desde Estrategia de Liberación hasta Apoyo Continuo muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Estratègia d'Alliberament fins a Suport Continu mostra el flux natural cap a la resolució",
      },
      positions: ["RELEASE_STRATEGY", "ONGOING_SUPPORT"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["health", "wellness", "body", "energy", "healing", "vitality"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const BURNOUT_RECOVERY_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines physical, mental, and energetic well-being. This 6-card spread provides medium level insight into burnout, exhaustion, recovery. Journey from exhaustion to renewed vitality",
    es: "Esta spread examines physical, mental, and energetic well-being. Esta 6-card spread provides medium level insight into burnout, exhaustion, recovery. Journey from exhaustion to renewed vitality",
    ca: "Aquesta spread examines physical, mental, and energetic well-being. Aquesta 6-card spread provides medium level insight into burnout, exhaustion, recovery. Journey from exhaustion to renewed vitality",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about burnout and exhaustion.",
    es: "Elige this spread when tú need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about burnout and exhaustion.",
    ca: "Tria this spread when tu need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about burnout and exhaustion.",
  },
  whenToAvoid: {
    en: "Avoid this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
    es: "Evita this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
    ca: "Evita this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and SUSTAINABLE_FUTURE positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and SUSTAINABLE_FUTURE positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_STATE and SUSTAINABLE_FUTURE positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current State and Depletion Causes reveals the core dynamic of this situation",
        es: "La relación entre Estado Actual y Causas de Agotamiento revela la dinámica central de esta situación",
        ca: "La relació entre Estat Actual i Causes d'Esgotament revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_STATE", "DEPLETION_CAUSES"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Boundaries to Sustainable Future shows the natural flow toward resolution",
        es: "La progresión desde Límites hasta Futuro Sostenible muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Límits fins a Futur Sostenible mostra el flux natural cap a la resolució",
      },
      positions: ["BOUNDARIES", "SUSTAINABLE_FUTURE"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["health", "wellness", "body", "energy", "healing", "vitality"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const BODY_WISDOM_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines physical, mental, and energetic well-being. This 5-card spread provides medium level insight into body, intuition, physical. Listen to your body's messages and intuition",
    es: "Esta spread examines physical, mental, and energetic well-being. Esta 5-card spread provides medium level insight into body, intuition, physical. Listen to your body's messages and intuition",
    ca: "Aquesta spread examines physical, mental, and energetic well-being. Aquesta 5-card spread provides medium level insight into body, intuition, physical. Listen to your body's messages and intuition",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about body and intuition.",
    es: "Elige this spread when tú need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about body and intuition.",
    ca: "Tria this spread when tu need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about body and intuition.",
  },
  whenToAvoid: {
    en: "Avoid this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
    es: "Evita this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
    ca: "Evita this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between PHYSICAL_SIGNALS and EMBODIED_WISDOM positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between PHYSICAL_SIGNALS and EMBODIED_WISDOM positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between PHYSICAL_SIGNALS and EMBODIED_WISDOM positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Physical Signals and Body-Mind Connection reveals the core dynamic of this situation",
        es: "La relación entre Señales Físicas y Conexión Cuerpo-Mente revela la dinámica central de esta situación",
        ca: "La relació entre Senyals Físics i Connexió Cos-Ment revela la dinàmica central d'aquesta situació",
      },
      positions: ["PHYSICAL_SIGNALS", "BODY_MIND_CONNECTION"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Intuitive Guidance to Embodied Wisdom shows the natural flow toward resolution",
        es: "La progresión desde Guía Intuitiva hasta Sabiduría Encarnada muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Guia Intuïtiva fins a Saviesa Encarnada mostra el flux natural cap a la resolució",
      },
      positions: ["INTUITIVE_GUIDANCE", "EMBODIED_WISDOM"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["health", "wellness", "body", "energy", "healing", "vitality"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const HOLISTIC_WELLNESS_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines physical, mental, and energetic well-being. This 8-card spread provides complex level insight into holistic, wellness, complete. Complete wellness across physical, mental, emotional, and spiritual dimensions",
    es: "Esta spread examines physical, mental, and energetic well-being. Esta 8-card spread provides complex level insight into holistic, wellness, complete. Complete wellness across physical, mental, emotional, and spiritual dimensions",
    ca: "Aquesta spread examines physical, mental, and energetic well-being. Aquesta 8-card spread provides complex level insight into holistic, wellness, complete. Complete wellness across physical, mental, emotional, and spiritual dimensions",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on health, wellness, body matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about holistic and wellness.",
    es: "Elige this spread when tú need guidance on health, wellness, body matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about holistic and wellness.",
    ca: "Tria this spread when tu need guidance on health, wellness, body matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about holistic and wellness.",
  },
  whenToAvoid: {
    en: "Avoid this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need quick simple answers, use a simpler spread instead.",
    es: "Evita this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need quick simple answers, use a simpler spread instead.",
    ca: "Evita this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need quick simple answers, use a simpler spread instead.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between PHYSICAL_DIMENSION and SPIRITUAL_PHYSICAL_BRIDGE positions.",
    es: "Lee cartas sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between PHYSICAL_DIMENSION and SPIRITUAL_PHYSICAL_BRIDGE positions.",
    ca: "Llegeix cartes sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between PHYSICAL_DIMENSION and SPIRITUAL_PHYSICAL_BRIDGE positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Physical Dimension and Mental Dimension reveals the core dynamic of this situation",
        es: "La relación entre Dimensión Física y Dimensión Mental revela la dinámica central de esta situación",
        ca: "La relació entre Dimensió Física i Dimensió Mental revela la dinàmica central d'aquesta situació",
      },
      positions: ["PHYSICAL_DIMENSION", "MENTAL_DIMENSION"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Physical-Mental Bridge to Spiritual-Physical Bridge shows the natural flow toward resolution",
        es: "La progresión desde Puente Físico-Mental hasta Puente Espiritual-Físico muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Pont Físic-Mental fins a Pont Espiritual-Físic mostra el flux natural cap a la resolució",
      },
      positions: ["PHYSICAL_MENTAL_BRIDGE", "SPIRITUAL_PHYSICAL_BRIDGE"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["health", "wellness", "body", "energy", "healing", "vitality"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "comprehensive",
      complexityLevel: "complex",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const HEALING_JOURNEY_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines physical, mental, and energetic well-being. This 7-card spread provides medium level insight into healing, transformation, recovery. Transform through the healing process from wound to wholeness",
    es: "Esta spread examines physical, mental, and energetic well-being. Esta 7-card spread provides medium level insight into healing, transformation, recovery. Transform through el healing process from wound to wholeness",
    ca: "Aquesta spread examines physical, mental, and energetic well-being. Aquesta 7-card spread provides medium level insight into healing, transformation, recovery. Transform through el healing process from wound to wholeness",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about healing and transformation.",
    es: "Elige this spread when tú need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about healing and transformation.",
    ca: "Tria this spread when tu need guidance on health, wellness, body matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about healing and transformation.",
  },
  whenToAvoid: {
    en: "Avoid this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
    es: "Evita this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
    ca: "Evita this spread for medical diagnosis (consult professionals), financial decisions, career planning. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between STARTING_POINT and WHOLENESS positions.",
    es: "Lee cartas sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between STARTING_POINT and WHOLENESS positions.",
    ca: "Llegeix cartes sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between STARTING_POINT and WHOLENESS positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Starting Point and The Wound reveals the core dynamic of this situation",
        es: "La relación entre Punto de Inicio y La Herida revela la dinámica central de esta situación",
        ca: "La relació entre Punt d'Inici i La Ferida revela la dinàmica central d'aquesta situació",
      },
      positions: ["STARTING_POINT", "THE_WOUND"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Transformation to Wholeness shows the natural flow toward resolution",
        es: "La progresión desde Transformación hasta Integridad muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Transformació fins a Integritat mostra el flux natural cap a la resolució",
      },
      positions: ["TRANSFORMATION", "WHOLENESS"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["health", "wellness", "body", "energy", "healing", "vitality"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const THREE_OPTIONS_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread clarifies choices, evaluates options, and reveals decision paths. This 9-card spread provides complex level insight into decision, choices, options. Deep analysis of three different paths or choices",
    es: "Esta spread clarifies choices, evaluates options, and reveals decision paths. Esta 9-card spread provides complex level insight into decision, choices, options. Deep analysis of three different paths or choices",
    ca: "Aquesta spread clarifies choices, evaluates options, and reveals decision paths. Aquesta 9-card spread provides complex level insight into decision, choices, options. Deep analysis of three different paths or choices",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on decision, choice, option matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about decision and choices.",
    es: "Elige this spread when tú need guidance on decision, choice, option matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about decision and choices.",
    ca: "Tria this spread when tu need guidance on decision, choice, option matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about decision and choices.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep psychological work, spiritual awakening, passive reflection. If you need quick simple answers, use a simpler spread instead.",
    es: "Evita this spread for deep psychological work, spiritual awakening, passive reflection. If you need quick simple answers, use a simpler spread instead.",
    ca: "Evita this spread for deep psychological work, spiritual awakening, passive reflection. If you need quick simple answers, use a simpler spread instead.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 9, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between OPTION_A_NATURE and OPTION_C_OUTCOME positions.",
    es: "Lee cartas sequentially from position 1 to 9, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between OPTION_A_NATURE and OPTION_C_OUTCOME positions.",
    ca: "Llegeix cartes sequentially from position 1 to 9, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between OPTION_A_NATURE and OPTION_C_OUTCOME positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Option A: Nature and Option A: Challenge reveals the core dynamic of this situation",
        es: "La relación entre Opción A: Naturaleza y Opción A: Desafío revela la dinámica central de esta situación",
        ca: "La relació entre Opció A: Naturalesa i Opció A: Desafiament revela la dinàmica central d'aquesta situació",
      },
      positions: ["OPTION_A_NATURE", "OPTION_A_CHALLENGE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Option B: Challenge to Option C: Outcome shows the natural flow toward resolution",
        es: "La progresión desde Opción B: Desafío hasta Opción C: Resultado muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Opció B: Desafiament fins a Opció C: Resultat mostra el flux natural cap a la resolució",
      },
      positions: ["OPTION_B_CHALLENGE", "OPTION_C_OUTCOME"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["decision", "choice", "option", "crossroads", "dilemma", "path"],
    emotionalStates: ["at crossroads"],
    preferWhen: {
      cardCountPreference: "comprehensive",
      complexityLevel: "complex",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const OPPORTUNITY_EVALUATION_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread clarifies choices, evaluates options, and reveals decision paths. This 6-card spread provides medium level insight into opportunity, evaluation, pros. Six cards to thoroughly evaluate an opportunity",
    es: "Esta spread clarifies choices, evaluates options, and reveals decision paths. Esta 6-card spread provides medium level insight into opportunity, evaluation, pros. Six cards to thoroughly evaluate an opportunity",
    ca: "Aquesta spread clarifies choices, evaluates options, and reveals decision paths. Aquesta 6-card spread provides medium level insight into opportunity, evaluation, pros. Six cards to thoroughly evaluate an opportunity",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on decision, choice, option matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about opportunity and evaluation.",
    es: "Elige this spread when tú need guidance on decision, choice, option matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about opportunity and evaluation.",
    ca: "Tria this spread when tu need guidance on decision, choice, option matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about opportunity and evaluation.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep psychological work, spiritual awakening, passive reflection. If you need different scope, explore other categories.",
    es: "Evita this spread for deep psychological work, spiritual awakening, passive reflection. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep psychological work, spiritual awakening, passive reflection. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between PROS_1 and HIDDEN_FACTOR positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between PROS_1 and HIDDEN_FACTOR positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between PROS_1 and HIDDEN_FACTOR positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Pro: Benefit and Pro: Opportunity reveals the core dynamic of this situation",
        es: "La relación entre Pro: Beneficio y Pro: Oportunidad revela la dinámica central de esta situación",
        ca: "La relació entre Pro: Benefici i Pro: Oportunitat revela la dinàmica central d'aquesta situació",
      },
      positions: ["PROS_1", "PROS_2"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Con: Risk to Hidden Factor shows the natural flow toward resolution",
        es: "La progresión desde Contra: Riesgo hasta Factor Oculto muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Contra: Risc fins a Factor Ocult mostra el flux natural cap a la resolució",
      },
      positions: ["CONS_1", "HIDDEN_FACTOR"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["decision", "choice", "option", "crossroads", "dilemma", "path"],
    emotionalStates: ["at crossroads"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const RISK_ASSESSMENT_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread clarifies choices, evaluates options, and reveals decision paths. This 5-card spread provides medium level insight into risk, reward, assessment. Five cards to weigh risk versus reward",
    es: "Esta spread clarifies choices, evaluates options, and reveals decision paths. Esta 5-card spread provides medium level insight into risk, reward, assessment. Five cards to weigh risk versus reward",
    ca: "Aquesta spread clarifies choices, evaluates options, and reveals decision paths. Aquesta 5-card spread provides medium level insight into risk, reward, assessment. Five cards to weigh risk versus reward",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on decision, choice, option matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about risk and reward.",
    es: "Elige this spread when tú need guidance on decision, choice, option matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about risk and reward.",
    ca: "Tria this spread when tu need guidance on decision, choice, option matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about risk and reward.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep psychological work, spiritual awakening, passive reflection. If you need different scope, explore other categories.",
    es: "Evita this spread for deep psychological work, spiritual awakening, passive reflection. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep psychological work, spiritual awakening, passive reflection. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between RISK and DECISION positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between RISK and DECISION positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between RISK and DECISION positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Risk and Reward reveals the core dynamic of this situation",
        es: "La relación entre Riesgo y Recompensa revela la dinámica central de esta situación",
        ca: "La relació entre Risc i Recompensa revela la dinàmica central d'aquesta situació",
      },
      positions: ["RISK", "REWARD"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Timing to Decision shows the natural flow toward resolution",
        es: "La progresión desde Momento hasta Decisión muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Moment fins a Decisió mostra el flux natural cap a la resolució",
      },
      positions: ["TIMING", "DECISION"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["decision", "choice", "option", "crossroads", "dilemma", "path"],
    emotionalStates: ["at crossroads"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const TIMING_DECISION_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread clarifies choices, evaluates options, and reveals decision paths. This 4-card spread provides simple level insight into timing, when, decision. Four cards to determine optimal timing",
    es: "Esta spread clarifies choices, evaluates options, and reveals decision paths. Esta 4-card spread provides simple level insight into timing, when, decision. Four cards to determine optimal timing",
    ca: "Aquesta spread clarifies choices, evaluates options, and reveals decision paths. Aquesta 4-card spread provides simple level insight into timing, when, decision. Four cards to determine optimal timing",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on decision, choice, option matters. Ideal for quick insight and clarity. Perfect for questions about timing and when.",
    es: "Elige this spread when tú need guidance on decision, choice, option matters. Ideal for quick insight and clarity. Perfect for questions about timing and when.",
    ca: "Tria this spread when tu need guidance on decision, choice, option matters. Ideal for quick insight and clarity. Perfect for questions about timing and when.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep psychological work, spiritual awakening, passive reflection. If you need more detailed analysis, consider a medium or complex spread.",
    es: "Evita this spread for deep psychological work, spiritual awakening, passive reflection. If you need more detailed analysis, consider a medium or complex spread.",
    ca: "Evita this spread for deep psychological work, spiritual awakening, passive reflection. If you need more detailed analysis, consider a medium or complex spread.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 4, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between NOW and BEST_TIMING positions.",
    es: "Lee cartas sequentially from position 1 to 4, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between NOW and BEST_TIMING positions.",
    ca: "Llegeix cartes sequentially from position 1 to 4, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between NOW and BEST_TIMING positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Now and Soon reveals the core dynamic of this situation",
        es: "La relación entre Ahora y Pronto revela la dinámica central de esta situación",
        ca: "La relació entre Ara i Aviat revela la dinàmica central d'aquesta situació",
      },
      positions: ["NOW", "SOON"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["decision", "choice", "option", "crossroads", "dilemma", "path"],
    emotionalStates: ["at crossroads"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "simple",
      experienceLevel: "beginner",
      timeframe: "medium-term",
    },
  },
};


const SHOULD_I_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread clarifies choices, evaluates options, and reveals decision paths. This 3-card spread provides simple level insight into decision, should, yes. Three cards for clear yes/no guidance with perspective",
    es: "Esta spread clarifies choices, evaluates options, and reveals decision paths. Esta 3-card spread provides simple level insight into decision, should, yes. Three cards for clear yes/no guidance with perspective",
    ca: "Aquesta spread clarifies choices, evaluates options, and reveals decision paths. Aquesta 3-card spread provides simple level insight into decision, should, yes. Three cards for clear yes/no guidance with perspective",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on decision, choice, option matters. Ideal for quick insight and clarity. Perfect for questions about decision and should.",
    es: "Elige this spread when tú need guidance on decision, choice, option matters. Ideal for quick insight and clarity. Perfect for questions about decision and should.",
    ca: "Tria this spread when tu need guidance on decision, choice, option matters. Ideal for quick insight and clarity. Perfect for questions about decision and should.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep psychological work, spiritual awakening, passive reflection. If you need more detailed analysis, consider a medium or complex spread.",
    es: "Evita this spread for deep psychological work, spiritual awakening, passive reflection. If you need more detailed analysis, consider a medium or complex spread.",
    ca: "Evita this spread for deep psychological work, spiritual awakening, passive reflection. If you need more detailed analysis, consider a medium or complex spread.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 3, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between YES_PERSPECTIVE and HIGHER_GUIDANCE positions.",
    es: "Lee cartas sequentially from position 1 to 3, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between YES_PERSPECTIVE and HIGHER_GUIDANCE positions.",
    ca: "Llegeix cartes sequentially from position 1 to 3, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between YES_PERSPECTIVE and HIGHER_GUIDANCE positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Yes Perspective and No Perspective reveals the core dynamic of this situation",
        es: "La relación entre Perspectiva Sí y Perspectiva No revela la dinámica central de esta situación",
        ca: "La relació entre Perspectiva Sí i Perspectiva No revela la dinàmica central d'aquesta situació",
      },
      positions: ["YES_PERSPECTIVE", "NO_PERSPECTIVE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["decision", "choice", "option", "crossroads", "dilemma", "path"],
    emotionalStates: ["at crossroads"],
    preferWhen: {
      cardCountPreference: "simple",
      complexityLevel: "simple",
      experienceLevel: "beginner",
      timeframe: "medium-term",
    },
  },
};


const LIFE_CROSSROADS_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread clarifies choices, evaluates options, and reveals decision paths. This 7-card spread provides medium level insight into major decision, life choice, crossroads. Seven cards to navigate major life decisions",
    es: "Esta spread clarifies choices, evaluates options, and reveals decision paths. Esta 7-card spread provides medium level insight into major decision, life choice, crossroads. Seven cards to navigate major life decisions",
    ca: "Aquesta spread clarifies choices, evaluates options, and reveals decision paths. Aquesta 7-card spread provides medium level insight into major decision, life choice, crossroads. Seven cards to navigate major life decisions",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on decision, choice, option matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about major decision and life choice.",
    es: "Elige this spread when tú need guidance on decision, choice, option matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about major decision and life choice.",
    ca: "Tria this spread when tu need guidance on decision, choice, option matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about major decision and life choice.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep psychological work, spiritual awakening, passive reflection. If you need different scope, explore other categories.",
    es: "Evita this spread for deep psychological work, spiritual awakening, passive reflection. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep psychological work, spiritual awakening, passive reflection. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_POSITION and GUIDANCE positions.",
    es: "Lee cartas sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_POSITION and GUIDANCE positions.",
    ca: "Llegeix cartes sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_POSITION and GUIDANCE positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current Position and Path A: Nature reveals the core dynamic of this situation",
        es: "La relación entre Posición Actual y Camino A: Naturaleza revela la dinámica central de esta situación",
        ca: "La relació entre Posició Actual i Camí A: Naturalesa revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_POSITION", "PATH_A_NATURE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Path B: Nature to Guidance shows the natural flow toward resolution",
        es: "La progresión desde Camino B: Naturaleza hasta Guía muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Camí B: Naturalesa fins a Guia mostra el flux natural cap a la resolució",
      },
      positions: ["PATH_B_NATURE", "GUIDANCE"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["decision", "choice", "option", "crossroads", "dilemma", "path"],
    emotionalStates: ["at crossroads"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const LIFE_PATH_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread facilitates self-discovery, personal insight, and inner exploration. This 7-card spread provides medium level insight into self-discovery, life-path, personal-growth. The Fool's Journey applied to your personal path of development",
    es: "Esta spread facilitates self-discovery, personal insight, and inner exploration. Esta 7-card spread provides medium level insight into self-discovery, life-path, personal-growth. The Fool's Journey applied to your personal path of development",
    ca: "Aquesta spread facilitates self-discovery, personal insight, and inner exploration. Aquesta 7-card spread provides medium level insight into self-discovery, life-path, personal-growth. The Fool's Journey applied to your personal path of development",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about self-discovery and life-path.",
    es: "Elige this spread when tú need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about self-discovery and life-path.",
    ca: "Tria this spread when tu need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about self-discovery and life-path.",
  },
  whenToAvoid: {
    en: "Avoid this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
    es: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
    ca: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between BIRTH and LEGACY positions.",
    es: "Lee cartas sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between BIRTH and LEGACY positions.",
    ca: "Llegeix cartes sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between BIRTH and LEGACY positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Birth and Childhood reveals the core dynamic of this situation",
        es: "La relación entre Nacimiento y Infancia revela la dinámica central de esta situación",
        ca: "La relació entre Naixement i Infantesa revela la dinàmica central d'aquesta situació",
      },
      positions: ["BIRTH", "CHILDHOOD"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Challenges to Legacy shows the natural flow toward resolution",
        es: "La progresión desde Desafíos hasta Legado muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Desafiaments fins a Llegat mostra el flux natural cap a la resolució",
      },
      positions: ["CHALLENGES", "LEGACY"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["self", "identity", "personality", "traits", "potential", "inner"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const HIDDEN_TALENTS_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread facilitates self-discovery, personal insight, and inner exploration. This 5-card spread provides medium level insight into self-discovery, talents, abilities. Discover dormant abilities waiting to be awakened",
    es: "Esta spread facilitates self-discovery, personal insight, and inner exploration. Esta 5-card spread provides medium level insight into self-discovery, talents, abilities. Discover dormant abilities waiting to be awakened",
    ca: "Aquesta spread facilitates self-discovery, personal insight, and inner exploration. Aquesta 5-card spread provides medium level insight into self-discovery, talents, abilities. Discover dormant abilities waiting to be awakened",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about self-discovery and talents.",
    es: "Elige this spread when tú need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about self-discovery and talents.",
    ca: "Tria this spread when tu need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about self-discovery and talents.",
  },
  whenToAvoid: {
    en: "Avoid this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
    es: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
    ca: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between VISIBLE_SKILLS and IMPACT positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between VISIBLE_SKILLS and IMPACT positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between VISIBLE_SKILLS and IMPACT positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Visible Skills and Hidden Talent reveals the core dynamic of this situation",
        es: "La relación entre Habilidades Visibles y Talento Oculto revela la dinámica central de esta situación",
        ca: "La relació entre Habilitats Visibles i Talent Ocult revela la dinàmica central d'aquesta situació",
      },
      positions: ["VISIBLE_SKILLS", "HIDDEN_TALENT_1"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Hidden Talent to Impact shows the natural flow toward resolution",
        es: "La progresión desde Talento Oculto hasta Impacto muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Talent Ocult fins a Impacte mostra el flux natural cap a la resolució",
      },
      positions: ["HIDDEN_TALENT_2", "IMPACT"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["self", "identity", "personality", "traits", "potential", "inner"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const PSYCHOLOGICAL_BLOCKS_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread facilitates self-discovery, personal insight, and inner exploration. This 6-card spread provides medium level insight into self-discovery, shadow-work, blocks. Shadow work spread to identify and release inner obstacles",
    es: "Esta spread facilitates self-discovery, personal insight, and inner exploration. Esta 6-card spread provides medium level insight into self-discovery, shadow-work, blocks. Shadow work spread to identify and release inner obstacles",
    ca: "Aquesta spread facilitates self-discovery, personal insight, and inner exploration. Aquesta 6-card spread provides medium level insight into self-discovery, shadow-work, blocks. Shadow work spread to identify and release inner obstacles",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about self-discovery and shadow-work.",
    es: "Elige this spread when tú need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about self-discovery and shadow-work.",
    ca: "Tria this spread when tu need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about self-discovery and shadow-work.",
  },
  whenToAvoid: {
    en: "Avoid this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
    es: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
    ca: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_BLOCK and FREEDOM positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_BLOCK and FREEDOM positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_BLOCK and FREEDOM positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current Block and Origin reveals the core dynamic of this situation",
        es: "La relación entre Bloqueo Actual y Origen revela la dinámica central de esta situación",
        ca: "La relació entre Bloqueig Actual i Origen revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_BLOCK", "ORIGIN"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Fear Behind It to Freedom shows the natural flow toward resolution",
        es: "La progresión desde Miedo Detrás hasta Libertad muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Por Darrere fins a Llibertat mostra el flux natural cap a la resolució",
      },
      positions: ["FEAR", "FREEDOM"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["self", "identity", "personality", "traits", "potential", "inner"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const BEHAVIOR_PATTERNS_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread facilitates self-discovery, personal insight, and inner exploration. This 6-card spread provides medium level insight into self-discovery, patterns, behavior. Circular spread revealing repetitive cycles and how to break them",
    es: "Esta spread facilitates self-discovery, personal insight, and inner exploration. Esta 6-card spread provides medium level insight into self-discovery, patterns, behavior. Circular spread revealing repetitive cycles and how to break them",
    ca: "Aquesta spread facilitates self-discovery, personal insight, and inner exploration. Aquesta 6-card spread provides medium level insight into self-discovery, patterns, behavior. Circular spread revealing repetitive cycles and how to break them",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about self-discovery and patterns.",
    es: "Elige this spread when tú need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about self-discovery and patterns.",
    ca: "Tria this spread when tu need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about self-discovery and patterns.",
  },
  whenToAvoid: {
    en: "Avoid this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
    es: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
    ca: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between PATTERN_1 and NEW_PATTERN positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between PATTERN_1 and NEW_PATTERN positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between PATTERN_1 and NEW_PATTERN positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Pattern 1 and Pattern 2 reveals the core dynamic of this situation",
        es: "La relación entre Patrón 1 y Patrón 2 revela la dinámica central de esta situación",
        ca: "La relació entre Patró 1 i Patró 2 revela la dinàmica central d'aquesta situació",
      },
      positions: ["PATTERN_1", "PATTERN_2"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Root Cause to New Pattern shows the natural flow toward resolution",
        es: "La progresión desde Causa Raíz hasta Nuevo Patrón muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Causa Arrel fins a Nou Patró mostra el flux natural cap a la resolució",
      },
      positions: ["ROOT_CAUSE", "NEW_PATTERN"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["self", "identity", "personality", "traits", "potential", "inner"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const INNER_CHILD_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread facilitates self-discovery, personal insight, and inner exploration. This 5-card spread provides medium level insight into self-discovery, inner-child, healing. Jungian pentagon connecting with wounded and joyful aspects of self",
    es: "Esta spread facilitates self-discovery, personal insight, and inner exploration. Esta 5-card spread provides medium level insight into self-discovery, inner-child, healing. Jungian pentagon connecting with wounded and joyful aspects of self",
    ca: "Aquesta spread facilitates self-discovery, personal insight, and inner exploration. Aquesta 5-card spread provides medium level insight into self-discovery, inner-child, healing. Jungian pentagon connecting with wounded and joyful aspects of self",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about self-discovery and inner-child.",
    es: "Elige this spread when tú need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about self-discovery and inner-child.",
    ca: "Tria this spread when tu need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about self-discovery and inner-child.",
  },
  whenToAvoid: {
    en: "Avoid this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
    es: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
    ca: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between WOUNDED_CHILD and INTEGRATION positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between WOUNDED_CHILD and INTEGRATION positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between WOUNDED_CHILD and INTEGRATION positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Wounded Child and Joyful Child reveals the core dynamic of this situation",
        es: "La relación entre Niño Herido y Niño Gozoso revela la dinámica central de esta situación",
        ca: "La relació entre Infant Ferit i Infant Joiós revela la dinàmica central d'aquesta situació",
      },
      positions: ["WOUNDED_CHILD", "JOYFUL_CHILD"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Message to Integration shows the natural flow toward resolution",
        es: "La progresión desde Mensaje hasta Integración muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Missatge fins a Integració mostra el flux natural cap a la resolució",
      },
      positions: ["MESSAGE", "INTEGRATION"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["self", "identity", "personality", "traits", "potential", "inner"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const SHADOW_SELF_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread facilitates self-discovery, personal insight, and inner exploration. This 6-card spread provides medium level insight into shadow work, self-discovery, integration. Jungian shadow work exploring hidden aspects of self",
    es: "Esta spread facilitates self-discovery, personal insight, and inner exploration. Esta 6-card spread provides medium level insight into shadow work, self-discovery, integration. Jungian shadow work exploring hidden aspects of self",
    ca: "Aquesta spread facilitates self-discovery, personal insight, and inner exploration. Aquesta 6-card spread provides medium level insight into shadow work, self-discovery, integration. Jungian shadow work exploring hidden aspects of self",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about shadow work and self-discovery.",
    es: "Elige this spread when tú need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about shadow work and self-discovery.",
    ca: "Tria this spread when tu need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about shadow work and self-discovery.",
  },
  whenToAvoid: {
    en: "Avoid this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
    es: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
    ca: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between PERSONA and WHOLENESS positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between PERSONA and WHOLENESS positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between PERSONA and WHOLENESS positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Persona and Shadow Aspect 1 reveals the core dynamic of this situation",
        es: "La relación entre Persona y Aspecto Sombra 1 revela la dinámica central de esta situación",
        ca: "La relació entre Persona i Aspecte Ombra 1 revela la dinàmica central d'aquesta situació",
      },
      positions: ["PERSONA", "SHADOW_ASPECT_1"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Gift in Shadow to Wholeness shows the natural flow toward resolution",
        es: "La progresión desde Don en la Sombra hasta Integridad muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Do a l'Ombra fins a Integritat mostra el flux natural cap a la resolució",
      },
      positions: ["GIFT_IN_SHADOW", "WHOLENESS"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["self", "identity", "personality", "traits", "potential", "inner"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const AUTHENTIC_SELF_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread facilitates self-discovery, personal insight, and inner exploration. This 7-card spread provides medium level insight into authenticity, true self, self-discovery. Seven-card spiral discovering your true self beyond conditioning",
    es: "Esta spread facilitates self-discovery, personal insight, and inner exploration. Esta 7-card spread provides medium level insight into authenticity, true self, self-discovery. Seven-card spiral discovering your true self beyond conditioning",
    ca: "Aquesta spread facilitates self-discovery, personal insight, and inner exploration. Aquesta 7-card spread provides medium level insight into authenticity, true self, self-discovery. Seven-card spiral discovering your true self beyond conditioning",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about authenticity and true self.",
    es: "Elige this spread when tú need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about authenticity and true self.",
    ca: "Tria this spread when tu need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about authenticity and true self.",
  },
  whenToAvoid: {
    en: "Avoid this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
    es: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
    ca: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between FALSE_SELF and LIBERATED_SELF positions.",
    es: "Lee cartas sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between FALSE_SELF and LIBERATED_SELF positions.",
    ca: "Llegeix cartes sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between FALSE_SELF and LIBERATED_SELF positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between False Self and Societal Expectations reveals the core dynamic of this situation",
        es: "La relación entre Falso Yo y Expectativas Sociales revela la dinámica central de esta situación",
        ca: "La relació entre Fals Jo i Expectatives Socials revela la dinàmica central d'aquesta situació",
      },
      positions: ["FALSE_SELF", "SOCIETAL_EXPECTATIONS"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Core Essence to Liberated Self shows the natural flow toward resolution",
        es: "La progresión desde Esencia Central hasta Yo Liberado muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Essència Central fins a Jo Alliberat mostra el flux natural cap a la resolució",
      },
      positions: ["CORE_ESSENCE", "LIBERATED_SELF"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["self", "identity", "personality", "traits", "potential", "inner"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const VALUES_CLARIFICATION_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread facilitates self-discovery, personal insight, and inner exploration. This 5-card spread provides medium level insight into values, priorities, alignment. Five-card cross revealing your core values and alignment",
    es: "Esta spread facilitates self-discovery, personal insight, and inner exploration. Esta 5-card spread provides medium level insight into values, priorities, alignment. Five-card cross revealing your core values and alignment",
    ca: "Aquesta spread facilitates self-discovery, personal insight, and inner exploration. Aquesta 5-card spread provides medium level insight into values, priorities, alignment. Five-card cross revealing your core values and alignment",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about values and priorities.",
    es: "Elige this spread when tú need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about values and priorities.",
    ca: "Tria this spread when tu need guidance on self, identity, personality matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about values and priorities.",
  },
  whenToAvoid: {
    en: "Avoid this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
    es: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
    ca: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between CORE_VALUE_1 and ALIGNMENT positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between CORE_VALUE_1 and ALIGNMENT positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between CORE_VALUE_1 and ALIGNMENT positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Core Value 1 and Core Value 2 reveals the core dynamic of this situation",
        es: "La relación entre Valor Central 1 y Valor Central 2 revela la dinámica central de esta situación",
        ca: "La relació entre Valor Central 1 i Valor Central 2 revela la dinàmica central d'aquesta situació",
      },
      positions: ["CORE_VALUE_1", "CORE_VALUE_2"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Core Value 3 to Alignment shows the natural flow toward resolution",
        es: "La progresión desde Valor Central 3 hasta Alineación muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Valor Central 3 fins a Alineació mostra el flux natural cap a la resolució",
      },
      positions: ["CORE_VALUE_3", "ALIGNMENT"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["self", "identity", "personality", "traits", "potential", "inner"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const STRENGTHS_WEAKNESSES_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread facilitates self-discovery, personal insight, and inner exploration. This 8-card spread provides complex level insight into self-assessment, swot, strengths. Eight-card SWOT-style mandala for comprehensive self-assessment",
    es: "Esta spread facilitates self-discovery, personal insight, and inner exploration. Esta 8-card spread provides complex level insight into self-assessment, swot, strengths. Eight-card SWOT-style mandala for comprehensive self-assessment",
    ca: "Aquesta spread facilitates self-discovery, personal insight, and inner exploration. Aquesta 8-card spread provides complex level insight into self-assessment, swot, strengths. Eight-card SWOT-style mandala for comprehensive self-assessment",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on self, identity, personality matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about self-assessment and swot.",
    es: "Elige this spread when tú need guidance on self, identity, personality matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about self-assessment and swot.",
    ca: "Tria this spread when tu need guidance on self, identity, personality matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about self-assessment and swot.",
  },
  whenToAvoid: {
    en: "Avoid this spread for urgent external decisions, relationship analysis with others, financial planning. If you need quick simple answers, use a simpler spread instead.",
    es: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need quick simple answers, use a simpler spread instead.",
    ca: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need quick simple answers, use a simpler spread instead.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between STRENGTH_1 and GROWTH positions.",
    es: "Lee cartas sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between STRENGTH_1 and GROWTH positions.",
    ca: "Llegeix cartes sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between STRENGTH_1 and GROWTH positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Strength 1 and Strength 2 reveals the core dynamic of this situation",
        es: "La relación entre Fortaleza 1 y Fortaleza 2 revela la dinámica central de esta situación",
        ca: "La relació entre Fortalesa 1 i Fortalesa 2 revela la dinàmica central d'aquesta situació",
      },
      positions: ["STRENGTH_1", "STRENGTH_2"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Opportunity to Growth shows the natural flow toward resolution",
        es: "La progresión desde Oportunidad hasta Crecimiento muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Oportunitat fins a Creixement mostra el flux natural cap a la resolució",
      },
      positions: ["OPPORTUNITY", "GROWTH"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["self", "identity", "personality", "traits", "potential", "inner"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "comprehensive",
      complexityLevel: "complex",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const PERSONAL_IDENTITY_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread facilitates self-discovery, personal insight, and inner exploration. This 9-card spread provides complex level insight into identity, self-discovery, who am i. Nine-card grid exploring the multifaceted question: Who am I?",
    es: "Esta spread facilitates self-discovery, personal insight, and inner exploration. Esta 9-card spread provides complex level insight into identity, self-discovery, who am i. Nine-card grid exploring el multifaceted question: Who am I?",
    ca: "Aquesta spread facilitates self-discovery, personal insight, and inner exploration. Aquesta 9-card spread provides complex level insight into identity, self-discovery, who am i. Nine-card grid exploring el multifaceted question: Who am I?",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on self, identity, personality matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about identity and self-discovery.",
    es: "Elige this spread when tú need guidance on self, identity, personality matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about identity and self-discovery.",
    ca: "Tria this spread when tu need guidance on self, identity, personality matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about identity and self-discovery.",
  },
  whenToAvoid: {
    en: "Avoid this spread for urgent external decisions, relationship analysis with others, financial planning. If you need quick simple answers, use a simpler spread instead.",
    es: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need quick simple answers, use a simpler spread instead.",
    ca: "Evita this spread for urgent external decisions, relationship analysis with others, financial planning. If you need quick simple answers, use a simpler spread instead.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 9, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between BODY and CORE positions.",
    es: "Lee cartas sequentially from position 1 to 9, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between BODY and CORE positions.",
    ca: "Llegeix cartes sequentially from position 1 to 9, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between BODY and CORE positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Body and Mind reveals the core dynamic of this situation",
        es: "La relación entre Cuerpo y Mente revela la dinámica central de esta situación",
        ca: "La relació entre Cos i Ment revela la dinàmica central d'aquesta situació",
      },
      positions: ["BODY", "MIND"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Roles to Core shows the natural flow toward resolution",
        es: "La progresión desde Roles hasta Núcleo muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Rols fins a Nucli mostra el flux natural cap a la resolució",
      },
      positions: ["ROLES", "CORE"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["self", "identity", "personality", "traits", "potential", "inner"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "comprehensive",
      complexityLevel: "complex",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const MOVING_RELOCATION_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines life circumstances, practical matters, and everyday situations. This 6-card spread provides medium level insight into relocation, moving, home-change. Six cards exploring decision about changing homes or cities",
    es: "Esta spread examines life circumstances, practical matters, and everyday situations. Esta 6-card spread provides medium level insight into relocation, moving, home-change. Six cards exploring decision about changing homes or cities",
    ca: "Aquesta spread examines life circumstances, practical matters, and everyday situations. Aquesta 6-card spread provides medium level insight into relocation, moving, home-change. Six cards exploring decision about changing homes or cities",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about relocation and moving.",
    es: "Elige this spread when tú need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about relocation and moving.",
    ca: "Tria this spread when tu need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about relocation and moving.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
    es: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_SITUATION and OUTCOME positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_SITUATION and OUTCOME positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_SITUATION and OUTCOME positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current Situation and New Location Energy reveals the core dynamic of this situation",
        es: "La relación entre Situación Actual y Energía de Nueva Ubicación revela la dinámica central de esta situación",
        ca: "La relació entre Situació Actual i Energia de Nova Ubicació revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_SITUATION", "NEW_LOCATION"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Timing Guidance to Potential Outcome shows the natural flow toward resolution",
        es: "La progresión desde Guía de Tiempo hasta Resultado Potencial muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Guia de Temps fins a Resultat Potencial mostra el flux natural cap a la resolució",
      },
      positions: ["TIMING", "OUTCOME"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["life", "situation", "circumstances", "practical", "everyday", "reality"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const TRAVEL_PLANNING_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines life circumstances, practical matters, and everyday situations. This 5-card spread provides medium level insight into travel, journey, trip. Five cards providing guidance for upcoming journey",
    es: "Esta spread examines life circumstances, practical matters, and everyday situations. Esta 5-card spread provides medium level insight into travel, journey, trip. Five cards providing guidance for upcoming journey",
    ca: "Aquesta spread examines life circumstances, practical matters, and everyday situations. Aquesta 5-card spread provides medium level insight into travel, journey, trip. Five cards providing guidance for upcoming journey",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about travel and journey.",
    es: "Elige this spread when tú need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about travel and journey.",
    ca: "Tria this spread when tu need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about travel and journey.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
    es: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between TRAVEL_PURPOSE and BLESSINGS positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between TRAVEL_PURPOSE and BLESSINGS positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between TRAVEL_PURPOSE and BLESSINGS positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Travel Purpose and Key Experiences reveals the core dynamic of this situation",
        es: "La relación entre Propósito del Viaje y Experiencias Clave revela la dinámica central de esta situación",
        ca: "La relació entre Propòsit del Viatge i Experiències Clau revela la dinàmica central d'aquesta situació",
      },
      positions: ["TRAVEL_PURPOSE", "EXPERIENCES"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Insights & Learning to Journey's Blessing shows the natural flow toward resolution",
        es: "La progresión desde Perspectiva y Aprendizaje hasta Bendición del Viaje muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Perspectiva i Aprenentatge fins a Benedicció del Viatge mostra el flux natural cap a la resolució",
      },
      positions: ["INSIGHTS", "BLESSINGS"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["life", "situation", "circumstances", "practical", "everyday", "reality"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const LEGAL_ISSUES_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines life circumstances, practical matters, and everyday situations. This 7-card spread provides medium level insight into legal, justice, court. Seven cards for understanding legal matters and justice",
    es: "Esta spread examines life circumstances, practical matters, and everyday situations. Esta 7-card spread provides medium level insight into legal, justice, court. Seven cards for understanding legal matters and justice",
    ca: "Aquesta spread examines life circumstances, practical matters, and everyday situations. Aquesta 7-card spread provides medium level insight into legal, justice, court. Seven cards for understanding legal matters and justice",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about legal and justice.",
    es: "Elige this spread when tú need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about legal and justice.",
    ca: "Tria this spread when tu need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about legal and justice.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
    es: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between SITUATION_ROOT and ULTIMATE_OUTCOME positions.",
    es: "Lee cartas sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between SITUATION_ROOT and ULTIMATE_OUTCOME positions.",
    ca: "Llegeix cartes sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between SITUATION_ROOT and ULTIMATE_OUTCOME positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Root of Situation and Your Position reveals the core dynamic of this situation",
        es: "La relación entre Raíz de la Situación y Tu Posición revela la dinámica central de esta situación",
        ca: "La relació entre Arrel de la Situació i La Teva Posició revela la dinàmica central d'aquesta situació",
      },
      positions: ["SITUATION_ROOT", "MY_POSITION"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Justice Energy to Ultimate Outcome shows the natural flow toward resolution",
        es: "La progresión desde Energía de Justicia hasta Resultado Final muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Energia de Justícia fins a Resultat Final mostra el flux natural cap a la resolució",
      },
      positions: ["JUSTICE_ENERGY", "ULTIMATE_OUTCOME"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["life", "situation", "circumstances", "practical", "everyday", "reality"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const FAMILY_DYNAMICS_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines life circumstances, practical matters, and everyday situations. This 8-card spread provides complex level insight into family, relationships, patterns. Eight cards for understanding family relationships and patterns",
    es: "Esta spread examines life circumstances, practical matters, and everyday situations. Esta 8-card spread provides complex level insight into family, relationships, patterns. Eight cards for understanding family relationships and patterns",
    ca: "Aquesta spread examines life circumstances, practical matters, and everyday situations. Aquesta 8-card spread provides complex level insight into family, relationships, patterns. Eight cards for understanding family relationships and patterns",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on life, situation, circumstances matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about family and relationships.",
    es: "Elige this spread when tú need guidance on life, situation, circumstances matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about family and relationships.",
    ca: "Tria this spread when tu need guidance on life, situation, circumstances matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about family and relationships.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep spiritual work, professional career guidance, romantic relationships. If you need quick simple answers, use a simpler spread instead.",
    es: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need quick simple answers, use a simpler spread instead.",
    ca: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need quick simple answers, use a simpler spread instead.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between FAMILY_CORE and FAMILY_FUTURE positions.",
    es: "Lee cartas sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between FAMILY_CORE and FAMILY_FUTURE positions.",
    ca: "Llegeix cartes sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between FAMILY_CORE and FAMILY_FUTURE positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Family Core Energy and Your Family Role reveals the core dynamic of this situation",
        es: "La relación entre Energía Central Familiar y Tu Rol Familiar revela la dinámica central de esta situación",
        ca: "La relació entre Energia Central Familiar i El Teu Rol Familiar revela la dinàmica central d'aquesta situació",
      },
      positions: ["FAMILY_CORE", "YOUR_ROLE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Hidden Patterns to Family Future shows the natural flow toward resolution",
        es: "La progresión desde Patrones Ocultos hasta Futuro Familiar muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Patrons Ocults fins a Futur Familiar mostra el flux natural cap a la resolució",
      },
      positions: ["HIDDEN_PATTERNS", "FAMILY_FUTURE"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["life", "situation", "circumstances", "practical", "everyday", "reality"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "comprehensive",
      complexityLevel: "complex",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const FRIENDSHIP_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines life circumstances, practical matters, and everyday situations. This 6-card spread provides medium level insight into friendship, platonic, relationships. Six cards for understanding platonic relationships",
    es: "Esta spread examines life circumstances, practical matters, and everyday situations. Esta 6-card spread provides medium level insight into friendship, platonic, relationships. Six cards for understanding platonic relationships",
    ca: "Aquesta spread examines life circumstances, practical matters, and everyday situations. Aquesta 6-card spread provides medium level insight into friendship, platonic, relationships. Six cards for understanding platonic relationships",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about friendship and platonic.",
    es: "Elige this spread when tú need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about friendship and platonic.",
    ca: "Tria this spread when tu need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about friendship and platonic.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
    es: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between FRIENDSHIP_FOUNDATION and FRIENDSHIP_DESTINY positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between FRIENDSHIP_FOUNDATION and FRIENDSHIP_DESTINY positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between FRIENDSHIP_FOUNDATION and FRIENDSHIP_DESTINY positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Friendship Foundation and What You Bring reveals the core dynamic of this situation",
        es: "La relación entre Fundamento de la Amistad y Lo Que Aportas revela la dinámica central de esta situación",
        ca: "La relació entre Fonament de l'Amistat i El Que Aportes revela la dinàmica central d'aquesta situació",
      },
      positions: ["FRIENDSHIP_FOUNDATION", "YOUR_CONTRIBUTION"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Friendship Challenges to Friendship Destiny shows the natural flow toward resolution",
        es: "La progresión desde Desafíos de la Amistad hasta Destino de la Amistad muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Desafiaments de l'Amistat fins a Destí de l'Amistat mostra el flux natural cap a la resolució",
      },
      positions: ["CHALLENGES", "FRIENDSHIP_DESTINY"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["life", "situation", "circumstances", "practical", "everyday", "reality"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const EDUCATION_STUDY_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines life circumstances, practical matters, and everyday situations. This 6-card spread provides medium level insight into education, study, learning. Six cards providing guidance for learning and academic pursuits",
    es: "Esta spread examines life circumstances, practical matters, and everyday situations. Esta 6-card spread provides medium level insight into education, study, learning. Six cards providing guidance for learning and academic pursuits",
    ca: "Aquesta spread examines life circumstances, practical matters, and everyday situations. Aquesta 6-card spread provides medium level insight into education, study, learning. Six cards providing guidance for learning and academic pursuits",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about education and study.",
    es: "Elige this spread when tú need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about education and study.",
    ca: "Tria this spread when tu need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about education and study.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
    es: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_LEARNING and ACADEMIC_OUTCOME positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_LEARNING and ACADEMIC_OUTCOME positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_LEARNING and ACADEMIC_OUTCOME positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current Learning State and Subject/Area Focus reveals the core dynamic of this situation",
        es: "La relación entre Estado Actual de Aprendizaje y Enfoque de Asignatura/Área revela la dinámica central de esta situación",
        ca: "La relació entre Estat Actual d'Aprenentatge i Enfocament de l'Assignatura/Àrea revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_LEARNING", "SUBJECT_FOCUS"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Challenges to Academic Outcome shows the natural flow toward resolution",
        es: "La progresión desde Desafíos hasta Resultado Académico muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Desafiaments fins a Resultat Acadèmic mostra el flux natural cap a la resolució",
      },
      positions: ["CHALLENGES", "ACADEMIC_OUTCOME"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["life", "situation", "circumstances", "practical", "everyday", "reality"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const CREATIVE_PROJECT_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines life circumstances, practical matters, and everyday situations. This 7-card spread provides medium level insight into creative, project, art. Seven cards exploring bringing creative visions to life",
    es: "Esta spread examines life circumstances, practical matters, and everyday situations. Esta 7-card spread provides medium level insight into creative, project, art. Seven cards exploring bringing creative visions to life",
    ca: "Aquesta spread examines life circumstances, practical matters, and everyday situations. Aquesta 7-card spread provides medium level insight into creative, project, art. Seven cards exploring bringing creative visions to life",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about creative and project.",
    es: "Elige this spread when tú need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about creative and project.",
    ca: "Tria this spread when tu need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about creative and project.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
    es: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CREATIVE_VISION and CREATIVE_OUTCOME positions.",
    es: "Lee cartas sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CREATIVE_VISION and CREATIVE_OUTCOME positions.",
    ca: "Llegeix cartes sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CREATIVE_VISION and CREATIVE_OUTCOME positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Your Creative Vision and Inspiration Source reveals the core dynamic of this situation",
        es: "La relación entre Tu Visión Creativa y Fuente de Inspiración revela la dinámica central de esta situación",
        ca: "La relació entre La Teva Visió Creativa i Font d'Inspiració revela la dinàmica central d'aquesta situació",
      },
      positions: ["CREATIVE_VISION", "INSPIRATION_SOURCE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Creative Obstacles to Creative Outcome shows the natural flow toward resolution",
        es: "La progresión desde Obstáculos Creativos hasta Resultado Creativo muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Obstacles Creatius fins a Resultat Creatiu mostra el flux natural cap a la resolució",
      },
      positions: ["OBSTACLES_TO_CREATION", "CREATIVE_OUTCOME"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["life", "situation", "circumstances", "practical", "everyday", "reality"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const HOME_LIFE_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines life circumstances, practical matters, and everyday situations. This 6-card spread provides medium level insight into home, family, domestic. Six cards exploring domestic harmony and household matters",
    es: "Esta spread examines life circumstances, practical matters, and everyday situations. Esta 6-card spread provides medium level insight into home, family, domestic. Six cards exploring domestic harmony and household matters",
    ca: "Aquesta spread examines life circumstances, practical matters, and everyday situations. Aquesta 6-card spread provides medium level insight into home, family, domestic. Six cards exploring domestic harmony and household matters",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about home and family.",
    es: "Elige this spread when tú need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about home and family.",
    ca: "Tria this spread when tu need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about home and family.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
    es: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between HOME_FOUNDATION and HOME_HARMONY positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between HOME_FOUNDATION and HOME_HARMONY positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between HOME_FOUNDATION and HOME_HARMONY positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Home Foundation and Family Dynamics reveals the core dynamic of this situation",
        es: "La relación entre Fundamento del Hogar y Dinámica Familiar revela la dinámica central de esta situación",
        ca: "La relació entre Fonament de la Llar i Dinàmica Familiar revela la dinàmica central d'aquesta situació",
      },
      positions: ["HOME_FOUNDATION", "FAMILY_DYNAMICS"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Challenges to Future Harmony shows the natural flow toward resolution",
        es: "La progresión desde Desafíos hasta Armonía Futura muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Desafiaments fins a Harmonia Futura mostra el flux natural cap a la resolució",
      },
      positions: ["HOME_CHALLENGES", "HOME_HARMONY"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["life", "situation", "circumstances", "practical", "everyday", "reality"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const PARENTING_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines life circumstances, practical matters, and everyday situations. This 8-card spread provides complex level insight into parenting, children, family. Eight cards offering guidance for raising children",
    es: "Esta spread examines life circumstances, practical matters, and everyday situations. Esta 8-card spread provides complex level insight into parenting, children, family. Eight cards offering guidance for raising children",
    ca: "Aquesta spread examines life circumstances, practical matters, and everyday situations. Aquesta 8-card spread provides complex level insight into parenting, children, family. Eight cards offering guidance for raising children",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on life, situation, circumstances matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about parenting and children.",
    es: "Elige this spread when tú need guidance on life, situation, circumstances matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about parenting and children.",
    ca: "Tria this spread when tu need guidance on life, situation, circumstances matters. Ideal for comprehensive analysis and detailed understanding. Perfect for questions about parenting and children.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep spiritual work, professional career guidance, romantic relationships. If you need quick simple answers, use a simpler spread instead.",
    es: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need quick simple answers, use a simpler spread instead.",
    ca: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need quick simple answers, use a simpler spread instead.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between PARENT_ROLE and PARENTING_OUTCOME positions.",
    es: "Lee cartas sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between PARENT_ROLE and PARENTING_OUTCOME positions.",
    ca: "Llegeix cartes sequentially from position 1 to 8, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to elemental balance, Major Arcana concentration, and card reversals. Look for patterns between PARENT_ROLE and PARENTING_OUTCOME positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Your Parenting Role and Child's Perspective reveals the core dynamic of this situation",
        es: "La relación entre Tu Papel de Padre/Madre y Perspectiva del Niño revela la dinámica central de esta situación",
        ca: "La relació entre El Teu Paper de Pare/Mare i Perspectiva de l'Infant revela la dinàmica central d'aquesta situació",
      },
      positions: ["PARENT_ROLE", "CHILD_PERSPECTIVE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Your Growth as Parent to Long-term Outcome shows the natural flow toward resolution",
        es: "La progresión desde Tu Crecimiento como Padre/Madre hasta Resultado a Largo Plazo muestra el flujo natural hacia la resolución",
        ca: "La progressió des de El Teu Creixement com a Mare/Pare fins a Resultat a Llarg Termini mostra el flux natural cap a la resolució",
      },
      positions: ["PARENTAL_GROWTH", "PARENTING_OUTCOME"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["life", "situation", "circumstances", "practical", "everyday", "reality"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "comprehensive",
      complexityLevel: "complex",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const MAJOR_LIFE_CHANGE_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread examines life circumstances, practical matters, and everyday situations. This 7-card spread provides medium level insight into transition, change, major. Seven cards for navigating significant life transitions",
    es: "Esta spread examines life circumstances, practical matters, and everyday situations. Esta 7-card spread provides medium level insight into transition, change, major. Seven cards for navigating significant life transitions",
    ca: "Aquesta spread examines life circumstances, practical matters, and everyday situations. Aquesta 7-card spread provides medium level insight into transition, change, major. Seven cards for navigating significant life transitions",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about transition and change.",
    es: "Elige this spread when tú need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about transition and change.",
    ca: "Tria this spread when tu need guidance on life, situation, circumstances matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about transition and change.",
  },
  whenToAvoid: {
    en: "Avoid this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
    es: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
    ca: "Evita this spread for deep spiritual work, professional career guidance, romantic relationships. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between WHAT_ENDS and NEW_CHAPTER_ENERGY positions.",
    es: "Lee cartas sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between WHAT_ENDS and NEW_CHAPTER_ENERGY positions.",
    ca: "Llegeix cartes sequentially from position 1 to 7, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between WHAT_ENDS and NEW_CHAPTER_ENERGY positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between What Ends and Reason for Change reveals the core dynamic of this situation",
        es: "La relación entre Lo Que Termina y Razón del Cambio revela la dinámica central de esta situación",
        ca: "La relació entre El Que Acaba i Raó del Canvi revela la dinàmica central d'aquesta situació",
      },
      positions: ["WHAT_ENDS", "REASON_FOR_CHANGE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Transition Challenges to New Chapter Energy shows the natural flow toward resolution",
        es: "La progresión desde Desafíos de Transición hasta Energía del Nuevo Capítulo muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Desafiaments de Transició fins a Energia del Nou Capítol mostra el flux natural cap a la resolució",
      },
      positions: ["TRANSITION_CHALLENGES", "NEW_CHAPTER_ENERGY"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["life", "situation", "circumstances", "practical", "everyday", "reality"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "medium-term",
    },
  },
};


const SIX_MONTH_OUTLOOK_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread reveals temporal patterns, upcoming energies, and future possibilities. This 6-card spread provides medium level insight into forecast, six months, planning. Six month forecast exploring themes and milestones across two quarters",
    es: "Esta spread reveals temporal patterns, upcoming energies, and future possibilities. Esta 6-card spread provides medium level insight into forecast, six months, planning. Six month forecast exploring themes and milestones across two quarters",
    ca: "Aquesta spread reveals temporal patterns, upcoming energies, and future possibilities. Aquesta 6-card spread provides medium level insight into forecast, six months, planning. Six month forecast exploring themes and milestones across two quarters",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on future, timing, forecast matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about forecast and six months.",
    es: "Elige this spread when tú need guidance on future, timing, forecast matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about forecast and six months.",
    ca: "Tria this spread when tu need guidance on future, timing, forecast matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about forecast and six months.",
  },
  whenToAvoid: {
    en: "Avoid this spread for immediate yes/no questions, deep psychological analysis, past life work. If you need different scope, explore other categories.",
    es: "Evita this spread for immediate yes/no questions, deep psychological analysis, past life work. If you need different scope, explore other categories.",
    ca: "Evita this spread for immediate yes/no questions, deep psychological analysis, past life work. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cards for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_MOMENTUM and SIX_MONTH_OUTCOME positions.",
    es: "Lee cartas sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartas for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_MOMENTUM and SIX_MONTH_OUTCOME positions.",
    ca: "Llegeix cartes sequentially from position 1 to 6, building the narrative progressively. Focus first on central positions for the core message, then expand to surrounding cartes for context. Pay attention to suit distribution and numerical progressions. Look for patterns between CURRENT_MOMENTUM and SIX_MONTH_OUTCOME positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Current Momentum and First Quarter Theme reveals the core dynamic of this situation",
        es: "La relación entre Impulso Actual y Tema del Primer Trimestre revela la dinámica central de esta situación",
        ca: "La relació entre Impuls Actual i Tema del Primer Trimestre revela la dinàmica central d'aquesta situació",
      },
      positions: ["CURRENT_MOMENTUM", "FIRST_QUARTER_THEME"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Second Quarter Theme to Six Month Outcome shows the natural flow toward resolution",
        es: "La progresión desde Tema del Segundo Trimestre hasta Resultado de Seis Meses muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Tema del Segon Trimestre fins a Resultat de Sis Mesos mostra el flux natural cap a la resolució",
      },
      positions: ["SECOND_QUARTER_THEME", "SIX_MONTH_OUTCOME"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["future", "timing", "forecast", "upcoming", "timeline", "prediction"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "long-term",
    },
  },
};


const QUARTERLY_FORECAST_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread reveals temporal patterns, upcoming energies, and future possibilities. This 3-card spread provides simple level insight into quarterly, three months, business. Three month business cycle forecast aligned with seasonal rhythms",
    es: "Esta spread reveals temporal patterns, upcoming energies, and future possibilities. Esta 3-card spread provides simple level insight into quarterly, three months, business. Three month business cycle forecast aligned with seasonal rhythms",
    ca: "Aquesta spread reveals temporal patterns, upcoming energies, and future possibilities. Aquesta 3-card spread provides simple level insight into quarterly, three months, business. Three month business cycle forecast aligned with seasonal rhythms",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on future, timing, forecast matters. Ideal for quick insight and clarity. Perfect for questions about quarterly and three months.",
    es: "Elige this spread when tú need guidance on future, timing, forecast matters. Ideal for quick insight and clarity. Perfect for questions about quarterly and three months.",
    ca: "Tria this spread when tu need guidance on future, timing, forecast matters. Ideal for quick insight and clarity. Perfect for questions about quarterly and three months.",
  },
  whenToAvoid: {
    en: "Avoid this spread for immediate yes/no questions, deep psychological analysis, past life work. If you need more detailed analysis, consider a medium or complex spread.",
    es: "Evita this spread for immediate yes/no questions, deep psychological analysis, past life work. If you need more detailed analysis, consider a medium or complex spread.",
    ca: "Evita this spread for immediate yes/no questions, deep psychological analysis, past life work. If you need more detailed analysis, consider a medium or complex spread.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 3, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between QUARTER_THEME and QUARTER_OUTCOME positions.",
    es: "Lee cartas sequentially from position 1 to 3, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between QUARTER_THEME and QUARTER_OUTCOME positions.",
    ca: "Llegeix cartes sequentially from position 1 to 3, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between QUARTER_THEME and QUARTER_OUTCOME positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Quarter Theme and Central Challenge reveals the core dynamic of this situation",
        es: "La relación entre Tema del Trimestre y Desafío Central revela la dinámica central de esta situación",
        ca: "La relació entre Tema del Trimestre i Desafiament Central revela la dinàmica central d'aquesta situació",
      },
      positions: ["QUARTER_THEME", "CENTRAL_CHALLENGE"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["future", "timing", "forecast", "upcoming", "timeline", "prediction"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "simple",
      complexityLevel: "simple",
      experienceLevel: "beginner",
      timeframe: "long-term",
    },
  },
};


const MONTHLY_FORECAST_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread reveals temporal patterns, upcoming energies, and future possibilities. This 4-card spread provides simple level insight into monthly, month ahead, weekly flow. Four card month ahead guidance with week-by-week flow",
    es: "Esta spread reveals temporal patterns, upcoming energies, and future possibilities. Esta 4-card spread provides simple level insight into monthly, month ahead, weekly flow. Four card month ahead guidance with week-by-week flow",
    ca: "Aquesta spread reveals temporal patterns, upcoming energies, and future possibilities. Aquesta 4-card spread provides simple level insight into monthly, month ahead, weekly flow. Four card month ahead guidance with week-by-week flow",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on future, timing, forecast matters. Ideal for quick insight and clarity. Perfect for questions about monthly and month ahead.",
    es: "Elige this spread when tú need guidance on future, timing, forecast matters. Ideal for quick insight and clarity. Perfect for questions about monthly and month ahead.",
    ca: "Tria this spread when tu need guidance on future, timing, forecast matters. Ideal for quick insight and clarity. Perfect for questions about monthly and month ahead.",
  },
  whenToAvoid: {
    en: "Avoid this spread for immediate yes/no questions, deep psychological analysis, past life work. If you need more detailed analysis, consider a medium or complex spread.",
    es: "Evita this spread for immediate yes/no questions, deep psychological analysis, past life work. If you need more detailed analysis, consider a medium or complex spread.",
    ca: "Evita this spread for immediate yes/no questions, deep psychological analysis, past life work. If you need more detailed analysis, consider a medium or complex spread.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 4, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between MONTH_OPENING and MONTH_RESOLUTION positions.",
    es: "Lee cartas sequentially from position 1 to 4, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between MONTH_OPENING and MONTH_RESOLUTION positions.",
    ca: "Llegeix cartes sequentially from position 1 to 4, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between MONTH_OPENING and MONTH_RESOLUTION positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Month Opening and Mid-Month Development reveals the core dynamic of this situation",
        es: "La relación entre Apertura del Mes y Desarrollo a Mediados de Mes revela la dinámica central de esta situación",
        ca: "La relació entre Obertura del Mes i Desenvolupament de Mitjans de Mes revela la dinàmica central d'aquesta situació",
      },
      positions: ["MONTH_OPENING", "MID_MONTH_DEVELOPMENT"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["future", "timing", "forecast", "upcoming", "timeline", "prediction"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "simple",
      experienceLevel: "beginner",
      timeframe: "long-term",
    },
  },
};


const SPECIFIC_EVENT_TIMING_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread reveals temporal patterns, upcoming energies, and future possibilities. This 5-card spread provides medium level insight into timing, when, event. Five card spread revealing when a specific event will unfold and what conditions surround it",
    es: "Esta spread reveals temporal patterns, upcoming energies, and future possibilities. Esta 5-card spread provides medium level insight into timing, when, event. Five card spread revealing when a specific event will unfold and what conditions surround it",
    ca: "Aquesta spread reveals temporal patterns, upcoming energies, and future possibilities. Aquesta 5-card spread provides medium level insight into timing, when, event. Five card spread revealing when a specific event will unfold and what conditions surround it",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on future, timing, forecast matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about timing and when.",
    es: "Elige this spread when tú need guidance on future, timing, forecast matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about timing and when.",
    ca: "Tria this spread when tu need guidance on future, timing, forecast matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about timing and when.",
  },
  whenToAvoid: {
    en: "Avoid this spread for immediate yes/no questions, deep psychological analysis, past life work. If you need different scope, explore other categories.",
    es: "Evita this spread for immediate yes/no questions, deep psychological analysis, past life work. If you need different scope, explore other categories.",
    ca: "Evita this spread for immediate yes/no questions, deep psychological analysis, past life work. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between TIMEFRAME and EVENT_NATURE positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between TIMEFRAME and EVENT_NATURE positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between TIMEFRAME and EVENT_NATURE positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Timeframe and Building Factors reveals the core dynamic of this situation",
        es: "La relación entre Marco de Tiempo y Factores en Construcción revela la dinámica central de esta situación",
        ca: "La relació entre Període de Temps i Factors en Construcció revela la dinàmica central d'aquesta situació",
      },
      positions: ["TIMEFRAME", "BUILDING_FACTORS"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Catalyst to Event Nature shows the natural flow toward resolution",
        es: "La progresión desde Catalizador hasta Naturaleza del Evento muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Catalizador fins a Naturalesa de l'Esdeveniment mostra el flux natural cap a la resolució",
      },
      positions: ["CATALYST", "EVENT_NATURE"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["future", "timing", "forecast", "upcoming", "timeline", "prediction"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "long-term",
    },
  },
};


const FOUR_SEASONS_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread reveals temporal patterns, upcoming energies, and future possibilities. This 5-card spread provides medium level insight into timing, annual, seasons. Five card annual cycle exploring each season's energy and the year's overarching theme",
    es: "Esta spread reveals temporal patterns, upcoming energies, and future possibilities. Esta 5-card spread provides medium level insight into timing, annual, seasons. Five card annual cycle exploring each season's energy and el year's overarching theme",
    ca: "Aquesta spread reveals temporal patterns, upcoming energies, and future possibilities. Aquesta 5-card spread provides medium level insight into timing, annual, seasons. Five card annual cycle exploring each season's energy and el year's overarching theme",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on future, timing, forecast matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about timing and annual.",
    es: "Elige this spread when tú need guidance on future, timing, forecast matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about timing and annual.",
    ca: "Tria this spread when tu need guidance on future, timing, forecast matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about timing and annual.",
  },
  whenToAvoid: {
    en: "Avoid this spread for immediate yes/no questions, deep psychological analysis, past life work. If you need different scope, explore other categories.",
    es: "Evita this spread for immediate yes/no questions, deep psychological analysis, past life work. If you need different scope, explore other categories.",
    ca: "Evita this spread for immediate yes/no questions, deep psychological analysis, past life work. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between SPRING and WINTER positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between SPRING and WINTER positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between SPRING and WINTER positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Spring and Summer reveals the core dynamic of this situation",
        es: "La relación entre Primavera y Verano revela la dinámica central de esta situación",
        ca: "La relació entre Primavera i Estiu revela la dinàmica central d'aquesta situació",
      },
      positions: ["SPRING", "SUMMER"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Year's Theme to Winter shows the natural flow toward resolution",
        es: "La progresión desde Tema del Año hasta Invierno muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Tema de l'Any fins a Hivern mostra el flux natural cap a la resolució",
      },
      positions: ["YEAR_THEME", "WINTER"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["future", "timing", "forecast", "upcoming", "timeline", "prediction"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "long-term",
    },
  },
};


const NEXT_STEPS_TIMELINE_EDUCATIONAL: SpreadEducationalContent = {
  purpose: {
    en: "This spread reveals temporal patterns, upcoming energies, and future possibilities. This 5-card spread provides medium level insight into timing, action, plan. Five card sequential action plan revealing immediate, short, medium, long-term steps and final outcome",
    es: "Esta spread reveals temporal patterns, upcoming energies, and future possibilities. Esta 5-card spread provides medium level insight into timing, action, plan. Five card sequential action plan revealing immediate, short, medium, long-term steps and final outcome",
    ca: "Aquesta spread reveals temporal patterns, upcoming energies, and future possibilities. Aquesta 5-card spread provides medium level insight into timing, action, plan. Five card sequential action plan revealing immediate, short, medium, long-term steps and final outcome",
  },
  whenToUse: {
    en: "Choose this spread when you need guidance on future, timing, forecast matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about timing and action.",
    es: "Elige this spread when tú need guidance on future, timing, forecast matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about timing and action.",
    ca: "Tria this spread when tu need guidance on future, timing, forecast matters. Ideal for balanced depth without overwhelming complexity. Perfect for questions about timing and action.",
  },
  whenToAvoid: {
    en: "Avoid this spread for immediate yes/no questions, deep psychological analysis, past life work. If you need different scope, explore other categories.",
    es: "Evita this spread for immediate yes/no questions, deep psychological analysis, past life work. If you need different scope, explore other categories.",
    ca: "Evita this spread for immediate yes/no questions, deep psychological analysis, past life work. If you need different scope, explore other categories.",
  },
  interpretationMethod: {
    en: "Read cards sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between IMMEDIATE_ACTION and FINAL_OUTCOME positions.",
    es: "Lee cartas sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between IMMEDIATE_ACTION and FINAL_OUTCOME positions.",
    ca: "Llegeix cartes sequentially from position 1 to 5, building the narrative progressively. Each position builds upon the previous, creating a clear story arc. Pay attention to suit distribution and numerical progressions. Look for patterns between IMMEDIATE_ACTION and FINAL_OUTCOME positions.",
  },
  positionInteractions: [
    {
      description: {
        en: "The relationship between Immediate Action and Short Term (1-2 months) reveals the core dynamic of this situation",
        es: "La relación entre Acción Inmediata y Corto Plazo (1-2 meses) revela la dinámica central de esta situación",
        ca: "La relació entre Acció Immediata i Curt Termini (1-2 mesos) revela la dinàmica central d'aquesta situació",
      },
      positions: ["IMMEDIATE_ACTION", "SHORT_TERM"],
      aiGuidance: "Compare these two positions for contrast or harmony. Look for complementary or opposing energies.",
    },
    {
      description: {
        en: "The progression from Medium Term (3-6 months) to Final Outcome shows the natural flow toward resolution",
        es: "La progresión desde Plazo Medio (3-6 meses) hasta Resultado Final muestra el flujo natural hacia la resolución",
        ca: "La progressió des de Termini Mitjà (3-6 mesos) fins a Resultat Final mostra el flux natural cap a la resolució",
      },
      positions: ["MEDIUM_TERM", "FINAL_OUTCOME"],
      aiGuidance: "Track the energy shift from middle to end. Does it show improvement, challenge, or transformation?",
    }
  ],
  aiSelectionCriteria: {
    questionPatterns: ["future", "timing", "forecast", "upcoming", "timeline", "prediction"],
    emotionalStates: ["seeking guidance"],
    preferWhen: {
      cardCountPreference: "moderate",
      complexityLevel: "medium",
      experienceLevel: "all",
      timeframe: "long-term",
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
  celtic_cross: CELTIC_CROSS_EDUCATIONAL,
  star: STAR_EDUCATIONAL,
  astrological: ASTROLOGICAL_EDUCATIONAL,
  year_ahead: YEAR_AHEAD_EDUCATIONAL,
  morning_guidance: MORNING_GUIDANCE_EDUCATIONAL,
  evening_reflection: EVENING_REFLECTION_EDUCATIONAL,
  weekly_overview: WEEKLY_OVERVIEW_EDUCATIONAL,
  yes_no: YES_NO_EDUCATIONAL,
  quick_insight: QUICK_INSIGHT_EDUCATIONAL,
  new_love_potential: NEW_LOVE_POTENTIAL_EDUCATIONAL,
  healing_breakup: HEALING_BREAKUP_EDUCATIONAL,
  soulmate_search: SOULMATE_SEARCH_EDUCATIONAL,
  compatibility_check: COMPATIBILITY_CHECK_EDUCATIONAL,
  marriage_decision: MARRIAGE_DECISION_EDUCATIONAL,
  dating_guidance: DATING_GUIDANCE_EDUCATIONAL,
  toxic_relationship: TOXIC_RELATIONSHIP_EDUCATIONAL,
  self_love_journey: SELF_LOVE_JOURNEY_EDUCATIONAL,
  intimacy_issues: INTIMACY_ISSUES_EDUCATIONAL,
  partnership_balance: PARTNERSHIP_BALANCE_EDUCATIONAL,
  love_triangle: LOVE_TRIANGLE_EDUCATIONAL,
  job_search: JOB_SEARCH_EDUCATIONAL,
  interview_prep: INTERVIEW_PREP_EDUCATIONAL,
  promotion_path: PROMOTION_PATH_EDUCATIONAL,
  career_change: CAREER_CHANGE_EDUCATIONAL,
  work_conflicts: WORK_CONFLICTS_EDUCATIONAL,
  team_dynamics: TEAM_DYNAMICS_EDUCATIONAL,
  entrepreneurship: ENTREPRENEURSHIP_EDUCATIONAL,
  side_hustle: SIDE_HUSTLE_EDUCATIONAL,
  work_life_balance: WORK_LIFE_BALANCE_EDUCATIONAL,
  career_purpose: CAREER_PURPOSE_EDUCATIONAL,
  negotiation_strategy: NEGOTIATION_STRATEGY_EDUCATIONAL,
  professional_growth: PROFESSIONAL_GROWTH_EDUCATIONAL,
  financial_overview: FINANCIAL_OVERVIEW_EDUCATIONAL,
  investment_decision: INVESTMENT_DECISION_EDUCATIONAL,
  debt_management: DEBT_MANAGEMENT_EDUCATIONAL,
  salary_negotiation: SALARY_NEGOTIATION_EDUCATIONAL,
  abundance_mindset: ABUNDANCE_MINDSET_EDUCATIONAL,
  business_finances: BUSINESS_FINANCES_EDUCATIONAL,
  savings_goals: SAVINGS_GOALS_EDUCATIONAL,
  financial_blocks: FINANCIAL_BLOCKS_EDUCATIONAL,
  money_flow: MONEY_FLOW_EDUCATIONAL,
  prosperity_path: PROSPERITY_PATH_EDUCATIONAL,
  spiritual_path: SPIRITUAL_PATH_EDUCATIONAL,
  chakra_alignment: CHAKRA_ALIGNMENT_EDUCATIONAL,
  shadow_work: SHADOW_WORK_EDUCATIONAL,
  life_purpose: LIFE_PURPOSE_EDUCATIONAL,
  spiritual_awakening: SPIRITUAL_AWAKENING_EDUCATIONAL,
  past_life: PAST_LIFE_EDUCATIONAL,
  spirit_guides: SPIRIT_GUIDES_EDUCATIONAL,
  psychic_development: PSYCHIC_DEVELOPMENT_EDUCATIONAL,
  full_moon_ritual: FULL_MOON_RITUAL_EDUCATIONAL,
  new_moon_intentions: NEW_MOON_INTENTIONS_EDUCATIONAL,
  meditation_journey: MEDITATION_JOURNEY_EDUCATIONAL,
  sacred_calling: SACRED_CALLING_EDUCATIONAL,
  health_check: HEALTH_CHECK_EDUCATIONAL,
  mental_health: MENTAL_HEALTH_EDUCATIONAL,
  energy_healing: ENERGY_HEALING_EDUCATIONAL,
  stress_relief: STRESS_RELIEF_EDUCATIONAL,
  burnout_recovery: BURNOUT_RECOVERY_EDUCATIONAL,
  body_wisdom: BODY_WISDOM_EDUCATIONAL,
  holistic_wellness: HOLISTIC_WELLNESS_EDUCATIONAL,
  healing_journey: HEALING_JOURNEY_EDUCATIONAL,
  three_options: THREE_OPTIONS_EDUCATIONAL,
  opportunity_evaluation: OPPORTUNITY_EVALUATION_EDUCATIONAL,
  risk_assessment: RISK_ASSESSMENT_EDUCATIONAL,
  timing_decision: TIMING_DECISION_EDUCATIONAL,
  should_i: SHOULD_I_EDUCATIONAL,
  life_crossroads: LIFE_CROSSROADS_EDUCATIONAL,
  life_path: LIFE_PATH_EDUCATIONAL,
  hidden_talents: HIDDEN_TALENTS_EDUCATIONAL,
  psychological_blocks: PSYCHOLOGICAL_BLOCKS_EDUCATIONAL,
  behavior_patterns: BEHAVIOR_PATTERNS_EDUCATIONAL,
  inner_child: INNER_CHILD_EDUCATIONAL,
  shadow_self: SHADOW_SELF_EDUCATIONAL,
  authentic_self: AUTHENTIC_SELF_EDUCATIONAL,
  values_clarification: VALUES_CLARIFICATION_EDUCATIONAL,
  strengths_weaknesses: STRENGTHS_WEAKNESSES_EDUCATIONAL,
  personal_identity: PERSONAL_IDENTITY_EDUCATIONAL,
  moving_relocation: MOVING_RELOCATION_EDUCATIONAL,
  travel_planning: TRAVEL_PLANNING_EDUCATIONAL,
  legal_issues: LEGAL_ISSUES_EDUCATIONAL,
  family_dynamics: FAMILY_DYNAMICS_EDUCATIONAL,
  friendship: FRIENDSHIP_EDUCATIONAL,
  education_study: EDUCATION_STUDY_EDUCATIONAL,
  creative_project: CREATIVE_PROJECT_EDUCATIONAL,
  home_life: HOME_LIFE_EDUCATIONAL,
  parenting: PARENTING_EDUCATIONAL,
  major_life_change: MAJOR_LIFE_CHANGE_EDUCATIONAL,
  six_month_outlook: SIX_MONTH_OUTLOOK_EDUCATIONAL,
  quarterly_forecast: QUARTERLY_FORECAST_EDUCATIONAL,
  monthly_forecast: MONTHLY_FORECAST_EDUCATIONAL,
  specific_event_timing: SPECIFIC_EVENT_TIMING_EDUCATIONAL,
  four_seasons: FOUR_SEASONS_EDUCATIONAL,
  next_steps_timeline: NEXT_STEPS_TIMELINE_EDUCATIONAL,
};

