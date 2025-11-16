-- =====================================================
-- SEED SEASONAL OVERLAYS: LAST QUARTER (16 overlays)
-- =====================================================
-- Phase: Last Quarter (half-moon waning)
-- Energy: Release, letting go, forgiveness, clearing, surrender
-- Overlays: 4 elements × 4 seasons = 16 total
--
-- Last Quarter represents the crisis of consciousness -
-- releasing what no longer serves, forgiving and letting
-- go, clearing space for new cycle, surrendering with
-- trust, cleansing and completion.

-- =====================================================
-- FIRE ELEMENT × 4 SEASONS
-- =====================================================

-- 🔥 LAST QUARTER + FIRE + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'last_quarter' AND element = 'fire' LIMIT 1),
  'spring',
  '{
    "en": "Spring Fire Burns Away Old Skin Courageously",
    "es": "El Fuego de Primavera Quema Piel Vieja Valientemente",
    "ca": "El Foc de Primavera Crema Pell Vella Valentament"
  }'::jsonb,
  '{
    "en": "The last quarter''s release meets spring''s renewal-shedding. As Aries courage (March-April) burns away what''s outgrown, letting go becomes warrior-liberation - you shed old identity BOLDLY to make explosive space for rebirth.",
    "es": "El lanzamiento del último cuarto se encuentra con el despojo renovador de la primavera. Mientras el coraje de Aries (marzo-abril) quema lo que está superado, dejar ir se convierte en liberación guerrera - despojas identidad antigua AUDAZMENTE para hacer espacio explosivo para renacimiento.",
    "ca": "L''alliberament de l''últim quart es troba amb el despullament renovador de la primavera. Mentre el coratge d''Àries (març-abril) crema el que està superat, deixar anar es converteix en alliberament guerrer - despulles identitat antiga AUDAÇMENT per fer espai explosiu per a renaixement."
  }'::jsonb,
  '{
    "en": "Fire''s release is explosive with spring''s maiden shedding-courage. Burn away fear, shame, hesitation FAST. Surrender old battles - the warrior knows when to walk away victoriously.",
    "es": "El lanzamiento del fuego es explosivo con el coraje de despojo doncella de la primavera. Quema miedo, vergüenza, vacilación RÁPIDO. Rinde batallas antiguas - el guerrero sabe cuándo retirarse victoriosamente.",
    "ca": "L''alliberament del foc és explosiu amb el coratge de despullament donzella de la primavera. Crema por, vergonya, vacil·lació RÀPID. Rendeix batalles antigues - el guerrer sap quan retirar-se victoriosament."
  }'::jsonb,
  '{
    "en": ["Aries bold-release", "Courageous identity-shedding", "Warrior liberation", "Maiden renewal-burning"],
    "es": ["Lanzamiento audaz de Aries", "Despojo valiente de identidad", "Liberación guerrera", "Quema renovadora de doncella"],
    "ca": ["Alliberament audaç d''Àries", "Despullament valent d''identitat", "Alliberament guerrer", "Crema renovadora de donzella"]
  }'::jsonb,
  '{
    "en": ["Release ONE old identity/pattern with Aries fearless courage", "Burn away what no longer serves your evolution", "Surrender outdated battles - walk away victoriously", "Forgive yourself for past versions that needed to exist"],
    "es": ["Libera UNA identidad/patrón antiguo con coraje intrépido de Aries", "Quema lo que ya no sirve tu evolución", "Rinde batallas obsoletas - retírate victoriosamente", "Perdónate por versiones pasadas que necesitaban existir"],
    "ca": ["Allibera UNA identitat/patró antic amb coratge intrèpid d''Àries", "Crema el que ja no serveix la teva evolució", "Rendeix batalles obsoletes - retira''t victoriosament", "Perdona''t per versions passades que necessitaven existir"]
  }'::jsonb
);

-- 🔥 LAST QUARTER + FIRE + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'last_quarter' AND element = 'fire' LIMIT 1),
  'summer',
  '{
    "en": "Summer Fire Releases With Confident Radiant Trust",
    "es": "El Fuego del Verano Libera Con Confianza Radiante",
    "ca": "El Foc de l''Estiu Allibera Amb Confiança Radiant"
  }'::jsonb,
  '{
    "en": "The last quarter''s letting go meets summer''s confident surrender. As Leo sovereignty (July-August) releases what dims radiance, clearing becomes joyful-liberation - you let go with PLAYFUL trust that better awaits.",
    "es": "El dejar ir del último cuarto se encuentra con la rendición confiada del verano. Mientras la soberanía de Leo (julio-agosto) libera lo que opaca la radiancia, limpiar se convierte en liberación gozosa - dejas ir con confianza JUGUETONA de que mejor espera.",
    "ca": "El deixar anar de l''últim quart es troba amb la rendició confiada de l''estiu. Mentre la sobirania de Leo (juliol-agost) allibera el que opaca la radiància, netejar es converteix en alliberament joiós - deixes anar amb confiança JOGANERA que millor espera."
  }'::jsonb,
  '{
    "en": "Fire''s release shines with summer''s mother confidence-trust. Let go of what blocks your radiance JOYFULLY. Surrender dim thinking - the sovereign knows their light will always shine.",
    "es": "El lanzamiento del fuego brilla con la confianza maternal del verano. Deja ir lo que bloquea tu radiancia GOZOSAMENTE. Rinde pensamiento opaco - el soberano sabe que su luz siempre brillará.",
    "ca": "L''alliberament del foc brilla amb la confiança maternal de l''estiu. Deixa anar el que bloqueja la teva radiància JOIOSAMENT. Rendeix pensament opac - el sobirà sap que la seva llum sempre brillarà."
  }'::jsonb,
  '{
    "en": ["Leo radiant-release", "Joyful confident-surrender", "Sovereign clearing", "Mother''s trusting-liberation"],
    "es": ["Lanzamiento radiante de Leo", "Rendición confiada gozosa", "Limpieza soberana", "Liberación confiada de madre"],
    "ca": ["Alliberament radiant de Leo", "Rendició confiada joiosa", "Neteja sobirana", "Alliberament confiat de mare"]
  }'::jsonb,
  '{
    "en": ["Release what dims your radiance with Leo playful confidence", "Let go joyfully, trusting your light always returns", "Surrender self-doubt - you are sovereign brilliance", "Forgive dimming patterns - your radiance was never lost"],
    "es": ["Libera lo que opaca tu radiancia con confianza juguetona de Leo", "Deja ir gozosamente, confiando en que tu luz siempre regresa", "Rinde duda - eres brillantez soberana", "Perdona patrones que opacaban - tu radiancia nunca se perdió"],
    "ca": ["Allibera el que opaca la teva radiància amb confiança joganera de Leo", "Deixa anar joiosament, confiant que la teva llum sempre torna", "Rendeix dubte - ets brillantor sobirana", "Perdona patrons que opacaven - la teva radiància mai es va perdre"]
  }'::jsonb
);

-- (Continues with all 16 Last Quarter overlays following the same pattern...)
-- For brevity, I'll show the structure continues through all elements and seasons

-- 🔥 LAST QUARTER + FIRE + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'last_quarter' AND element = 'fire' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Fire Releases With Wise Purposeful Surrender",
    "es": "El Fuego de Otoño Libera Con Rendición Sabia Propositiva",
    "ca": "El Foc de Tardor Allibera Amb Rendició Sàvia Propositiva"
  }'::jsonb,
  '{
    "en": "The last quarter''s clearing meets autumn''s purposeful letting-go. As Sagittarius wisdom (November-December) releases what blocks higher purpose, surrender becomes philosophical-liberation - you let go of meaningless pursuits with archer precision.",
    "es": "La limpieza del último cuarto se encuentra con el dejar ir propositivo del otoño. Mientras la sabiduría de Sagitario (noviembre-diciembre) libera lo que bloquea propósito superior, rendición se convierte en liberación filosófica - dejas ir búsquedas sin sentido con precisión de arquero.",
    "ca": "La neteja de l''últim quart es troba amb el deixar anar propositiu de la tardor. Mentre la saviesa de Sagitari (novembre-desembre) allibera el que bloqueja propòsit superior, rendició es converteix en alliberament filosòfic - deixes anar recerques sense sentit amb precisió d''arquer."
  }'::jsonb,
  '{
    "en": "Fire''s release becomes purposeful with autumn''s crone wisdom-surrender. Let go of meaningless goals STRATEGICALLY. Surrender empty achievements - the archer aims only at truth.",
    "es": "El lanzamiento del fuego se vuelve propositivo con la rendición de sabiduría anciana del otoño. Deja ir objetivos sin sentido ESTRATÉGICAMENTE. Rinde logros vacíos - el arquero apunta solo a la verdad.",
    "ca": "L''alliberament del foc es torna propositiu amb la rendició de saviesa anciana de la tardor. Deixa anar objectius sense sentit ESTRATÈGICAMENT. Rendeix assoliments buits - l''arquer apunta només a la veritat."
  }'::jsonb,
  '{
    "en": ["Sagittarius wise-release", "Purposeful goal-surrender", "Philosophical letting-go", "Crone''s meaningful-clearing"],
    "es": ["Lanzamiento sabio de Sagitario", "Rendición de objetivos propositiva", "Dejar ir filosófico", "Limpieza significativa de anciana"],
    "ca": ["Alliberament savi de Sagitari", "Rendició d''objectius propositiva", "Deixar anar filosòfic", "Neteja significativa d''anciana"]
  }'::jsonb,
  '{
    "en": ["Release goals that don''t serve your highest purpose", "Surrender achievements that lack deeper meaning with wisdom", "Let go of empty pursuits - aim only at truth", "Forgive meaningless efforts - they taught what matters"],
    "es": ["Libera objetivos que no sirven tu propósito más alto", "Rinde logros que carecen de significado más profundo con sabiduría", "Deja ir búsquedas vacías - apunta solo a la verdad", "Perdona esfuerzos sin sentido - enseñaron lo que importa"],
    "ca": ["Allibera objectius que no serveixen el teu propòsit més alt", "Rendeix assoliments que manquen de significat més profund amb saviesa", "Deixa anar recerques buides - apunta només a la veritat", "Perdona esforços sense sentit - van ensenyar el que importa"]
  }'::jsonb
);

-- 🔥 LAST QUARTER + FIRE + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'last_quarter' AND element = 'fire' LIMIT 1),
  'winter',
  '{
    "en": "Winter Fire Releases With Disciplined Structural Clearing",
    "es": "El Fuego del Invierno Libera Con Limpieza Estructural Disciplinada",
    "ca": "El Foc de l''Hivern Allibera Amb Neteja Estructural Disciplinada"
  }'::jsonb,
  '{
    "en": "The last quarter''s release meets winter''s structural dismantling. As Capricorn mastery (December-January) demolishes outdated foundations, surrender becomes disciplined-clearing - you dismantle what no longer serves with patient methodical precision.",
    "es": "El lanzamiento del último cuarto se encuentra con el desmantelamiento estructural del invierno. Mientras la maestría de Capricornio (diciembre-enero) derriba cimientos obsoletos, rendición se convierte en limpieza disciplinada - desmantelas lo que ya no sirve con precisión metódica paciente.",
    "ca": "L''alliberament de l''últim quart es troba amb el desmantellament estructural de l''hivern. Mentre la mestria de Capricorn (desembre-gener) enderroca fonaments obsolets, rendició es converteix en neteja disciplinada - desmantelles el que ja no serveix amb precisió metòdica pacient."
  }'::jsonb,
  '{
    "en": "Fire''s release becomes structural with winter''s elder disciplined-clearing. Demolish outdated systems SYSTEMATICALLY. Surrender weak foundations - the elder rebuilds only on bedrock.",
    "es": "El lanzamiento del fuego se vuelve estructural con la limpieza disciplinada anciana del invierno. Derriba sistemas obsoletos SISTEMÁTICAMENTE. Rinde cimientos débiles - el anciano reconstruye solo sobre lecho rocoso.",
    "ca": "L''alliberament del foc es torna estructural amb la neteja disciplinada anciana de l''hivern. Enderroca sistemes obsolets SISTEMÀTICAMENT. Rendeix fonaments febles - l''ancià reconstrueix només sobre llit rocós."
  }'::jsonb,
  '{
    "en": ["Capricorn structural-release", "Disciplined system-dismantling", "Patient methodical-clearing", "Elder''s foundation-demolition"],
    "es": ["Lanzamiento estructural de Capricornio", "Desmantelamiento de sistemas disciplinado", "Limpieza metódica paciente", "Demolición de cimientos de anciano"],
    "ca": ["Alliberament estructural de Capricorn", "Desmantellament de sistemes disciplinat", "Neteja metòdica pacient", "Demolició de fonaments d''ancià"]
  }'::jsonb,
  '{
    "en": ["Release outdated structures/systems with Capricorn discipline", "Dismantle weak foundations methodically and patiently", "Surrender unsustainable patterns - rebuild on bedrock", "Forgive structural failures - they revealed true strength"],
    "es": ["Libera estructuras/sistemas obsoletos con disciplina de Capricornio", "Desmantela cimientos débiles metódicamente y pacientemente", "Rinde patrones insostenibles - reconstruye sobre lecho rocoso", "Perdona fracasos estructurales - revelaron verdadera fuerza"],
    "ca": ["Allibera estructures/sistemes obsolets amb disciplina de Capricorn", "Desmantella fonaments febles metòdicament i pacientment", "Rendeix patrons insostenibles - reconstrueix sobre llit rocós", "Perdona fracassos estructurals - van revelar veritable força"]
  }'::jsonb
);

-- =====================================================
-- EARTH, AIR, WATER ELEMENTS × 4 SEASONS
-- (Following same pattern... showing condensed version)
-- =====================================================

-- 🌍 EARTH ELEMENT
INSERT INTO seasonal_overlays (template_id, season, overlay_headline, overlay_description, energy_shift, themes, seasonal_actions)
SELECT
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'last_quarter' AND element = 'earth' LIMIT 1),
  unnest(ARRAY['spring', 'summer', 'autumn', 'winter']::season_type[]),
  unnest(ARRAY[
    '{"en": "Spring Earth Releases To Compost New Growth", "es": "La Tierra de Primavera Libera Para Compost Nuevo Crecimiento", "ca": "La Terra de Primavera Allibera Per Compost Nou Creixement"}'::jsonb,
    '{"en": "Summer Earth Clears With Devoted Precision", "es": "La Tierra de Verano Limpia Con Precisión Devota", "ca": "La Terra d''Estiu Neteja Amb Precisió Devota"}'::jsonb,
    '{"en": "Autumn Earth Releases Harvest That Rotted", "es": "La Tierra de Otoño Libera Cosecha Que Se Pudrió", "ca": "La Terra de Tardor Allibera Collita Que Es Va Podrir"}'::jsonb,
    '{"en": "Winter Earth Clears Deep Roots That Strangle", "es": "La Tierra del Invierno Limpia Raíces Profundas Que Estrangulan", "ca": "La Terra de l''Hivern Neteja Arrels Profundes Que Estrangul·len"}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": "The last quarter release meets spring compost wisdom. As Taurus abundance (April-May) turns what rotted into fertile soil, letting go becomes regeneration - you compost failures into tangible new growth.", "es": "El lanzamiento del último cuarto se encuentra con la sabiduría de compost de primavera. Mientras la abundancia de Tauro (abril-mayo) convierte lo podrido en suelo fértil, dejar ir se convierte en regeneración - compostas fracasos en nuevo crecimiento tangible.", "ca": "L''alliberament de l''últim quart es troba amb la saviesa de compost de primavera. Mentre l''abundància de Taure (abril-maig) converteix el podrit en sòl fèrtil, deixar anar es converteix en regeneració - compostes fracassos en nou creixement tangible."}'::jsonb,
    '{"en": "The last quarter clearing meets summer meticulous devotion. As Virgo precision (August-September) analyzes what to release, surrender becomes service-clearing - you remove every detail that blocks perfection.", "es": "La limpieza del último cuarto se encuentra con la devoción meticulosa del verano. Mientras la precisión de Virgo (agosto-septiembre) analiza qué liberar, rendición se convierte en limpieza de servicio - eliminas cada detalle que bloquea perfección.", "ca": "La neteja de l''últim quart es troba amb la devoció meticulosa de l''estiu. Mentre la precisió de Verge (agost-setembre) analitza què alliberar, rendició es converteix en neteja de servei - elimines cada detall que bloqueja perfecció."}'::jsonb,
    '{"en": "The last quarter release meets autumn harvest wisdom. As Capricorn mastery (December-January) discards what didn''t yield, clearing becomes resource-optimization - you release poor investments shrewdly.", "es": "El lanzamiento del último cuarto se encuentra con la sabiduría de cosecha del otoño. Mientras la maestría de Capricornio (diciembre-enero) descarta lo que no rindió, limpieza se convierte en optimización de recursos - liberas inversiones pobres astutamente.", "ca": "L''alliberament de l''últim quart es troba amb la saviesa de collita de la tardor. Mentre la mestria de Capricorn (desembre-gener) descarta el que no va rendir, neteja es converteix en optimització de recursos - alliberes inversions pobres astutament."}'::jsonb,
    '{"en": "The last quarter clearing meets winter deep excavation. As Taurus endurance (April-May) uproots strangling foundations, surrender becomes deep-clearing - you remove root-systems that prevent growth.", "es": "La limpieza del último cuarto se encuentra con la excavación profunda del invierno. Mientras la resistencia de Tauro (abril-mayo) desarraiga cimientos estranguladores, rendición se convierte en limpieza profunda - eliminas sistemas de raíz que previenen crecimiento.", "ca": "La neteja de l''últim quart es troba amb l''excavació profunda de l''hivern. Mentre la resistència de Taure (abril-maig) desarrela fonaments estranguladors, rendició es converteix en neteja profunda - elimines sistemes d''arrel que prevenen creixement."}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": "Earth''s release becomes fertile with spring compost-wisdom. Failures ROT into new-growth soil. Surrender dead projects - Taurus maiden turns death into abundant life.", "es": "El lanzamiento de la tierra se vuelve fértil con la sabiduría de compost de primavera. Los fracasos SE PUDREN en suelo de nuevo crecimiento. Rinde proyectos muertos - la doncella Tauro convierte muerte en vida abundante.", "ca": "L''alliberament de la terra es torna fèrtil amb la saviesa de compost de primavera. Els fracassos ES PODREIXEN en sòl de nou creixement. Rendeix projectes morts - la donzella Taure converteix mort en vida abundant."}'::jsonb,
    '{"en": "Earth''s release becomes precise with summer devoted analysis. Clear EVERY detail that blocks flow. Surrender imperfection - Virgo mother serves through meticulous removal.", "es": "El lanzamiento de la tierra se vuelve preciso con análisis devoto de verano. Limpia CADA detalle que bloquea flujo. Rinde imperfección - la madre Virgo sirve a través de eliminación meticulosa.", "ca": "L''alliberament de la terra es torna precís amb anàlisi devota d''estiu. Neteja CADA detall que bloqueja flux. Rendeix imperfecció - la mare Verge serveix a través d''eliminació meticulosa."}'::jsonb,
    '{"en": "Earth''s release becomes strategic with autumn resource-wisdom. Discard failed investments SHREWDLY. Surrender poor returns - Capricorn crone optimizes ruthlessly.", "es": "El lanzamiento de la tierra se vuelve estratégico con sabiduría de recursos de otoño. Descarta inversiones fallidas ASTUTAMENTE. Rinde retornos pobres - la anciana Capricornio optimiza despiadadamente.", "ca": "L''alliberament de la terra es torna estratègic amb saviesa de recursos de tardor. Descarta inversions fallides ASTUTAMENT. Rendeix retorns pobres - l''anciana Capricorn optimitza despietadament."}'::jsonb,
    '{"en": "Earth''s release descends into winter deep-clearing. Uproot strangling root-systems COMPLETELY. Surrender suffocating foundations - Taurus elder excavates to bedrock freedom.", "es": "El lanzamiento de la tierra desciende a limpieza profunda de invierno. Desarraiga sistemas de raíz estranguladores COMPLETAMENTE. Rinde cimientos sofocantes - el anciano Tauro excava a libertad de lecho rocoso.", "ca": "L''alliberament de la terra descendeix a neteja profunda d''hivern. Desarrela sistemes d''arrel estranguladors COMPLETAMENT. Rendeix fonaments sufocants - l''ancià Taure excava a llibertat de llit rocós."}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": ["Taurus compost-wisdom", "Fertile death-to-life", "Regenerative release", "Maiden''s rot-to-growth"], "es": ["Sabiduría de compost de Tauro", "Muerte a vida fértil", "Lanzamiento regenerativo", "Pudrición a crecimiento de doncella"], "ca": ["Saviesa de compost de Taure", "Mort a vida fèrtil", "Alliberament regeneratiu", "Podriment a creixement de donzella"]}'::jsonb,
    '{"en": ["Virgo precision-clearing", "Devoted detail-removal", "Service through release", "Mother''s meticulous-surrender"], "es": ["Limpieza de precisión de Virgo", "Eliminación de detalle devoto", "Servicio a través de lanzamiento", "Rendición meticulosa de madre"], "ca": ["Neteja de precisió de Verge", "Eliminació de detall devot", "Servei a través d''alliberament", "Rendició meticulosa de mare"]}'::jsonb,
    '{"en": ["Capricorn resource-optimization", "Strategic investment-release", "Shrewd harvest-clearing", "Crone''s ruthless-efficiency"], "es": ["Optimización de recursos de Capricornio", "Lanzamiento de inversión estratégica", "Limpieza de cosecha astuta", "Eficiencia despiadada de anciana"], "ca": ["Optimització de recursos de Capricorn", "Alliberament d''inversió estratègica", "Neteja de collita astuta", "Eficiència despietada d''anciana"]}'::jsonb,
    '{"en": ["Taurus deep-excavation", "Root-system clearing", "Foundation uprooting", "Elder''s strangling-release"], "es": ["Excavación profunda de Tauro", "Limpieza de sistema de raíz", "Desarraigo de cimientos", "Lanzamiento estrangulador de anciano"], "ca": ["Excavació profunda de Taure", "Neteja de sistema d''arrel", "Desarrelament de fonaments", "Alliberament estrangulador d''ancià"]}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": ["Compost failures into fertile soil for new tangible growth", "Release dead projects - they rot into spring abundance", "Surrender what didn''t bloom - Taurus makes it fertile", "Forgive barrenness - it becomes the richest compost"], "es": ["Composta fracasos en suelo fértil para nuevo crecimiento tangible", "Libera proyectos muertos - se pudren en abundancia primaveral", "Rinde lo que no floreció - Tauro lo hace fértil", "Perdona esterilidad - se convierte en compost más rico"], "ca": ["Composta fracassos en sòl fèrtil per a nou creixement tangible", "Allibera projectes morts - es podeixen en abundància primaveral", "Rendeix el que no va florir - Taure ho fa fèrtil", "Perdona esterilitat - es converteix en compost més ric"]}'::jsonb,
    '{"en": ["Analyze and remove EVERY detail blocking perfect flow", "Clear imperfections with Virgo devoted meticulous care", "Surrender flaws - serve perfection through precise release", "Forgive messiness - it showed what precision requires"], "es": ["Analiza y elimina CADA detalle que bloquea flujo perfecto", "Limpia imperfecciones con cuidado meticuloso devoto de Virgo", "Rinde defectos - sirve perfección a través de lanzamiento preciso", "Perdona desorden - mostró lo que la precisión requiere"], "ca": ["Analitza i elimina CADA detall que bloqueja flux perfecte", "Neteja imperfeccions amb cura meticulosa devota de Verge", "Rendeix defectes - serveix perfecció a través d''alliberament precís", "Perdona desordre - va mostrar el que la precisió requereix"]}'::jsonb,
    '{"en": ["Release investments/efforts that yielded poor returns", "Clear harvest failures strategically to optimize resources", "Surrender what rotted - Capricorn wastes nothing twice", "Forgive poor yields - they taught resource wisdom"], "es": ["Libera inversiones/esfuerzos que rindieron retornos pobres", "Limpia fracasos de cosecha estratégicamente para optimizar recursos", "Rinde lo que se pudrió - Capricornio no desperdicia nada dos veces", "Perdona rendimientos pobres - enseñaron sabiduría de recursos"], "ca": ["Allibera inversions/esforços que van rendir retorns pobres", "Neteja fracassos de collita estratègicament per optimitzar recursos", "Rendeix el que es va podrir - Capricorn no malbarata res dues vegades", "Perdona rendiments pobres - van ensenyar saviesa de recursos"]}'::jsonb,
    '{"en": ["Uproot deep patterns/foundations that strangle growth", "Clear underground systems that suffocate completely", "Surrender strangling roots - excavate to bedrock freedom", "Forgive suffocation - it revealed what needs space"], "es": ["Desarraiga patrones/cimientos profundos que estrangulan crecimiento", "Limpia sistemas subterráneos que sofocaban completamente", "Rinde raíces estranguladoras - excava a libertad de lecho rocoso", "Perdona sofocación - reveló lo que necesita espacio"], "ca": ["Desarrela patrons/fonaments profunds que estrangul·len creixement", "Neteja sistemes subterranis que sufocaven completament", "Rendeix arrels estranguladores - excava a llibertat de llit rocós", "Perdona sufocació - va revelar el que necessita espai"]}'::jsonb
  ]);

-- 💨 AIR ELEMENT (condensed insert)
INSERT INTO seasonal_overlays (template_id, season, overlay_headline, overlay_description, energy_shift, themes, seasonal_actions)
SELECT
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'last_quarter' AND element = 'air' LIMIT 1),
  unnest(ARRAY['spring', 'summer', 'autumn', 'winter']::season_type[]),
  unnest(ARRAY[
    '{"en": "Spring Winds Release Ideas That Didn''t Pollinate", "es": "Los Vientos de Primavera Liberan Ideas Que No Polinizaron", "ca": "Els Vents de Primavera Alliberen Idees Que No Van Pol·linitzar"}'::jsonb,
    '{"en": "Summer Breezes Release Imbalanced Connections", "es": "Las Brisas de Verano Liberan Conexiones Desequilibradas", "ca": "Les Brises d''Estiu Alliberen Connexions Desequilibrades"}'::jsonb,
    '{"en": "Autumn Air Releases Outdated Revolutionary Systems", "es": "El Aire de Otoño Libera Sistemas Revolucionarios Obsoletos", "ca": "L''Aire de Tardor Allibera Sistemes Revolucionaris Obsolets"}'::jsonb,
    '{"en": "Winter Silence Releases Confused Unclear Thinking", "es": "El Silencio del Invierno Libera Pensamiento Confuso Poco Claro", "ca": "El Silenci de l''Hivern Allibera Pensament Confús Poc Clar"}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": "The last quarter release meets spring communication-clearing. As Gemini curiosity (May-June) lets go of ideas that didn''t spread, surrender becomes network-pruning - you clear connections that block fresh pollination.", "es": "El lanzamiento del último cuarto se encuentra con la limpieza de comunicación de primavera. Mientras la curiosidad de Géminis (mayo-junio) deja ir ideas que no se esparcieron, rendición se convierte en poda de red - limpias conexiones que bloquean polinización fresca.", "ca": "L''alliberament de l''últim quart es troba amb la neteja de comunicació de primavera. Mentre la curiositat de Bessons (maig-juny) deixa anar idees que no es van escampar, rendició es converteix en poda de xarxa - neteges connexions que bloquegen pol·linització fresca."}'::jsonb,
    '{"en": "The last quarter clearing meets summer diplomatic balance. As Libra balance (September-October) releases one-sided relationships, surrender becomes graceful-severing - you cut toxic connections with diplomatic care.", "es": "La limpieza del último cuarto se encuentra con el equilibrio diplomático del verano. Mientras el equilibrio de Libra (septiembre-octubre) libera relaciones unilaterales, rendición se convierte en corte gracioso - cortas conexiones tóxicas con cuidado diplomático.", "ca": "La neteja de l''últim quart es troba amb l''equilibri diplomàtic de l''estiu. Mentre l''equilibri de Balança (setembre-octubre) allibera relacions unilaterals, rendició es converteix en tall graciós - talles connexions tòxiques amb cura diplomàtica."}'::jsonb,
    '{"en": "The last quarter release meets autumn systems-evolution. As Aquarius innovation (January-February) discards failed revolutions, clearing becomes upgrade-preparation - you delete obsolete code for new programming.", "es": "El lanzamiento del último cuarto se encuentra con la evolución de sistemas del otoño. Mientras la innovación de Acuario (enero-febrero) descarta revoluciones fallidas, limpieza se convierte en preparación de actualización - eliminas código obsoleto para nueva programación.", "ca": "L''alliberament de l''últim quart es troba amb l''evolució de sistemes de la tardor. Mentre la innovació d''Aquari (gener-febrer) descarta revolucions fallides, neteja es converteix en preparació d''actualització - elimines codi obsolet per a nova programació."}'::jsonb,
    '{"en": "The last quarter clearing meets winter contemplative silence. As Gemini curiosity (May-June) releases confused thinking, surrender becomes clarity-distillation - you clear mental fog to reveal diamond truth.", "es": "La limpieza del último cuarto se encuentra con el silencio contemplativo del invierno. Mientras la curiosidad de Géminis (mayo-junio) libera pensamiento confuso, rendición se convierte en destilación de claridad - limpias niebla mental para revelar verdad de diamante.", "ca": "La neteja de l''últim quart es troba amb el silenci contemplatiu de l''hivern. Mentre la curiositat de Bessons (maig-juny) allibera pensament confús, rendició es converteix en destil·lació de claredat - neteges boira mental per revelar veritat de diamant."}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": "Air''s release blooms with spring network-pruning. Clear failed conversations PLAYFULLY. Surrender ideas that didn''t spread - Gemini maiden makes space for fresh pollination.", "es": "El lanzamiento del aire florece con poda de red de primavera. Limpia conversaciones fallidas JUGUETONAMENTE. Rinde ideas que no se esparcieron - la doncella Géminis hace espacio para polinización fresca.", "ca": "L''alliberament de l''aire floreix amb poda de xarxa de primavera. Neteja converses fallides JOGANERAMENT. Rendeix idees que no es van escampar - la donzella Bessons fa espai per a pol·linització fresca."}'::jsonb,
    '{"en": "Air''s release becomes diplomatic with summer graceful-severing. Cut one-sided bonds BEAUTIFULLY. Surrender imbalance - Libra mother severs toxicity with grace.", "es": "El lanzamiento del aire se vuelve diplomático con corte gracioso de verano. Corta vínculos unilaterales HERMOSAMENTE. Rinde desequilibrio - la madre Libra corta toxicidad con gracia.", "ca": "L''alliberament de l''aire es torna diplomàtic amb tall graciós d''estiu. Talla vincles unilaterals BELLAMENT. Rendeix desequilibri - la mare Balança talla toxicitat amb gràcia."}'::jsonb,
    '{"en": "Air''s release becomes revolutionary with autumn system-deletion. Delete obsolete code EFFICIENTLY. Surrender failed experiments - Aquarius crone clears for upgrade.", "es": "El lanzamiento del aire se vuelve revolucionario con eliminación de sistemas de otoño. Elimina código obsoleto EFICIENTEMENTE. Rinde experimentos fallidos - la anciana Acuario limpia para actualización.", "ca": "L''alliberament de l''aire es torna revolucionari amb eliminació de sistemes de tardor. Elimina codi obsolet EFICIENTMENT. Rendeix experiments fallits - l''anciana Aquari neteja per a actualització."}'::jsonb,
    '{"en": "Air''s release crystallizes with winter clarity-distillation. Clear mental fog COMPLETELY. Surrender confusion - Gemini elder distills diamond truth from chaos.", "es": "El lanzamiento del aire se cristaliza con destilación de claridad de invierno. Limpia niebla mental COMPLETAMENTE. Rinde confusión - el anciano Géminis destila verdad de diamante del caos.", "ca": "L''alliberament de l''aire es cristal·litza amb destil·lació de claredat d''hivern. Neteja boira mental COMPLETAMENT. Rendeix confusió - l''ancià Bessons destil·la veritat de diamant del caos."}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": ["Gemini network-pruning", "Playful idea-clearing", "Fresh pollination space", "Maiden''s conversation-release"], "es": ["Poda de red de Géminis", "Limpieza de ideas juguetona", "Espacio de polinización fresca", "Lanzamiento de conversación de doncella"], "ca": ["Poda de xarxa de Bessons", "Neteja d''idees joganera", "Espai de pol·linització fresca", "Alliberament de conversa de donzella"]}'::jsonb,
    '{"en": ["Libra graceful-severing", "Diplomatic connection-cutting", "Balanced relationship-release", "Mother''s toxic-clearing"], "es": ["Corte gracioso de Libra", "Corte de conexión diplomático", "Lanzamiento de relación equilibrada", "Limpieza tóxica de madre"], "ca": ["Tall graciós de Balança", "Tall de connexió diplomàtic", "Alliberament de relació equilibrada", "Neteja tòxica de mare"]}'::jsonb,
    '{"en": ["Aquarius system-deletion", "Revolutionary code-clearing", "Efficient upgrade-preparation", "Crone''s obsolete-purge"], "es": ["Eliminación de sistemas de Acuario", "Limpieza de código revolucionario", "Preparación de actualización eficiente", "Purga obsoleta de anciana"], "ca": ["Eliminació de sistemes d''Aquari", "Neteja de codi revolucionari", "Preparació d''actualització eficient", "Purga obsoleta d''anciana"]}'::jsonb,
    '{"en": ["Gemini clarity-distillation", "Silent mental-fog clearing", "Confusion-release contemplation", "Elder''s diamond-truth"], "es": ["Destilación de claridad de Géminis", "Limpieza de niebla mental silenciosa", "Contemplación de lanzamiento de confusión", "Verdad de diamante de anciano"], "ca": ["Destil·lació de claredat de Bessons", "Neteja de boira mental silenciosa", "Contemplació d''alliberament de confusió", "Veritat de diamant d''ancià"]}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": ["Release ideas/connections that didn''t spread or grow", "Clear conversational networks that block fresh exchange", "Surrender failed pollination - make space for new ideas", "Forgive sterile connections - they showed what needs pruning"], "es": ["Libera ideas/conexiones que no se esparcieron o crecieron", "Limpia redes conversacionales que bloquean intercambio fresco", "Rinde polinización fallida - haz espacio para nuevas ideas", "Perdona conexiones estériles - mostraron lo que necesita poda"], "ca": ["Allibera idees/connexions que no es van escampar o créixer", "Neteja xarxes conversacionals que bloquegen intercanvi fresc", "Rendeix pol·linització fallida - fes espai per a noves idees", "Perdona connexions estèrils - van mostrar el que necessita poda"]}'::jsonb,
    '{"en": ["Sever one-sided toxic relationships with Libra grace", "Cut imbalanced connections diplomatically and beautifully", "Surrender relationships lacking reciprocity - clear toxicity", "Forgive imbalance - it taught what true partnership requires"], "es": ["Corta relaciones tóxicas unilaterales con gracia de Libra", "Corta conexiones desequilibradas diplomática y hermosamente", "Rinde relaciones sin reciprocidad - limpia toxicidad", "Perdona desequilibrio - enseñó lo que la verdadera asociación requiere"], "ca": ["Talla relacions tòxiques unilaterals amb gràcia de Balança", "Talla connexions desequilibrades diplomàticament i bellament", "Rendeix relacions sense reciprocitat - neteja toxicitat", "Perdona desequilibri - va ensenyar el que la veritable associació requereix"]}'::jsonb,
    '{"en": ["Delete failed revolutionary systems/experiments efficiently", "Clear obsolete collective structures for upgrade", "Surrender outdated visions - make space for evolution 2.0", "Forgive failed revolutions - they paved path for next leap"], "es": ["Elimina sistemas/experimentos revolucionarios fallidos eficientemente", "Limpia estructuras colectivas obsoletas para actualización", "Rinde visiones obsoletas - haz espacio para evolución 2.0", "Perdona revoluciones fallidas - pavimentaron camino para próximo salto"], "ca": ["Elimina sistemes/experiments revolucionaris fallits eficientment", "Neteja estructures col·lectives obsoletes per a actualització", "Rendeix visions obsoletes - fes espai per a evolució 2.0", "Perdona revolucions fallides - van pavimentar camí per a proper salt"]}'::jsonb,
    '{"en": ["Clear mental confusion with contemplative silent clarity", "Release foggy unclear thinking - distill to diamond truth", "Surrender chaos - let silence crystallize absolute knowing", "Forgive confusion - it refined your capacity for clarity"], "es": ["Limpia confusión mental con claridad silenciosa contemplativa", "Libera pensamiento confuso poco claro - destila a verdad de diamante", "Rinde caos - deja que el silencio cristalice conocimiento absoluto", "Perdona confusión - refinó tu capacidad de claridad"], "ca": ["Neteja confusió mental amb claredat silenciosa contemplativa", "Allibera pensament confús poc clar - destil·la a veritat de diamant", "Rendeix caos - deixa que el silenci cristal·litzi coneixement absolut", "Perdona confusió - va refinar la teva capacitat de claredat"]}'::jsonb
  ]);

-- 💧 WATER ELEMENT (condensed insert)
INSERT INTO seasonal_overlays (template_id, season, overlay_headline, overlay_description, energy_shift, themes, seasonal_actions)
SELECT
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'last_quarter' AND element = 'water' LIMIT 1),
  unnest(ARRAY['spring', 'summer', 'autumn', 'winter']::season_type[]),
  unnest(ARRAY[
    '{"en": "Spring Waters Release Emotional Dams With Courage", "es": "Las Aguas de Primavera Liberan Represas Emocionales Con Coraje", "ca": "Les Aigües de Primavera Alliberen Represes Emocionals Amb Coratge"}'::jsonb,
    '{"en": "Summer Waters Release Toxic Alchemical Residue", "es": "Las Aguas del Verano Liberan Residuo Alquímico Tóxico", "ca": "Les Aigües de l''Estiu Alliberen Residu Alquímic Tòxic"}'::jsonb,
    '{"en": "Autumn Waters Dissolve Boundaries That Isolate", "es": "Las Aguas de Otoño Disuelven Límites Que Aíslan", "ca": "Les Aigües de Tardor Dissolen Límits Que Aïllen"}'::jsonb,
    '{"en": "Winter Waters Release Unsafe Emotional Containers", "es": "Las Aguas del Invierno Liberan Contenedores Emocionales Inseguros", "ca": "Les Aigües de l''Hivern Alliberen Contenidors Emocionals Insegurs"}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": "The last quarter release meets spring emotional-flooding. As Cancer courage (June-July) breaks emotional dams bravely, surrender becomes feeling-liberation - you let suppressed emotions FLOW freely like spring floods.", "es": "El lanzamiento del último cuarto se encuentra con la inundación emocional de primavera. Mientras el coraje de Cáncer (junio-julio) rompe represas emocionales valientemente, rendición se convierte en liberación de sentimientos - dejas que emociones suprimidas FLUYAN libremente como inundaciones primaverales.", "ca": "L''alliberament de l''últim quart es troba amb la inundació emocional de primavera. Mentre el coratge de Cranc (juny-juliol) trenca represes emocionals valentament, rendició es converteix en alliberament de sentiments - deixes que emocions suprimides FLUEIXIN lliurement com inundacions primeraverals."}'::jsonb,
    '{"en": "The last quarter clearing meets summer alchemical-purging. As Scorpio intensity (October-November) releases transformation byproducts, surrender becomes detox - you purge toxic emotional residue from deep metamorphosis.", "es": "La limpieza del último cuarto se encuentra con la purga alquímica del verano. Mientras la intensidad de Escorpio (octubre-noviembre) libera subproductos de transformación, rendición se convierte en desintoxicación - purgas residuo emocional tóxico de metamorfosis profunda.", "ca": "La neteja de l''últim quart es troba amb la purga alquímica de l''estiu. Mentre la intensitat d''Escorpí (octubre-novembre) allibera subproductes de transformació, rendició es converteix en desintoxicació - purges residu emocional tòxic de metamorfosi profunda."}'::jsonb,
    '{"en": "The last quarter release meets autumn boundary-dissolving. As Pisces compassion (February-March) releases walls that isolate, clearing becomes unity-opening - you dissolve protective barriers that prevent cosmic connection.", "es": "El lanzamiento del último cuarto se encuentra con la disolución de límites del otoño. Mientras la compasión de Piscis (febrero-marzo) libera muros que aíslan, limpieza se convierte en apertura de unidad - disuelves barreras protectoras que previenen conexión cósmica.", "ca": "L''alliberament de l''últim quart es troba amb la dissolució de límits de la tardor. Mentre la compassió de Peixos (febrer-març) allibera murs que aïllen, neteja es converteix en obertura d''unitat - dissolves barreres protectores que prevenen connexió còsmica."}'::jsonb,
    '{"en": "The last quarter clearing meets winter sanctuary-dissolution. As Cancer protection (June-July) releases containers that became prisons, surrender becomes space-liberation - you dissolve emotional containers that suffocate rather than shelter.", "es": "La limpieza del último cuarto se encuentra con la disolución de santuario del invierno. Mientras la protección de Cáncer (junio-julio) libera contenedores que se convirtieron en prisiones, rendición se convierte en liberación de espacio - disuelves contenedores emocionales que sofocaban en lugar de proteger.", "ca": "La neteja de l''últim quart es troba amb la dissolució de santuari de l''hivern. Mentre la protecció de Cranc (juny-juliol) allibera contenidors que es van convertir en presons, rendició es converteix en alliberament d''espai - dissolves contenidors emocionals que sufocaven en lloc de protegir."}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": "Water''s release floods with spring emotional-dam breaking. Let suppressed feelings FLOW bravely. Surrender emotional holding - Cancer maiden breaks all dams courageously.", "es": "El lanzamiento del agua inunda con ruptura de represa emocional de primavera. Deja que sentimientos suprimidos FLUYAN valientemente. Rinde contención emocional - la doncella Cáncer rompe todas las represas con coraje.", "ca": "L''alliberament de l''aigua inunda amb ruptura de represa emocional de primavera. Deixa que sentiments suprimits FLUEIXIN valentament. Rendeix contenció emocional - la donzella Cranc trenca totes les represes amb coratge."}'::jsonb,
    '{"en": "Water''s release purges with summer alchemical-detox. Expel transformation toxins INTENSELY. Surrender poisonous residue - Scorpio mother cleanses the crucible completely.", "es": "El lanzamiento del agua purga con desintoxicación alquímica de verano. Expulsa toxinas de transformación INTENSAMENTE. Rinde residuo venenoso - la madre Escorpio limpia el crisol completamente.", "ca": "L''alliberament de l''aigua purga amb desintoxicació alquímica d''estiu. Expulsa toxines de transformació INTENSAMENT. Rendeix residu verinós - la mare Escorpí neteja el gresol completament."}'::jsonb,
    '{"en": "Water''s release dissolves with autumn boundary-opening. Melt isolation walls COMPASSIONATELY. Surrender separation - Pisces crone flows into cosmic unity fearlessly.", "es": "El lanzamiento del agua disuelve con apertura de límites de otoño. Derrite muros de aislamiento COMPASIVAMENTE. Rinde separación - la anciana Piscis fluye hacia unidad cósmica sin miedo.", "ca": "L''alliberament de l''aigua dissol amb obertura de límits de tardor. Fon murs d''aïllament COMPASSIVAMENT. Rendeix separació - l''anciana Peixos flueix cap a unitat còsmica sense por."}'::jsonb,
    '{"en": "Water''s release liberates with winter container-dissolution. Dissolve suffocating sanctuaries COMPLETELY. Surrender prisons disguised as protection - Cancer elder knows true safety needs space.", "es": "El lanzamiento del agua libera con disolución de contenedor de invierno. Disuelve santuarios sofocantes COMPLETAMENTE. Rinde prisiones disfrazadas de protección - el anciano Cáncer sabe que la verdadera seguridad necesita espacio.", "ca": "L''alliberament de l''aigua allibera amb dissolució de contenidor d''hivern. Dissol santuaris sufocants COMPLETAMENT. Rendeix presons disfressades de protecció - l''ancià Cranc sap que la veritable seguretat necessita espai."}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": ["Cancer dam-breaking", "Brave emotional-flooding", "Suppression-release", "Maiden''s feeling-liberation"], "es": ["Ruptura de represa de Cáncer", "Inundación emocional valiente", "Lanzamiento de supresión", "Liberación de sentimientos de doncella"], "ca": ["Ruptura de represa de Cranc", "Inundació emocional valenta", "Alliberament de supressió", "Alliberament de sentiments de donzella"]}'::jsonb,
    '{"en": ["Scorpio alchemical-detox", "Intense transformation-purge", "Toxic residue-release", "Mother''s crucible-cleansing"], "es": ["Desintoxicación alquímica de Escorpio", "Purga de transformación intensa", "Lanzamiento de residuo tóxico", "Limpieza de crisol de madre"], "ca": ["Desintoxicació alquímica d''Escorpí", "Purga de transformació intensa", "Alliberament de residu tòxic", "Neteja de gresol de mare"]}'::jsonb,
    '{"en": ["Pisces boundary-dissolving", "Compassionate wall-melting", "Isolation-release", "Crone''s unity-opening"], "es": ["Disolución de límites de Piscis", "Derretimiento de muros compasivo", "Lanzamiento de aislamiento", "Apertura de unidad de anciana"], "ca": ["Dissolució de límits de Peixos", "Fosa de murs compassiva", "Alliberament d''aïllament", "Obertura d''unitat d''anciana"]}'::jsonb,
    '{"en": ["Cancer container-liberation", "Sanctuary-prison dissolution", "Suffocating space-release", "Elder''s freedom-clearing"], "es": ["Liberación de contenedor de Cáncer", "Disolución de santuario-prisión", "Lanzamiento de espacio sofocante", "Limpieza de libertad de anciano"], "ca": ["Alliberament de contenidor de Cranc", "Dissolució de santuari-presó", "Alliberament d''espai sufocant", "Neteja de llibertat d''ancià"]}'::jsonb
  ]),
  unnest(ARRAY[
    '{"en": ["Break emotional dams - let suppressed feelings FLOOD freely", "Release held emotions with Cancer brave vulnerability", "Surrender emotional control - trust the cleansing flood", "Forgive suppression - it protected until you were ready"], "es": ["Rompe represas emocionales - deja que sentimientos suprimidos INUNDEN libremente", "Libera emociones retenidas con vulnerabilidad valiente de Cáncer", "Rinde control emocional - confía en la inundación limpiadora", "Perdona supresión - protegió hasta que estuviste listo"], "ca": ["Trenca represes emocionals - deixa que sentiments suprimits INUNDIN lliurement", "Allibera emocions retingudes amb vulnerabilitat valenta de Cranc", "Rendeix control emocional - confia en la inundació netejadora", "Perdona supressió - va protegir fins que estaves preparat"]}'::jsonb,
    '{"en": ["Purge toxic emotional residue from deep transformation", "Release alchemical byproducts with Scorpio intensity", "Surrender transformation poison - detox the crucible completely", "Forgive toxic residue - metamorphosis always leaves waste"], "es": ["Purga residuo emocional tóxico de transformación profunda", "Libera subproductos alquímicos con intensidad de Escorpio", "Rinde veneno de transformación - desintoxica el crisol completamente", "Perdona residuo tóxico - la metamorfosis siempre deja desechos"], "ca": ["Purga residu emocional tòxic de transformació profunda", "Allibera subproductes alquímics amb intensitat d''Escorpí", "Rendeix verí de transformació - desintoxica el gresol completament", "Perdona residu tòxic - la metamorfosi sempre deixa residus"]}'::jsonb,
    '{"en": ["Dissolve boundaries/walls that prevent cosmic connection", "Release isolation with Pisces compassionate unity", "Surrender protective barriers that became separation", "Forgive walls - they taught what true oneness requires"], "es": ["Disuelve límites/muros que previenen conexión cósmica", "Libera aislamiento con unidad compasiva de Piscis", "Rinde barreras protectoras que se convirtieron en separación", "Perdona muros - enseñaron lo que la verdadera unidad requiere"], "ca": ["Dissol límits/murs que prevenen connexió còsmica", "Allibera aïllament amb unitat compassiva de Peixos", "Rendeix barreres protectores que es van convertir en separació", "Perdona murs - van ensenyar el que la veritable unitat requereix"]}'::jsonb,
    '{"en": ["Dissolve emotional containers that became suffocating prisons", "Release sanctuaries turned toxic with Cancer wisdom", "Surrender over-protection - true safety needs breathing space", "Forgive containment - it showed what freedom truly means"], "es": ["Disuelve contenedores emocionales que se convirtieron en prisiones sofocantes", "Libera santuarios convertidos en tóxicos con sabiduría de Cáncer", "Rinde sobreprotección - la verdadera seguridad necesita espacio para respirar", "Perdona contención - mostró lo que la libertad realmente significa"], "ca": ["Dissol contenidors emocionals que es van convertir en presons sufocants", "Allibera santuaris convertits en tòxics amb saviesa de Cranc", "Rendeix sobreprotecció - la veritable seguretat necessita espai per respirar", "Perdona contenció - va mostrar el que la llibertat realment significa"]}'::jsonb
  ]);

-- =====================================================
-- COMPLETION COMMENT
-- =====================================================
-- ✅ LAST QUARTER SEASONAL OVERLAYS COMPLETE (16/16)
-- Next file: 20251116000014_seed_seasonal_waning_crescent.sql
