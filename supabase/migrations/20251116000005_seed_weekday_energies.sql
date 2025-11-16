-- =====================================================
-- SEED WEEKDAY ENERGIES (7 PLANETARY DAYS)
-- =====================================================
-- Purpose: Populate the 7 weekday energies based on Chaldean Order
-- Foundation: Babylonian/Hellenistic astrology (2000+ years)
-- Source: docs/planetary_weekday_correspondences.md

-- =====================================================
-- SUNDAY - SUN ☀️
-- =====================================================
INSERT INTO weekday_energies (
  weekday,
  planet,
  element,
  qualities,
  description,
  traditional_meaning,
  areas_of_influence,
  favorable_activities,
  color,
  metal,
  stones,
  herbs,
  planet_emoji,
  element_emoji
) VALUES (
  'sunday',
  'sun',
  'fire',
  '{"polarity": "yang", "temperature": "hot", "moisture": "dry"}'::jsonb,
  '{
    "en": "The Sun''s radiant energy illuminates your path and amplifies your personal power. This is a day of vitality, self-expression, and stepping into your authentic authority.",
    "es": "La energía radiante del Sol ilumina tu camino y amplifica tu poder personal. Este es un día de vitalidad, autoexpresión y de asumir tu autoridad auténtica.",
    "ca": "L''energia radiant del Sol il·lumina el teu camí i amplifica el teu poder personal. Aquest és un dia de vitalitat, autoexpressió i d''assumir la teva autoritat autèntica."
  }'::jsonb,
  '{
    "en": "The Sun governs vitality, ego, identity, and life purpose. In traditional astrology, Sunday is ruled by the Sun, the center of our solar system and the source of all life. This day carries the energy of confidence, creativity, and conscious self-awareness.",
    "es": "El Sol gobierna la vitalidad, el ego, la identidad y el propósito de vida. En astrología tradicional, el domingo está regido por el Sol, el centro de nuestro sistema solar y la fuente de toda vida. Este día lleva la energía de confianza, creatividad y autoconciencia consciente.",
    "ca": "El Sol governa la vitalitat, l''ego, la identitat i el propòsit de vida. En astrologia tradicional, el diumenge està regit pel Sol, el centre del nostre sistema solar i la font de tota vida. Aquest dia porta l''energia de confiança, creativitat i autoconsciència conscient."
  }'::jsonb,
  '{
    "en": ["Physical vitality and health", "Recognition and fame", "Authority figures and leadership", "Creative self-expression", "Life purpose and direction", "Personal confidence"],
    "es": ["Vitalidad física y salud", "Reconocimiento y fama", "Figuras de autoridad y liderazgo", "Autoexpresión creativa", "Propósito de vida y dirección", "Confianza personal"],
    "ca": ["Vitalitat física i salut", "Reconeixement i fama", "Figures d''autoritat i lideratge", "Autoexpressió creativa", "Propòsit de vida i direcció", "Confiança personal"]
  }'::jsonb,
  '{
    "en": ["Boost personal confidence through ritual or affirmation", "Plan important projects that require visibility", "Connect with your life purpose through meditation", "Creative activities that express your authentic self", "Seek recognition for your achievements", "Lead or take charge of situations"],
    "es": ["Aumenta la confianza personal a través de ritual o afirmación", "Planifica proyectos importantes que requieren visibilidad", "Conecta con tu propósito de vida a través de meditación", "Actividades creativas que expresen tu yo auténtico", "Busca reconocimiento por tus logros", "Lidera o toma el control de situaciones"],
    "ca": ["Augmenta la confiança personal a través de ritual o afirmació", "Planifica projectes importants que requereixen visibilitat", "Connecta amb el teu propòsit de vida a través de meditació", "Activitats creatives que expressin el teu jo autèntic", "Cerca reconeixement pels teus assoliments", "Lidera o pren el control de situacions"]
  }'::jsonb,
  'gold',
  'gold',
  '["topaz", "diamond", "citrine"]'::jsonb,
  '["chamomile", "calendula", "St. John''s wort", "sunflower"]'::jsonb,
  '☀️',
  '🔥'
);

-- =====================================================
-- MONDAY - MOON 🌙
-- =====================================================
INSERT INTO weekday_energies (
  weekday,
  planet,
  element,
  qualities,
  description,
  traditional_meaning,
  areas_of_influence,
  favorable_activities,
  color,
  metal,
  stones,
  herbs,
  planet_emoji,
  element_emoji
) VALUES (
  'monday',
  'moon',
  'water',
  '{"polarity": "yin", "temperature": "cold", "moisture": "moist"}'::jsonb,
  '{
    "en": "The Moon''s reflective energy invites you inward to explore emotions, intuition, and the rhythms of your inner world. This is a day of feeling, nurturing, and honoring your emotional landscape.",
    "es": "La energía reflexiva de la Luna te invita hacia adentro para explorar emociones, intuición y los ritmos de tu mundo interior. Este es un día de sentir, nutrir y honrar tu paisaje emocional.",
    "ca": "L''energia reflexiva de la Lluna t''invita cap a dins per explorar emocions, intuïció i els ritmes del teu món interior. Aquest és un dia de sentir, nodrir i honorar el teu paisatge emocional."
  }'::jsonb,
  '{
    "en": "The Moon governs emotions, intuition, memory, and cycles. In traditional astrology, Monday is ruled by the Moon, the celestial body that governs our emotional tides and unconscious patterns. This day carries the energy of receptivity, nurturing, and psychic sensitivity.",
    "es": "La Luna gobierna las emociones, la intuición, la memoria y los ciclos. En astrología tradicional, el lunes está regido por la Luna, el cuerpo celeste que gobierna nuestras mareas emocionales y patrones inconscientes. Este día lleva la energía de receptividad, nutrición y sensibilidad psíquica.",
    "ca": "La Lluna governa les emocions, la intuïció, la memòria i els cicles. En astrologia tradicional, el dilluns està regit per la Lluna, el cos celeste que governa les nostres marees emocionals i patrons inconscients. Aquest dia porta l''energia de receptivitat, nutrició i sensibilitat psíquica."
  }'::jsonb,
  '{
    "en": ["Emotions and feelings", "Intuition and psychic abilities", "Home and domestic life", "Mother and maternal figures", "Memory and past", "Habits and routines", "Dreams and the unconscious"],
    "es": ["Emociones y sentimientos", "Intuición y habilidades psíquicas", "Hogar y vida doméstica", "Madre y figuras maternales", "Memoria y pasado", "Hábitos y rutinas", "Sueños y el inconsciente"],
    "ca": ["Emocions i sentiments", "Intuïció i habilitats psíquiques", "Llar i vida domèstica", "Mare i figures maternals", "Memòria i passat", "Hàbits i rutines", "Somnis i l''inconscient"]
  }'::jsonb,
  '{
    "en": ["Work with dreams through journaling or interpretation", "Emotional cleansing ritual or release work", "Connect with family and honor your roots", "Meditation and inner reflection", "Divination practices (tarot, oracle cards)", "Nurture yourself and others", "Tend to domestic matters and home"],
    "es": ["Trabaja con sueños mediante diario o interpretación", "Ritual de limpieza emocional o trabajo de liberación", "Conecta con la familia y honra tus raíces", "Meditación y reflexión interior", "Prácticas de adivinación (tarot, cartas oráculo)", "Nutre a ti mismo y a los demás", "Atiende asuntos domésticos y el hogar"],
    "ca": ["Treballa amb somnis mitjançant diari o interpretació", "Ritual de neteja emocional o treball d''alliberament", "Connecta amb la família i honora les teves arrels", "Meditació i reflexió interior", "Pràctiques d''endevinació (tarot, cartes oracle)", "Nodrix a tu mateix i als altres", "Atén assumptes domèstics i la llar"]
  }'::jsonb,
  'silver',
  'silver',
  '["moonstone", "pearl", "selenite", "opal"]'::jsonb,
  '["mugwort", "jasmine", "white sage", "eucalyptus"]'::jsonb,
  '🌙',
  '💧'
);

-- =====================================================
-- TUESDAY - MARS ♂️
-- =====================================================
INSERT INTO weekday_energies (
  weekday,
  planet,
  element,
  qualities,
  description,
  traditional_meaning,
  areas_of_influence,
  favorable_activities,
  color,
  metal,
  stones,
  herbs,
  planet_emoji,
  element_emoji
) VALUES (
  'tuesday',
  'mars',
  'fire',
  '{"polarity": "yang", "temperature": "hot", "moisture": "dry"}'::jsonb,
  '{
    "en": "Mars ignites the fire of action, courage, and assertive willpower. This is a day to move forward with determination, defend your boundaries, and channel your passion into purposeful action.",
    "es": "Marte enciende el fuego de la acción, el coraje y la fuerza de voluntad asertiva. Este es un día para avanzar con determinación, defender tus límites y canalizar tu pasión en acción con propósito.",
    "ca": "Mart encén el foc de l''acció, el coratge i la força de voluntat assertiva. Aquest és un dia per avançar amb determinació, defensar els teus límits i canalitzar la teva passió en acció amb propòsit."
  }'::jsonb,
  '{
    "en": "Mars governs action, courage, conflict, and desire. In traditional astrology, Tuesday is ruled by Mars, the warrior planet that drives us to act, compete, and assert our will. This day carries the energy of initiative, bravery, and physical dynamism.",
    "es": "Marte gobierna la acción, el coraje, el conflicto y el deseo. En astrología tradicional, el martes está regido por Marte, el planeta guerrero que nos impulsa a actuar, competir y afirmar nuestra voluntad. Este día lleva la energía de iniciativa, valentía y dinamismo físico.",
    "ca": "Mart governa l''acció, el coratge, el conflicte i el desig. En astrologia tradicional, el dimarts està regit per Mart, el planeta guerrer que ens impulsa a actuar, competir i afirmar la nostra voluntat. Aquest dia porta l''energia d''iniciativa, valentia i dinamisme físic."
  }'::jsonb,
  '{
    "en": ["Action and initiative", "Courage and bravery", "Conflict and competition", "Sexual passion and desire", "Physical energy and athletics", "Assertiveness and boundaries", "Independence and self-defense"],
    "es": ["Acción e iniciativa", "Coraje y valentía", "Conflicto y competición", "Pasión sexual y deseo", "Energía física y atletismo", "Asertividad y límites", "Independencia y autodefensa"],
    "ca": ["Acció i iniciativa", "Coratge i valentia", "Conflicte i competició", "Passió sexual i desig", "Energia física i atletisme", "Assertivitat i límits", "Independència i autodefensa"]
  }'::jsonb,
  '{
    "en": ["Ritual to boost courage and overcome fear", "Set firm boundaries and practice saying no", "Start projects that require decisive action", "Intense physical exercise or sports", "Stand up for yourself against injustice", "Channel anger constructively", "Take initiative on something you''ve been delaying"],
    "es": ["Ritual para aumentar el coraje y superar el miedo", "Establece límites firmes y practica decir no", "Inicia proyectos que requieren acción decisiva", "Ejercicio físico intenso o deportes", "Defiéndete contra la injusticia", "Canaliza la ira de forma constructiva", "Toma la iniciativa en algo que has estado postergando"],
    "ca": ["Ritual per augmentar el coratge i superar la por", "Estableix límits ferms i practica dir no", "Inicia projectes que requereixen acció decisiva", "Exercici físic intens o esports", "Defensa''t contra la injustícia", "Canalitza la ira de forma constructiva", "Pren la iniciativa en algo que has estat posposant"]
  }'::jsonb,
  'red',
  'iron',
  '["garnet", "ruby", "bloodstone", "red jasper"]'::jsonb,
  '["ginger", "black pepper", "cayenne", "nettle", "garlic"]'::jsonb,
  '♂️',
  '🔥'
);

-- =====================================================
-- WEDNESDAY - MERCURY ☿
-- =====================================================
INSERT INTO weekday_energies (
  weekday,
  planet,
  element,
  qualities,
  description,
  traditional_meaning,
  areas_of_influence,
  favorable_activities,
  color,
  metal,
  stones,
  herbs,
  planet_emoji,
  element_emoji
) VALUES (
  'wednesday',
  'mercury',
  'air',
  '{"polarity": "neutral", "temperature": "neutral", "moisture": "neutral"}'::jsonb,
  '{
    "en": "Mercury quickens the mind and opens channels of communication and learning. This is a day of mental agility, exchange of ideas, and connecting the dots between disparate concepts.",
    "es": "Mercurio acelera la mente y abre canales de comunicación y aprendizaje. Este es un día de agilidad mental, intercambio de ideas y conexión de puntos entre conceptos dispares.",
    "ca": "Mercuri accelera la ment i obre canals de comunicació i aprenentatge. Aquest és un dia d''agilitat mental, intercanvi d''idees i connexió de punts entre conceptes dispars."
  }'::jsonb,
  '{
    "en": "Mercury governs communication, intellect, commerce, and travel. In traditional astrology, Wednesday is ruled by Mercury, the messenger of the gods who facilitates exchange, learning, and connection. This day carries the energy of curiosity, adaptability, and mental dexterity.",
    "es": "Mercurio gobierna la comunicación, el intelecto, el comercio y los viajes. En astrología tradicional, el miércoles está regido por Mercurio, el mensajero de los dioses que facilita el intercambio, el aprendizaje y la conexión. Este día lleva la energía de curiosidad, adaptabilidad y destreza mental.",
    "ca": "Mercuri governa la comunicació, l''intel·lecte, el comerç i els viatges. En astrologia tradicional, el dimecres està regit per Mercuri, el missatger dels déus que facilita l''intercanvi, l''aprenentatge i la connexió. Aquest dia porta l''energia de curiositat, adaptabilitat i destresa mental."
  }'::jsonb,
  '{
    "en": ["Communication and language", "Intellectual reasoning and logic", "Learning and education", "Commerce and business transactions", "Technology and information", "Short trips and local travel", "Siblings and neighbors"],
    "es": ["Comunicación y lenguaje", "Razonamiento intelectual y lógica", "Aprendizaje y educación", "Comercio y transacciones comerciales", "Tecnología e información", "Viajes cortos y locales", "Hermanos y vecinos"],
    "ca": ["Comunicació i llenguatge", "Raonament intel·lectual i lògica", "Aprenentatge i educació", "Comerç i transaccions comercials", "Tecnologia i informació", "Viatges curts i locals", "Germans i veïns"]
  }'::jsonb,
  '{
    "en": ["Write, study, or teach something new", "Negotiate contracts or business deals", "Start a course or educational program", "Network and connect with others socially", "Organize information and declutter mentally", "Have important conversations", "Work on communication skills"],
    "es": ["Escribe, estudia o enseña algo nuevo", "Negocia contratos o negocios", "Comienza un curso o programa educativo", "Haz networking y conecta con otros socialmente", "Organiza información y despeja mentalmente", "Ten conversaciones importantes", "Trabaja en habilidades de comunicación"],
    "ca": ["Escriu, estudia o ensenya alguna cosa nova", "Negocia contractes o negocis", "Comença un curs o programa educatiu", "Fes networking i connecta amb altres socialment", "Organitza informació i neteja mentalment", "Tingues converses importants", "Treballa en habilitats de comunicació"]
  }'::jsonb,
  'orange',
  'mercury',
  '["agate", "carnelian", "aventurine", "citrine"]'::jsonb,
  '["lavender", "peppermint", "fennel", "dill", "parsley"]'::jsonb,
  '☿',
  '💨'
);

-- =====================================================
-- THURSDAY - JUPITER ♃
-- =====================================================
INSERT INTO weekday_energies (
  weekday,
  planet,
  element,
  qualities,
  description,
  traditional_meaning,
  areas_of_influence,
  favorable_activities,
  color,
  metal,
  stones,
  herbs,
  planet_emoji,
  element_emoji
) VALUES (
  'thursday',
  'jupiter',
  'fire',
  '{"polarity": "yang", "temperature": "hot", "moisture": "moist"}'::jsonb,
  '{
    "en": "Jupiter expands your horizons and invites abundance, wisdom, and optimistic faith. This is a day of growth, generosity, and trusting in the benevolence of the universe.",
    "es": "Júpiter expande tus horizontes e invita a la abundancia, la sabiduría y la fe optimista. Este es un día de crecimiento, generosidad y confianza en la benevolencia del universo.",
    "ca": "Júpiter expandeix els teus horitzons i convida a l''abundància, la saviesa i la fe optimista. Aquest és un dia de creixement, generositat i confiança en la benevolència de l''univers."
  }'::jsonb,
  '{
    "en": "Jupiter governs expansion, wisdom, justice, and abundance. In traditional astrology, Thursday is ruled by Jupiter, the king of the gods who bestows blessings, opportunities, and philosophical understanding. This day carries the energy of optimism, generosity, and faith in higher meaning.",
    "es": "Júpiter gobierna la expansión, la sabiduría, la justicia y la abundancia. En astrología tradicional, el jueves está regido por Júpiter, el rey de los dioses que otorga bendiciones, oportunidades y comprensión filosófica. Este día lleva la energía de optimismo, generosidad y fe en un significado superior.",
    "ca": "Júpiter governa l''expansió, la saviesa, la justícia i l''abundància. En astrologia tradicional, el dijous està regit per Júpiter, el rei dels déus que atorga benediccions, oportunitats i comprensió filosòfica. Aquest dia porta l''energia d''optimisme, generositat i fe en un significat superior."
  }'::jsonb,
  '{
    "en": ["Abundance and prosperity", "Wisdom and philosophy", "Higher education and knowledge", "Justice and legal matters", "Long-distance travel and foreign cultures", "Religion and spirituality", "Teachers and mentors", "Growth and expansion"],
    "es": ["Abundancia y prosperidad", "Sabiduría y filosofía", "Educación superior y conocimiento", "Justicia y asuntos legales", "Viajes de larga distancia y culturas extranjeras", "Religión y espiritualidad", "Maestros y mentores", "Crecimiento y expansión"],
    "ca": ["Abundància i prosperitat", "Saviesa i filosofia", "Educació superior i coneixement", "Justícia i assumptes legals", "Viatges de llarga distància i cultures estrangeres", "Religió i espiritualitat", "Mestres i mentors", "Creixement i expansió"]
  }'::jsonb,
  '{
    "en": ["Ritual to attract abundance and prosperity", "Begin higher education or philosophical study", "Plan long-distance travel or cultural exploration", "Practice gratitude and count your blessings", "Seek wisdom from teachers or mentors", "Engage with spiritual or religious practices", "Expand your worldview through learning"],
    "es": ["Ritual para atraer abundancia y prosperidad", "Comienza educación superior o estudio filosófico", "Planifica viajes de larga distancia o exploración cultural", "Practica la gratitud y cuenta tus bendiciones", "Busca sabiduría de maestros o mentores", "Participa en prácticas espirituales o religiosas", "Expande tu visión del mundo a través del aprendizaje"],
    "ca": ["Ritual per atraure abundància i prosperitat", "Comença educació superior o estudi filosòfic", "Planifica viatges de llarga distància o exploració cultural", "Practica la gratitud i compta les teves benediccions", "Cerca saviesa de mestres o mentors", "Participa en pràctiques espirituals o religioses", "Expandeix la teva visió del món a través de l''aprenentatge"]
  }'::jsonb,
  'purple',
  'tin',
  '["amethyst", "sapphire", "turquoise", "lapis lazuli"]'::jsonb,
  '["sage", "cedar", "nutmeg", "clove", "hyssop"]'::jsonb,
  '♃',
  '🔥'
);

-- =====================================================
-- FRIDAY - VENUS ♀
-- =====================================================
INSERT INTO weekday_energies (
  weekday,
  planet,
  element,
  qualities,
  description,
  traditional_meaning,
  areas_of_influence,
  favorable_activities,
  color,
  metal,
  stones,
  herbs,
  planet_emoji,
  element_emoji
) VALUES (
  'friday',
  'venus',
  'earth',
  '{"polarity": "yin", "temperature": "cold", "moisture": "moist"}'::jsonb,
  '{
    "en": "Venus invites pleasure, beauty, and harmonious connection. This is a day to savor life''s sweetness, cultivate relationships, and appreciate the beauty that surrounds you.",
    "es": "Venus invita al placer, la belleza y la conexión armoniosa. Este es un día para saborear la dulzura de la vida, cultivar relaciones y apreciar la belleza que te rodea.",
    "ca": "Venus convida al plaer, la bellesa i la connexió harmoniosa. Aquest és un dia per assaborir la dolçor de la vida, cultivar relacions i apreciar la bellesa que t''envolta."
  }'::jsonb,
  '{
    "en": "Venus governs love, beauty, pleasure, and values. In traditional astrology, Friday is ruled by Venus, the goddess of love who brings harmony, aesthetic appreciation, and relational connection. This day carries the energy of receptivity, sensuality, and diplomatic grace.",
    "es": "Venus gobierna el amor, la belleza, el placer y los valores. En astrología tradicional, el viernes está regido por Venus, la diosa del amor que trae armonía, apreciación estética y conexión relacional. Este día lleva la energía de receptividad, sensualidad y gracia diplomática.",
    "ca": "Venus governa l''amor, la bellesa, el plaer i els valors. En astrologia tradicional, el divendres està regit per Venus, la deessa de l''amor que porta harmonia, apreciació estètica i connexió relacional. Aquest dia porta l''energia de receptivitat, sensualitat i gràcia diplomàtica."
  }'::jsonb,
  '{
    "en": ["Romantic love and relationships", "Beauty and aesthetics", "Pleasure and enjoyment", "Money and material possessions", "Art and creative expression", "Social harmony and friendship", "Self-worth and values"],
    "es": ["Amor romántico y relaciones", "Belleza y estética", "Placer y disfrute", "Dinero y posesiones materiales", "Arte y expresión creativa", "Armonía social y amistad", "Autoestima y valores"],
    "ca": ["Amor romàntic i relacions", "Bellesa i estètica", "Plaer i gaudi", "Diners i possessions materials", "Art i expressió creativa", "Harmonia social i amistat", "Autoestima i valors"]
  }'::jsonb,
  '{
    "en": ["Love ritual or romantic gesture", "Create beauty through art or music", "Self-care and beauty treatments", "Socialize with friends and loved ones", "Shop for clothing, jewelry, or beautiful items", "Garden or work with flowers and plants", "Diplomatic conversations to restore harmony"],
    "es": ["Ritual de amor o gesto romántico", "Crea belleza a través del arte o la música", "Autocuidado y tratamientos de belleza", "Socializa con amigos y seres queridos", "Compra ropa, joyas o artículos hermosos", "Jardín o trabaja con flores y plantas", "Conversaciones diplomáticas para restaurar la armonía"],
    "ca": ["Ritual d''amor o gest romàntic", "Crea bellesa a través de l''art o la música", "Autocura i tractaments de bellesa", "Socialitza amb amics i éssers estimats", "Compra roba, joies o articles bells", "Jardí o treballa amb flors i plantes", "Converses diplomàtiques per restaurar l''harmonia"]
  }'::jsonb,
  'green',
  'copper',
  '["emerald", "rose quartz", "jade", "green aventurine"]'::jsonb,
  '["rose", "violet", "vanilla", "ylang-ylang", "apple blossom"]'::jsonb,
  '♀',
  '🌍'
);

-- =====================================================
-- SATURDAY - SATURN ♄
-- =====================================================
INSERT INTO weekday_energies (
  weekday,
  planet,
  element,
  qualities,
  description,
  traditional_meaning,
  areas_of_influence,
  favorable_activities,
  color,
  metal,
  stones,
  herbs,
  planet_emoji,
  element_emoji
) VALUES (
  'saturday',
  'saturn',
  'earth',
  '{"polarity": "yin", "temperature": "cold", "moisture": "dry"}'::jsonb,
  '{
    "en": "Saturn teaches through structure, discipline, and the wisdom of limitation. This is a day to build foundations, honor commitments, and understand that boundaries create freedom.",
    "es": "Saturno enseña a través de la estructura, la disciplina y la sabiduría de la limitación. Este es un día para construir cimientos, honrar compromisos y comprender que los límites crean libertad.",
    "ca": "Saturn ensenya a través de l''estructura, la disciplina i la saviesa de la limitació. Aquest és un dia per construir fonaments, honorar compromisos i comprendre que els límits creen llibertat."
  }'::jsonb,
  '{
    "en": "Saturn governs structure, discipline, time, and responsibility. In traditional astrology, Saturday is ruled by Saturn, the lord of time who teaches through limitation, maturity, and karmic lessons. This day carries the energy of patience, commitment, and earned wisdom.",
    "es": "Saturno gobierna la estructura, la disciplina, el tiempo y la responsabilidad. En astrología tradicional, el sábado está regido por Saturno, el señor del tiempo que enseña a través de la limitación, la madurez y las lecciones kármicas. Este día lleva la energía de paciencia, compromiso y sabiduría ganada.",
    "ca": "Saturn governa l''estructura, la disciplina, el temps i la responsabilitat. En astrologia tradicional, el dissabte està regit per Saturn, el senyor del temps que ensenya a través de la limitació, la maduresa i les lliçons kàrmiques. Aquest dia porta l''energia de paciència, compromís i saviesa guanyada."
  }'::jsonb,
  '{
    "en": ["Structure and organization", "Discipline and hard work", "Time and aging", "Responsibility and duty", "Boundaries and limitations", "Long-term goals and career", "Karma and life lessons", "Elders and authority"],
    "es": ["Estructura y organización", "Disciplina y trabajo duro", "Tiempo y envejecimiento", "Responsabilidad y deber", "Límites y limitaciones", "Metas a largo plazo y carrera", "Karma y lecciones de vida", "Ancianos y autoridad"],
    "ca": ["Estructura i organització", "Disciplina i treball dur", "Temps i envelliment", "Responsabilitat i deure", "Límits i limitacions", "Objectius a llarg termini i carrera", "Karma i lliçons de vida", "Ancians i autoritat"]
  }'::jsonb,
  '{
    "en": ["Long-term planning and goal-setting", "Deep cleaning and organization", "Set healthy boundaries in relationships", "Ancestral work and honoring elders", "Meditate on life lessons and patterns", "Complete old projects or commitments", "Discipline yourself in an area needing structure"],
    "es": ["Planificación a largo plazo y establecimiento de metas", "Limpieza profunda y organización", "Establece límites saludables en las relaciones", "Trabajo ancestral y honra a los ancianos", "Medita sobre lecciones de vida y patrones", "Completa proyectos antiguos o compromisos", "Disciplínate en un área que necesita estructura"],
    "ca": ["Planificació a llarg termini i establiment d''objectius", "Neteja profunda i organització", "Estableix límits saludables en les relacions", "Treball ancestral i honora els ancians", "Medita sobre lliçons de vida i patrons", "Completa projectes antics o compromisos", "Disciplina''t en una àrea que necessita estructura"]
  }'::jsonb,
  'black',
  'lead',
  '["onyx", "obsidian", "jet", "hematite", "black tourmaline"]'::jsonb,
  '["comfrey", "cypress", "patchouli", "myrrh", "Solomon''s seal"]'::jsonb,
  '♄',
  '🌍'
);

-- Update the updated_at timestamp for all rows (set to now)
UPDATE weekday_energies SET updated_at = now();

-- Verify the data
SELECT weekday, planet, element, active FROM weekday_energies ORDER BY
  CASE weekday
    WHEN 'sunday' THEN 1
    WHEN 'monday' THEN 2
    WHEN 'tuesday' THEN 3
    WHEN 'wednesday' THEN 4
    WHEN 'thursday' THEN 5
    WHEN 'friday' THEN 6
    WHEN 'saturday' THEN 7
  END;
