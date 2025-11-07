// Model for lunar rituals
class LunarRitual {
  final String id;
  final String nameEn;
  final String nameEs;
  final String nameCa;
  final String descriptionEn;
  final String descriptionEs;
  final String descriptionCa;
  final List<String> phases; // Which moon phases this ritual is for
  final String category; // manifestation, release, healing, protection, abundance
  final int durationMinutes;
  final String difficulty; // beginner, intermediate, advanced
  final List<String> materialsEn;
  final List<String> materialsEs;
  final List<String> materialsCa;
  final List<RitualStep> stepsEn;
  final List<RitualStep> stepsEs;
  final List<RitualStep> stepsCa;
  final List<String> intentionsEn;
  final List<String> intentionsEs;
  final List<String> intentionsCa;
  final String iconEmoji;

  const LunarRitual({
    required this.id,
    required this.nameEn,
    required this.nameEs,
    required this.nameCa,
    required this.descriptionEn,
    required this.descriptionEs,
    required this.descriptionCa,
    required this.phases,
    required this.category,
    required this.durationMinutes,
    required this.difficulty,
    required this.materialsEn,
    required this.materialsEs,
    required this.materialsCa,
    required this.stepsEn,
    required this.stepsEs,
    required this.stepsCa,
    required this.intentionsEn,
    required this.intentionsEs,
    required this.intentionsCa,
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

  List<String> getMaterials(String locale) {
    switch (locale) {
      case 'es':
        return materialsEs;
      case 'ca':
        return materialsCa;
      default:
        return materialsEn;
    }
  }

  List<RitualStep> getSteps(String locale) {
    switch (locale) {
      case 'es':
        return stepsEs;
      case 'ca':
        return stepsCa;
      default:
        return stepsEn;
    }
  }

  List<String> getIntentions(String locale) {
    switch (locale) {
      case 'es':
        return intentionsEs;
      case 'ca':
        return intentionsCa;
      default:
        return intentionsEn;
    }
  }
}

class RitualStep {
  final String title;
  final String description;
  final int order;

  const RitualStep({
    required this.title,
    required this.description,
    required this.order,
  });
}

// Ritual Repository with 20 curated rituals
class LunarRitualRepository {
  static final List<LunarRitual> allRituals = [
    // NEW MOON RITUALS (4)
    LunarRitual(
      id: 'new_moon_intentions',
      nameEn: 'New Moon Intention Setting',
      nameEs: 'Establecer Intenciones de Luna Nueva',
      nameCa: 'Establir Intencions de Lluna Nova',
      descriptionEn: 'Set powerful intentions for the lunar cycle ahead with focused energy and clarity',
      descriptionEs: 'Establece intenciones poderosas para el ciclo lunar con energía enfocada y claridad',
      descriptionCa: 'Estableix intencions poderoses per al cicle lunar amb energia enfocada i claredat',
      phases: ['new_moon'],
      category: 'manifestation',
      durationMinutes: 30,
      difficulty: 'beginner',
      materialsEn: ['Journal or paper', 'Pen', 'Candle (white or black)', 'Quiet space'],
      materialsEs: ['Diario o papel', 'Bolígrafo', 'Vela (blanca o negra)', 'Espacio tranquilo'],
      materialsCa: ['Diari o paper', 'Bolígraf', 'Espelma (blanca o negra)', 'Espai tranquil'],
      stepsEn: [
        RitualStep(order: 1, title: 'Create Sacred Space', description: 'Find a quiet place where you won\'t be disturbed. Light your candle to mark the beginning.'),
        RitualStep(order: 2, title: 'Ground and Center', description: 'Take 5 deep breaths. Feel your connection to the earth and the new moon\'s energy.'),
        RitualStep(order: 3, title: 'Reflect on Desires', description: 'Ask yourself: What do I want to create in this lunar cycle? What new beginning calls to me?'),
        RitualStep(order: 4, title: 'Write Your Intentions', description: 'Write 3-5 specific, positive intentions in present tense. Be clear and heartfelt.'),
        RitualStep(order: 5, title: 'Visualize Success', description: 'Close your eyes and visualize each intention as already manifest. Feel the emotions.'),
        RitualStep(order: 6, title: 'Seal with Gratitude', description: 'Thank the moon and universe. Blow out the candle. Keep your intentions somewhere visible.'),
      ],
      stepsEs: [
        RitualStep(order: 1, title: 'Crear Espacio Sagrado', description: 'Encuentra un lugar tranquilo donde no te molesten. Enciende tu vela para marcar el comienzo.'),
        RitualStep(order: 2, title: 'Arraigarse y Centrarse', description: 'Toma 5 respiraciones profundas. Siente tu conexión con la tierra y la energía de la luna nueva.'),
        RitualStep(order: 3, title: 'Reflexionar sobre Deseos', description: '¿Qué quiero crear en este ciclo lunar? ¿Qué nuevo comienzo me llama?'),
        RitualStep(order: 4, title: 'Escribir Intenciones', description: 'Escribe 3-5 intenciones específicas y positivas en presente. Sé claro y sincero.'),
        RitualStep(order: 5, title: 'Visualizar Éxito', description: 'Cierra los ojos y visualiza cada intención como ya manifestada. Siente las emociones.'),
        RitualStep(order: 6, title: 'Sellar con Gratitud', description: 'Agradece a la luna y al universo. Apaga la vela. Guarda tus intenciones donde sean visibles.'),
      ],
      stepsCa: [
        RitualStep(order: 1, title: 'Crear Espai Sagrat', description: 'Troba un lloc tranquil on no et molesti. Encén l\'espelma per marcar el començament.'),
        RitualStep(order: 2, title: 'Arrelar-se i Centrar-se', description: 'Pren 5 respiracions profundes. Sent la connexió amb la terra i l\'energia de la lluna nova.'),
        RitualStep(order: 3, title: 'Reflexionar sobre Desitjos', description: 'Què vull crear en aquest cicle lunar? Quin nou començament em crida?'),
        RitualStep(order: 4, title: 'Escriure Intencions', description: 'Escriu 3-5 intencions específiques i positives en present. Sigues clar i sincer.'),
        RitualStep(order: 5, title: 'Visualitzar Èxit', description: 'Tanca els ulls i visualitza cada intenció ja manifestada. Sent les emocions.'),
        RitualStep(order: 6, title: 'Segell amb Gratitud', description: 'Agraeix a la lluna i l\'univers. Apaga l\'espelma. Guarda les intencions on siguin visibles.'),
      ],
      intentionsEn: ['New beginnings', 'Fresh starts', 'Planting seeds', 'Setting goals'],
      intentionsEs: ['Nuevos comienzos', 'Inicios frescos', 'Plantar semillas', 'Establecer metas'],
      intentionsCa: ['Nous començaments', 'Inicis frescos', 'Plantar llavors', 'Establir objectius'],
      iconEmoji: '🌑',
    ),

    LunarRitual(
      id: 'new_moon_vision_board',
      nameEn: 'New Moon Vision Board',
      nameEs: 'Tablero de Visión Luna Nueva',
      nameCa: 'Tauler de Visió Lluna Nova',
      descriptionEn: 'Create a visual representation of your dreams and goals for the coming cycle',
      descriptionEs: 'Crea una representación visual de tus sueños y metas para el próximo ciclo',
      descriptionCa: 'Crea una representació visual dels teus somnis i objectius pel proper cicle',
      phases: ['new_moon'],
      category: 'manifestation',
      durationMinutes: 45,
      difficulty: 'beginner',
      materialsEn: ['Poster board or corkboard', 'Magazines', 'Scissors', 'Glue', 'Photos', 'Markers'],
      materialsEs: ['Cartulina o tablero', 'Revistas', 'Tijeras', 'Pegamento', 'Fotos', 'Marcadores'],
      materialsCa: ['Cartolina o tauler', 'Revistes', 'Tisores', 'Enganxina', 'Fotos', 'Retoladors'],
      stepsEn: [
        RitualStep(order: 1, title: 'Gather Materials', description: 'Collect magazines, photos, and materials that inspire you.'),
        RitualStep(order: 2, title: 'Set Intentions', description: 'Meditate on what you want to manifest. Write it down first.'),
        RitualStep(order: 3, title: 'Find Images', description: 'Cut out images, words, and phrases that resonate with your goals.'),
        RitualStep(order: 4, title: 'Arrange Mindfully', description: 'Arrange pieces on your board in a way that feels right. Trust your intuition.'),
        RitualStep(order: 5, title: 'Glue and Create', description: 'Glue down your vision. Add personal touches with markers or photos.'),
        RitualStep(order: 6, title: 'Display Prominently', description: 'Place your vision board where you\'ll see it daily. Let it inspire action.'),
      ],
      stepsEs: [
        RitualStep(order: 1, title: 'Reunir Materiales', description: 'Reúne revistas, fotos y materiales que te inspiren.'),
        RitualStep(order: 2, title: 'Establecer Intenciones', description: 'Medita sobre lo que quieres manifestar. Escríbelo primero.'),
        RitualStep(order: 3, title: 'Encontrar Imágenes', description: 'Recorta imágenes, palabras y frases que resuenen con tus metas.'),
        RitualStep(order: 4, title: 'Organizar Conscientemente', description: 'Organiza las piezas en tu tablero de forma intuitiva.'),
        RitualStep(order: 5, title: 'Pegar y Crear', description: 'Pega tu visión. Añade toques personales con marcadores o fotos.'),
        RitualStep(order: 6, title: 'Mostrar Prominentemente', description: 'Coloca tu tablero donde lo veas diariamente. Deja que inspire acción.'),
      ],
      stepsCa: [
        RitualStep(order: 1, title: 'Reunir Materials', description: 'Reuneix revistes, fotos i materials que t\'inspirin.'),
        RitualStep(order: 2, title: 'Establir Intencions', description: 'Medita sobre el que vols manifestar. Escriu-ho primer.'),
        RitualStep(order: 3, title: 'Trobar Imatges', description: 'Retalla imatges, paraules i frases que ressonin amb els teus objectius.'),
        RitualStep(order: 4, title: 'Organitzar Conscientment', description: 'Organitza les peces al teu tauler de forma intuïtiva.'),
        RitualStep(order: 5, title: 'Enganxar i Crear', description: 'Enganxa la teva visió. Afegeix tocs personals amb retoladors o fotos.'),
        RitualStep(order: 6, title: 'Mostrar Prominentment', description: 'Col·loca el teu tauler on el vegis diàriament. Deixa que inspiri acció.'),
      ],
      intentionsEn: ['Visualization', 'Goal clarity', 'Creative manifestation', 'Inspiration'],
      intentionsEs: ['Visualización', 'Claridad de metas', 'Manifestación creativa', 'Inspiración'],
      intentionsCa: ['Visualització', 'Claredat d\'objectius', 'Manifestació creativa', 'Inspiració'],
      iconEmoji: '🎨',
    ),

    LunarRitual(
      id: 'new_moon_seed_planting',
      nameEn: 'New Moon Seed Ritual',
      nameEs: 'Ritual de Semillas Luna Nueva',
      nameCa: 'Ritual de Llavors Lluna Nova',
      descriptionEn: 'Plant physical seeds as symbolic representation of your intentions taking root',
      descriptionEs: 'Planta semillas físicas como representación simbólica de tus intenciones arraigándose',
      descriptionCa: 'Planta llavors físiques com a representació simbòlica de les teves intencions arrelant-se',
      phases: ['new_moon'],
      category: 'manifestation',
      durationMinutes: 40,
      difficulty: 'beginner',
      materialsEn: ['Seeds (herbs or flowers)', 'Pot with soil', 'Water', 'Small stones or crystals', 'Paper for intentions'],
      materialsEs: ['Semillas (hierbas o flores)', 'Maceta con tierra', 'Agua', 'Piedras pequeñas o cristales', 'Papel para intenciones'],
      materialsCa: ['Llavors (herbes o flors)', 'Test amb terra', 'Aigua', 'Pedres petites o cristalls', 'Paper per intencions'],
      stepsEn: [
        RitualStep(order: 1, title: 'Choose Your Seeds', description: 'Select seeds that symbolize your intention (basil for prosperity, lavender for peace, etc.)'),
        RitualStep(order: 2, title: 'Prepare Sacred Soil', description: 'Fill your pot with soil. As you do, think of it as fertile ground for your dreams.'),
        RitualStep(order: 3, title: 'Write Your Intention', description: 'On a small piece of paper, write one clear intention. Be specific.'),
        RitualStep(order: 4, title: 'Plant with Purpose', description: 'Bury the paper and plant seeds on top. Each seed represents your intention growing.'),
        RitualStep(order: 5, title: 'Bless with Water', description: 'Water the seeds, imagining moon energy flowing into them. Speak your intention aloud.'),
        RitualStep(order: 6, title: 'Nurture Daily', description: 'Care for your plant throughout the lunar cycle. As it grows, so does your manifestation.'),
      ],
      stepsEs: [
        RitualStep(order: 1, title: 'Elegir Semillas', description: 'Selecciona semillas que simbolicen tu intención (albahaca para prosperidad, lavanda para paz, etc.)'),
        RitualStep(order: 2, title: 'Preparar Tierra Sagrada', description: 'Llena tu maceta con tierra. Al hacerlo, piensa en ella como tierra fértil para tus sueños.'),
        RitualStep(order: 3, title: 'Escribir Intención', description: 'En un papel pequeño, escribe una intención clara. Sé específico.'),
        RitualStep(order: 4, title: 'Plantar con Propósito', description: 'Entierra el papel y planta semillas encima. Cada semilla representa tu intención creciendo.'),
        RitualStep(order: 5, title: 'Bendecir con Agua', description: 'Riega las semillas, imaginando energía lunar fluyendo. Pronuncia tu intención en voz alta.'),
        RitualStep(order: 6, title: 'Nutrir Diariamente', description: 'Cuida tu planta durante el ciclo lunar. A medida que crece, también lo hace tu manifestación.'),
      ],
      stepsCa: [
        RitualStep(order: 1, title: 'Triar Llavors', description: 'Selecciona llavors que simbolitzin la teva intenció (alfàbrega per prosperitat, lavanda per pau, etc.)'),
        RitualStep(order: 2, title: 'Preparar Terra Sagrada', description: 'Omple el test amb terra. En fer-ho, pensa-hi com a terra fèrtil pels teus somnis.'),
        RitualStep(order: 3, title: 'Escriure Intenció', description: 'En un paper petit, escriu una intenció clara. Sigues específic.'),
        RitualStep(order: 4, title: 'Plantar amb Propòsit', description: 'Enterra el paper i planta llavors a sobre. Cada llavor representa la teva intenció creixent.'),
        RitualStep(order: 5, title: 'Beneir amb Aigua', description: 'Rega les llavors, imaginant energia lunar fluint. Pronuncia la teva intenció en veu alta.'),
        RitualStep(order: 6, title: 'Nodrir Diàriament', description: 'Cuida la teva planta durant el cicle lunar. A mesura que creix, també ho fa la teva manifestació.'),
      ],
      intentionsEn: ['Growth', 'Patience', 'Nurturing dreams', 'Grounding intentions'],
      intentionsEs: ['Crecimiento', 'Paciencia', 'Nutrir sueños', 'Arraigando intenciones'],
      intentionsCa: ['Creixement', 'Paciència', 'Nodrir somnis', 'Arrelant intencions'],
      iconEmoji: '🌱',
    ),

    LunarRitual(
      id: 'new_moon_tarot_spread',
      nameEn: 'New Moon Tarot Reading',
      nameEs: 'Lectura de Tarot Luna Nueva',
      nameCa: 'Lectura de Tarot Lluna Nova',
      descriptionEn: 'Use tarot to gain insight into the opportunities and challenges of this new cycle',
      descriptionEs: 'Usa el tarot para obtener perspectiva sobre las oportunidades y desafíos de este nuevo ciclo',
      descriptionCa: 'Utilitza el tarot per obtenir perspectiva sobre les oportunitats i desafiaments d\'aquest nou cicle',
      phases: ['new_moon'],
      category: 'manifestation',
      durationMinutes: 25,
      difficulty: 'intermediate',
      materialsEn: ['Tarot deck', 'Candle', 'Journal', 'Quiet space'],
      materialsEs: ['Baraja de tarot', 'Vela', 'Diario', 'Espacio tranquilo'],
      materialsCa: ['Baralla de tarot', 'Espelma', 'Diari', 'Espai tranquil'],
      stepsEn: [
        RitualStep(order: 1, title: 'Cleanse Your Deck', description: 'Knock on the deck three times or pass it through incense smoke.'),
        RitualStep(order: 2, title: 'Set Your Question', description: 'Focus on: "What do I need to know about this new lunar cycle?"'),
        RitualStep(order: 3, title: 'Draw Cards', description: 'Draw 3 cards: 1) What to release, 2) What to embrace, 3) Hidden opportunity'),
        RitualStep(order: 4, title: 'Interpret Intuitively', description: 'Don\'t just use book meanings. What does each card say to YOU?'),
        RitualStep(order: 5, title: 'Journal Insights', description: 'Write down your interpretations and how they relate to your intentions.'),
        RitualStep(order: 6, title: 'Create Action Plan', description: 'Based on the reading, decide on 2-3 concrete actions for the month ahead.'),
      ],
      stepsEs: [
        RitualStep(order: 1, title: 'Limpiar Tu Baraja', description: 'Golpea la baraja tres veces o pásala por humo de incienso.'),
        RitualStep(order: 2, title: 'Establecer Tu Pregunta', description: 'Enfócate en: "¿Qué necesito saber sobre este nuevo ciclo lunar?"'),
        RitualStep(order: 3, title: 'Sacar Cartas', description: 'Saca 3 cartas: 1) Qué liberar, 2) Qué abrazar, 3) Oportunidad oculta'),
        RitualStep(order: 4, title: 'Interpretar Intuitivamente', description: 'No uses solo significados de libros. ¿Qué te dice cada carta?'),
        RitualStep(order: 5, title: 'Escribir Perspectivas', description: 'Anota tus interpretaciones y cómo se relacionan con tus intenciones.'),
        RitualStep(order: 6, title: 'Crear Plan de Acción', description: 'Basado en la lectura, decide 2-3 acciones concretas para el mes.'),
      ],
      stepsCa: [
        RitualStep(order: 1, title: 'Netejar La Teva Baralla', description: 'Cop la baralla tres vegades o passa-la per fum d\'encens.'),
        RitualStep(order: 2, title: 'Establir La Teva Pregunta', description: 'Enfoca\'t en: "Què necessito saber sobre aquest nou cicle lunar?"'),
        RitualStep(order: 3, title: 'Treure Cartes', description: 'Treu 3 cartes: 1) Què alliberar, 2) Què abraçar, 3) Oportunitat oculta'),
        RitualStep(order: 4, title: 'Interpretar Intuïtivament', description: 'No facis servir només significats de llibres. Què et diu cada carta?'),
        RitualStep(order: 5, title: 'Escriure Perspectives', description: 'Anota les teves interpretacions i com es relacionen amb les teves intencions.'),
        RitualStep(order: 6, title: 'Crear Pla d\'Acció', description: 'Basat en la lectura, decideix 2-3 accions concretes pel mes.'),
      ],
      intentionsEn: ['Divine guidance', 'Clarity', 'Wisdom', 'Direction'],
      intentionsEs: ['Guía divina', 'Claridad', 'Sabiduría', 'Dirección'],
      intentionsCa: ['Guia divina', 'Claredat', 'Saviesa', 'Direcció'],
      iconEmoji: '🔮',
    ),

    // WAXING MOON RITUALS (3)
    LunarRitual(
      id: 'waxing_action_plan',
      nameEn: 'Waxing Moon Action Ritual',
      nameEs: 'Ritual de Acción Luna Creciente',
      nameCa: 'Ritual d\'Acció Lluna Creixent',
      descriptionEn: 'Channel growing moon energy into concrete steps toward your goals',
      descriptionEs: 'Canaliza la energía creciente de la luna en pasos concretos hacia tus metas',
      descriptionCa: 'Canalitza l\'energia creixent de la lluna en passos concrets cap als teus objectius',
      phases: ['waxing_crescent', 'first_quarter', 'waxing_gibbous'],
      category: 'manifestation',
      durationMinutes: 35,
      difficulty: 'beginner',
      materialsEn: ['Your new moon intentions', 'Journal', 'Yellow or orange candle', 'Calendar'],
      materialsEs: ['Tus intenciones de luna nueva', 'Diario', 'Vela amarilla o naranja', 'Calendario'],
      materialsCa: ['Les teves intencions de lluna nova', 'Diari', 'Espelma groga o taronja', 'Calendari'],
      stepsEn: [
        RitualStep(order: 1, title: 'Review Intentions', description: 'Read your new moon intentions. Which ones are calling for action now?'),
        RitualStep(order: 2, title: 'Light Action Candle', description: 'Light a yellow or orange candle to symbolize growing energy and momentum.'),
        RitualStep(order: 3, title: 'Break Down Goals', description: 'For each intention, write 3 specific, actionable steps you can take this week.'),
        RitualStep(order: 4, title: 'Schedule Actions', description: 'Put these actions in your calendar. Commit to specific dates and times.'),
        RitualStep(order: 5, title: 'Visualize Success', description: 'See yourself completing each action. Feel the satisfaction and momentum.'),
        RitualStep(order: 6, title: 'Take First Step', description: 'Do ONE action from your list right now, no matter how small. Build momentum!'),
      ],
      stepsEs: [
        RitualStep(order: 1, title: 'Revisar Intenciones', description: 'Lee tus intenciones de luna nueva. ¿Cuáles piden acción ahora?'),
        RitualStep(order: 2, title: 'Encender Vela de Acción', description: 'Enciende una vela amarilla o naranja para simbolizar energía y momentum creciente.'),
        RitualStep(order: 3, title: 'Desglosar Metas', description: 'Para cada intención, escribe 3 pasos específicos y accionables para esta semana.'),
        RitualStep(order: 4, title: 'Programar Acciones', description: 'Pon estas acciones en tu calendario. Comprométete con fechas y horas específicas.'),
        RitualStep(order: 5, title: 'Visualizar Éxito', description: 'Véte completando cada acción. Siente la satisfacción y el momentum.'),
        RitualStep(order: 6, title: 'Dar Primer Paso', description: 'Haz UNA acción de tu lista ahora mismo, sin importar cuán pequeña. ¡Construye momentum!'),
      ],
      stepsCa: [
        RitualStep(order: 1, title: 'Revisar Intencions', description: 'Llegeix les teves intencions de lluna nova. Quines demanen acció ara?'),
        RitualStep(order: 2, title: 'Encendre Espelma d\'Acció', description: 'Encén una espelma groga o taronja per simbolitzar energia i momentum creixent.'),
        RitualStep(order: 3, title: 'Desglossar Objectius', description: 'Per cada intenció, escriu 3 passos específics i accionables per aquesta setmana.'),
        RitualStep(order: 4, title: 'Programar Accions', description: 'Posa aquestes accions al teu calendari. Compromet-te amb dates i hores específiques.'),
        RitualStep(order: 5, title: 'Visualitzar Èxit', description: 'Veu-te completant cada acció. Sent la satisfacció i el momentum.'),
        RitualStep(order: 6, title: 'Fer Primer Pas', description: 'Fes UNA acció de la teva llista ara mateix, per petita que sigui. Construeix momentum!'),
      ],
      intentionsEn: ['Action', 'Momentum', 'Progress', 'Building energy'],
      intentionsEs: ['Acción', 'Momentum', 'Progreso', 'Construyendo energía'],
      intentionsCa: ['Acció', 'Momentum', 'Progrés', 'Construint energia'],
      iconEmoji: '🌓',
    ),

    // FULL MOON RITUALS (4)
    LunarRitual(
      id: 'full_moon_gratitude',
      nameEn: 'Full Moon Gratitude Ceremony',
      nameEs: 'Ceremonia de Gratitud de Luna Llena',
      nameCa: 'Cerimònia de Gratitud de Lluna Plena',
      descriptionEn: 'Honor the fullness of the moon and your life with a powerful gratitude practice',
      descriptionEs: 'Honra la plenitud de la luna y tu vida con una práctica poderosa de gratitud',
      descriptionCa: 'Honra la plenitud de la lluna i la teva vida amb una pràctica poderosa de gratitud',
      phases: ['full_moon'],
      category: 'abundance',
      durationMinutes: 35,
      difficulty: 'beginner',
      materialsEn: ['Journal', 'Pen', 'White candle', 'Flowers or fruit offering'],
      materialsEs: ['Diario', 'Bolígrafo', 'Vela blanca', 'Ofrenda de flores o fruta'],
      materialsCa: ['Diari', 'Bolígraf', 'Espelma blanca', 'Ofrenda de flors o fruita'],
      stepsEn: [
        RitualStep(order: 1, title: 'Prepare Your Altar', description: 'Create a beautiful space with your candle and offerings. If possible, place it where moonlight can reach.'),
        RitualStep(order: 2, title: 'Moon Gazing', description: 'Spend 5 minutes gazing at the full moon (or visualizing it). Feel its radiant energy filling you.'),
        RitualStep(order: 3, title: 'Gratitude List', description: 'Write down 10-20 things you\'re grateful for. Include small joys and big blessings alike.'),
        RitualStep(order: 4, title: 'Read Aloud', description: 'Read your gratitude list aloud with feeling. Let each item resonate in your heart.'),
        RitualStep(order: 5, title: 'Offer Thanks', description: 'Place your hands over your heart and speak your thanks to the universe, the moon, and yourself.'),
        RitualStep(order: 6, title: 'Close with Offering', description: 'Leave your flowers or fruit outside as an offering of gratitude to nature.'),
      ],
      stepsEs: [
        RitualStep(order: 1, title: 'Preparar tu Altar', description: 'Crea un espacio hermoso con tu vela y ofrendas. Si es posible, colócalo donde llegue la luz de la luna.'),
        RitualStep(order: 2, title: 'Contemplar la Luna', description: 'Pasa 5 minutos mirando la luna llena (o visualizándola). Siente su energía radiante llenándote.'),
        RitualStep(order: 3, title: 'Lista de Gratitud', description: 'Escribe 10-20 cosas por las que estás agradecido. Incluye pequeñas alegrías y grandes bendiciones.'),
        RitualStep(order: 4, title: 'Leer en Voz Alta', description: 'Lee tu lista de gratitud en voz alta con sentimiento. Deja que cada elemento resuene en tu corazón.'),
        RitualStep(order: 5, title: 'Ofrecer Gracias', description: 'Coloca tus manos sobre tu corazón y habla tu agradecimiento al universo, la luna y a ti mismo.'),
        RitualStep(order: 6, title: 'Cerrar con Ofrenda', description: 'Deja tus flores o fruta afuera como ofrenda de gratitud a la naturaleza.'),
      ],
      stepsCa: [
        RitualStep(order: 1, title: 'Preparar el teu Altar', description: 'Crea un espai bonic amb l\'espelma i les ofrenes. Si és possible, col·loca-ho on arribi la llum de la lluna.'),
        RitualStep(order: 2, title: 'Contemplar la Lluna', description: 'Passa 5 minuts mirant la lluna plena (o visualitzant-la). Sent la seva energia radiant omplint-te.'),
        RitualStep(order: 3, title: 'Llista de Gratitud', description: 'Escriu 10-20 coses per les quals estàs agraït. Inclou petites alegries i grans benediccions.'),
        RitualStep(order: 4, title: 'Llegir en Veu Alta', description: 'Llegeix la teva llista de gratitud en veu alta amb sentiment. Deixa que cada element ressoni al teu cor.'),
        RitualStep(order: 5, title: 'Oferir Gràcies', description: 'Col·loca les mans sobre el cor i parla el teu agraïment a l\'univers, la lluna i a tu mateix.'),
        RitualStep(order: 6, title: 'Tancar amb Ofrena', description: 'Deixa les flors o fruita a fora com una ofrena de gratitud a la natura.'),
      ],
      intentionsEn: ['Gratitude', 'Abundance', 'Appreciation', 'Fullness'],
      intentionsEs: ['Gratitud', 'Abundancia', 'Apreciación', 'Plenitud'],
      intentionsCa: ['Gratitud', 'Abundància', 'Apreciació', 'Plenitud'],
      iconEmoji: '🌕',
    ),

    LunarRitual(
      id: 'full_moon_release',
      nameEn: 'Full Moon Release Ceremony',
      nameEs: 'Ceremonia de Liberación de Luna Llena',
      nameCa: 'Cerimònia d\'Alliberament de Lluna Plena',
      descriptionEn: 'Release what no longer serves you under the powerful light of the full moon',
      descriptionEs: 'Libera lo que ya no te sirve bajo la poderosa luz de la luna llena',
      descriptionCa: 'Allibera el que ja no et serveix sota la poderosa llum de la lluna plena',
      phases: ['full_moon'],
      category: 'release',
      durationMinutes: 40,
      difficulty: 'beginner',
      materialsEn: ['Paper', 'Pen', 'Fireproof bowl', 'Matches', 'Water'],
      materialsEs: ['Papel', 'Bolígrafo', 'Recipiente resistente al fuego', 'Fósforos', 'Agua'],
      materialsCa: ['Paper', 'Bolígraf', 'Recipient resistent al foc', 'Llumins', 'Aigua'],
      stepsEn: [
        RitualStep(order: 1, title: 'Connect with Moon', description: 'Go outside or look at the full moon through a window. Breathe deeply and feel its illuminating energy.'),
        RitualStep(order: 2, title: 'Identify What to Release', description: 'Reflect: What patterns, beliefs, relationships, or habits are holding you back? Be honest.'),
        RitualStep(order: 3, title: 'Write It Down', description: 'On paper, write down everything you want to release. Use "I release..." statements.'),
        RitualStep(order: 4, title: 'Speak Your Release', description: 'Read each item aloud. Say firmly: "I release you with love. You no longer serve my highest good."'),
        RitualStep(order: 5, title: 'Burn the Paper', description: 'Safely burn the paper in your fireproof bowl. Watch the smoke carry your releases away.'),
        RitualStep(order: 6, title: 'Cleanse and Close', description: 'Pour water over the ashes. Wash your hands. Feel the weight lifted from your shoulders.'),
      ],
      stepsEs: [
        RitualStep(order: 1, title: 'Conectar con la Luna', description: 'Sal afuera o mira la luna llena por la ventana. Respira profundamente y siente su energía iluminadora.'),
        RitualStep(order: 2, title: 'Identificar qué Liberar', description: 'Reflexiona: ¿Qué patrones, creencias, relaciones o hábitos te están frenando? Sé honesto.'),
        RitualStep(order: 3, title: 'Escríbelo', description: 'En papel, escribe todo lo que quieres liberar. Usa declaraciones "Yo libero...".'),
        RitualStep(order: 4, title: 'Habla tu Liberación', description: 'Lee cada elemento en voz alta. Di firmemente: "Te libero con amor. Ya no sirves a mi mayor bien."'),
        RitualStep(order: 5, title: 'Quemar el Papel', description: 'Quema el papel de forma segura en tu recipiente. Observa cómo el humo lleva tus liberaciones.'),
        RitualStep(order: 6, title: 'Limpiar y Cerrar', description: 'Vierte agua sobre las cenizas. Lávate las manos. Siente el peso levantado de tus hombros.'),
      ],
      stepsCa: [
        RitualStep(order: 1, title: 'Connectar amb la Lluna', description: 'Surt a fora o mira la lluna plena per la finestra. Respira profundament i sent la seva energia il·luminadora.'),
        RitualStep(order: 2, title: 'Identificar què Alliberar', description: 'Reflexiona: Quins patrons, creences, relacions o hàbits t\'estan frenant? Sigues honest.'),
        RitualStep(order: 3, title: 'Escriu-ho', description: 'En paper, escriu tot el que vols alliberar. Utilitza declaracions "Jo allibero...".'),
        RitualStep(order: 4, title: 'Parla el teu Alliberament', description: 'Llegeix cada element en veu alta. Digues fermament: "T\'allibero amb amor. Ja no serveixes al meu major bé."'),
        RitualStep(order: 5, title: 'Cremar el Paper', description: 'Crema el paper de manera segura al teu recipient. Observa com el fum porta els teus alliberaments.'),
        RitualStep(order: 6, title: 'Netejar i Tancar', description: 'Aboca aigua sobre les cendres. Renta\'t les mans. Sent el pes aixecat de les teves espatlles.'),
      ],
      intentionsEn: ['Letting go', 'Release', 'Freedom', 'Clearing'],
      intentionsEs: ['Soltar', 'Liberación', 'Libertad', 'Limpieza'],
      intentionsCa: ['Deixar anar', 'Alliberament', 'Llibertat', 'Neteja'],
      iconEmoji: '🌕',
    ),

    LunarRitual(
      id: 'full_moon_charging',
      nameEn: 'Full Moon Crystal Charging',
      nameEs: 'Carga de Cristales de Luna Llena',
      nameCa: 'Càrrega de Cristalls de Lluna Plena',
      descriptionEn: 'Cleanse and charge your crystals, tools, and intentions with full moon energy',
      descriptionEs: 'Limpia y carga tus cristales, herramientas e intenciones con energía de luna llena',
      descriptionCa: 'Neteja i carrega els teus cristalls, eines i intencions amb energia de lluna plena',
      phases: ['full_moon'],
      category: 'healing',
      durationMinutes: 20,
      difficulty: 'beginner',
      materialsEn: ['Crystals or spiritual tools', 'White cloth', 'Bowl of water (optional)', 'Moonlit windowsill or outdoor space'],
      materialsEs: ['Cristales o herramientas espirituales', 'Tela blanca', 'Cuenco de agua (opcional)', 'Alféizar con luz de luna o espacio exterior'],
      materialsCa: ['Cristalls o eines espirituals', 'Tela blanca', 'Bol d\'aigua (opcional)', 'Ampit amb llum de lluna o espai exterior'],
      stepsEn: [
        RitualStep(order: 1, title: 'Cleanse Your Items', description: 'Pass crystals through sage smoke or rinse in water. Set intention to clear old energy.'),
        RitualStep(order: 2, title: 'Arrange on Cloth', description: 'Place white cloth in moonlight. Arrange your crystals and tools on it with reverence.'),
        RitualStep(order: 3, title: 'State Your Intention', description: 'Hold hands over items. Say: "Under this full moon, I charge you with light, love, and power."'),
        RitualStep(order: 4, title: 'Leave Overnight', description: 'Leave items in moonlight overnight (or at least 3 hours). Let them absorb lunar energy.'),
        RitualStep(order: 5, title: 'Retrieve and Thank', description: 'In the morning, collect your charged items. Thank the moon for its blessing.'),
      ],
      stepsEs: [
        RitualStep(order: 1, title: 'Limpiar tus Objetos', description: 'Pasa los cristales por humo de salvia o enjuaga con agua. Establece la intención de limpiar la energía vieja.'),
        RitualStep(order: 2, title: 'Organizar en la Tela', description: 'Coloca la tela blanca a la luz de la luna. Organiza tus cristales y herramientas con reverencia.'),
        RitualStep(order: 3, title: 'Declarar tu Intención', description: 'Sostén las manos sobre los objetos. Di: "Bajo esta luna llena, te cargo con luz, amor y poder."'),
        RitualStep(order: 4, title: 'Dejar Durante la Noche', description: 'Deja los objetos a la luz de la luna durante la noche (o al menos 3 horas). Deja que absorban energía lunar.'),
        RitualStep(order: 5, title: 'Recoger y Agradecer', description: 'Por la mañana, recoge tus objetos cargados. Agradece a la luna por su bendición.'),
      ],
      stepsCa: [
        RitualStep(order: 1, title: 'Netejar els teus Objectes', description: 'Passa els cristalls pel fum de sàlvia o renta amb aigua. Estableix la intenció de netejar l\'energia vella.'),
        RitualStep(order: 2, title: 'Organitzar a la Tela', description: 'Col·loca la tela blanca a la llum de la lluna. Organitza els teus cristalls i eines amb reverència.'),
        RitualStep(order: 3, title: 'Declarar la teva Intenció', description: 'Sostingues les mans sobre els objectes. Digues: "Sota aquesta lluna plena, et carrego amb llum, amor i poder."'),
        RitualStep(order: 4, title: 'Deixar Durant la Nit', description: 'Deixa els objectes a la llum de la lluna durant la nit (o almenys 3 hores). Deixa que absorbeixin energia lunar.'),
        RitualStep(order: 5, title: 'Recollir i Agrair', description: 'Al matí, recull els teus objectes carregats. Agraeix a la lluna per la seva benedicció.'),
      ],
      intentionsEn: ['Charging', 'Amplification', 'Cleansing', 'Power'],
      intentionsEs: ['Carga', 'Amplificación', 'Limpieza', 'Poder'],
      intentionsCa: ['Càrrega', 'Amplificació', 'Neteja', 'Poder'],
      iconEmoji: '💎',
    ),

    LunarRitual(
      id: 'full_moon_celebration',
      nameEn: 'Full Moon Dance & Celebration',
      nameEs: 'Danza y Celebración de Luna Llena',
      nameCa: 'Dansa i Celebració de Lluna Plena',
      descriptionEn: 'Celebrate your achievements and the moon\'s fullness with joyful movement and music',
      descriptionEs: 'Celebra tus logros y la plenitud de la luna con movimiento alegre y música',
      descriptionCa: 'Celebra els teus assoliments i la plenitud de la lluna amb moviment alegre i música',
      phases: ['full_moon'],
      category: 'abundance',
      durationMinutes: 30,
      difficulty: 'beginner',
      materialsEn: ['Music player', 'Comfortable space to move', 'Optional: drum or rattle', 'Optional: festive attire'],
      materialsEs: ['Reproductor de música', 'Espacio cómodo para moverse', 'Opcional: tambor o maraca', 'Opcional: ropa festiva'],
      materialsCa: ['Reproductor de música', 'Espai còmode per moure\'s', 'Opcional: tambor o maraca', 'Opcional: roba festiva'],
      stepsEn: [
        RitualStep(order: 1, title: 'Prepare Your Space', description: 'Clear a space to move freely. If outdoors, find a moonlit spot. Put on music that makes you feel alive.'),
        RitualStep(order: 2, title: 'Acknowledge Achievements', description: 'Stand still. Speak aloud 3-5 things you\'ve accomplished since the last full moon.'),
        RitualStep(order: 3, title: 'Begin to Move', description: 'Start swaying gently. Let the music move through you. No choreography—just authentic expression.'),
        RitualStep(order: 4, title: 'Build Energy', description: 'Increase your movement. Spin, jump, stomp, reach for the sky. Channel the moon\'s powerful energy.'),
        RitualStep(order: 5, title: 'Peak Expression', description: 'Dance with complete abandon for 5-10 minutes. Celebrate your life, your power, your magic.'),
        RitualStep(order: 6, title: 'Cool Down & Ground', description: 'Slow your movements. Come to stillness. Place hands on heart. Thank yourself and the moon.'),
      ],
      stepsEs: [
        RitualStep(order: 1, title: 'Preparar tu Espacio', description: 'Despeja un espacio para moverte libremente. Si está afuera, encuentra un lugar iluminado por la luna. Pon música que te haga sentir vivo.'),
        RitualStep(order: 2, title: 'Reconocer Logros', description: 'Quédate quieto. Habla en voz alta 3-5 cosas que has logrado desde la última luna llena.'),
        RitualStep(order: 3, title: 'Comenzar a Moverte', description: 'Comienza a balancearte suavemente. Deja que la música se mueva a través de ti. Sin coreografía—solo expresión auténtica.'),
        RitualStep(order: 4, title: 'Construir Energía', description: 'Aumenta tu movimiento. Gira, salta, pisa fuerte, alcanza el cielo. Canaliza la poderosa energía de la luna.'),
        RitualStep(order: 5, title: 'Expresión Máxima', description: 'Baila con completo abandono por 5-10 minutos. Celebra tu vida, tu poder, tu magia.'),
        RitualStep(order: 6, title: 'Enfriar y Arraigarse', description: 'Disminuye tus movimientos. Llega a la quietud. Coloca las manos en el corazón. Agradécete a ti mismo y a la luna.'),
      ],
      stepsCa: [
        RitualStep(order: 1, title: 'Preparar el teu Espai', description: 'Esbrina un espai per moure\'t lliurement. Si està a fora, troba un lloc il·luminat per la lluna. Posa música que et faci sentir viu.'),
        RitualStep(order: 2, title: 'Reconèixer Assoliments', description: 'Queda\'t quiet. Parla en veu alta 3-5 coses que has aconseguit des de l\'última lluna plena.'),
        RitualStep(order: 3, title: 'Començar a Moure\'t', description: 'Comença a balancejar-te suaument. Deixa que la música es mogui a través teu. Sense coreografia—només expressió autèntica.'),
        RitualStep(order: 4, title: 'Construir Energia', description: 'Augmenta el teu moviment. Gira, salta, trepitja fort, arriba al cel. Canalitza la poderosa energia de la lluna.'),
        RitualStep(order: 5, title: 'Expressió Màxima', description: 'Balla amb complet abandó durant 5-10 minuts. Celebra la teva vida, el teu poder, la teva màgia.'),
        RitualStep(order: 6, title: 'Refredar i Arrelar', description: 'Disminueix els teus moviments. Arriba a la quietud. Col·loca les mans al cor. Agraeix-te a tu mateix i a la lluna.'),
      ],
      intentionsEn: ['Celebration', 'Joy', 'Achievement', 'Expression'],
      intentionsEs: ['Celebración', 'Alegría', 'Logro', 'Expresión'],
      intentionsCa: ['Celebració', 'Alegria', 'Assoliment', 'Expressió'],
      iconEmoji: '💃',
    ),

    // WANING MOON RITUALS (4)
    LunarRitual(
      id: 'waning_letting_go',
      nameEn: 'Waning Moon Letting Go',
      nameEs: 'Luna Menguante: Soltar',
      nameCa: 'Lluna Minvant: Deixar Anar',
      descriptionEn: 'Release burdens and make space for renewal as the moon decreases',
      descriptionEs: 'Libera cargas y haz espacio para la renovación mientras la luna decrece',
      descriptionCa: 'Allibera càrregues i fes espai per a la renovació mentre la lluna decreix',
      phases: ['waning_gibbous', 'last_quarter', 'waning_crescent'],
      category: 'release',
      durationMinutes: 35,
      difficulty: 'beginner',
      materialsEn: ['Journal', 'Pen', 'Black or dark blue candle', 'Salt water bowl'],
      materialsEs: ['Diario', 'Bolígrafo', 'Vela negra o azul oscuro', 'Cuenco de agua con sal'],
      materialsCa: ['Diari', 'Bolígraf', 'Espelma negra o blava fosca', 'Bol d\'aigua amb sal'],
      stepsEn: [
        RitualStep(order: 1, title: 'Create Release Space', description: 'Light your candle. Set up your journal and salt water. Breathe deeply to center yourself.'),
        RitualStep(order: 2, title: 'Inventory Burdens', description: 'Write down what feels heavy: worries, grudges, self-criticism, expired relationships, old stories.'),
        RitualStep(order: 3, title: 'Choose What to Release', description: 'Circle 3-5 items you\'re ready to release. Don\'t force it—only what feels ready.'),
        RitualStep(order: 4, title: 'Release Ritual', description: 'For each item, say: "I release you. You are not mine to carry." Dip fingers in salt water and flick toward candle.'),
        RitualStep(order: 5, title: 'Visualize Space', description: 'Close your eyes. Visualize the weight leaving your body. Feel the space it creates.'),
        RitualStep(order: 6, title: 'Seal the Work', description: 'Blow out the candle. Pour salt water outside. Feel lighter and freer.'),
      ],
      stepsEs: [
        RitualStep(order: 1, title: 'Crear Espacio de Liberación', description: 'Enciende tu vela. Prepara tu diario y agua con sal. Respira profundamente para centrarte.'),
        RitualStep(order: 2, title: 'Inventario de Cargas', description: 'Escribe lo que se siente pesado: preocupaciones, rencores, autocrítica, relaciones vencidas, viejas historias.'),
        RitualStep(order: 3, title: 'Elegir qué Liberar', description: 'Encierra en un círculo 3-5 elementos que estés listo para liberar. No fuerces—solo lo que se sienta listo.'),
        RitualStep(order: 4, title: 'Ritual de Liberación', description: 'Para cada elemento, di: "Te libero. No eres mío para cargar." Sumerge los dedos en agua con sal y salpica hacia la vela.'),
        RitualStep(order: 5, title: 'Visualizar Espacio', description: 'Cierra los ojos. Visualiza el peso dejando tu cuerpo. Siente el espacio que crea.'),
        RitualStep(order: 6, title: 'Sellar el Trabajo', description: 'Apaga la vela. Vierte el agua con sal afuera. Siéntete más ligero y libre.'),
      ],
      stepsCa: [
        RitualStep(order: 1, title: 'Crear Espai d\'Alliberament', description: 'Encén l\'espelma. Prepara el teu diari i aigua amb sal. Respira profundament per centrar-te.'),
        RitualStep(order: 2, title: 'Inventari de Càrregues', description: 'Escriu el que se sent pesat: preocupacions, rancúnies, autocrítica, relacions vençudes, velles històries.'),
        RitualStep(order: 3, title: 'Triar què Alliberar', description: 'Marca amb un cercle 3-5 elements que estiguis preparat per alliberar. No forcis—només el que se senti preparat.'),
        RitualStep(order: 4, title: 'Ritual d\'Alliberament', description: 'Per cada element, digues: "T\'allibero. No ets meu per carregar." Submergeix els dits en aigua amb sal i salpica cap a l\'espelma.'),
        RitualStep(order: 5, title: 'Visualitzar Espai', description: 'Tanca els ulls. Visualitza el pes deixant el teu cos. Sent l\'espai que crea.'),
        RitualStep(order: 6, title: 'Segell del Treball', description: 'Apaga l\'espelma. Aboca l\'aigua amb sal a fora. Sent-te més lleuger i lliure.'),
      ],
      intentionsEn: ['Letting go', 'Lightening', 'Space-making', 'Surrender'],
      intentionsEs: ['Soltar', 'Aligerar', 'Hacer espacio', 'Entrega'],
      intentionsCa: ['Deixar anar', 'Alleugerir', 'Fer espai', 'Entrega'],
      iconEmoji: '🌖',
    ),

    LunarRitual(
      id: 'waning_cleansing_bath',
      nameEn: 'Waning Moon Cleansing Bath',
      nameEs: 'Baño de Limpieza de Luna Menguante',
      nameCa: 'Bany de Neteja de Lluna Minvant',
      descriptionEn: 'Wash away negativity and old energy in a purifying moon bath ritual',
      descriptionEs: 'Lava la negatividad y la energía vieja en un ritual de baño purificador lunar',
      descriptionCa: 'Renta la negativitat i l\'energia vella en un ritual de bany purificador lunar',
      phases: ['waning_gibbous', 'last_quarter', 'waning_crescent'],
      category: 'healing',
      durationMinutes: 45,
      difficulty: 'beginner',
      materialsEn: ['Epsom salt or sea salt', 'Dried herbs (lavender, rosemary, sage)', 'Essential oils (optional)', 'Black or white candle'],
      materialsEs: ['Sal de Epsom o sal marina', 'Hierbas secas (lavanda, romero, salvia)', 'Aceites esenciales (opcional)', 'Vela negra o blanca'],
      materialsCa: ['Sal d\'Epsom o sal marina', 'Herbes seques (espígol, romaní, sàlvia)', 'Olis essencials (opcional)', 'Espelma negra o blanca'],
      stepsEn: [
        RitualStep(order: 1, title: 'Prepare Bath', description: 'Fill tub with warm water. Add salt, herbs, and oils. Stir counterclockwise (banishing direction).'),
        RitualStep(order: 2, title: 'Set Intention', description: 'Light candle. Say: "This water cleanses all that no longer serves. I emerge renewed."'),
        RitualStep(order: 3, title: 'Enter with Awareness', description: 'Step into bath slowly. Feel the water receiving everything you wish to release.'),
        RitualStep(order: 4, title: 'Soak and Release', description: 'Soak for 20-30 minutes. Visualize darkness leaving your body, dissolving into the water.'),
        RitualStep(order: 5, title: 'Wash Away', description: 'Use a cup to pour water over your head and shoulders. Each pour washes away old energy.'),
        RitualStep(order: 6, title: 'Drain and Renew', description: 'Stand and drain water. Visualize all negativity flowing away. Pat dry and dress in clean clothes.'),
      ],
      stepsEs: [
        RitualStep(order: 1, title: 'Preparar Baño', description: 'Llena la bañera con agua tibia. Añade sal, hierbas y aceites. Revuelve en sentido antihorario (dirección de destierro).'),
        RitualStep(order: 2, title: 'Establecer Intención', description: 'Enciende la vela. Di: "Esta agua limpia todo lo que ya no sirve. Emerjo renovado."'),
        RitualStep(order: 3, title: 'Entrar con Conciencia', description: 'Entra al baño lentamente. Siente el agua recibiendo todo lo que deseas liberar.'),
        RitualStep(order: 4, title: 'Remojar y Liberar', description: 'Remoja durante 20-30 minutos. Visualiza la oscuridad dejando tu cuerpo, disolviéndose en el agua.'),
        RitualStep(order: 5, title: 'Lavar', description: 'Usa una taza para verter agua sobre tu cabeza y hombros. Cada vertido lava la energía vieja.'),
        RitualStep(order: 6, title: 'Drenar y Renovar', description: 'Ponte de pie y drena el agua. Visualiza toda la negatividad fluyendo. Seca y viste con ropa limpia.'),
      ],
      stepsCa: [
        RitualStep(order: 1, title: 'Preparar Bany', description: 'Omple la banyera amb aigua tèbia. Afegeix sal, herbes i olis. Remena en sentit antihorari (direcció de desterrament).'),
        RitualStep(order: 2, title: 'Establir Intenció', description: 'Encén l\'espelma. Digues: "Aquesta aigua neteja tot el que ja no serveix. Emergeixo renovat."'),
        RitualStep(order: 3, title: 'Entrar amb Consciència', description: 'Entra al bany lentament. Sent l\'aigua rebent tot el que desitges alliberar.'),
        RitualStep(order: 4, title: 'Remullar i Alliberar', description: 'Remulla durant 20-30 minuts. Visualitza la foscor deixant el teu cos, dissolent-se a l\'aigua.'),
        RitualStep(order: 5, title: 'Rentar', description: 'Utilitza una tassa per abocar aigua sobre el teu cap i espatlles. Cada abocada renta l\'energia vella.'),
        RitualStep(order: 6, title: 'Drenar i Renovar', description: 'Aixeca\'t i drena l\'aigua. Visualitza tota la negativitat fluint. Asseca i vesteix amb roba neta.'),
      ],
      intentionsEn: ['Cleansing', 'Purification', 'Renewal', 'Washing away'],
      intentionsEs: ['Limpieza', 'Purificación', 'Renovación', 'Lavar'],
      intentionsCa: ['Neteja', 'Purificació', 'Renovació', 'Rentar'],
      iconEmoji: '🛁',
    ),

    LunarRitual(
      id: 'waning_cord_cutting',
      nameEn: 'Waning Moon Cord Cutting',
      nameEs: 'Corte de Cordones de Luna Menguante',
      nameCa: 'Tall de Cordons de Lluna Minvant',
      descriptionEn: 'Cut energetic cords to relationships, situations, or patterns that drain you',
      descriptionEs: 'Corta cordones energéticos con relaciones, situaciones o patrones que te drenan',
      descriptionCa: 'Talla cordons energètics amb relacions, situacions o patrons que et drenen',
      phases: ['waning_gibbous', 'last_quarter'],
      category: 'release',
      durationMinutes: 30,
      difficulty: 'intermediate',
      materialsEn: ['Two candles', 'String or ribbon', 'Scissors', 'Fireproof dish'],
      materialsEs: ['Dos velas', 'Hilo o cinta', 'Tijeras', 'Plato resistente al fuego'],
      materialsCa: ['Dues espelmes', 'Fil o cinta', 'Tisores', 'Plat resistent al foc'],
      stepsEn: [
        RitualStep(order: 1, title: 'Identify the Cord', description: 'Reflect on what or who drains your energy. What attachment needs to be released?'),
        RitualStep(order: 2, title: 'Set Up Candles', description: 'Place two candles 12 inches apart. One represents you, one represents what you\'re releasing.'),
        RitualStep(order: 3, title: 'Tie the Cord', description: 'Tie string between the candles. Light both. This represents the energetic connection.'),
        RitualStep(order: 4, title: 'Speak Your Truth', description: 'Say: "I honor what was, but this connection no longer serves my highest good. I release it with love."'),
        RitualStep(order: 5, title: 'Cut the Cord', description: 'Use scissors to cut the string. Say firmly: "It is done. I am free. You are free."'),
        RitualStep(order: 6, title: 'Release the Energy', description: 'Burn the cut string safely. Blow out the candle that isn\'t you. Keep your candle burning a bit longer.'),
      ],
      stepsEs: [
        RitualStep(order: 1, title: 'Identificar el Cordón', description: 'Reflexiona sobre qué o quién drena tu energía. ¿Qué apego necesita ser liberado?'),
        RitualStep(order: 2, title: 'Configurar Velas', description: 'Coloca dos velas a 30 cm de distancia. Una te representa, otra representa lo que estás liberando.'),
        RitualStep(order: 3, title: 'Atar el Cordón', description: 'Ata el hilo entre las velas. Enciende ambas. Esto representa la conexión energética.'),
        RitualStep(order: 4, title: 'Habla tu Verdad', description: 'Di: "Honro lo que fue, pero esta conexión ya no sirve a mi mayor bien. Lo libero con amor."'),
        RitualStep(order: 5, title: 'Cortar el Cordón', description: 'Usa tijeras para cortar el hilo. Di firmemente: "Está hecho. Soy libre. Eres libre."'),
        RitualStep(order: 6, title: 'Liberar la Energía', description: 'Quema el hilo cortado de forma segura. Apaga la vela que no eres tú. Mantén tu vela encendida un poco más.'),
      ],
      stepsCa: [
        RitualStep(order: 1, title: 'Identificar el Cordó', description: 'Reflexiona sobre què o qui drena la teva energia. Quin aferrament necessita ser alliberat?'),
        RitualStep(order: 2, title: 'Configurar Espelmes', description: 'Col·loca dues espelmes a 30 cm de distància. Una et representa, l\'altra representa el que estàs alliberant.'),
        RitualStep(order: 3, title: 'Lligar el Cordó', description: 'Lliga el fil entre les espelmes. Encén ambdues. Això representa la connexió energètica.'),
        RitualStep(order: 4, title: 'Parla la teva Veritat', description: 'Digues: "Honro el que va ser, però aquesta connexió ja no serveix al meu major bé. L\'allibero amb amor."'),
        RitualStep(order: 5, title: 'Tallar el Cordó', description: 'Utilitza tisores per tallar el fil. Digues fermament: "Està fet. Sóc lliure. Ets lliure."'),
        RitualStep(order: 6, title: 'Alliberar l\'Energia', description: 'Crema el fil tallat de manera segura. Apaga l\'espelma que no ets tu. Mantingues la teva espelma encesa una mica més.'),
      ],
      intentionsEn: ['Cutting ties', 'Boundaries', 'Freedom', 'Energetic sovereignty'],
      intentionsEs: ['Cortar lazos', 'Límites', 'Libertad', 'Soberanía energética'],
      intentionsCa: ['Tallar llaços', 'Límits', 'Llibertat', 'Sobirania energètica'],
      iconEmoji: '✂️',
    ),

    LunarRitual(
      id: 'waning_rest_reflection',
      nameEn: 'Waning Moon Rest & Reflection',
      nameEs: 'Descanso y Reflexión de Luna Menguante',
      nameCa: 'Descans i Reflexió de Lluna Minvant',
      descriptionEn: 'Honor the need for rest and deep reflection as the moon wanes toward darkness',
      descriptionEs: 'Honra la necesidad de descanso y reflexión profunda mientras la luna mengua hacia la oscuridad',
      descriptionCa: 'Honra la necessitat de descans i reflexió profunda mentre la lluna minva cap a la foscor',
      phases: ['last_quarter', 'waning_crescent'],
      category: 'healing',
      durationMinutes: 40,
      difficulty: 'beginner',
      materialsEn: ['Comfortable cushion or bed', 'Soft blanket', 'Journal', 'Calming tea', 'Dim lighting'],
      materialsEs: ['Cojín o cama cómoda', 'Manta suave', 'Diario', 'Té calmante', 'Iluminación tenue'],
      materialsCa: ['Coixí o llit còmode', 'Manta suau', 'Diari', 'Te calmant', 'Il·luminació tènue'],
      stepsEn: [
        RitualStep(order: 1, title: 'Create Restful Space', description: 'Dim lights, light a candle if desired. Make your space cozy. Brew calming tea.'),
        RitualStep(order: 2, title: 'Settle In', description: 'Sit or lie comfortably. Wrap yourself in blanket. Take 10 deep, slow breaths.'),
        RitualStep(order: 3, title: 'Reflect on the Cycle', description: 'Journal: What did this lunar cycle teach me? What am I ready to let fade? What needs rest?'),
        RitualStep(order: 4, title: 'Practice Acceptance', description: 'Say: "I accept where I am. I honor my need for rest. Not all seasons are for action."'),
        RitualStep(order: 5, title: 'Rest or Meditate', description: 'Close your eyes. Rest for 15-20 minutes. Let yourself drift. No agenda. Just be.'),
        RitualStep(order: 6, title: 'Close Gently', description: 'When ready, open eyes slowly. Stretch gently. Thank yourself for this gift of rest.'),
      ],
      stepsEs: [
        RitualStep(order: 1, title: 'Crear Espacio de Descanso', description: 'Atenúa las luces, enciende una vela si lo deseas. Haz tu espacio acogedor. Prepara té calmante.'),
        RitualStep(order: 2, title: 'Acomodarse', description: 'Siéntate o acuéstate cómodamente. Envuélvete en una manta. Toma 10 respiraciones profundas y lentas.'),
        RitualStep(order: 3, title: 'Reflexionar sobre el Ciclo', description: 'Escribe: ¿Qué me enseñó este ciclo lunar? ¿Qué estoy listo para dejar desvanecer? ¿Qué necesita descanso?'),
        RitualStep(order: 4, title: 'Practicar la Aceptación', description: 'Di: "Acepto donde estoy. Honro mi necesidad de descanso. No todas las estaciones son para la acción."'),
        RitualStep(order: 5, title: 'Descansar o Meditar', description: 'Cierra los ojos. Descansa durante 15-20 minutos. Déjate llevar. Sin agenda. Solo ser.'),
        RitualStep(order: 6, title: 'Cerrar Suavemente', description: 'Cuando estés listo, abre los ojos lentamente. Estira suavemente. Agradécete por este regalo de descanso.'),
      ],
      stepsCa: [
        RitualStep(order: 1, title: 'Crear Espai de Descans', description: 'Atenua les llums, encén una espelma si ho desitges. Fes el teu espai acollidor. Prepara te calmant.'),
        RitualStep(order: 2, title: 'Acomodar-se', description: 'Seu o estigues-te còmodament. Embolica\'t en una manta. Pren 10 respiracions profundes i lentes.'),
        RitualStep(order: 3, title: 'Reflexionar sobre el Cicle', description: 'Escriu: Què m\'ha ensenyat aquest cicle lunar? Què estic preparat per deixar esvair? Què necessita descans?'),
        RitualStep(order: 4, title: 'Practicar l\'Acceptació', description: 'Digues: "Accepto on estic. Honoro la meva necessitat de descans. No totes les estacions són per a l\'acció."'),
        RitualStep(order: 5, title: 'Descansar o Meditar', description: 'Tanca els ulls. Descansa durant 15-20 minuts. Deixa\'t portar. Sense agenda. Només ser.'),
        RitualStep(order: 6, title: 'Tancar Suaument', description: 'Quan estiguis preparat, obre els ulls lentament. Estira suaument. Agraeix-te per aquest regal de descans.'),
      ],
      intentionsEn: ['Rest', 'Reflection', 'Acceptance', 'Integration'],
      intentionsEs: ['Descanso', 'Reflexión', 'Aceptación', 'Integración'],
      intentionsCa: ['Descans', 'Reflexió', 'Acceptació', 'Integració'],
      iconEmoji: '🌙',
    ),

    // GENERAL / MULTIPLE PHASE RITUALS (4)
    LunarRitual(
      id: 'moon_water_creation',
      nameEn: 'Moon Water Creation',
      nameEs: 'Creación de Agua Lunar',
      nameCa: 'Creació d\'Aigua Lunar',
      descriptionEn: 'Create charged moon water for use in rituals, blessings, and spiritual work',
      descriptionEs: 'Crea agua lunar cargada para usar en rituales, bendiciones y trabajo espiritual',
      descriptionCa: 'Crea aigua lunar carregada per utilitzar en rituals, benediccions i treball espiritual',
      phases: ['new_moon', 'waxing_crescent', 'first_quarter', 'waxing_gibbous', 'full_moon'],
      category: 'manifestation',
      durationMinutes: 15,
      difficulty: 'beginner',
      materialsEn: ['Glass jar or bottle', 'Fresh water', 'Optional: crystals, herbs, flowers'],
      materialsEs: ['Frasco o botella de vidrio', 'Agua fresca', 'Opcional: cristales, hierbas, flores'],
      materialsCa: ['Pot o ampolla de vidre', 'Aigua fresca', 'Opcional: cristalls, herbes, flors'],
      stepsEn: [
        RitualStep(order: 1, title: 'Choose Your Phase', description: 'Different moon phases infuse different qualities. New moon for intention, full moon for power, waning for release.'),
        RitualStep(order: 2, title: 'Fill Your Jar', description: 'Fill a clean glass container with fresh water. Add crystals, herbs, or flowers if desired.'),
        RitualStep(order: 3, title: 'Set Intention', description: 'Hold hands over water. State your intention clearly. Example: "I charge this water with lunar energy for clarity and wisdom."'),
        RitualStep(order: 4, title: 'Place in Moonlight', description: 'Leave outside or on windowsill overnight (at least 3 hours). Let the moon charge the water.'),
        RitualStep(order: 5, title: 'Collect and Store', description: 'In morning, collect your moon water. Store in a cool, dark place. Label with date and moon phase.'),
        RitualStep(order: 6, title: 'Use Mindfully', description: 'Use in baths, to anoint objects, water plants, drink (if clean), or sprinkle for blessings.'),
      ],
      stepsEs: [
        RitualStep(order: 1, title: 'Elegir tu Fase', description: 'Diferentes fases lunares infunden diferentes cualidades. Luna nueva para intención, luna llena para poder, menguante para liberación.'),
        RitualStep(order: 2, title: 'Llenar tu Frasco', description: 'Llena un recipiente de vidrio limpio con agua fresca. Añade cristales, hierbas o flores si lo deseas.'),
        RitualStep(order: 3, title: 'Establecer Intención', description: 'Sostén las manos sobre el agua. Declara tu intención claramente. Ejemplo: "Cargo esta agua con energía lunar para claridad y sabiduría."'),
        RitualStep(order: 4, title: 'Colocar a la Luz de la Luna', description: 'Deja afuera o en el alféizar durante la noche (al menos 3 horas). Deja que la luna cargue el agua.'),
        RitualStep(order: 5, title: 'Recoger y Almacenar', description: 'Por la mañana, recoge tu agua lunar. Almacena en un lugar fresco y oscuro. Etiqueta con fecha y fase lunar.'),
        RitualStep(order: 6, title: 'Usar Conscientemente', description: 'Usa en baños, para ungir objetos, regar plantas, beber (si está limpia), o rociar para bendiciones.'),
      ],
      stepsCa: [
        RitualStep(order: 1, title: 'Triar la teva Fase', description: 'Diferents fases lunars infonen diferents qualitats. Lluna nova per intenció, lluna plena per poder, minvant per alliberament.'),
        RitualStep(order: 2, title: 'Omplir el teu Pot', description: 'Omple un recipient de vidre net amb aigua fresca. Afegeix cristalls, herbes o flors si ho desitges.'),
        RitualStep(order: 3, title: 'Establir Intenció', description: 'Sostingues les mans sobre l\'aigua. Declara la teva intenció clarament. Exemple: "Carrego aquesta aigua amb energia lunar per claredat i saviesa."'),
        RitualStep(order: 4, title: 'Col·locar a la Llum de la Lluna', description: 'Deixa a fora o a l\'ampit durant la nit (almenys 3 hores). Deixa que la lluna carregui l\'aigua.'),
        RitualStep(order: 5, title: 'Recollir i Emmagatzemar', description: 'Al matí, recull la teva aigua lunar. Emmagatzema en un lloc fresc i fosc. Etiqueta amb data i fase lunar.'),
        RitualStep(order: 6, title: 'Utilitzar Conscientment', description: 'Utilitza en banys, per ungir objectes, regar plantes, beure (si està neta), o ruixar per benediccions.'),
      ],
      intentionsEn: ['Charging', 'Blessing', 'Infusion', 'Sacred water'],
      intentionsEs: ['Carga', 'Bendición', 'Infusión', 'Agua sagrada'],
      intentionsCa: ['Càrrega', 'Benedicció', 'Infusió', 'Aigua sagrada'],
      iconEmoji: '💧',
    ),

    LunarRitual(
      id: 'lunar_meditation',
      nameEn: 'Lunar Cycle Meditation',
      nameEs: 'Meditación del Ciclo Lunar',
      nameCa: 'Meditació del Cicle Lunar',
      descriptionEn: 'Connect deeply with the current moon phase through guided meditation',
      descriptionEs: 'Conéctate profundamente con la fase lunar actual a través de meditación guiada',
      descriptionCa: 'Connecta profundament amb la fase lunar actual mitjançant meditació guiada',
      phases: ['new_moon', 'waxing_crescent', 'first_quarter', 'waxing_gibbous', 'full_moon', 'waning_gibbous', 'last_quarter', 'waning_crescent'],
      category: 'healing',
      durationMinutes: 25,
      difficulty: 'beginner',
      materialsEn: ['Comfortable seat or cushion', 'Quiet space', 'Optional: blanket', 'Optional: meditation music'],
      materialsEs: ['Asiento o cojín cómodo', 'Espacio tranquilo', 'Opcional: manta', 'Opcional: música de meditación'],
      materialsCa: ['Seient o coixí còmode', 'Espai tranquil', 'Opcional: manta', 'Opcional: música de meditació'],
      stepsEn: [
        RitualStep(order: 1, title: 'Prepare Space', description: 'Find a quiet, comfortable spot. Sit with spine straight but relaxed. Set timer for 20 minutes.'),
        RitualStep(order: 2, title: 'Ground and Breathe', description: 'Take 10 deep breaths. Feel your body settling. Release tension with each exhale.'),
        RitualStep(order: 3, title: 'Visualize the Moon', description: 'Picture the moon in its current phase. See it clearly in your mind\'s eye. Feel its energy.'),
        RitualStep(order: 4, title: 'Receive Moon Energy', description: 'Imagine moonlight pouring down through your crown. It fills your body with silver light.'),
        RitualStep(order: 5, title: 'Ask and Listen', description: 'Ask the moon: "What message do you have for me?" Sit in receptive silence. Listen.'),
        RitualStep(order: 6, title: 'Return and Record', description: 'When timer sounds, slowly return to awareness. Open eyes. Journal any insights immediately.'),
      ],
      stepsEs: [
        RitualStep(order: 1, title: 'Preparar Espacio', description: 'Encuentra un lugar tranquilo y cómodo. Siéntate con la columna recta pero relajada. Configura temporizador por 20 minutos.'),
        RitualStep(order: 2, title: 'Arraigarse y Respirar', description: 'Toma 10 respiraciones profundas. Siente tu cuerpo asentándose. Libera tensión con cada exhalación.'),
        RitualStep(order: 3, title: 'Visualizar la Luna', description: 'Imagina la luna en su fase actual. Véela claramente en tu ojo mental. Siente su energía.'),
        RitualStep(order: 4, title: 'Recibir Energía Lunar', description: 'Imagina la luz de la luna vertiendo a través de tu corona. Llena tu cuerpo con luz plateada.'),
        RitualStep(order: 5, title: 'Preguntar y Escuchar', description: 'Pregunta a la luna: "¿Qué mensaje tienes para mí?" Siéntate en silencio receptivo. Escucha.'),
        RitualStep(order: 6, title: 'Regresar y Registrar', description: 'Cuando suene el temporizador, regresa lentamente a la conciencia. Abre los ojos. Escribe cualquier percepción inmediatamente.'),
      ],
      stepsCa: [
        RitualStep(order: 1, title: 'Preparar Espai', description: 'Troba un lloc tranquil i còmode. Seu amb la columna recta però relaxada. Configura temporitzador per 20 minuts.'),
        RitualStep(order: 2, title: 'Arrelar i Respirar', description: 'Pren 10 respiracions profundes. Sent el teu cos assentant-se. Allibera tensió amb cada exhalació.'),
        RitualStep(order: 3, title: 'Visualitzar la Lluna', description: 'Imagina la lluna en la seva fase actual. Veu-la clarament al teu ull mental. Sent la seva energia.'),
        RitualStep(order: 4, title: 'Rebre Energia Lunar', description: 'Imagina la llum de la lluna abocant a través de la teva corona. Omple el teu cos amb llum platejada.'),
        RitualStep(order: 5, title: 'Preguntar i Escoltar', description: 'Pregunta a la lluna: "Quin missatge tens per a mi?" Seu en silenci receptiu. Escolta.'),
        RitualStep(order: 6, title: 'Tornar i Registrar', description: 'Quan soni el temporitzador, torna lentament a la consciència. Obre els ulls. Escriu qualsevol percepció immediatament.'),
      ],
      intentionsEn: ['Connection', 'Receptivity', 'Inner wisdom', 'Stillness'],
      intentionsEs: ['Conexión', 'Receptividad', 'Sabiduría interior', 'Quietud'],
      intentionsCa: ['Connexió', 'Receptivitat', 'Saviesa interior', 'Quietud'],
      iconEmoji: '🧘',
    ),

    LunarRitual(
      id: 'moon_altar_creation',
      nameEn: 'Create Moon Altar',
      nameEs: 'Crear Altar Lunar',
      nameCa: 'Crear Altar Lunar',
      descriptionEn: 'Build a sacred moon altar as a focal point for your lunar practice',
      descriptionEs: 'Construye un altar lunar sagrado como punto focal para tu práctica lunar',
      descriptionCa: 'Construeix un altar lunar sagrat com a punt focal per a la teva pràctica lunar',
      phases: ['new_moon', 'waxing_crescent', 'first_quarter', 'waxing_gibbous', 'full_moon', 'waning_gibbous', 'last_quarter', 'waning_crescent'],
      category: 'manifestation',
      durationMinutes: 45,
      difficulty: 'beginner',
      materialsEn: ['Small table or shelf space', 'White or silver cloth', 'Candles', 'Crystals (moonstone, selenite, clear quartz)', 'Moon imagery', 'Fresh flowers or plants', 'Personal meaningful items'],
      materialsEs: ['Mesa pequeña o espacio en estante', 'Tela blanca o plateada', 'Velas', 'Cristales (piedra lunar, selenita, cuarzo transparente)', 'Imágenes de la luna', 'Flores frescas o plantas', 'Objetos personales significativos'],
      materialsCa: ['Taula petita o espai en prestatge', 'Tela blanca o platejada', 'Espelmes', 'Cristalls (pedra lunar, selenita, quars transparent)', 'Imatges de la lluna', 'Flors fresques o plantes', 'Objectes personals significatius'],
      stepsEn: [
        RitualStep(order: 1, title: 'Choose Location', description: 'Select a space where you can leave altar undisturbed. Near window with moonlight is ideal.'),
        RitualStep(order: 2, title: 'Cleanse the Space', description: 'Clean physically. Then sage, ring bells, or use sound to cleanse energetically.'),
        RitualStep(order: 3, title: 'Lay Foundation', description: 'Place cloth as base. This marks the space as sacred. Smooth it with intention.'),
        RitualStep(order: 4, title: 'Arrange Elements', description: 'Place items intuitively. Typically: candles, crystals, moon imagery, personal items, offerings.'),
        RitualStep(order: 5, title: 'Consecrate Altar', description: 'Light candles. Say: "This altar is dedicated to the moon\'s wisdom and my spiritual growth. May it be a beacon of light."'),
        RitualStep(order: 6, title: 'Maintain Regularly', description: 'Visit daily. Light candles. Refresh offerings. Update with current moon phase. Keep it alive.'),
      ],
      stepsEs: [
        RitualStep(order: 1, title: 'Elegir Ubicación', description: 'Selecciona un espacio donde puedas dejar el altar sin molestar. Cerca de ventana con luz de luna es ideal.'),
        RitualStep(order: 2, title: 'Limpiar el Espacio', description: 'Limpia físicamente. Luego salvia, toca campanas, o usa sonido para limpiar energéticamente.'),
        RitualStep(order: 3, title: 'Establecer Base', description: 'Coloca tela como base. Esto marca el espacio como sagrado. Alísala con intención.'),
        RitualStep(order: 4, title: 'Organizar Elementos', description: 'Coloca objetos intuitivamente. Típicamente: velas, cristales, imágenes lunares, objetos personales, ofrendas.'),
        RitualStep(order: 5, title: 'Consagrar Altar', description: 'Enciende velas. Di: "Este altar está dedicado a la sabiduría de la luna y mi crecimiento espiritual. Que sea un faro de luz."'),
        RitualStep(order: 6, title: 'Mantener Regularmente', description: 'Visita diariamente. Enciende velas. Refresca ofrendas. Actualiza con fase lunar actual. Manténlo vivo.'),
      ],
      stepsCa: [
        RitualStep(order: 1, title: 'Triar Ubicació', description: 'Selecciona un espai on puguis deixar l\'altar sense molestar. A prop de finestra amb llum de lluna és ideal.'),
        RitualStep(order: 2, title: 'Netejar l\'Espai', description: 'Neteja físicament. Després sàlvia, toca campanes, o utilitza so per netejar energèticament.'),
        RitualStep(order: 3, title: 'Establir Base', description: 'Col·loca tela com a base. Això marca l\'espai com a sagrat. Allisa-la amb intenció.'),
        RitualStep(order: 4, title: 'Organitzar Elements', description: 'Col·loca objectes intuïtivament. Típicament: espelmes, cristalls, imatges lunars, objectes personals, ofrenes.'),
        RitualStep(order: 5, title: 'Consagrar Altar', description: 'Encén espelmes. Digues: "Aquest altar està dedicat a la saviesa de la lluna i el meu creixement espiritual. Que sigui un far de llum."'),
        RitualStep(order: 6, title: 'Mantenir Regularment', description: 'Visita diàriament. Encén espelmes. Refresca ofrenes. Actualitza amb fase lunar actual. Mantingues-lo viu.'),
      ],
      intentionsEn: ['Sacred space', 'Dedication', 'Focus', 'Practice'],
      intentionsEs: ['Espacio sagrado', 'Dedicación', 'Enfoque', 'Práctica'],
      intentionsCa: ['Espai sagrat', 'Dedicació', 'Enfocament', 'Pràctica'],
      iconEmoji: '🕯️',
    ),

    LunarRitual(
      id: 'moonlight_journal',
      nameEn: 'Moonlight Journaling',
      nameEs: 'Diario a la Luz de la Luna',
      nameCa: 'Diari a la Llum de la Lluna',
      descriptionEn: 'Write by moonlight to access deeper intuition and lunar wisdom',
      descriptionEs: 'Escribe a la luz de la luna para acceder a intuición más profunda y sabiduría lunar',
      descriptionCa: 'Escriu a la llum de la lluna per accedir a intuïció més profunda i saviesa lunar',
      phases: ['new_moon', 'waxing_crescent', 'first_quarter', 'waxing_gibbous', 'full_moon', 'waning_gibbous', 'last_quarter', 'waning_crescent'],
      category: 'manifestation',
      durationMinutes: 30,
      difficulty: 'beginner',
      materialsEn: ['Journal or paper', 'Pen', 'Moonlit space (outdoors or near window)', 'Optional: candle', 'Optional: warm drink'],
      materialsEs: ['Diario o papel', 'Bolígrafo', 'Espacio iluminado por luna (exterior o cerca de ventana)', 'Opcional: vela', 'Opcional: bebida caliente'],
      materialsCa: ['Diari o paper', 'Bolígraf', 'Espai il·luminat per lluna (exterior o a prop de finestra)', 'Opcional: espelma', 'Opcional: beguda calenta'],
      stepsEn: [
        RitualStep(order: 1, title: 'Find Moonlight', description: 'Position yourself where moonlight reaches you. Let it touch your skin and your journal.'),
        RitualStep(order: 2, title: 'Settle and Breathe', description: 'Take several deep breaths. Feel the moon\'s presence. Let thoughts settle like snow.'),
        RitualStep(order: 3, title: 'Phase-Specific Prompts', description: 'New moon: What do I want to birth? Full moon: What has come to light? Waning: What needs release?'),
        RitualStep(order: 4, title: 'Free Write', description: 'Write continuously for 15-20 minutes. Don\'t edit or censor. Let the words flow from intuition.'),
        RitualStep(order: 5, title: 'Read and Reflect', description: 'Read what you wrote. Underline phrases that resonate. Notice patterns or insights.'),
        RitualStep(order: 6, title: 'Close with Gratitude', description: 'Thank the moon for its wisdom. Close journal. Keep it in moonlight overnight to charge it.'),
      ],
      stepsEs: [
        RitualStep(order: 1, title: 'Encontrar Luz de Luna', description: 'Posiciónate donde la luz de la luna te alcance. Deja que toque tu piel y tu diario.'),
        RitualStep(order: 2, title: 'Asentarse y Respirar', description: 'Toma varias respiraciones profundas. Siente la presencia de la luna. Deja que los pensamientos se asienten como nieve.'),
        RitualStep(order: 3, title: 'Prompts según Fase', description: 'Luna nueva: ¿Qué quiero dar a luz? Luna llena: ¿Qué ha salido a la luz? Menguante: ¿Qué necesita liberación?'),
        RitualStep(order: 4, title: 'Escritura Libre', description: 'Escribe continuamente durante 15-20 minutos. No edites ni censures. Deja que las palabras fluyan desde la intuición.'),
        RitualStep(order: 5, title: 'Leer y Reflexionar', description: 'Lee lo que escribiste. Subraya frases que resuenen. Nota patrones o percepciones.'),
        RitualStep(order: 6, title: 'Cerrar con Gratitud', description: 'Agradece a la luna por su sabiduría. Cierra el diario. Déjalo a la luz de la luna durante la noche para cargarlo.'),
      ],
      stepsCa: [
        RitualStep(order: 1, title: 'Trobar Llum de Lluna', description: 'Posiciona\'t on la llum de la lluna t\'arribi. Deixa que toqui la teva pell i el teu diari.'),
        RitualStep(order: 2, title: 'Assentar-se i Respirar', description: 'Pren diverses respiracions profundes. Sent la presència de la lluna. Deixa que els pensaments s\'assentin com neu.'),
        RitualStep(order: 3, title: 'Prompts segons Fase', description: 'Lluna nova: Què vull parir? Lluna plena: Què ha sortit a la llum? Minvant: Què necessita alliberament?'),
        RitualStep(order: 4, title: 'Escriptura Lliure', description: 'Escriu contínuament durant 15-20 minuts. No editís ni censuris. Deixa que les paraules flueixin des de la intuïció.'),
        RitualStep(order: 5, title: 'Llegir i Reflexionar', description: 'Llegeix el que vas escriure. Subratlla frases que resonin. Nota patrons o percepcions.'),
        RitualStep(order: 6, title: 'Tancar amb Gratitud', description: 'Agraeix a la lluna per la seva saviesa. Tanca el diari. Deixa\'l a la llum de la lluna durant la nit per carregar-lo.'),
      ],
      intentionsEn: ['Self-discovery', 'Intuition', 'Clarity', 'Processing'],
      intentionsEs: ['Autodescubrimiento', 'Intuición', 'Claridad', 'Procesamiento'],
      intentionsCa: ['Autodescobrim', 'Intuïció', 'Claredat', 'Processament'],
      iconEmoji: '📔',
    ),
  ];

  static List<LunarRitual> getRitualsForPhase(String phaseId) {
    return allRituals.where((r) => r.phases.contains(phaseId)).toList();
  }

  static List<LunarRitual> getRitualsByCategory(String category) {
    return allRituals.where((r) => r.category == category).toList();
  }

  static LunarRitual? getRitualById(String id) {
    try {
      return allRituals.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}
