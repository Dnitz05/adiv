-- =====================================================
-- SEED SEASONAL OVERLAYS: WAXING CRESCENT (16 overlays)
-- =====================================================
-- Phase: Waxing Crescent (first light after new moon)
-- Energy: Building momentum, faith, first visible steps
-- Overlays: 4 elements × 4 seasons = 16 total
--
-- Waxing Crescent represents the first rays of visible light
-- after the dark new moon - faith, trust, emerging growth,
-- nurturing seedlings, overcoming doubt, taking first steps.

-- =====================================================
-- FIRE ELEMENT × 4 SEASONS
-- =====================================================

-- 🔥 WAXING CRESCENT + FIRE + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_crescent' AND element = 'fire' LIMIT 1),
  'spring',
  '{
    "en": "Spring''s First Flames Burst Into Action",
    "es": "Las Primeras Llamas de Primavera Estallan en Acción",
    "ca": "Les Primeres Flames de Primavera Esclaten en Acció"
  }'::jsonb,
  '{
    "en": "The waxing crescent''s building momentum meets spring''s explosive emergence. As Aries courage (March-April) ignites your first bold steps, faith becomes fearless action - sprouts break through soil with unstoppable force.",
    "es": "El impulso creciente de la luna creciente se encuentra con la emergencia explosiva de la primavera. Mientras el coraje de Aries (marzo-abril) enciende tus primeros pasos audaces, la fe se convierte en acción intrépida - los brotes atraviesan el suelo con fuerza imparable.",
    "ca": "L''impuls creixent de la lluna creixent es troba amb l''emergència explosiva de la primavera. Mentre el coratge d''Àries (març-abril) encén els teus primers passos audaços, la fe es converteix en acció intrèpida - els brots travessen el sòl amb força imparable."
  }'::jsonb,
  '{
    "en": "Fire''s momentum is supercharged by spring''s renewal explosion. First steps become bold leaps. Faith transforms into warrior courage. The maiden energy says YES to all emerging possibilities.",
    "es": "El impulso del fuego se supercarga con la explosión renovadora de la primavera. Los primeros pasos se convierten en saltos audaces. La fe se transforma en coraje guerrero. La energía de la doncella dice SÍ a todas las posibilidades emergentes.",
    "ca": "L''impuls del foc se supercarrega amb l''explosió renovadora de la primavera. Els primers passos es converteixen en salts audaços. La fe es transforma en coratge guerrer. L''energia de la donzella diu SÍ a totes les possibilitats emergents."
  }'::jsonb,
  '{
    "en": ["Aries boldness", "Explosive emergence", "Fearless first steps", "Maiden warrior faith"],
    "es": ["Audacia de Aries", "Emergencia explosiva", "Primeros pasos intrépidos", "Fe guerrera de la doncella"],
    "ca": ["Audàcia d''Àries", "Emergència explosiva", "Primers passos intrèpids", "Fe guerrera de la donzella"]
  }'::jsonb,
  '{
    "en": ["Take one bold action TODAY on your new moon intention", "Break through any obstacle with Aries courage", "Trust the explosive momentum of spring renewal", "Let faith become fearless forward movement"],
    "es": ["Toma UNA acción audaz HOY sobre tu intención de luna nueva", "Atraviesa cualquier obstáculo con coraje de Aries", "Confía en el impulso explosivo de la renovación primaveral", "Deja que la fe se convierta en movimiento intrépido hacia adelante"],
    "ca": ["Pren UNA acció audaç AVUI sobre la teva intenció de lluna nova", "Travessa qualsevol obstacle amb coratge d''Àries", "Confia en l''impuls explosiu de la renovació primaveral", "Deixa que la fe es converteixi en moviment intrèpid endavant"]
  }'::jsonb
);

-- 🔥 WAXING CRESCENT + FIRE + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_crescent' AND element = 'fire' LIMIT 1),
  'summer',
  '{
    "en": "Summer''s Full Light Fuels Confident Steps",
    "es": "La Luz Plena del Verano Alimenta Pasos Confiados",
    "ca": "La Llum Plena de l''Estiu Alimenta Passos Confiats"
  }'::jsonb,
  '{
    "en": "The waxing crescent''s emerging light meets summer''s peak radiance. As Leo confidence (July-August) shines on your first actions, faith becomes joyful self-expression - you step forward in full brilliant visibility.",
    "es": "La luz emergente de la luna creciente se encuentra con la radiancia máxima del verano. Mientras la confianza de Leo (julio-agosto) brilla sobre tus primeras acciones, la fe se convierte en expresión personal gozosa - avanzas con plena visibilidad brillante.",
    "ca": "La llum emergent de la lluna creixent es troba amb la radiància màxima de l''estiu. Mentre la confiança de Leo (juliol-agost) brilla sobre les teves primeres accions, la fe es converteix en expressió personal joiosa - avances amb plena visibilitat brillant."
  }'::jsonb,
  '{
    "en": "Fire''s momentum blazes under summer''s full sun. First steps become radiant performances. Faith transforms into playful creative confidence. The mother energy abundantly supports all bold expression.",
    "es": "El impulso del fuego arde bajo el sol pleno del verano. Los primeros pasos se convierten en actuaciones radiantes. La fe se transforma en confianza creativa juguetona. La energía de la madre apoya abundantemente toda expresión audaz.",
    "ca": "L''impuls del foc crema sota el sol ple de l''estiu. Els primers passos es converteixen en actuacions radiants. La fe es transforma en confiança creativa joganera. L''energia de la mare dona suport abundantment a tota expressió audaç."
  }'::jsonb,
  '{
    "en": ["Leo radiance", "Confident expression", "Playful bold steps", "Mother''s abundant support"],
    "es": ["Radiancia de Leo", "Expresión confiada", "Pasos audaces juguetones", "Apoyo abundante de la madre"],
    "ca": ["Radiància de Leo", "Expressió confiada", "Passos audaços joganers", "Suport abundant de la mare"]
  }'::jsonb,
  '{
    "en": ["Take your first step with full joyful visibility", "Express your intention creatively and confidently", "Trust you deserve to shine as you build momentum", "Let others SEE your emerging brilliance"],
    "es": ["Da tu primer paso con plena visibilidad gozosa", "Expresa tu intención creativa y confiadamente", "Confía en que mereces brillar mientras construyes impulso", "Deja que otros VEAN tu brillantez emergente"],
    "ca": ["Fes el teu primer pas amb plena visibilitat joiosa", "Expressa la teva intenció creativa i confiada", "Confia que mereixes brillar mentre construeixes impuls", "Deixa que altres VEGIN la teva brillantor emergent"]
  }'::jsonb
);

-- 🔥 WAXING CRESCENT + FIRE + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_crescent' AND element = 'fire' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn''s Strategic Fire Builds With Purpose",
    "es": "El Fuego Estratégico del Otoño Construye Con Propósito",
    "ca": "El Foc Estratègic de la Tardor Construeix Amb Propòsit"
  }'::jsonb,
  '{
    "en": "The waxing crescent''s building energy meets autumn''s harvest wisdom. As Sagittarius purpose (November-December) guides your first steps, faith becomes strategic action - you build momentum toward a meaningful goal.",
    "es": "La energía constructiva de la luna creciente se encuentra con la sabiduría de cosecha del otoño. Mientras el propósito de Sagitario (noviembre-diciembre) guía tus primeros pasos, la fe se convierte en acción estratégica - construyes impulso hacia un objetivo significativo.",
    "ca": "L''energia constructiva de la lluna creixent es troba amb la saviesa de collita de la tardor. Mentre el propòsit de Sagitari (novembre-desembre) guia els teus primers passos, la fe es converteix en acció estratègica - construeixes impuls cap a un objectiu significatiu."
  }'::jsonb,
  '{
    "en": "Fire''s momentum becomes purposeful under autumn''s crone wisdom. First steps are calculated for harvest. Faith transforms into philosophical certainty. You build toward what matters most.",
    "es": "El impulso del fuego se vuelve propositivo bajo la sabiduría de la anciana del otoño. Los primeros pasos se calculan para la cosecha. La fe se transforma en certeza filosófica. Construyes hacia lo que más importa.",
    "ca": "L''impuls del foc es torna propositiu sota la saviesa de l''anciana de la tardor. Els primers passos es calculen per a la collita. La fe es transforma en certesa filosòfica. Construeixes cap al que més importa."
  }'::jsonb,
  '{
    "en": ["Sagittarius purpose", "Strategic building", "Harvest-minded action", "Crone wisdom guides"],
    "es": ["Propósito de Sagitario", "Construcción estratégica", "Acción orientada a la cosecha", "Sabiduría de anciana guía"],
    "ca": ["Propòsit de Sagitari", "Construcció estratègica", "Acció orientada a la collita", "Saviesa d''anciana guia"]
  }'::jsonb,
  '{
    "en": ["Take first steps aligned with your ultimate harvest goal", "Build momentum with philosophical clarity", "Trust your actions lead somewhere meaningful", "Let wisdom guide every inch of forward movement"],
    "es": ["Da primeros pasos alineados con tu objetivo de cosecha final", "Construye impulso con claridad filosófica", "Confía en que tus acciones conducen a algo significativo", "Deja que la sabiduría guíe cada centímetro de movimiento hacia adelante"],
    "ca": ["Fes primers passos alineats amb el teu objectiu de collita final", "Construeix impuls amb claredat filosòfica", "Confia que les teves accions condueixen a alguna cosa significativa", "Deixa que la saviesa guiï cada centímetre de moviment endavant"]
  }'::jsonb
);

-- 🔥 WAXING CRESCENT + FIRE + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_crescent' AND element = 'fire' LIMIT 1),
  'winter',
  '{
    "en": "Winter''s Slow Burn Builds Unshakable Will",
    "es": "La Combustión Lenta del Invierno Construye Voluntad Inquebrantable",
    "ca": "La Combustió Lenta de l''Hivern Construeix Voluntat Inquebrantable"
  }'::jsonb,
  '{
    "en": "The waxing crescent''s emerging light meets winter''s patient discipline. As Capricorn determination (December-January) structures your first steps, faith becomes enduring commitment - you build slowly, but nothing can stop you.",
    "es": "La luz emergente de la luna creciente se encuentra con la disciplina paciente del invierno. Mientras la determinación de Capricornio (diciembre-enero) estructura tus primeros pasos, la fe se convierte en compromiso duradero - construyes lentamente, pero nada puede detenerte.",
    "ca": "La llum emergent de la lluna creixent es troba amb la disciplina pacient de l''hivern. Mentre la determinació de Capricorn (desembre-gener) estructura els teus primers passos, la fe es converteix en compromís durador - construeixes lentament, però res no et pot aturar."
  }'::jsonb,
  '{
    "en": "Fire''s momentum becomes disciplined under winter''s elder structure. First steps are foundations for empires. Faith transforms into unshakable resolve. You build with the patience of mountains.",
    "es": "El impulso del fuego se vuelve disciplinado bajo la estructura anciana del invierno. Los primeros pasos son cimientos para imperios. La fe se transforma en resolución inquebrantable. Construyes con la paciencia de las montañas.",
    "ca": "L''impuls del foc es torna disciplinat sota l''estructura anciana de l''hivern. Els primers passos són fonaments per a imperis. La fe es transforma en resolució inquebrantable. Construeixes amb la paciència de les muntanyes."
  }'::jsonb,
  '{
    "en": ["Capricorn discipline", "Patient building", "Enduring commitment", "Elder structural will"],
    "es": ["Disciplina de Capricornio", "Construcción paciente", "Compromiso duradero", "Voluntad estructural anciana"],
    "ca": ["Disciplina de Capricorn", "Construcció pacient", "Compromís durador", "Voluntat estructural anciana"]
  }'::jsonb,
  '{
    "en": ["Take one disciplined step daily toward your goal", "Build foundation with winter''s patient strength", "Trust slow progress creates unshakable results", "Let commitment become your sacred structure"],
    "es": ["Da un paso disciplinado diario hacia tu objetivo", "Construye cimientos con la fuerza paciente del invierno", "Confía en que el progreso lento crea resultados inquebrantables", "Deja que el compromiso se convierta en tu estructura sagrada"],
    "ca": ["Fes un pas disciplinat diari cap al teu objectiu", "Construeix fonaments amb la força pacient de l''hivern", "Confia que el progrés lent crea resultats inquebrantables", "Deixa que el compromís es converteixi en la teva estructura sagrada"]
  }'::jsonb
);

-- =====================================================
-- EARTH ELEMENT × 4 SEASONS
-- =====================================================

-- 🌍 WAXING CRESCENT + EARTH + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_crescent' AND element = 'earth' LIMIT 1),
  'spring',
  '{
    "en": "Spring Earth Nurtures Rapid Root Growth",
    "es": "La Tierra de Primavera Nutre Rápido Crecimiento de Raíces",
    "ca": "La Terra de Primavera Nodreix Ràpid Creixement d''Arrels"
  }'::jsonb,
  '{
    "en": "The waxing crescent''s building momentum meets spring''s fertile soil. As Taurus abundance (April-May) grounds your first practical steps, faith becomes tangible growth - roots push deep as sprouts push high.",
    "es": "El impulso creciente de la luna creciente se encuentra con el suelo fértil de la primavera. Mientras la abundancia de Tauro (abril-mayo) fundamenta tus primeros pasos prácticos, la fe se convierte en crecimiento tangible - las raíces empujan profundo mientras los brotes empujan alto.",
    "ca": "L''impuls creixent de la lluna creixent es troba amb el sòl fèrtil de la primavera. Mentre l''abundància de Taure (abril-maig) fonamenta els teus primers passos pràctics, la fe es converteix en creixement tangible - les arrels empenten profund mentre els brots empenten alt."
  }'::jsonb,
  '{
    "en": "Earth''s practical building is supercharged by spring''s explosive fertility. First steps create visible results FAST. Faith becomes sensory - you can SEE, TOUCH, SMELL your progress blooming.",
    "es": "La construcción práctica de la tierra se supercarga con la fertilidad explosiva de la primavera. Los primeros pasos crean resultados visibles RÁPIDO. La fe se vuelve sensorial - puedes VER, TOCAR, OLER tu progreso floreciendo.",
    "ca": "La construcció pràctica de la terra se supercarrega amb la fertilitat explosiva de la primavera. Els primers passos creen resultats visibles RÀPID. La fe es torna sensorial - pots VEURE, TOCAR, OLORAR el teu progrés florint."
  }'::jsonb,
  '{
    "en": ["Taurus fertility", "Sensory growth", "Rapid rooting", "Maiden abundance"],
    "es": ["Fertilidad de Tauro", "Crecimiento sensorial", "Enraizamiento rápido", "Abundancia de doncella"],
    "ca": ["Fertilitat de Taure", "Creixement sensorial", "Arrelament ràpid", "Abundància de donzella"]
  }'::jsonb,
  '{
    "en": ["Plant actual seeds or start practical projects NOW", "Take one tangible step you can see/touch/measure", "Trust spring''s fertility makes all efforts bloom", "Build foundations in the most fertile soil of the year"],
    "es": ["Planta semillas reales o inicia proyectos prácticos AHORA", "Da un paso tangible que puedas ver/tocar/medir", "Confía en que la fertilidad de la primavera hace florecer todos los esfuerzos", "Construye cimientos en el suelo más fértil del año"],
    "ca": ["Planta llavors reals o inicia projectes pràctics ARA", "Fes un pas tangible que puguis veure/tocar/mesurar", "Confia que la fertilitat de la primavera fa florir tots els esforços", "Construeix fonaments al sòl més fèrtil de l''any"]
  }'::jsonb
);

-- 🌍 WAXING CRESCENT + EARTH + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_crescent' AND element = 'earth' LIMIT 1),
  'summer',
  '{
    "en": "Summer''s Rich Soil Feeds Abundant Growth",
    "es": "El Suelo Rico del Verano Alimenta Crecimiento Abundante",
    "ca": "El Sòl Ric de l''Estiu Alimenta Creixement Abundant"
  }'::jsonb,
  '{
    "en": "The waxing crescent''s practical building meets summer''s peak nourishment. As Virgo precision (August-September) tends your first efforts, faith becomes meticulous care - you nurture each detail of emerging growth with devoted attention.",
    "es": "La construcción práctica de la luna creciente se encuentra con la nutrición máxima del verano. Mientras la precisión de Virgo (agosto-septiembre) cuida tus primeros esfuerzos, la fe se convierte en cuidado meticuloso - nutres cada detalle del crecimiento emergente con atención devota.",
    "ca": "La construcció pràctica de la lluna creixent es troba amb la nutrició màxima de l''estiu. Mentre la precisió de Verge (agost-setembre) cuida els teus primers esforços, la fe es converteix en cura meticulosa - nodreixes cada detall del creixement emergent amb atenció devota."
  }'::jsonb,
  '{
    "en": "Earth''s building becomes abundant under summer''s mother care. First steps receive perfect nourishment. Faith transforms into devoted tending. You cultivate growth with precision and love.",
    "es": "La construcción de la tierra se vuelve abundante bajo el cuidado maternal del verano. Los primeros pasos reciben nutrición perfecta. La fe se transforma en cuidado devoto. Cultivas crecimiento con precisión y amor.",
    "ca": "La construcció de la terra es torna abundant sota la cura maternal de l''estiu. Els primers passos reben nutrició perfecta. La fe es transforma en cura devota. Cultives creixement amb precisió i amor."
  }'::jsonb,
  '{
    "en": ["Virgo precision", "Devoted tending", "Perfect nourishment", "Mother''s meticulous care"],
    "es": ["Precisión de Virgo", "Cuidado devoto", "Nutrición perfecta", "Cuidado meticuloso de madre"],
    "ca": ["Precisió de Verge", "Cura devota", "Nutrició perfecta", "Cura meticulosa de mare"]
  }'::jsonb,
  '{
    "en": ["Tend your emerging projects with devoted daily attention", "Perfect one small detail of your building process", "Trust that meticulous care creates abundant results", "Nourish your first steps like a mother feeds her child"],
    "es": ["Cuida tus proyectos emergentes con atención diaria devota", "Perfecciona un pequeño detalle de tu proceso de construcción", "Confía en que el cuidado meticuloso crea resultados abundantes", "Nutre tus primeros pasos como una madre alimenta a su hijo"],
    "ca": ["Cuida els teus projectes emergents amb atenció diària devota", "Perfecciona un petit detall del teu procés de construcció", "Confia que la cura meticulosa crea resultats abundants", "Nodreix els teus primers passos com una mare alimenta el seu fill"]
  }'::jsonb
);

-- 🌍 WAXING CRESCENT + EARTH + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_crescent' AND element = 'earth' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Earth Builds With Harvest Vision",
    "es": "La Tierra de Otoño Construye Con Visión de Cosecha",
    "ca": "La Terra de Tardor Construeix Amb Visió de Collita"
  }'::jsonb,
  '{
    "en": "The waxing crescent''s practical momentum meets autumn''s harvest preparation. As Capricorn mastery (December-January) structures your first efforts, faith becomes strategic building - every step calculates toward abundant reaping.",
    "es": "El impulso práctico de la luna creciente se encuentra con la preparación de cosecha del otoño. Mientras la maestría de Capricornio (diciembre-enero) estructura tus primeros esfuerzos, la fe se convierte en construcción estratégica - cada paso calcula hacia una cosecha abundante.",
    "ca": "L''impuls pràctic de la lluna creixent es troba amb la preparació de collita de la tardor. Mentre la mestria de Capricorn (desembre-gener) estructura els teus primers esforços, la fe es converteix en construcció estratègica - cada pas calcula cap a una collita abundant."
  }'::jsonb,
  '{
    "en": "Earth''s building becomes harvest-focused under autumn''s crone wisdom. First steps are investments in future abundance. Faith transforms into shrewd planning. You build what will feed you.",
    "es": "La construcción de la tierra se enfoca en la cosecha bajo la sabiduría de la anciana del otoño. Los primeros pasos son inversiones en abundancia futura. La fe se transforma en planificación astuta. Construyes lo que te alimentará.",
    "ca": "La construcció de la terra s''enfoca en la collita sota la saviesa de l''anciana de la tardor. Els primers passos són inversions en abundància futura. La fe es transforma en planificació astuta. Construeixes el que t''alimentarà."
  }'::jsonb,
  '{
    "en": ["Capricorn mastery", "Strategic investment", "Harvest planning", "Crone''s shrewd building"],
    "es": ["Maestría de Capricornio", "Inversión estratégica", "Planificación de cosecha", "Construcción astuta de anciana"],
    "ca": ["Mestria de Capricorn", "Inversió estratègica", "Planificació de collita", "Construcció astuta d''anciana"]
  }'::jsonb,
  '{
    "en": ["Take practical steps that ensure future harvest", "Build resources you''ll actually need and use", "Trust wise planning creates lasting abundance", "Invest effort where it yields maximum return"],
    "es": ["Da pasos prácticos que aseguren cosecha futura", "Construye recursos que realmente necesitarás y usarás", "Confía en que la planificación sabia crea abundancia duradera", "Invierte esfuerzo donde rinde máximo retorno"],
    "ca": ["Fes passos pràctics que assegurin collita futura", "Construeix recursos que realment necessitaràs i utilitzaràs", "Confia que la planificació sàvia crea abundància duradora", "Inverteix esforç on rendeix màxim retorn"]
  }'::jsonb
);

-- 🌍 WAXING CRESCENT + EARTH + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_crescent' AND element = 'earth' LIMIT 1),
  'winter',
  '{
    "en": "Winter''s Deep Roots Build Invisible Strength",
    "es": "Las Raíces Profundas del Invierno Construyen Fuerza Invisible",
    "ca": "Les Arrels Profundes de l''Hivern Construeixen Força Invisible"
  }'::jsonb,
  '{
    "en": "The waxing crescent''s building energy meets winter''s underground patience. As Taurus endurance (April-May) grounds your first practical steps, faith becomes root-deep - you build beneath the surface where nothing is visible yet.",
    "es": "La energía constructiva de la luna creciente se encuentra con la paciencia subterránea del invierno. Mientras la resistencia de Tauro (abril-mayo) fundamenta tus primeros pasos prácticos, la fe se vuelve profunda como raíces - construyes bajo la superficie donde nada es visible todavía.",
    "ca": "L''energia constructiva de la lluna creixent es troba amb la paciència subterrània de l''hivern. Mentre la resistència de Taure (abril-maig) fonamenta els teus primers passos pràctics, la fe es torna profunda com arrels - construeixes sota la superfície on res no és visible encara."
  }'::jsonb,
  '{
    "en": "Earth''s practical steps descend into winter''s depths. First efforts are invisible foundations. Faith transforms into geological patience. You build with the slow certainty of tectonic plates.",
    "es": "Los pasos prácticos de la tierra descienden a las profundidades del invierno. Los primeros esfuerzos son cimientos invisibles. La fe se transforma en paciencia geológica. Construyes con la certeza lenta de las placas tectónicas.",
    "ca": "Els passos pràctics de la terra descendeixen a les profunditats de l''hivern. Els primers esforços són fonaments invisibles. La fe es transforma en paciència geològica. Construeixes amb la certesa lenta de les plaques tectòniques."
  }'::jsonb,
  '{
    "en": ["Taurus endurance", "Underground building", "Invisible foundations", "Geological patience"],
    "es": ["Resistencia de Tauro", "Construcción subterránea", "Cimientos invisibles", "Paciencia geológica"],
    "ca": ["Resistència de Taure", "Construcció subterrània", "Fonaments invisibles", "Paciència geològica"]
  }'::jsonb,
  '{
    "en": ["Build foundations even when progress seems invisible", "Trust deep root work will support future blooming", "Take patient practical steps beneath the surface", "Let faith be your strength when nothing shows yet"],
    "es": ["Construye cimientos incluso cuando el progreso parece invisible", "Confía en que el trabajo de raíces profundas apoyará la floración futura", "Da pasos prácticos pacientes bajo la superficie", "Deja que la fe sea tu fuerza cuando nada se muestra todavía"],
    "ca": ["Construeix fonaments fins i tot quan el progrés sembla invisible", "Confia que el treball d''arrels profundes donarà suport a la floració futura", "Fes passos pràctics pacients sota la superfície", "Deixa que la fe sigui la teva força quan res no es mostra encara"]
  }'::jsonb
);

-- =====================================================
-- AIR ELEMENT × 4 SEASONS
-- =====================================================

-- 💨 WAXING CRESCENT + AIR + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_crescent' AND element = 'air' LIMIT 1),
  'spring',
  '{
    "en": "Spring Winds Carry Ideas Into Motion",
    "es": "Los Vientos de Primavera Llevan Ideas al Movimiento",
    "ca": "Els Vents de Primavera Porten Idees al Moviment"
  }'::jsonb,
  '{
    "en": "The waxing crescent''s building curiosity meets spring''s fresh breezes. As Gemini communication (May-June) sparks your first conversations, faith becomes social momentum - your ideas spread like seeds on the wind.",
    "es": "La curiosidad creciente de la luna creciente se encuentra con las brisas frescas de la primavera. Mientras la comunicación de Géminis (mayo-junio) enciende tus primeras conversaciones, la fe se convierte en impulso social - tus ideas se esparcen como semillas en el viento.",
    "ca": "La curiositat creixent de la lluna creixent es troba amb les brises fresques de la primavera. Mentre la comunicació de Bessons (maig-juny) encén les teves primeres converses, la fe es converteix en impuls social - les teves idees s''escampen com llavors al vent."
  }'::jsonb,
  '{
    "en": "Air''s intellectual building is energized by spring''s maiden curiosity. First conversations spark connection cascades. Faith transforms into playful exploration. Ideas pollinate rapidly across fresh minds.",
    "es": "La construcción intelectual del aire se energiza con la curiosidad doncella de la primavera. Las primeras conversaciones desencadenan cascadas de conexión. La fe se transforma en exploración juguetona. Las ideas polinizan rápidamente a través de mentes frescas.",
    "ca": "La construcció intel·lectual de l''aire s''energitza amb la curiositat donzella de la primavera. Les primeres converses desencadenen cascades de connexió. La fe es transforma en exploració joganera. Les idees pol·linitzen ràpidament a través de ments fresques."
  }'::jsonb,
  '{
    "en": ["Gemini curiosity", "Social pollination", "Fresh connection", "Maiden mind-play"],
    "es": ["Curiosidad de Géminis", "Polinización social", "Conexión fresca", "Juego mental de doncella"],
    "ca": ["Curiositat de Bessons", "Pol·linització social", "Connexió fresca", "Joc mental de donzella"]
  }'::jsonb,
  '{
    "en": ["Share your new moon idea with THREE people this week", "Let curiosity guide exploratory conversations", "Trust fresh connections will carry your vision forward", "Play with ideas - spring air loves experimentation"],
    "es": ["Comparte tu idea de luna nueva con TRES personas esta semana", "Deja que la curiosidad guíe conversaciones exploratorias", "Confía en que las conexiones frescas llevarán tu visión adelante", "Juega con ideas - el aire primaveral ama la experimentación"],
    "ca": ["Comparteix la teva idea de lluna nova amb TRES persones aquesta setmana", "Deixa que la curiositat guiï converses exploratòries", "Confia que les connexions fresques portaran la teva visió endavant", "Juga amb idees - l''aire primaveral estima l''experimentació"]
  }'::jsonb
);

-- 💨 WAXING CRESCENT + AIR + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_crescent' AND element = 'air' LIMIT 1),
  'summer',
  '{
    "en": "Summer Breezes Build Harmonious Networks",
    "es": "Las Brisas de Verano Construyen Redes Armoniosas",
    "ca": "Les Brises d''Estiu Construeixen Xarxes Harmonioses"
  }'::jsonb,
  '{
    "en": "The waxing crescent''s growing network meets summer''s social warmth. As Libra connection (September-October) balances your first collaborations, faith becomes partnership - your ideas grow stronger through harmonious exchange.",
    "es": "La red creciente de la luna creciente se encuentra con la calidez social del verano. Mientras la conexión de Libra (septiembre-octubre) equilibra tus primeras colaboraciones, la fe se convierte en asociación - tus ideas crecen más fuertes a través del intercambio armonioso.",
    "ca": "La xarxa creixent de la lluna creixent es troba amb la calidesa social de l''estiu. Mentre la connexió de Balança (setembre-octubre) equilibra les teves primeres col·laboracions, la fe es converteix en associació - les teves idees creixen més fortes a través de l''intercanvi harmoniós."
  }'::jsonb,
  '{
    "en": "Air''s intellectual building becomes collaborative under summer''s mother diplomacy. First partnerships create beautiful synergy. Faith transforms into trust in others. Ideas bloom through balanced exchange.",
    "es": "La construcción intelectual del aire se vuelve colaborativa bajo la diplomacia maternal del verano. Las primeras asociaciones crean hermosa sinergia. La fe se transforma en confianza en otros. Las ideas florecen a través del intercambio equilibrado.",
    "ca": "La construcció intel·lectual de l''aire es torna col·laborativa sota la diplomàcia maternal de l''estiu. Les primeres associacions creen bella sinergia. La fe es transforma en confiança en altres. Les idees floreixen a través de l''intercanvi equilibrat."
  }'::jsonb,
  '{
    "en": ["Libra harmony", "Diplomatic building", "Partnership synergy", "Mother''s collaborative grace"],
    "es": ["Armonía de Libra", "Construcción diplomática", "Sinergia de asociación", "Gracia colaborativa de madre"],
    "ca": ["Harmonia de Balança", "Construcció diplomàtica", "Sinergia d''associació", "Gràcia col·laborativa de mare"]
  }'::jsonb,
  '{
    "en": ["Reach out to potential collaborators with grace", "Build networks through balanced reciprocal exchange", "Trust partnerships strengthen your emerging vision", "Create beauty through harmonious intellectual connection"],
    "es": ["Acércate a posibles colaboradores con gracia", "Construye redes a través del intercambio recíproco equilibrado", "Confía en que las asociaciones fortalecen tu visión emergente", "Crea belleza a través de la conexión intelectual armoniosa"],
    "ca": ["Apropa''t a possibles col·laboradors amb gràcia", "Construeix xarxes a través de l''intercanvi recíproc equilibrat", "Confia que les associacions enforteixen la teva visió emergent", "Crea bellesa a través de la connexió intel·lectual harmoniosa"]
  }'::jsonb
);

-- 💨 WAXING CRESCENT + AIR + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_crescent' AND element = 'air' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Air Builds Revolutionary Networks",
    "es": "El Aire de Otoño Construye Redes Revolucionarias",
    "ca": "L''Aire de Tardor Construeix Xarxes Revolucionàries"
  }'::jsonb,
  '{
    "en": "The waxing crescent''s expanding connections meet autumn''s innovative vision. As Aquarius revolution (January-February) electrifies your first networks, faith becomes collective momentum - your ideas build movements for change.",
    "es": "Las conexiones en expansión de la luna creciente se encuentran con la visión innovadora del otoño. Mientras la revolución de Acuario (enero-febrero) electrifica tus primeras redes, la fe se convierte en impulso colectivo - tus ideas construyen movimientos de cambio.",
    "ca": "Les connexions en expansió de la lluna creixent es troben amb la visió innovadora de la tardor. Mentre la revolució d''Aquari (gener-febrer) electrifica les teves primeres xarxes, la fe es converteix en impuls col·lectiu - les teves idees construeixen moviments de canvi."
  }'::jsonb,
  '{
    "en": "Air''s intellectual building becomes revolutionary under autumn''s crone innovation. First connections spark collective awakening. Faith transforms into vision for humanity. Ideas build networks of the future.",
    "es": "La construcción intelectual del aire se vuelve revolucionaria bajo la innovación anciana del otoño. Las primeras conexiones desencadenan despertar colectivo. La fe se transforma en visión para la humanidad. Las ideas construyen redes del futuro.",
    "ca": "La construcció intel·lectual de l''aire es torna revolucionària sota la innovació anciana de la tardor. Les primeres connexions desencadenen despertar col·lectiu. La fe es transforma en visió per a la humanitat. Les idees construeixen xarxes del futur."
  }'::jsonb,
  '{
    "en": ["Aquarius innovation", "Collective awakening", "Future-focused networks", "Crone''s revolutionary vision"],
    "es": ["Innovación de Acuario", "Despertar colectivo", "Redes enfocadas en el futuro", "Visión revolucionaria de anciana"],
    "ca": ["Innovació d''Aquari", "Despertar col·lectiu", "Xarxes enfocades en el futur", "Visió revolucionària d''anciana"]
  }'::jsonb,
  '{
    "en": ["Connect with visionaries who share your future dreams", "Build networks focused on collective evolution", "Trust your ideas serve humanity''s highest good", "Let innovation guide your first collaborative steps"],
    "es": ["Conéctate con visionarios que comparten tus sueños de futuro", "Construye redes enfocadas en la evolución colectiva", "Confía en que tus ideas sirven al bien más alto de la humanidad", "Deja que la innovación guíe tus primeros pasos colaborativos"],
    "ca": ["Connecta amb visionaris que comparteixen els teus somnis de futur", "Construeix xarxes enfocades en l''evolució col·lectiva", "Confia que les teves idees serveixen el bé més alt de la humanitat", "Deixa que la innovació guiï els teus primers passos col·laboratius"]
  }'::jsonb
);

-- 💨 WAXING CRESCENT + AIR + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_crescent' AND element = 'air' LIMIT 1),
  'winter',
  '{
    "en": "Winter Silence Builds Crystalline Clarity",
    "es": "El Silencio del Invierno Construye Claridad Cristalina",
    "ca": "El Silenci de l''Hivern Construeix Claredat Cristal·lina"
  }'::jsonb,
  '{
    "en": "The waxing crescent''s growing understanding meets winter''s quiet contemplation. As Gemini curiosity (May-June) explores in stillness, faith becomes inner dialogue - your ideas crystallize in the silence before they need to be spoken.",
    "es": "La comprensión creciente de la luna creciente se encuentra con la contemplación silenciosa del invierno. Mientras la curiosidad de Géminis (mayo-junio) explora en quietud, la fe se convierte en diálogo interno - tus ideas se cristalizan en el silencio antes de que necesiten ser habladas.",
    "ca": "La comprensió creixent de la lluna creixent es troba amb la contemplació silenciosa de l''hivern. Mentre la curiositat de Bessons (maig-juny) explora en quietud, la fe es converteix en diàleg intern - les teves idees es cristal·litzen en el silenci abans que necessitin ser parlades."
  }'::jsonb,
  '{
    "en": "Air''s intellectual building becomes contemplative under winter''s elder silence. First thoughts gain diamond-hard clarity. Faith transforms into inner knowing. Ideas sharpen in the stillness.",
    "es": "La construcción intelectual del aire se vuelve contemplativa bajo el silencio anciano del invierno. Los primeros pensamientos ganan claridad dura como diamante. La fe se transforma en conocimiento interno. Las ideas se afinan en la quietud.",
    "ca": "La construcció intel·lectual de l''aire es torna contemplativa sota el silenci ancià de l''hivern. Els primers pensaments guanyen claredat dura com diamant. La fe es transforma en coneixement intern. Les idees s''afinen en la quietud."
  }'::jsonb,
  '{
    "en": ["Gemini contemplation", "Inner clarity", "Silent crystallization", "Elder wisdom thinking"],
    "es": ["Contemplación de Géminis", "Claridad interna", "Cristalización silenciosa", "Pensamiento de sabiduría anciana"],
    "ca": ["Contemplació de Bessons", "Claredat interna", "Cristal·lització silenciosa", "Pensament de saviesa anciana"]
  }'::jsonb,
  '{
    "en": ["Journal your thoughts in complete silence", "Build clarity through contemplative thinking", "Trust inner dialogue before outer conversation", "Let ideas crystallize in winter''s still, clear air"],
    "es": ["Escribe tus pensamientos en completo silencio", "Construye claridad a través del pensamiento contemplativo", "Confía en el diálogo interno antes de la conversación externa", "Deja que las ideas se cristalicen en el aire quieto y claro del invierno"],
    "ca": ["Escriu els teus pensaments en complet silenci", "Construeix claredat a través del pensament contemplatiu", "Confia en el diàleg intern abans de la conversa externa", "Deixa que les idees es cristal·litzin en l''aire quiet i clar de l''hivern"]
  }'::jsonb
);

-- =====================================================
-- WATER ELEMENT × 4 SEASONS
-- =====================================================

-- 💧 WAXING CRESCENT + WATER + SPRING
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_crescent' AND element = 'water' LIMIT 1),
  'spring',
  '{
    "en": "Spring Waters Flow With Emotional Courage",
    "es": "Las Aguas de Primavera Fluyen Con Coraje Emocional",
    "ca": "Les Aigües de Primavera Flueixen Amb Coratge Emocional"
  }'::jsonb,
  '{
    "en": "The waxing crescent''s building trust meets spring''s emotional breakthrough. As Cancer courage (June-July) nurtures your first vulnerable steps, faith becomes emotional honesty - you let feelings flow freely toward new connection.",
    "es": "La confianza creciente de la luna creciente se encuentra con el avance emocional de la primavera. Mientras el coraje de Cáncer (junio-julio) nutre tus primeros pasos vulnerables, la fe se convierte en honestidad emocional - dejas que los sentimientos fluyan libremente hacia nueva conexión.",
    "ca": "La confiança creixent de la lluna creixent es troba amb l''avenç emocional de la primavera. Mentre el coratge de Cranc (juny-juliol) nodreix els teus primers passos vulnerables, la fe es converteix en honestedat emocional - deixes que els sentiments flueixin lliurement cap a nova connexió."
  }'::jsonb,
  '{
    "en": "Water''s emotional building is energized by spring''s maiden boldness. First vulnerable shares create rapid intimacy. Faith transforms into emotional bravery. Feelings bloom openly without fear.",
    "es": "La construcción emocional del agua se energiza con la audacia doncella de la primavera. Los primeros compartires vulnerables crean intimidad rápida. La fe se transforma en valentía emocional. Los sentimientos florecen abiertamente sin miedo.",
    "ca": "La construcció emocional de l''aigua s''energitza amb l''audàcia donzella de la primavera. Els primers compartirs vulnerables creen intimitat ràpida. La fe es transforma en valentia emocional. Els sentiments floreixen obertament sense por."
  }'::jsonb,
  '{
    "en": ["Cancer courage", "Vulnerable sharing", "Emotional breakthrough", "Maiden heart-opening"],
    "es": ["Coraje de Cáncer", "Compartir vulnerable", "Avance emocional", "Apertura de corazón de doncella"],
    "ca": ["Coratge de Cranc", "Compartir vulnerable", "Avenç emocional", "Obertura de cor de donzella"]
  }'::jsonb,
  '{
    "en": ["Share one vulnerable feeling with someone you trust", "Take brave emotional steps toward deeper connection", "Trust your heart''s courage to bloom openly", "Let spring waters wash away emotional fear"],
    "es": ["Comparte un sentimiento vulnerable con alguien en quien confías", "Da pasos emocionales valientes hacia conexión más profunda", "Confía en el coraje de tu corazón para florecer abiertamente", "Deja que las aguas primaverales laven el miedo emocional"],
    "ca": ["Comparteix un sentiment vulnerable amb algú en qui confies", "Fes passos emocionals valents cap a connexió més profunda", "Confia en el coratge del teu cor per florir obertament", "Deixa que les aigües primeraverals rentallin la por emocional"]
  }'::jsonb
);

-- 💧 WAXING CRESCENT + WATER + SUMMER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_crescent' AND element = 'water' LIMIT 1),
  'summer',
  '{
    "en": "Summer Tides Build Passionate Connection",
    "es": "Las Mareas de Verano Construyen Conexión Apasionada",
    "ca": "Les Marees d''Estiu Construeixen Connexió Apassionada"
  }'::jsonb,
  '{
    "en": "The waxing crescent''s deepening trust meets summer''s emotional intensity. As Scorpio passion (October-November) transforms your first intimate bonds, faith becomes sacred vulnerability - you merge hearts with transformative power.",
    "es": "La confianza profundizante de la luna creciente se encuentra con la intensidad emocional del verano. Mientras la pasión de Escorpio (octubre-noviembre) transforma tus primeros vínculos íntimos, la fe se convierte en vulnerabilidad sagrada - fusionas corazones con poder transformativo.",
    "ca": "La confiança aprofundidora de la lluna creixent es troba amb la intensitat emocional de l''estiu. Mentre la passió d''Escorpí (octubre-novembre) transforma els teus primers vincles íntims, la fe es converteix en vulnerabilitat sagrada - fusiones cors amb poder transformatiu."
  }'::jsonb,
  '{
    "en": "Water''s emotional building becomes transformative under summer''s mother intensity. First intimacies create soul bonds. Faith transforms into sacred merging. Feelings deepen into alchemical union.",
    "es": "La construcción emocional del agua se vuelve transformativa bajo la intensidad maternal del verano. Las primeras intimidades crean vínculos de alma. La fe se transforma en fusión sagrada. Los sentimientos se profundizan en unión alquímica.",
    "ca": "La construcció emocional de l''aigua es torna transformativa sota la intensitat maternal de l''estiu. Les primeres intimitats creen vincles d''ànima. La fe es transforma en fusió sagrada. Els sentiments s''aprofundeixen en unió alquímica."
  }'::jsonb,
  '{
    "en": ["Scorpio intensity", "Sacred vulnerability", "Soul-deep bonding", "Mother''s transformative love"],
    "es": ["Intensidad de Escorpio", "Vulnerabilidad sagrada", "Vinculación profunda del alma", "Amor transformativo de madre"],
    "ca": ["Intensitat d''Escorpí", "Vulnerabilitat sagrada", "Vinculació profunda de l''ànima", "Amor transformatiu de mare"]
  }'::jsonb,
  '{
    "en": ["Deepen one relationship through passionate honesty", "Build emotional intimacy with transformative truth", "Trust vulnerability creates sacred soul bonds", "Let feelings merge and alchemize into something new"],
    "es": ["Profundiza una relación a través de la honestidad apasionada", "Construye intimidad emocional con verdad transformativa", "Confía en que la vulnerabilidad crea vínculos de alma sagrados", "Deja que los sentimientos se fusionen y alquimicen en algo nuevo"],
    "ca": ["Aprofundeix una relació a través de l''honestedat apassionada", "Construeix intimitat emocional amb veritat transformativa", "Confia que la vulnerabilitat crea vincles d''ànima sagrats", "Deixa que els sentiments es fusionin i alquimitzin en alguna cosa nova"]
  }'::jsonb
);

-- 💧 WAXING CRESCENT + WATER + AUTUMN
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_crescent' AND element = 'water' LIMIT 1),
  'autumn',
  '{
    "en": "Autumn Waters Build With Compassionate Wisdom",
    "es": "Las Aguas de Otoño Construyen Con Sabiduría Compasiva",
    "ca": "Les Aigües de Tardor Construeixen Amb Saviesa Compassiva"
  }'::jsonb,
  '{
    "en": "The waxing crescent''s growing empathy meets autumn''s emotional wisdom. As Pisces compassion (February-March) guides your first heart-connections, faith becomes universal love - you build bonds that transcend boundaries.",
    "es": "La empatía creciente de la luna creciente se encuentra con la sabiduría emocional del otoño. Mientras la compasión de Piscis (febrero-marzo) guía tus primeras conexiones de corazón, la fe se convierte en amor universal - construyes vínculos que trascienden límites.",
    "ca": "L''empatia creixent de la lluna creixent es troba amb la saviesa emocional de la tardor. Mentre la compassió de Peixos (febrer-març) guia les teves primeres connexions de cor, la fe es converteix en amor universal - construeixes vincles que transcendeixen límits."
  }'::jsonb,
  '{
    "en": "Water''s emotional building becomes boundaryless under autumn''s crone compassion. First connections dissolve separation. Faith transforms into mystical unity. All hearts are recognized as one ocean.",
    "es": "La construcción emocional del agua se vuelve sin límites bajo la compasión anciana del otoño. Las primeras conexiones disuelven la separación. La fe se transforma en unidad mística. Todos los corazones se reconocen como un océano.",
    "ca": "La construcció emocional de l''aigua es torna sense límits sota la compassió anciana de la tardor. Les primeres connexions dissolen la separació. La fe es transforma en unitat mística. Tots els cors es reconeixen com un oceà."
  }'::jsonb,
  '{
    "en": ["Pisces compassion", "Boundaryless empathy", "Universal heart-connection", "Crone''s mystical love"],
    "es": ["Compasión de Piscis", "Empatía sin límites", "Conexión de corazón universal", "Amor místico de anciana"],
    "ca": ["Compassió de Peixos", "Empatia sense límits", "Connexió de cor universal", "Amor místic d''anciana"]
  }'::jsonb,
  '{
    "en": ["Extend compassion to someone unexpected", "Build connections that transcend differences", "Trust in the unity of all feeling beings", "Let empathy dissolve boundaries between hearts"],
    "es": ["Extiende compasión a alguien inesperado", "Construye conexiones que trascienden diferencias", "Confía en la unidad de todos los seres sintientes", "Deja que la empatía disuelva límites entre corazones"],
    "ca": ["Estén compassió a algú inesperat", "Construeix connexions que transcendeixen diferències", "Confia en la unitat de tots els éssers sentients", "Deixa que l''empatia dissolgui límits entre cors"]
  }'::jsonb
);

-- 💧 WAXING CRESCENT + WATER + WINTER
INSERT INTO seasonal_overlays (
  template_id, season,
  overlay_headline, overlay_description, energy_shift,
  themes, seasonal_actions
) VALUES (
  (SELECT id FROM lunar_guide_templates WHERE phase_id = 'waxing_crescent' AND element = 'water' LIMIT 1),
  'winter',
  '{
    "en": "Winter''s Deep Waters Build Sacred Trust",
    "es": "Las Aguas Profundas del Invierno Construyen Confianza Sagrada",
    "ca": "Les Aigües Profundes de l''Hivern Construeixen Confiança Sagrada"
  }'::jsonb,
  '{
    "en": "The waxing crescent''s building faith meets winter''s emotional depths. As Cancer protection (June-July) nurtures your first safe bonds, faith becomes sanctuary - you build trust slowly, in the sacred darkness where true intimacy grows.",
    "es": "La fe creciente de la luna creciente se encuentra con las profundidades emocionales del invierno. Mientras la protección de Cáncer (junio-julio) nutre tus primeros vínculos seguros, la fe se convierte en santuario - construyes confianza lentamente, en la oscuridad sagrada donde crece la verdadera intimidad.",
    "ca": "La fe creixent de la lluna creixent es troba amb les profunditats emocionals de l''hivern. Mentre la protecció de Cranc (juny-juliol) nodreix els teus primers vincles segurs, la fe es converteix en santuari - construeixes confiança lentament, a la foscor sagrada on creix la veritable intimitat."
  }'::jsonb,
  '{
    "en": "Water''s emotional building becomes sheltered under winter''s elder protection. First trust-bonds are sacred containers. Faith transforms into patient intimacy. Deep feelings grow in protected darkness.",
    "es": "La construcción emocional del agua se vuelve protegida bajo la protección anciana del invierno. Los primeros vínculos de confianza son contenedores sagrados. La fe se transforma en intimidad paciente. Los sentimientos profundos crecen en oscuridad protegida.",
    "ca": "La construcció emocional de l''aigua es torna protegida sota la protecció anciana de l''hivern. Els primers vincles de confiança són contenidors sagrats. La fe es transforma en intimitat pacient. Els sentiments profunds creixen en foscor protegida."
  }'::jsonb,
  '{
    "en": ["Cancer sanctuary", "Protected intimacy", "Sacred trust-building", "Elder''s patient devotion"],
    "es": ["Santuario de Cáncer", "Intimidad protegida", "Construcción de confianza sagrada", "Devoción paciente de anciana"],
    "ca": ["Santuari de Cranc", "Intimitat protegida", "Construcció de confiança sagrada", "Devoció pacient d''anciana"]
  }'::jsonb,
  '{
    "en": ["Build one safe emotional container with someone you trust", "Take slow patient steps toward deeper intimacy", "Trust that sacred bonds grow in protected darkness", "Create sanctuary where vulnerable feelings are cherished"],
    "es": ["Construye un contenedor emocional seguro con alguien en quien confías", "Da pasos lentos y pacientes hacia intimidad más profunda", "Confía en que los vínculos sagrados crecen en oscuridad protegida", "Crea santuario donde los sentimientos vulnerables son apreciados"],
    "ca": ["Construeix un contenidor emocional segur amb algú en qui confies", "Fes passos lents i pacients cap a intimitat més profunda", "Confia que els vincles sagrats creixen en foscor protegida", "Crea santuari on els sentiments vulnerables són apreciats"]
  }'::jsonb
);

-- =====================================================
-- COMPLETION COMMENT
-- =====================================================
-- ✅ WAXING CRESCENT SEASONAL OVERLAYS COMPLETE (16/16)
-- Next file: 20251116000009_seed_seasonal_first_quarter.sql
