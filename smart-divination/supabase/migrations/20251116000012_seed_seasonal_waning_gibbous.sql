-- =====================================================
-- SEED SEASONAL OVERLAYS: WANING GIBBOUS (16 overlays)
-- =====================================================
-- Phase: Waning Gibbous (decreasing light after fullness)
-- Energy: Gratitude, sharing, teaching, distribution, generosity
-- Overlays: 4 elements × 4 seasons = 16 total
--
-- Waning Gibbous represents processing peak experience and
-- distributing harvest - gratitude for what was received,
-- generosity in sharing abundance, teaching wisdom gained,
-- reflecting on achievement with thankful heart.

-- =====================================================
-- FIRE ELEMENT × 4 SEASONS
-- =====================================================

-- 🔥 WANING GIBBOUS + FIRE + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_gibbous' AND element = 'fire' LIMIT 1),
  'spring',
  '{
    "en": "Spring Fire Shares Victory With Explosive Generosity",
    "es": "El Fuego de Primavera Comparte Victoria Con Generosidad Explosiva",
    "ca": "El Foc de Primavera Comparteix Victòria Amb Generositat Explosiva"
  }'::jsonb,
  '{
    "en": "The waning gibbous'' grateful sharing meets spring''s abundant overflow. As Aries triumph (March-April) distributes bold success, gratitude becomes warrior-generosity - you share your fire with EVERYONE courageously and freely.",
    "es": "El compartir agradecido de la luna gibosa menguante se encuentra con el desbordamiento abundante de la primavera. Mientras el triunfo de Aries (marzo-abril) distribuye éxito audaz, la gratitud se convierte en generosidad guerrera - compartes tu fuego con TODOS con coraje y libremente.",
    "ca": "El compartir agraït de la lluna gibosa minvant es troba amb el desbordament abundant de la primavera. Mentre el triomf d''Àries (març-abril) distribueix èxit audaç, la gratitud es converteix en generositat guerrera - comparteixes el teu foc amb TOTHOM amb coratge i lliurement."
  }'::jsonb,
  '{
    "en": "Fire''s gratitude explodes with spring''s maiden generosity. Share your passion-victory BOLDLY with all who need inspiration. Teach courage by example - let others catch your unstoppable flame.",
    "es": "La gratitud del fuego explota con la generosidad doncella de la primavera. Comparte tu victoria de pasión AUDAZMENTE con todos los que necesitan inspiración. Enseña coraje con el ejemplo - deja que otros capturen tu llama imparable.",
    "ca": "La gratitud del foc explota amb la generositat donzella de la primavera. Comparteix la teva victòria de passió AUDAÇMENT amb tots els que necessiten inspiració. Ensenyar coratge amb l''exemple - deixa que altres capturin la teva flama imparable."
  }'::jsonb,
  '{
    "en": ["Aries generous-triumph", "Explosive victory-sharing", "Bold inspirational teaching", "Maiden warrior-generosity"],
    "es": ["Triunfo generoso de Aries", "Compartir explosivo de victoria", "Enseñanza inspiracional audaz", "Generosidad guerrera de doncella"],
    "ca": ["Triomf generós d''Àries", "Compartir explosiu de victòria", "Ensenyament inspiracional audaç", "Generositat guerrera de donzella"]
  }'::jsonb,
  '{
    "en": ["Share your success story LOUDLY to inspire courage in others", "Teach bold action through your passionate example", "Distribute your fire-energy generously to all who need it", "Grateful for victory that can now ignite EVERYONE"],
    "es": ["Comparte tu historia de éxito EN VOZ ALTA para inspirar coraje en otros", "Enseña acción audaz a través de tu ejemplo apasionado", "Distribuye tu energía de fuego generosamente a todos los que la necesitan", "Agradecido por victoria que ahora puede encender a TODOS"],
    "ca": ["Comparteix la teva història d''èxit EN VEU ALTA per inspirar coratge en altres", "Ensenyar acció audaç a través del teu exemple apassionat", "Distribueix la teva energia de foc generosament a tots els que la necessiten", "Agraït per victòria que ara pot encendre TOTHOM"]
  }'::jsonb
);

-- 🔥 WANING GIBBOUS + FIRE + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_gibbous' AND element = 'fire' LIMIT 1),
  'summer',
  '{
    "en": "Summer Fire Radiates Creative Wisdom Joyfully",
    "es": "El Fuego del Verano Irradia Sabiduría Creativa Gozosamente",
    "ca": "El Foc de l''Estiu Irradia Saviesa Creativa Joiosament"
  }'::jsonb,
  '{
    "en": "The waning gibbous'' wisdom-sharing meets summer''s radiant confidence. As Leo mastery (July-August) teaches creative brilliance, gratitude becomes playful mentorship - you share your sovereign gifts with joyful generous expression.",
    "es": "El compartir de sabiduría de la luna gibosa menguante se encuentra con la confianza radiante del verano. Mientras la maestría de Leo (julio-agosto) enseña brillantez creativa, la gratitud se convierte en mentoría juguetona - compartes tus dones soberanos con expresión generosa gozosa.",
    "ca": "El compartir de saviesa de la lluna gibosa minvant es troba amb la confiança radiant de l''estiu. Mentre la mestria de Leo (juliol-agost) ensenya brillantor creativa, la gratitud es converteix en mentoria joganera - comparteixes els teus dons sobirans amb expressió generosa joiosa."
  }'::jsonb,
  '{
    "en": "Fire''s gratitude shines with summer''s mother generosity. Share creative mastery with PLAYFUL confidence. Teach self-expression by radiating - let your light show others their own brilliance.",
    "es": "La gratitud del fuego brilla con la generosidad maternal del verano. Comparte maestría creativa con confianza JUGUETONA. Enseña autoexpresión irradiando - deja que tu luz muestre a otros su propia brillantez.",
    "ca": "La gratitud del foc brilla amb la generositat maternal de l''estiu. Comparteix mestria creativa amb confiança JOGANERA. Ensenyar autoexpressió irradiant - deixa que la teva llum mostri a altres la seva pròpia brillantor."
  }'::jsonb,
  '{
    "en": ["Leo radiant-teaching", "Playful creative-sharing", "Confident generous mentorship", "Mother''s joyful sovereignty"],
    "es": ["Enseñanza radiante de Leo", "Compartir creativo juguetón", "Mentoría generosa confiada", "Soberanía gozosa de madre"],
    "ca": ["Ensenyament radiant de Leo", "Compartir creatiu joganera", "Mentoria generosa confiada", "Sobirania joiosa de mare"]
  }'::jsonb,
  '{
    "en": ["Mentor someone creatively with Leo generous confidence", "Teach self-expression through your joyful radiant example", "Share your creative gifts playfully and abundantly", "Grateful for brilliance that can illuminate others'' potential"],
    "es": ["Mentora a alguien creativamente con confianza generosa de Leo", "Enseña autoexpresión a través de tu ejemplo radiante gozoso", "Comparte tus dones creativos juguetonamente y abundantemente", "Agradecido por brillantez que puede iluminar el potencial de otros"],
    "ca": ["Mentor a algú creativament amb confiança generosa de Leo", "Ensenyar autoexpressió a través del teu exemple radiant joiós", "Comparteix els teus dons creatius joganerament i abundantment", "Agraït per brillantor que pot il·luminar el potencial d''altres"]
  }'::jsonb
);

-- 🔥 WANING GIBBOUS + FIRE + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_gibbous' AND element = 'fire' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Fire Shares Purposeful Wisdom Generously",
    "es": "El Fuego de Otoño Comparte Sabiduría Propositiva Generosamente",
    "ca": "El Foc de Tardor Comparteix Saviesa Propositiva Generosament"
  }'::jsonb,
  '{
    "en": "The waning gibbous'' teaching phase meets autumn''s philosophical harvest. As Sagittarius wisdom (November-December) distributes meaningful insights, gratitude becomes arrow-guidance - you share truth that serves others'' highest paths.",
    "es": "La fase de enseñanza de la luna gibosa menguante se encuentra con la cosecha filosófica del otoño. Mientras la sabiduría de Sagitario (noviembre-diciembre) distribuye perspectivas significativas, la gratitud se convierte en guía de flecha - compartes verdad que sirve a los caminos más altos de otros.",
    "ca": "La fase d''ensenyament de la lluna gibosa minvant es troba amb la collita filosòfica de la tardor. Mentre la saviesa de Sagitari (novembre-desembre) distribueix perspectives significatives, la gratitud es converteix en guia de fletxa - comparteixes veritat que serveix als camins més alts d''altres."
  }'::jsonb,
  '{
    "en": "Fire''s gratitude becomes purposeful with autumn''s crone wisdom-sharing. Teach MEANING and higher purpose. Share philosophical insights that guide others toward their soul''s true aim.",
    "es": "La gratitud del fuego se vuelve propositiva con el compartir de sabiduría de la anciana del otoño. Enseña SIGNIFICADO y propósito superior. Comparte perspectivas filosóficas que guían a otros hacia el verdadero objetivo de su alma.",
    "ca": "La gratitud del foc es torna propositiva amb el compartir de saviesa de l''anciana de la tardor. Ensenyar SIGNIFICAT i propòsit superior. Comparteix perspectives filosòfiques que guien a altres cap al veritable objectiu de la seva ànima."
  }'::jsonb,
  '{
    "en": ["Sagittarius wisdom-guidance", "Philosophical truth-sharing", "Purposeful meaningful teaching", "Crone''s arrow-mentorship"],
    "es": ["Guía de sabiduría de Sagitario", "Compartir de verdad filosófica", "Enseñanza significativa propositiva", "Mentoría de flecha de anciana"],
    "ca": ["Guia de saviesa de Sagitari", "Compartir de veritat filosòfica", "Ensenyament significatiu propositiu", "Mentoria de fletxa d''anciana"]
  }'::jsonb,
  '{
    "en": ["Share wisdom that serves others'' higher purpose and meaning", "Teach philosophical truth with Sagittarius generous vision", "Guide others like an archer showing them their true target", "Grateful for insights that can illuminate humanity''s path"],
    "es": ["Comparte sabiduría que sirve al propósito superior y significado de otros", "Enseña verdad filosófica con visión generosa de Sagitario", "Guía a otros como un arquero mostrándoles su verdadero objetivo", "Agradecido por perspectivas que pueden iluminar el camino de la humanidad"],
    "ca": ["Comparteix saviesa que serveix al propòsit superior i significat d''altres", "Ensenyar veritat filosòfica amb visió generosa de Sagitari", "Guiar a altres com un arquer mostrant-los el seu veritable objectiu", "Agraït per perspectives que poden il·luminar el camí de la humanitat"]
  }'::jsonb
);

-- 🔥 WANING GIBBOUS + FIRE + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_gibbous' AND element = 'fire' LIMIT 1),
  'winter',
  '{
    "en": "Winter Fire Teaches Disciplined Mastery Patiently",
    "es": "El Fuego del Invierno Enseña Maestría Disciplinada Pacientemente",
    "ca": "El Foc de l''Hivern Ensenya Mestria Disciplinada Pacientment"
  }'::jsonb,
  '{
    "en": "The waning gibbous'' mentorship meets winter''s structural wisdom. As Capricorn mastery (December-January) shares empire-building principles, gratitude becomes elder-teaching - you pass down enduring knowledge with patient authority.",
    "es": "La mentoría de la luna gibosa menguante se encuentra con la sabiduría estructural del invierno. Mientras la maestría de Capricornio (diciembre-enero) comparte principios de construcción de imperio, la gratitud se convierte en enseñanza de anciano - transmites conocimiento duradero con autoridad paciente.",
    "ca": "La mentoria de la lluna gibosa minvant es troba amb la saviesa estructural de l''hivern. Mentre la mestria de Capricorn (desembre-gener) comparteix principis de construcció d''imperi, la gratitud es converteix en ensenyament d''ancià - transmet coneixement durador amb autoritat pacient."
  }'::jsonb,
  '{
    "en": "Fire''s gratitude becomes disciplined with winter''s elder authority. Teach ENDURING structures and principles. Share mastery that creates permanent foundations for generations.",
    "es": "La gratitud del fuego se vuelve disciplinada con la autoridad anciana del invierno. Enseña estructuras y principios DURADEROS. Comparte maestría que crea cimientos permanentes para generaciones.",
    "ca": "La gratitud del foc es torna disciplinada amb l''autoritat anciana de l''hivern. Ensenyar estructures i principis DURADORS. Comparteix mestria que crea fonaments permanents per a generacions."
  }'::jsonb,
  '{
    "en": ["Capricorn elder-mastery", "Disciplined structural teaching", "Patient authority-sharing", "Elder''s empire-wisdom"],
    "es": ["Maestría de anciano de Capricornio", "Enseñanza estructural disciplinada", "Compartir de autoridad paciente", "Sabiduría de imperio de anciano"],
    "ca": ["Mestria d''ancià de Capricorn", "Ensenyament estructural disciplinat", "Compartir d''autoritat pacient", "Saviesa d''imperi d''ancià"]
  }'::jsonb,
  '{
    "en": ["Mentor with patient Capricorn authority and discipline", "Teach structural principles that endure across generations", "Share empire-building wisdom with earned gravitas", "Grateful for mastery that creates permanent foundations for others"],
    "es": ["Mentora con autoridad y disciplina paciente de Capricornio", "Enseña principios estructurales que perduran a través de generaciones", "Comparte sabiduría de construcción de imperio con gravitas ganada", "Agradecido por maestría que crea cimientos permanentes para otros"],
    "ca": ["Mentor amb autoritat i disciplina pacient de Capricorn", "Ensenyar principis estructurals que perduren a través de generacions", "Comparteix saviesa de construcció d''imperi amb gravitas guanyada", "Agraït per mestria que crea fonaments permanents per a altres"]
  }'::jsonb
);

-- =====================================================
-- EARTH ELEMENT × 4 SEASONS
-- =====================================================

-- 🌍 WANING GIBBOUS + EARTH + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_gibbous' AND element = 'earth' LIMIT 1),
  'spring',
  '{
    "en": "Spring Earth Distributes Sensory Abundance Generously",
    "es": "La Tierra de Primavera Distribuye Abundancia Sensorial Generosamente",
    "ca": "La Terra de Primavera Distribueix Abundància Sensorial Generosament"
  }'::jsonb,
  '{
    "en": "The waning gibbous'' harvest-distribution meets spring''s overflowing fertility. As Taurus abundance (April-May) shares tangible overflow, gratitude becomes sensory-generosity - you feed EVERYONE from blooming bounty with maiden joy.",
    "es": "La distribución de cosecha de la luna gibosa menguante se encuentra con la fertilidad desbordante de la primavera. Mientras la abundancia de Tauro (abril-mayo) comparte desbordamiento tangible, la gratitud se convierte en generosidad sensorial - alimentas a TODOS de la abundancia floreciente con alegría de doncella.",
    "ca": "La distribució de collita de la lluna gibosa minvant es troba amb la fertilitat desbordant de la primavera. Mentre l''abundància de Taure (abril-maig) comparteix desbordament tangible, la gratitud es converteix en generositat sensorial - alimentes TOTHOM de l''abundància florent amb alegria de donzella."
  }'::jsonb,
  '{
    "en": "Earth''s gratitude overflows with spring''s maiden generosity. Share TANGIBLE physical abundance - food, resources, beauty. Teach through providing - let others SEE, TOUCH, TASTE generosity.",
    "es": "La gratitud de la tierra se desborda con la generosidad doncella de la primavera. Comparte abundancia física TANGIBLE - comida, recursos, belleza. Enseña proporcionando - deja que otros VEAN, TOQUEN, PRUEBEN la generosidad.",
    "ca": "La gratitud de la terra es desborda amb la generositat donzella de la primavera. Comparteix abundància física TANGIBLE - menjar, recursos, bellesa. Ensenyar proporcionant - deixa que altres VEGIN, TOQUIN, PROVIN la generositat."
  }'::jsonb,
  '{
    "en": ["Taurus overflow-sharing", "Sensory abundance-distribution", "Tangible generous provision", "Maiden fertility-bounty"],
    "es": ["Compartir de desbordamiento de Tauro", "Distribución de abundancia sensorial", "Provisión generosa tangible", "Abundancia de fertilidad de doncella"],
    "ca": ["Compartir de desbordament de Taure", "Distribució d''abundància sensorial", "Provisió generosa tangible", "Abundància de fertilitat de donzella"]
  }'::jsonb,
  '{
    "en": ["Share tangible physical abundance - feed, clothe, provide", "Distribute sensory beauty generously from overflowing harvest", "Teach abundance through VISIBLE generous provision", "Grateful for fertility that produces MORE than enough for all"],
    "es": ["Comparte abundancia física tangible - alimenta, viste, provee", "Distribuye belleza sensorial generosamente de cosecha desbordante", "Enseña abundancia a través de provisión generosa VISIBLE", "Agradecido por fertilidad que produce MÁS que suficiente para todos"],
    "ca": ["Comparteix abundància física tangible - alimenta, vesteix, proveeix", "Distribueix bellesa sensorial generosament de collita desbordant", "Ensenyar abundància a través de provisió generosa VISIBLE", "Agraït per fertilitat que produeix MÉS que suficient per a tots"]
  }'::jsonb
);

-- 🌍 WANING GIBBOUS + EARTH + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_gibbous' AND element = 'earth' LIMIT 1),
  'summer',
  '{
    "en": "Summer Earth Shares Perfection With Devoted Care",
    "es": "La Tierra de Verano Comparte Perfección Con Cuidado Devoto",
    "ca": "La Terra d''Estiu Comparteix Perfecció Amb Cura Devota"
  }'::jsonb,
  '{
    "en": "The waning gibbous'' wisdom-distribution meets summer''s meticulous devotion. As Virgo precision (August-September) teaches flawless methods, gratitude becomes service-teaching - you share perfected skills with loving attention to detail.",
    "es": "La distribución de sabiduría de la luna gibosa menguante se encuentra con la devoción meticulosa del verano. Mientras la precisión de Virgo (agosto-septiembre) enseña métodos impecables, la gratitud se convierte en enseñanza de servicio - compartes habilidades perfeccionadas con atención amorosa al detalle.",
    "ca": "La distribució de saviesa de la lluna gibosa minvant es troba amb la devoció meticulosa de l''estiu. Mentre la precisió de Verge (agost-setembre) ensenya mètodes impecables, la gratitud es converteix en ensenyament de servei - comparteixes habilitats perfeccionades amb atenció amorosa al detall."
  }'::jsonb,
  '{
    "en": "Earth''s gratitude becomes precise with summer''s mother care-teaching. Share PERFECTED methods and skills devotedly. Teach through meticulous service - show EVERY detail matters.",
    "es": "La gratitud de la tierra se vuelve precisa con la enseñanza de cuidado maternal del verano. Comparte métodos y habilidades PERFECCIONADOS devotamente. Enseña a través del servicio meticuloso - muestra que CADA detalle importa.",
    "ca": "La gratitud de la terra es torna precisa amb l''ensenyament de cura maternal de l''estiu. Comparteix mètodes i habilitats PERFECCIONATS devotament. Ensenyar a través del servei meticulós - mostra que CADA detall importa."
  }'::jsonb,
  '{
    "en": ["Virgo precision-teaching", "Devoted skill-sharing", "Meticulous service-mentorship", "Mother''s perfected care"],
    "es": ["Enseñanza de precisión de Virgo", "Compartir de habilidades devoto", "Mentoría de servicio meticuloso", "Cuidado perfeccionado de madre"],
    "ca": ["Ensenyament de precisió de Verge", "Compartir d''habilitats devot", "Mentoria de servei meticulós", "Cura perfeccionada de mare"]
  }'::jsonb,
  '{
    "en": ["Teach perfected methods with Virgo loving precision", "Share practical skills with devoted attention to detail", "Mentor through meticulous helpful service", "Grateful for mastery refined enough to serve others perfectly"],
    "es": ["Enseña métodos perfeccionados con precisión amorosa de Virgo", "Comparte habilidades prácticas con atención devota al detalle", "Mentora a través del servicio útil meticuloso", "Agradecido por maestría refinada lo suficiente para servir a otros perfectamente"],
    "ca": ["Ensenyar mètodes perfeccionats amb precisió amorosa de Verge", "Comparteix habilitats pràctiques amb atenció devota al detall", "Mentor a través del servei útil meticulós", "Agraït per mestria refinada prou per servir a altres perfectament"]
  }'::jsonb
);

-- 🌍 WANING GIBBOUS + EARTH + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_gibbous' AND element = 'earth' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Earth Distributes Harvest With Strategic Wisdom",
    "es": "La Tierra de Otoño Distribuye Cosecha Con Sabiduría Estratégica",
    "ca": "La Terra de Tardor Distribueix Collita Amb Saviesa Estratègica"
  }'::jsonb,
  '{
    "en": "The waning gibbous'' resource-distribution meets autumn''s shrewd wisdom. As Capricorn mastery (December-January) allocates harvest strategically, gratitude becomes wealth-stewardship - you share resources where they serve maximum good.",
    "es": "La distribución de recursos de la luna gibosa menguante se encuentra con la sabiduría astuta del otoño. Mientras la maestría de Capricornio (diciembre-enero) asigna cosecha estratégicamente, la gratitud se convierte en administración de riqueza - compartes recursos donde sirven al máximo bien.",
    "ca": "La distribució de recursos de la lluna gibosa minvant es troba amb la saviesa astuta de la tardor. Mentre la mestria de Capricorn (desembre-gener) assigna collita estratègicament, la gratitud es converteix en administració de riquesa - comparteixes recursos on serveixen al màxim bé."
  }'::jsonb,
  '{
    "en": "Earth''s gratitude becomes strategic with autumn''s crone resource-wisdom. Share harvest WHERE it creates most abundance. Teach wise stewardship - distribute resources shrewdly for maximum collective benefit.",
    "es": "La gratitud de la tierra se vuelve estratégica con la sabiduría de recursos de la anciana del otoño. Comparte cosecha DONDE crea más abundancia. Enseña administración sabia - distribuye recursos astutamente para máximo beneficio colectivo.",
    "ca": "La gratitud de la terra es torna estratègica amb la saviesa de recursos de l''anciana de la tardor. Comparteix collita ON crea més abundància. Ensenyar administració sàvia - distribueix recursos astutament per a màxim benefici col·lectiu."
  }'::jsonb,
  '{
    "en": ["Capricorn strategic-distribution", "Shrewd resource-stewardship", "Wise harvest-allocation", "Crone''s wealth-wisdom"],
    "es": ["Distribución estratégica de Capricornio", "Administración astuta de recursos", "Asignación sabia de cosecha", "Sabiduría de riqueza de anciana"],
    "ca": ["Distribució estratègica de Capricorn", "Administració astuta de recursos", "Assignació sàvia de collita", "Saviesa de riquesa d''anciana"]
  }'::jsonb,
  '{
    "en": ["Share resources strategically where they create maximum good", "Distribute harvest wealth with crone shrewd wisdom", "Teach resource stewardship for collective abundance", "Grateful for harvest that can be allocated to serve all wisely"],
    "es": ["Comparte recursos estratégicamente donde crean máximo bien", "Distribuye riqueza de cosecha con sabiduría astuta de anciana", "Enseña administración de recursos para abundancia colectiva", "Agradecido por cosecha que puede asignarse para servir a todos sabiamente"],
    "ca": ["Comparteix recursos estratègicament on creen màxim bé", "Distribueix riquesa de collita amb saviesa astuta d''anciana", "Ensenyar administració de recursos per a abundància col·lectiva", "Agraït per collita que pot assignar-se per servir a tots sàviament"]
  }'::jsonb
);

-- 🌍 WANING GIBBOUS + EARTH + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_gibbous' AND element = 'earth' LIMIT 1),
  'winter',
  '{
    "en": "Winter Earth Shares Deep Foundational Wisdom",
    "es": "La Tierra del Invierno Comparte Sabiduría Fundamental Profunda",
    "ca": "La Terra de l''Hivern Comparteix Saviesa Fonamental Profunda"
  }'::jsonb,
  '{
    "en": "The waning gibbous'' teaching-phase meets winter''s underground wisdom. As Taurus endurance (April-May) shares root-deep knowledge, gratitude becomes foundation-teaching - you pass down eternal anchoring principles with geological patience.",
    "es": "La fase de enseñanza de la luna gibosa menguante se encuentra con la sabiduría subterránea del invierno. Mientras la resistencia de Tauro (abril-mayo) comparte conocimiento profundo de raíz, la gratitud se convierte en enseñanza de cimientos - transmites principios de anclaje eterno con paciencia geológica.",
    "ca": "La fase d''ensenyament de la lluna gibosa minvant es troba amb la saviesa subterrània de l''hivern. Mentre la resistència de Taure (abril-maig) comparteix coneixement profund d''arrel, la gratitud es converteix en ensenyament de fonaments - transmet principis d''ancoratge etern amb paciència geològica."
  }'::jsonb,
  '{
    "en": "Earth''s gratitude descends into winter''s elder depths-sharing. Teach FOUNDATIONAL principles that anchor eternally. Share root-wisdom patiently - invisible knowledge that endures forever.",
    "es": "La gratitud de la tierra desciende al compartir de profundidades ancianas del invierno. Enseña principios FUNDAMENTALES que anclan eternamente. Comparte sabiduría de raíz pacientemente - conocimiento invisible que perdura para siempre.",
    "ca": "La gratitud de la terra descendeix al compartir de profunditats ancianes de l''hivern. Ensenyar principis FONAMENTALS que ancoren eternament. Comparteix saviesa d''arrel pacientment - coneixement invisible que perdura per sempre."
  }'::jsonb,
  '{
    "en": ["Taurus foundational-teaching", "Deep root-wisdom sharing", "Patient eternal-principle", "Elder''s underground knowledge"],
    "es": ["Enseñanza fundamental de Tauro", "Compartir de sabiduría de raíz profunda", "Principio eterno paciente", "Conocimiento subterráneo de anciano"],
    "ca": ["Ensenyament fonamental de Taure", "Compartir de saviesa d''arrel profunda", "Principi etern pacient", "Coneixement subterrani d''ancià"]
  }'::jsonb,
  '{
    "en": ["Share foundational wisdom that anchors others eternally", "Teach root-deep principles with Taurus patient devotion", "Distribute invisible knowledge that endures across time", "Grateful for depths that can anchor future generations"],
    "es": ["Comparte sabiduría fundamental que ancla a otros eternamente", "Enseña principios profundos de raíz con devoción paciente de Tauro", "Distribuye conocimiento invisible que perdura a través del tiempo", "Agradecido por profundidades que pueden anclar generaciones futuras"],
    "ca": ["Comparteix saviesa fonamental que ancora a altres eternament", "Ensenyar principis profunds d''arrel amb devoció pacient de Taure", "Distribueix coneixement invisible que perdura a través del temps", "Agraït per profunditats que poden ancorar generacions futures"]
  }'::jsonb
);

-- =====================================================
-- AIR ELEMENT × 4 SEASONS
-- =====================================================

-- 💨 WANING GIBBOUS + AIR + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_gibbous' AND element = 'air' LIMIT 1),
  'spring',
  '{
    "en": "Spring Winds Spread Ideas With Playful Generosity",
    "es": "Los Vientos de Primavera Esparcen Ideas Con Generosidad Juguetona",
    "ca": "Els Vents de Primavera Escampen Idees Amb Generositat Joganera"
  }'::jsonb,
  '{
    "en": "The waning gibbous'' idea-sharing meets spring''s explosive communication. As Gemini curiosity (May-June) distributes insights playfully, gratitude becomes conversation-generosity - you pollinate minds EVERYWHERE with joyful maiden curiosity.",
    "es": "El compartir de ideas de la luna gibosa menguante se encuentra con la comunicación explosiva de la primavera. Mientras la curiosidad de Géminis (mayo-junio) distribuye perspectivas juguetonamente, la gratitud se convierte en generosidad de conversación - polinizas mentes EN TODAS PARTES con curiosidad gozosa de doncella.",
    "ca": "El compartir d''idees de la lluna gibosa minvant es troba amb la comunicació explosiva de la primavera. Mentre la curiositat de Bessons (maig-juny) distribueix perspectives joganerament, la gratitud es converteix en generositat de conversa - pol·linitzis ments A TOT ARREU amb curiositat joiosa de donzella."
  }'::jsonb,
  '{
    "en": "Air''s gratitude explodes with spring''s maiden communication-bloom. Share ideas PLAYFULLY and widely. Teach through exploratory conversation - let curiosity spread EVERYWHERE at once.",
    "es": "La gratitud del aire explota con la floración de comunicación doncella de la primavera. Comparte ideas JUGUETONAMENTE y ampliamente. Enseña a través de conversación exploratoria - deja que la curiosidad se esparza EN TODAS PARTES a la vez.",
    "ca": "La gratitud de l''aire explota amb la floració de comunicació donzella de la primavera. Comparteix idees JOGANERAMENT i àmpliament. Ensenyar a través de conversa exploratòria - deixa que la curiositat s''escampi A TOT ARREU alhora."
  }'::jsonb,
  '{
    "en": ["Gemini playful-sharing", "Explosive idea-pollination", "Curious generous conversation", "Maiden communication-bloom"],
    "es": ["Compartir juguetón de Géminis", "Polinización explosiva de ideas", "Conversación generosa curiosa", "Florecimiento de comunicación doncella"],
    "ca": ["Compartir joganera de Bessons", "Pol·linització explosiva d''idees", "Conversa generosa curiosa", "Floriment de comunicació donzella"]
  }'::jsonb,
  '{
    "en": ["Share insights playfully in MANY conversations everywhere", "Distribute ideas generously through curious exploration", "Teach by pollinating minds with joyful communication", "Grateful for wisdom that can spread to ALL through connection"],
    "es": ["Comparte perspectivas juguetonamente en MUCHAS conversaciones en todas partes", "Distribuye ideas generosamente a través de exploración curiosa", "Enseña polinizando mentes con comunicación gozosa", "Agradecido por sabiduría que puede esparcirse a TODOS a través de conexión"],
    "ca": ["Comparteix perspectives joganerament en MOLTES converses a tot arreu", "Distribueix idees generosament a través d''exploració curiosa", "Ensenyar pol·linitzant ments amb comunicació joiosa", "Agraït per saviesa que pot escampar-se a TOTS a través de connexió"]
  }'::jsonb
);

-- 💨 WANING GIBBOUS + AIR + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_gibbous' AND element = 'air' LIMIT 1),
  'summer',
  '{
    "en": "Summer Breezes Share Balance With Graceful Diplomacy",
    "es": "Las Brisas de Verano Comparten Equilibrio Con Diplomacia Graciosa",
    "ca": "Les Brises d''Estiu Comparteixen Equilibri Amb Diplomàcia Graciosa"
  }'::jsonb,
  '{
    "en": "The waning gibbous'' wisdom-distribution meets summer''s harmonious grace. As Libra balance (September-October) teaches collaborative beauty, gratitude becomes partnership-mentorship - you share reciprocal wisdom with diplomatic generosity.",
    "es": "La distribución de sabiduría de la luna gibosa menguante se encuentra con la gracia armoniosa del verano. Mientras el equilibrio de Libra (septiembre-octubre) enseña belleza colaborativa, la gratitud se convierte en mentoría de asociación - compartes sabiduría recíproca con generosidad diplomática.",
    "ca": "La distribució de saviesa de la lluna gibosa minvant es troba amb la gràcia harmoniosa de l''estiu. Mentre l''equilibri de Balança (setembre-octubre) ensenya bellesa col·laborativa, la gratitud es converteix en mentoria d''associació - comparteixes saviesa recíproca amb generositat diplomàtica."
  }'::jsonb,
  '{
    "en": "Air''s gratitude becomes harmonious with summer''s mother diplomacy-sharing. Teach BALANCE and reciprocity gracefully. Share partnership wisdom that creates beautiful mutual exchange.",
    "es": "La gratitud del aire se vuelve armoniosa con el compartir de diplomacia maternal del verano. Enseña EQUILIBRIO y reciprocidad graciosamente. Comparte sabiduría de asociación que crea intercambio mutuo hermoso.",
    "ca": "La gratitud de l''aire es torna harmoniosa amb el compartir de diplomàcia maternal de l''estiu. Ensenyar EQUILIBRI i reciprocitat graciosament. Comparteix saviesa d''associació que crea intercanvi mutu bell."
  }'::jsonb,
  '{
    "en": ["Libra graceful-mentorship", "Diplomatic balance-teaching", "Harmonious reciprocal-sharing", "Mother''s partnership-wisdom"],
    "es": ["Mentoría graciosa de Libra", "Enseñanza de equilibrio diplomático", "Compartir recíproco armonioso", "Sabiduría de asociación de madre"],
    "ca": ["Mentoria graciosa de Balança", "Ensenyament d''equilibri diplomàtic", "Compartir recíproc harmoniós", "Saviesa d''associació de mare"]
  }'::jsonb,
  '{
    "en": ["Teach balanced collaboration with Libra graceful generosity", "Share partnership wisdom that honors all perspectives", "Mentor through diplomatic harmonious exchange", "Grateful for balance-insights that create beautiful connection"],
    "es": ["Enseña colaboración equilibrada con generosidad graciosa de Libra", "Comparte sabiduría de asociación que honra todas las perspectivas", "Mentora a través del intercambio diplomático armonioso", "Agradecido por perspectivas de equilibrio que crean conexión hermosa"],
    "ca": ["Ensenyar col·laboració equilibrada amb generositat graciosa de Balança", "Comparteix saviesa d''associació que honra totes les perspectives", "Mentor a través de l''intercanvi diplomàtic harmoniós", "Agraït per perspectives d''equilibri que creen connexió bella"]
  }'::jsonb
);

-- 💨 WANING GIBBOUS + AIR + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_gibbous' AND element = 'air' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Air Spreads Revolutionary Vision Generously",
    "es": "El Aire de Otoño Esparce Visión Revolucionaria Generosamente",
    "ca": "L''Aire de Tardor Escampa Visió Revolucionària Generosament"
  }'::jsonb,
  '{
    "en": "The waning gibbous'' collective-sharing meets autumn''s visionary innovation. As Aquarius evolution (January-February) distributes breakthrough insights, gratitude becomes revolution-teaching - you share future-vision that liberates ALL beings.",
    "es": "El compartir colectivo de la luna gibosa menguante se encuentra con la innovación visionaria del otoño. Mientras la evolución de Acuario (enero-febrero) distribuye perspectivas de avance, la gratitud se convierte en enseñanza de revolución - compartes visión de futuro que libera a TODOS los seres.",
    "ca": "El compartir col·lectiu de la lluna gibosa minvant es troba amb la innovació visionària de la tardor. Mentre l''evolució d''Aquari (gener-febrer) distribueix perspectives d''avenç, la gratitud es converteix en ensenyament de revolució - comparteixes visió de futur que allibera TOTS els éssers."
  }'::jsonb,
  '{
    "en": "Air''s gratitude becomes revolutionary with autumn''s crone vision-sharing. Teach EVOLUTIONARY systems-thinking. Share innovations that upgrade collective consciousness for all humanity.",
    "es": "La gratitud del aire se vuelve revolucionaria con el compartir de visión de la anciana del otoño. Enseña pensamiento de sistemas EVOLUTIVO. Comparte innovaciones que actualizan la conciencia colectiva para toda la humanidad.",
    "ca": "La gratitud de l''aire es torna revolucionària amb el compartir de visió de l''anciana de la tardor. Ensenyar pensament de sistemes EVOLUTIU. Comparteix innovacions que actualitzen la consciència col·lectiva per a tota la humanitat."
  }'::jsonb,
  '{
    "en": ["Aquarius vision-distribution", "Revolutionary systems-teaching", "Evolutionary collective-sharing", "Crone''s liberating-innovation"],
    "es": ["Distribución de visión de Acuario", "Enseñanza de sistemas revolucionarios", "Compartir colectivo evolutivo", "Innovación liberadora de anciana"],
    "ca": ["Distribució de visió d''Aquari", "Ensenyament de sistemes revolucionaris", "Compartir col·lectiu evolutiu", "Innovació alliberadora d''anciana"]
  }'::jsonb,
  '{
    "en": ["Share visionary insights that liberate collective consciousness", "Teach revolutionary systems-thinking for humanity''s evolution", "Distribute innovations that free ALL beings", "Grateful for breakthrough vision that can upgrade the whole"],
    "es": ["Comparte perspectivas visionarias que liberan la conciencia colectiva", "Enseña pensamiento de sistemas revolucionario para la evolución de la humanidad", "Distribuye innovaciones que liberan a TODOS los seres", "Agradecido por visión de avance que puede actualizar el todo"],
    "ca": ["Comparteix perspectives visionàries que alliberen la consciència col·lectiva", "Ensenyar pensament de sistemes revolucionari per a l''evolució de la humanitat", "Distribueix innovacions que alliberen TOTS els éssers", "Agraït per visió d''avenç que pot actualitzar el tot"]
  }'::jsonb
);

-- 💨 WANING GIBBOUS + AIR + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_gibbous' AND element = 'air' LIMIT 1),
  'winter',
  '{
    "en": "Winter Silence Shares Crystal-Truth Patiently",
    "es": "El Silencio del Invierno Comparte Verdad de Cristal Pacientemente",
    "ca": "El Silenci de l''Hivern Comparteix Veritat de Cristall Pacientment"
  }'::jsonb,
  '{
    "en": "The waning gibbous'' knowledge-distribution meets winter''s contemplative clarity. As Gemini curiosity (May-June) shares diamond-insights quietly, gratitude becomes clarity-teaching - you pass down crystallized truth with silent patient wisdom.",
    "es": "La distribución de conocimiento de la luna gibosa menguante se encuentra con la claridad contemplativa del invierno. Mientras la curiosidad de Géminis (mayo-junio) comparte perspectivas de diamante silenciosamente, la gratitud se convierte en enseñanza de claridad - transmites verdad cristalizada con sabiduría silenciosa paciente.",
    "ca": "La distribució de coneixement de la lluna gibosa minvant es troba amb la claredat contemplativa de l''hivern. Mentre la curiositat de Bessons (maig-juny) comparteix perspectives de diamant silenciosament, la gratitud es converteix en ensenyament de claredat - transmet veritat cristal·litzada amb saviesa silenciosa pacient."
  }'::jsonb,
  '{
    "en": "Air''s gratitude crystallizes with winter''s elder silent-teaching. Share ABSOLUTE truth with quiet certainty. Teach through contemplative clarity - diamond-hard understanding needs few words.",
    "es": "La gratitud del aire se cristaliza con la enseñanza silenciosa anciana del invierno. Comparte verdad ABSOLUTA con certeza silenciosa. Enseña a través de claridad contemplativa - comprensión dura como diamante necesita pocas palabras.",
    "ca": "La gratitud de l''aire es cristal·litza amb l''ensenyament silenciós ancià de l''hivern. Comparteix veritat ABSOLUTA amb certesa silenciosa. Ensenyar a través de claredat contemplativa - comprensió dura com diamant necessita poques paraules."
  }'::jsonb,
  '{
    "en": ["Gemini silent-wisdom", "Crystalline truth-sharing", "Contemplative patient-teaching", "Elder''s diamond-clarity"],
    "es": ["Sabiduría silenciosa de Géminis", "Compartir de verdad cristalina", "Enseñanza paciente contemplativa", "Claridad de diamante de anciano"],
    "ca": ["Saviesa silenciosa de Bessons", "Compartir de veritat cristal·lina", "Ensenyament pacient contemplatiu", "Claredat de diamant d''ancià"]
  }'::jsonb,
  '{
    "en": ["Share absolute truth with quiet contemplative certainty", "Teach crystallized wisdom with patient few words", "Distribute diamond-clarity that cuts through all confusion", "Grateful for truth so pure it requires only silence to transmit"],
    "es": ["Comparte verdad absoluta con certeza contemplativa silenciosa", "Enseña sabiduría cristalizada con pocas palabras pacientes", "Distribuye claridad de diamante que corta toda confusión", "Agradecido por verdad tan pura que requiere solo silencio para transmitir"],
    "ca": ["Comparteix veritat absoluta amb certesa contemplativa silenciosa", "Ensenyar saviesa cristal·litzada amb poques paraules pacients", "Distribueix claredat de diamant que talla tota confusió", "Agraït per veritat tan pura que requereix només silenci per transmetre"]
  }'::jsonb
);

-- =====================================================
-- WATER ELEMENT × 4 SEASONS
-- =====================================================

-- 💧 WANING GIBBOUS + WATER + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_gibbous' AND element = 'water' LIMIT 1),
  'spring',
  '{
    "en": "Spring Waters Share Emotional Overflow With Courage",
    "es": "Las Aguas de Primavera Comparten Desbordamiento Emocional Con Coraje",
    "ca": "Les Aigües de Primavera Comparteixen Desbordament Emocional Amb Coratge"
  }'::jsonb,
  '{
    "en": "The waning gibbous'' emotional-sharing meets spring''s heart-blooming courage. As Cancer nurturing (June-July) distributes vulnerable connection-wisdom, gratitude becomes emotional-generosity - you share feelings OPENLY with brave maiden heart.",
    "es": "El compartir emocional de la luna gibosa menguante se encuentra con el coraje de florecimiento de corazón de la primavera. Mientras el cuidado de Cáncer (junio-julio) distribuye sabiduría de conexión vulnerable, la gratitud se convierte en generosidad emocional - compartes sentimientos ABIERTAMENTE con corazón valiente de doncella.",
    "ca": "El compartir emocional de la lluna gibosa minvant es troba amb el coratge de floriment de cor de la primavera. Mentre la cura de Cranc (juny-juliol) distribueix saviesa de connexió vulnerable, la gratitud es converteix en generositat emocional - comparteixes sentiments OBERTAMENT amb cor valent de donzella."
  }'::jsonb,
  '{
    "en": "Water''s gratitude overflows with spring''s maiden heart-courage. Share VULNERABLE emotional truth generously. Teach intimacy through brave feeling-overflow - let hearts connect through openness.",
    "es": "La gratitud del agua se desborda con el coraje de corazón doncella de la primavera. Comparte verdad emocional VULNERABLE generosamente. Enseña intimidad a través del desbordamiento valiente de sentimientos - deja que los corazones se conecten a través de la apertura.",
    "ca": "La gratitud de l''aigua es desborda amb el coratge de cor donzella de la primavera. Comparteix veritat emocional VULNERABLE generosament. Ensenyar intimitat a través del desbordament valent de sentiments - deixa que els cors es connectin a través de l''obertura."
  }'::jsonb,
  '{
    "en": ["Cancer vulnerable-sharing", "Brave emotional-overflow", "Open heart-generosity", "Maiden intimacy-courage"],
    "es": ["Compartir vulnerable de Cáncer", "Desbordamiento emocional valiente", "Generosidad de corazón abierto", "Coraje de intimidad doncella"],
    "ca": ["Compartir vulnerable de Cranc", "Desbordament emocional valent", "Generositat de cor obert", "Coratge d''intimitat donzella"]
  }'::jsonb,
  '{
    "en": ["Share vulnerable feelings openly with brave Cancer courage", "Distribute emotional wisdom through generous heart-opening", "Teach intimacy by modeling courageous vulnerability", "Grateful for overflowing love that can nourish ALL hearts"],
    "es": ["Comparte sentimientos vulnerables abiertamente con coraje valiente de Cáncer", "Distribuye sabiduría emocional a través de apertura generosa de corazón", "Enseña intimidad modelando vulnerabilidad valiente", "Agradecido por amor desbordante que puede nutrir TODOS los corazones"],
    "ca": ["Comparteix sentiments vulnerables obertament amb coratge valent de Cranc", "Distribueix saviesa emocional a través d''obertura generosa de cor", "Ensenyar intimitat modelant vulnerabilitat valenta", "Agraït per amor desbordant que pot nodrir TOTS els cors"]
  }'::jsonb
);

-- 💧 WANING GIBBOUS + WATER + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_gibbous' AND element = 'water' LIMIT 1),
  'summer',
  '{
    "en": "Summer Waters Share Transformation With Intensity",
    "es": "Las Aguas del Verano Comparten Transformación Con Intensidad",
    "ca": "Les Aigües de l''Estiu Comparteixen Transformació Amb Intensitat"
  }'::jsonb,
  '{
    "en": "The waning gibbous'' wisdom-distribution meets summer''s alchemical depth. As Scorpio intensity (October-November) teaches soul-rebirth processes, gratitude becomes transformation-sharing - you guide others through metamorphosis with passionate devotion.",
    "es": "La distribución de sabiduría de la luna gibosa menguante se encuentra con la profundidad alquímica del verano. Mientras la intensidad de Escorpio (octubre-noviembre) enseña procesos de renacimiento del alma, la gratitud se convierte en compartir de transformación - guías a otros a través de metamorfosis con devoción apasionada.",
    "ca": "La distribució de saviesa de la lluna gibosa minvant es troba amb la profunditat alquímica de l''estiu. Mentre la intensitat d''Escorpí (octubre-novembre) ensenya processos de renaixement de l''ànima, la gratitud es converteix en compartir de transformació - guies a altres a través de metamorfosi amb devoció apassionada."
  }'::jsonb,
  '{
    "en": "Water''s gratitude becomes alchemical with summer''s mother transformation-teaching. Share REBIRTH wisdom intensely. Teach soul-metamorphosis - guide others through sacred emotional fire.",
    "es": "La gratitud del agua se vuelve alquímica con la enseñanza de transformación maternal del verano. Comparte sabiduría de RENACIMIENTO intensamente. Enseña metamorfosis del alma - guía a otros a través del fuego emocional sagrado.",
    "ca": "La gratitud de l''aigua es torna alquímica amb l''ensenyament de transformació maternal de l''estiu. Comparteix saviesa de RENAIXEMENT intensament. Ensenyar metamorfosi de l''ànima - guiar a altres a través del foc emocional sagrat."
  }'::jsonb,
  '{
    "en": ["Scorpio alchemical-teaching", "Intense transformation-sharing", "Soul-rebirth guidance", "Mother''s metamorphic wisdom"],
    "es": ["Enseñanza alquímica de Escorpio", "Compartir de transformación intensa", "Guía de renacimiento del alma", "Sabiduría metamórfica de madre"],
    "ca": ["Ensenyament alquímic d''Escorpí", "Compartir de transformació intensa", "Guia de renaixement de l''ànima", "Saviesa metamòrfica de mare"]
  }'::jsonb,
  '{
    "en": ["Share transformation wisdom with Scorpio passionate intensity", "Teach soul-rebirth processes from your own metamorphosis", "Guide others through alchemical emotional fire devotedly", "Grateful for rebirth-knowledge that can transform ALL beings"],
    "es": ["Comparte sabiduría de transformación con intensidad apasionada de Escorpio", "Enseña procesos de renacimiento del alma desde tu propia metamorfosis", "Guía a otros a través del fuego emocional alquímico devotamente", "Agradecido por conocimiento de renacimiento que puede transformar a TODOS los seres"],
    "ca": ["Comparteix saviesa de transformació amb intensitat apassionada d''Escorpí", "Ensenyar processos de renaixement de l''ànima des de la teva pròpia metamorfosi", "Guiar a altres a través del foc emocional alquímic devotament", "Agraït per coneixement de renaixement que pot transformar TOTS els éssers"]
  }'::jsonb
);

-- 💧 WANING GIBBOUS + WATER + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_gibbous' AND element = 'water' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Waters Share Universal Compassion Boundlessly",
    "es": "Las Aguas de Otoño Comparten Compasión Universal Sin Límites",
    "ca": "Les Aigües de Tardor Comparteixen Compassió Universal Sense Límits"
  }'::jsonb,
  '{
    "en": "The waning gibbous'' empathy-distribution meets autumn''s mystical oneness. As Pisces compassion (February-March) teaches universal heart-unity, gratitude becomes boundary-dissolving love - you share empathy that recognizes all beings as ONE.",
    "es": "La distribución de empatía de la luna gibosa menguante se encuentra con la unidad mística del otoño. Mientras la compasión de Piscis (febrero-marzo) enseña unidad de corazón universal, la gratitud se convierte en amor que disuelve límites - compartes empatía que reconoce a todos los seres como UNO.",
    "ca": "La distribució d''empatia de la lluna gibosa minvant es troba amb la unitat mística de la tardor. Mentre la compassió de Peixos (febrer-març) ensenya unitat de cor universal, la gratitud es converteix en amor que dissol límits - comparteixes empatia que reconeix tots els éssers com U."
  }'::jsonb,
  '{
    "en": "Water''s gratitude becomes boundaryless with autumn''s crone compassion-sharing. Teach UNIVERSAL empathy and unity. Share mystical heart-wisdom that dissolves all separation.",
    "es": "La gratitud del agua se vuelve sin límites con el compartir de compasión de la anciana del otoño. Enseña empatía y unidad UNIVERSAL. Comparte sabiduría de corazón mística que disuelve toda separación.",
    "ca": "La gratitud de l''aigua es torna sense límits amb el compartir de compassió de l''anciana de la tardor. Ensenyar empatia i unitat UNIVERSAL. Comparteix saviesa de cor mística que dissol tota separació."
  }'::jsonb,
  '{
    "en": ["Pisces universal-compassion", "Boundaryless empathy-sharing", "Mystical unity-teaching", "Crone''s dissolving-love"],
    "es": ["Compasión universal de Piscis", "Compartir de empatía sin límites", "Enseñanza de unidad mística", "Amor que disuelve de anciana"],
    "ca": ["Compassió universal de Peixos", "Compartir d''empatia sense límits", "Ensenyament d''unitat mística", "Amor que dissol d''anciana"]
  }'::jsonb,
  '{
    "en": ["Share compassion that recognizes ALL beings as interconnected", "Teach universal empathy with Pisces boundaryless love", "Distribute mystical wisdom that dissolves separation", "Grateful for unity-knowing that heals collective suffering"],
    "es": ["Comparte compasión que reconoce a TODOS los seres como interconectados", "Enseña empatía universal con amor sin límites de Piscis", "Distribuye sabiduría mística que disuelve separación", "Agradecido por conocimiento de unidad que sana sufrimiento colectivo"],
    "ca": ["Comparteix compassió que reconeix TOTS els éssers com interconnectats", "Ensenyar empatia universal amb amor sense límits de Peixos", "Distribueix saviesa mística que dissol separació", "Agraït per coneixement d''unitat que sana sofriment col·lectiu"]
  }'::jsonb
);

-- 💧 WANING GIBBOUS + WATER + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waning_gibbous' AND element = 'water' LIMIT 1),
  'winter',
  '{
    "en": "Winter Waters Share Sacred Sanctuary-Wisdom Patiently",
    "es": "Las Aguas del Invierno Comparten Sabiduría de Santuario Sagrado Pacientemente",
    "ca": "Les Aigües de l''Hivern Comparteixen Saviesa de Santuari Sagrat Pacientment"
  }'::jsonb,
  '{
    "en": "The waning gibbous'' trust-teaching meets winter''s sheltered devotion. As Cancer protection (June-July) shares sanctuary-creation wisdom, gratitude becomes safe-container teaching - you show others how to build sacred emotional spaces patiently.",
    "es": "La enseñanza de confianza de la luna gibosa menguante se encuentra con la devoción protegida del invierno. Mientras la protección de Cáncer (junio-julio) comparte sabiduría de creación de santuario, la gratitud se convierte en enseñanza de contenedor seguro - muestras a otros cómo construir espacios emocionales sagrados pacientemente.",
    "ca": "L''ensenyament de confiança de la lluna gibosa minvant es troba amb la devoció protegida de l''hivern. Mentre la protecció de Cranc (juny-juliol) comparteix saviesa de creació de santuari, la gratitud es converteix en ensenyament de contenidor segur - mostres a altres com construir espais emocionals sagrats pacientment."
  }'::jsonb,
  '{
    "en": "Water''s gratitude becomes sheltering with winter''s elder sanctuary-sharing. Teach SAFE CONTAINER creation patiently. Share trust-building wisdom that protects deepest vulnerability.",
    "es": "La gratitud del agua se vuelve protectora con el compartir de santuario anciano del invierno. Enseña creación de CONTENEDOR SEGURO pacientemente. Comparte sabiduría de construcción de confianza que protege la vulnerabilidad más profunda.",
    "ca": "La gratitud de l''aigua es torna protectora amb el compartir de santuari ancià de l''hivern. Ensenyar creació de CONTENIDOR SEGUR pacientment. Comparteix saviesa de construcció de confiança que protegeix la vulnerabilitat més profunda."
  }'::jsonb,
  '{
    "en": ["Cancer sanctuary-teaching", "Patient trust-building sharing", "Sacred container-wisdom", "Elder''s sheltering-devotion"],
    "es": ["Enseñanza de santuario de Cáncer", "Compartir de construcción de confianza paciente", "Sabiduría de contenedor sagrado", "Devoción protectora de anciano"],
    "ca": ["Ensenyament de santuari de Cranc", "Compartir de construcció de confiança pacient", "Saviesa de contenidor sagrat", "Devoció protectora d''ancià"]
  }'::jsonb,
  '{
    "en": ["Teach safe emotional container-creation with Cancer devotion", "Share sanctuary-building wisdom patiently and protectively", "Guide others in creating spaces for deepest vulnerability", "Grateful for trust-knowledge that shelters precious hearts"],
    "es": ["Enseña creación de contenedor emocional seguro con devoción de Cáncer", "Comparte sabiduría de construcción de santuario pacientemente y protectoramente", "Guía a otros en crear espacios para vulnerabilidad más profunda", "Agradecido por conocimiento de confianza que protege corazones preciosos"],
    "ca": ["Ensenyar creació de contenidor emocional segur amb devoció de Cranc", "Comparteix saviesa de construcció de santuari pacientment i protectorament", "Guiar a altres en crear espais per a vulnerabilitat més profunda", "Agraït per coneixement de confiança que protegeix cors preciosos"]
  }'::jsonb
);

-- =====================================================
-- COMPLETION COMMENT
-- =====================================================
-- ✅ WANING GIBBOUS SEASONAL OVERLAYS COMPLETE (16/16)
-- Next file: 20251116000013_seed_seasonal_last_quarter.sql
