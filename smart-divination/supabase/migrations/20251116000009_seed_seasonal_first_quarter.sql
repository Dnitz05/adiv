-- =====================================================
-- SEED SEASONAL OVERLAYS: FIRST QUARTER (16 overlays)
-- =====================================================
-- Phase: First Quarter (half-moon waxing)
-- Energy: Decision, action, commitment, overcoming obstacles
-- Overlays: 4 elements × 4 seasons = 16 total
--
-- First Quarter represents the crisis of action - the half-
-- illuminated moon marks a turning point requiring decisive
-- commitment, pushing through resistance, and testing your
-- resolve with concrete action.

-- =====================================================
-- FIRE ELEMENT × 4 SEASONS
-- =====================================================

-- 🔥 FIRST QUARTER + FIRE + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'first_quarter' AND element = 'fire' LIMIT 1),
  'spring',
  '{
    "en": "Spring''s Warrior Fire Breaks Through All Barriers",
    "es": "El Fuego Guerrero de Primavera Atraviesa Todas las Barreras",
    "ca": "El Foc Guerrer de Primavera Travessa Totes les Barreres"
  }'::jsonb,
  '{
    "en": "The first quarter''s decisive moment meets spring''s unstoppable breakthrough. As Aries warrior energy (March-April) faces your first obstacles, commitment becomes explosive courage - you shatter resistance like sprouts breaking through stone.",
    "es": "El momento decisivo del primer cuarto se encuentra con el avance imparable de la primavera. Mientras la energía guerrera de Aries (marzo-abril) enfrenta tus primeros obstáculos, el compromiso se convierte en coraje explosivo - destrozas la resistencia como brotes rompiendo piedra.",
    "ca": "El moment decisiu del primer quart es troba amb l''avenç imparable de la primavera. Mentre l''energia guerrera d''Àries (març-abril) enfronta els teus primers obstacles, el compromís es converteix en coratge explosiu - destroces la resistència com brots rompent pedra."
  }'::jsonb,
  '{
    "en": "Fire''s decisive action is supercharged by spring''s maiden warrior force. Obstacles become fuel for breakthrough. Commitment transforms into fearless battle. Nothing can stop renewal''s explosive power.",
    "es": "La acción decisiva del fuego se supercarga con la fuerza guerrera doncella de la primavera. Los obstáculos se convierten en combustible para el avance. El compromiso se transforma en batalla intrépida. Nada puede detener el poder explosivo de la renovación.",
    "ca": "L''acció decisiva del foc se supercarrega amb la força guerrera donzella de la primavera. Els obstacles es converteixen en combustible per a l''avenç. El compromís es transforma en batalla intrèpida. Res no pot aturar el poder explosiu de la renovació."
  }'::jsonb,
  '{
    "en": ["Aries warrior courage", "Explosive breakthrough", "Fearless obstacle-shattering", "Maiden battle-force"],
    "es": ["Coraje guerrero de Aries", "Avance explosivo", "Destrucción intrépida de obstáculos", "Fuerza de batalla de doncella"],
    "ca": ["Coratge guerrer d''Àries", "Avenç explosiu", "Destrucció intrèpida d''obstacles", "Força de batalla de donzella"]
  }'::jsonb,
  '{
    "en": ["ATTACK your biggest obstacle with Aries courage TODAY", "Make the bold decision you''ve been avoiding", "Break through resistance with explosive force", "Let nothing stand between you and your goal"],
    "es": ["ATACA tu mayor obstáculo con coraje de Aries HOY", "Toma la decisión audaz que has estado evitando", "Atraviesa la resistencia con fuerza explosiva", "No dejes que nada se interponga entre tú y tu objetivo"],
    "ca": ["ATACA el teu obstacle més gran amb coratge d''Àries AVUI", "Pren la decisió audaç que has estat evitant", "Travessa la resistència amb força explosiva", "No deixis que res s''interposi entre tu i el teu objectiu"]
  }'::jsonb
);

-- 🔥 FIRST QUARTER + FIRE + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'first_quarter' AND element = 'fire' LIMIT 1),
  'summer',
  '{
    "en": "Summer''s Radiant Fire Commands Confident Action",
    "es": "El Fuego Radiante del Verano Comanda Acción Confiada",
    "ca": "El Foc Radiant de l''Estiu Comanda Acció Confiada"
  }'::jsonb,
  '{
    "en": "The first quarter''s commitment point meets summer''s peak confidence. As Leo sovereignty (July-August) faces challenges with regal power, decisive action becomes joyful performance - you overcome obstacles with playful creative mastery.",
    "es": "El punto de compromiso del primer cuarto se encuentra con la confianza máxima del verano. Mientras la soberanía de Leo (julio-agosto) enfrenta desafíos con poder regio, la acción decisiva se convierte en actuación gozosa - superas obstáculos con maestría creativa juguetona.",
    "ca": "El punt de compromís del primer quart es troba amb la confiança màxima de l''estiu. Mentre la sobirania de Leo (juliol-agost) enfronta desafiaments amb poder regi, l''acció decisiva es converteix en actuació joiosa - superes obstacles amb mestria creativa joganera."
  }'::jsonb,
  '{
    "en": "Fire''s decisive action blazes under summer''s sovereign confidence. Obstacles become stages for brilliant performance. Commitment transforms into regal command. You act with the certainty of royalty.",
    "es": "La acción decisiva del fuego arde bajo la confianza soberana del verano. Los obstáculos se convierten en escenarios para actuación brillante. El compromiso se transforma en comando regio. Actúas con la certeza de la realeza.",
    "ca": "L''acció decisiva del foc crema sota la confiança sobirana de l''estiu. Els obstacles es converteixen en escenaris per a actuació brillant. El compromís es transforma en comandament regi. Actues amb la certesa de la reialesa."
  }'::jsonb,
  '{
    "en": ["Leo sovereignty", "Confident overcoming", "Playful mastery", "Mother''s regal power"],
    "es": ["Soberanía de Leo", "Superación confiada", "Maestría juguetona", "Poder regio de madre"],
    "ca": ["Sobirania de Leo", "Superació confiada", "Mestria joganera", "Poder regi de mare"]
  }'::jsonb,
  '{
    "en": ["Make your decision with full radiant confidence", "Overcome obstacles like a sovereign - it''s your birthright", "Commit to your path with joyful creative certainty", "Let your action be a brilliant performance of power"],
    "es": ["Toma tu decisión con plena confianza radiante", "Supera obstáculos como soberano - es tu derecho de nacimiento", "Comprométete con tu camino con certeza creativa gozosa", "Deja que tu acción sea una actuación brillante de poder"],
    "ca": ["Pren la teva decisió amb plena confiança radiant", "Supera obstacles com a sobirà - és el teu dret de naixement", "Compromet-te amb el teu camí amb certesa creativa joiosa", "Deixa que la teva acció sigui una actuació brillant de poder"]
  }'::jsonb
);

-- 🔥 FIRST QUARTER + FIRE + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'first_quarter' AND element = 'fire' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Fire Makes Strategic Calculated Strikes",
    "es": "El Fuego de Otoño Hace Ataques Calculados Estratégicos",
    "ca": "El Foc de Tardor Fa Atacs Calculats Estratègics"
  }'::jsonb,
  '{
    "en": "The first quarter''s decisive action meets autumn''s harvest wisdom. As Sagittarius purpose (November-December) navigates obstacles with philosophical clarity, commitment becomes strategic strike - you act with archer''s precision toward meaningful goals.",
    "es": "La acción decisiva del primer cuarto se encuentra con la sabiduría de cosecha del otoño. Mientras el propósito de Sagitario (noviembre-diciembre) navega obstáculos con claridad filosófica, el compromiso se convierte en ataque estratégico - actúas con precisión de arquero hacia objetivos significativos.",
    "ca": "L''acció decisiva del primer quart es troba amb la saviesa de collita de la tardor. Mentre el propòsit de Sagitari (novembre-desembre) navega obstacles amb claredat filosòfica, el compromís es converteix en atac estratègic - actues amb precisió d''arquer cap a objectius significatius."
  }'::jsonb,
  '{
    "en": "Fire''s decisive action becomes purposeful under autumn''s crone wisdom. Obstacles are navigated with archer precision. Commitment transforms into philosophical certainty. Every action aims at harvest.",
    "es": "La acción decisiva del fuego se vuelve propositiva bajo la sabiduría de la anciana del otoño. Los obstáculos se navegan con precisión de arquero. El compromiso se transforma en certeza filosófica. Cada acción apunta a la cosecha.",
    "ca": "L''acció decisiva del foc es torna propositiva sota la saviesa de l''anciana de la tardor. Els obstacles es naveguen amb precisió d''arquer. El compromís es transforma en certesa filosòfica. Cada acció apunta a la collita."
  }'::jsonb,
  '{
    "en": ["Sagittarius precision", "Strategic navigation", "Purposeful commitment", "Crone''s archer wisdom"],
    "es": ["Precisión de Sagitario", "Navegación estratégica", "Compromiso propositivo", "Sabiduría de arquera anciana"],
    "ca": ["Precisió de Sagitari", "Navegació estratègica", "Compromís propositiu", "Saviesa d''arquera anciana"]
  }'::jsonb,
  '{
    "en": ["Make decisions aligned with your ultimate harvest goal", "Navigate obstacles with strategic archer precision", "Commit to actions that serve your highest purpose", "Let wisdom guide every decisive strike"],
    "es": ["Toma decisiones alineadas con tu objetivo de cosecha final", "Navega obstáculos con precisión estratégica de arquero", "Comprométete con acciones que sirven tu propósito más alto", "Deja que la sabiduría guíe cada ataque decisivo"],
    "ca": ["Pren decisions alineades amb el teu objectiu de collita final", "Navega obstacles amb precisió estratègica d''arquer", "Compromet-te amb accions que serveixen el teu propòsit més alt", "Deixa que la saviesa guiï cada atac decisiu"]
  }'::jsonb
);

-- 🔥 FIRST QUARTER + FIRE + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'first_quarter' AND element = 'fire' LIMIT 1),
  'winter',
  '{
    "en": "Winter Fire Commits With Unshakable Discipline",
    "es": "El Fuego del Invierno Se Compromete Con Disciplina Inquebrantable",
    "ca": "El Foc de l''Hivern Es Compromet Amb Disciplina Inquebrantable"
  }'::jsonb,
  '{
    "en": "The first quarter''s crisis of action meets winter''s patient endurance. As Capricorn mastery (December-January) faces obstacles with mountain-like resolve, commitment becomes structural - you decide with the permanence of stone.",
    "es": "La crisis de acción del primer cuarto se encuentra con la resistencia paciente del invierno. Mientras la maestría de Capricornio (diciembre-enero) enfrenta obstáculos con resolución como montaña, el compromiso se vuelve estructural - decides con la permanencia de la piedra.",
    "ca": "La crisi d''acció del primer quart es troba amb la resistència pacient de l''hivern. Mentre la mestria de Capricorn (desembre-gener) enfronta obstacles amb resolució com muntanya, el compromís es torna estructural - decideixes amb la permanència de la pedra."
  }'::jsonb,
  '{
    "en": "Fire''s decisive action becomes disciplined under winter''s elder structure. Obstacles are endured with geological patience. Commitment transforms into unbreakable vow. You build empire foundations with each decision.",
    "es": "La acción decisiva del fuego se vuelve disciplinada bajo la estructura anciana del invierno. Los obstáculos se soportan con paciencia geológica. El compromiso se transforma en voto inquebrantable. Construyes cimientos de imperio con cada decisión.",
    "ca": "L''acció decisiva del foc es torna disciplinada sota l''estructura anciana de l''hivern. Els obstacles es suporten amb paciència geològica. El compromís es transforma en vot inquebrantable. Construeixes fonaments d''imperi amb cada decisió."
  }'::jsonb,
  '{
    "en": ["Capricorn mastery", "Disciplined endurance", "Structural commitment", "Elder''s mountain-will"],
    "es": ["Maestría de Capricornio", "Resistencia disciplinada", "Compromiso estructural", "Voluntad de montaña anciana"],
    "ca": ["Mestria de Capricorn", "Resistència disciplinada", "Compromís estructural", "Voluntat de muntanya anciana"]
  }'::jsonb,
  '{
    "en": ["Make one irreversible commitment to your path", "Face obstacles with patient mountain-like endurance", "Decide with the permanence and structure of stone", "Let discipline be your unshakable foundation"],
    "es": ["Haz un compromiso irreversible con tu camino", "Enfrenta obstáculos con resistencia paciente como montaña", "Decide con la permanencia y estructura de la piedra", "Deja que la disciplina sea tu fundamento inquebrantable"],
    "ca": ["Fes un compromís irreversible amb el teu camí", "Enfronta obstacles amb resistència pacient com muntanya", "Decideix amb la permanència i estructura de la pedra", "Deixa que la disciplina sigui el teu fonament inquebrantable"]
  }'::jsonb
);

-- =====================================================
-- EARTH ELEMENT × 4 SEASONS
-- =====================================================

-- 🌍 FIRST QUARTER + EARTH + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'first_quarter' AND element = 'earth' LIMIT 1),
  'spring',
  '{
    "en": "Spring Earth Commits to Rapid Tangible Growth",
    "es": "La Tierra de Primavera Se Compromete con Crecimiento Tangible Rápido",
    "ca": "La Terra de Primavera Es Compromet amb Creixement Tangible Ràpid"
  }'::jsonb,
  '{
    "en": "The first quarter''s decisive commitment meets spring''s fertile abundance. As Taurus determination (April-May) pushes through soil-resistance, practical action becomes unstoppable growth - you can SEE and TOUCH your progress blooming.",
    "es": "El compromiso decisivo del primer cuarto se encuentra con la abundancia fértil de la primavera. Mientras la determinación de Tauro (abril-mayo) empuja a través de la resistencia del suelo, la acción práctica se convierte en crecimiento imparable - puedes VER y TOCAR tu progreso floreciendo.",
    "ca": "El compromís decisiu del primer quart es troba amb l''abundància fèrtil de la primavera. Mentre la determinació de Taure (abril-maig) empenta a través de la resistència del sòl, l''acció pràctica es converteix en creixement imparable - pots VEURE i TOCAR el teu progrés florint."
  }'::jsonb,
  '{
    "en": "Earth''s practical commitment is supercharged by spring''s explosive fertility. Obstacles dissolve in rich soil. Decisions become sensory reality FAST. Every action yields visible blooming results.",
    "es": "El compromiso práctico de la tierra se supercarga con la fertilidad explosiva de la primavera. Los obstáculos se disuelven en suelo rico. Las decisiones se convierten en realidad sensorial RÁPIDO. Cada acción produce resultados de floración visibles.",
    "ca": "El compromís pràctic de la terra se supercarrega amb la fertilitat explosiva de la primavera. Els obstacles es dissolen en sòl ric. Les decisions es converteixen en realitat sensorial RÀPID. Cada acció produeix resultats de floració visibles."
  }'::jsonb,
  '{
    "en": ["Taurus determination", "Sensory breakthrough", "Fertile commitment", "Maiden abundance-force"],
    "es": ["Determinación de Tauro", "Avance sensorial", "Compromiso fértil", "Fuerza de abundancia doncella"],
    "ca": ["Determinació de Taure", "Avenç sensorial", "Compromís fèrtil", "Força d''abundància donzella"]
  }'::jsonb,
  '{
    "en": ["Make one practical decision with tangible immediate results", "Commit to actions you can see/touch/measure blooming", "Push through resistance - spring soil yields abundance", "Let determination create sensory visible progress"],
    "es": ["Toma una decisión práctica con resultados inmediatos tangibles", "Comprométete con acciones que puedas ver/tocar/medir floreciendo", "Empuja a través de la resistencia - el suelo primaveral produce abundancia", "Deja que la determinación cree progreso sensorial visible"],
    "ca": ["Pren una decisió pràctica amb resultats immediats tangibles", "Compromet-te amb accions que puguis veure/tocar/mesurar florint", "Empenta a través de la resistència - el sòl primaveral produeix abundància", "Deixa que la determinació creï progrés sensorial visible"]
  }'::jsonb
);

-- 🌍 FIRST QUARTER + EARTH + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'first_quarter' AND element = 'earth' LIMIT 1),
  'summer',
  '{
    "en": "Summer Earth Perfects Every Detail With Precision",
    "es": "La Tierra de Verano Perfecciona Cada Detalle Con Precisión",
    "ca": "La Terra d''Estiu Perfecciona Cada Detall Amb Precisió"
  }'::jsonb,
  '{
    "en": "The first quarter''s crisis of action meets summer''s meticulous refinement. As Virgo precision (August-September) analyzes obstacles with devoted care, commitment becomes perfection - you overcome challenges by attending to every detail.",
    "es": "La crisis de acción del primer cuarto se encuentra con el refinamiento meticuloso del verano. Mientras la precisión de Virgo (agosto-septiembre) analiza obstáculos con cuidado devoto, el compromiso se convierte en perfección - superas desafíos atendiendo a cada detalle.",
    "ca": "La crisi d''acció del primer quart es troba amb el refinament meticulós de l''estiu. Mentre la precisió de Verge (agost-setembre) analitza obstacles amb cura devota, el compromís es converteix en perfecció - superes desafiaments atenent a cada detall."
  }'::jsonb,
  '{
    "en": "Earth''s practical decisions become precise under summer''s mother devotion. Obstacles are solved through meticulous analysis. Commitment transforms into perfect execution. Every detail receives devoted attention.",
    "es": "Las decisiones prácticas de la tierra se vuelven precisas bajo la devoción maternal del verano. Los obstáculos se resuelven a través del análisis meticuloso. El compromiso se transforma en ejecución perfecta. Cada detalle recibe atención devota.",
    "ca": "Les decisions pràctiques de la terra es tornen precises sota la devoció maternal de l''estiu. Els obstacles es resolen a través de l''anàlisi meticulosa. El compromís es transforma en execució perfecta. Cada detall rep atenció devota."
  }'::jsonb,
  '{
    "en": ["Virgo precision", "Devoted refinement", "Perfect execution", "Mother''s meticulous care"],
    "es": ["Precisión de Virgo", "Refinamiento devoto", "Ejecución perfecta", "Cuidado meticuloso de madre"],
    "ca": ["Precisió de Verge", "Refinament devot", "Execució perfecta", "Cura meticulosa de mare"]
  }'::jsonb,
  '{
    "en": ["Analyze obstacles with Virgo precision - what EXACTLY needs fixing?", "Commit to perfecting one important detail today", "Overcome challenges through meticulous devoted care", "Let precision be your path through resistance"],
    "es": ["Analiza obstáculos con precisión de Virgo - ¿qué necesita arreglarse EXACTAMENTE?", "Comprométete a perfeccionar un detalle importante hoy", "Supera desafíos a través del cuidado meticuloso devoto", "Deja que la precisión sea tu camino a través de la resistencia"],
    "ca": ["Analitza obstacles amb precisió de Verge - què necessita arreglar-se EXACTAMENT?", "Compromet-te a perfeccionar un detall important avui", "Supera desafiaments a través de la cura meticulosa devota", "Deixa que la precisió sigui el teu camí a través de la resistència"]
  }'::jsonb
);

-- 🌍 FIRST QUARTER + EARTH + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'first_quarter' AND element = 'earth' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Earth Commits to Strategic Resource Building",
    "es": "La Tierra de Otoño Se Compromete con Construcción Estratégica de Recursos",
    "ca": "La Terra de Tardor Es Compromet amb Construcció Estratègica de Recursos"
  }'::jsonb,
  '{
    "en": "The first quarter''s decisive action meets autumn''s harvest preparation. As Capricorn mastery (December-January) navigates obstacles with shrewd planning, commitment becomes resource-focused - every decision calculates toward abundant reaping.",
    "es": "La acción decisiva del primer cuarto se encuentra con la preparación de cosecha del otoño. Mientras la maestría de Capricornio (diciembre-enero) navega obstáculos con planificación astuta, el compromiso se enfoca en recursos - cada decisión calcula hacia una cosecha abundante.",
    "ca": "L''acció decisiva del primer quart es troba amb la preparació de collita de la tardor. Mentre la mestria de Capricorn (desembre-gener) navega obstacles amb planificació astuta, el compromís s''enfoca en recursos - cada decisió calcula cap a una collita abundant."
  }'::jsonb,
  '{
    "en": "Earth''s practical commitment becomes harvest-strategic under autumn''s crone wisdom. Obstacles are investments to overcome. Decisions transform into shrewd resource allocation. You build what will feed future abundance.",
    "es": "El compromiso práctico de la tierra se vuelve estratégico de cosecha bajo la sabiduría de la anciana del otoño. Los obstáculos son inversiones a superar. Las decisiones se transforman en asignación astuta de recursos. Construyes lo que alimentará la abundancia futura.",
    "ca": "El compromís pràctic de la terra es torna estratègic de collita sota la saviesa de l''anciana de la tardor. Els obstacles són inversions a superar. Les decisions es transformen en assignació astuta de recursos. Construeixes el que alimentarà l''abundància futura."
  }'::jsonb,
  '{
    "en": ["Capricorn mastery", "Shrewd resource planning", "Harvest-focused commitment", "Crone''s strategic building"],
    "es": ["Maestría de Capricornio", "Planificación astuta de recursos", "Compromiso enfocado en cosecha", "Construcción estratégica de anciana"],
    "ca": ["Mestria de Capricorn", "Planificació astuta de recursos", "Compromís enfocat en collita", "Construcció estratègica d''anciana"]
  }'::jsonb,
  '{
    "en": ["Commit resources where they yield maximum harvest return", "Navigate obstacles by calculating strategic resource allocation", "Make decisions that ensure future practical abundance", "Let crone wisdom guide every investment of effort"],
    "es": ["Compromete recursos donde producen máximo retorno de cosecha", "Navega obstáculos calculando asignación estratégica de recursos", "Toma decisiones que aseguran abundancia práctica futura", "Deja que la sabiduría de anciana guíe cada inversión de esfuerzo"],
    "ca": ["Compromet recursos on produeixen màxim retorn de collita", "Navega obstacles calculant assignació estratègica de recursos", "Pren decisions que asseguren abundància pràctica futura", "Deixa que la saviesa d''anciana guiï cada inversió d''esforç"]
  }'::jsonb
);

-- 🌍 FIRST QUARTER + EARTH + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'first_quarter' AND element = 'earth' LIMIT 1),
  'winter',
  '{
    "en": "Winter''s Deep Foundations Endure All Resistance",
    "es": "Los Cimientos Profundos del Invierno Soportan Toda Resistencia",
    "ca": "Els Fonaments Profunds de l''Hivern Suporten Tota Resistència"
  }'::jsonb,
  '{
    "en": "The first quarter''s testing moment meets winter''s underground patience. As Taurus endurance (April-May) faces obstacles beneath the surface, commitment becomes geological - you build foundations so deep that nothing can shake them.",
    "es": "El momento de prueba del primer cuarto se encuentra con la paciencia subterránea del invierno. Mientras la resistencia de Tauro (abril-mayo) enfrenta obstáculos bajo la superficie, el compromiso se vuelve geológico - construyes cimientos tan profundos que nada puede sacudirlos.",
    "ca": "El moment de prova del primer quart es troba amb la paciència subterrània de l''hivern. Mentre la resistència de Taure (abril-maig) enfronta obstacles sota la superfície, el compromís es torna geològic - construeixes fonaments tan profunds que res no els pot sacseja."
  }'::jsonb,
  '{
    "en": "Earth''s practical decisions descend into winter''s depths. Obstacles become bedrock to anchor upon. Commitment transforms into tectonic permanence. Every action builds invisible eternal strength.",
    "es": "Las decisiones prácticas de la tierra descienden a las profundidades del invierno. Los obstáculos se convierten en lecho rocoso para anclarse. El compromiso se transforma en permanencia tectónica. Cada acción construye fuerza eterna invisible.",
    "ca": "Les decisions pràctiques de la terra descendeixen a les profunditats de l''hivern. Els obstacles es converteixen en llit rocós per ancorar-se. El compromís es transforma en permanència tectònica. Cada acció construeix força eterna invisible."
  }'::jsonb,
  '{
    "en": ["Taurus endurance", "Geological commitment", "Invisible foundations", "Elder''s bedrock patience"],
    "es": ["Resistencia de Tauro", "Compromiso geológico", "Cimientos invisibles", "Paciencia de lecho rocoso anciana"],
    "ca": ["Resistència de Taure", "Compromís geològic", "Fonaments invisibles", "Paciència de llit rocós ancià"]
  }'::jsonb,
  '{
    "en": ["Commit to building foundations even when progress is invisible", "Face obstacles by going DEEPER - anchor in bedrock", "Make decisions with geological permanence and patience", "Let endurance be your path through winter resistance"],
    "es": ["Comprométete a construir cimientos incluso cuando el progreso es invisible", "Enfrenta obstáculos yendo MÁS PROFUNDO - ancla en lecho rocoso", "Toma decisiones con permanencia y paciencia geológica", "Deja que la resistencia sea tu camino a través de la resistencia invernal"],
    "ca": ["Compromet-te a construir fonaments fins i tot quan el progrés és invisible", "Enfronta obstacles anant MÉS PROFUND - ancora al llit rocós", "Pren decisions amb permanència i paciència geològica", "Deixa que la resistència sigui el teu camí a través de la resistència hivernal"]
  }'::jsonb
);

-- =====================================================
-- AIR ELEMENT × 4 SEASONS
-- =====================================================

-- 💨 FIRST QUARTER + AIR + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'first_quarter' AND element = 'air' LIMIT 1),
  'spring',
  '{
    "en": "Spring Winds Carry Ideas Through All Resistance",
    "es": "Los Vientos de Primavera Llevan Ideas A Través de Toda Resistencia",
    "ca": "Els Vents de Primavera Porten Idees A Través de Tota Resistència"
  }'::jsonb,
  '{
    "en": "The first quarter''s decision crisis meets spring''s fresh communication surge. As Gemini curiosity (May-June) navigates mental obstacles with playful agility, commitment becomes conversational breakthrough - your ideas find their way around every block.",
    "es": "La crisis de decisión del primer cuarto se encuentra con el auge de comunicación fresca de la primavera. Mientras la curiosidad de Géminis (mayo-junio) navega obstáculos mentales con agilidad juguetona, el compromiso se convierte en avance conversacional - tus ideas encuentran su camino alrededor de cada bloqueo.",
    "ca": "La crisi de decisió del primer quart es troba amb l''augment de comunicació fresca de la primavera. Mentre la curiositat de Bessons (maig-juny) navega obstacles mentals amb agilitat joganera, el compromís es converteix en avenç conversacional - les teves idees troben el seu camí al voltant de cada bloqueig."
  }'::jsonb,
  '{
    "en": "Air''s intellectual decisions are energized by spring''s maiden curiosity. Obstacles become puzzles to playfully solve. Commitment transforms into exploratory conversation. Ideas pollinate around every barrier.",
    "es": "Las decisiones intelectuales del aire se energizan con la curiosidad doncella de la primavera. Los obstáculos se convierten en rompecabezas para resolver juguetonamente. El compromiso se transforma en conversación exploratoria. Las ideas polinizan alrededor de cada barrera.",
    "ca": "Les decisions intel·lectuals de l''aire s''energitzen amb la curiositat donzella de la primavera. Els obstacles es converteixen en trencaclosques per resoldre joganerament. El compromís es transforma en conversa exploratòria. Les idees pol·linitzen al voltant de cada barrera."
  }'::jsonb,
  '{
    "en": ["Gemini agility", "Conversational breakthrough", "Playful problem-solving", "Maiden mind-flexibility"],
    "es": ["Agilidad de Géminis", "Avance conversacional", "Resolución juguetona de problemas", "Flexibilidad mental de doncella"],
    "ca": ["Agilitat de Bessons", "Avenç conversacional", "Resolució joganera de problemes", "Flexibilitat mental de donzella"]
  }'::jsonb,
  '{
    "en": ["Talk through obstacles - find THREE new angles on the problem", "Commit to curious exploration rather than rigid forcing", "Let ideas find flexible pathways around resistance", "Make decisions through playful conversational brainstorming"],
    "es": ["Habla a través de obstáculos - encuentra TRES nuevos ángulos sobre el problema", "Comprométete con la exploración curiosa en lugar de forzar rígidamente", "Deja que las ideas encuentren caminos flexibles alrededor de la resistencia", "Toma decisiones a través de lluvia de ideas conversacional juguetona"],
    "ca": ["Parla a través d''obstacles - troba TRES nous angles sobre el problema", "Compromet-te amb l''exploració curiosa en lloc de forçar rígidament", "Deixa que les idees trobin camins flexibles al voltant de la resistència", "Pren decisions a través de pluja d''idees conversacional joganera"]
  }'::jsonb
);

-- 💨 FIRST QUARTER + AIR + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'first_quarter' AND element = 'air' LIMIT 1),
  'summer',
  '{
    "en": "Summer''s Diplomatic Grace Balances Through Conflict",
    "es": "La Gracia Diplomática del Verano Equilibra A Través del Conflicto",
    "ca": "La Gràcia Diplomàtica de l''Estiu Equilibra A Través del Conflicte"
  }'::jsonb,
  '{
    "en": "The first quarter''s testing moment meets summer''s harmonious collaboration. As Libra balance (September-October) faces relationship obstacles with graceful diplomacy, commitment becomes partnership - you overcome through beautiful reciprocal exchange.",
    "es": "El momento de prueba del primer cuarto se encuentra con la colaboración armoniosa del verano. Mientras el equilibrio de Libra (septiembre-octubre) enfrenta obstáculos de relación con diplomacia graciosa, el compromiso se convierte en asociación - superas a través del intercambio recíproco hermoso.",
    "ca": "El moment de prova del primer quart es troba amb la col·laboració harmoniosa de l''estiu. Mentre l''equilibri de Balança (setembre-octubre) enfronta obstacles de relació amb diplomàcia graciosa, el compromís es converteix en associació - superes a través de l''intercanvi recíproc bell."
  }'::jsonb,
  '{
    "en": "Air''s intellectual decisions become collaborative under summer''s mother grace. Obstacles are balanced through partnership. Commitment transforms into harmonious exchange. Beautiful diplomacy overcomes all conflict.",
    "es": "Las decisiones intelectuales del aire se vuelven colaborativas bajo la gracia maternal del verano. Los obstáculos se equilibran a través de la asociación. El compromiso se transforma en intercambio armonioso. La diplomacia hermosa supera todo conflicto.",
    "ca": "Les decisions intel·lectuals de l''aire es tornen col·laboratives sota la gràcia maternal de l''estiu. Els obstacles s''equilibren a través de l''associació. El compromís es transforma en intercanvi harmoniós. La diplomàcia bella supera tot conflicte."
  }'::jsonb,
  '{
    "en": ["Libra diplomacy", "Partnership balance", "Graceful conflict resolution", "Mother''s harmonious collaboration"],
    "es": ["Diplomacia de Libra", "Equilibrio de asociación", "Resolución graciosa de conflictos", "Colaboración armoniosa de madre"],
    "ca": ["Diplomàcia de Balança", "Equilibri d''associació", "Resolució graciosa de conflictes", "Col·laboració harmoniosa de mare"]
  }'::jsonb,
  '{
    "en": ["Overcome obstacles through beautiful partnership collaboration", "Commit to balanced reciprocal exchange, not forcing", "Make decisions that honor both/all perspectives gracefully", "Let Libra diplomacy transform conflict into harmony"],
    "es": ["Supera obstáculos a través de la colaboración hermosa de asociación", "Comprométete con el intercambio recíproco equilibrado, no forzando", "Toma decisiones que honren ambas/todas las perspectivas graciosamente", "Deja que la diplomacia de Libra transforme el conflicto en armonía"],
    "ca": ["Supera obstacles a través de la col·laboració bella d''associació", "Compromet-te amb l''intercanvi recíproc equilibrat, no forçant", "Pren decisions que honorin ambdues/totes les perspectives graciosament", "Deixa que la diplomàcia de Balança transformi el conflicte en harmonia"]
  }'::jsonb
);

-- 💨 FIRST QUARTER + AIR + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'first_quarter' AND element = 'air' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Air Revolutionizes Systems With Innovation",
    "es": "El Aire de Otoño Revoluciona Sistemas Con Innovación",
    "ca": "L''Aire de Tardor Revoluciona Sistemes Amb Innovació"
  }'::jsonb,
  '{
    "en": "The first quarter''s decision point meets autumn''s visionary breakthrough. As Aquarius innovation (January-February) faces systemic obstacles with revolutionary thinking, commitment becomes collective evolution - you overcome by creating entirely new structures.",
    "es": "El punto de decisión del primer cuarto se encuentra con el avance visionario del otoño. Mientras la innovación de Acuario (enero-febrero) enfrenta obstáculos sistémicos con pensamiento revolucionario, el compromiso se convierte en evolución colectiva - superas creando estructuras completamente nuevas.",
    "ca": "El punt de decisió del primer quart es troba amb l''avenç visionari de la tardor. Mentre la innovació d''Aquari (gener-febrer) enfronta obstacles sistèmics amb pensament revolucionari, el compromís es converteix en evolució col·lectiva - superes creant estructures completament noves."
  }'::jsonb,
  '{
    "en": "Air''s intellectual decisions become revolutionary under autumn''s crone innovation. Obstacles are systems to upgrade. Commitment transforms into visionary evolution. Future-focused networks overcome present limitations.",
    "es": "Las decisiones intelectuales del aire se vuelven revolucionarias bajo la innovación anciana del otoño. Los obstáculos son sistemas a actualizar. El compromiso se transforma en evolución visionaria. Las redes enfocadas en el futuro superan las limitaciones presentes.",
    "ca": "Les decisions intel·lectuals de l''aire es tornen revolucionàries sota la innovació anciana de la tardor. Els obstacles són sistemes a actualitzar. El compromís es transforma en evolució visionària. Les xarxes enfocades en el futur superen les limitacions presents."
  }'::jsonb,
  '{
    "en": ["Aquarius innovation", "Revolutionary systems-thinking", "Visionary commitment", "Crone''s evolutionary breakthrough"],
    "es": ["Innovación de Acuario", "Pensamiento revolucionario de sistemas", "Compromiso visionario", "Avance evolutivo de anciana"],
    "ca": ["Innovació d''Aquari", "Pensament revolucionari de sistemes", "Compromís visionari", "Avenç evolutiu d''anciana"]
  }'::jsonb,
  '{
    "en": ["Don''t overcome obstacles - CREATE NEW SYSTEMS entirely", "Commit to revolutionary innovation, not incremental fixes", "Make decisions serving collective evolutionary leaps", "Let Aquarius vision transform present limitations into future freedom"],
    "es": ["No superes obstáculos - CREA NUEVOS SISTEMAS completamente", "Comprométete con la innovación revolucionaria, no arreglos incrementales", "Toma decisiones sirviendo saltos evolutivos colectivos", "Deja que la visión de Acuario transforme las limitaciones presentes en libertad futura"],
    "ca": ["No superis obstacles - CREA NOUS SISTEMES completament", "Compromet-te amb la innovació revolucionària, no arranjaments incrementals", "Pren decisions servint salts evolutius col·lectius", "Deixa que la visió d''Aquari transformi les limitacions presents en llibertat futura"]
  }'::jsonb
);

-- 💨 FIRST QUARTER + AIR + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'first_quarter' AND element = 'air' LIMIT 1),
  'winter',
  '{
    "en": "Winter Silence Crystallizes Diamond-Clear Decisions",
    "es": "El Silencio del Invierno Cristaliza Decisiones Cristalinas",
    "ca": "El Silenci de l''Hivern Cristal·litza Decisions Cristal·lines"
  }'::jsonb,
  '{
    "en": "The first quarter''s crisis of action meets winter''s contemplative clarity. As Gemini curiosity (May-June) navigates mental obstacles in stillness, commitment becomes crystalline knowing - your decisions sharpen to diamond-hard certainty in the silence.",
    "es": "La crisis de acción del primer cuarto se encuentra con la claridad contemplativa del invierno. Mientras la curiosidad de Géminis (mayo-junio) navega obstáculos mentales en quietud, el compromiso se convierte en conocimiento cristalino - tus decisiones se afinan a certeza dura como diamante en el silencio.",
    "ca": "La crisi d''acció del primer quart es troba amb la claredat contemplativa de l''hivern. Mentre la curiositat de Bessons (maig-juny) navega obstacles mentals en quietud, el compromís es converteix en coneixement cristal·lí - les teves decisions s''afinen a certesa dura com diamant en el silenci."
  }'::jsonb,
  '{
    "en": "Air''s intellectual decisions become contemplative under winter''s elder silence. Obstacles dissolve in pure thought. Commitment transforms into crystalline clarity. Perfect understanding cuts through all confusion.",
    "es": "Las decisiones intelectuales del aire se vuelven contemplativas bajo el silencio anciano del invierno. Los obstáculos se disuelven en pensamiento puro. El compromiso se transforma en claridad cristalina. La comprensión perfecta corta toda confusión.",
    "ca": "Les decisions intel·lectuals de l''aire es tornen contemplatives sota el silenci ancià de l''hivern. Els obstacles es dissolen en pensament pur. El compromís es transforma en claredat cristal·lina. La comprensió perfecta talla tota confusió."
  }'::jsonb,
  '{
    "en": ["Gemini contemplation", "Crystalline clarity", "Silent knowing", "Elder''s diamond-mind"],
    "es": ["Contemplación de Géminis", "Claridad cristalina", "Conocimiento silencioso", "Mente de diamante anciana"],
    "ca": ["Contemplació de Bessons", "Claredat cristal·lina", "Coneixement silenciós", "Ment de diamant anciana"]
  }'::jsonb,
  '{
    "en": ["Sit in complete silence until your decision becomes crystal-clear", "Overcome mental obstacles through contemplative clarity", "Commit when inner knowing reaches diamond-hard certainty", "Let winter silence sharpen thought to perfect precision"],
    "es": ["Siéntate en completo silencio hasta que tu decisión se vuelva cristalina", "Supera obstáculos mentales a través de la claridad contemplativa", "Comprométete cuando el conocimiento interno alcance certeza dura como diamante", "Deja que el silencio invernal afile el pensamiento a precisión perfecta"],
    "ca": ["Seu en complet silenci fins que la teva decisió es torni cristal·lina", "Supera obstacles mentals a través de la claredat contemplativa", "Compromet-te quan el coneixement intern arribi a certesa dura com diamant", "Deixa que el silenci hivernal afili el pensament a precisió perfecta"]
  }'::jsonb
);

-- =====================================================
-- WATER ELEMENT × 4 SEASONS
-- =====================================================

-- 💧 FIRST QUARTER + WATER + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'first_quarter' AND element = 'water' LIMIT 1),
  'spring',
  '{
    "en": "Spring Waters Break Through Emotional Barriers",
    "es": "Las Aguas de Primavera Atraviesan Barreras Emocionales",
    "ca": "Les Aigües de Primavera Travessen Barreres Emocionals"
  }'::jsonb,
  '{
    "en": "The first quarter''s testing moment meets spring''s emotional courage. As Cancer bravery (June-July) faces vulnerable obstacles with heart-strength, commitment becomes emotional breakthrough - you let feelings flow through every resistance.",
    "es": "El momento de prueba del primer cuarto se encuentra con el coraje emocional de la primavera. Mientras la valentía de Cáncer (junio-julio) enfrenta obstáculos vulnerables con fuerza de corazón, el compromiso se convierte en avance emocional - dejas que los sentimientos fluyan a través de cada resistencia.",
    "ca": "El moment de prova del primer quart es troba amb el coratge emocional de la primavera. Mentre la valentia de Cranc (juny-juliol) enfronta obstacles vulnerables amb força de cor, el compromís es converteix en avenç emocional - deixes que els sentiments flueixin a través de cada resistència."
  }'::jsonb,
  '{
    "en": "Water''s emotional decisions are energized by spring''s maiden courage. Obstacles are emotional dams to burst through. Commitment transforms into heart-bravery. Feelings breakthrough with unstoppable spring-flood force.",
    "es": "Las decisiones emocionales del agua se energizan con el coraje doncella de la primavera. Los obstáculos son represas emocionales a atravesar. El compromiso se transforma en valentía de corazón. Los sentimientos avanzan con fuerza de inundación primaveral imparable.",
    "ca": "Les decisions emocionals de l''aigua s''energitzen amb el coratge donzella de la primavera. Els obstacles són represes emocionals a travessar. El compromís es transforma en valentia de cor. Els sentiments avancen amb força d''inundació primaveral imparable."
  }'::jsonb,
  '{
    "en": ["Cancer courage", "Emotional breakthrough", "Vulnerable heart-strength", "Maiden feeling-force"],
    "es": ["Coraje de Cáncer", "Avance emocional", "Fuerza de corazón vulnerable", "Fuerza de sentimiento doncella"],
    "ca": ["Coratge de Cranc", "Avenç emocional", "Força de cor vulnerable", "Força de sentiment donzella"]
  }'::jsonb,
  '{
    "en": ["Share the vulnerable feeling you''ve been holding back", "Commit to emotional honesty even when it''s scary", "Let feelings FLOW through obstacles - don''t dam them", "Make heart-brave decisions with spring''s emotional courage"],
    "es": ["Comparte el sentimiento vulnerable que has estado reteniendo", "Comprométete con la honestidad emocional incluso cuando da miedo", "Deja que los sentimientos FLUYAN a través de obstáculos - no los represas", "Toma decisiones valientes de corazón con el coraje emocional de la primavera"],
    "ca": ["Comparteix el sentiment vulnerable que has estat retenint", "Compromet-te amb l''honestedat emocional fins i tot quan fa por", "Deixa que els sentiments FLUEIXIN a través d''obstacles - no els represis", "Pren decisions valentes de cor amb el coratge emocional de la primavera"]
  }'::jsonb
);

-- 💧 FIRST QUARTER + WATER + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'first_quarter' AND element = 'water' LIMIT 1),
  'summer',
  '{
    "en": "Summer''s Intense Waters Transform All Resistance",
    "es": "Las Aguas Intensas del Verano Transforman Toda Resistencia",
    "ca": "Les Aigües Intenses de l''Estiu Transformen Tota Resistència"
  }'::jsonb,
  '{
    "en": "The first quarter''s crisis of action meets summer''s emotional alchemy. As Scorpio transformation (October-November) faces intimate obstacles with soul-deep power, commitment becomes metamorphosis - you overcome by fundamentally changing at the heart level.",
    "es": "La crisis de acción del primer cuarto se encuentra con la alquimia emocional del verano. Mientras la transformación de Escorpio (octubre-noviembre) enfrenta obstáculos íntimos con poder profundo del alma, el compromiso se convierte en metamorfosis - superas cambiando fundamentalmente a nivel del corazón.",
    "ca": "La crisi d''acció del primer quart es troba amb l''alquímia emocional de l''estiu. Mentre la transformació d''Escorpí (octubre-novembre) enfronta obstacles íntims amb poder profund de l''ànima, el compromís es converteix en metamorfosi - superes canviant fonamentalment a nivell del cor."
  }'::jsonb,
  '{
    "en": "Water''s emotional decisions become transformative under summer''s mother intensity. Obstacles are alchemical crucibles. Commitment transforms into soul-rebirth. You emerge fundamentally changed, reborn through sacred fire.",
    "es": "Las decisiones emocionales del agua se vuelven transformativas bajo la intensidad maternal del verano. Los obstáculos son crisoles alquímicos. El compromiso se transforma en renacimiento del alma. Emerges fundamentalmente cambiado, renacido a través del fuego sagrado.",
    "ca": "Les decisions emocionals de l''aigua es tornen transformatives sota la intensitat maternal de l''estiu. Els obstacles són gresols alquímics. El compromís es transforma en renaixement de l''ànima. Emergeixis fonamentalment canviat, renascut a través del foc sagrat."
  }'::jsonb,
  '{
    "en": ["Scorpio transformation", "Alchemical rebirth", "Soul-deep commitment", "Mother''s intense metamorphosis"],
    "es": ["Transformación de Escorpio", "Renacimiento alquímico", "Compromiso profundo del alma", "Metamorfosis intensa de madre"],
    "ca": ["Transformació d''Escorpí", "Renaixement alquímic", "Compromís profund de l''ànima", "Metamorfosi intensa de mare"]
  }'::jsonb,
  '{
    "en": ["Don''t just overcome obstacles - LET THEM TRANSFORM YOU", "Commit to deep emotional alchemy, not surface solutions", "Face intimate resistance with Scorpio soul-power", "Make decisions that fundamentally change who you are"],
    "es": ["No solo superes obstáculos - DEJA QUE TE TRANSFORMEN", "Comprométete con la alquimia emocional profunda, no soluciones superficiales", "Enfrenta resistencia íntima con poder de alma de Escorpio", "Toma decisiones que cambien fundamentalmente quién eres"],
    "ca": ["No només superis obstacles - DEIXA QUE ET TRANSFORMIN", "Compromet-te amb l''alquímia emocional profunda, no solucions superficials", "Enfronta resistència íntima amb poder d''ànima d''Escorpí", "Pren decisions que canviïn fonamentalment qui ets"]
  }'::jsonb
);

-- 💧 FIRST QUARTER + WATER + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'first_quarter' AND element = 'water' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn''s Boundaryless Waters Dissolve All Barriers",
    "es": "Las Aguas Sin Límites del Otoño Disuelven Todas las Barreras",
    "ca": "Les Aigües Sense Límits de la Tardor Dissolen Totes les Barreres"
  }'::jsonb,
  '{
    "en": "The first quarter''s decision moment meets autumn''s mystical compassion. As Pisces unity (February-March) faces separation-obstacles with boundaryless empathy, commitment becomes universal love - you overcome by dissolving the illusion of barriers entirely.",
    "es": "El momento de decisión del primer cuarto se encuentra con la compasión mística del otoño. Mientras la unidad de Piscis (febrero-marzo) enfrenta obstáculos de separación con empatía sin límites, el compromiso se convierte en amor universal - superas disolviendo completamente la ilusión de barreras.",
    "ca": "El moment de decisió del primer quart es troba amb la compassió mística de la tardor. Mentre la unitat de Peixos (febrer-març) enfronta obstacles de separació amb empatia sense límits, el compromís es converteix en amor universal - superes dissolent completament la il·lusió de barreres."
  }'::jsonb,
  '{
    "en": "Water''s emotional decisions become boundaryless under autumn''s crone compassion. Obstacles are illusions of separation to dissolve. Commitment transforms into mystical unity. All hearts merge in the cosmic ocean.",
    "es": "Las decisiones emocionales del agua se vuelven sin límites bajo la compasión anciana del otoño. Los obstáculos son ilusiones de separación a disolver. El compromiso se transforma en unidad mística. Todos los corazones se fusionan en el océano cósmico.",
    "ca": "Les decisions emocionals de l''aigua es tornen sense límits sota la compassió anciana de la tardor. Els obstacles són il·lusions de separació a dissoldre. El compromís es transforma en unitat mística. Tots els cors es fusionen a l''oceà còsmic."
  }'::jsonb,
  '{
    "en": ["Pisces unity", "Boundary dissolution", "Universal compassion", "Crone''s mystical merging"],
    "es": ["Unidad de Piscis", "Disolución de límites", "Compasión universal", "Fusión mística de anciana"],
    "ca": ["Unitat de Peixos", "Dissolució de límits", "Compassió universal", "Fusió mística d''anciana"]
  }'::jsonb,
  '{
    "en": ["Overcome obstacles by dissolving the boundary between self/other", "Commit to universal compassion - all suffering is one", "Make decisions recognizing the interconnection of all beings", "Let Pisces empathy transform separation into sacred unity"],
    "es": ["Supera obstáculos disolviendo el límite entre yo/otro", "Comprométete con la compasión universal - todo sufrimiento es uno", "Toma decisiones reconociendo la interconexión de todos los seres", "Deja que la empatía de Piscis transforme la separación en unidad sagrada"],
    "ca": ["Supera obstacles dissolent el límit entre jo/altre", "Compromet-te amb la compassió universal - tot sofriment és un", "Pren decisions reconeixent la interconnexió de tots els éssers", "Deixa que l''empatia de Peixos transformi la separació en unitat sagrada"]
  }'::jsonb
);

-- 💧 FIRST QUARTER + WATER + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'first_quarter' AND element = 'water' LIMIT 1),
  'winter',
  '{
    "en": "Winter''s Sacred Depths Protect Vulnerable Commitment",
    "es": "Las Profundidades Sagradas del Invierno Protegen el Compromiso Vulnerable",
    "ca": "Les Profunditats Sagrades de l''Hivern Protegeixen el Compromís Vulnerable"
  }'::jsonb,
  '{
    "en": "The first quarter''s testing crisis meets winter''s emotional sanctuary. As Cancer protection (June-July) faces trust-obstacles in sacred darkness, commitment becomes sheltered intimacy - you build safe containers where vulnerable bonds can deepen.",
    "es": "La crisis de prueba del primer cuarto se encuentra con el santuario emocional del invierno. Mientras la protección de Cáncer (junio-julio) enfrenta obstáculos de confianza en oscuridad sagrada, el compromiso se convierte en intimidad protegida - construyes contenedores seguros donde los vínculos vulnerables pueden profundizarse.",
    "ca": "La crisi de prova del primer quart es troba amb el santuari emocional de l''hivern. Mentre la protecció de Cranc (juny-juliol) enfronta obstacles de confiança en foscor sagrada, el compromís es converteix en intimitat protegida - construeixes contenidors segurs on els vincles vulnerables poden aprofundir-se."
  }'::jsonb,
  '{
    "en": "Water''s emotional decisions become sheltered under winter''s elder protection. Obstacles are trust-tests to pass slowly. Commitment transforms into sacred sanctuary-building. Deep intimacy grows in protected darkness.",
    "es": "Las decisiones emocionales del agua se vuelven protegidas bajo la protección anciana del invierno. Los obstáculos son pruebas de confianza a pasar lentamente. El compromiso se transforma en construcción de santuario sagrado. La intimidad profunda crece en oscuridad protegida.",
    "ca": "Les decisions emocionals de l''aigua es tornen protegides sota la protecció anciana de l''hivern. Els obstacles són proves de confiança a passar lentament. El compromís es transforma en construcció de santuari sagrat. La intimitat profunda creix en foscor protegida."
  }'::jsonb,
  '{
    "en": ["Cancer sanctuary", "Protected trust-building", "Sacred container commitment", "Elder''s sheltering devotion"],
    "es": ["Santuario de Cáncer", "Construcción de confianza protegida", "Compromiso de contenedor sagrado", "Devoción protectora anciana"],
    "ca": ["Santuari de Cranc", "Construcció de confiança protegida", "Compromís de contenidor sagrat", "Devoció protectora anciana"]
  }'::jsonb,
  '{
    "en": ["Overcome trust obstacles by creating SAFER sacred space first", "Commit slowly, building protected containers for vulnerability", "Make decisions honoring the need for emotional sanctuary", "Let Cancer sheltering transform resistance into cherished safety"],
    "es": ["Supera obstáculos de confianza creando espacio sagrado MÁS SEGURO primero", "Comprométete lentamente, construyendo contenedores protegidos para la vulnerabilidad", "Toma decisiones honrando la necesidad de santuario emocional", "Deja que la protección de Cáncer transforme la resistencia en seguridad apreciada"],
    "ca": ["Supera obstacles de confiança creant espai sagrat MÉS SEGUR primer", "Compromet-te lentament, construint contenidors protegits per a la vulnerabilitat", "Pren decisions honorant la necessitat de santuari emocional", "Deixa que la protecció de Cranc transformi la resistència en seguretat apreciada"]
  }'::jsonb
);

-- =====================================================
-- COMPLETION COMMENT
-- =====================================================
-- ✅ FIRST QUARTER SEASONAL OVERLAYS COMPLETE (16/16)
-- Next file: 20251116000010_seed_seasonal_waxing_gibbous.sql
