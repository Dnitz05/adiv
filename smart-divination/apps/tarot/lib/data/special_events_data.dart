import '../models/special_event.dart';

/// Repository for Special Moon Events
/// Based on verified astronomical and astrological traditions
class SpecialEventsData {
  static const List<SpecialEvent> events = [
    // Solar Eclipse - When Moon blocks the Sun
    SpecialEvent(
      id: 'solar_eclipse',
      icon: '🌑',
      name: 'Solar Eclipse',
      localizedNames: {
        'en': 'Solar Eclipse',
        'es': 'Eclipse Solar',
        'ca': 'Eclipsi Solar',
      },
      type: 'eclipse',
      scientificExplanation: {
        'en': 'A solar eclipse occurs when the Moon passes between Earth and the Sun, temporarily blocking the Sun\'s light. This can only happen during a New Moon when the three celestial bodies align.',
        'es': 'Un eclipse solar ocurre cuando la Luna pasa entre la Tierra y el Sol, bloqueando temporalmente la luz del Sol. Esto solo puede suceder durante la Luna Nueva cuando los tres cuerpos celestiales se alinean.',
        'ca': 'Un eclipsi solar ocorre quan la Lluna passa entre la Terra i el Sol, bloquejant temporalment la llum del Sol. Això només pot succeir durant la Lluna Nova quan els tres cossos celestials s\'alineen.',
      },
      astrologicalMeaning: {
        'en': 'Solar eclipses mark powerful new beginnings and unexpected shifts in consciousness. They represent karmic turning points where the light of awareness is temporarily obscured, allowing us to see what was hidden in plain sight.',
        'es': 'Los eclipses solares marcan poderosos nuevos comienzos y cambios inesperados en la conciencia. Representan puntos de inflexión kármicos donde la luz de la conciencia se oscurece temporalmente, permitiéndonos ver lo que estaba oculto a plena vista.',
        'ca': 'Els eclipsis solars marquen nous començaments poderosos i canvis inesperats en la consciència. Representen punts d\'inflexió kàrmics on la llum de la consciència s\'enfosqueix temporalment, permetent-nos veure el que estava amagat a ple dia.',
      },
      description: {
        'en': 'Solar eclipses are among the most powerful astrological events, bringing sudden revelations, fated encounters, and dramatic new chapters. Their effects can be felt for 6 months before and after. These are cosmic reset buttons that close old doors and open unexpected new paths.',
        'es': 'Los eclipses solares son entre los eventos astrológicos más poderosos, trayendo revelaciones repentinas, encuentros predestinados y capítulos dramáticamente nuevos. Sus efectos se pueden sentir durante 6 meses antes y después. Son botones de reinicio cósmico que cierran puertas viejas y abren caminos nuevos inesperados.',
        'ca': 'Els eclipsis solars són entre els esdeveniments astrològics més poderosos, portant revelacions sobtades, trobades predestinades i capítols dramàticament nous. Els seus efectes es poden sentir durant 6 mesos abans i després. Són botons de reinici còsmic que tanquen portes velles i obren camins nous inesperats.',
      },
      spiritualThemes: {
        'en': [
          'Destiny and fate',
          'Sudden revelations',
          'New beginnings',
          'Shadow work',
          'Karmic completion',
        ],
        'es': [
          'Destino y fatalidad',
          'Revelaciones repentinas',
          'Nuevos comienzos',
          'Trabajo de sombra',
          'Completación kármica',
        ],
        'ca': [
          'Destí i fatalitat',
          'Revelacions sobtades',
          'Nous començaments',
          'Treball d\'ombra',
          'Completació kàrmica',
        ],
      },
      practices: {
        'en': [
          'Meditate on what needs to end and what wants to begin',
          'Journal about unexpected insights and synchronicities',
          'Release old patterns that no longer serve you',
          'Set intentions for the next 6-month cycle',
          'Observe without forcing - let the eclipse work its magic',
        ],
        'es': [
          'Medita sobre lo que necesita terminar y lo que quiere comenzar',
          'Escribe sobre ideas inesperadas y sincronicidades',
          'Libera patrones antiguos que ya no te sirven',
          'Establece intenciones para el próximo ciclo de 6 meses',
          'Observa sin forzar - deja que el eclipse haga su magia',
        ],
        'ca': [
          'Medita sobre el que necessita acabar i el que vol començar',
          'Escriu sobre idees inesperades i sincronicitats',
          'Allibera patrons antics que ja no et serveixen',
          'Estableix intencions per al proper cicle de 6 mesos',
          'Observa sense forçar - deixa que l\'eclipsi faci la seva màgia',
        ],
      },
      whatToAvoid: {
        'en': [
          'Making major decisions on eclipse day - wait 3 days',
          'Starting important projects during the eclipse window',
          'Forcing outcomes or trying to control results',
          'Traditional manifestation rituals (eclipses reveal, not create)',
        ],
        'es': [
          'Tomar decisiones importantes el día del eclipse - espera 3 días',
          'Comenzar proyectos importantes durante la ventana del eclipse',
          'Forzar resultados o intentar controlar los resultados',
          'Rituales tradicionales de manifestación (los eclipses revelan, no crean)',
        ],
        'ca': [
          'Prendre decisions importants el dia de l\'eclipsi - espera 3 dies',
          'Començar projectes importants durant la finestra de l\'eclipsi',
          'Forçar resultats o intentar controlar els resultats',
          'Rituals tradicionals de manifestació (els eclipsis revelen, no creen)',
        ],
      },
      frequency: '2-5 times per year',
      color: '#1A1A1A',
      intensity: 'high',
    ),

    // Lunar Eclipse - Earth's shadow on Moon
    SpecialEvent(
      id: 'lunar_eclipse',
      icon: '🌕',
      name: 'Lunar Eclipse',
      localizedNames: {
        'en': 'Lunar Eclipse',
        'es': 'Eclipse Lunar',
        'ca': 'Eclipsi Lunar',
      },
      type: 'eclipse',
      scientificExplanation: {
        'en': 'A lunar eclipse occurs when Earth passes between the Sun and Moon, casting its shadow on the Moon. This can only happen during a Full Moon when the alignment is precise. The Moon often appears reddish (Blood Moon) due to Earth\'s atmosphere filtering sunlight.',
        'es': 'Un eclipse lunar ocurre cuando la Tierra pasa entre el Sol y la Luna, proyectando su sombra sobre la Luna. Esto solo puede suceder durante la Luna Llena cuando la alineación es precisa. La Luna a menudo aparece rojiza (Luna de Sangre) debido a que la atmósfera terrestre filtra la luz solar.',
        'ca': 'Un eclipsi lunar ocorre quan la Terra passa entre el Sol i la Lluna, projectant la seva ombra sobre la Lluna. Això només pot succeir durant la Lluna Plena quan l\'alineació és precisa. La Lluna sovint apareix vermellosa (Lluna de Sang) perquè l\'atmosfera terrestre filtra la llum solar.',
      },
      astrologicalMeaning: {
        'en': 'Lunar eclipses illuminate what has been building in our emotional and subconscious realms. They bring climactic endings, emotional revelations, and the culmination of processes that began 6 months prior. They reveal hidden truths and bring closure.',
        'es': 'Los eclipses lunares iluminan lo que ha estado creciendo en nuestros reinos emocionales y subconscientes. Traen finales climáticos, revelaciones emocionales y la culminación de procesos que comenzaron 6 meses antes. Revelan verdades ocultas y traen cierre.',
        'ca': 'Els eclipsis lunars il·luminen el que ha estat creixent en els nostres regnes emocionals i subconscients. Porten finals climàtics, revelacions emocionals i la culminació de processos que van començar 6 mesos abans. Revelen veritats ocultes i porten tancament.',
      },
      description: {
        'en': 'Lunar eclipses are emotional super-full moons that bring intense feelings to the surface for release. They mark major endings, revelations about relationships, and the completion of emotional cycles. The Blood Moon appearance adds to their mystical power.',
        'es': 'Los eclipses lunares son super-lunas llenas emocionales que traen sentimientos intensos a la superficie para ser liberados. Marcan finales importantes, revelaciones sobre relaciones y la finalización de ciclos emocionales. La apariencia de Luna de Sangre añade a su poder místico.',
        'ca': 'Els eclipsis lunars són súper-llunes plenes emocionals que porten sentiments intensos a la superfície per ser alliberats. Marquen finals importants, revelacions sobre relacions i la finalització de cicles emocionals. L\'aparença de Lluna de Sang afegeix al seu poder místic.',
      },
      spiritualThemes: {
        'en': [
          'Emotional release and catharsis',
          'Relationship revelations',
          'Endings and closure',
          'Shadow integration',
          'Truth and authenticity',
        ],
        'es': [
          'Liberación emocional y catarsis',
          'Revelaciones de relaciones',
          'Finales y cierre',
          'Integración de sombra',
          'Verdad y autenticidad',
        ],
        'ca': [
          'Alliberament emocional i catarsi',
          'Revelacions de relacions',
          'Finals i tancament',
          'Integració d\'ombra',
          'Veritat i autenticitat',
        ],
      },
      practices: {
        'en': [
          'Release rituals - let go of what no longer serves',
          'Emotional journaling about relationships and patterns',
          'Full moon water charging under the eclipse',
          'Forgiveness work for self and others',
          'Witness and honor your emotions without judgment',
        ],
        'es': [
          'Rituales de liberación - suelta lo que ya no sirve',
          'Escritura emocional sobre relaciones y patrones',
          'Carga de agua de luna llena bajo el eclipse',
          'Trabajo de perdón para ti y otros',
          'Presencia y honra tus emociones sin juicio',
        ],
        'ca': [
          'Rituals d\'alliberament - deixa anar el que ja no serveix',
          'Escriptura emocional sobre relacions i patrons',
          'Càrrega d\'aigua de lluna plena sota l\'eclipsi',
          'Treball de perdó per a tu i els altres',
          'Presencia i honra les teves emocions sense judici',
        ],
      },
      whatToAvoid: {
        'en': [
          'Suppressing emotions - let them flow',
          'Making permanent decisions in the emotional intensity',
          'Burning bridges - wait until emotions settle',
          'Looking directly at the eclipse without eye protection',
        ],
        'es': [
          'Suprimir emociones - déjalas fluir',
          'Tomar decisiones permanentes en la intensidad emocional',
          'Quemar puentes - espera hasta que las emociones se asienten',
          'Mirar directamente al eclipse sin protección ocular',
        ],
        'ca': [
          'Suprimir emocions - deixa-les fluir',
          'Prendre decisions permanents en la intensitat emocional',
          'Cremar ponts - espera fins que les emocions s\'assentuin',
          'Mirar directament l\'eclipsi sense protecció ocular',
        ],
      },
      frequency: '2-4 times per year',
      color: '#8B0000',
      intensity: 'high',
    ),

    // Supermoon - Perigee Full Moon
    SpecialEvent(
      id: 'supermoon',
      icon: '🌕',
      name: 'Supermoon',
      localizedNames: {
        'en': 'Supermoon',
        'es': 'Superluna',
        'ca': 'Superluna',
      },
      type: 'phenomenon',
      scientificExplanation: {
        'en': 'A supermoon occurs when a full moon coincides with the Moon\'s closest approach to Earth (perigee). The Moon can appear up to 14% larger and 30% brighter than when it\'s at its farthest point. This happens because the Moon\'s orbit is elliptical, not circular.',
        'es': 'Una superluna ocurre cuando una luna llena coincide con el acercamiento más cercano de la Luna a la Tierra (perigeo). La Luna puede aparecer hasta un 14% más grande y un 30% más brillante que cuando está en su punto más lejano. Esto sucede porque la órbita de la Luna es elíptica, no circular.',
        'ca': 'Una superluna ocorre quan una lluna plena coincideix amb l\'apropament més proper de la Lluna a la Terra (perigeu). La Lluna pot aparèixer fins a un 14% més gran i un 30% més brillant que quan està al seu punt més llunyà. Això passa perquè l\'òrbita de la Lluna és el·líptica, no circular.',
      },
      astrologicalMeaning: {
        'en': 'Supermoons amplify the emotional and psychic energy of regular full moons. They bring heightened intuition, stronger manifestations, and more intense emotional experiences. The Moon\'s proximity makes her influence more palpable and powerful.',
        'es': 'Las superlunas amplifican la energía emocional y psíquica de las lunas llenas regulares. Traen intuición elevada, manifestaciones más fuertes y experiencias emocionales más intensas. La proximidad de la Luna hace que su influencia sea más palpable y poderosa.',
        'ca': 'Les superlunes amplifiquen l\'energia emocional i psíquica de les llunes plenes regulars. Porten intuïció elevada, manifestacions més fortes i experiències emocionals més intenses. La proximitat de la Lluna fa que la seva influència sigui més palpable i poderosa.',
      },
      description: {
        'en': 'Supermoons are visually stunning and energetically potent. They enhance all the qualities of a full moon - illumination, completion, release - but with added intensity. Emotions run higher, dreams are more vivid, and the veil between worlds feels thinner.',
        'es': 'Las superlunas son visualmente impresionantes y energéticamente potentes. Mejoran todas las cualidades de una luna llena - iluminación, finalización, liberación - pero con intensidad añadida. Las emociones son más altas, los sueños son más vívidos y el velo entre mundos se siente más delgado.',
        'ca': 'Les superlunes són visualment impressionants i energèticament potents. Milloren totes les qualitats d\'una lluna plena - il·luminació, finalització, alliberament - però amb intensitat afegida. Les emocions són més altes, els somnis són més vius i el vel entre mons se sent més prim.',
      },
      spiritualThemes: {
        'en': [
          'Amplified intuition and psychic awareness',
          'Powerful manifestation and release',
          'Heightened emotional sensitivity',
          'Vivid dreams and visions',
          'Connection to lunar goddess energy',
        ],
        'es': [
          'Intuición amplificada y conciencia psíquica',
          'Manifestación y liberación poderosas',
          'Sensibilidad emocional elevada',
          'Sueños y visiones vívidos',
          'Conexión con la energía de la diosa lunar',
        ],
        'ca': [
          'Intuïció amplificada i consciència psíquica',
          'Manifestació i alliberament poderosos',
          'Sensibilitat emocional elevada',
          'Somnis i visions vius',
          'Connexió amb l\'energia de la deessa lunar',
        ],
      },
      practices: {
        'en': [
          'Moon bathing - absorb the amplified lunar energy',
          'Create moon water with extra charging power',
          'Divination and oracle work (heightened intuition)',
          'Release ceremony for what no longer serves',
          'Gratitude ritual for manifestations received',
          'Dream journaling (dreams will be more vivid)',
        ],
        'es': [
          'Baño de luna - absorbe la energía lunar amplificada',
          'Crea agua de luna con poder de carga extra',
          'Trabajo de adivinación y oráculo (intuición elevada)',
          'Ceremonia de liberación para lo que ya no sirve',
          'Ritual de gratitud por manifestaciones recibidas',
          'Diario de sueños (los sueños serán más vívidos)',
        ],
        'ca': [
          'Bany de lluna - absorbeix l\'energia lunar amplificada',
          'Crea aigua de lluna amb poder de càrrega extra',
          'Treball d\'endevinació i oracle (intuïció elevada)',
          'Cerimònia d\'alliberament per al que ja no serveix',
          'Ritual de gratitud per manifestacions rebudes',
          'Diari de somnis (els somnis seran més vius)',
        ],
      },
      whatToAvoid: {
        'en': [
          'Overreacting to emotions - they\'re amplified',
          'Making impulsive decisions under heightened feelings',
          'Ignoring the need for rest (energy can be draining)',
          'Dismissing intuitive hits as "too intense"',
        ],
        'es': [
          'Reaccionar exageradamente a las emociones - están amplificadas',
          'Tomar decisiones impulsivas bajo sentimientos elevados',
          'Ignorar la necesidad de descanso (la energía puede ser agotadora)',
          'Descartar golpes intuitivos como "demasiado intensos"',
        ],
        'ca': [
          'Reaccionar exageradament a les emocions - estan amplificades',
          'Prendre decisions impulsives sota sentiments elevats',
          'Ignorar la necessitat de descans (l\'energia pot ser esgotadora)',
          'Descartar cops intuitius com a "massa intensos"',
        ],
      },
      frequency: '3-4 times per year',
      color: '#FFD700',
      intensity: 'high',
    ),

    // Blue Moon - Second Full Moon in a Month
    SpecialEvent(
      id: 'blue_moon',
      icon: '🔵',
      name: 'Blue Moon',
      localizedNames: {
        'en': 'Blue Moon',
        'es': 'Luna Azul',
        'ca': 'Lluna Blava',
      },
      type: 'phenomenon',
      scientificExplanation: {
        'en': 'A blue moon is the second full moon occurring within a single calendar month. This happens every 2-3 years because the lunar cycle (29.5 days) is shorter than most months. The term "once in a blue moon" reflects its rarity. Note: The Moon doesn\'t actually appear blue unless atmospheric conditions create that effect.',
        'es': 'Una luna azul es la segunda luna llena que ocurre dentro de un solo mes calendario. Esto sucede cada 2-3 años porque el ciclo lunar (29.5 días) es más corto que la mayoría de los meses. El término "una vez cada luna azul" refleja su rareza. Nota: La Luna realmente no aparece azul a menos que las condiciones atmosféricas creen ese efecto.',
        'ca': 'Una lluna blava és la segona lluna plena que ocorre dins d\'un sol mes de calendari. Això passa cada 2-3 anys perquè el cicle lunar (29,5 dies) és més curt que la majoria dels mesos. El terme "una vegada cada lluna blava" reflecteix la seva raresa. Nota: La Lluna realment no apareix blava tret que les condicions atmosfèriques creïn aquest efecte.',
      },
      astrologicalMeaning: {
        'en': 'Blue moons carry the energy of "bonus opportunity" - a second chance to work with the same zodiac sign\'s full moon themes in one month. They amplify manifestation power and offer unexpected blessings. This is cosmic grace giving you extra time to complete something.',
        'es': 'Las lunas azules llevan la energía de "oportunidad extra" - una segunda oportunidad para trabajar con los temas de luna llena del mismo signo zodiacal en un mes. Amplifican el poder de manifestación y ofrecen bendiciones inesperadas. Esta es gracia cósmica que te da tiempo extra para completar algo.',
        'ca': 'Les llunes blaves porten l\'energia d\'"oportunitat extra" - una segona oportunitat per treballar amb els temes de lluna plena del mateix signe zodiacal en un mes. Amplifiquen el poder de manifestació i ofereixen benediccions inesperades. Aquesta és gràcia còsmica que et dóna temps extra per completar alguna cosa.',
      },
      description: {
        'en': 'Blue moons are rare gifts from the cosmos, occurring only once every 2-3 years. They represent second chances, bonus opportunities, and the magic of unexpected timing. Whatever full moon energy you worked with earlier in the month gets a powerful encore.',
        'es': 'Las lunas azules son regalos raros del cosmos, ocurriendo solo una vez cada 2-3 años. Representan segundas oportunidades, oportunidades extra y la magia del tiempo inesperado. Cualquier energía de luna llena con la que trabajaste antes en el mes obtiene un encore poderoso.',
        'ca': 'Les llunes blaves són regals rars del cosmos, ocorrent només una vegada cada 2-3 anys. Representen segones oportunitats, oportunitats extra i la màgia del temps inesperat. Qualsevol energia de lluna plena amb la qual vas treballar abans en el mes obté un encore poderós.',
      },
      spiritualThemes: {
        'en': [
          'Second chances and do-overs',
          'Completing unfinished business',
          'Bonus manifestation power',
          'Unexpected blessings',
          'Rare opportunity and timing',
        ],
        'es': [
          'Segundas oportunidades y repeticiones',
          'Completar asuntos pendientes',
          'Poder de manifestación extra',
          'Bendiciones inesperadas',
          'Oportunidad rara y timing',
        ],
        'ca': [
          'Segones oportunitats i repeticions',
          'Completar assumptes pendents',
          'Poder de manifestació extra',
          'Benediccions inesperades',
          'Oportunitat rara i timing',
        ],
      },
      practices: {
        'en': [
          'Revisit intentions from the first full moon of the month',
          'Complete projects or goals you started but didn\'t finish',
          'Double manifestation ritual (twice the moon, twice the power)',
          'Gratitude practice for second chances in life',
          'Ask: "What deserves another try?"',
        ],
        'es': [
          'Revisa intenciones de la primera luna llena del mes',
          'Completa proyectos u objetivos que comenzaste pero no terminaste',
          'Ritual de manifestación doble (dos veces la luna, dos veces el poder)',
          'Práctica de gratitud por segundas oportunidades en la vida',
          'Pregunta: "¿Qué merece otro intento?"',
        ],
        'ca': [
          'Revisa intencions de la primera lluna plena del mes',
          'Completa projectes o objectius que vas començar però no vas acabar',
          'Ritual de manifestació doble (dues vegades la lluna, dues vegades el poder)',
          'Pràctica de gratitud per segones oportunitats a la vida',
          'Pregunta: "Què mereix un altre intent?"',
        ],
      },
      whatToAvoid: {
        'en': [
          'Wasting the rare opportunity on trivial matters',
          'Thinking "I already did this" and missing the gift',
          'Being too practical - blue moons are magical',
          'Forgetting to acknowledge the rarity and specialness',
        ],
        'es': [
          'Desperdiciar la oportunidad rara en asuntos triviales',
          'Pensar "Ya hice esto" y perder el regalo',
          'Ser demasiado práctico - las lunas azules son mágicas',
          'Olvidar reconocer la rareza y especialidad',
        ],
        'ca': [
          'Malgastar l\'oportunitat rara en assumptes trivials',
          'Pensar "Ja vaig fer això" i perdre el regal',
          'Ser massa pràctic - les llunes blaves són màgiques',
          'Oblidar reconèixer la raresa i especialitat',
        ],
      },
      frequency: 'Every 2-3 years',
      color: '#4169E1',
      intensity: 'medium',
    ),

    // Void of Course Moon
    SpecialEvent(
      id: 'void_of_course',
      icon: '🌫️',
      name: 'Void of Course Moon',
      localizedNames: {
        'en': 'Void of Course Moon',
        'es': 'Luna Vacía de Curso',
        'ca': 'Lluna Buida de Curs',
      },
      type: 'astrological',
      scientificExplanation: {
        'en': 'A void of course Moon occurs during the time between the Moon\'s last major aspect (conjunction, sextile, square, trine, opposition) in one zodiac sign and its entrance into the next sign. This period can last from a few minutes to over a day, depending on the Moon\'s speed and position.',
        'es': 'Una Luna vacía de curso ocurre durante el tiempo entre el último aspecto mayor de la Luna (conjunción, sextil, cuadratura, trígono, oposición) en un signo zodiacal y su entrada en el siguiente signo. Este período puede durar desde unos minutos hasta más de un día, dependiendo de la velocidad y posición de la Luna.',
        'ca': 'Una Lluna buida de curs ocorre durant el temps entre l\'últim aspecte major de la Lluna (conjunció, sextil, quadratura, trígon, oposició) en un signe zodiacal i la seva entrada al següent signe. Aquest període pot durar des d\'uns minuts fins a més d\'un dia, depenent de la velocitat i posició de la Lluna.',
      },
      astrologicalMeaning: {
        'en': 'When the Moon is void of course, it\'s in a liminal state - between worlds, unanchored. Traditional astrology teaches that actions taken during this time often "come to nothing" or don\'t turn out as planned. It\'s a time when the universe says "pause and reflect" rather than "act and initiate."',
        'es': 'Cuando la Luna está vacía de curso, está en un estado liminal - entre mundos, sin ancla. La astrología tradicional enseña que las acciones tomadas durante este tiempo a menudo "no llevan a nada" o no resultan como se planificó. Es un momento en que el universo dice "pausa y reflexiona" en lugar de "actúa e inicia."',
        'ca': 'Quan la Lluna està buida de curs, està en un estat liminal - entre mons, sense ancoratge. L\'astrologia tradicional ensenya que les accions preses durant aquest temps sovint "no porten a res" o no resulten com es va planificar. És un moment en què l\'univers diu "pausa i reflexiona" en lloc d\'"actua i inicia."',
      },
      description: {
        'en': 'The void of course Moon creates a dreamy, unfocused energy where normal cause-and-effect seems suspended. It\'s excellent for rest, contemplation, and routine tasks, but not ideal for starting new projects or making important decisions. Think of it as cosmic "downtime" that occurs several times per week.',
        'es': 'La Luna vacía de curso crea una energía soñadora y desenfocada donde la causa-efecto normal parece suspendida. Es excelente para el descanso, la contemplación y las tareas rutinarias, pero no es ideal para comenzar nuevos proyectos o tomar decisiones importantes. Piénsalo como "tiempo de inactividad" cósmico que ocurre varias veces por semana.',
        'ca': 'La Lluna buida de curs crea una energia somniadora i desenfocada on la causa-efecte normal sembla suspesa. És excel·lent per al descans, la contemplació i les tasques rutinàries, però no és ideal per començar nous projectes o prendre decisions importants. Pensa-ho com "temps d\'inactivitat" còsmic que ocorre diverses vegades per setmana.',
      },
      spiritualThemes: {
        'en': [
          'Rest and integration',
          'Liminal spaces and transitions',
          'Going with the flow',
          'Releasing control',
          'Spiritual contemplation',
        ],
        'es': [
          'Descanso e integración',
          'Espacios liminales y transiciones',
          'Fluir con la corriente',
          'Soltar el control',
          'Contemplación espiritual',
        ],
        'ca': [
          'Descans i integració',
          'Espais liminals i transicions',
          'Fluir amb el corrent',
          'Deixar anar el control',
          'Contemplació espiritual',
        ],
      },
      practices: {
        'en': [
          'Meditation and contemplative practices',
          'Journaling and reflection',
          'Routine tasks and admin work',
          'Rest and self-care',
          'Creative work without attachment to outcomes',
          'Tying up loose ends from previous projects',
        ],
        'es': [
          'Meditación y prácticas contemplativas',
          'Escritura y reflexión',
          'Tareas rutinarias y trabajo administrativo',
          'Descanso y autocuidado',
          'Trabajo creativo sin apego a resultados',
          'Atar cabos sueltos de proyectos anteriores',
        ],
        'ca': [
          'Meditació i pràctiques contemplatives',
          'Escriptura i reflexió',
          'Tasques rutinàries i treball administratiu',
          'Descans i autocura',
          'Treball creatiu sense apegament als resultats',
          'Lligar caps solts de projectes anteriors',
        ],
      },
      whatToAvoid: {
        'en': [
          'Starting new projects or businesses',
          'Making important decisions or signing contracts',
          'Major purchases (especially expensive items)',
          'Job interviews or first dates',
          'Launching products or initiatives',
          'Anything where you need a specific outcome',
        ],
        'es': [
          'Comenzar nuevos proyectos o negocios',
          'Tomar decisiones importantes o firmar contratos',
          'Compras importantes (especialmente artículos caros)',
          'Entrevistas de trabajo o primeras citas',
          'Lanzar productos o iniciativas',
          'Cualquier cosa donde necesites un resultado específico',
        ],
        'ca': [
          'Començar nous projectes o negocis',
          'Prendre decisions importants o signar contractes',
          'Compres importants (especialment articles cars)',
          'Entrevistes de feina o primeres cites',
          'Llançar productes o iniciatives',
          'Qualsevol cosa on necessitis un resultat específic',
        ],
      },
      frequency: 'Multiple times per week (every 2-3 days)',
      color: '#B0C4DE',
      intensity: 'low',
    ),

    // Black Moon Lilith
    SpecialEvent(
      id: 'black_moon_lilith',
      icon: '🌑',
      name: 'Black Moon Lilith',
      localizedNames: {
        'en': 'Black Moon Lilith',
        'es': 'Luna Negra Lilith',
        'ca': 'Lluna Negra Lilith',
      },
      type: 'astrological',
      scientificExplanation: {
        'en': 'Black Moon Lilith is the lunar apogee - the point in the Moon\'s elliptical orbit where it is farthest from Earth. This is not a physical celestial body but a calculated point that moves through the zodiac, spending about 9 months in each sign. It represents the Moon\'s most distant, shadowy position.',
        'es': 'La Luna Negra Lilith es el apogeo lunar - el punto en la órbita elíptica de la Luna donde está más lejos de la Tierra. No es un cuerpo celestial físico sino un punto calculado que se mueve a través del zodíaco, pasando aproximadamente 9 meses en cada signo. Representa la posición más distante y sombría de la Luna.',
        'ca': 'La Lluna Negra Lilith és l\'apogeu lunar - el punt en l\'òrbita el·líptica de la Lluna on està més lluny de la Terra. No és un cos celestial físic sinó un punt calculat que es mou a través del zodíac, passant aproximadament 9 mesos en cada signe. Representa la posició més distant i ombria de la Lluna.',
      },
      astrologicalMeaning: {
        'en': 'Black Moon Lilith represents the wild, untamed, rejected feminine - the parts of ourselves we\'ve been taught to suppress or hide. She embodies sexual power, rage, authenticity, and the refusal to be controlled. In mythology, Lilith was Adam\'s first wife who refused to be submissive. She represents liberation through embracing the shadow.',
        'es': 'La Luna Negra Lilith representa lo femenino salvaje, indomable y rechazado - las partes de nosotros mismos que nos han enseñado a suprimir u ocultar. Encarna el poder sexual, la rabia, la autenticidad y la negativa a ser controlados. En la mitología, Lilith fue la primera esposa de Adán que se negó a ser sumisa. Representa la liberación a través de abrazar la sombra.',
        'ca': 'La Lluna Negra Lilith representa el femení salvatge, indomable i rebutjat - les parts de nosaltres mateixos que ens han ensenyat a suprimir o amagar. Encarna el poder sexual, la ràbia, l\'autenticitat i la negativa a ser controlats. En la mitologia, Lilith va ser la primera esposa d\'Adam que es va negar a ser submisa. Representa l\'alliberament a través d\'abraçar l\'ombra.',
      },
      description: {
        'en': 'Black Moon Lilith is the astrological symbol of the Dark Goddess - raw, primal feminine power that refuses to be tamed or controlled. She shows us where we\'ve experienced rejection, where we hold sexual shame or power, and where we need to reclaim our wildness. Working with Lilith means confronting taboos and owning all parts of ourselves.',
        'es': 'La Luna Negra Lilith es el símbolo astrológico de la Diosa Oscura - poder femenino crudo y primario que se niega a ser domado o controlado. Nos muestra dónde hemos experimentado rechazo, dónde tenemos vergüenza o poder sexual, y dónde necesitamos reclamar nuestra naturaleza salvaje. Trabajar con Lilith significa confrontar tabúes y apropiarnos de todas las partes de nosotros mismos.',
        'ca': 'La Lluna Negra Lilith és el símbol astrològic de la Deessa Fosca - poder femení cru i primari que es nega a ser domesticat o controlat. Ens mostra on hem experimentat rebuig, on tenim vergonya o poder sexual, i on necessitem reclamar la nostra naturalesa salvatge. Treballar amb Lilith significa confrontar tabús i apropiar-nos de totes les parts de nosaltres mateixos.',
      },
      spiritualThemes: {
        'en': [
          'Shadow work and integration',
          'Sexual power and autonomy',
          'Rage and healthy anger',
          'Rejecting patriarchal conditioning',
          'Wild, untamed nature',
        ],
        'es': [
          'Trabajo de sombra e integración',
          'Poder y autonomía sexual',
          'Rabia y enojo saludable',
          'Rechazar el condicionamiento patriarcal',
          'Naturaleza salvaje e indomable',
        ],
        'ca': [
          'Treball d\'ombra i integració',
          'Poder i autonomia sexual',
          'Ràbia i enuig saludable',
          'Rebutjar el condicionament patriarcal',
          'Naturalesa salvatge i indomable',
        ],
      },
      practices: {
        'en': [
          'Shadow journaling about rejected or hidden parts of self',
          'Explore where you\'ve been shamed for your power',
          'Reclaim your sexuality and sensuality on your own terms',
          'Express anger in healthy, constructive ways',
          'Study Lilith in your birth chart (sign and house)',
          'Honor the Dark Goddess through ritual',
        ],
        'es': [
          'Escritura de sombra sobre partes rechazadas u ocultas del yo',
          'Explora dónde has sido avergonzado por tu poder',
          'Reclama tu sexualidad y sensualidad en tus propios términos',
          'Expresa la rabia de formas saludables y constructivas',
          'Estudia a Lilith en tu carta natal (signo y casa)',
          'Honra a la Diosa Oscura a través del ritual',
        ],
        'ca': [
          'Escriptura d\'ombra sobre parts rebutjades o ocultes del jo',
          'Explora on has estat avergonyit pel teu poder',
          'Reclama la teva sexualitat i sensualitat en els teus propis termes',
          'Expressa la ràbia de maneres saludables i constructives',
          'Estudia Lilith a la teva carta natal (signe i casa)',
          'Honra la Deessa Fosca a través del ritual',
        ],
      },
      whatToAvoid: {
        'en': [
          'Suppressing anger or pretending to be "nice"',
          'Shaming yourself for sexual desires or power',
          'Allowing others to control or diminish you',
          'Fearing your own wildness and authenticity',
          'Dismissing Lilith as "too dark" or "negative"',
        ],
        'es': [
          'Suprimir la rabia o pretender ser "amable"',
          'Avergonzarte de deseos o poder sexual',
          'Permitir que otros te controlen o disminuyan',
          'Temer tu propia naturaleza salvaje y autenticidad',
          'Descartar a Lilith como "demasiado oscura" o "negativa"',
        ],
        'ca': [
          'Suprimir la ràbia o fingir ser "amable"',
          'Avergonyir-te de desitjos o poder sexual',
          'Permetre que altres et controlin o disminueixin',
          'Témer la teva pròpia naturalesa salvatge i autenticitat',
          'Descartar Lilith com a "massa fosca" o "negativa"',
        ],
      },
      frequency: '9 months per zodiac sign',
      color: '#2C0E4B',
      intensity: 'high',
    ),
  ];

  /// Get event by ID
  static SpecialEvent? getEventById(String id) {
    try {
      return events.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get events by type
  static List<SpecialEvent> getEventsByType(String type) {
    return events.where((event) => event.type == type).toList();
  }

  /// Get high intensity events (eclipses, supermoons, Lilith)
  static List<SpecialEvent> getHighIntensityEvents() {
    return events.where((event) => event.intensity == 'high').toList();
  }
}
