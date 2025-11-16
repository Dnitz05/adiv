-- Complete setup script for lunar tables
-- Run this entire script in Supabase SQL Editor

-- Step 1: Clean slate - drop existing tables if they exist
DROP TABLE IF EXISTS public.lunar_guide_templates CASCADE;
DROP TABLE IF EXISTS public.daily_lunar_insights CASCADE;

-- Step 2: Create lunar_guide_templates table
CREATE TABLE public.lunar_guide_templates (
  id TEXT PRIMARY KEY,
  phase_id TEXT NOT NULL,
  element TEXT NULL,
  zodiac_sign TEXT NULL,
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

-- Step 3: Create daily_lunar_insights table
CREATE TABLE public.daily_lunar_insights (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  date TEXT NOT NULL UNIQUE,
  template_id TEXT NULL,
  phase_id TEXT NOT NULL,
  zodiac_sign TEXT NOT NULL,
  element TEXT NOT NULL,
  composed_headline JSONB NULL,
  composed_tagline JSONB NULL,
  composed_energy_description JSONB NULL,
  composed_focus_areas JSONB NULL,
  special_event_ids TEXT[] DEFAULT ARRAY[]::TEXT[],
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Step 4: Create update triggers
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_lunar_guide_templates_updated_at
    BEFORE UPDATE ON lunar_guide_templates
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_daily_lunar_insights_updated_at
    BEFORE UPDATE ON daily_lunar_insights
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Step 5: Disable RLS completely
ALTER TABLE public.lunar_guide_templates DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_lunar_insights DISABLE ROW LEVEL SECURITY;

-- Step 6: Grant all necessary permissions
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT SELECT ON public.lunar_guide_templates TO anon, authenticated;
GRANT SELECT ON public.daily_lunar_insights TO anon, authenticated;

-- Step 7: Insert 8 base templates
INSERT INTO public.lunar_guide_templates (id, phase_id, element, zodiac_sign, headline, tagline, focus_areas, energy_description, recommended_actions, journal_prompts, priority, active)
VALUES
  -- New Moon (Generic)
  ('new_moon_generic', 'new_moon', NULL, NULL,
   '{"en": "New Beginnings", "es": "Nuevos Comienzos", "ca": "Nous Començaments"}',
   '{"en": "Plant seeds of intention", "es": "Planta semillas de intención", "ca": "Planta llavors d''intenció"}',
   '["intention_setting", "planning", "dreaming"]',
   '{"en": "The New Moon marks a fresh start. The sky is dark, creating space for new possibilities. This is the perfect time to set intentions and plant seeds for what you wish to grow.", "es": "La Luna Nueva marca un nuevo comienzo. El cielo está oscuro, creando espacio para nuevas posibilidades. Es el momento perfecto para establecer intenciones y plantar semillas de lo que deseas cultivar.", "ca": "La Lluna Nova marca un nou començament. El cel està fosc, creant espai per a noves possibilitats. És el moment perfecte per establir intencions i plantar llavors del que vols cultivar."}',
   '["Set clear intentions for this lunar cycle", "Write down your goals and dreams", "Create a vision board", "Meditate on new possibilities", "Start a new project or habit"]',
   '["What do I want to create in this lunar cycle?", "What seeds am I planting for my future?", "What would I do if I knew I couldn''t fail?"]',
   0, true),

  -- Waxing Crescent (Generic)
  ('waxing_crescent_generic', 'waxing_crescent', NULL, NULL,
   '{"en": "Taking Action", "es": "Tomar Acción", "ca": "Prendre Acció"}',
   '{"en": "Build momentum toward your goals", "es": "Construye impulso hacia tus metas", "ca": "Construeix impuls cap als teus objectius"}',
   '["action", "momentum", "initiative"]',
   '{"en": "As the Moon begins to grow, so does your ability to take action. This phase is about building momentum and taking the first concrete steps toward your intentions.", "es": "A medida que la Luna comienza a crecer, también lo hace tu capacidad de actuar. Esta fase se trata de construir impulso y dar los primeros pasos concretos hacia tus intenciones.", "ca": "A mesura que la Lluna comença a créixer, també ho fa la teva capacitat d''actuar. Aquesta fase tracta de construir impuls i fer els primers passos concrets cap a les teves intencions."}',
   '["Take one concrete action toward your goals", "Build supportive habits and routines", "Gather resources you''ll need", "Reach out to allies and collaborators", "Stay flexible and adjust your plans as needed"]',
   '["What action can I take today to move forward?", "What habits will support my intentions?", "Who can help me on this journey?"]',
   0, true),

  -- First Quarter (Generic)
  ('first_quarter_generic', 'first_quarter', NULL, NULL,
   '{"en": "Overcoming Challenges", "es": "Superar Desafíos", "ca": "Superar Reptes"}',
   '{"en": "Push through obstacles with determination", "es": "Supera obstáculos con determinación", "ca": "Supera obstacles amb determinació"}',
   '["perseverance", "problem_solving", "strength"]',
   '{"en": "The First Quarter Moon is a time of decision and commitment. You may face obstacles or resistance, but this is a test of your dedication. Push through with courage.", "es": "La Luna del Primer Cuarto es un momento de decisión y compromiso. Puedes enfrentar obstáculos o resistencia, pero esta es una prueba de tu dedicación. Supéralo con coraje.", "ca": "La Lluna del Primer Quart és un moment de decisió i compromís. Pots enfrontar obstacles o resistència, però aquesta és una prova de la teva dedicació. Supera-ho amb coratge."}',
   '["Face challenges head-on with confidence", "Make necessary decisions and commitments", "Adjust your strategy if needed", "Ask for help when you need it", "Celebrate small victories along the way"]',
   '["What obstacles am I facing, and how can I overcome them?", "What do I need to commit to right now?", "How can I stay motivated when things get tough?"]',
   0, true),

  -- Waxing Gibbous (Generic)
  ('waxing_gibbous_generic', 'waxing_gibbous', NULL, NULL,
   '{"en": "Refinement & Adjustment", "es": "Refinamiento y Ajuste", "ca": "Refinament i Ajust"}',
   '{"en": "Perfect your approach and fine-tune details", "es": "Perfecciona tu enfoque y ajusta detalles", "ca": "Perfecciona el teu enfocament i ajusta detalls"}',
   '["refinement", "preparation", "patience"]',
   '{"en": "As the Moon grows nearly full, it''s time to refine and perfect. Review your progress, make adjustments, and prepare for the culmination that''s coming.", "es": "A medida que la Luna casi se llena, es hora de refinar y perfeccionar. Revisa tu progreso, haz ajustes y prepárate para la culminación que se acerca.", "ca": "A mesura que la Lluna gairebé es plena, és hora de refinar i perfeccionar. Revisa el teu progrés, fes ajustos i prepara''t per a la culminació que s''acosta."}',
   '["Review your progress and adjust course", "Perfect the details of your project", "Practice patience as things come together", "Trust the process and timing", "Prepare for the manifestation ahead"]',
   '["What needs fine-tuning before I reach my goal?", "Am I being patient with the process?", "What final preparations do I need to make?"]',
   0, true),

  -- Full Moon (Generic)
  ('full_moon_generic', 'full_moon', NULL, NULL,
   '{"en": "Illumination & Release", "es": "Iluminación y Liberación", "ca": "Il·luminació i Alliberament"}',
   '{"en": "Celebrate achievements and release what no longer serves", "es": "Celebra logros y libera lo que ya no sirve", "ca": "Celebra èxits i allibera el que ja no serveix"}',
   '["manifestation", "gratitude", "release"]',
   '{"en": "The Full Moon illuminates everything, revealing both your achievements and what needs to be released. This is a powerful time for gratitude, celebration, and letting go.", "es": "La Luna Llena lo ilumina todo, revelando tanto tus logros como lo que necesita ser liberado. Este es un momento poderoso para la gratitud, la celebración y soltar.", "ca": "La Lluna Plena ho il·lumina tot, revelant tant els teus èxits com el que cal alliberar. Aquest és un moment poderós per a la gratitud, la celebració i deixar anar."}',
   '["Celebrate your achievements and progress", "Practice gratitude for what you have", "Release what no longer serves you", "Perform a releasing ritual or ceremony", "Share your light and success with others"]',
   '["What have I manifested in this cycle?", "What am I grateful for right now?", "What do I need to release or let go of?"]',
   0, true),

  -- Waning Gibbous (Generic)
  ('waning_gibbous_generic', 'waning_gibbous', NULL, NULL,
   '{"en": "Sharing & Gratitude", "es": "Compartir y Gratitud", "ca": "Compartir i Gratitud"}',
   '{"en": "Share your wisdom and give thanks", "es": "Comparte tu sabiduría y da gracias", "ca": "Comparteix la teva saviesa i dóna gràcies"}',
   '["generosity", "teaching", "gratitude"]',
   '{"en": "After the Full Moon''s peak, this is a time to share what you''ve learned and give back. Your experiences can help others on their journey.", "es": "Después del pico de la Luna Llena, este es un momento para compartir lo que has aprendido y retribuir. Tus experiencias pueden ayudar a otros en su camino.", "ca": "Després del pic de la Lluna Plena, aquest és un moment per compartir el que has après i retornar. Les teves experiències poden ajudar altres en el seu camí."}',
   '["Share your knowledge and experiences", "Give back to your community", "Express gratitude to those who helped you", "Teach what you''ve learned", "Be generous with your time and resources"]',
   '["What wisdom can I share with others?", "How can I give back to my community?", "Who helped me along the way, and how can I thank them?"]',
   0, true),

  -- Last Quarter (Generic)
  ('last_quarter_generic', 'last_quarter', NULL, NULL,
   '{"en": "Release & Forgiveness", "es": "Liberación y Perdón", "ca": "Alliberament i Perdó"}',
   '{"en": "Let go of the past and forgive", "es": "Suelta el pasado y perdona", "ca": "Deixa anar el passat i perdona"}',
   '["forgiveness", "clearing", "closure"]',
   '{"en": "The Last Quarter Moon is a time of active release. Let go of grudges, regrets, and anything weighing you down. Forgiveness—of yourself and others—creates space for new beginnings.", "es": "La Luna del Último Cuarto es un tiempo de liberación activa. Suelta rencores, arrepentimientos y cualquier cosa que te pese. El perdón—de ti mismo y de otros—crea espacio para nuevos comienzos.", "ca": "La Lluna de l''Últim Quart és un temps d''alliberament actiu. Deixa anar rancúnies, penediments i qualsevol cosa que et pesi. El perdó—de tu mateix i dels altres—crea espai per a nous començaments."}',
   '["Practice forgiveness of yourself and others", "Release old grudges and resentments", "Clear physical and emotional clutter", "Complete unfinished business", "Make amends where needed"]',
   '["What am I holding onto that I need to release?", "Who do I need to forgive, including myself?", "What emotional baggage can I let go of?"]',
   0, true),

  -- Waning Crescent (Generic)
  ('waning_crescent_generic', 'waning_crescent', NULL, NULL,
   '{"en": "Sacred Rest", "es": "Descanso Sagrado", "ca": "Descans Sagrat"}',
   '{"en": "Turn inward for wisdom and renewal", "es": "Vuélvete hacia adentro para sabiduría y renovación", "ca": "Gira''t cap a dins per a saviesa i renovació"}',
   '["rest", "introspection", "surrender"]',
   '{"en": "The Waning Crescent is the Moon''s quietest phase. This is a time to rest, reflect, and turn inward. Honor your need for solitude and prepare for the new cycle ahead.", "es": "La Luna Menguante Creciente es la fase más silenciosa de la Luna. Este es un momento para descansar, reflexionar y volcarse hacia adentro. Honra tu necesidad de soledad y prepárate para el nuevo ciclo que viene.", "ca": "La Lluna Minvant Creixent és la fase més silenciosa de la Lluna. Aquest és un moment per descansar, reflexionar i girar-te cap a dins. Honra la teva necessitat de solitud i prepara''t per al nou cicle que ve."}',
   '["Rest and restore your energy", "Meditate and turn inward", "Trust in divine timing and surrender", "Reflect on the lessons of this cycle", "Prepare mentally for new beginnings"]',
   '["What have I learned in this lunar cycle?", "What do I need to release before the next New Moon?", "How can I honor my need for rest and restoration?"]',
   0, true);

-- Step 8: Reload PostgREST schema cache
NOTIFY pgrst, 'reload schema';
NOTIFY pgrst, 'reload config';

-- Step 9: Verify everything is set up correctly
SELECT '✅ Tables created' as status;

SELECT
    'Templates: ' || COUNT(*)::text as verification
FROM lunar_guide_templates
UNION ALL
SELECT
    'RLS disabled: ' || CASE WHEN rowsecurity = false THEN '✅' ELSE '❌' END
FROM pg_tables
WHERE tablename = 'lunar_guide_templates'
UNION ALL
SELECT
    'Permissions granted: ' || CASE WHEN COUNT(*) > 0 THEN '✅' ELSE '❌' END
FROM information_schema.table_privileges
WHERE table_name = 'lunar_guide_templates'
AND grantee = 'anon'
AND privilege_type = 'SELECT';

SELECT '🔄 PostgREST schema reload triggered' as status;
