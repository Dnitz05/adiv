-- =====================================================
-- SEED SEASONAL OVERLAYS: WAXING GIBBOUS (16 overlays)
-- =====================================================
-- Phase: Waxing Gibbous (96% illuminated, nearly full)
-- Energy: Refinement, adjustment, patience, trust, anticipation
-- Overlays: 4 elements × 4 seasons = 16 total
--
-- Waxing Gibbous represents the final preparations before
-- fullness - refining, polishing, adjusting, trusting the
-- process, anticipating culmination with patient devotion.

-- =====================================================
-- FIRE ELEMENT × 4 SEASONS
-- =====================================================

-- 🔥 WAXING GIBBOUS + FIRE + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_gibbous' AND element = 'fire' LIMIT 1),
  'spring',
  '{
    "en": "Spring Fire Bursts Into Final Explosive Bloom",
    "es": "El Fuego de Primavera Estalla en Floración Explosiva Final",
    "ca": "El Foc de Primavera Esclata en Floració Explosiva Final"
  }'::jsonb,
  '{
    "en": "The waxing gibbous'' refinement energy meets spring''s peak blooming surge. As Aries completion (March-April) perfects your bold vision, anticipation becomes explosive certainty - you''re about to burst into full unstoppable manifestation.",
    "es": "La energía de refinamiento de la luna gibosa creciente se encuentra con el auge de floración máxima de la primavera. Mientras la finalización de Aries (marzo-abril) perfecciona tu visión audaz, la anticipación se convierte en certeza explosiva - estás a punto de estallar en manifestación completa imparable.",
    "ca": "L''energia de refinament de la lluna gibosa creixent es troba amb l''augment de floració màxima de la primavera. Mentre la finalització d''Àries (març-abril) perfecciona la teva visió audaç, l''anticipació es converteix en certesa explosiva - estàs a punt d''esclatar en manifestació completa imparable."
  }'::jsonb,
  '{
    "en": "Fire''s refinement is supercharged by spring''s explosive blooming. Final adjustments become bold finishing touches. Trust transforms into maiden warrior certainty. You can FEEL the fullness about to burst.",
    "es": "El refinamiento del fuego se supercarga con la floración explosiva de la primavera. Los ajustes finales se convierten en toques finales audaces. La confianza se transforma en certeza de guerrera doncella. Puedes SENTIR la plenitud a punto de estallar.",
    "ca": "El refinament del foc se supercarrega amb la floració explosiva de la primavera. Els ajustos finals es converteixen en tocs finals audaços. La confiança es transforma en certesa de guerrera donzella. Pots SENTIR la plenitud a punt d''esclatar."
  }'::jsonb,
  '{
    "en": ["Aries completion", "Explosive anticipation", "Bold final touches", "Maiden peak certainty"],
    "es": ["Finalización de Aries", "Anticipación explosiva", "Toques finales audaces", "Certeza de pico doncella"],
    "ca": ["Finalització d''Àries", "Anticipació explosiva", "Tocs finals audaços", "Certesa de pic donzella"]
  }'::jsonb,
  '{
    "en": ["Add ONE bold final touch to perfect your vision", "Trust spring''s explosive force - fullness is IMMINENT", "Polish with Aries courage - go BIG on finishing details", "Let anticipation fuel one last burst of passionate refinement"],
    "es": ["Añade UN toque final audaz para perfeccionar tu visión", "Confía en la fuerza explosiva de la primavera - la plenitud es INMINENTE", "Pule con coraje de Aries - ve a lo GRANDE en los detalles finales", "Deja que la anticipación alimente un último estallido de refinamiento apasionado"],
    "ca": ["Afegeix UN toc final audaç per perfeccionar la teva visió", "Confia en la força explosiva de la primavera - la plenitud és IMMINENT", "Poleix amb coratge d''Àries - ves a allò GRAN en els detalls finals", "Deixa que l''anticipació alimenti un últim esclat de refinament apassionat"]
  }'::jsonb
);

-- 🔥 WAXING GIBBOUS + FIRE + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_gibbous' AND element = 'fire' LIMIT 1),
  'summer',
  '{
    "en": "Summer''s Radiant Fire Polishes To Peak Brilliance",
    "es": "El Fuego Radiante del Verano Pule Hasta Brillantez Máxima",
    "ca": "El Foc Radiant de l''Estiu Poleix Fins a Brillantor Màxima"
  }'::jsonb,
  '{
    "en": "The waxing gibbous'' perfecting energy meets summer''s confident radiance. As Leo mastery (July-August) refines your creative expression, anticipation becomes joyful certainty - you''re polishing to absolute brilliant peak performance.",
    "es": "La energía perfectiva de la luna gibosa creciente se encuentra con la radiancia confiada del verano. Mientras la maestría de Leo (julio-agosto) refina tu expresión creativa, la anticipación se convierte en certeza gozosa - estás puliendo hacia actuación de pico absolutamente brillante.",
    "ca": "L''energia perfectiva de la lluna gibosa creixent es troba amb la radiància confiada de l''estiu. Mentre la mestria de Leo (juliol-agost) refina la teva expressió creativa, l''anticipació es converteix en certesa joiosa - estàs polint cap a actuació de pic absolutament brillant."
  }'::jsonb,
  '{
    "en": "Fire''s refinement blazes under summer''s sovereign confidence. Final polishing becomes radiant mastery. Trust transforms into regal certainty. You shine brighter with every perfecting touch.",
    "es": "El refinamiento del fuego arde bajo la confianza soberana del verano. El pulido final se convierte en maestría radiante. La confianza se transforma en certeza regia. Brillas más con cada toque perfeccionador.",
    "ca": "El refinament del foc crema sota la confiança sobirana de l''estiu. El polit final es converteix en mestria radiant. La confiança es transforma en certesa règia. Brilles més amb cada toc perfeccionador."
  }'::jsonb,
  '{
    "en": ["Leo mastery", "Radiant polishing", "Confident refinement", "Mother''s brilliant peak"],
    "es": ["Maestría de Leo", "Pulido radiante", "Refinamiento confiado", "Pico brillante de madre"],
    "ca": ["Mestria de Leo", "Polit radiant", "Refinament confiat", "Pic brillant de mare"]
  }'::jsonb,
  '{
    "en": ["Perfect one detail that makes your work SHINE brilliantly", "Trust your creative mastery - you''re nearly at peak radiance", "Polish with Leo confidence - you DESERVE this fullness", "Let joyful anticipation inspire brilliant final touches"],
    "es": ["Perfecciona un detalle que hace que tu trabajo BRILLE brillantemente", "Confía en tu maestría creativa - estás casi en radiancia máxima", "Pule con confianza de Leo - MERECES esta plenitud", "Deja que la anticipación gozosa inspire toques finales brillantes"],
    "ca": ["Perfecciona un detall que fa que el teu treball BRILLI brillantment", "Confia en la teva mestria creativa - estàs gairebé a radiància màxima", "Poleix amb confiança de Leo - MEREIXES aquesta plenitud", "Deixa que l''anticipació joiosa inspiri tocs finals brillants"]
  }'::jsonb
);

-- 🔥 WAXING GIBBOUS + FIRE + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_gibbous' AND element = 'fire' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Fire Refines With Strategic Harvest Vision",
    "es": "El Fuego de Otoño Refina Con Visión Estratégica de Cosecha",
    "ca": "El Foc de Tardor Refina Amb Visió Estratègica de Collita"
  }'::jsonb,
  '{
    "en": "The waxing gibbous'' adjustment phase meets autumn''s purposeful preparation. As Sagittarius wisdom (November-December) perfects your meaningful goals, anticipation becomes philosophical certainty - you''re refining toward harvest that truly matters.",
    "es": "La fase de ajuste de la luna gibosa creciente se encuentra con la preparación propositiva del otoño. Mientras la sabiduría de Sagitario (noviembre-diciembre) perfecciona tus objetivos significativos, la anticipación se convierte en certeza filosófica - estás refinando hacia cosecha que realmente importa.",
    "ca": "La fase d''ajust de la lluna gibosa creixent es troba amb la preparació propositiva de la tardor. Mentre la saviesa de Sagitari (novembre-desembre) perfecciona els teus objectius significatius, l''anticipació es converteix en certesa filosòfica - estàs refinant cap a collita que realment importa."
  }'::jsonb,
  '{
    "en": "Fire''s refinement becomes purposeful under autumn''s crone wisdom. Final adjustments aim at meaningful harvest. Trust transforms into archer certainty. Every polishing touch serves your highest goal.",
    "es": "El refinamiento del fuego se vuelve propositivo bajo la sabiduría de la anciana del otoño. Los ajustes finales apuntan a cosecha significativa. La confianza se transforma en certeza de arquero. Cada toque pulidor sirve tu objetivo más alto.",
    "ca": "El refinament del foc es torna propositiu sota la saviesa de l''anciana de la tardor. Els ajustos finals apunten a collita significativa. La confiança es transforma en certesa d''arquer. Cada toc polidor serveix el teu objectiu més alt."
  }'::jsonb,
  '{
    "en": ["Sagittarius wisdom", "Purposeful perfecting", "Harvest-aimed refinement", "Crone''s strategic polishing"],
    "es": ["Sabiduría de Sagitario", "Perfeccionamiento propositivo", "Refinamiento dirigido a cosecha", "Pulido estratégico de anciana"],
    "ca": ["Saviesa de Sagitari", "Perfeccionament propositiu", "Refinament dirigit a collita", "Polit estratègic d''anciana"]
  }'::jsonb,
  '{
    "en": ["Refine with harvest vision - does this serve your ultimate goal?", "Trust Sagittarius wisdom - full reaping approaches", "Polish strategically toward meaningful completion", "Let purposeful anticipation guide final adjustments"],
    "es": ["Refina con visión de cosecha - ¿esto sirve tu objetivo final?", "Confía en la sabiduría de Sagitario - se acerca la cosecha completa", "Pule estratégicamente hacia finalización significativa", "Deja que la anticipación propositiva guíe los ajustes finales"],
    "ca": ["Refina amb visió de collita - això serveix el teu objectiu final?", "Confia en la saviesa de Sagitari - s''apropa la collita completa", "Poleix estratègicament cap a finalització significativa", "Deixa que l''anticipació propositiva guiï els ajustos finals"]
  }'::jsonb
);

-- 🔥 WAXING GIBBOUS + FIRE + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_gibbous' AND element = 'fire' LIMIT 1),
  'winter',
  '{
    "en": "Winter Fire Perfects With Disciplined Mastery",
    "es": "El Fuego del Invierno Perfecciona Con Maestría Disciplinada",
    "ca": "El Foc de l''Hivern Perfecciona Amb Mestria Disciplinada"
  }'::jsonb,
  '{
    "en": "The waxing gibbous'' patient refinement meets winter''s structural discipline. As Capricorn mastery (December-January) adjusts empire foundations with precision, anticipation becomes unshakable certainty - you''re building to permanent mountain-like completion.",
    "es": "El refinamiento paciente de la luna gibosa creciente se encuentra con la disciplina estructural del invierno. Mientras la maestría de Capricornio (diciembre-enero) ajusta cimientos de imperio con precisión, la anticipación se convierte en certeza inquebrantable - estás construyendo hacia finalización permanente como montaña.",
    "ca": "El refinament pacient de la lluna gibosa creixent es troba amb la disciplina estructural de l''hivern. Mentre la mestria de Capricorn (desembre-gener) ajusta fonaments d''imperi amb precisió, l''anticipació es converteix en certesa inquebrantable - estàs construint cap a finalització permanent com muntanya."
  }'::jsonb,
  '{
    "en": "Fire''s refinement becomes disciplined under winter''s elder structure. Final adjustments build permanent foundations. Trust transforms into geological certainty. Every detail strengthens empire architecture.",
    "es": "El refinamiento del fuego se vuelve disciplinado bajo la estructura anciana del invierno. Los ajustes finales construyen cimientos permanentes. La confianza se transforma en certeza geológica. Cada detalle fortalece la arquitectura del imperio.",
    "ca": "El refinament del foc es torna disciplinat sota l''estructura anciana de l''hivern. Els ajustos finals construeixen fonaments permanents. La confiança es transforma en certesa geològica. Cada detall enforteix l''arquitectura de l''imperi."
  }'::jsonb,
  '{
    "en": ["Capricorn mastery", "Disciplined perfecting", "Structural refinement", "Elder''s empire-building"],
    "es": ["Maestría de Capricornio", "Perfeccionamiento disciplinado", "Refinamiento estructural", "Construcción de imperio anciana"],
    "ca": ["Mestria de Capricorn", "Perfeccionament disciplinat", "Refinament estructural", "Construcció d''imperi anciana"]
  }'::jsonb,
  '{
    "en": ["Perfect structural details with Capricorn discipline", "Trust patient refinement - empires need solid foundations", "Adjust with the precision of mountain-building geology", "Let enduring anticipation inspire permanent excellence"],
    "es": ["Perfecciona detalles estructurales con disciplina de Capricornio", "Confía en el refinamiento paciente - los imperios necesitan cimientos sólidos", "Ajusta con la precisión de la geología constructora de montañas", "Deja que la anticipación duradera inspire excelencia permanente"],
    "ca": ["Perfecciona detalls estructurals amb disciplina de Capricorn", "Confia en el refinament pacient - els imperis necessiten fonaments sòlids", "Ajusta amb la precisió de la geologia constructora de muntanyes", "Deixa que l''anticipació duradora inspiri excel·lència permanent"]
  }'::jsonb
);

-- =====================================================
-- EARTH ELEMENT × 4 SEASONS
-- =====================================================

-- 🌍 WAXING GIBBOUS + EARTH + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_gibbous' AND element = 'earth' LIMIT 1),
  'spring',
  '{
    "en": "Spring Earth Blooms Into Sensory Peak Abundance",
    "es": "La Tierra de Primavera Florece en Abundancia Sensorial Máxima",
    "ca": "La Terra de Primavera Floreix en Abundància Sensorial Màxima"
  }'::jsonb,
  '{
    "en": "The waxing gibbous'' perfecting energy meets spring''s fertile peak blooming. As Taurus abundance (April-May) refines tangible results, anticipation becomes sensory certainty - you can SEE, SMELL, TOUCH the fullness about to overflow.",
    "es": "La energía perfectiva de la luna gibosa creciente se encuentra con la floración de pico fértil de la primavera. Mientras la abundancia de Tauro (abril-mayo) refina resultados tangibles, la anticipación se convierte en certeza sensorial - puedes VER, OLER, TOCAR la plenitud a punto de desbordarse.",
    "ca": "L''energia perfectiva de la lluna gibosa creixent es troba amb la floració de pic fèrtil de la primavera. Mentre l''abundància de Taure (abril-maig) refina resultats tangibles, l''anticipació es converteix en certesa sensorial - pots VEURE, OLORAR, TOCAR la plenitud a punt de desbordar-se."
  }'::jsonb,
  '{
    "en": "Earth''s practical refinement is supercharged by spring''s peak fertility. Final touches bloom VISIBLY. Trust transforms into sensory knowing - your body FEELS fullness approaching. Abundance overflows all containers.",
    "es": "El refinamiento práctico de la tierra se supercarga con la fertilidad máxima de la primavera. Los toques finales florecen VISIBLEMENTE. La confianza se transforma en conocimiento sensorial - tu cuerpo SIENTE la plenitud acercándose. La abundancia desborda todos los contenedores.",
    "ca": "El refinament pràctic de la terra se supercarrega amb la fertilitat màxima de la primavera. Els tocs finals floreixen VISIBLEMENT. La confiança es transforma en coneixement sensorial - el teu cos SENT la plenitud acostant-se. L''abundància desborda tots els contenidors."
  }'::jsonb,
  '{
    "en": ["Taurus abundance", "Sensory peak blooming", "Tangible overflow", "Maiden fertility-fullness"],
    "es": ["Abundancia de Tauro", "Floración de pico sensorial", "Desbordamiento tangible", "Plenitud de fertilidad doncella"],
    "ca": ["Abundància de Taure", "Floració de pic sensorial", "Desbordament tangible", "Plenitud de fertilitat donzella"]
  }'::jsonb,
  '{
    "en": ["Perfect one sensory detail - make it beautiful to SEE/TOUCH", "Trust spring abundance - overflow is IMMINENT and VISIBLE", "Refine with Taurus devotion to physical beauty", "Let your senses anticipate the tangible fullness approaching"],
    "es": ["Perfecciona un detalle sensorial - hazlo hermoso para VER/TOCAR", "Confía en la abundancia primaveral - el desbordamiento es INMINENTE y VISIBLE", "Refina con devoción de Tauro por la belleza física", "Deja que tus sentidos anticipen la plenitud tangible que se acerca"],
    "ca": ["Perfecciona un detall sensorial - fes-lo bell per VEURE/TOCAR", "Confia en l''abundància primaveral - el desbordament és IMMINENT i VISIBLE", "Refina amb devoció de Taure per la bellesa física", "Deixa que els teus sentits anticipin la plenitud tangible que s''acosta"]
  }'::jsonb
);

-- 🌍 WAXING GIBBOUS + EARTH + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_gibbous' AND element = 'earth' LIMIT 1),
  'summer',
  '{
    "en": "Summer Earth Perfects Every Detail With Devotion",
    "es": "La Tierra de Verano Perfecciona Cada Detalle Con Devoción",
    "ca": "La Terra d''Estiu Perfecciona Cada Detall Amb Devoció"
  }'::jsonb,
  '{
    "en": "The waxing gibbous'' meticulous refinement meets summer''s devoted care. As Virgo precision (August-September) analyzes final details with loving attention, anticipation becomes perfect service - you''re polishing to absolute flawless completion.",
    "es": "El refinamiento meticuloso de la luna gibosa creciente se encuentra con el cuidado devoto del verano. Mientras la precisión de Virgo (agosto-septiembre) analiza detalles finales con atención amorosa, la anticipación se convierte en servicio perfecto - estás puliendo hacia finalización absolutamente impecable.",
    "ca": "El refinament meticulós de la lluna gibosa creixent es troba amb la cura devota de l''estiu. Mentre la precisió de Verge (agost-setembre) analitza detalls finals amb atenció amorosa, l''anticipació es converteix en servei perfecte - estàs polint cap a finalització absolutament impecable."
  }'::jsonb,
  '{
    "en": "Earth''s practical perfecting becomes devotional under summer''s mother care. Final refinements receive meticulous love. Trust transforms into analytical certainty. Every tiny detail matters and receives attention.",
    "es": "El perfeccionamiento práctico de la tierra se vuelve devocional bajo el cuidado maternal del verano. Los refinamientos finales reciben amor meticuloso. La confianza se transforma en certeza analítica. Cada pequeño detalle importa y recibe atención.",
    "ca": "El perfeccionament pràctic de la terra es torna devocional sota la cura maternal de l''estiu. Els refinaments finals reben amor meticulós. La confiança es transforma en certesa analítica. Cada petit detall importa i rep atenció."
  }'::jsonb,
  '{
    "en": ["Virgo precision", "Devoted perfecting", "Meticulous love", "Mother''s flawless care"],
    "es": ["Precisión de Virgo", "Perfeccionamiento devoto", "Amor meticuloso", "Cuidado impecable de madre"],
    "ca": ["Precisió de Verge", "Perfeccionament devot", "Amor meticulós", "Cura impecable de mare"]
  }'::jsonb,
  '{
    "en": ["Analyze every detail with Virgo loving precision", "Trust devoted care - perfection approaches through attention", "Refine the smallest elements - they ALL matter", "Let meticulous anticipation inspire flawless completion"],
    "es": ["Analiza cada detalle con precisión amorosa de Virgo", "Confía en el cuidado devoto - la perfección se acerca a través de la atención", "Refina los elementos más pequeños - TODOS importan", "Deja que la anticipación meticulosa inspire finalización impecable"],
    "ca": ["Analitza cada detall amb precisió amorosa de Verge", "Confia en la cura devota - la perfecció s''acosta a través de l''atenció", "Refina els elements més petits - TOTS importen", "Deixa que l''anticipació meticulosa inspiri finalització impecable"]
  }'::jsonb
);

-- 🌍 WAXING GIBBOUS + EARTH + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_gibbous' AND element = 'earth' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Earth Prepares Maximum Harvest Abundance",
    "es": "La Tierra de Otoño Prepara Abundancia de Cosecha Máxima",
    "ca": "La Terra de Tardor Prepara Abundància de Collita Màxima"
  }'::jsonb,
  '{
    "en": "The waxing gibbous'' preparation phase meets autumn''s harvest readiness. As Capricorn mastery (December-January) makes final resource calculations, anticipation becomes shrewd certainty - you''re optimizing every detail for maximum reaping.",
    "es": "La fase de preparación de la luna gibosa creciente se encuentra con la disposición de cosecha del otoño. Mientras la maestría de Capricornio (diciembre-enero) hace cálculos finales de recursos, la anticipación se convierte en certeza astuta - estás optimizando cada detalle para cosecha máxima.",
    "ca": "La fase de preparació de la lluna gibosa creixent es troba amb la disposició de collita de la tardor. Mentre la mestria de Capricorn (desembre-gener) fa càlculs finals de recursos, l''anticipació es converteix en certesa astuta - estàs optimitzant cada detall per a collita màxima."
  }'::jsonb,
  '{
    "en": "Earth''s practical refinement becomes harvest-strategic under autumn''s crone wisdom. Final adjustments maximize abundance yield. Trust transforms into calculated certainty. Every resource is optimized for reaping.",
    "es": "El refinamiento práctico de la tierra se vuelve estratégico de cosecha bajo la sabiduría de la anciana del otoño. Los ajustes finales maximizan el rendimiento de abundancia. La confianza se transforma en certeza calculada. Cada recurso se optimiza para la cosecha.",
    "ca": "El refinament pràctic de la terra es torna estratègic de collita sota la saviesa de l''anciana de la tardor. Els ajustos finals maximitzen el rendiment d''abundància. La confiança es transforma en certesa calculada. Cada recurs s''optimitza per a la collita."
  }'::jsonb,
  '{
    "en": ["Capricorn mastery", "Harvest optimization", "Strategic preparation", "Crone''s shrewd abundance"],
    "es": ["Maestría de Capricornio", "Optimización de cosecha", "Preparación estratégica", "Abundancia astuta de anciana"],
    "ca": ["Mestria de Capricorn", "Optimització de collita", "Preparació estratègica", "Abundància astuta d''anciana"]
  }'::jsonb,
  '{
    "en": ["Optimize final details for maximum harvest return", "Trust shrewd calculations - abundant reaping approaches", "Refine resource allocation strategically", "Let harvest anticipation inspire wise final adjustments"],
    "es": ["Optimiza detalles finales para retorno de cosecha máximo", "Confía en cálculos astutos - se acerca la cosecha abundante", "Refina la asignación de recursos estratégicamente", "Deja que la anticipación de cosecha inspire ajustes finales sabios"],
    "ca": ["Optimitza detalls finals per a retorn de collita màxim", "Confia en càlculs astuts - s''acosta la collita abundant", "Refina l''assignació de recursos estratègicament", "Deixa que l''anticipació de collita inspiri ajustos finals savis"]
  }'::jsonb
);

-- 🌍 WAXING GIBBOUS + EARTH + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_gibbous' AND element = 'earth' LIMIT 1),
  'winter',
  '{
    "en": "Winter''s Deep Foundations Strengthen To Permanence",
    "es": "Los Cimientos Profundos del Invierno Se Fortalecen Hasta la Permanencia",
    "ca": "Els Fonaments Profunds de l''Hivern s''Enforteixen Fins a la Permanència"
  }'::jsonb,
  '{
    "en": "The waxing gibbous'' patient refinement meets winter''s underground completion. As Taurus endurance (April-May) perfects invisible root-structures, anticipation becomes geological certainty - foundations solidify to eternal bedrock strength.",
    "es": "El refinamiento paciente de la luna gibosa creciente se encuentra con la finalización subterránea del invierno. Mientras la resistencia de Tauro (abril-mayo) perfecciona estructuras de raíz invisibles, la anticipación se convierte en certeza geológica - los cimientos se solidifican a fuerza de lecho rocoso eterno.",
    "ca": "El refinament pacient de la lluna gibosa creixent es troba amb la finalització subterrània de l''hivern. Mentre la resistència de Taure (abril-maig) perfecciona estructures d''arrel invisibles, l''anticipació es converteix en certesa geològica - els fonaments es solidifiquen a força de llit rocós etern."
  }'::jsonb,
  '{
    "en": "Earth''s practical perfecting descends into winter''s depths. Final adjustments strengthen invisible anchors. Trust transforms into tectonic certainty. Underground roots reach their deepest strongest hold.",
    "es": "El perfeccionamiento práctico de la tierra desciende a las profundidades del invierno. Los ajustes finales fortalecen anclajes invisibles. La confianza se transforma en certeza tectónica. Las raíces subterráneas alcanzan su agarre más profundo y fuerte.",
    "ca": "El perfeccionament pràctic de la terra descendeix a les profunditats de l''hivern. Els ajustos finals enforteixen ancoratges invisibles. La confiança es transforma en certesa tectònica. Les arrels subterrànies arriben al seu agafament més profund i fort."
  }'::jsonb,
  '{
    "en": ["Taurus endurance", "Geological perfecting", "Invisible root-strength", "Elder''s bedrock completion"],
    "es": ["Resistencia de Tauro", "Perfeccionamiento geológico", "Fuerza de raíz invisible", "Finalización de lecho rocoso anciana"],
    "ca": ["Resistència de Taure", "Perfeccionament geològic", "Força d''arrel invisible", "Finalització de llit rocós ancià"]
  }'::jsonb,
  '{
    "en": ["Perfect invisible foundations with patient devotion", "Trust deep roots - permanent strength approaches completion", "Refine underground structures to bedrock solidity", "Let geological anticipation inspire eternal anchoring"],
    "es": ["Perfecciona cimientos invisibles con devoción paciente", "Confía en raíces profundas - la fuerza permanente se acerca a la finalización", "Refina estructuras subterráneas a solidez de lecho rocoso", "Deja que la anticipación geológica inspire anclaje eterno"],
    "ca": ["Perfecciona fonaments invisibles amb devoció pacient", "Confia en arrels profundes - la força permanent s''acosta a la finalització", "Refina estructures subterrànies a solidesa de llit rocós", "Deixa que l''anticipació geològica inspiri ancoratge etern"]
  }'::jsonb
);

-- =====================================================
-- AIR ELEMENT × 4 SEASONS
-- =====================================================

-- 💨 WAXING GIBBOUS + AIR + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_gibbous' AND element = 'air' LIMIT 1),
  'spring',
  '{
    "en": "Spring Winds Carry Ideas To Peak Connection",
    "es": "Los Vientos de Primavera Llevan Ideas a Conexión Máxima",
    "ca": "Els Vents de Primavera Porten Idees a Connexió Màxima"
  }'::jsonb,
  '{
    "en": "The waxing gibbous'' network-building meets spring''s communication peak. As Gemini curiosity (May-June) refines conversational connections, anticipation becomes social certainty - your ideas are about to pollinate everywhere at once.",
    "es": "La construcción de red de la luna gibosa creciente se encuentra con el pico de comunicación de la primavera. Mientras la curiosidad de Géminis (mayo-junio) refina conexiones conversacionales, la anticipación se convierte en certeza social - tus ideas están a punto de polinizar en todas partes a la vez.",
    "ca": "La construcció de xarxa de la lluna gibosa creixent es troba amb el pic de comunicació de la primavera. Mentre la curiositat de Bessons (maig-juny) refina connexions conversacionals, l''anticipació es converteix en certesa social - les teves idees estan a punt de pol·linitzar a tot arreu alhora."
  }'::jsonb,
  '{
    "en": "Air''s intellectual refinement is energized by spring''s maiden curiosity. Final conversations spark explosive connection cascades. Trust transforms into playful certainty. Ideas reach peak pollination momentum.",
    "es": "El refinamiento intelectual del aire se energiza con la curiosidad doncella de la primavera. Las conversaciones finales desencadenan cascadas de conexión explosivas. La confianza se transforma en certeza juguetona. Las ideas alcanzan impulso de polinización máximo.",
    "ca": "El refinament intel·lectual de l''aire s''energitza amb la curiositat donzella de la primavera. Les converses finals desencadenen cascades de connexió explosives. La confiança es transforma en certesa joganera. Les idees arriben a impuls de pol·linització màxim."
  }'::jsonb,
  '{
    "en": ["Gemini peak connection", "Explosive idea-pollination", "Playful network completion", "Maiden communication-surge"],
    "es": ["Conexión máxima de Géminis", "Polinización explosiva de ideas", "Finalización de red juguetona", "Oleada de comunicación doncella"],
    "ca": ["Connexió màxima de Bessons", "Pol·linització explosiva d''idees", "Finalització de xarxa joganera", "Onada de comunicació donzella"]
  }'::jsonb,
  '{
    "en": ["Refine ONE key message for maximum spread", "Trust spring winds - your ideas will carry EVERYWHERE", "Perfect playful communication for peak connection", "Let curious anticipation inspire final conversational touches"],
    "es": ["Refina UN mensaje clave para máxima difusión", "Confía en los vientos primaverales - tus ideas llegarán a TODAS PARTES", "Perfecciona la comunicación juguetona para conexión máxima", "Deja que la anticipación curiosa inspire toques conversacionales finales"],
    "ca": ["Refina UN missatge clau per a màxima difusió", "Confia en els vents primeraverals - les teves idees arribaran a TOT ARREU", "Perfecciona la comunicació joganera per a connexió màxima", "Deixa que l''anticipació curiosa inspiri tocs conversacionals finals"]
  }'::jsonb
);

-- 💨 WAXING GIBBOUS + AIR + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_gibbous' AND element = 'air' LIMIT 1),
  'summer',
  '{
    "en": "Summer Breezes Perfect Harmonious Collaboration",
    "es": "Las Brisas de Verano Perfeccionan la Colaboración Armoniosa",
    "ca": "Les Brises d''Estiu Perfeccionen la Col·laboració Harmoniosa"
  }'::jsonb,
  '{
    "en": "The waxing gibbous'' partnership refinement meets summer''s diplomatic grace. As Libra balance (September-October) adjusts collaborative beauty, anticipation becomes harmonious certainty - relationships are approaching perfect reciprocal fullness.",
    "es": "El refinamiento de asociación de la luna gibosa creciente se encuentra con la gracia diplomática del verano. Mientras el equilibrio de Libra (septiembre-octubre) ajusta la belleza colaborativa, la anticipación se convierte en certeza armoniosa - las relaciones se acercan a plenitud recíproca perfecta.",
    "ca": "El refinament d''associació de la lluna gibosa creixent es troba amb la gràcia diplomàtica de l''estiu. Mentre l''equilibri de Balança (setembre-octubre) ajusta la bellesa col·laborativa, l''anticipació es converteix en certesa harmoniosa - les relacions s''acosten a plenitud recíproca perfecta."
  }'::jsonb,
  '{
    "en": "Air''s intellectual refinement becomes collaborative under summer''s mother grace. Final adjustments create beautiful balance. Trust transforms into diplomatic certainty. Partnerships reach peak harmonious exchange.",
    "es": "El refinamiento intelectual del aire se vuelve colaborativo bajo la gracia maternal del verano. Los ajustes finales crean equilibrio hermoso. La confianza se transforma en certeza diplomática. Las asociaciones alcanzan intercambio armonioso máximo.",
    "ca": "El refinament intel·lectual de l''aire es torna col·laboratiu sota la gràcia maternal de l''estiu. Els ajustos finals creen equilibri bell. La confiança es transforma en certesa diplomàtica. Les associacions arriben a intercanvi harmoniós màxim."
  }'::jsonb,
  '{
    "en": ["Libra balance", "Beautiful partnership-perfecting", "Harmonious exchange", "Mother''s diplomatic grace"],
    "es": ["Equilibrio de Libra", "Perfeccionamiento hermoso de asociación", "Intercambio armonioso", "Gracia diplomática de madre"],
    "ca": ["Equilibri de Balança", "Perfeccionament bell d''associació", "Intercanvi harmoniós", "Gràcia diplomàtica de mare"]
  }'::jsonb,
  '{
    "en": ["Perfect partnership balance with graceful final adjustments", "Trust Libra diplomacy - harmonious fullness approaches", "Refine collaborative beauty to peak reciprocity", "Let relationship anticipation inspire mutual perfection"],
    "es": ["Perfecciona el equilibrio de asociación con ajustes finales graciosos", "Confía en la diplomacia de Libra - se acerca la plenitud armoniosa", "Refina la belleza colaborativa a reciprocidad máxima", "Deja que la anticipación de relación inspire perfección mutua"],
    "ca": ["Perfecciona l''equilibri d''associació amb ajustos finals graciosos", "Confia en la diplomàcia de Balança - s''acosta la plenitud harmoniosa", "Refina la bellesa col·laborativa a reciprocitat màxima", "Deixa que l''anticipació de relació inspiri perfecció mútua"]
  }'::jsonb
);

-- 💨 WAXING GIBBOUS + AIR + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_gibbous' AND element = 'air' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Air Perfects Revolutionary Network Systems",
    "es": "El Aire de Otoño Perfecciona Sistemas de Red Revolucionarios",
    "ca": "L''Aire de Tardor Perfecciona Sistemes de Xarxa Revolucionaris"
  }'::jsonb,
  '{
    "en": "The waxing gibbous'' systems refinement meets autumn''s visionary innovation. As Aquarius evolution (January-February) adjusts collective networks for breakthrough, anticipation becomes revolutionary certainty - you''re about to activate humanity''s next leap.",
    "es": "El refinamiento de sistemas de la luna gibosa creciente se encuentra con la innovación visionaria del otoño. Mientras la evolución de Acuario (enero-febrero) ajusta redes colectivas para avance, la anticipación se convierte en certeza revolucionaria - estás a punto de activar el próximo salto de la humanidad.",
    "ca": "El refinament de sistemes de la lluna gibosa creixent es troba amb la innovació visionària de la tardor. Mentre l''evolució d''Aquari (gener-febrer) ajusta xarxes col·lectives per a avenç, l''anticipació es converteix en certesa revolucionària - estàs a punt d''activar el proper salt de la humanitat."
  }'::jsonb,
  '{
    "en": "Air''s intellectual refinement becomes revolutionary under autumn''s crone innovation. Final adjustments upgrade entire systems. Trust transforms into visionary certainty. Collective networks reach evolutionary activation point.",
    "es": "El refinamiento intelectual del aire se vuelve revolucionario bajo la innovación anciana del otoño. Los ajustes finales actualizan sistemas enteros. La confianza se transforma en certeza visionaria. Las redes colectivas alcanzan punto de activación evolutivo.",
    "ca": "El refinament intel·lectual de l''aire es torna revolucionari sota la innovació anciana de la tardor. Els ajustos finals actualitzen sistemes sencers. La confiança es transforma en certesa visionària. Les xarxes col·lectives arriben a punt d''activació evolutiu."
  }'::jsonb,
  '{
    "en": ["Aquarius innovation", "Revolutionary system-perfecting", "Collective evolution", "Crone''s visionary breakthrough"],
    "es": ["Innovación de Acuario", "Perfeccionamiento revolucionario de sistemas", "Evolución colectiva", "Avance visionario de anciana"],
    "ca": ["Innovació d''Aquari", "Perfeccionament revolucionari de sistemes", "Evolució col·lectiva", "Avenç visionari d''anciana"]
  }'::jsonb,
  '{
    "en": ["Perfect system upgrades for collective breakthrough", "Trust Aquarius vision - revolutionary activation is imminent", "Refine networks to serve humanity''s evolutionary leap", "Let visionary anticipation inspire future-focused completion"],
    "es": ["Perfecciona actualizaciones de sistemas para avance colectivo", "Confía en la visión de Acuario - la activación revolucionaria es inminente", "Refina redes para servir el salto evolutivo de la humanidad", "Deja que la anticipación visionaria inspire finalización enfocada en el futuro"],
    "ca": ["Perfecciona actualitzacions de sistemes per a avenç col·lectiu", "Confia en la visió d''Aquari - l''activació revolucionària és imminent", "Refina xarxes per servir el salt evolutiu de la humanitat", "Deixa que l''anticipació visionària inspiri finalització enfocada en el futur"]
  }'::jsonb
);

-- 💨 WAXING GIBBOUS + AIR + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_gibbous' AND element = 'air' LIMIT 1),
  'winter',
  '{
    "en": "Winter Silence Crystallizes To Diamond Perfection",
    "es": "El Silencio del Invierno Se Cristaliza a Perfección de Diamante",
    "ca": "El Silenci de l''Hivern es Cristal·litza a Perfecció de Diamant"
  }'::jsonb,
  '{
    "en": "The waxing gibbous'' contemplative refinement meets winter''s silent clarity. As Gemini curiosity (May-June) perfects understanding in stillness, anticipation becomes crystalline knowing - thoughts sharpen to their clearest, hardest, most brilliant form.",
    "es": "El refinamiento contemplativo de la luna gibosa creciente se encuentra con la claridad silenciosa del invierno. Mientras la curiosidad de Géminis (mayo-junio) perfecciona la comprensión en quietud, la anticipación se convierte en conocimiento cristalino - los pensamientos se afinan a su forma más clara, dura y brillante.",
    "ca": "El refinament contemplatiu de la lluna gibosa creixent es troba amb la claredat silenciosa de l''hivern. Mentre la curiositat de Bessons (maig-juny) perfecciona la comprensió en quietud, l''anticipació es converteix en coneixement cristal·lí - els pensaments s''afinen a la seva forma més clara, dura i brillant."
  }'::jsonb,
  '{
    "en": "Air''s intellectual refinement becomes contemplative under winter''s elder silence. Final understanding crystallizes to diamond clarity. Trust transforms into absolute certainty. Pure thought reaches its most perfect precision.",
    "es": "El refinamiento intelectual del aire se vuelve contemplativo bajo el silencio anciano del invierno. La comprensión final se cristaliza a claridad de diamante. La confianza se transforma en certeza absoluta. El pensamiento puro alcanza su precisión más perfecta.",
    "ca": "El refinament intel·lectual de l''aire es torna contemplatiu sota el silenci ancià de l''hivern. La comprensió final es cristal·litza a claredat de diamant. La confiança es transforma en certesa absoluta. El pensament pur arriba a la seva precisió més perfecta."
  }'::jsonb,
  '{
    "en": ["Gemini contemplation", "Diamond-clarity perfecting", "Silent crystallization", "Elder''s absolute knowing"],
    "es": ["Contemplación de Géminis", "Perfeccionamiento de claridad de diamante", "Cristalización silenciosa", "Conocimiento absoluto anciano"],
    "ca": ["Contemplació de Bessons", "Perfeccionament de claredat de diamant", "Cristal·lització silenciosa", "Coneixement absolut ancià"]
  }'::jsonb,
  '{
    "en": ["Sit in silence until understanding becomes crystal-perfect", "Trust contemplative clarity - absolute knowing approaches", "Refine thoughts to diamond-hard precision", "Let silent anticipation sharpen mind to flawless brilliance"],
    "es": ["Siéntate en silencio hasta que la comprensión se vuelva cristalina-perfecta", "Confía en la claridad contemplativa - se acerca el conocimiento absoluto", "Refina pensamientos a precisión dura como diamante", "Deja que la anticipación silenciosa afile la mente a brillantez impecable"],
    "ca": ["Seu en silenci fins que la comprensió es torni cristal·lina-perfecta", "Confia en la claredat contemplativa - s''acosta el coneixement absolut", "Refina pensaments a precisió dura com diamant", "Deixa que l''anticipació silenciosa afili la ment a brillantor impecable"]
  }'::jsonb
);

-- =====================================================
-- WATER ELEMENT × 4 SEASONS
-- =====================================================

-- 💧 WAXING GIBBOUS + WATER + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_gibbous' AND element = 'water' LIMIT 1),
  'spring',
  '{
    "en": "Spring Waters Overflow With Emotional Fullness",
    "es": "Las Aguas de Primavera Se Desbordan Con Plenitud Emocional",
    "ca": "Les Aigües de Primavera es Desborden Amb Plenitud Emocional"
  }'::jsonb,
  '{
    "en": "The waxing gibbous'' emotional deepening meets spring''s heart-blooming surge. As Cancer nurturing (June-July) perfects vulnerable connections, anticipation becomes heart-certainty - you can FEEL the emotional fullness about to overflow all containers.",
    "es": "La profundización emocional de la luna gibosa creciente se encuentra con el auge de floración de corazón de la primavera. Mientras el cuidado de Cáncer (junio-julio) perfecciona conexiones vulnerables, la anticipación se convierte en certeza de corazón - puedes SENTIR la plenitud emocional a punto de desbordar todos los contenedores.",
    "ca": "L''aprofundiment emocional de la lluna gibosa creixent es troba amb l''augment de floració de cor de la primavera. Mentre la cura de Cranc (juny-juliol) perfecciona connexions vulnerables, l''anticipació es converteix en certesa de cor - pots SENTIR la plenitud emocional a punt de desbordar tots els contenidors."
  }'::jsonb,
  '{
    "en": "Water''s emotional refinement is supercharged by spring''s maiden heart-courage. Final vulnerable shares create intimacy overflow. Trust transforms into heart-knowing. Feelings bloom to their absolute fullest expression.",
    "es": "El refinamiento emocional del agua se supercarga con el coraje de corazón doncella de la primavera. Los compartires vulnerables finales crean desbordamiento de intimidad. La confianza se transforma en conocimiento de corazón. Los sentimientos florecen a su expresión más completa absoluta.",
    "ca": "El refinament emocional de l''aigua se supercarrega amb el coratge de cor donzella de la primavera. Els compartirs vulnerables finals creen desbordament d''intimitat. La confiança es transforma en coneixement de cor. Els sentiments floreixen a la seva expressió més completa absoluta."
  }'::jsonb,
  '{
    "en": ["Cancer nurturing", "Heart-fullness overflow", "Vulnerable bloom completion", "Maiden emotional-surge"],
    "es": ["Cuidado de Cáncer", "Desbordamiento de plenitud de corazón", "Finalización de floración vulnerable", "Oleada emocional doncella"],
    "ca": ["Cura de Cranc", "Desbordament de plenitud de cor", "Finalització de floració vulnerable", "Onada emocional donzella"]
  }'::jsonb,
  '{
    "en": ["Share ONE final vulnerable truth to complete emotional intimacy", "Trust heart-courage - emotional fullness is about to OVERFLOW", "Perfect vulnerable connection with brave final honesty", "Let feeling-anticipation inspire total heart-opening"],
    "es": ["Comparte UNA verdad vulnerable final para completar la intimidad emocional", "Confía en el coraje de corazón - la plenitud emocional está a punto de DESBORDARSE", "Perfecciona la conexión vulnerable con honestidad final valiente", "Deja que la anticipación de sentimientos inspire apertura total de corazón"],
    "ca": ["Comparteix UNA veritat vulnerable final per completar la intimitat emocional", "Confia en el coratge de cor - la plenitud emocional està a punt de DESBORDAR-SE", "Perfecciona la connexió vulnerable amb honestedat final valenta", "Deixa que l''anticipació de sentiments inspiri obertura total de cor"]
  }'::jsonb
);

-- 💧 WAXING GIBBOUS + WATER + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_gibbous' AND element = 'water' LIMIT 1),
  'summer',
  '{
    "en": "Summer''s Intense Waters Complete Alchemical Transformation",
    "es": "Las Aguas Intensas del Verano Completan la Transformación Alquímica",
    "ca": "Les Aigües Intenses de l''Estiu Completen la Transformació Alquímica"
  }'::jsonb,
  '{
    "en": "The waxing gibbous'' transformative refinement meets summer''s soul-deep alchemy. As Scorpio intensity (October-November) perfects intimate metamorphosis, anticipation becomes rebirth-certainty - you''re about to emerge fundamentally transformed at the heart level.",
    "es": "El refinamiento transformativo de la luna gibosa creciente se encuentra con la alquimia profunda del alma del verano. Mientras la intensidad de Escorpio (octubre-noviembre) perfecciona la metamorfosis íntima, la anticipación se convierte en certeza de renacimiento - estás a punto de emerger fundamentalmente transformado a nivel del corazón.",
    "ca": "El refinament transformatiu de la lluna gibosa creixent es troba amb l''alquímia profunda de l''ànima de l''estiu. Mentre la intensitat d''Escorpí (octubre-novembre) perfecciona la metamorfosi íntima, l''anticipació es converteix en certesa de renaixement - estàs a punt d''emergir fonamentalment transformat a nivell del cor."
  }'::jsonb,
  '{
    "en": "Water''s emotional refinement becomes alchemical under summer''s mother intensity. Final transformations complete soul-rebirth. Trust transforms into metamorphic certainty. You emerge from the crucible as someone NEW.",
    "es": "El refinamiento emocional del agua se vuelve alquímico bajo la intensidad maternal del verano. Las transformaciones finales completan el renacimiento del alma. La confianza se transforma en certeza metamórfica. Emerges del crisol como alguien NUEVO.",
    "ca": "El refinament emocional de l''aigua es torna alquímic sota la intensitat maternal de l''estiu. Les transformacions finals completen el renaixement de l''ànima. La confiança es transforma en certesa metamòrfica. Emergeixis del gresol com algú NOU."
  }'::jsonb,
  '{
    "en": ["Scorpio transformation", "Alchemical completion", "Soul-rebirth perfecting", "Mother''s metamorphic intensity"],
    "es": ["Transformación de Escorpio", "Finalización alquímica", "Perfeccionamiento de renacimiento del alma", "Intensidad metamórfica de madre"],
    "ca": ["Transformació d''Escorpí", "Finalització alquímica", "Perfeccionament de renaixement de l''ànima", "Intensitat metamòrfica de mare"]
  }'::jsonb,
  '{
    "en": ["Complete ONE final alchemical transformation of the heart", "Trust Scorpio intensity - you''re about to be REBORN", "Perfect intimate metamorphosis with soul-deep honesty", "Let transformation-anticipation inspire total rebirth readiness"],
    "es": ["Completa UNA transformación alquímica final del corazón", "Confía en la intensidad de Escorpio - estás a punto de RENACER", "Perfecciona la metamorfosis íntima con honestidad profunda del alma", "Deja que la anticipación de transformación inspire preparación total de renacimiento"],
    "ca": ["Completa UNA transformació alquímica final del cor", "Confia en la intensitat d''Escorpí - estàs a punt de RENÉIXER", "Perfecciona la metamorfosi íntima amb honestedat profunda de l''ànima", "Deixa que l''anticipació de transformació inspiri preparació total de renaixement"]
  }'::jsonb
);

-- 💧 WAXING GIBBOUS + WATER + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_gibbous' AND element = 'water' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Waters Dissolve Into Universal Oneness",
    "es": "Las Aguas de Otoño Se Disuelven en Unidad Universal",
    "ca": "Les Aigües de Tardor es Dissolen en Unitat Universal"
  }'::jsonb,
  '{
    "en": "The waxing gibbous'' compassionate deepening meets autumn''s mystical unity. As Pisces boundarylessness (February-March) perfects universal connection, anticipation becomes cosmic certainty - you''re about to merge completely into the ocean of all feeling.",
    "es": "La profundización compasiva de la luna gibosa creciente se encuentra con la unidad mística del otoño. Mientras la falta de límites de Piscis (febrero-marzo) perfecciona la conexión universal, la anticipación se convierte en certeza cósmica - estás a punto de fusionarte completamente en el océano de todo sentimiento.",
    "ca": "L''aprofundiment compassiu de la lluna gibosa creixent es troba amb la unitat mística de la tardor. Mentre la manca de límits de Peixos (febrer-març) perfecciona la connexió universal, l''anticipació es converteix en certesa còsmica - estàs a punt de fusionar-te completament a l''oceà de tot sentiment."
  }'::jsonb,
  '{
    "en": "Water''s emotional refinement becomes boundaryless under autumn''s crone compassion. Final connections dissolve all separation. Trust transforms into mystical unity. All hearts merge into ONE cosmic ocean.",
    "es": "El refinamiento emocional del agua se vuelve sin límites bajo la compasión anciana del otoño. Las conexiones finales disuelven toda separación. La confianza se transforma en unidad mística. Todos los corazones se fusionan en UN océano cósmico.",
    "ca": "El refinament emocional de l''aigua es torna sense límits sota la compassió anciana de la tardor. Les connexions finals dissolen tota separació. La confiança es transforma en unitat mística. Tots els cors es fusionen en UN oceà còsmic."
  }'::jsonb,
  '{
    "en": ["Pisces unity", "Boundary dissolution completion", "Universal compassion-merging", "Crone''s mystical ocean"],
    "es": ["Unidad de Piscis", "Finalización de disolución de límites", "Fusión de compasión universal", "Océano místico de anciana"],
    "ca": ["Unitat de Peixos", "Finalització de dissolució de límits", "Fusió de compassió universal", "Oceà místic d''anciana"]
  }'::jsonb,
  '{
    "en": ["Dissolve ONE final boundary between self and others", "Trust Pisces compassion - unity is about to be COMPLETE", "Perfect boundaryless connection with universal empathy", "Let mystical anticipation inspire total merging readiness"],
    "es": ["Disuelve UN límite final entre yo y otros", "Confía en la compasión de Piscis - la unidad está a punto de ser COMPLETA", "Perfecciona la conexión sin límites con empatía universal", "Deja que la anticipación mística inspire preparación total de fusión"],
    "ca": ["Dissol UN límit final entre jo i altres", "Confia en la compassió de Peixos - la unitat està a punt de ser COMPLETA", "Perfecciona la connexió sense límits amb empatia universal", "Deixa que l''anticipació mística inspiri preparació total de fusió"]
  }'::jsonb
);

-- 💧 WAXING GIBBOUS + WATER + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_gibbous' AND element = 'water' LIMIT 1),
  'winter',
  '{
    "en": "Winter''s Sacred Sanctuary Reaches Deep Intimacy",
    "es": "El Santuario Sagrado del Invierno Alcanza Intimidad Profunda",
    "ca": "El Santuari Sagrat de l''Hivern Arriba a Intimitat Profunda"
  }'::jsonb,
  '{
    "en": "The waxing gibbous'' trust-building meets winter''s sheltered devotion. As Cancer protection (June-July) perfects sacred emotional containers, anticipation becomes sanctuary-certainty - you''ve created safe space where the deepest intimacy can finally bloom.",
    "es": "La construcción de confianza de la luna gibosa creciente se encuentra con la devoción protegida del invierno. Mientras la protección de Cáncer (junio-julio) perfecciona contenedores emocionales sagrados, la anticipación se convierte en certeza de santuario - has creado espacio seguro donde la intimidad más profunda finalmente puede florecer.",
    "ca": "La construcció de confiança de la lluna gibosa creixent es troba amb la devoció protegida de l''hivern. Mentre la protecció de Cranc (juny-juliol) perfecciona contenidors emocionals sagrats, l''anticipació es converteix en certesa de santuari - has creat espai segur on la intimitat més profunda finalment pot florir."
  }'::jsonb,
  '{
    "en": "Water''s emotional refinement becomes sheltered under winter''s elder protection. Final trust-bonds create unbreakable sanctuary. Trust transforms into devotional certainty. Sacred containers hold the deepest most precious vulnerability.",
    "es": "El refinamiento emocional del agua se vuelve protegido bajo la protección anciana del invierno. Los vínculos de confianza finales crean santuario inquebrantable. La confianza se transforma en certeza devocional. Los contenedores sagrados sostienen la vulnerabilidad más profunda y preciosa.",
    "ca": "El refinament emocional de l''aigua es torna protegit sota la protecció anciana de l''hivern. Els vincles de confiança finals creen santuari inquebrantable. La confiança es transforma en certesa devocional. Els contenidors sagrats sostenen la vulnerabilitat més profunda i preciosa."
  }'::jsonb,
  '{
    "en": ["Cancer sanctuary", "Deep intimacy completion", "Sacred container-perfecting", "Elder''s sheltering devotion"],
    "es": ["Santuario de Cáncer", "Finalización de intimidad profunda", "Perfeccionamiento de contenedor sagrado", "Devoción protectora anciana"],
    "ca": ["Santuari de Cranc", "Finalització d''intimitat profunda", "Perfeccionament de contenidor sagrat", "Devoció protectora anciana"]
  }'::jsonb,
  '{
    "en": ["Perfect ONE sacred container for deepest vulnerability", "Trust Cancer sheltering - true intimacy can finally bloom", "Refine emotional safety to absolute sanctuary strength", "Let devotional anticipation inspire total trust completion"],
    "es": ["Perfecciona UN contenedor sagrado para la vulnerabilidad más profunda", "Confía en la protección de Cáncer - la verdadera intimidad finalmente puede florecer", "Refina la seguridad emocional a fuerza de santuario absoluta", "Deja que la anticipación devocional inspire finalización total de confianza"],
    "ca": ["Perfecciona UN contenidor sagrat per a la vulnerabilitat més profunda", "Confia en la protecció de Cranc - la veritable intimitat finalment pot florir", "Refina la seguretat emocional a força de santuari absoluta", "Deixa que l''anticipació devocional inspiri finalització total de confiança"]
  }'::jsonb
);

-- =====================================================
-- COMPLETION COMMENT
-- =====================================================
-- ✅ WAXING GIBBOUS SEASONAL OVERLAYS COMPLETE (16/16)
-- Next file: 20251116000011_seed_seasonal_full_moon.sql
