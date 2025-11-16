-- =====================================================
-- SEED SEASONAL OVERLAYS - NEW MOON (16 overlays)
-- =====================================================
-- Purpose: Seasonal variations for New Moon phase across all 4 elements
-- Structure: 4 elements × 4 seasons = 16 overlays
-- Foundation: Wheel of the Year + Lunar Astrology

-- NOTE: This migration references templates from 20251115000003_seed_lunar_guides.sql
-- Each overlay modifies a base template with seasonal energy

-- =====================================================
-- NEW MOON + FIRE (4 seasonal variations)
-- =====================================================

-- Spring: Aries Fire - Explosive New Beginnings
INSERT INTO seasonal_overlays (
  template_id,
  season,
  overlay_headline,
  overlay_description,
  energy_shift,
  themes,
  seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'new_moon' AND element = 'fire' AND priority = 1 LIMIT 1),
  'spring',
  '{
    "en": "Spring Ignites Bold New Starts",
    "es": "La Primavera Enciende Nuevos Inicios Audaces",
    "ca": "La Primavera Encén Nous Inicis Audaços"
  }'::jsonb,
  '{
    "en": "The new moon''s blank slate merges with spring''s explosive rebirth. As Aries fire initiates the astrological new year (March 21), your passionate intentions align with nature''s most powerful surge of growth energy.",
    "es": "La página en blanco de la luna nueva se fusiona con el renacimiento explosivo de la primavera. Mientras el fuego de Aries inicia el año nuevo astrológico (21 de marzo), tus intenciones apasionadas se alinean con el impulso de crecimiento más poderoso de la naturaleza.",
    "ca": "La pàgina en blanc de la lluna nova es fusiona amb el renaixement explosiu de la primavera. Mentre el foc d''Aries inicia l''any nou astrològic (21 de març), les teves intencions apassionades s''alineen amb l''impuls de creixement més poderós de la naturalesa."
  }'::jsonb,
  '{
    "en": "Fire''s initiative energy is supercharged by spring''s renewal force. This is the most potent time of year for brave new beginnings - the maiden''s fresh courage meets the warrior''s bold action.",
    "es": "La energía de iniciativa del fuego se supercarga con la fuerza de renovación de la primavera. Este es el momento más potente del año para nuevos comienzos valientes - el coraje fresco de la doncella se encuentra con la acción audaz del guerrero.",
    "ca": "L''energia d''iniciativa del foc se supercarrega amb la força de renovació de la primavera. Aquest és el moment més potent de l''any per nous començaments valents - el coratge fresc de la donzella es troba amb l''acció audaç del guerrer."
  }'::jsonb,
  '{
    "en": ["Aries courage", "Spring renewal", "Seedtime boldness", "Maiden warrior energy"],
    "es": ["Coraje de Aries", "Renovación primaveral", "Audacia de siembra", "Energía de doncella guerrera"],
    "ca": ["Coratge d''Aries", "Renovació primaveral", "Audàcia de sembra", "Energia de donzella guerrera"]
  }'::jsonb,
  '{
    "en": ["Plant seeds (literal or metaphorical) with fierce intention", "Start that project you''ve been too afraid to begin", "Take the first courageous step aligned with spring''s push", "Declare bold visions as nature declares new life"],
    "es": ["Planta semillas (literales o metafóricas) con intención feroz", "Comienza ese proyecto que has temido iniciar", "Da el primer paso valiente alineado con el impulso primaveral", "Declara visiones audaces mientras la naturaleza declara nueva vida"],
    "ca": ["Planta llavors (literals o metafòriques) amb intenció ferotge", "Comença aquest projecte que has tingut por d''iniciar", "Fes el primer pas valent alineat amb l''impuls primaveral", "Declara visions audaces mentre la naturalesa declara nova vida"]
  }'::jsonb
);

-- Summer: Creative Heat - Passionate Incubation
INSERT INTO seasonal_overlays (
  template_id,
  season,
  overlay_headline,
  overlay_description,
  energy_shift,
  themes,
  seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'new_moon' AND element = 'fire' AND priority = 1 LIMIT 1),
  'summer',
  '{
    "en": "Summer Incubates Passionate Seeds",
    "es": "El Verano Incuba Semillas Apasionadas",
    "ca": "L''Estiu Incuba Llavors Apassionades"
  }'::jsonb,
  '{
    "en": "The new moon''s introspective planting meets summer''s peak creative heat. Under Cancer''s nurturing fire and Leo''s radiant expression, your passionate intentions gestate in maximum warmth and light.",
    "es": "La siembra introspectiva de la luna nueva se encuentra con el calor creativo máximo del verano. Bajo el fuego nutridor de Cáncer y la expresión radiante de Leo, tus intenciones apasionadas gestan en máximo calor y luz.",
    "ca": "La sembra introspectiva de la lluna nova es troba amb la calor creativa màxima de l''estiu. Sota el foc nodridor de Càncer i l''expressió radiant de Leo, les teves intencions apassionades gesten en màxim calor i llum."
  }'::jsonb,
  '{
    "en": "Fire''s passion is amplified by summer''s abundance of light. Your creative intentions have maximum fuel - like planting in the richest, warmest soil. The mother''s nurturing combines with the creator''s full expression.",
    "es": "La pasión del fuego se amplifica con la abundancia de luz del verano. Tus intenciones creativas tienen combustible máximo - como plantar en el suelo más rico y cálido. La nutrición de la madre se combina con la expresión plena del creador.",
    "ca": "La passió del foc s''amplifica amb l''abundància de llum de l''estiu. Les teves intencions creatives tenen combustible màxim - com plantar en el sòl més ric i càlid. La nutrició de la mare es combina amb l''expressió plena del creador."
  }'::jsonb,
  '{
    "en": ["Creative incubation", "Peak vitality", "Passionate nurturing", "Solar power"],
    "es": ["Incubación creativa", "Vitalidad máxima", "Nutrición apasionada", "Poder solar"],
    "ca": ["Incubació creativa", "Vitalitat màxima", "Nutrició apassionada", "Poder solar"]
  }'::jsonb,
  '{
    "en": ["Set creative intentions to express at summer''s peak", "Plant passionate projects that will bloom in full light", "Nurture your vital energy as you plant new seeds", "Bask in summer sun while declaring bold visions"],
    "es": ["Establece intenciones creativas para expresar en el pico del verano", "Planta proyectos apasionados que florecerán en plena luz", "Nutre tu energía vital mientras plantas nuevas semillas", "Disfruta del sol de verano mientras declaras visiones audaces"],
    "ca": ["Estableix intencions creatives per expressar al pic de l''estiu", "Planta projectes apassionats que floriran en plena llum", "Nodreix la teva energia vital mentre plantes noves llavors", "Gaudeix del sol d''estiu mentre declares visions audaces"]
  }'::jsonb
);

-- Autumn: Strategic Fire - Harvest Preparation
INSERT INTO seasonal_overlays (
  template_id,
  season,
  overlay_headline,
  overlay_description,
  energy_shift,
  themes,
  seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'new_moon' AND element = 'fire' AND priority = 1 LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Plants Seeds for Future Harvest",
    "es": "El Otoño Planta Semillas para Futura Cosecha",
    "ca": "La Tardor Planta Llavors per Futura Collita"
  }'::jsonb,
  '{
    "en": "The new moon''s intention-setting meets autumn''s preparation wisdom. As Libra seeks balance and Scorpio transforms deeply, your passionate seeds are planted with the crone''s strategic foresight for what will be harvested later.",
    "es": "El establecimiento de intenciones de la luna nueva se encuentra con la sabiduría de preparación del otoño. Mientras Libra busca equilibrio y Escorpio transforma profundamente, tus semillas apasionadas se plantan con la previsión estratégica de la anciana para lo que se cosechará después.",
    "ca": "L''establiment d''intencions de la lluna nova es troba amb la saviesa de preparació de la tardor. Mentre Balança cerca equilibri i Escorpi transforma profundament, les teves llavors apassionades es planten amb la previsió estratègica de l''àvia per al que es colirà després."
  }'::jsonb,
  '{
    "en": "Fire''s initiative is tempered by autumn''s wisdom. You plant not with spring''s wild hope, but with the crone''s knowing - these seeds will sleep through winter and germinate when ready. Strategic passion replaces impulsive action.",
    "es": "La iniciativa del fuego se templa con la sabiduría del otoño. No plantas con la esperanza salvaje de la primavera, sino con el conocimiento de la anciana - estas semillas dormirán durante el invierno y germinarán cuando estén listas. La pasión estratégica reemplaza la acción impulsiva.",
    "ca": "La iniciativa del foc es tempera amb la saviesa de la tardor. No plantes amb l''esperança salvatge de la primavera, sinó amb el coneixement de l''àvia - aquestes llavors dormiran durant l''hivern i germinaran quan estiguin llestes. La passió estratègica reemplaça l''acció impulsiva."
  }'::jsonb,
  '{
    "en": ["Strategic intention", "Harvest wisdom", "Balanced passion", "Transformative planning"],
    "es": ["Intención estratégica", "Sabiduría de cosecha", "Pasión equilibrada", "Planificación transformadora"],
    "ca": ["Intenció estratègica", "Saviesa de collita", "Passió equilibrada", "Planificació transformadora"]
  }'::jsonb,
  '{
    "en": ["Set intentions for what you want to harvest next year", "Plant passion projects with autumn''s strategic wisdom", "Balance bold action with preparation for leaner times", "Transform raw passion into mature planning"],
    "es": ["Establece intenciones para lo que quieres cosechar el próximo año", "Planta proyectos apasionados con la sabiduría estratégica del otoño", "Equilibra acción audaz con preparación para tiempos más difíciles", "Transforma pasión cruda en planificación madura"],
    "ca": ["Estableix intencions per al que vols collir l''any que ve", "Planta projectes apassionats amb la saviesa estratègica de la tardor", "Equilibra acció audaç amb preparació per temps més difícils", "Transforma passió crua en planificació madura"]
  }'::jsonb
);

-- Winter: Inner Flame - Hope in Darkness
INSERT INTO seasonal_overlays (
  template_id,
  season,
  overlay_headline,
  overlay_description,
  energy_shift,
  themes,
  seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'new_moon' AND element = 'fire' AND priority = 1 LIMIT 1),
  'winter',
  '{
    "en": "Winter''s Inner Flame Sparks Hope",
    "es": "La Llama Interior del Invierno Enciende Esperanza",
    "ca": "La Flama Interior de l''Hivern Encén Esperança"
  }'::jsonb,
  '{
    "en": "The new moon''s darkness meets winter''s deepest night. As Capricorn builds inner structure and Aquarius visions the future, your passionate flame becomes a candle of hope in maximum darkness - the elder''s eternal fire that never dies.",
    "es": "La oscuridad de la luna nueva se encuentra con la noche más profunda del invierno. Mientras Capricornio construye estructura interior y Acuario visiona el futuro, tu llama apasionada se convierte en una vela de esperanza en máxima oscuridad - el fuego eterno del anciano que nunca muere.",
    "ca": "La foscor de la lluna nova es troba amb la nit més profunda de l''hivern. Mentre Capricorn construeix estructura interior i Aquari visiona el futur, la teva flama apassionada es converteix en una espelma d''esperança en màxima foscor - el foc etern de l''ancià que mai no mor."
  }'::jsonb,
  '{
    "en": "Fire''s heat provides crucial warmth in winter''s cold. Your intentions are not planted in soil, but kept alive as inner flame during the season of death. This is faith - nurturing passion when nothing seems to grow. The seed incubates in darkness.",
    "es": "El calor del fuego proporciona calor crucial en el frío del invierno. Tus intenciones no se plantan en tierra, sino que se mantienen vivas como llama interior durante la estación de muerte. Esto es fe - nutrir pasión cuando nada parece crecer. La semilla incuba en oscuridad.",
    "ca": "La calor del foc proporciona calor crucial en el fred de l''hivern. Les teves intencions no es planten en terra, sinó que es mantenen vives com a flama interior durant l''estació de mort. Això és fe - nodrir passió quan res sembla créixer. La llavor incuba en foscor."
  }'::jsonb,
  '{
    "en": ["Inner warmth", "Faith in darkness", "Eternal flame", "Patient incubation"],
    "es": ["Calor interior", "Fe en la oscuridad", "Llama eterna", "Incubación paciente"],
    "ca": ["Calor interior", "Fe en la foscor", "Flama eterna", "Incubació pacient"]
  }'::jsonb,
  '{
    "en": ["Nurture your inner flame through winter''s darkness", "Set intentions knowing they will sleep until spring", "Light candles as symbols of hope in the dark", "Trust that your passion survives even when invisible"],
    "es": ["Nutre tu llama interior a través de la oscuridad del invierno", "Establece intenciones sabiendo que dormirán hasta la primavera", "Enciende velas como símbolos de esperanza en la oscuridad", "Confía en que tu pasión sobrevive incluso cuando es invisible"],
    "ca": ["Nodreix la teva flama interior a través de la foscor de l''hivern", "Estableix intencions sabent que dormiran fins la primavera", "Encén espelmes com a símbols d''esperança en la foscor", "Confia que la teva passió sobreviu fins i tot quan és invisible"]
  }'::jsonb
);

-- =====================================================
-- NEW MOON + EARTH (4 seasonal variations)
-- =====================================================

-- Spring: Fertile Soil - Perfect Planting Time
INSERT INTO seasonal_overlays (
  template_id,
  season,
  overlay_headline,
  overlay_description,
  energy_shift,
  themes,
  seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'new_moon' AND element = 'earth' AND priority = 1 LIMIT 1),
  'spring',
  '{
    "en": "Spring''s Fertile Earth Welcomes Seeds",
    "es": "La Tierra Fértil de Primavera Recibe Semillas",
    "ca": "La Terra Fèrtil de Primavera Rep Llavors"
  }'::jsonb,
  '{
    "en": "The new moon''s grounding intention meets spring''s perfectly fertile soil. As Taurus brings material manifestation power (April-May), your practical plans have ideal conditions to root deeply and grow strong.",
    "es": "La intención arraigadora de la luna nueva se encuentra con el suelo perfectamente fértil de la primavera. Mientras Tauro trae poder de manifestación material (abril-mayo), tus planes prácticos tienen condiciones ideales para arraigar profundamente y crecer fuertes.",
    "ca": "La intenció arreladora de la lluna nova es troba amb el sòl perfectament fèrtil de la primavera. Mentre Taure porta poder de manifestació material (abril-maig), els teus plans pràctics tenen condicions ideals per arrelar profundament i créixer forts."
  }'::jsonb,
  '{
    "en": "Earth''s stability is supercharged by spring''s growth force. This is THE optimal time for material manifestation - rich soil, perfect temperature, abundant moisture. What you plant now has nature''s full support to become real and tangible.",
    "es": "La estabilidad de la tierra se supercarga con la fuerza de crecimiento de la primavera. Este es EL momento óptimo para manifestación material - suelo rico, temperatura perfecta, humedad abundante. Lo que plantas ahora tiene el apoyo completo de la naturaleza para hacerse real y tangible.",
    "ca": "L''estabilitat de la terra se supercarrega amb la força de creixement de la primavera. Aquest és EL moment òptim per manifestació material - sòl ric, temperatura perfecta, humitat abundant. El que plantes ara té el suport complet de la naturalesa per fer-se real i tangible."
  }'::jsonb,
  '{
    "en": ["Perfect conditions", "Material manifestation", "Taurus abundance", "Rooted growth"],
    "es": ["Condiciones perfectas", "Manifestación material", "Abundancia de Tauro", "Crecimiento arraigado"],
    "ca": ["Condicions perfectes", "Manifestació material", "Abundància de Taure", "Creixement arrelat"]
  }'::jsonb,
  '{
    "en": ["Plant actual seeds or start a garden NOW", "Set material goals (financial, physical) with spring''s support", "Create realistic plans knowing conditions favor manifestation", "Ground intentions in physical action aligned with nature"],
    "es": ["Planta semillas reales o comienza un jardín AHORA", "Establece metas materiales (financieras, físicas) con el apoyo de la primavera", "Crea planes realistas sabiendo que las condiciones favorecen la manifestación", "Arraiga intenciones en acción física alineada con la naturaleza"],
    "ca": ["Planta llavors reals o comença un jardí ARA", "Estableix objectius materials (financers, físics) amb el suport de la primavera", "Crea plans realistes sabent que les condicions afavoreixen la manifestació", "Arrel intencions en acció física alineada amb la naturalesa"]
  }'::jsonb
);

-- Summer: Grounded Abundance - Material Fullness
INSERT INTO seasonal_overlays (
  template_id,
  season,
  overlay_headline,
  overlay_description,
  energy_shift,
  themes,
  seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'new_moon' AND element = 'earth' AND priority = 1 LIMIT 1),
  'summer',
  '{
    "en": "Summer''s Abundance Grounds New Foundations",
    "es": "La Abundancia del Verano Fundamenta Nuevas Bases",
    "ca": "L''Abundància de l''Estiu Fonament Noves Bases"
  }'::jsonb,
  '{
    "en": "The new moon''s practical planning meets summer''s peak material abundance. Under Virgo''s harvest eye (August-September), your grounded intentions can draw from maximum physical resources and earthly support.",
    "es": "La planificación práctica de la luna nueva se encuentra con la abundancia material máxima del verano. Bajo el ojo de cosecha de Virgo (agosto-septiembre), tus intenciones arraigadas pueden extraer de máximos recursos físicos y apoyo terrenal.",
    "ca": "La planificació pràctica de la lluna nova es troba amb l''abundància material màxima de l''estiu. Sota l''ull de collita de Verge (agost-setembre), les teves intencions arrelades poden extreure de màxims recursos físics i suport terrenal."
  }'::jsonb,
  '{
    "en": "Earth''s resources are at maximum availability in summer. You plant with the security of plenty - abundant food, warmth, light. Your material plans have cushioning and safety. The mother''s generous provision supports practical foundations.",
    "es": "Los recursos de la tierra están en máxima disponibilidad en verano. Plantas con la seguridad de la abundancia - comida abundante, calor, luz. Tus planes materiales tienen amortiguación y seguridad. La provisión generosa de la madre apoya fundamentos prácticos.",
    "ca": "Els recursos de la terra estan en màxima disponibilitat a l''estiu. Plantes amb la seguretat de l''abundància - menjar abundant, calor, llum. Els teus plans materials tenen amortiment i seguretat. La provisió generosa de la mare dóna suport a fonaments pràctics."
  }'::jsonb,
  '{
    "en": ["Material security", "Virgo precision", "Abundant resources", "Practical plenty"],
    "es": ["Seguridad material", "Precisión de Virgo", "Recursos abundantes", "Abundancia práctica"],
    "ca": ["Seguretat material", "Precisió de Verge", "Recursos abundants", "Abundància pràctica"]
  }'::jsonb,
  '{
    "en": ["Set financial goals with summer''s abundance mentality", "Start practical projects knowing resources are plentiful", "Plan material foundations from a place of plenty, not scarcity", "Ground intentions in summer''s generous earth"],
    "es": ["Establece metas financieras con mentalidad de abundancia del verano", "Inicia proyectos prácticos sabiendo que los recursos son abundantes", "Planifica fundamentos materiales desde un lugar de abundancia, no escasez", "Arraiga intenciones en la tierra generosa del verano"],
    "ca": ["Estableix objectius financers amb mentalitat d''abundància de l''estiu", "Inicia projectes pràctics sabent que els recursos són abundants", "Planifica fonaments materials des d''un lloc d''abundància, no escassetat", "Arrel intencions en la terra generosa de l''estiu"]
  }'::jsonb
);

-- Autumn: Harvest Planning - Strategic Grounding
INSERT INTO seasonal_overlays (
  template_id,
  season,
  overlay_headline,
  overlay_description,
  energy_shift,
  themes,
  seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'new_moon' AND element = 'earth' AND priority = 1 LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Plans Material Harvest",
    "es": "El Otoño Planifica Cosecha Material",
    "ca": "La Tardor Planifica Collita Material"
  }'::jsonb,
  '{
    "en": "The new moon''s grounding meets autumn''s harvest wisdom. As seasons prepare for scarcity, your material intentions become strategic storage plans - what physical resources and structures will sustain you through lean times?",
    "es": "El arraigo de la luna nueva se encuentra con la sabiduría de cosecha del otoño. Mientras las estaciones se preparan para la escasez, tus intenciones materiales se convierten en planes estratégicos de almacenamiento - ¿qué recursos físicos y estructuras te sostendrán en tiempos difíciles?",
    "ca": "L''arrelament de la lluna nova es troba amb la saviesa de collita de la tardor. Mentre les estacions es preparen per l''escassetat, les teves intencions materials es converteixen en plans estratègics d''emmagatzematge - quins recursos físics i estructures et sostindran en temps difícils?"
  }'::jsonb,
  '{
    "en": "Earth''s practicality becomes preparation for winter. You don''t plant for immediate growth, but for storage, preservation, and long-term security. The crone''s wisdom knows: save now, survive later. Material planning shifts from abundance to sustainability.",
    "es": "La practicidad de la tierra se convierte en preparación para el invierno. No plantas para crecimiento inmediato, sino para almacenamiento, preservación y seguridad a largo plazo. La sabiduría de la anciana sabe: ahorra ahora, sobrevive después. La planificación material cambia de abundancia a sostenibilidad.",
    "ca": "La practicitat de la terra es converteix en preparació per l''hivern. No plantes per creixement immediat, sinó per emmagatzematge, preservació i seguretat a llarg termini. La saviesa de l''àvia sap: estalvia ara, sobreviu després. La planificació material canvia d''abundància a sostenibilitat."
  }'::jsonb,
  '{
    "en": ["Strategic storage", "Material preparation", "Sustainable planning", "Resource preservation"],
    "es": ["Almacenamiento estratégico", "Preparación material", "Planificación sostenible", "Preservación de recursos"],
    "ca": ["Emmagatzematge estratègic", "Preparació material", "Planificació sostenible", "Preservació de recursos"]
  }'::jsonb,
  '{
    "en": ["Plan how to preserve and store resources", "Set financial goals for long-term security", "Create sustainable material structures", "Prepare practical foundations for leaner times ahead"],
    "es": ["Planifica cómo preservar y almacenar recursos", "Establece metas financieras para seguridad a largo plazo", "Crea estructuras materiales sostenibles", "Prepara fundamentos prácticos para tiempos más difíciles por venir"],
    "ca": ["Planifica com preservar i emmagatzemar recursos", "Estableix objectius financers per seguretat a llarg termini", "Crea estructures materials sostenibles", "Prepara fonaments pràctics per temps més difícils per venir"]
  }'::jsonb
);

-- Winter: Deep Roots - Structure in Stillness
INSERT INTO seasonal_overlays (
  template_id,
  season,
  overlay_headline,
  overlay_description,
  energy_shift,
  themes,
  seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'new_moon' AND element = 'earth' AND priority = 1 LIMIT 1),
  'winter',
  '{
    "en": "Winter''s Deep Roots Build Inner Structure",
    "es": "Las Raíces Profundas del Invierno Construyen Estructura Interior",
    "ca": "Les Arrels Profundes de l''Hivern Construeixen Estructura Interior"
  }'::jsonb,
  '{
    "en": "The new moon''s foundation-building meets winter''s deepest grounding. As Capricorn constructs inner architecture (December-January), your material intentions become skeletal structures that will support all future growth - bones, not flesh.",
    "es": "La construcción de fundamentos de la luna nueva se encuentra con el arraigo más profundo del invierno. Mientras Capricornio construye arquitectura interior (diciembre-enero), tus intenciones materiales se convierten en estructuras esqueléticas que apoyarán todo crecimiento futuro - huesos, no carne.",
    "ca": "La construcció de fonaments de la lluna nova es troba amb l''arrelament més profund de l''hivern. Mentre Capricorn construeix arquitectura interior (desembre-gener), les teves intencions materials es converteixen en estructures esquelètiques que donaran suport a tot creixement futur - ossos, no carn."
  }'::jsonb,
  '{
    "en": "Earth reaches maximum depth in winter. Your practical plans go underground like tree roots, invisible but essential. You''re building skeletal structure, foundation, bedrock - not surface growth. The elder knows: strong bones support everything.",
    "es": "La tierra alcanza máxima profundidad en invierno. Tus planes prácticos van bajo tierra como raíces de árbol, invisibles pero esenciales. Estás construyendo estructura esquelética, fundamento, roca madre - no crecimiento superficial. El anciano sabe: huesos fuertes sostienen todo.",
    "ca": "La terra arriba a màxima profunditat a l''hivern. Els teus plans pràctics van sota terra com arrels d''arbre, invisibles però essencials. Estàs construint estructura esquelètica, fonament, roca mare - no creixement superficial. L''ancià sap: ossos forts sostenen tot."
  }'::jsonb,
  '{
    "en": ["Deep foundation", "Skeletal structure", "Capricorn discipline", "Invisible bedrock"],
    "es": ["Fundamento profundo", "Estructura esquelética", "Disciplina de Capricornio", "Roca madre invisible"],
    "ca": ["Fonament profund", "Estructura esquelètica", "Disciplina de Capricorn", "Roca mare invisible"]
  }'::jsonb,
  '{
    "en": ["Build foundational structures that will support future growth", "Set long-term material goals with Capricorn discipline", "Create invisible support systems (savings, health routines)", "Trust deep work that shows no immediate results"],
    "es": ["Construye estructuras fundamentales que apoyarán crecimiento futuro", "Establece metas materiales a largo plazo con disciplina de Capricornio", "Crea sistemas de apoyo invisibles (ahorros, rutinas de salud)", "Confía en trabajo profundo que no muestra resultados inmediatos"],
    "ca": ["Construeix estructures fonamentals que donaran suport a creixement futur", "Estableix objectius materials a llarg termini amb disciplina de Capricorn", "Crea sistemes de suport invisibles (estalvis, rutines de salut)", "Confia en treball profund que no mostra resultats immediats"]
  }'::jsonb
);

-- =====================================================
-- NEW MOON + AIR (4 seasonal variations)
-- =====================================================

-- Spring: Fresh Ideas - Mental Renewal
INSERT INTO seasonal_overlays (
  template_id,
  season,
  overlay_headline,
  overlay_description,
  energy_shift,
  themes,
  seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'new_moon' AND element = 'air' AND priority = 1 LIMIT 1),
  'spring',
  '{
    "en": "Spring Breathes Fresh Ideas to Life",
    "es": "La Primavera Respira Nuevas Ideas a la Vida",
    "ca": "La Primavera Respira Noves Idees a la Vida"
  }'::jsonb,
  '{
    "en": "The new moon''s mental clarity meets spring''s renewal of perspective. As Gemini brings communicative curiosity (May-June), your fresh ideas ride on spring winds of change and new learning.",
    "es": "La claridad mental de la luna nueva se encuentra con la renovación de perspectiva de la primavera. Mientras Géminis trae curiosidad comunicativa (mayo-junio), tus ideas frescas cabalgan en vientos primaverales de cambio y nuevo aprendizaje.",
    "ca": "La claredat mental de la lluna nova es troba amb la renovació de perspectiva de la primavera. Mentre Bessons porta curiositat comunicativa (maig-juny), les teves idees fresques cavalquen en vents primaverals de canvi i nou aprenentatge."
  }'::jsonb,
  '{
    "en": "Air''s mental agility is refreshed by spring''s new growth energy. Your mind opens like flowers bloom - fresh perspectives, novel concepts, renewed curiosity. The maiden''s innocent wonder meets the scholar''s eager learning.",
    "es": "La agilidad mental del aire se refresca con la energía de nuevo crecimiento de la primavera. Tu mente se abre como florecen las flores - perspectivas frescas, conceptos novedosos, curiosidad renovada. El asombro inocente de la doncella se encuentra con el aprendizaje ansioso del erudito.",
    "ca": "L''agilitat mental de l''aire es refresca amb l''energia de nou creixement de la primavera. La teva ment s''obre com floreixen les flors - perspectives fresques, conceptes nous, curiositat renovada. L''asombro innocent de la donzella es troba amb l''aprenentatge ansiós de l''erudit."
  }'::jsonb,
  '{
    "en": ["Mental renewal", "Gemini curiosity", "Fresh perspectives", "Learning energy"],
    "es": ["Renovación mental", "Curiosidad de Géminis", "Perspectivas frescas", "Energía de aprendizaje"],
    "ca": ["Renovació mental", "Curiositat de Bessons", "Perspectives fresques", "Energia d''aprenentatge"]
  }'::jsonb,
  '{
    "en": ["Start learning something completely new", "Set intentions for communication or study", "Open your mind to fresh perspectives aligned with spring''s renewal", "Begin writing or teaching projects with spring''s fresh energy"],
    "es": ["Comienza a aprender algo completamente nuevo", "Establece intenciones de comunicación o estudio", "Abre tu mente a perspectivas frescas alineadas con la renovación de primavera", "Comienza proyectos de escritura o enseñanza con energía fresca de primavera"],
    "ca": ["Comença a aprendre alguna cosa completament nova", "Estableix intencions de comunicació o estudi", "Obre la teva ment a perspectives fresques alineades amb la renovació de primavera", "Comença projectes d''escriptura o ensenyament amb energia fresca de primavera"]
  }'::jsonb
);

-- Summer: Mental Brilliance - Peak Clarity
INSERT INTO seasonal_overlays (
  template_id,
  season,
  overlay_headline,
  overlay_description,
  energy_shift,
  themes,
  seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'new_moon' AND element = 'air' AND priority = 1 LIMIT 1),
  'summer',
  '{
    "en": "Summer''s Mental Brilliance Illuminates Ideas",
    "es": "El Brillo Mental del Verano Ilumina Ideas",
    "ca": "El Brillantor Mental de l''Estiu Il·lumina Idees"
  }'::jsonb,
  '{
    "en": "The new moon''s idea generation meets summer''s peak mental clarity. Under maximum light, your intellectual intentions have optimal visibility and expression - ideas shine bright like the noon sun.",
    "es": "La generación de ideas de la luna nueva se encuentra con la claridad mental máxima del verano. Bajo luz máxima, tus intenciones intelectuales tienen visibilidad y expresión óptimas - las ideas brillan intensamente como el sol del mediodía.",
    "ca": "La generació d''idees de la lluna nova es troba amb la claredat mental màxima de l''estiu. Sota llum màxima, les teves intencions intel·lectuals tenen visibilitat i expressió òptimes - les idees brillen intensament com el sol del migdia."
  }'::jsonb,
  '{
    "en": "Air''s clarity reaches maximum brilliance in summer''s light. Your thoughts have laser focus, ideas crystallize with precision. The mother''s nurturing intelligence meets peak expressive power. Mental work benefits from abundant light and warmth.",
    "es": "La claridad del aire alcanza máximo brillo en la luz del verano. Tus pensamientos tienen enfoque láser, las ideas cristalizan con precisión. La inteligencia nutritiva de la madre se encuentra con poder expresivo máximo. El trabajo mental se beneficia de luz y calor abundantes.",
    "ca": "La claredat de l''aire arriba a màxim brillantor en la llum de l''estiu. Els teus pensaments tenen enfocament làser, les idees cristal·litzen amb precisió. La intel·ligència nutritiva de la mare es troba amb poder expressiu màxim. El treball mental es beneficia de llum i calor abundants."
  }'::jsonb,
  '{
    "en": ["Peak clarity", "Brilliant ideas", "Mental expression", "Maximum visibility"],
    "es": ["Claridad máxima", "Ideas brillantes", "Expresión mental", "Visibilidad máxima"],
    "ca": ["Claredat màxima", "Idees brillants", "Expressió mental", "Visibilitat màxima"]
  }'::jsonb,
  '{
    "en": ["Set clear, brilliant intellectual goals", "Start projects requiring maximum mental clarity", "Express ideas with summer''s confident voice", "Plan communication that will shine in full light"],
    "es": ["Establece metas intelectuales claras y brillantes", "Inicia proyectos que requieren máxima claridad mental", "Expresa ideas con voz confiada del verano", "Planifica comunicación que brillará en plena luz"],
    "ca": ["Estableix objectius intel·lectuals clars i brillants", "Inicia projectes que requereixen màxima claredat mental", "Expressa idees amb veu confiada de l''estiu", "Planifica comunicació que brillarà en plena llum"]
  }'::jsonb
);

-- Autumn: Balanced Thought - Intellectual Harvest
INSERT INTO seasonal_overlays (
  template_id,
  season,
  overlay_headline,
  overlay_description,
  energy_shift,
  themes,
  seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'new_moon' AND element = 'air' AND priority = 1 LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Balances New Mental Perspectives",
    "es": "El Otoño Equilibra Nuevas Perspectivas Mentales",
    "ca": "La Tardor Equilibra Noves Perspectives Mentals"
  }'::jsonb,
  '{
    "en": "The new moon''s fresh thinking meets autumn''s balanced wisdom. As Libra weighs all perspectives (September-October), your intellectual intentions seek equilibrium - not just new ideas, but balanced, fair, harmonious thoughts.",
    "es": "El pensamiento fresco de la luna nueva se encuentra con la sabiduría equilibrada del otoño. Mientras Libra sopesa todas las perspectivas (septiembre-octubre), tus intenciones intelectuales buscan equilibrio - no solo ideas nuevas, sino pensamientos equilibrados, justos, armoniosos.",
    "ca": "El pensament fresc de la lluna nova es troba amb la saviesa equilibrada de la tardor. Mentre Balança sopesa totes les perspectives (setembre-octubre), les teves intencions intel·lectuals cerquen equilibri - no només idees noves, sinó pensaments equilibrats, justos, harmoniosos."
  }'::jsonb,
  '{
    "en": "Air''s intellectual pursuit becomes balanced by autumn''s wisdom. You plant ideas that consider all sides, all voices, all perspectives. The crone knows: truth lies in balance, not extremes. Mental planning shifts from brilliant singularity to harmonious plurality.",
    "es": "La búsqueda intelectual del aire se equilibra con la sabiduría del otoño. Plantas ideas que consideran todos los lados, todas las voces, todas las perspectivas. La anciana sabe: la verdad yace en el equilibrio, no en extremos. La planificación mental cambia de singularidad brillante a pluralidad armoniosa.",
    "ca": "La cerca intel·lectual de l''aire s''equilibra amb la saviesa de la tardor. Plantes idees que consideren tots els costats, totes les veus, totes les perspectives. L''àvia sap: la veritat jeu en l''equilibri, no en extrems. La planificació mental canvia de singularitat brillant a pluralitat harmoniosa."
  }'::jsonb,
  '{
    "en": ["Balanced thinking", "Libra fairness", "Multiple perspectives", "Harmonious ideas"],
    "es": ["Pensamiento equilibrado", "Justicia de Libra", "Múltiples perspectivas", "Ideas armoniosas"],
    "ca": ["Pensament equilibrat", "Justícia de Balança", "Múltiples perspectives", "Idees harmonioses"]
  }'::jsonb,
  '{
    "en": ["Set intentions to understand all perspectives", "Plan communication that bridges divides", "Study subjects from multiple angles", "Seek balanced, fair intellectual approaches"],
    "es": ["Establece intenciones de entender todas las perspectivas", "Planifica comunicación que una divisiones", "Estudia temas desde múltiples ángulos", "Busca enfoques intelectuales equilibrados y justos"],
    "ca": ["Estableix intencions d''entendre totes les perspectives", "Planifica comunicació que uneixi divisions", "Estudia temes des de múltiples angles", "Cerca enfocaments intel·lectuals equilibrats i justos"]
  }'::jsonb
);

-- Winter: Quiet Mind - Mental Rest
INSERT INTO seasonal_overlays (
  template_id,
  season,
  overlay_headline,
  overlay_description,
  energy_shift,
  themes,
  seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'new_moon' AND element = 'air' AND priority = 1 LIMIT 1),
  'winter',
  '{
    "en": "Winter Quiets the Mind for Renewal",
    "es": "El Invierno Silencia la Mente para Renovación",
    "ca": "L''Hivern Silencia la Ment per Renovació"
  }'::jsonb,
  '{
    "en": "The new moon''s mental stillness meets winter''s deepest quiet. As Aquarius detaches into vision (January-February), your intellectual intentions become spacious, still, and clear as winter air - thoughts like snowflakes, unique and pristine.",
    "es": "La quietud mental de la luna nueva se encuentra con el silencio más profundo del invierno. Mientras Acuario se desapega hacia la visión (enero-febrero), tus intenciones intelectuales se vuelven espaciosas, quietas y claras como aire invernal - pensamientos como copos de nieve, únicos y prístinos.",
    "ca": "La quietud mental de la lluna nova es troba amb el silenci més profund de l''hivern. Mentre Aquari es desapega cap a la visió (gener-febrer), les teves intencions intel·lectuals es tornen espaioses, quietes i clares com aire hivernal - pensaments com flocs de neu, únics i prístins."
  }'::jsonb,
  '{
    "en": "Air becomes crystalline in winter''s cold. Your mind clears like frost-covered glass - sharp, bright, still. Mental intentions focus not on activity but on clarity. The elder''s wisdom knows: sometimes the best thought is no thought. Silence before speech.",
    "es": "El aire se vuelve cristalino en el frío del invierno. Tu mente se aclara como vidrio cubierto de escarcha - afilada, brillante, quieta. Las intenciones mentales se enfocan no en actividad sino en claridad. La sabiduría del anciano sabe: a veces el mejor pensamiento es ningún pensamiento. Silencio antes del habla.",
    "ca": "L''aire es torna cristal·lí en el fred de l''hivern. La teva ment s''aclara com vidre cobert de gebre - afilada, brillant, quieta. Les intencions mentals s''enfoquen no en activitat sinó en claredat. La saviesa de l''ancià sap: de vegades el millor pensament és cap pensament. Silenci abans de la paraula."
  }'::jsonb,
  '{
    "en": ["Mental stillness", "Crystalline clarity", "Aquarius detachment", "Pristine thought"],
    "es": ["Quietud mental", "Claridad cristalina", "Desapego de Acuario", "Pensamiento prístino"],
    "ca": ["Quietud mental", "Claredat cristal·lina", "Desapegament d''Aquari", "Pensament prístin"]
  }'::jsonb,
  '{
    "en": ["Set intentions for mental rest and clarity", "Practice meditation and thought-stillness", "Plan communication from quiet center, not mental noise", "Let ideas crystallize in winter''s silence"],
    "es": ["Establece intenciones de descanso mental y claridad", "Practica meditación y quietud de pensamiento", "Planifica comunicación desde centro tranquilo, no ruido mental", "Deja que ideas cristalicen en silencio invernal"],
    "ca": ["Estableix intencions de descans mental i claredat", "Practica meditació i quietud de pensament", "Planifica comunicació des de centre tranquil, no soroll mental", "Deixa que idees cristal·litzin en silenci hivernal"]
  }'::jsonb
);

-- =====================================================
-- NEW MOON + WATER (4 seasonal variations)
-- =====================================================

-- Spring: Emotional Renewal - Heart Rebirth
INSERT INTO seasonal_overlays (
  template_id,
  season,
  overlay_headline,
  overlay_description,
  energy_shift,
  themes,
  seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'new_moon' AND element = 'water' AND priority = 1 LIMIT 1),
  'spring',
  '{
    "en": "Spring Renews the Emotional Heart",
    "es": "La Primavera Renueva el Corazón Emocional",
    "ca": "La Primavera Renova el Cor Emocional"
  }'::jsonb,
  '{
    "en": "The new moon''s emotional depth meets spring''s renewal of feeling. After winter''s emotional hibernation, your heart awakens like flowers bloom - fresh feelings, renewed capacity for joy, emotional rebirth and innocent wonder.",
    "es": "La profundidad emocional de la luna nueva se encuentra con la renovación de sentimientos de la primavera. Después de la hibernación emocional del invierno, tu corazón despierta como florecen las flores - sentimientos frescos, capacidad renovada de alegría, renacimiento emocional y asombro inocente.",
    "ca": "La profunditat emocional de la lluna nova es troba amb la renovació de sentiments de la primavera. Després de la hibernació emocional de l''hivern, el teu cor desperta com floreixen les flors - sentiments frescos, capacitat renovada d''alegria, renaixement emocional i asombro innocent."
  }'::jsonb,
  '{
    "en": "Water''s emotional flow is refreshed by spring''s renewal. Your heart, frozen or dormant in winter, melts and flows again. The maiden''s innocent heart meets renewed capacity to feel, love, and connect. Emotional intentions bloom like first flowers.",
    "es": "El flujo emocional del agua se refresca con la renovación de la primavera. Tu corazón, congelado o dormido en invierno, se derrite y fluye de nuevo. El corazón inocente de la doncella se encuentra con capacidad renovada de sentir, amar y conectar. Intenciones emocionales florecen como primeras flores.",
    "ca": "El flux emocional de l''aigua es refresca amb la renovació de la primavera. El teu cor, congelat o adormit a l''hivern, es fon i flueix de nou. El cor innocent de la donzella es troba amb capacitat renovada de sentir, estimar i connectar. Intencions emocionals floreixen com primeres flors."
  }'::jsonb,
  '{
    "en": ["Emotional renewal", "Heart awakening", "Fresh feelings", "Innocent joy"],
    "es": ["Renovación emocional", "Despertar del corazón", "Sentimientos frescos", "Alegría inocente"],
    "ca": ["Renovació emocional", "Despertar del cor", "Sentiments frescos", "Alegria innocent"]
  }'::jsonb,
  '{
    "en": ["Set intentions for emotional healing and renewal", "Open your heart after winter''s closure", "Allow yourself to feel fresh joy aligned with spring''s rebirth", "Plant seeds of new emotional connections"],
    "es": ["Establece intenciones de sanación y renovación emocional", "Abre tu corazón después del cierre invernal", "Permítete sentir alegría fresca alineada con el renacimiento primaveral", "Planta semillas de nuevas conexiones emocionales"],
    "ca": ["Estableix intencions de sanació i renovació emocional", "Obre el teu cor després del tancament hivernal", "Permet-te sentir alegria fresca alineada amb el renaixement primaveral", "Planta llavors de noves connexions emocionals"]
  }'::jsonb
);

-- Summer: Emotional Overflow - Heart Fullness
INSERT INTO seasonal_overlays (
  template_id,
  season,
  overlay_headline,
  overlay_description,
  energy_shift,
  themes,
  seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'new_moon' AND element = 'water' AND priority = 1 LIMIT 1),
  'summer',
  '{
    "en": "Summer''s Heart Overflows with Feeling",
    "es": "El Corazón del Verano Desborda de Sentimiento",
    "ca": "El Cor de l''Estiu Desborda de Sentiment"
  }'::jsonb,
  '{
    "en": "The new moon''s emotional intention meets summer''s peak heart capacity. Under Cancer''s nurturing waters (June-July), your feelings have maximum depth, warmth, and generosity - emotional abundance to share and express fully.",
    "es": "La intención emocional de la luna nueva se encuentra con la capacidad máxima del corazón del verano. Bajo las aguas nutritivas de Cáncer (junio-julio), tus sentimientos tienen máxima profundidad, calor y generosidad - abundancia emocional para compartir y expresar plenamente.",
    "ca": "La intenció emocional de la lluna nova es troba amb la capacitat màxima del cor de l''estiu. Sota les aigües nutritives de Càncer (juny-juliol), els teus sentiments tenen màxima profunditat, calor i generositat - abundància emocional per compartir i expressar plenament."
  }'::jsonb,
  '{
    "en": "Water reaches peak emotional fullness in summer. Your heart overflows like a full well - generous, nourishing, abundant. The mother''s loving capacity is at maximum. Emotional intentions focus on sharing, nurturing, expressing the heart''s plenty.",
    "es": "El agua alcanza plenitud emocional máxima en verano. Tu corazón desborda como un pozo lleno - generoso, nutritivo, abundante. La capacidad amorosa de la madre está al máximo. Intenciones emocionales se enfocan en compartir, nutrir, expresar la abundancia del corazón.",
    "ca": "L''aigua arriba a plenitud emocional màxima a l''estiu. El teu cor desborda com un pou ple - generós, nutritiu, abundant. La capacitat amorosa de la mare està al màxim. Intencions emocionals s''enfoquen en compartir, nodrir, expressar l''abundància del cor."
  }'::jsonb,
  '{
    "en": ["Emotional abundance", "Cancer nurturing", "Heart overflow", "Generous feelings"],
    "es": ["Abundancia emocional", "Nutrición de Cáncer", "Desbordamiento del corazón", "Sentimientos generosos"],
    "ca": ["Abundància emocional", "Nutrició de Càncer", "Desbordament del cor", "Sentiments generosos"]
  }'::jsonb,
  '{
    "en": ["Set intentions to share emotional abundance", "Plan acts of nurturing and care", "Express feelings with summer''s generous heart", "Allow your emotions to overflow and nourish others"],
    "es": ["Establece intenciones de compartir abundancia emocional", "Planifica actos de nutrición y cuidado", "Expresa sentimientos con corazón generoso del verano", "Permite que tus emociones desborden y nutran a otros"],
    "ca": ["Estableix intencions de compartir abundància emocional", "Planifica actes de nutrició i cura", "Expressa sentiments amb cor generós de l''estiu", "Permet que les teves emocions desbordin i nodreixin altres"]
  }'::jsonb
);

-- Autumn: Emotional Wisdom - Heart Maturity
INSERT INTO seasonal_overlays (
  template_id,
  season,
  overlay_headline,
  overlay_description,
  energy_shift,
  themes,
  seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'new_moon' AND element = 'water' AND priority = 1 LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Deepens Emotional Wisdom",
    "es": "El Otoño Profundiza Sabiduría Emocional",
    "ca": "La Tardor Profunditza Saviesa Emocional"
  }'::jsonb,
  '{
    "en": "The new moon''s intuitive intention meets autumn''s emotional maturity. As Scorpio dives into psychic depths (October-November), your heart''s intentions become wise, transformative, and profound - not innocent joy, but mature understanding.",
    "es": "La intención intuitiva de la luna nueva se encuentra con la madurez emocional del otoño. Mientras Escorpio se sumerge en profundidades psíquicas (octubre-noviembre), las intenciones de tu corazón se vuelven sabias, transformadoras y profundas - no alegría inocente, sino comprensión madura.",
    "ca": "La intenció intuïtiva de la lluna nova es troba amb la maduresa emocional de la tardor. Mentre Escorpi es submergeix en profunditats psíquiques (octubre-novembre), les intencions del teu cor es tornen sàvies, transformadores i profundes - no alegria innocent, sinó comprensió madura."
  }'::jsonb,
  '{
    "en": "Water deepens into Scorpio''s transformative abyss. Emotional intentions become about shadow work, deep healing, psychic transformation. The crone''s wise heart knows: true feeling includes pain, loss, death. Emotional maturity replaces innocent overflow.",
    "es": "El agua se profundiza en el abismo transformador de Escorpio. Intenciones emocionales se vuelven sobre trabajo de sombra, sanación profunda, transformación psíquica. El corazón sabio de la anciana sabe: sentimiento verdadero incluye dolor, pérdida, muerte. Madurez emocional reemplaza desbordamiento inocente.",
    "ca": "L''aigua es profunditza en l''abisme transformador d''Escorpi. Intencions emocionals es tornen sobre treball d''ombra, sanació profunda, transformació psíquica. El cor savi de l''àvia sap: sentiment veritable inclou dolor, pèrdua, mort. Maduresa emocional reemplaça desbordament innocent."
  }'::jsonb,
  '{
    "en": ["Emotional depth", "Scorpio transformation", "Shadow wisdom", "Mature feeling"],
    "es": ["Profundidad emocional", "Transformación de Escorpio", "Sabiduría de sombra", "Sentimiento maduro"],
    "ca": ["Profunditat emocional", "Transformació d''Escorpi", "Saviesa d''ombra", "Sentiment madur"]
  }'::jsonb,
  '{
    "en": ["Set intentions for deep emotional transformation", "Plan shadow work and psychic healing", "Embrace all feelings, including painful ones", "Seek emotional wisdom, not just happiness"],
    "es": ["Establece intenciones de transformación emocional profunda", "Planifica trabajo de sombra y sanación psíquica", "Abraza todos los sentimientos, incluidos los dolorosos", "Busca sabiduría emocional, no solo felicidad"],
    "ca": ["Estableix intencions de transformació emocional profunda", "Planifica treball d''ombra i sanació psíquica", "Abraça tots els sentiments, inclosos els dolorosos", "Cerca saviesa emocional, no només felicitat"]
  }'::jsonb
);

-- Winter: Deep Waters - Emotional Mystery
INSERT INTO seasonal_overlays (
  template_id,
  season,
  overlay_headline,
  overlay_description,
  energy_shift,
  themes,
  seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'new_moon' AND element = 'water' AND priority = 1 LIMIT 1),
  'winter',
  '{
    "en": "Winter''s Deep Waters Hold Sacred Mystery",
    "es": "Las Aguas Profundas del Invierno Contienen Misterio Sagrado",
    "ca": "Les Aigües Profundes de l''Hivern Contenen Misteri Sagrat"
  }'::jsonb,
  '{
    "en": "The new moon''s emotional depth meets winter''s most mysterious waters. As Pisces dissolves into mystical union (February-March), your heart''s intentions become spiritual, boundaryless, and transcendent - merging with the cosmic ocean of feeling.",
    "es": "La profundidad emocional de la luna nueva se encuentra con las aguas más misteriosas del invierno. Mientras Piscis se disuelve en unión mística (febrero-marzo), las intenciones de tu corazón se vuelven espirituales, sin límites y trascendentes - fusionándose con el océano cósmico de sentimiento.",
    "ca": "La profunditat emocional de la lluna nova es troba amb les aigües més misterioses de l''hivern. Mentre Peixos es dissol en unió mística (febrer-març), les intencions del teu cor es tornen espirituals, sense límits i transcendents - fusionant-se amb l''oceà còsmic de sentiment."
  }'::jsonb,
  '{
    "en": "Water becomes mystical in winter''s depths. Emotions dissolve into spiritual connection, psychic intuition, cosmic compassion. The elder''s heart knows no boundaries - all suffering is one, all love interconnected. Emotional intentions transcend individual feeling into universal heart.",
    "es": "El agua se vuelve mística en las profundidades del invierno. Emociones se disuelven en conexión espiritual, intuición psíquica, compasión cósmica. El corazón del anciano no conoce límites - todo sufrimiento es uno, todo amor interconectado. Intenciones emocionales trascienden sentimiento individual hacia corazón universal.",
    "ca": "L''aigua es torna mística en les profunditats de l''hivern. Emocions es dissolen en connexió espiritual, intuïció psíquica, compassió còsmica. El cor de l''ancià no coneix límits - tot patiment és un, tot amor interconnectat. Intencions emocionals transcendeixen sentiment individual cap a cor universal."
  }'::jsonb,
  '{
    "en": ["Mystical emotion", "Pisces compassion", "Boundaryless heart", "Spiritual feeling"],
    "es": ["Emoción mística", "Compasión de Piscis", "Corazón sin límites", "Sentimiento espiritual"],
    "ca": ["Emoció mística", "Compassió de Peixos", "Cor sense límits", "Sentiment espiritual"]
  }'::jsonb,
  '{
    "en": ["Set intentions for spiritual emotional connection", "Practice universal compassion meditation", "Dissolve boundaries between self and others", "Trust mystical emotional guidance from the deep"],
    "es": ["Establece intenciones de conexión emocional espiritual", "Practica meditación de compasión universal", "Disuelve límites entre tú y otros", "Confía en guía emocional mística desde las profundidades"],
    "ca": ["Estableix intencions de connexió emocional espiritual", "Practica meditació de compassió universal", "Dissol límits entre tu i altres", "Confia en guia emocional mística des de les profunditats"]
  }'::jsonb
);

-- Verification query
SELECT
  t.phase_id,
  t.element,
  so.season,
  so.overlay_headline->>'en' as headline
FROM seasonal_overlays so
JOIN lunar_guide_templates t ON so.template_id = t.id
WHERE t.phase_id = 'new_moon'
ORDER BY t.element, so.season;