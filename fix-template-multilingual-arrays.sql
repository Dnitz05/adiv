-- Fix lunar guide templates to have multilingual focus_areas, recommended_actions, and journal_prompts

-- Waning Crescent (Generic) - Sacred Rest
UPDATE lunar_guide_templates
SET
  focus_areas = '{"en": ["rest", "introspection", "surrender"], "es": ["descanso", "introspección", "rendirse"], "ca": ["descans", "introspecció", "rendir-se"]}',
  recommended_actions = '{"en": ["Rest and restore your energy", "Meditate and turn inward", "Trust in divine timing and surrender", "Reflect on the lessons of this cycle", "Prepare mentally for new beginnings"], "es": ["Descansa y restaura tu energía", "Medita y vuélvete hacia adentro", "Confía en el tiempo divino y ríndete", "Reflexiona sobre las lecciones de este ciclo", "Prepárate mentalmente para nuevos comienzos"], "ca": ["Descansa i restaura la teva energia", "Medita i gira''t cap a dins", "Confia en el temps diví i rendeix-te", "Reflexiona sobre les lliçons d''aquest cicle", "Prepara''t mentalment per a nous començaments"]}',
  journal_prompts = '{"en": ["What have I learned in this lunar cycle?", "What do I need to release before the next New Moon?", "How can I honor my need for rest and restoration?"], "es": ["¿Qué he aprendido en este ciclo lunar?", "¿Qué necesito soltar antes de la próxima Luna Nueva?", "¿Cómo puedo honrar mi necesidad de descanso y restauración?"], "ca": ["Què he après en aquest cicle lunar?", "Què necessito alliberar abans de la propera Lluna Nova?", "Com puc honrar la meva necessitat de descans i restauració?"]}'
WHERE id = 'waning_crescent_generic';

-- New Moon (Generic)
UPDATE lunar_guide_templates
SET
  focus_areas = '{"en": ["intention_setting", "planning", "dreaming"], "es": ["establecer_intenciones", "planificación", "soñar"], "ca": ["establir_intencions", "planificació", "somiar"]}',
  recommended_actions = '{"en": ["Set clear intentions for this lunar cycle", "Write down your goals and dreams", "Create a vision board", "Meditate on new possibilities", "Start a new project or habit"], "es": ["Establece intenciones claras para este ciclo lunar", "Escribe tus metas y sueños", "Crea un tablero de visión", "Medita sobre nuevas posibilidades", "Comienza un nuevo proyecto o hábito"], "ca": ["Estableix intencions clares per aquest cicle lunar", "Escriu els teus objectius i somnis", "Crea un tauler de visió", "Medita sobre noves possibilitats", "Comença un nou projecte o hàbit"]}',
  journal_prompts = '{"en": ["What do I want to create in this lunar cycle?", "What seeds am I planting for my future?", "What would I do if I knew I couldn''t fail?"], "es": ["¿Qué quiero crear en este ciclo lunar?", "¿Qué semillas estoy plantando para mi futuro?", "¿Qué haría si supiera que no puedo fallar?"], "ca": ["Què vull crear en aquest cicle lunar?", "Quines llavors estic plantant per al meu futur?", "Què faria si sabés que no puc fallar?"]}'
WHERE id = 'new_moon_generic';

-- Waxing Crescent (Generic)
UPDATE lunar_guide_templates
SET
  focus_areas = '{"en": ["action", "momentum", "initiative"], "es": ["acción", "impulso", "iniciativa"], "ca": ["acció", "impuls", "iniciativa"]}',
  recommended_actions = '{"en": ["Take one concrete action toward your goals", "Build supportive habits and routines", "Gather resources you''ll need", "Reach out to allies and collaborators", "Stay flexible and adjust your plans as needed"], "es": ["Da un paso concreto hacia tus metas", "Construye hábitos y rutinas de apoyo", "Reúne los recursos que necesitarás", "Contacta aliados y colaboradores", "Mantente flexible y ajusta tus planes según sea necesario"], "ca": ["Fes un pas concret cap als teus objectius", "Construeix hàbits i rutines de suport", "Reuneix els recursos que necessitaràs", "Contacta aliats i col·laboradors", "Mantén-te flexible i ajusta els teus plans segons calgui"]}',
  journal_prompts = '{"en": ["What action can I take today to move forward?", "What habits will support my intentions?", "Who can help me on this journey?"], "es": ["¿Qué acción puedo tomar hoy para avanzar?", "¿Qué hábitos apoyarán mis intenciones?", "¿Quién puede ayudarme en este viaje?"], "ca": ["Quina acció puc fer avui per avançar?", "Quins hàbits donaran suport a les meves intencions?", "Qui em pot ajudar en aquest viatge?"]}'
WHERE id = 'waxing_crescent_generic';

-- First Quarter (Generic)
UPDATE lunar_guide_templates
SET
  focus_areas = '{"en": ["perseverance", "problem_solving", "strength"], "es": ["perseverancia", "resolución_de_problemas", "fuerza"], "ca": ["perseverança", "resolució_de_problemes", "força"]}',
  recommended_actions = '{"en": ["Face challenges head-on with confidence", "Make necessary decisions and commitments", "Adjust your strategy if needed", "Ask for help when you need it", "Celebrate small victories along the way"], "es": ["Enfrenta los desafíos con confianza", "Toma decisiones y compromisos necesarios", "Ajusta tu estrategia si es necesario", "Pide ayuda cuando la necesites", "Celebra pequeñas victorias en el camino"], "ca": ["Enfronta els reptes amb confiança", "Pren decisions i compromisos necessaris", "Ajusta la teva estratègia si cal", "Demana ajuda quan la necessitis", "Celebra petites victòries pel camí"]}',
  journal_prompts = '{"en": ["What obstacles am I facing, and how can I overcome them?", "What do I need to commit to right now?", "How can I stay motivated when things get tough?"], "es": ["¿Qué obstáculos enfrento y cómo puedo superarlos?", "¿A qué necesito comprometerme ahora?", "¿Cómo puedo mantenerme motivado cuando las cosas se ponen difíciles?"], "ca": ["Quins obstacles estic enfrontant i com puc superar-los?", "A què necessito comprometre''m ara?", "Com puc mantenir-me motivat quan les coses es posen difícils?"]}'
WHERE id = 'first_quarter_generic';

-- Waxing Gibbous (Generic)
UPDATE lunar_guide_templates
SET
  focus_areas = '{"en": ["refinement", "preparation", "patience"], "es": ["refinamiento", "preparación", "paciencia"], "ca": ["refinament", "preparació", "paciència"]}',
  recommended_actions = '{"en": ["Review your progress and adjust course", "Perfect the details of your project", "Practice patience as things come together", "Trust the process and timing", "Prepare for the manifestation ahead"], "es": ["Revisa tu progreso y ajusta el rumbo", "Perfecciona los detalles de tu proyecto", "Practica la paciencia mientras las cosas se unen", "Confía en el proceso y el tiempo", "Prepárate para la manifestación que viene"], "ca": ["Revisa el teu progrés i ajusta el rumb", "Perfecciona els detalls del teu projecte", "Practica la paciència mentre les coses s''ajunten", "Confia en el procés i el temps", "Prepara''t per a la manifestació que ve"]}',
  journal_prompts = '{"en": ["What needs fine-tuning before I reach my goal?", "Am I being patient with the process?", "What final preparations do I need to make?"], "es": ["¿Qué necesita ajustes finos antes de alcanzar mi meta?", "¿Estoy siendo paciente con el proceso?", "¿Qué preparaciones finales necesito hacer?"], "ca": ["Què necessita ajustos fins abans d''assolir el meu objectiu?", "Estic sent pacient amb el procés?", "Quines preparacions finals necessito fer?"]}'
WHERE id = 'waxing_gibbous_generic';

-- Full Moon (Generic)
UPDATE lunar_guide_templates
SET
  focus_areas = '{"en": ["manifestation", "gratitude", "release"], "es": ["manifestación", "gratitud", "liberación"], "ca": ["manifestació", "gratitud", "alliberament"]}',
  recommended_actions = '{"en": ["Celebrate your achievements and progress", "Practice gratitude for what you have", "Release what no longer serves you", "Perform a releasing ritual or ceremony", "Share your light and success with others"], "es": ["Celebra tus logros y progreso", "Practica la gratitud por lo que tienes", "Libera lo que ya no te sirve", "Realiza un ritual o ceremonia de liberación", "Comparte tu luz y éxito con otros"], "ca": ["Celebra els teus èxits i progrés", "Practica la gratitud pel que tens", "Allibera el que ja no et serveix", "Realitza un ritual o cerimònia d''alliberament", "Comparteix la teva llum i èxit amb altres"]}',
  journal_prompts = '{"en": ["What have I manifested in this cycle?", "What am I grateful for right now?", "What do I need to release or let go of?"], "es": ["¿Qué he manifestado en este ciclo?", "¿Por qué estoy agradecido ahora?", "¿Qué necesito liberar o soltar?"], "ca": ["Què he manifestat en aquest cicle?", "Per què estic agraït ara?", "Què necessito alliberar o deixar anar?"]}'
WHERE id = 'full_moon_generic';

-- Waning Gibbous (Generic)
UPDATE lunar_guide_templates
SET
  focus_areas = '{"en": ["generosity", "teaching", "gratitude"], "es": ["generosidad", "enseñanza", "gratitud"], "ca": ["generositat", "ensenyament", "gratitud"]}',
  recommended_actions = '{"en": ["Share your knowledge and experiences", "Give back to your community", "Express gratitude to those who helped you", "Teach what you''ve learned", "Be generous with your time and resources"], "es": ["Comparte tu conocimiento y experiencias", "Devuelve a tu comunidad", "Expresa gratitud a quienes te ayudaron", "Enseña lo que has aprendido", "Sé generoso con tu tiempo y recursos"], "ca": ["Comparteix el teu coneixement i experiències", "Retorna a la teva comunitat", "Expressa gratitud a qui t''ha ajudat", "Ensenya el que has après", "Sigues generós amb el teu temps i recursos"]}',
  journal_prompts = '{"en": ["What wisdom can I share with others?", "How can I give back to my community?", "Who helped me along the way, and how can I thank them?"], "es": ["¿Qué sabiduría puedo compartir con otros?", "¿Cómo puedo devolver a mi comunidad?", "¿Quién me ayudó en el camino y cómo puedo agradecerles?"], "ca": ["Quina saviesa puc compartir amb altres?", "Com puc retornar a la meva comunitat?", "Qui m''ha ajudat pel camí i com puc agrair-los-ho?"]}'
WHERE id = 'waning_gibbous_generic';

-- Last Quarter (Generic)
UPDATE lunar_guide_templates
SET
  focus_areas = '{"en": ["forgiveness", "clearing", "closure"], "es": ["perdón", "limpieza", "cierre"], "ca": ["perdó", "neteja", "tancament"]}',
  recommended_actions = '{"en": ["Practice forgiveness of yourself and others", "Release old grudges and resentments", "Clear physical and emotional clutter", "Complete unfinished business", "Make amends where needed"], "es": ["Practica el perdón de ti mismo y de otros", "Libera viejos rencores y resentimientos", "Limpia el desorden físico y emocional", "Completa asuntos pendientes", "Haz las paces donde sea necesario"], "ca": ["Practica el perdó de tu mateix i dels altres", "Allibera vells rancors i ressentiments", "Neteja el desordre físic i emocional", "Completa assumptes pendents", "Fes les paus on calgui"]}',
  journal_prompts = '{"en": ["What am I holding onto that I need to release?", "Who do I need to forgive, including myself?", "What emotional baggage can I let go of?"], "es": ["¿Qué estoy reteniendo que necesito liberar?", "¿A quién necesito perdonar, incluyéndome a mí mismo?", "¿Qué equipaje emocional puedo soltar?"], "ca": ["Què estic retenint que necessito alliberar?", "A qui necessito perdonar, incloent-me a mi mateix?", "Quin equipatge emocional puc deixar anar?"]}'
WHERE id = 'last_quarter_generic';

SELECT 'Templates updated with multilingual arrays' as status;
