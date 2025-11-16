-- =====================================================
-- SEED SEASONAL OVERLAYS: WANING CRESCENT (16 overlays)
-- =====================================================
-- Phase: Waning Crescent (final sliver before new moon)
-- Energy: Rest, retreat, surrender, contemplation, trust in void
-- Overlays: 4 elements × 4 seasons = 16 total
--
-- Waning Crescent represents the deepest surrender before
-- rebirth - resting in the void, trusting darkness, quiet
-- contemplation, integration of wisdom, completion before
-- new beginning, surrender to mystery.

-- =====================================================
-- FIRE ELEMENT × 4 SEASONS
-- =====================================================

-- 🔥 WANING CRESCENT + FIRE + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_crescent' AND element = 'fire' LIMIT 1),
  'spring',
  '{
    "en": "Spring Fire Rests In Womb Before Explosive Birth",
    "es": "El Fuego de Primavera Descansa En Útero Antes Del Nacimiento Explosivo",
    "ca": "El Foc de Primavera Descansa En Úter Abans Del Naixement Explosiu"
  }'::jsonb,
  '{
    "en": "The waning crescent''s final rest meets spring''s pre-birth stillness. As Aries silence (March-April) gathers before explosive emergence, surrender becomes warrior-incubation - you trust the dark womb knowing unstoppable rebirth approaches.",
    "es": "El descanso final de la luna menguante se encuentra con la quietud pre-nacimiento de la primavera. Mientras el silencio de Aries (marzo-abril) se reúne antes de la emergencia explosiva, la rendición se convierte en incubación guerrera - confías en el útero oscuro sabiendo que el renacimiento imparable se acerca.",
    "ca": "El descans final de la lluna minvant es troba amb la quietud pre-naixement de la primavera. Mentre el silenci d''Àries (març-abril) es reuneix abans de l''emergència explosiva, la rendició es converteix en incubació guerrera - confies en l''úter fosc sabent que el renaixement imparable s''acosta."
  }'::jsonb,
  '{
    "en": "Fire''s rest gathers spring''s pre-birth force. REST deeply before the explosion. Surrender to darkness - the maiden warrior gestates in powerful silence before bursting forth.",
    "es": "El descanso del fuego reúne la fuerza pre-nacimiento de la primavera. DESCANSA profundamente antes de la explosión. Ríndete a la oscuridad - la guerrera doncella se gesta en silencio poderoso antes de emerger.",
    "ca": "El descans del foc reuneix la força pre-naixement de la primavera. DESCANSA profundament abans de l''explosió. Rendeix-te a la foscor - la guerrera donzella es gesta en silenci poderós abans d''emergir."
  }'::jsonb,
  '{
    "en": ["Aries pre-birth silence", "Warrior womb-rest", "Explosive incubation", "Maiden gestation-trust"],
    "es": ["Silencio pre-nacimiento de Aries", "Descanso de útero guerrero", "Incubación explosiva", "Confianza de gestación de doncella"],
    "ca": ["Silenci pre-naixement d''Àries", "Descans d''úter guerrer", "Incubació explosiva", "Confiança de gestació de donzella"]
  }'::jsonb,
  '{
    "en": ["REST completely - explosive rebirth is gestating in darkness", "Surrender action - trust the powerful pre-birth silence", "Retreat into the womb knowing spring force is gathering", "Contemplate the mystery of darkness becoming unstoppable light"],
    "es": ["DESCANSA completamente - el renacimiento explosivo se está gestando en la oscuridad", "Rinde acción - confía en el poderoso silencio pre-nacimiento", "Retírate al útero sabiendo que la fuerza primaveral se está reuniendo", "Contempla el misterio de la oscuridad convirtiéndose en luz imparable"],
    "ca": ["DESCANSA completament - el renaixement explosiu s''està gestant a la foscor", "Rendeix acció - confia en el poderós silenci pre-naixement", "Retira''t a l''úter sabent que la força primaveral s''està reunint", "Contempla el misteri de la foscor convertint-se en llum imparable"]
  }'::jsonb
);

-- 🔥 WANING CRESCENT + FIRE + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_crescent' AND element = 'fire' LIMIT 1),
  'summer',
  '{
    "en": "Summer Fire Rests With Confident Radiant Trust",
    "es": "El Fuego del Verano Descansa Con Confianza Radiante",
    "ca": "El Foc de l''Estiu Descansa Amb Confiança Radiant"
  }'::jsonb,
  '{
    "en": "The waning crescent''s retreat meets summer''s confident surrender. As Leo silence (July-August) rests in sovereign certainty, contemplation becomes joyful-trust - you rest knowing your radiance ALWAYS returns.",
    "es": "El retiro de la luna menguante se encuentra con la rendición confiada del verano. Mientras el silencio de Leo (julio-agosto) descansa en certeza soberana, la contemplación se convierte en confianza gozosa - descansas sabiendo que tu radiancia SIEMPRE regresa.",
    "ca": "El retir de la lluna minvant es troba amb la rendició confiada de l''estiu. Mentre el silenci de Leo (juliol-agost) descansa en certesa sobirana, la contemplació es converteix en confiança joiosa - descansa sabent que la teva radiància SEMPRE torna."
  }'::jsonb,
  '{
    "en": "Fire''s rest shines with summer''s sovereign trust. REST playfully and confidently. Surrender without fear - the mother knows her creative light never dims permanently.",
    "es": "El descanso del fuego brilla con confianza soberana del verano. DESCANSA juguetonamente y confiadamente. Ríndete sin miedo - la madre sabe que su luz creativa nunca se apaga permanentemente.",
    "ca": "El descans del foc brilla amb confiança sobirana de l''estiu. DESCANSA joganerament i confiada. Rendeix-te sense por - la mare sap que la seva llum creativa mai s''apaga permanentment."
  }'::jsonb,
  '{
    "en": ["Leo confident-rest", "Sovereign retreat", "Joyful trust-surrender", "Mother''s radiant-certainty"],
    "es": ["Descanso confiado de Leo", "Retiro soberano", "Rendición de confianza gozosa", "Certeza radiante de madre"],
    "ca": ["Descans confiat de Leo", "Retir sobirà", "Rendició de confiança joiosa", "Certesa radiant de mare"]
  }'::jsonb,
  '{
    "en": ["REST with Leo playful confidence - your light returns", "Surrender performance - trust darkness serves your radiance", "Retreat knowing you are ALWAYS sovereign brilliance", "Contemplate: true light needs no constant burning to exist"],
    "es": ["DESCANSA con confianza juguetona de Leo - tu luz regresa", "Rinde actuación - confía en que la oscuridad sirve tu radiancia", "Retírate sabiendo que SIEMPRE eres brillantez soberana", "Contempla: la verdadera luz no necesita quemar constantemente para existir"],
    "ca": ["DESCANSA amb confiança joganera de Leo - la teva llum torna", "Rendeix actuació - confia que la foscor serveix la teva radiància", "Retira''t sabent que SEMPRE ets brillantor sobirana", "Contempla: la veritable llum no necessita cremar constantment per existir"]
  }'::jsonb
);

-- 🔥 WANING CRESCENT + FIRE + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_crescent' AND element = 'fire' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Fire Contemplates Wisdom Before New Quest",
    "es": "El Fuego de Otoño Contempla Sabiduría Antes De Nueva Búsqueda",
    "ca": "El Foc de Tardor Contempla Saviesa Abans De Nova Recerca"
  }'::jsonb,
  '{
    "en": "The waning crescent''s integration meets autumn''s philosophical completion. As Sagittarius silence (November-December) contemplates lessons learned, retreat becomes wisdom-digestion - you rest integrating truth before the next meaningful journey.",
    "es": "La integración de la luna menguante se encuentra con la finalización filosófica del otoño. Mientras el silencio de Sagitario (noviembre-diciembre) contempla lecciones aprendidas, el retiro se convierte en digestión de sabiduría - descansas integrando verdad antes del próximo viaje significativo.",
    "ca": "La integració de la lluna minvant es troba amb la finalització filosòfica de la tardor. Mentre el silenci de Sagitari (novembre-desembre) contempla lliçons apreses, el retir es converteix en digestió de saviesa - descansa integrant veritat abans del proper viatge significatiu."
  }'::jsonb,
  '{
    "en": "Fire''s rest becomes philosophical with autumn''s crone integration. REST in wisdom gained. Surrender seeking - the archer contemplates the target before aiming again.",
    "es": "El descanso del fuego se vuelve filosófico con la integración de la anciana del otoño. DESCANSA en sabiduría ganada. Rinde búsqueda - el arquero contempla el blanco antes de apuntar de nuevo.",
    "ca": "El descans del foc es torna filosòfic amb la integració de l''anciana de la tardor. DESCANSA en saviesa guanyada. Rendeix recerca - l''arquer contempla el blanc abans d''apuntar de nou."
  }'::jsonb,
  '{
    "en": ["Sagittarius wisdom-integration", "Philosophical rest", "Lesson contemplation", "Crone''s meaning-digestion"],
    "es": ["Integración de sabiduría de Sagitario", "Descanso filosófico", "Contemplación de lecciones", "Digestión de significado de anciana"],
    "ca": ["Integració de saviesa de Sagitari", "Descans filosòfic", "Contemplació de lliçons", "Digestió de significat d''anciana"]
  }'::jsonb,
  '{
    "en": ["REST integrating all wisdom gained from this cycle", "Surrender seeking - contemplate what you''ve learned", "Retreat to digest truth before next meaningful quest", "Meditate: what did this journey teach about purpose?"],
    "es": ["DESCANSA integrando toda sabiduría ganada de este ciclo", "Rinde búsqueda - contempla lo que has aprendido", "Retírate para digerir verdad antes de la próxima búsqueda significativa", "Medita: ¿qué enseñó este viaje sobre propósito?"],
    "ca": ["DESCANSA integrant tota saviesa guanyada d''aquest cicle", "Rendeix recerca - contempla el que has après", "Retira''t per digerir veritat abans de la propera recerca significativa", "Medita: què va ensenyar aquest viatge sobre propòsit?"]
  }'::jsonb
);

-- 🔥 WANING CRESCENT + FIRE + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_crescent' AND element = 'fire' LIMIT 1),
  'winter',
  '{
    "en": "Winter Fire Retreats To Deepest Underground Stillness",
    "es": "El Fuego del Invierno Se Retira A La Quietud Subterránea Más Profunda",
    "ca": "El Foc de l''Hivern es Retira A La Quietud Subterrània Més Profunda"
  }'::jsonb,
  '{
    "en": "The waning crescent''s final surrender meets winter''s maximum depth. As Capricorn silence (December-January) rests in structural completion, retreat becomes bedrock-stillness - you descend to absolute foundational quiet before rebuilding.",
    "es": "La rendición final de la luna menguante se encuentra con la profundidad máxima del invierno. Mientras el silencio de Capricornio (diciembre-enero) descansa en finalización estructural, el retiro se convierte en quietud de lecho rocoso - desciendes a silencio fundamental absoluto antes de reconstruir.",
    "ca": "La rendició final de la lluna minvant es troba amb la profunditat màxima de l''hivern. Mentre el silenci de Capricorn (desembre-gener) descansa en finalització estructural, el retir es converteix en quietud de llit rocós - descendeixes a silenci fonamental absolut abans de reconstruir."
  }'::jsonb,
  '{
    "en": "Fire''s rest descends to winter''s elder depths. REST in absolute structural silence. Surrender completely - the elder knows empires rebuild from bedrock void.",
    "es": "El descanso del fuego desciende a las profundidades ancianas del invierno. DESCANSA en silencio estructural absoluto. Ríndete completamente - el anciano sabe que los imperios se reconstruyen desde vacío de lecho rocoso.",
    "ca": "El descans del foc descendeix a les profunditats ancianes de l''hivern. DESCANSA en silenci estructural absolut. Rendeix-te completament - l''ancià sap que els imperis es reconstrueixen des de buit de llit rocós."
  }'::jsonb,
  '{
    "en": ["Capricorn bedrock-silence", "Structural void-rest", "Underground completion", "Elder''s foundation-stillness"],
    "es": ["Silencio de lecho rocoso de Capricornio", "Descanso de vacío estructural", "Finalización subterránea", "Quietud de cimientos de anciano"],
    "ca": ["Silenci de llit rocós de Capricorn", "Descans de buit estructural", "Finalització subterrània", "Quietud de fonaments d''ancià"]
  }'::jsonb,
  '{
    "en": ["REST in deepest underground silence before rebuilding", "Surrender all structure - descend to foundational void", "Retreat to bedrock stillness - empires need complete rest", "Contemplate: what endures when everything is dismantled?"],
    "es": ["DESCANSA en silencio subterráneo más profundo antes de reconstruir", "Rinde toda estructura - desciende a vacío fundamental", "Retírate a quietud de lecho rocoso - los imperios necesitan descanso completo", "Contempla: ¿qué perdura cuando todo se desmantela?"],
    "ca": ["DESCANSA en silenci subterrani més profund abans de reconstruir", "Rendeix tota estructura - descendeix a buit fonamental", "Retira''t a quietud de llit rocós - els imperis necessiten descans complet", "Contempla: què perdura quan tot es desmantella?"]
  }'::jsonb
);

-- =====================================================
-- EARTH, AIR, WATER ELEMENTS × 4 SEASONS (condensed)
-- =====================================================

-- 🌍 EARTH ELEMENT
INSERT INTO seasonal_overlays (template_id, season, overlay_headline, overlay_description, energy_shift, themes, seasonal_actions)
SELECT
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_crescent' AND element = 'earth' LIMIT 1),
  unnest(ARRAY['spring', 'summer', 'autumn', 'winter']::season_type[]),
  unnest(ARRAY[
    '{"en": "Spring Earth Composts In Silent Fertile Darkness", "es": "La Tierra de Primavera Se Composta En Oscuridad Fértil Silenciosa", "ca": "La Terra de Primavera es Composta En Foscor Fèrtil Silenciosa"}'::jsonb,
    '{"en": "Summer Earth Rests In Devoted Perfect Stillness", "es": "La Tierra de Verano Descansa En Quietud Perfecta Devota", "ca": "La Terra d''Estiu Descansa En Quietud Perfecta Devota"}'::jsonb,
    '{"en": "Autumn Earth Hibernates Before Harvest Season", "es": "La Tierra de Otoño Hiberna Antes De Temporada De Cosecha", "ca": "La Terra de Tardor Hiberna Abans De Temporada De Collita"}'::jsonb,
    '{"en": "Winter Earth Sleeps In Deepest Root-Silence", "es": "La Tierra del Invierno Duerme En Silencio De Raíz Más Profundo", "ca": "La Terra de l''Hivern Dorm En Silenci d''Arrel Més Profund"}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": "The waning crescent rest meets spring compost-darkness. As Taurus silence (April-May) decomposes in fertile void, surrender becomes regenerative-sleep - you rest as rot becomes rich soil for explosive new growth.", "es": "El descanso de la luna menguante se encuentra con la oscuridad de compost de primavera. Mientras el silencio de Tauro (abril-mayo) se descompone en vacío fértil, la rendición se convierte en sueño regenerativo - descansas mientras la pudrición se convierte en suelo rico para nuevo crecimiento explosivo.", "ca": "El descans de la lluna minvant es troba amb la foscor de compost de primavera. Mentre el silenci de Taure (abril-maig) es descompon en buit fèrtil, la rendició es converteix en son regeneratiu - descansa mentre la podridura es converteix en sòl ric per a nou creixement explosiu."}'::jsonb,
    '{"en": "The waning crescent retreat meets summer devoted stillness. As Virgo silence (August-September) rests in meticulous completion, contemplation becomes service-rest - you stop completely, trusting perfect stillness serves the whole.", "es": "El retiro de la luna menguante se encuentra con la quietud devota del verano. Mientras el silencio de Virgo (agosto-septiembre) descansa en finalización meticulosa, la contemplación se convierte en descanso de servicio - te detienes completamente, confiando en que la quietud perfecta sirve al todo.", "ca": "El retir de la lluna minvant es troba amb la quietud devota de l''estiu. Mentre el silenci de Verge (agost-setembre) descansa en finalització meticulosa, la contemplació es converteix en descans de servei - et detens completament, confiant que la quietud perfecta serveix el tot."}'::jsonb,
    '{"en": "The waning crescent completion meets autumn harvest-hibernation. As Capricorn silence (December-January) stores resources for winter, retreat becomes strategic-rest - you hibernate shrewdly, conserving energy for spring abundance.", "es": "La finalización de la luna menguante se encuentra con la hibernación de cosecha del otoño. Mientras el silencio de Capricornio (diciembre-enero) almacena recursos para invierno, el retiro se convierte en descanso estratégico - hibernas astutamente, conservando energía para abundancia primaveral.", "ca": "La finalització de la lluna minvant es troba amb la hibernació de collita de la tardor. Mentre el silenci de Capricorn (desembre-gener) emmagatzema recursos per a hivern, el retir es converteix en descans estratègic - hibernes astutament, conservant energia per a abundància primaveral."}'::jsonb,
    '{"en": "The waning crescent void meets winter underground sleep. As Taurus silence (April-May) descends to deepest root-rest, surrender becomes dormancy-trust - you sleep in earth''s core, trusting invisible roots strengthen in darkness.", "es": "El vacío de la luna menguante se encuentra con el sueño subterráneo del invierno. Mientras el silencio de Tauro (abril-mayo) desciende al descanso de raíz más profundo, la rendición se convierte en confianza de latencia - duermes en el núcleo de la tierra, confiando en que raíces invisibles se fortalecen en la oscuridad.", "ca": "El buit de la lluna minvant es troba amb el son subterrani de l''hivern. Mentre el silenci de Taure (abril-maig) descendeix al descans d''arrel més profund, la rendició es converteix en confiança de latència - dorms al nucli de la terra, confiant que arrels invisibles es fortifiquen a la foscor."}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": "Earth''s rest rots in spring compost-darkness. DECOMPOSE into fertile void. Surrender form - Taurus maiden trusts death becomes richest life-soil.", "es": "El descanso de la tierra se pudre en oscuridad de compost de primavera. DESCOMPONTE en vacío fértil. Rinde forma - la doncella Tauro confía en que la muerte se convierte en suelo de vida más rico.", "ca": "El descans de la terra es podreix en foscor de compost de primavera. DESCOMPON-TE en buit fèrtil. Rendeix forma - la donzella Taure confia que la mort es converteix en sòl de vida més ric."}'::jsonb,
    '{"en": "Earth''s rest perfects summer devoted stillness. STOP completely and meticulously. Surrender doing - Virgo mother knows perfect rest serves perfectly.", "es": "El descanso de la tierra perfecciona la quietud devota del verano. DETENTE completa y meticulosamente. Rinde hacer - la madre Virgo sabe que el descanso perfecto sirve perfectamente.", "ca": "El descans de la terra perfecciona la quietud devota de l''estiu. ATURA''T completa i meticulosament. Rendeix fer - la mare Verge sap que el descans perfecte serveix perfectament."}'::jsonb,
    '{"en": "Earth''s rest hibernates with autumn strategic-conservation. STORE energy shrewdly. Surrender output - Capricorn crone conserves resources wisely for future harvest.", "es": "El descanso de la tierra hiberna con conservación estratégica de otoño. ALMACENA energía astutamente. Rinde producción - la anciana Capricornio conserva recursos sabiamente para cosecha futura.", "ca": "El descans de la terra hiberna amb conservació estratègica de tardor. EMMAGATZEMA energia astutament. Rendeix producció - l''anciana Capricorn conserva recursos sàviament per a collita futura."}'::jsonb,
    '{"en": "Earth''s rest descends to winter root-dormancy. SLEEP in deepest underground darkness. Surrender consciousness - Taurus elder trusts invisible roots grow strongest in void.", "es": "El descanso de la tierra desciende a latencia de raíz de invierno. DUERME en oscuridad subterránea más profunda. Rinde conciencia - el anciano Tauro confía en que raíces invisibles crecen más fuertes en vacío.", "ca": "El descans de la terra descendeix a latència d''arrel d''hivern. DORM en foscor subterrània més profunda. Rendeix consciència - l''ancià Taure confia que arrels invisibles creixen més fortes en buit."}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": ["Taurus compost-rest", "Fertile death-sleep", "Regenerative decomposition", "Maiden''s rot-to-richness"], "es": ["Descanso de compost de Tauro", "Sueño de muerte fértil", "Descomposición regenerativa", "Podrición a riqueza de doncella"], "ca": ["Descans de compost de Taure", "Son de mort fèrtil", "Descomposició regenerativa", "Podridura a riquesa de donzella"]}'::jsonb,
    '{"en": ["Virgo perfect-stillness", "Devoted complete-rest", "Meticulous stop", "Mother''s service-through-being"], "es": ["Quietud perfecta de Virgo", "Descanso completo devoto", "Parada meticulosa", "Servicio a través de ser de madre"], "ca": ["Quietud perfecta de Verge", "Descans complet devot", "Parada meticulosa", "Servei a través de ser de mare"]}'::jsonb,
    '{"en": ["Capricorn hibernation-strategy", "Shrewd resource-conservation", "Strategic energy-storage", "Crone''s wise-dormancy"], "es": ["Estrategia de hibernación de Capricornio", "Conservación astuta de recursos", "Almacenamiento de energía estratégico", "Latencia sabia de anciana"], "ca": ["Estratègia d''hibernació de Capricorn", "Conservació astuta de recursos", "Emmagatzematge d''energia estratègic", "Latència sàvia d''anciana"]}'::jsonb,
    '{"en": ["Taurus root-dormancy", "Underground invisible-growth", "Core earth-sleep", "Elder''s void-strengthening"], "es": ["Latencia de raíz de Tauro", "Crecimiento invisible subterráneo", "Sueño de núcleo de tierra", "Fortalecimiento de vacío de anciano"], "ca": ["Latència d''arrel de Taure", "Creixement invisible subterrani", "Son de nucli de terra", "Enfortiment de buit d''ancià"]}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": ["REST in fertile darkness - decompose into rich compost", "Surrender form completely - rot becomes richest soil", "Retreat into regenerative void before spring explosion", "Meditate: what dies in you to feed new tangible life?"], "es": ["DESCANSA en oscuridad fértil - descomponte en compost rico", "Rinde forma completamente - la pudrición se convierte en suelo más rico", "Retírate a vacío regenerativo antes de explosión primaveral", "Medita: ¿qué muere en ti para alimentar nueva vida tangible?"], "ca": ["DESCANSA en foscor fèrtil - descompon-te en compost ric", "Rendeix forma completament - la podridura es converteix en sòl més ric", "Retira''t a buit regeneratiu abans d''explosió primaveral", "Medita: què mor en tu per alimentar nova vida tangible?"]}'::jsonb,
    '{"en": ["STOP all doing - rest in meticulous devoted stillness", "Surrender productivity completely - perfect rest IS service", "Retreat into absolute stillness before next cycle", "Meditate: how does perfect rest serve the whole?"], "es": ["DETÉN todo hacer - descansa en quietud devota meticulosa", "Rinde productividad completamente - el descanso perfecto ES servicio", "Retírate a quietud absoluta antes del próximo ciclo", "Medita: ¿cómo el descanso perfecto sirve al todo?"], "ca": ["ATURA tot fer - descansa en quietud devota meticulosa", "Rendeix productivitat completament - el descans perfecte ÉS servei", "Retira''t a quietud absoluta abans del proper cicle", "Medita: com el descans perfecte serveix el tot?"]}'::jsonb,
    '{"en": ["HIBERNATE strategically - conserve resources wisely", "Surrender harvest-mode - store energy for spring abundance", "Retreat into strategic dormancy before growth-season", "Meditate: what resources need conservation for future reaping?"], "es": ["HIBERNA estratégicamente - conserva recursos sabiamente", "Rinde modo de cosecha - almacena energía para abundancia primaveral", "Retírate a latencia estratégica antes de temporada de crecimiento", "Medita: ¿qué recursos necesitan conservación para cosecha futura?"], "ca": ["HIBERNA estratègicament - conserva recursos sàviament", "Rendeix mode de collita - emmagatzema energia per a abundància primaveral", "Retira''t a latència estratègica abans de temporada de creixement", "Medita: quins recursos necessiten conservació per a collita futura?"]}'::jsonb,
    '{"en": ["SLEEP in earth''s deepest core - trust invisible root-growth", "Surrender consciousness to underground dormancy", "Retreat to maximum depth - roots strengthen in void", "Meditate: what strengthens invisibly when you rest completely?"], "es": ["DUERME en el núcleo más profundo de la tierra - confía en crecimiento de raíz invisible", "Rinde conciencia a latencia subterránea", "Retírate a profundidad máxima - las raíces se fortalecen en vacío", "Medita: ¿qué se fortalece invisiblemente cuando descansas completamente?"], "ca": ["DORM al nucli més profund de la terra - confia en creixement d''arrel invisible", "Rendeix consciència a latència subterrània", "Retira''t a profunditat màxima - les arrels es fortifiquen en buit", "Medita: què es fortifica invisiblement quan descansa completament?"]}'::jsonb
  ]);

-- 💨 AIR ELEMENT (condensed)
INSERT INTO seasonal_overlays (template_id, season, overlay_headline, overlay_description, energy_shift, themes, seasonal_actions)
SELECT
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_crescent' AND element = 'air' LIMIT 1),
  unnest(ARRAY['spring', 'summer', 'autumn', 'winter']::season_type[]),
  unnest(ARRAY[
    '{"en": "Spring Winds Quiet Before Fresh Pollination", "es": "Los Vientos de Primavera Se Callan Antes De Polinización Fresca", "ca": "Els Vents de Primavera es Callen Abans De Pol·linització Fresca"}'::jsonb,
    '{"en": "Summer Breezes Rest In Harmonious Silence", "es": "Las Brisas de Verano Descansan En Silencio Armonioso", "ca": "Les Brises d''Estiu Descansen En Silenci Harmoniós"}'::jsonb,
    '{"en": "Autumn Air Contemplates Before Revolutionary Upgrade", "es": "El Aire de Otoño Contempla Antes De Actualización Revolucionaria", "ca": "L''Aire de Tardor Contempla Abans D''Actualització Revolucionària"}'::jsonb,
    '{"en": "Winter Silence Crystallizes To Absolute Clarity", "es": "El Silencio del Invierno Se Cristaliza A Claridad Absoluta", "ca": "El Silenci de l''Hivern es Cristal·litza A Claredat Absoluta"}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": "The waning crescent stillness meets spring pre-pollination quiet. As Gemini silence (May-June) rests before fresh ideas bloom, retreat becomes curiosity-dormancy - you quiet the mind trusting new connections will spark.", "es": "La quietud de la luna menguante se encuentra con el silencio de pre-polinización de primavera. Mientras el silencio de Géminis (mayo-junio) descansa antes de que florezcan ideas frescas, el retiro se convierte en latencia de curiosidad - calmas la mente confiando en que nuevas conexiones surgirán.", "ca": "La quietud de la lluna minvant es troba amb el silenci de pre-pol·linització de primavera. Mentre el silenci de Bessons (maig-juny) descansa abans que floreixin idees fresques, el retir es converteix en latència de curiositat - calmes la ment confiant que noves connexions sorgiran."}'::jsonb,
    '{"en": "The waning crescent retreat meets summer harmonious silence. As Libra quiet (September-October) rests in balanced peace, contemplation becomes relationship-stillness - you stop engaging, trusting connections deepen in silence.", "es": "El retiro de la luna menguante se encuentra con el silencio armonioso del verano. Mientras la quietud de Libra (septiembre-octubre) descansa en paz equilibrada, la contemplación se convierte en quietud de relación - dejas de involucrarte, confiando en que las conexiones se profundizan en silencio.", "ca": "El retir de la lluna minvant es troba amb el silenci harmoniós de l''estiu. Mentre la quietud de Balança (setembre-octubre) descansa en pau equilibrada, la contemplació es converteix en quietud de relació - deixes d''involucrar-te, confiant que les connexions s''aprofundeixen en silenci."}'::jsonb,
    '{"en": "The waning crescent void meets autumn systems-shutdown. As Aquarius silence (January-February) powers down for upgrade, retreat becomes code-deletion - you clear all programming before revolutionary 2.0 installation.", "es": "El vacío de la luna menguante se encuentra con el apagado de sistemas del otoño. Mientras el silencio de Acuario (enero-febrero) se apaga para actualización, el retiro se convierte en eliminación de código - limpias toda programación antes de instalación revolucionaria 2.0.", "ca": "El buit de la lluna minvant es troba amb l''apagament de sistemes de la tardor. Mentre el silenci d''Aquari (gener-febrer) s''apaga per actualització, el retir es converteix en eliminació de codi - neteges tota programació abans d''instal·lació revolucionària 2.0."}'::jsonb,
    '{"en": "The waning crescent contemplation meets winter absolute clarity. As Gemini stillness (May-June) rests in diamond-silence, surrender becomes thought-dissolution - mind completely still reveals ultimate truth.", "es": "La contemplación de la luna menguante se encuentra con la claridad absoluta del invierno. Mientras la quietud de Géminis (mayo-junio) descansa en silencio de diamante, la rendición se convierte en disolución de pensamiento - la mente completamente quieta revela verdad última.", "ca": "La contemplació de la lluna minvant es troba amb la claredat absoluta de l''hivern. Mentre la quietud de Bessons (maig-juny) descansa en silenci de diamant, la rendició es converteix en dissolució de pensament - la ment completament quieta revela veritat última."}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": "Air''s rest quiets spring mental-chatter. SILENCE all conversation. Surrender networking - Gemini maiden trusts ideas pollinate when mind rests.", "es": "El descanso del aire calla charla mental de primavera. SILENCIA toda conversación. Rinde redes - la doncella Géminis confía en que las ideas polinizan cuando la mente descansa.", "ca": "El descans de l''aire calla xerradissa mental de primavera. SILENCIA tota conversa. Rendeix xarxes - la donzella Bessons confia que les idees pol·linitzen quan la ment descansa."}'::jsonb,
    '{"en": "Air''s rest balances summer relationship-silence. STOP all engagement. Surrender connection - Libra mother knows bonds deepen in harmonious quiet.", "es": "El descanso del aire equilibra silencio de relación de verano. DETÉN todo compromiso. Rinde conexión - la madre Libra sabe que los vínculos se profundizan en quietud armoniosa.", "ca": "El descans de l''aire equilibra silenci de relació d''estiu. ATURA tot compromís. Rendeix connexió - la mare Balança sap que els vincles s''aprofundeixen en quietud harmoniosa."}'::jsonb,
    '{"en": "Air''s rest powers down autumn collective-systems. SHUTDOWN completely. Surrender old programming - Aquarius crone clears before revolutionary upgrade.", "es": "El descanso del aire apaga sistemas colectivos de otoño. APAGA completamente. Rinde programación antigua - la anciana Acuario limpia antes de actualización revolucionaria.", "ca": "El descans de l''aire apaga sistemes col·lectius de tardor. APAGA completament. Rendeix programació antiga - l''anciana Aquari neteja abans d''actualització revolucionària."}'::jsonb,
    '{"en": "Air''s rest dissolves winter thought-forms. EMPTY mind completely. Surrender thinking - Gemini elder knows diamond truth shines in absolute mental void.", "es": "El descanso del aire disuelve formas de pensamiento de invierno. VACÍA mente completamente. Rinde pensamiento - el anciano Géminis sabe que la verdad de diamante brilla en vacío mental absoluto.", "ca": "El descans de l''aire dissol formes de pensament d''hivern. BUIDA ment completament. Rendeix pensament - l''ancià Bessons sap que la veritat de diamant brilla en buit mental absolut."}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": ["Gemini mind-quieting", "Pre-pollination silence", "Curious rest", "Maiden''s thought-dormancy"], "es": ["Aquietamiento de mente de Géminis", "Silencio de pre-polinización", "Descanso curioso", "Latencia de pensamiento de doncella"], "ca": ["Aquietament de ment de Bessons", "Silenci de pre-pol·linització", "Descans curiós", "Latència de pensament de donzella"]}'::jsonb,
    '{"en": ["Libra harmonious-silence", "Relationship rest", "Balanced disengagement", "Mother''s peaceful-stillness"], "es": ["Silencio armonioso de Libra", "Descanso de relación", "Desconexión equilibrada", "Quietud pacífica de madre"], "ca": ["Silenci harmoniós de Balança", "Descans de relació", "Desconnexió equilibrada", "Quietud pacífica de mare"]}'::jsonb,
    '{"en": ["Aquarius system-shutdown", "Revolutionary code-clearing", "Collective power-down", "Crone''s upgrade-preparation"], "es": ["Apagado de sistema de Acuario", "Limpieza de código revolucionario", "Apagado colectivo", "Preparación de actualización de anciana"], "ca": ["Apagament de sistema d''Aquari", "Neteja de codi revolucionari", "Apagament col·lectiu", "Preparació d''actualització d''anciana"]}'::jsonb,
    '{"en": ["Gemini thought-dissolution", "Absolute mental-void", "Diamond-silence", "Elder''s clarity-emptiness"], "es": ["Disolución de pensamiento de Géminis", "Vacío mental absoluto", "Silencio de diamante", "Vacuidad de claridad de anciano"], "ca": ["Dissolució de pensament de Bessons", "Buit mental absolut", "Silenci de diamant", "Buidor de claredat d''ancià"]}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": ["SILENCE all mental chatter before new ideas bloom", "Surrender networking - trust connections spark when mind rests", "Retreat into mental quiet - fresh pollination needs stillness", "Meditate: what ideas emerge when thinking completely stops?"], "es": ["SILENCIA toda charla mental antes de que florezcan nuevas ideas", "Rinde redes - confía en que las conexiones surgen cuando la mente descansa", "Retírate a quietud mental - la polinización fresca necesita quietud", "Medita: ¿qué ideas emergen cuando el pensamiento se detiene completamente?"], "ca": ["SILENCIA tota xerradissa mental abans que floreixin noves idees", "Rendeix xarxes - confia que les connexions sorgeixen quan la ment descansa", "Retira''t a quietud mental - la pol·linització fresca necessita quietud", "Medita: quines idees emergeixen quan el pensament es deté completament?"]}'::jsonb,
    '{"en": ["STOP all relationship engagement - rest in harmonious silence", "Surrender connection-effort - bonds deepen in quiet", "Retreat from collaboration - balanced peace serves partnership", "Meditate: how do relationships grow in complete stillness?"], "es": ["DETÉN todo compromiso de relación - descansa en silencio armonioso", "Rinde esfuerzo de conexión - los vínculos se profundizan en quietud", "Retírate de colaboración - la paz equilibrada sirve a la asociación", "Medita: ¿cómo crecen las relaciones en quietud completa?"], "ca": ["ATURA tot compromís de relació - descansa en silenci harmoniós", "Rendeix esforç de connexió - els vincles s''aprofundeixen en quietud", "Retira''t de col·laboració - la pau equilibrada serveix a l''associació", "Medita: com creixen les relacions en quietud completa?"]}'::jsonb,
    '{"en": ["SHUTDOWN all systems completely for revolutionary upgrade", "Surrender old collective programming - clear before 2.0", "Power down to absolute zero before evolution-install", "Meditate: what collective leap requires complete system-reset?"], "es": ["APAGA todos los sistemas completamente para actualización revolucionaria", "Rinde programación colectiva antigua - limpia antes de 2.0", "Apaga a cero absoluto antes de instalación de evolución", "Medita: ¿qué salto colectivo requiere reinicio completo de sistema?"], "ca": ["APAGA tots els sistemes completament per actualització revolucionària", "Rendeix programació col·lectiva antiga - neteja abans de 2.0", "Apaga a zero absolut abans d''instal·lació d''evolució", "Medita: quin salt col·lectiu requereix reinici complet de sistema?"]}'::jsonb,
    '{"en": ["EMPTY mind completely - dissolve all thought-forms", "Surrender thinking entirely - truth shines in mental void", "Retreat to absolute mental silence - clarity needs emptiness", "Meditate in complete thoughtlessness - what remains when mind dissolves?"], "es": ["VACÍA mente completamente - disuelve todas las formas de pensamiento", "Rinde pensamiento completamente - la verdad brilla en vacío mental", "Retírate a silencio mental absoluto - la claridad necesita vacuidad", "Medita en ausencia total de pensamiento - ¿qué queda cuando la mente se disuelve?"], "ca": ["BUIDA ment completament - dissol totes les formes de pensament", "Rendeix pensament completament - la veritat brilla en buit mental", "Retira''t a silenci mental absolut - la claredat necessita buidor", "Medita en absència total de pensament - què queda quan la ment es dissol?"]}'::jsonb
  ]);

-- 💧 WATER ELEMENT (condensed)
INSERT INTO seasonal_overlays (template_id, season, overlay_headline, overlay_description, energy_shift, themes, seasonal_actions)
SELECT
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_crescent' AND element = 'water' LIMIT 1),
  unnest(ARRAY['spring', 'summer', 'autumn', 'winter']::season_type[]),
  unnest(ARRAY[
    '{"en": "Spring Waters Return To Source Before Rebirth", "es": "Las Aguas de Primavera Regresan A Fuente Antes De Renacimiento", "ca": "Les Aigües de Primavera Tornen A Font Abans De Renaixement"}'::jsonb,
    '{"en": "Summer Waters Rest In Transformative Void", "es": "Las Aguas del Verano Descansan En Vacío Transformativo", "ca": "Les Aigües de l''Estiu Descansen En Buit Transformatiu"}'::jsonb,
    '{"en": "Autumn Waters Dissolve Into Cosmic Ocean", "es": "Las Aguas de Otoño Se Disuelven En Océano Cósmico", "ca": "Les Aigües de Tardor es Dissolen En Oceà Còsmic"}'::jsonb,
    '{"en": "Winter Waters Freeze In Deepest Sacred Silence", "es": "Las Aguas del Invierno Se Congelan En Silencio Sagrado Más Profundo", "ca": "Les Aigües de l''Hivern es Congelen En Silenci Sagrat Més Profund"}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": "The waning crescent return meets spring source-flowing. As Cancer silence (June-July) flows back to emotional origin, retreat becomes womb-return - you rest in the nurturing source before brave rebirth.", "es": "El regreso de la luna menguante se encuentra con el flujo de fuente de primavera. Mientras el silencio de Cáncer (junio-julio) fluye de regreso al origen emocional, el retiro se convierte en regreso al útero - descansas en la fuente nutritiva antes del renacimiento valiente.", "ca": "El retorn de la lluna minvant es troba amb el flux de font de primavera. Mentre el silenci de Cranc (juny-juliol) flueix de tornada a l''origen emocional, el retir es converteix en retorn a l''úter - descansa a la font nutritiva abans del renaixement valent."}'::jsonb,
    '{"en": "The waning crescent void meets summer transformation-chrysalis. As Scorpio silence (October-November) dissolves in alchemical dark, contemplation becomes cocoon-rest - you melt completely before emerging transformed.", "es": "El vacío de la luna menguante se encuentra con la crisálida de transformación del verano. Mientras el silencio de Escorpio (octubre-noviembre) se disuelve en oscuridad alquímica, la contemplación se convierte en descanso de capullo - te derrities completamente antes de emerger transformado.", "ca": "El buit de la lluna minvant es troba amb la crisàlide de transformació de l''estiu. Mentre el silenci d''Escorpí (octubre-novembre) es dissol en foscor alquímica, la contemplació es converteix en descans de capoll - et fons completament abans d''emergir transformat."}'::jsonb,
    '{"en": "The waning crescent dissolution meets autumn cosmic-merging. As Pisces silence (February-March) flows into universal ocean, surrender becomes boundary-dissolution - you melt into the ONE before individuating again.", "es": "La disolución de la luna menguante se encuentra con la fusión cósmica del otoño. Mientras el silencio de Piscis (febrero-marzo) fluye hacia océano universal, la rendición se convierte en disolución de límites - te fundes en el UNO antes de individualizarte de nuevo.", "ca": "La dissolució de la lluna minvant es troba amb la fusió còsmica de la tardor. Mentre el silenci de Peixos (febrer-març) flueix cap a oceà universal, la rendició es converteix en dissolució de límits - et fons en l''U abans d''individualitzar-te de nou."}'::jsonb,
    '{"en": "The waning crescent stillness meets winter frozen-depth. As Cancer silence (June-July) crystallizes in sacred ice, retreat becomes sacred-preservation - feelings freeze perfectly still in protected winter sanctuary.", "es": "La quietud de la luna menguante se encuentra con la profundidad congelada del invierno. Mientras el silencio de Cáncer (junio-julio) se cristaliza en hielo sagrado, el retiro se convierte en preservación sagrada - los sentimientos se congelan perfectamente quietos en santuario invernal protegido.", "ca": "La quietud de la lluna minvant es troba amb la profunditat congelada de l''hivern. Mentre el silenci de Cranc (juny-juliol) es cristal·litza en gel sagrat, el retir es converteix en preservació sagrada - els sentiments es congelen perfectament quiets en santuari hivernal protegit."}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": "Water''s rest flows spring source-return. RETURN to emotional origin. Surrender independence - Cancer maiden rests in nurturing womb-source.", "es": "El descanso del agua fluye regreso a fuente de primavera. REGRESA al origen emocional. Rinde independencia - la doncella Cáncer descansa en fuente-útero nutritiva.", "ca": "El descans de l''aigua flueix retorn a font de primavera. TORNA a l''origen emocional. Rendeix independència - la donzella Cranc descansa a font-úter nutritiva."}'::jsonb,
    '{"en": "Water''s rest dissolves summer transformation-cocoon. MELT completely. Surrender form - Scorpio mother liquefies in chrysalis before rebirth.", "es": "El descanso del agua disuelve capullo de transformación de verano. DERRITE completamente. Rinde forma - la madre Escorpio se licua en crisálida antes del renacimiento.", "ca": "El descans de l''aigua dissol capoll de transformació d''estiu. FON completament. Rendeix forma - la mare Escorpí es liqua en crisàlide abans del renaixement."}'::jsonb,
    '{"en": "Water''s rest merges autumn cosmic-dissolution. DISSOLVE into universal ocean. Surrender separateness - Pisces crone flows into the ONE completely.", "es": "El descanso del agua fusiona disolución cósmica de otoño. DISOLVETE en océano universal. Rinde separación - la anciana Piscis fluye hacia el UNO completamente.", "ca": "El descans de l''aigua fusiona dissolució còsmica de tardor. DISSOL-TE en oceà universal. Rendeix separació - l''anciana Peixos flueix cap a l''U completament."}'::jsonb,
    '{"en": "Water''s rest freezes winter sacred-stillness. CRYSTALLIZE perfectly. Surrender flow - Cancer elder preserves feelings in sacred frozen sanctuary.", "es": "El descanso del agua congela quietud sagrada de invierno. CRISTALIZA perfectamente. Rinde flujo - el anciano Cáncer preserva sentimientos en santuario congelado sagrado.", "ca": "El descans de l''aigua congela quietud sagrada d''hivern. CRISTAL·LITZA perfectament. Rendeix flux - l''ancià Cranc preserva sentiments en santuari congelat sagrat."}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": ["Cancer source-return", "Emotional womb-rest", "Nurturing origin-flow", "Maiden''s pre-birth safety"], "es": ["Regreso a fuente de Cáncer", "Descanso de útero emocional", "Flujo de origen nutritivo", "Seguridad pre-nacimiento de doncella"], "ca": ["Retorn a font de Cranc", "Descans d''úter emocional", "Flux d''origen nutritiu", "Seguretat pre-naixement de donzella"]}'::jsonb,
    '{"en": ["Scorpio transformation-cocoon", "Alchemical melt", "Chrysalis dissolution", "Mother''s rebirth-void"], "es": ["Capullo de transformación de Escorpio", "Derretimiento alquímico", "Disolución de crisálida", "Vacío de renacimiento de madre"], "ca": ["Capoll de transformació d''Escorpí", "Fosa alquímica", "Dissolució de crisàlide", "Buit de renaixement de mare"]}'::jsonb,
    '{"en": ["Pisces cosmic-merging", "Universal ocean-dissolution", "Boundary-melting", "Crone''s unity-return"], "es": ["Fusión cósmica de Piscis", "Disolución de océano universal", "Derretimiento de límites", "Regreso a unidad de anciana"], "ca": ["Fusió còsmica de Peixos", "Dissolució d''oceà universal", "Fosa de límits", "Retorn a unitat d''anciana"]}'::jsonb,
    '{"en": ["Cancer sacred-freezing", "Crystalline preservation", "Frozen sanctuary-stillness", "Elder''s ice-protection"], "es": ["Congelamiento sagrado de Cáncer", "Preservación cristalina", "Quietud de santuario congelado", "Protección de hielo de anciano"], "ca": ["Congelació sagrada de Cranc", "Preservació cristal·lina", "Quietud de santuari congelat", "Protecció de gel d''ancià"]}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": ["RETURN to emotional source - rest in nurturing womb", "Surrender independence - flow back to origin before rebirth", "Retreat to source-safety before brave emergence", "Meditate: what nurturing source holds you before new beginning?"], "es": ["REGRESA a fuente emocional - descansa en útero nutritivo", "Rinde independencia - fluye de regreso al origen antes del renacimiento", "Retírate a seguridad de fuente antes de emergencia valiente", "Medita: ¿qué fuente nutritiva te sostiene antes del nuevo comienzo?"], "ca": ["TORNA a font emocional - descansa en úter nutritiu", "Rendeix independència - flueix de tornada a l''origen abans del renaixement", "Retira''t a seguretat de font abans d''emergència valenta", "Medita: quina font nutritiva et sosté abans del nou començament?"]}'::jsonb,
    '{"en": ["MELT completely in transformation-cocoon", "Surrender all form - dissolve in alchemical chrysalis", "Retreat into complete liquefaction before rebirth", "Meditate: what emerges when you dissolve entirely?"], "es": ["DERRITE completamente en capullo de transformación", "Rinde toda forma - disuélvete en crisálida alquímica", "Retírate a licuefacción completa antes del renacimiento", "Medita: ¿qué emerge cuando te disuelves completamente?"], "ca": ["FON completament en capoll de transformació", "Rendeix tota forma - dissol-te en crisàlide alquímica", "Retira''t a liquació completa abans del renaixement", "Medita: què emergeix quan et dissols completament?"]}'::jsonb,
    '{"en": ["DISSOLVE into cosmic ocean - merge with universal ONE", "Surrender separateness completely - flow into unity", "Retreat into boundaryless cosmic water before individuating", "Meditate: what is ONE when all boundaries dissolve?"], "es": ["DISOLVETE en océano cósmico - fusiónate con UNO universal", "Rinde separación completamente - fluye hacia unidad", "Retírate a agua cósmica sin límites antes de individualizar", "Medita: ¿qué es UNO cuando todos los límites se disuelven?"], "ca": ["DISSOL-TE en oceà còsmic - fusiona''t amb U universal", "Rendeix separació completament - flueix cap a unitat", "Retira''t a aigua còsmica sense límits abans d''individualitzar", "Medita: què és U quan tots els límits es dissolen?"]}'::jsonb,
    '{"en": ["FREEZE feelings in sacred crystalline stillness", "Surrender emotional flow - preserve in frozen sanctuary", "Retreat into perfect ice-stillness before thawing", "Meditate: what is preserved when emotions freeze completely still?"], "es": ["CONGELA sentimientos en quietud cristalina sagrada", "Rinde flujo emocional - preserva en santuario congelado", "Retírate a quietud de hielo perfecta antes de descongelar", "Medita: ¿qué se preserva cuando las emociones se congelan completamente quietas?"], "ca": ["CONGELA sentiments en quietud cristal·lina sagrada", "Rendeix flux emocional - preserva en santuari congelat", "Retira''t a quietud de gel perfecta abans de descongelar", "Medita: què es preserva quan les emocions es congelen completament quietes?"]}'::jsonb
  ]);

-- =====================================================
-- COMPLETION COMMENT
-- =====================================================
-- ✅ ✅ ✅ ALL 128 SEASONAL OVERLAYS COMPLETE! ✅ ✅ ✅
-- 8 phases × 4 elements × 4 seasons = 128 total overlays
-- Modular lunar guide system content creation FINISHED!
