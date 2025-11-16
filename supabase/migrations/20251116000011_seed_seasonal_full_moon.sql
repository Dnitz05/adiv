-- =====================================================
-- SEED SEASONAL OVERLAYS: FULL MOON (16 overlays)
-- =====================================================
-- Phase: Full Moon (100% illuminated, complete fullness)
-- Energy: Peak, culmination, illumination, celebration, release
-- Overlays: 4 elements × 4 seasons = 16 total
--
-- Full Moon represents maximum power and visibility -
-- everything comes to light, culmination of intentions,
-- celebration of fullness, gratitude for harvest, and
-- release of what no longer serves.

-- =====================================================
-- FIRE ELEMENT × 4 SEASONS
-- =====================================================

-- 🔥 FULL MOON + FIRE + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'full_moon' AND element = 'fire' LIMIT 1),
  'spring',
  '{
    "en": "Spring Fire Explodes Into Maximum Radiant Glory",
    "es": "El Fuego de Primavera Explota en Gloria Radiante Máxima",
    "ca": "El Foc de Primavera Explota en Glòria Radiant Màxima"
  }'::jsonb,
  '{
    "en": "The full moon''s peak power meets spring''s explosive fullness. As Aries triumph (March-April) celebrates bold manifestation, illumination becomes unstoppable victory - your passionate vision stands in absolute radiant glory for ALL to see.",
    "es": "El poder máximo de la luna llena se encuentra con la plenitud explosiva de la primavera. Mientras el triunfo de Aries (marzo-abril) celebra la manifestación audaz, la iluminación se convierte en victoria imparable - tu visión apasionada se encuentra en gloria radiante absoluta para que TODOS la vean.",
    "ca": "El poder màxim de la lluna plena es troba amb la plenitud explosiva de la primavera. Mentre el triomf d''Àries (març-abril) celebra la manifestació audaç, la il·luminació es converteix en victòria imparable - la teva visió apassionada es troba en glòria radiant absoluta perquè TOTS la vegin."
  }'::jsonb,
  '{
    "en": "Fire''s peak blazes with spring''s renewal triumph. Everything you initiated now BURNS at maximum brilliance. Release hesitation - the maiden warrior stands victorious in full explosive light.",
    "es": "El pico del fuego arde con el triunfo renovador de la primavera. Todo lo que iniciaste ahora ARDE a máxima brillantez. Libera la vacilación - la guerrera doncella se encuentra victoriosa en plena luz explosiva.",
    "ca": "El pic del foc crema amb el triomf renovador de la primavera. Tot el que vas iniciar ara CREMA a màxima brillantor. Allibera la vacil·lació - la guerrera donzella es troba victoriosa en plena llum explosiva."
  }'::jsonb,
  '{
    "en": ["Aries triumph", "Explosive victory", "Maximum bold glory", "Maiden warrior-peak"],
    "es": ["Triunfo de Aries", "Victoria explosiva", "Gloria audaz máxima", "Pico de guerrera doncella"],
    "ca": ["Triomf d''Àries", "Victòria explosiva", "Glòria audaç màxima", "Pic de guerrera donzella"]
  }'::jsonb,
  '{
    "en": ["CELEBRATE your bold achievement with Aries triumph", "Release all doubt - stand in your victorious radiance", "Share your success LOUDLY - let everyone see your fire", "Gratitude for unstoppable courage that brought you HERE"],
    "es": ["CELEBRA tu logro audaz con triunfo de Aries", "Libera toda duda - permanece en tu radiancia victoriosa", "Comparte tu éxito EN VOZ ALTA - deja que todos vean tu fuego", "Gratitud por el coraje imparable que te trajo AQUÍ"],
    "ca": ["CELEBRA el teu assoliment audaç amb triomf d''Àries", "Allibera tot dubte - roman a la teva radiància victoriosa", "Comparteix el teu èxit EN VEU ALTA - deixa que tots vegin el teu foc", "Gratitud pel coratge imparable que et va portar AQUÍ"]
  }'::jsonb
);

-- 🔥 FULL MOON + FIRE + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'full_moon' AND element = 'fire' LIMIT 1),
  'summer',
  '{
    "en": "Summer''s Sovereign Fire Shines At Absolute Peak",
    "es": "El Fuego Soberano del Verano Brilla en Pico Absoluto",
    "ca": "El Foc Sobirà de l''Estiu Brilla a Pic Absolut"
  }'::jsonb,
  '{
    "en": "The full moon''s illumination meets summer''s radiant sovereignty. As Leo mastery (July-August) celebrates creative brilliance at peak, culmination becomes regal performance - you stand center stage in absolute confident glory.",
    "es": "La iluminación de la luna llena se encuentra con la soberanía radiante del verano. Mientras la maestría de Leo (julio-agosto) celebra la brillantez creativa en su pico, la culminación se convierte en actuación regia - permaneces en el centro del escenario en gloria confiada absoluta.",
    "ca": "La il·luminació de la lluna plena es troba amb la sobirania radiant de l''estiu. Mentre la mestria de Leo (juliol-agost) celebra la brillantor creativa al seu pic, la culminació es converteix en actuació règia - romanes al centre de l''escenari en glòria confiada absoluta."
  }'::jsonb,
  '{
    "en": "Fire''s peak burns with summer''s sovereign confidence. Your creative expression reaches maximum radiant brilliance. Release self-doubt - the mother''s child shines with deserved royal magnificence.",
    "es": "El pico del fuego arde con la confianza soberana del verano. Tu expresión creativa alcanza máxima brillantez radiante. Libera la duda - el hijo de la madre brilla con magnificencia real merecida.",
    "ca": "El pic del foc crema amb la confiança sobirana de l''estiu. La teva expressió creativa arriba a màxima brillantor radiant. Allibera el dubte - el fill de la mare brilla amb magnificència reial merescuda."
  }'::jsonb,
  '{
    "en": ["Leo sovereignty", "Creative peak brilliance", "Regal celebration", "Mother''s radiant child"],
    "es": ["Soberanía de Leo", "Brillantez de pico creativo", "Celebración regia", "Hijo radiante de madre"],
    "ca": ["Sobirania de Leo", "Brillantor de pic creatiu", "Celebració règia", "Fill radiant de mare"]
  }'::jsonb,
  '{
    "en": ["PERFORM your success with Leo confidence - you ARE royalty", "Release unworthiness - claim your deserved magnificence", "Celebrate creatively, joyfully, with FULL radiant expression", "Gratitude for the courage to shine at your absolute brightest"],
    "es": ["ACTÚA tu éxito con confianza de Leo - ERES realeza", "Libera la indignidad - reclama tu magnificencia merecida", "Celebra creativamente, gozosamente, con expresión radiante PLENA", "Gratitud por el coraje de brillar en tu máxima brillantez absoluta"],
    "ca": ["ACTUA el teu èxit amb confiança de Leo - ETS reialesa", "Allibera la indignitat - reclama la teva magnificència merescuda", "Celebra creativament, joiosament, amb expressió radiant PLENA", "Gratitud pel coratge de brillar a la teva màxima brillantor absoluta"]
  }'::jsonb
);

-- 🔥 FULL MOON + FIRE + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'full_moon' AND element = 'fire' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Fire Reveals Meaningful Harvest Fulfilled",
    "es": "El Fuego de Otoño Revela Cosecha Significativa Cumplida",
    "ca": "El Foc de Tardor Revela Collita Significativa Complerta"
  }'::jsonb,
  '{
    "en": "The full moon''s revelation meets autumn''s purposeful harvest. As Sagittarius wisdom (November-December) celebrates meaningful goals achieved, illumination becomes philosophical triumph - your vision manifested serves humanity''s highest purpose.",
    "es": "La revelación de la luna llena se encuentra con la cosecha propositiva del otoño. Mientras la sabiduría de Sagitario (noviembre-diciembre) celebra objetivos significativos alcanzados, la iluminación se convierte en triunfo filosófico - tu visión manifestada sirve el propósito más alto de la humanidad.",
    "ca": "La revelació de la lluna plena es troba amb la collita propositiva de la tardor. Mentre la saviesa de Sagitari (novembre-desembre) celebra objectius significatius assolits, la il·luminació es converteix en triomf filosòfic - la teva visió manifestada serveix el propòsit més alt de la humanitat."
  }'::jsonb,
  '{
    "en": "Fire''s peak illuminates autumn''s harvest wisdom. What you created MATTERS deeply and serves truth. Release empty achievements - the crone''s arrow hit the meaningful target.",
    "es": "El pico del fuego ilumina la sabiduría de cosecha del otoño. Lo que creaste IMPORTA profundamente y sirve a la verdad. Libera logros vacíos - la flecha de la anciana dio en el blanco significativo.",
    "ca": "El pic del foc il·lumina la saviesa de collita de la tardor. El que vas crear IMPORTA profundament i serveix la veritat. Allibera assoliments buits - la fletxa de l''anciana va donar al blanc significatiu."
  }'::jsonb,
  '{
    "en": ["Sagittarius wisdom-harvest", "Meaningful culmination", "Philosophical triumph", "Crone''s purposeful peak"],
    "es": ["Cosecha de sabiduría de Sagitario", "Culminación significativa", "Triunfo filosófico", "Pico propositivo de anciana"],
    "ca": ["Collita de saviesa de Sagitari", "Culminació significativa", "Triomf filosòfic", "Pic propositiu d''anciana"]
  }'::jsonb,
  '{
    "en": ["CELEBRATE how your achievement serves higher purpose", "Release surface success - honor DEEP meaningful impact", "Share your wisdom harvest with those who need it", "Gratitude for vision that created something truly MEANINGFUL"],
    "es": ["CELEBRA cómo tu logro sirve al propósito superior", "Libera éxito superficial - honra impacto PROFUNDO significativo", "Comparte tu cosecha de sabiduría con quienes la necesitan", "Gratitud por visión que creó algo verdaderamente SIGNIFICATIVO"],
    "ca": ["CELEBRA com el teu assoliment serveix al propòsit superior", "Allibera èxit superficial - honra impacte PROFUND significatiu", "Comparteix la teva collita de saviesa amb qui la necessita", "Gratitud per visió que va crear alguna cosa veritablement SIGNIFICATIVA"]
  }'::jsonb
);

-- 🔥 FULL MOON + FIRE + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'full_moon' AND element = 'fire' LIMIT 1),
  'winter',
  '{
    "en": "Winter Fire Reaches Mountain-Summit Mastery",
    "es": "El Fuego del Invierno Alcanza Maestría de Cumbre de Montaña",
    "ca": "El Foc de l''Hivern Arriba a Mestria de Cim de Muntanya"
  }'::jsonb,
  '{
    "en": "The full moon''s peak power meets winter''s structural completion. As Capricorn mastery (December-January) celebrates empire built with discipline, illumination becomes permanent achievement - you stand atop the mountain you patiently climbed.",
    "es": "El poder máximo de la luna llena se encuentra con la finalización estructural del invierno. Mientras la maestría de Capricornio (diciembre-enero) celebra el imperio construido con disciplina, la iluminación se convierte en logro permanente - permaneces en la cima de la montaña que pacientemente escalaste.",
    "ca": "El poder màxim de la lluna plena es troba amb la finalització estructural de l''hivern. Mentre la mestria de Capricorn (desembre-gener) celebra l''imperi construït amb disciplina, la il·luminació es converteix en assoliment permanent - romanes al cim de la muntanya que pacientment vas escalar."
  }'::jsonb,
  '{
    "en": "Fire''s peak stands solid as winter''s mountain summit. What you built endures FOREVER with geological permanence. Release temporary gains - the elder''s empire withstands all time.",
    "es": "El pico del fuego se mantiene sólido como la cumbre de montaña del invierno. Lo que construiste perdura PARA SIEMPRE con permanencia geológica. Libera ganancias temporales - el imperio del anciano resiste todo tiempo.",
    "ca": "El pic del foc es manté sòlid com el cim de muntanya de l''hivern. El que vas construir perdura PER SEMPRE amb permanència geològica. Allibera guanys temporals - l''imperi de l''ancià resisteix tot temps."
  }'::jsonb,
  '{
    "en": ["Capricorn empire-peak", "Permanent structural achievement", "Mountain-summit mastery", "Elder''s eternal completion"],
    "es": ["Pico de imperio de Capricornio", "Logro estructural permanente", "Maestría de cumbre de montaña", "Finalización eterna de anciano"],
    "ca": ["Pic d''imperi de Capricorn", "Assoliment estructural permanent", "Mestria de cim de muntanya", "Finalització eterna d''ancià"]
  }'::jsonb,
  '{
    "en": ["CELEBRATE the permanent foundations you built", "Release fleeting success - honor ENDURING achievement", "Stand tall on your mountain summit with earned authority", "Gratitude for discipline that created something ETERNAL"],
    "es": ["CELEBRA los cimientos permanentes que construiste", "Libera éxito fugaz - honra logro DURADERO", "Permanece alto en tu cumbre de montaña con autoridad ganada", "Gratitud por disciplina que creó algo ETERNO"],
    "ca": ["CELEBRA els fonaments permanents que vas construir", "Allibera èxit fugaç - honra assoliment DURADOR", "Roman alt al teu cim de muntanya amb autoritat guanyada", "Gratitud per disciplina que va crear alguna cosa ETERNA"]
  }'::jsonb
);

-- =====================================================
-- EARTH ELEMENT × 4 SEASONS
-- =====================================================

-- 🌍 FULL MOON + EARTH + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'full_moon' AND element = 'earth' LIMIT 1),
  'spring',
  '{
    "en": "Spring Earth Overflows With Sensory Abundance",
    "es": "La Tierra de Primavera Se Desborda Con Abundancia Sensorial",
    "ca": "La Terra de Primavera es Desborda Amb Abundància Sensorial"
  }'::jsonb,
  '{
    "en": "The full moon''s harvest peak meets spring''s explosive fertility. As Taurus abundance (April-May) celebrates tangible overflow, illumination becomes sensory feast - you can SEE, TOUCH, SMELL, TASTE the fullness blooming everywhere.",
    "es": "El pico de cosecha de la luna llena se encuentra con la fertilidad explosiva de la primavera. Mientras la abundancia de Tauro (abril-mayo) celebra el desbordamiento tangible, la iluminación se convierte en festín sensorial - puedes VER, TOCAR, OLER, PROBAR la plenitud floreciendo en todas partes.",
    "ca": "El pic de collita de la lluna plena es troba amb la fertilitat explosiva de la primavera. Mentre l''abundància de Taure (abril-maig) celebra el desbordament tangible, la il·luminació es converteix en festí sensorial - pots VEURE, TOCAR, OLORAR, PROVAR la plenitud florint a tot arreu."
  }'::jsonb,
  '{
    "en": "Earth''s harvest overflows with spring''s maiden abundance. TANGIBLE results bloom visibly everywhere at once. Release scarcity - fertility provides more than you can hold.",
    "es": "La cosecha de la tierra se desborda con la abundancia doncella de la primavera. Resultados TANGIBLES florecen visiblemente en todas partes a la vez. Libera escasez - la fertilidad provee más de lo que puedes sostener.",
    "ca": "La collita de la terra es desborda amb l''abundància donzella de la primavera. Resultats TANGIBLES floreixen visiblement a tot arreu alhora. Allibera escassetat - la fertilitat proveeix més del que pots sostenir."
  }'::jsonb,
  '{
    "en": ["Taurus overflow", "Sensory abundance-peak", "Tangible bloom fullness", "Maiden fertility-harvest"],
    "es": ["Desbordamiento de Tauro", "Pico de abundancia sensorial", "Plenitud de floración tangible", "Cosecha de fertilidad doncella"],
    "ca": ["Desbordament de Taure", "Pic d''abundància sensorial", "Plenitud de floració tangible", "Collita de fertilitat donzella"]
  }'::jsonb,
  '{
    "en": ["CELEBRATE with physical sensory pleasure - feast your senses", "Release lack - spring provides VISIBLE overflowing abundance", "Share your tangible harvest - there''s MORE than enough", "Gratitude for fertile earth that bloomed beyond all containers"],
    "es": ["CELEBRA con placer sensorial físico - festeja tus sentidos", "Libera carencia - la primavera provee abundancia visible desbordante", "Comparte tu cosecha tangible - hay MÁS que suficiente", "Gratitud por tierra fértil que floreció más allá de todos los contenedores"],
    "ca": ["CELEBRA amb plaer sensorial físic - festeja els teus sentits", "Allibera mancança - la primavera proveeix abundància visible desbordant", "Comparteix la teva collita tangible - hi ha MÉS que suficient", "Gratitud per terra fèrtil que va florir més enllà de tots els contenidors"]
  }'::jsonb
);

-- 🌍 FULL MOON + EARTH + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'full_moon' AND element = 'earth' LIMIT 1),
  'summer',
  '{
    "en": "Summer Earth Perfects To Flawless Completion",
    "es": "La Tierra de Verano Se Perfecciona Hasta Finalización Impecable",
    "ca": "La Terra d''Estiu es Perfecciona Fins a Finalització Impecable"
  }'::jsonb,
  '{
    "en": "The full moon''s perfect illumination meets summer''s meticulous care. As Virgo devotion (August-September) celebrates flawless completion, harvest becomes precision masterpiece - every detail attended with loving perfection.",
    "es": "La iluminación perfecta de la luna llena se encuentra con el cuidado meticuloso del verano. Mientras la devoción de Virgo (agosto-septiembre) celebra la finalización impecable, la cosecha se convierte en obra maestra de precisión - cada detalle atendido con perfección amorosa.",
    "ca": "La il·luminació perfecta de la lluna plena es troba amb la cura meticulosa de l''estiu. Mentre la devoció de Verge (agost-setembre) celebra la finalització impecable, la collita es converteix en obra mestra de precisió - cada detall atès amb perfecció amorosa."
  }'::jsonb,
  '{
    "en": "Earth''s harvest reaches summer''s mother perfection. Every tiny detail shines with devoted care. Release good-enough - your work achieved FLAWLESS completion.",
    "es": "La cosecha de la tierra alcanza la perfección maternal del verano. Cada pequeño detalle brilla con cuidado devoto. Libera lo suficientemente bueno - tu trabajo logró finalización IMPECABLE.",
    "ca": "La collita de la terra arriba a la perfecció maternal de l''estiu. Cada petit detall brilla amb cura devota. Allibera prou bo - el teu treball va aconseguir finalització IMPECABLE."
  }'::jsonb,
  '{
    "en": ["Virgo perfection-harvest", "Flawless devoted completion", "Precision masterpiece", "Mother''s meticulous peak"],
    "es": ["Cosecha de perfección de Virgo", "Finalización devota impecable", "Obra maestra de precisión", "Pico meticuloso de madre"],
    "ca": ["Collita de perfecció de Verge", "Finalització devota impecable", "Obra mestra de precisió", "Pic meticulós de mare"]
  }'::jsonb,
  '{
    "en": ["CELEBRATE every perfect detail with Virgo pride", "Release self-criticism - acknowledge FLAWLESS completion", "Share your meticulous masterpiece with devoted joy", "Gratitude for loving care that perfected every element"],
    "es": ["CELEBRA cada detalle perfecto con orgullo de Virgo", "Libera autocrítica - reconoce finalización IMPECABLE", "Comparte tu obra maestra meticulosa con alegría devota", "Gratitud por cuidado amoroso que perfeccionó cada elemento"],
    "ca": ["CELEBRA cada detall perfecte amb orgull de Verge", "Allibera autocrítica - reconeix finalització IMPECABLE", "Comparteix la teva obra mestra meticulosa amb alegria devota", "Gratitud per cura amorosa que va perfeccionar cada element"]
  }'::jsonb
);

-- 🌍 FULL MOON + EARTH + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'full_moon' AND element = 'earth' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Earth Reaps Maximum Abundant Harvest",
    "es": "La Tierra de Otoño Cosecha Abundancia Máxima",
    "ca": "La Terra de Tardor Cull Abundància Màxima"
  }'::jsonb,
  '{
    "en": "The full moon''s harvest celebration meets autumn''s peak reaping. As Capricorn mastery (December-January) gathers resources with shrewd wisdom, illumination becomes wealth-manifestation - every strategic effort yields abundant tangible return.",
    "es": "La celebración de cosecha de la luna llena se encuentra con la cosecha máxima del otoño. Mientras la maestría de Capricornio (diciembre-enero) reúne recursos con sabiduría astuta, la iluminación se convierte en manifestación de riqueza - cada esfuerzo estratégico produce retorno tangible abundante.",
    "ca": "La celebració de collita de la lluna plena es troba amb la collita màxima de la tardor. Mentre la mestria de Capricorn (desembre-gener) reuneix recursos amb saviesa astuta, la il·luminació es converteix en manifestació de riquesa - cada esforç estratègic produeix retorn tangible abundant."
  }'::jsonb,
  '{
    "en": "Earth''s harvest peaks with autumn''s crone abundance-wisdom. Strategic planning yielded MAXIMUM return. Release waste - reap exactly what you wisely sowed.",
    "es": "La cosecha de la tierra alcanza su pico con la sabiduría de abundancia anciana del otoño. La planificación estratégica produjo retorno MÁXIMO. Libera desperdicio - cosecha exactamente lo que sabiamente sembraste.",
    "ca": "La collita de la terra arriba al seu pic amb la saviesa d''abundància anciana de la tardor. La planificació estratègica va produir retorn MÀXIM. Allibera malbaratament - cull exactament el que sàviament vas sembrar."
  }'::jsonb,
  '{
    "en": ["Capricorn abundance-mastery", "Strategic harvest-peak", "Maximum resource-return", "Crone''s wealth-wisdom"],
    "es": ["Maestría de abundancia de Capricornio", "Pico de cosecha estratégica", "Retorno de recursos máximo", "Sabiduría de riqueza de anciana"],
    "ca": ["Mestria d''abundància de Capricorn", "Pic de collita estratègica", "Retorn de recursos màxim", "Saviesa de riquesa d''anciana"]
  }'::jsonb,
  '{
    "en": ["CELEBRATE abundant return on your strategic investments", "Release hoarding - share harvest wealth generously", "Gather resources with gratitude for shrewd planning", "Honor the crone wisdom that maximized every effort"],
    "es": ["CELEBRA retorno abundante en tus inversiones estratégicas", "Libera acumulación - comparte riqueza de cosecha generosamente", "Reúne recursos con gratitud por planificación astuta", "Honra la sabiduría de anciana que maximizó cada esfuerzo"],
    "ca": ["CELEBRA retorn abundant a les teves inversions estratègiques", "Allibera acumulació - comparteix riquesa de collita generosament", "Reuneix recursos amb gratitud per planificació astuta", "Honra la saviesa d''anciana que va maximitzar cada esforç"]
  }'::jsonb
);

-- 🌍 FULL MOON + EARTH + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'full_moon' AND element = 'earth' LIMIT 1),
  'winter',
  '{
    "en": "Winter''s Deep Roots Reveal Hidden Strength",
    "es": "Las Raíces Profundas del Invierno Revelan Fuerza Oculta",
    "ca": "Les Arrels Profundes de l''Hivern Revelen Força Oculta"
  }'::jsonb,
  '{
    "en": "The full moon''s revealing light meets winter''s underground completion. As Taurus endurance (April-May) illuminates invisible foundations, harvest becomes depth-revelation - roots you patiently built now show their IMMENSE hidden strength.",
    "es": "La luz reveladora de la luna llena se encuentra con la finalización subterránea del invierno. Mientras la resistencia de Tauro (abril-mayo) ilumina cimientos invisibles, la cosecha se convierte en revelación de profundidad - las raíces que pacientemente construiste ahora muestran su fuerza oculta INMENSA.",
    "ca": "La llum reveladora de la lluna plena es troba amb la finalització subterrània de l''hivern. Mentre la resistència de Taure (abril-maig) il·lumina fonaments invisibles, la collita es converteix en revelació de profunditat - les arrels que pacientment vas construir ara mostren la seva força oculta IMMENSA."
  }'::jsonb,
  '{
    "en": "Earth''s harvest illuminates winter''s elder depths. Invisible foundations reveal GEOLOGICAL permanence. Release surface success - your deepest roots anchor ETERNALLY.",
    "es": "La cosecha de la tierra ilumina las profundidades ancianas del invierno. Los cimientos invisibles revelan permanencia GEOLÓGICA. Libera éxito superficial - tus raíces más profundas anclan ETERNAMENTE.",
    "ca": "La collita de la terra il·lumina les profunditats ancianes de l''hivern. Els fonaments invisibles revelen permanència GEOLÒGICA. Allibera èxit superficial - les teves arrels més profundes ancoren ETERNAMENT."
  }'::jsonb,
  '{
    "en": ["Taurus depth-revelation", "Invisible root-harvest", "Geological foundation-peak", "Elder''s underground completion"],
    "es": ["Revelación de profundidad de Tauro", "Cosecha de raíz invisible", "Pico de cimiento geológico", "Finalización subterránea de anciano"],
    "ca": ["Revelació de profunditat de Taure", "Collita d''arrel invisible", "Pic de fonament geològic", "Finalització subterrània d''ancià"]
  }'::jsonb,
  '{
    "en": ["CELEBRATE foundations that will endure FOREVER", "Release flashy achievement - honor DEEP eternal anchoring", "Illuminate your invisible roots with proud revelation", "Gratitude for patience that built geological permanence"],
    "es": ["CELEBRA cimientos que perdurarán PARA SIEMPRE", "Libera logro llamativo - honra anclaje PROFUNDO eterno", "Ilumina tus raíces invisibles con revelación orgullosa", "Gratitud por paciencia que construyó permanencia geológica"],
    "ca": ["CELEBRA fonaments que perduraran PER SEMPRE", "Allibera assoliment cridaner - honra ancoratge PROFUND etern", "Il·lumina les teves arrels invisibles amb revelació orgullosa", "Gratitud per paciència que va construir permanència geològica"]
  }'::jsonb
);

-- =====================================================
-- AIR ELEMENT × 4 SEASONS
-- =====================================================

-- 💨 FULL MOON + AIR + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'full_moon' AND element = 'air' LIMIT 1),
  'spring',
  '{
    "en": "Spring Winds Carry Ideas To Universal Connection",
    "es": "Los Vientos de Primavera Llevan Ideas a Conexión Universal",
    "ca": "Els Vents de Primavera Porten Idees a Connexió Universal"
  }'::jsonb,
  '{
    "en": "The full moon''s peak communication meets spring''s explosive social bloom. As Gemini curiosity (May-June) celebrates ideas pollinating everywhere, illumination becomes network-activation - your vision connects ALL minds at once.",
    "es": "La comunicación máxima de la luna llena se encuentra con el florecimiento social explosivo de la primavera. Mientras la curiosidad de Géminis (mayo-junio) celebra ideas polinizando en todas partes, la iluminación se convierte en activación de red - tu visión conecta TODAS las mentes a la vez.",
    "ca": "La comunicació màxima de la lluna plena es troba amb el floriment social explosiu de la primavera. Mentre la curiositat de Bessons (maig-juny) celebra idees pol·linitzant a tot arreu, la il·luminació es converteix en activació de xarxa - la teva visió connecta TOTES les ments alhora."
  }'::jsonb,
  '{
    "en": "Air''s network peaks with spring''s maiden communication-surge. Ideas spread EVERYWHERE simultaneously through playful connection. Release isolation - your voice reaches ALL ears.",
    "es": "La red del aire alcanza su pico con la oleada de comunicación doncella de la primavera. Las ideas se esparcen EN TODAS PARTES simultáneamente a través de conexión juguetona. Libera aislamiento - tu voz alcanza TODOS los oídos.",
    "ca": "La xarxa de l''aire arriba al seu pic amb l''onada de comunicació donzella de la primavera. Les idees s''escampen A TOT ARREU simultàniament a través de connexió joganera. Allibera aïllament - la teva veu arriba a TOTES les orelles."
  }'::jsonb,
  '{
    "en": ["Gemini network-peak", "Universal idea-pollination", "Playful connection-explosion", "Maiden communication-bloom"],
    "es": ["Pico de red de Géminis", "Polinización universal de ideas", "Explosión de conexión juguetona", "Florecimiento de comunicación doncella"],
    "ca": ["Pic de xarxa de Bessons", "Pol·linització universal d''idees", "Explosió de connexió joganera", "Floriment de comunicació donzella"]
  }'::jsonb,
  '{
    "en": ["CELEBRATE how your ideas connected EVERYONE", "Release private thinking - share wisdom WIDELY and playfully", "Watch your network activate with explosive spring joy", "Gratitude for curiosity that pollinated universal minds"],
    "es": ["CELEBRA cómo tus ideas conectaron a TODOS", "Libera pensamiento privado - comparte sabiduría AMPLIAMENTE y juguetonamente", "Observa tu red activarse con explosiva alegría primaveral", "Gratitud por curiosidad que polinizó mentes universales"],
    "ca": ["CELEBRA com les teves idees van connectar TOTHOM", "Allibera pensament privat - comparteix saviesa ÀMPLIAMENT i joganerament", "Observa la teva xarxa activar-se amb explosiva alegria primaveral", "Gratitud per curiositat que va pol·linitzar ments universals"]
  }'::jsonb
);

-- 💨 FULL MOON + AIR + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'full_moon' AND element = 'air' LIMIT 1),
  'summer',
  '{
    "en": "Summer Breezes Celebrate Perfect Harmonious Balance",
    "es": "Las Brisas de Verano Celebran Equilibrio Armonioso Perfecto",
    "ca": "Les Brises d''Estiu Celebren Equilibri Harmoniós Perfecte"
  }'::jsonb,
  '{
    "en": "The full moon''s partnership peak meets summer''s diplomatic grace. As Libra balance (September-October) celebrates beautiful collaboration, illumination becomes reciprocal-perfection - relationships shine in absolute harmonious fullness.",
    "es": "El pico de asociación de la luna llena se encuentra con la gracia diplomática del verano. Mientras el equilibrio de Libra (septiembre-octubre) celebra la colaboración hermosa, la iluminación se convierte en perfección recíproca - las relaciones brillan en plenitud armoniosa absoluta.",
    "ca": "El pic d''associació de la lluna plena es troba amb la gràcia diplomàtica de l''estiu. Mentre l''equilibri de Balança (setembre-octubre) celebra la col·laboració bella, la il·luminació es converteix en perfecció recíproca - les relacions brillen en plenitud harmoniosa absoluta."
  }'::jsonb,
  '{
    "en": "Air''s collaboration reaches summer''s mother balance-perfection. Partnerships bloom in BEAUTIFUL mutual fullness. Release one-sided effort - celebrate TRUE reciprocity.",
    "es": "La colaboración del aire alcanza la perfección de equilibrio maternal del verano. Las asociaciones florecen en plenitud mutua HERMOSA. Libera esfuerzo unilateral - celebra reciprocidad VERDADERA.",
    "ca": "La col·laboració de l''aire arriba a la perfecció d''equilibri maternal de l''estiu. Les associacions floreixen en plenitud mútua BELLA. Allibera esforç unilateral - celebra reciprocitat VERITABLE."
  }'::jsonb,
  '{
    "en": ["Libra partnership-peak", "Harmonious balance-perfection", "Beautiful reciprocal fullness", "Mother''s diplomatic grace"],
    "es": ["Pico de asociación de Libra", "Perfección de equilibrio armonioso", "Plenitud recíproca hermosa", "Gracia diplomática de madre"],
    "ca": ["Pic d''associació de Balança", "Perfecció d''equilibri harmoniós", "Plenitud recíproca bella", "Gràcia diplomàtica de mare"]
  }'::jsonb,
  '{
    "en": ["CELEBRATE beautiful balanced partnerships with grace", "Release inequality - honor MUTUAL reciprocal fullness", "Share collaborative joy in harmonious exchange", "Gratitude for Libra diplomacy that created perfect balance"],
    "es": ["CELEBRA asociaciones hermosas equilibradas con gracia", "Libera desigualdad - honra plenitud recíproca MUTUA", "Comparte alegría colaborativa en intercambio armonioso", "Gratitud por diplomacia de Libra que creó equilibrio perfecto"],
    "ca": ["CELEBRA associacions belles equilibrades amb gràcia", "Allibera desigualtat - honra plenitud recíproca MÚTUA", "Comparteix alegria col·laborativa en intercanvi harmoniós", "Gratitud per diplomàcia de Balança que va crear equilibri perfecte"]
  }'::jsonb
);

-- 💨 FULL MOON + AIR + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'full_moon' AND element = 'air' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Air Activates Revolutionary Collective Awakening",
    "es": "El Aire de Otoño Activa Despertar Colectivo Revolucionario",
    "ca": "L''Aire de Tardor Activa Despertar Col·lectiu Revolucionari"
  }'::jsonb,
  '{
    "en": "The full moon''s illumination meets autumn''s visionary breakthrough. As Aquarius evolution (January-February) celebrates collective networks activated, culmination becomes humanity-leap - your vision sparked REVOLUTIONARY change for ALL.",
    "es": "La iluminación de la luna llena se encuentra con el avance visionario del otoño. Mientras la evolución de Acuario (enero-febrero) celebra redes colectivas activadas, la culminación se convierte en salto de humanidad - tu visión desencadenó cambio REVOLUCIONARIO para TODOS.",
    "ca": "La il·luminació de la lluna plena es troba amb l''avenç visionari de la tardor. Mentre l''evolució d''Aquari (gener-febrer) celebra xarxes col·lectives activades, la culminació es converteix en salt d''humanitat - la teva visió va desencadenar canvi REVOLUCIONARI per a TOTS."
  }'::jsonb,
  '{
    "en": "Air''s network reaches autumn''s crone revolutionary peak. Collective systems EVOLVED through your vision. Release personal gain - celebrate HUMANITY''S advancement.",
    "es": "La red del aire alcanza el pico revolucionario de la anciana del otoño. Los sistemas colectivos EVOLUCIONARON a través de tu visión. Libera ganancia personal - celebra el avance de la HUMANIDAD.",
    "ca": "La xarxa de l''aire arriba al pic revolucionari de l''anciana de la tardor. Els sistemes col·lectius van EVOLUCIONAR a través de la teva visió. Allibera guany personal - celebra l''avenç de la HUMANITAT."
  }'::jsonb,
  '{
    "en": ["Aquarius revolution-peak", "Collective awakening-activation", "Visionary evolutionary leap", "Crone''s humanity-transformation"],
    "es": ["Pico de revolución de Acuario", "Activación de despertar colectivo", "Salto evolutivo visionario", "Transformación de humanidad de anciana"],
    "ca": ["Pic de revolució d''Aquari", "Activació de despertar col·lectiu", "Salt evolutiu visionari", "Transformació d''humanitat d''anciana"]
  }'::jsonb,
  '{
    "en": ["CELEBRATE how your vision served collective evolution", "Release ego-achievement - honor HUMANITY''S revolutionary leap", "Watch systems transform with visionary Aquarius joy", "Gratitude for innovation that advanced ALL beings"],
    "es": ["CELEBRA cómo tu visión sirvió a la evolución colectiva", "Libera logro de ego - honra el salto revolucionario de la HUMANIDAD", "Observa sistemas transformarse con alegría visionaria de Acuario", "Gratitud por innovación que avanzó a TODOS los seres"],
    "ca": ["CELEBRA com la teva visió va servir l''evolució col·lectiva", "Allibera assoliment d''ego - honra el salt revolucionari de la HUMANITAT", "Observa sistemes transformar-se amb alegria visionària d''Aquari", "Gratitud per innovació que va avançar TOTS els éssers"]
  }'::jsonb
);

-- 💨 FULL MOON + AIR + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'full_moon' AND element = 'air' LIMIT 1),
  'winter',
  '{
    "en": "Winter Silence Reveals Diamond-Perfect Truth",
    "es": "El Silencio del Invierno Revela Verdad Perfecta Como Diamante",
    "ca": "El Silenci de l''Hivern Revela Veritat Perfecta Com Diamant"
  }'::jsonb,
  '{
    "en": "The full moon''s complete illumination meets winter''s crystalline clarity. As Gemini contemplation (May-June) celebrates absolute understanding, revelation becomes diamond-knowing - thought crystallized to its purest, clearest, most brilliant truth.",
    "es": "La iluminación completa de la luna llena se encuentra con la claridad cristalina del invierno. Mientras la contemplación de Géminis (mayo-junio) celebra la comprensión absoluta, la revelación se convierte en conocimiento de diamante - pensamiento cristalizado a su verdad más pura, clara y brillante.",
    "ca": "La il·luminació completa de la lluna plena es troba amb la claredat cristal·lina de l''hivern. Mentre la contemplació de Bessons (maig-juny) celebra la comprensió absoluta, la revelació es converteix en coneixement de diamant - pensament cristal·litzat a la seva veritat més pura, clara i brillant."
  }'::jsonb,
  '{
    "en": "Air''s understanding reaches winter''s elder clarity-perfection. Silent contemplation revealed ABSOLUTE truth. Release confusion - celebrate diamond-hard knowing.",
    "es": "La comprensión del aire alcanza la perfección de claridad anciana del invierno. La contemplación silenciosa reveló verdad ABSOLUTA. Libera confusión - celebra conocimiento duro como diamante.",
    "ca": "La comprensió de l''aire arriba a la perfecció de claredat anciana de l''hivern. La contemplació silenciosa va revelar veritat ABSOLUTA. Allibera confusió - celebra coneixement dur com diamant."
  }'::jsonb,
  '{
    "en": ["Gemini clarity-peak", "Diamond-truth revelation", "Silent absolute knowing", "Elder''s crystalline perfection"],
    "es": ["Pico de claridad de Géminis", "Revelación de verdad de diamante", "Conocimiento absoluto silencioso", "Perfección cristalina de anciano"],
    "ca": ["Pic de claredat de Bessons", "Revelació de veritat de diamant", "Coneixement absolut silenciós", "Perfecció cristal·lina d''ancià"]
  }'::jsonb,
  '{
    "en": ["CELEBRATE absolute truth that silence revealed", "Release uncertainty - stand in diamond-hard clarity", "Share your crystallized wisdom with quiet certainty", "Gratitude for contemplation that revealed perfect understanding"],
    "es": ["CELEBRA la verdad absoluta que el silencio reveló", "Libera incertidumbre - permanece en claridad dura como diamante", "Comparte tu sabiduría cristalizada con certeza silenciosa", "Gratitud por contemplación que reveló comprensión perfecta"],
    "ca": ["CELEBRA la veritat absoluta que el silenci va revelar", "Allibera incertesa - roman a claredat dura com diamant", "Comparteix la teva saviesa cristal·litzada amb certesa silenciosa", "Gratitud per contemplació que va revelar comprensió perfecta"]
  }'::jsonb
);

-- =====================================================
-- WATER ELEMENT × 4 SEASONS
-- =====================================================

-- 💧 FULL MOON + WATER + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'full_moon' AND element = 'water' LIMIT 1),
  'spring',
  '{
    "en": "Spring Waters Overflow With Heart-Fullness",
    "es": "Las Aguas de Primavera Se Desbordan Con Plenitud de Corazón",
    "ca": "Les Aigües de Primavera es Desborden Amb Plenitud de Cor"
  }'::jsonb,
  '{
    "en": "The full moon''s emotional peak meets spring''s heart-blooming explosion. As Cancer nurturing (June-July) celebrates vulnerable connection-fullness, illumination becomes emotional-overflow - feelings bloom beyond all containers in brave maiden openness.",
    "es": "El pico emocional de la luna llena se encuentra con la explosión de florecimiento de corazón de la primavera. Mientras el cuidado de Cáncer (junio-julio) celebra la plenitud de conexión vulnerable, la iluminación se convierte en desbordamiento emocional - los sentimientos florecen más allá de todos los contenedores en apertura valiente de doncella.",
    "ca": "El pic emocional de la lluna plena es troba amb l''explosió de floriment de cor de la primavera. Mentre la cura de Cranc (juny-juliol) celebra la plenitud de connexió vulnerable, la il·luminació es converteix en desbordament emocional - els sentiments floreixen més enllà de tots els contenidors en obertura valenta de donzella."
  }'::jsonb,
  '{
    "en": "Water''s emotional fullness overflows with spring''s maiden heart-courage. Vulnerable intimacy blooms EVERYWHERE at once. Release emotional holding - let love FLOOD freely.",
    "es": "La plenitud emocional del agua se desborda con el coraje de corazón doncella de la primavera. La intimidad vulnerable florece EN TODAS PARTES a la vez. Libera contención emocional - deja que el amor FLUYA libremente.",
    "ca": "La plenitud emocional de l''aigua es desborda amb el coratge de cor donzella de la primavera. La intimitat vulnerable floreix A TOT ARREU alhora. Allibera contenció emocional - deixa que l''amor FLUEIXI lliurement."
  }'::jsonb,
  '{
    "en": ["Cancer heart-peak", "Vulnerable overflow-bloom", "Emotional courage-fullness", "Maiden intimacy-explosion"],
    "es": ["Pico de corazón de Cáncer", "Floración de desbordamiento vulnerable", "Plenitud de coraje emocional", "Explosión de intimidad doncella"],
    "ca": ["Pic de cor de Cranc", "Floració de desbordament vulnerable", "Plenitud de coratge emocional", "Explosió d''intimitat donzella"]
  }'::jsonb,
  '{
    "en": ["CELEBRATE emotional fullness with brave vulnerability", "Release heart-protection - let feelings OVERFLOW freely", "Share love abundantly - there''s MORE than enough", "Gratitude for courage that opened your heart completely"],
    "es": ["CELEBRA la plenitud emocional con vulnerabilidad valiente", "Libera protección de corazón - deja que los sentimientos SE DESBORDEN libremente", "Comparte amor abundantemente - hay MÁS que suficiente", "Gratitud por coraje que abrió tu corazón completamente"],
    "ca": ["CELEBRA la plenitud emocional amb vulnerabilitat valenta", "Allibera protecció de cor - deixa que els sentiments ES DESBORDIN lliurement", "Comparteix amor abundantment - hi ha MÉS que suficient", "Gratitud pel coratge que va obrir el teu cor completament"]
  }'::jsonb
);

-- 💧 FULL MOON + WATER + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'full_moon' AND element = 'water' LIMIT 1),
  'summer',
  '{
    "en": "Summer''s Intense Waters Complete Soul-Rebirth",
    "es": "Las Aguas Intensas del Verano Completan Renacimiento del Alma",
    "ca": "Les Aigües Intenses de l''Estiu Completen Renaixement de l''Ànima"
  }'::jsonb,
  '{
    "en": "The full moon''s transformative illumination meets summer''s alchemical completion. As Scorpio intensity (October-November) celebrates soul-level metamorphosis, peak becomes rebirth-revelation - you emerged fundamentally NEW from the emotional crucible.",
    "es": "La iluminación transformativa de la luna llena se encuentra con la finalización alquímica del verano. Mientras la intensidad de Escorpio (octubre-noviembre) celebra la metamorfosis a nivel del alma, el pico se convierte en revelación de renacimiento - emergiste fundamentalmente NUEVO del crisol emocional.",
    "ca": "La il·luminació transformativa de la lluna plena es troba amb la finalització alquímica de l''estiu. Mentre la intensitat d''Escorpí (octubre-novembre) celebra la metamorfosi a nivell de l''ànima, el pic es converteix en revelació de renaixement - vas emergir fonamentalment NOU del gresol emocional."
  }'::jsonb,
  '{
    "en": "Water''s transformation completes with summer''s mother alchemy-peak. You are REBORN at the heart level. Release old identity - celebrate your NEW transformed self.",
    "es": "La transformación del agua se completa con el pico de alquimia maternal del verano. RENACISTE a nivel del corazón. Libera identidad antigua - celebra tu YO transformado NUEVO.",
    "ca": "La transformació de l''aigua es completa amb el pic d''alquímia maternal de l''estiu. VAS RENÉIXER a nivell del cor. Allibera identitat antiga - celebra el teu JO transformat NOU."
  }'::jsonb,
  '{
    "en": ["Scorpio rebirth-peak", "Alchemical soul-completion", "Transformative revelation", "Mother''s metamorphic fullness"],
    "es": ["Pico de renacimiento de Escorpio", "Finalización de alma alquímica", "Revelación transformativa", "Plenitud metamórfica de madre"],
    "ca": ["Pic de renaixement d''Escorpí", "Finalització d''ànima alquímica", "Revelació transformativa", "Plenitud metamòrfica de mare"]
  }'::jsonb,
  '{
    "en": ["CELEBRATE your complete soul-level rebirth", "Release who you WERE - honor who you''ve BECOME", "Share your transformation story with passionate truth", "Gratitude for intensity that alchemized you completely"],
    "es": ["CELEBRA tu renacimiento completo a nivel del alma", "Libera quién ERAS - honra en quién te HAS CONVERTIDO", "Comparte tu historia de transformación con verdad apasionada", "Gratitud por intensidad que te alquimizó completamente"],
    "ca": ["CELEBRA el teu renaixement complet a nivell de l''ànima", "Allibera qui ERES - honra en qui t''HAS CONVERTIT", "Comparteix la teva història de transformació amb veritat apassionada", "Gratitud per intensitat que et va alquimitzar completament"]
  }'::jsonb
);

-- 💧 FULL MOON + WATER + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'full_moon' AND element = 'water' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Waters Merge Into Cosmic Unity",
    "es": "Las Aguas de Otoño Se Fusionan en Unidad Cósmica",
    "ca": "Les Aigües de Tardor es Fusionen en Unitat Còsmica"
  }'::jsonb,
  '{
    "en": "The full moon''s complete illumination meets autumn''s mystical dissolution. As Pisces compassion (February-March) celebrates boundaryless unity, peak becomes cosmic-merging - all hearts recognized as ONE infinite ocean of feeling.",
    "es": "La iluminación completa de la luna llena se encuentra con la disolución mística del otoño. Mientras la compasión de Piscis (febrero-marzo) celebra la unidad sin límites, el pico se convierte en fusión cósmica - todos los corazones reconocidos como UN océano infinito de sentimiento.",
    "ca": "La il·luminació completa de la lluna plena es troba amb la dissolució mística de la tardor. Mentre la compassió de Peixos (febrer-març) celebra la unitat sense límits, el pic es converteix en fusió còsmica - tots els cors reconeguts com UN oceà infinit de sentiment."
  }'::jsonb,
  '{
    "en": "Water''s empathy reaches autumn''s crone mystical-unity. All separation DISSOLVED into universal love. Release individual heart - celebrate the ONE cosmic ocean.",
    "es": "La empatía del agua alcanza la unidad mística de la anciana del otoño. Toda separación SE DISOLVIÓ en amor universal. Libera corazón individual - celebra el océano cósmico UNO.",
    "ca": "L''empatia de l''aigua arriba a la unitat mística de l''anciana de la tardor. Tota separació ES VA DISSOLDRE en amor universal. Allibera cor individual - celebra l''oceà còsmic U."
  }'::jsonb,
  '{
    "en": ["Pisces unity-peak", "Boundary-dissolving completion", "Mystical cosmic-merging", "Crone''s universal ocean"],
    "es": ["Pico de unidad de Piscis", "Finalización de disolución de límites", "Fusión cósmica mística", "Océano universal de anciana"],
    "ca": ["Pic d''unitat de Peixos", "Finalització de dissolució de límits", "Fusió còsmica mística", "Oceà universal d''anciana"]
  }'::jsonb,
  '{
    "en": ["CELEBRATE oneness with ALL feeling beings", "Release separation - recognize universal heart-unity", "Share boundaryless compassion with mystical certainty", "Gratitude for empathy that dissolved you into cosmic love"],
    "es": ["CELEBRA la unidad con TODOS los seres sintientes", "Libera separación - reconoce unidad de corazón universal", "Comparte compasión sin límites con certeza mística", "Gratitud por empatía que te disolvió en amor cósmico"],
    "ca": ["CELEBRA la unitat amb TOTS els éssers sentients", "Allibera separació - reconeix unitat de cor universal", "Comparteix compassió sense límits amb certesa mística", "Gratitud per empatia que et va dissoldre en amor còsmic"]
  }'::jsonb
);

-- 💧 FULL MOON + WATER + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'full_moon' AND element = 'water' LIMIT 1),
  'winter',
  '{
    "en": "Winter''s Sacred Sanctuary Holds Deepest Intimacy",
    "es": "El Santuario Sagrado del Invierno Contiene Intimidad Más Profunda",
    "ca": "El Santuari Sagrat de l''Hivern Conté Intimitat Més Profunda"
  }'::jsonb,
  '{
    "en": "The full moon''s trust-illumination meets winter''s sheltered devotion-peak. As Cancer protection (June-July) celebrates sacred emotional containers perfected, fullness becomes sanctuary-completion - the deepest most precious vulnerability blooms in absolute safety.",
    "es": "La iluminación de confianza de la luna llena se encuentra con el pico de devoción protegida del invierno. Mientras la protección de Cáncer (junio-julio) celebra contenedores emocionales sagrados perfeccionados, la plenitud se convierte en finalización de santuario - la vulnerabilidad más profunda y preciosa florece en seguridad absoluta.",
    "ca": "La il·luminació de confiança de la lluna plena es troba amb el pic de devoció protegida de l''hivern. Mentre la protecció de Cranc (juny-juliol) celebra contenidors emocionals sagrats perfeccionats, la plenitud es converteix en finalització de santuari - la vulnerabilitat més profunda i preciosa floreix en seguretat absoluta."
  }'::jsonb,
  '{
    "en": "Water''s intimacy reaches winter''s elder sanctuary-perfection. Sacred trust created ABSOLUTE emotional safety. Release fear - celebrate the sheltered depths you co-created.",
    "es": "La intimidad del agua alcanza la perfección de santuario anciana del invierno. La confianza sagrada creó seguridad emocional ABSOLUTA. Libera miedo - celebra las profundidades protegidas que co-creaste.",
    "ca": "La intimitat de l''aigua arriba a la perfecció de santuari ancià de l''hivern. La confiança sagrada va crear seguretat emocional ABSOLUTA. Allibera por - celebra les profunditats protegides que vas co-crear."
  }'::jsonb,
  '{
    "en": ["Cancer sanctuary-peak", "Sacred intimacy-completion", "Absolute trust-fullness", "Elder''s sheltered devotion"],
    "es": ["Pico de santuario de Cáncer", "Finalización de intimidad sagrada", "Plenitud de confianza absoluta", "Devoción protegida de anciano"],
    "ca": ["Pic de santuari de Cranc", "Finalització d''intimitat sagrada", "Plenitud de confiança absoluta", "Devoció protegida d''ancià"]
  }'::jsonb,
  '{
    "en": ["CELEBRATE the sacred sanctuary you built together", "Release guardedness - rest in ABSOLUTE emotional safety", "Share deepest vulnerability with devoted trust", "Gratitude for patience that created unbreakable intimacy"],
    "es": ["CELEBRA el santuario sagrado que construiste juntos", "Libera vigilancia - descansa en seguridad emocional ABSOLUTA", "Comparte vulnerabilidad más profunda con confianza devota", "Gratitud por paciencia que creó intimidad inquebrantable"],
    "ca": ["CELEBRA el santuari sagrat que vas construir junts", "Allibera vigilància - descansa en seguretat emocional ABSOLUTA", "Comparteix vulnerabilitat més profunda amb confiança devota", "Gratitud per paciència que va crear intimitat inquebrantable"]
  }'::jsonb
);

-- =====================================================
-- COMPLETION COMMENT
-- =====================================================
-- ✅ FULL MOON SEASONAL OVERLAYS COMPLETE (16/16)
-- Next file: 20251116000012_seed_seasonal_waning_gibbous.sql
