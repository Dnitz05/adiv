-- Drop existing table if it has wrong schema
DROP TABLE IF EXISTS public.lunar_guide_templates CASCADE;

-- Create with correct schema (TEXT id instead of UUID)
CREATE TABLE public.lunar_guide_templates (
  id TEXT PRIMARY KEY,
  phase_id phase_type NOT NULL,
  element element_type NULL,
  zodiac_sign zodiac_sign_type NULL,
  headline JSONB NOT NULL,
  tagline JSONB NULL,
  focus_areas JSONB NOT NULL,
  energy_description JSONB NOT NULL,
  recommended_actions JSONB NOT NULL,
  journal_prompts JSONB NULL,
  priority INTEGER NOT NULL DEFAULT 0,
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_lunar_guide_templates_phase ON lunar_guide_templates(phase_id, active);
CREATE INDEX idx_lunar_guide_templates_lookup ON lunar_guide_templates(phase_id, element, zodiac_sign, active);

ALTER TABLE lunar_guide_templates ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Lunar guide templates are viewable by everyone"
  ON lunar_guide_templates FOR SELECT
  USING (active = true);

CREATE TRIGGER update_lunar_guide_templates_updated_at
  BEFORE UPDATE ON lunar_guide_templates
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Now insert the data
INSERT INTO lunar_guide_templates (id, phase_id, element, zodiac_sign, headline, tagline, focus_areas, energy_description, recommended_actions, journal_prompts, priority, active)
VALUES
('new_moon_generic', 'new_moon', NULL, NULL,
  '{"en": "New Beginnings Await", "es": "Nuevos Comienzos Esperan", "ca": "Nous Inicis T''Esperen"}',
  '{"en": "Plant seeds for the cycle ahead", "es": "Planta semillas para el ciclo que viene", "ca": "Planta llavors pel cicle que ve"}',
  '{"en": ["Intentions", "Fresh starts", "Visioning"], "es": ["Intenciones", "Comienzos frescos", "Visualización"], "ca": ["Intencions", "Inicis frescos", "Visualització"]}',
  '{"en": "The New Moon offers a blank slate. Darkness holds potential for what wants to emerge. This is the optimal time for setting intentions and planting seeds for manifestation.", "es": "La Luna Nueva ofrece una pizarra en blanco. La oscuridad contiene potencial para lo que quiere emerger. Este es el momento óptimo para establecer intenciones y plantar semillas para la manifestación.", "ca": "La Lluna Nova ofereix una pissarra en blanc. La foscor conté potencial per allò que vol emergir. Aquest és el moment òptim per establir intencions i plantar llavors per la manifestació."}',
  '{"en": ["Set clear intentions for the month ahead", "Journal about what you want to create", "Light a candle to honor new beginnings"], "es": ["Establece intenciones claras para el mes que viene", "Escribe sobre lo que quieres crear", "Enciende una vela para honrar nuevos comienzos"], "ca": ["Estableix intencions clares pel mes que ve", "Escriu sobre el que vols crear", "Encén una espelma per honrar nous inicis"]}',
  '{"en": ["What do I want to call into my life?", "What seeds am I planting this lunar cycle?", "What energy do I want to cultivate?"], "es": ["¿Qué quiero llamar a mi vida?", "¿Qué semillas estoy plantando este ciclo lunar?", "¿Qué energía quiero cultivar?"], "ca": ["Què vull cridar a la meva vida?", "Quines llavors estic plantant aquest cicle lunar?", "Quina energia vull cultivar?"]}',
  0, true),

('waxing_crescent_generic', 'waxing_crescent', NULL, NULL,
  '{"en": "First Signs of Growth", "es": "Primeras Señales de Crecimiento", "ca": "Primers Signes de Creixement"}',
  '{"en": "Nurture what is emerging", "es": "Nutre lo que está emergiendo", "ca": "Nodreix allò que emergeix"}',
  '{"en": ["Early action", "Cultivation", "Commitment"], "es": ["Acción temprana", "Cultivo", "Compromiso"], "ca": ["Acció primerenca", "Cultiu", "Compromís"]}',
  '{"en": "The crescent moon appears as intentions take their first form. This is when you begin actively working with what you planted at the New Moon. Small steps matter most.", "es": "La luna creciente aparece cuando las intenciones toman su primera forma. Aquí comienzas a trabajar activamente con lo que plantaste en la Luna Nueva. Los pequeños pasos importan más.", "ca": "La lluna creixent apareix quan les intencions prenen la seva primera forma. Aquí comences a treballar activament amb el que vas plantar a la Lluna Nova. Els petits passos importen més."}',
  '{"en": ["Take the first steps toward your intentions", "Create an action plan", "Notice what wants support"], "es": ["Da los primeros pasos hacia tus intenciones", "Crea un plan de acción", "Observa qué quiere apoyo"], "ca": ["Fes els primers passos cap a les teves intencions", "Crea un pla d''acció", "Observa què vol suport"]}',
  '{"en": ["What action can I take today?", "Where do I need to stay committed?", "What requires my attention now?"], "es": ["¿Qué acción puedo tomar hoy?", "¿Dónde necesito mantenerme comprometido?", "¿Qué requiere mi atención ahora?"], "ca": ["Quina acció puc fer avui?", "On necessito mantenir-me compromès?", "Què requereix la meva atenció ara?"]}',
  0, true),

('first_quarter_generic', 'first_quarter', NULL, NULL,
  '{"en": "Decision Point", "es": "Punto de Decisión", "ca": "Punt de Decisió"}',
  '{"en": "Choose your path forward", "es": "Elige tu camino hacia adelante", "ca": "Tria el teu camí endavant"}',
  '{"en": ["Decisions", "Adjustments", "Overcoming obstacles"], "es": ["Decisiones", "Ajustes", "Superar obstáculos"], "ca": ["Decisions", "Ajustos", "Superar obstacles"]}',
  '{"en": "The First Quarter Moon presents a crucial choice point. Challenges arise to test commitment. This is when you must actively choose your direction and push through resistance.", "es": "La Luna del Primer Cuarto presenta un punto de elección crucial. Surgen desafíos para probar el compromiso. Aquí debes elegir activamente tu dirección y superar la resistencia.", "ca": "La Lluna del Primer Quart presenta un punt d''elecció crucial. Sorgeixen desafiaments per provar el compromís. Aquí has de triar activament la teva direcció i superar la resistència."}',
  '{"en": ["Make necessary decisions", "Address challenges directly", "Adjust your approach if needed"], "es": ["Toma decisiones necesarias", "Enfrenta los desafíos directamente", "Ajusta tu enfoque si es necesario"], "ca": ["Pren decisions necessàries", "Enfronta els desafiaments directament", "Ajusta el teu enfocament si cal"]}',
  '{"en": ["What obstacles am I facing?", "What decisions must I make?", "Where do I need to push through?"], "es": ["¿Qué obstáculos estoy enfrentando?", "¿Qué decisiones debo tomar?", "¿Dónde necesito empujar?"], "ca": ["Quins obstacles estic afrontant?", "Quines decisions he de prendre?", "On necessito empènyer?"]}',
  0, true),

('waxing_gibbous_generic', 'waxing_gibbous', NULL, NULL,
  '{"en": "Refinement Phase", "es": "Fase de Refinamiento", "ca": "Fase de Refinament"}',
  '{"en": "Perfect what you''re building", "es": "Perfecciona lo que estás construyendo", "ca": "Perfecciona el que estàs construint"}',
  '{"en": ["Refinement", "Preparation", "Patience"], "es": ["Refinamiento", "Preparación", "Paciencia"], "ca": ["Refinament", "Preparació", "Paciència"]}',
  '{"en": "The Waxing Gibbous Moon calls for refinement and adjustment. What you''ve been building is almost ready. Focus on details, make final preparations, and trust the process.", "es": "La Luna Gibosa Creciente pide refinamiento y ajuste. Lo que has estado construyendo casi está listo. Enfócate en los detalles, haz preparaciones finales y confía en el proceso.", "ca": "La Lluna Gibosa Creixent demana refinament i ajust. El que has estat construint gairebé està a punt. Enfoca''t en els detalls, fes preparacions finals i confia en el procés."}',
  '{"en": ["Fine-tune your approach", "Prepare for completion", "Stay patient with the process"], "es": ["Afina tu enfoque", "Prepárate para la finalización", "Mantén paciencia con el proceso"], "ca": ["Afina el teu enfocament", "Prepara''t per a la finalització", "Mantén paciència amb el procés"]}',
  '{"en": ["What needs refinement?", "How can I prepare for harvest?", "Where do I need patience?"], "es": ["¿Qué necesita refinamiento?", "¿Cómo puedo prepararme para la cosecha?", "¿Dónde necesito paciencia?"], "ca": ["Què necessita refinament?", "Com puc preparar-me per a la collita?", "On necessito paciència?"]}',
  0, true),

('full_moon_generic', 'full_moon', NULL, NULL,
  '{"en": "Peak Illumination", "es": "Iluminación Máxima", "ca": "Il·luminació Màxima"}',
  '{"en": "Celebrate and release", "es": "Celebra y suelta", "ca": "Celebra i allibera"}',
  '{"en": ["Culmination", "Gratitude", "Release"], "es": ["Culminación", "Gratitud", "Soltar"], "ca": ["Culminació", "Gratitud", "Alliberar"]}',
  '{"en": "The Full Moon brings full illumination and completion. What you planted at the New Moon reaches fruition. This is time for celebration, gratitude, and releasing what no longer serves.", "es": "La Luna Llena trae iluminación completa y finalización. Lo que plantaste en la Luna Nueva alcanza su fruto. Es tiempo de celebración, gratitud y soltar lo que ya no sirve.", "ca": "La Lluna Plena porta il·luminació completa i finalització. El que vas plantar a la Lluna Nova arriba al seu fruit. És temps de celebració, gratitud i alliberar allò que ja no serveix."}',
  '{"en": ["Celebrate your achievements", "Express gratitude", "Release what''s complete"], "es": ["Celebra tus logros", "Expresa gratitud", "Suelta lo que está completo"], "ca": ["Celebra els teus assoliments", "Expressa gratitud", "Allibera el que està complet"]}',
  '{"en": ["What am I grateful for?", "What has come to fruition?", "What is ready to be released?"], "es": ["¿Por qué estoy agradecido?", "¿Qué ha dado frutos?", "¿Qué está listo para ser soltado?"], "ca": ["Per què estic agraït?", "Què ha donat fruits?", "Què està llest per ser alliberat?"]}',
  0, true),

('waning_gibbous_generic', 'waning_gibbous', NULL, NULL,
  '{"en": "Sharing Wisdom", "es": "Compartir Sabiduría", "ca": "Compartir Saviesa"}',
  '{"en": "Integrate and share what you''ve learned", "es": "Integra y comparte lo que has aprendido", "ca": "Integra i comparteix el que has après"}',
  '{"en": ["Integration", "Sharing", "Teaching"], "es": ["Integración", "Compartir", "Enseñar"], "ca": ["Integració", "Compartir", "Ensenyar"]}',
  '{"en": "The Waning Gibbous Moon invites reflection and sharing. Having reached the peak, you now integrate lessons and share wisdom. What you''ve learned can benefit others.", "es": "La Luna Gibosa Menguante invita a la reflexión y compartir. Habiendo alcanzado el pico, ahora integras lecciones y compartes sabiduría. Lo que has aprendido puede beneficiar a otros.", "ca": "La Lluna Gibosa Minvant convida a la reflexió i compartir. Havent assolit el pic, ara integres lliçons i compareixes saviesa. El que has après pot beneficiar altres."}',
  '{"en": ["Reflect on lessons learned", "Share your knowledge", "Give thanks and give back"], "es": ["Reflexiona sobre las lecciones aprendidas", "Comparte tu conocimiento", "Da gracias y devuelve"], "ca": ["Reflexiona sobre les lliçons apreses", "Comparteix el teu coneixement", "Dóna gràcies i retorna"]}',
  '{"en": ["What have I learned?", "What wisdom can I share?", "How can I help others?"], "es": ["¿Qué he aprendido?", "¿Qué sabiduría puedo compartir?", "¿Cómo puedo ayudar a otros?"], "ca": ["Què he après?", "Quina saviesa puc compartir?", "Com puc ajudar altres?"]}',
  0, true),

('last_quarter_generic', 'last_quarter', NULL, NULL,
  '{"en": "Letting Go", "es": "Dejar Ir", "ca": "Deixar Anar"}',
  '{"en": "Release and forgive", "es": "Suelta y perdona", "ca": "Allibera i perdona"}',
  '{"en": ["Release", "Forgiveness", "Clearing"], "es": ["Soltar", "Perdón", "Limpiar"], "ca": ["Alliberar", "Perdó", "Netejar"]}',
  '{"en": "The Last Quarter Moon supports deep release. This is a powerful time for letting go of what weighs you down - old patterns, grudges, and attachments. Forgiveness heals.", "es": "La Luna del Último Cuarto apoya la liberación profunda. Este es un tiempo poderoso para soltar lo que te pesa - patrones viejos, rencores y apegos. El perdón sana.", "ca": "La Lluna de l''Últim Quart recolza l''alliberament profund. Aquest és un temps poderós per deixar anar el que et pesa - patrons vells, rancors i apegaments. El perdó sana."}',
  '{"en": ["Release old patterns", "Practice forgiveness", "Clear physical and emotional space"], "es": ["Suelta patrones viejos", "Practica el perdón", "Limpia espacio físico y emocional"], "ca": ["Allibera patrons vells", "Practica el perdó", "Neteja espai físic i emocional"]}',
  '{"en": ["What am I ready to release?", "Who or what needs my forgiveness?", "What patterns no longer serve me?"], "es": ["¿Qué estoy listo para soltar?", "¿Quién o qué necesita mi perdón?", "¿Qué patrones ya no me sirven?"], "ca": ["Què estic preparat per alliberar?", "Qui o què necessita el meu perdó?", "Quins patrons ja no em serveixen?"]}',
  0, true),

('waning_crescent_generic', 'waning_crescent', NULL, NULL,
  '{"en": "Sacred Rest", "es": "Descanso Sagrado", "ca": "Descans Sagrat"}',
  '{"en": "Retreat inward for renewal", "es": "Retírate hacia dentro para renovación", "ca": "Retira''t cap a dins per renovació"}',
  '{"en": ["Rest", "Reflection", "Renewal"], "es": ["Descanso", "Reflexión", "Renovación"], "ca": ["Descans", "Reflexió", "Renovació"]}',
  '{"en": "The Waning Crescent Moon marks a time of sacred rest before the next New Moon. Honor the need for retreat, introspection, and gentle renewal. The darkness prepares the way for new light.", "es": "La Luna Menguante marca un tiempo de descanso sagrado antes de la próxima Luna Nueva. Honra la necesidad de retiro, introspección y renovación suave. La oscuridad prepara el camino para nueva luz.", "ca": "La Lluna Minvant marca un temps de descans sagrat abans de la propera Lluna Nova. Honora la necessitat de retir, introspecció i renovació suau. La foscor prepara el camí per a nova llum."}',
  '{"en": ["Rest and restore", "Practice gentle reflection", "Prepare for the next cycle"], "es": ["Descansa y restaura", "Practica reflexión suave", "Prepárate para el próximo ciclo"], "ca": ["Descansa i restaura", "Practica reflexió suau", "Prepara''t pel proper cicle"]}',
  '{"en": ["What do I need to rest?", "What am I ready to complete?", "How can I prepare for renewal?"], "es": ["¿Qué necesito descansar?", "¿Qué estoy listo para completar?", "¿Cómo puedo prepararme para la renovación?"], "ca": ["Què necessito descansar?", "Què estic llest per completar?", "Com puc preparar-me per a la renovació?"]}',
  0, true);

-- Verify
SELECT phase_id, element, zodiac_sign, priority, active FROM lunar_guide_templates ORDER BY phase_id;
