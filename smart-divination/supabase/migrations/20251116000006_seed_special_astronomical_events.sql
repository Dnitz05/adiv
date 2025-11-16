-- =====================================================
-- SEED SPECIAL ASTRONOMICAL EVENTS (2025-2027)
-- =====================================================
-- Purpose: Populate special astronomical events with verified dates
-- Foundation: docs/astronomical_events.md
-- Sources: NASA, Time and Date, Cafe Astrology, The Old Farmer's Almanac

-- =====================================================
-- 2025 EVENTS
-- =====================================================

-- Total Lunar Eclipse - September 7, 2025
INSERT INTO special_astronomical_events (
  event_type,
  start_date,
  end_date,
  event_name,
  traditional_meaning,
  guidance,
  recommended_actions,
  avoid_actions,
  intensity,
  visibility,
  zodiac_sign
) VALUES (
  'lunar_eclipse_total',
  '2025-09-07',
  NULL,
  '{
    "en": "Total Lunar Eclipse (Blood Moon)",
    "es": "Eclipse Lunar Total (Luna de Sangre)",
    "ca": "Eclipsi Lunar Total (Lluna de Sang)"
  }'::jsonb,
  '{
    "en": "In ancient traditions, lunar eclipses marked moments of profound emotional culmination and release. The Moon, governing our emotions and inner world, is temporarily darkened, revealing what has been hidden in shadow. This is a cosmic reset button for the emotional body.",
    "es": "En tradiciones antiguas, los eclipses lunares marcaban momentos de profunda culminación y liberación emocional. La Luna, gobernante de nuestras emociones y mundo interior, se oscurece temporalmente, revelando lo que ha estado oculto en la sombra. Este es un botón de reinicio cósmico para el cuerpo emocional.",
    "ca": "En tradicions antigues, els eclipsis lunars marcaven moments de profunda culminació i alliberament emocional. La Lluna, governant de les nostres emocions i món interior, s''enfosqueix temporalment, revelant el que ha estat ocult a l''ombra. Aquest és un botó de reinici còsmic per al cos emocional."
  }'::jsonb,
  '{
    "en": "This is not an ordinary Full Moon. A total lunar eclipse creates a portal for deep transformation. What emotional patterns are ready to end? What shadow material needs to be seen and released? The effects of this eclipse will reverberate for 6 months. Honor what is ending to make space for rebirth.",
    "es": "Esta no es una Luna Llena ordinaria. Un eclipse lunar total crea un portal para una transformación profunda. ¿Qué patrones emocionales están listos para terminar? ¿Qué material de sombra necesita ser visto y liberado? Los efectos de este eclipse reverberarán durante 6 meses. Honra lo que está terminando para hacer espacio para el renacimiento.",
    "ca": "Aquesta no és una Lluna Plena ordinària. Un eclipsi lunar total crea un portal per a una transformació profunda. Quins patrons emocionals estan llestos per acabar? Quin material d''ombra necessita ser vist i alliberat? Els efectes d''aquest eclipsi reverberaran durant 6 mesos. Honora el que està acabant per fer espai per al renaixement."
  }'::jsonb,
  '{
    "en": ["Deep emotional release work or ceremony", "Shadow work - examine what you''ve been avoiding", "Journal about patterns ready to end", "Honor achievements before releasing them", "Meditation on death and rebirth", "Ritual to mark major life transitions"],
    "es": ["Trabajo de liberación emocional profunda o ceremonia", "Trabajo de sombra - examina lo que has estado evitando", "Escribe sobre patrones listos para terminar", "Honra logros antes de liberarlos", "Meditación sobre muerte y renacimiento", "Ritual para marcar transiciones de vida importantes"],
    "ca": ["Treball d''alliberament emocional profund o cerimònia", "Treball d''ombra - examina el que has estat evitant", "Escriu sobre patrons llestos per acabar", "Honora assoliments abans d''alliberar-los", "Meditació sobre mort i renaixement", "Ritual per marcar transicions de vida importants"]
  }'::jsonb,
  '{
    "en": ["Making impulsive life-changing decisions", "Starting new major projects (wait 3 days)", "Forcing outcomes - let the eclipse do its work", "Ignoring strong emotions that arise"],
    "es": ["Tomar decisiones impulsivas que cambien la vida", "Comenzar nuevos proyectos importantes (espera 3 días)", "Forzar resultados - deja que el eclipse haga su trabajo", "Ignorar emociones fuertes que surjan"],
    "ca": ["Prendre decisions impulsives que canviïn la vida", "Començar nous projectes importants (espera 3 dies)", "Forçar resultats - deixa que l''eclipsi faci la seva feina", "Ignorar emocions fortes que sorgeixin"]
  }'::jsonb,
  10,
  'Global (visible from North America, South America, Europe, Africa)',
  'pisces'
);

-- Partial Solar Eclipse - September 21, 2025
INSERT INTO special_astronomical_events (
  event_type,
  start_date,
  end_date,
  event_name,
  traditional_meaning,
  guidance,
  recommended_actions,
  avoid_actions,
  intensity,
  visibility
) VALUES (
  'solar_eclipse_partial',
  '2025-09-21',
  NULL,
  '{
    "en": "Partial Solar Eclipse",
    "es": "Eclipse Solar Parcial",
    "ca": "Eclipsi Solar Parcial"
  }'::jsonb,
  '{
    "en": "In ancient Mesopotamian and Hellenistic astrology, solar eclipses were considered powerful omens marking significant changes in leadership, authority, and life direction. The Sun, representing the conscious self and life force, is temporarily obscured, creating a moment of destiny and new beginnings.",
    "es": "En astrología mesopotámica y helenística antigua, los eclipses solares eran considerados poderosos presagios que marcaban cambios significativos en liderazgo, autoridad y dirección de vida. El Sol, representando el yo consciente y la fuerza vital, se oscurece temporalmente, creando un momento de destino y nuevos comienzos.",
    "ca": "En astrologia mesopotàmica i hel·lenística antiga, els eclipsis solars eren considerats poderosos presagis que marcaven canvis significants en lideratge, autoritat i direcció de vida. El Sol, representant el jo conscient i la força vital, s''enfosqueix temporalment, creant un moment de destí i nous començaments."
  }'::jsonb,
  '{
    "en": "A partial eclipse brings moderate but significant shifts. This is a moment to adjust your path, not completely overhaul it. What needs to change in your sense of purpose or self-expression? The effects will unfold over the next 6 months.",
    "es": "Un eclipse parcial trae cambios moderados pero significativos. Este es un momento para ajustar tu camino, no para revisarlo completamente. ¿Qué necesita cambiar en tu sentido de propósito o autoexpresión? Los efectos se desarrollarán durante los próximos 6 meses.",
    "ca": "Un eclipsi parcial porta canvis moderats però significatius. Aquest és un moment per ajustar el teu camí, no per revisar-lo completament. Què necessita canviar en el teu sentit de propòsit o autoexpressió? Els efectes es desenvoluparan durant els propers 6 mesos."
  }'::jsonb,
  '{
    "en": ["Reflect on your life direction and purpose", "Identify areas needing adjustment or course-correction", "Set intentions for new beginnings", "Release outdated identities or roles", "Meditate on who you are becoming"],
    "es": ["Reflexiona sobre tu dirección de vida y propósito", "Identifica áreas que necesitan ajuste o corrección de rumbo", "Establece intenciones para nuevos comienzos", "Libera identidades o roles obsoletos", "Medita sobre en quién te estás convirtiendo"],
    "ca": ["Reflexiona sobre la teva direcció de vida i propòsit", "Identifica àrees que necessiten ajust o correcció de rumb", "Estableix intencions per nous començaments", "Allibera identitats o rols obsolets", "Medita sobre en qui t''estàs convertint"]
  }'::jsonb,
  '{
    "en": ["Starting major new projects on eclipse day itself", "Making final decisions (wait 3 days for clarity)", "Ignoring the call for change"],
    "es": ["Comenzar nuevos proyectos importantes en el día del eclipse", "Tomar decisiones finales (espera 3 días para claridad)", "Ignorar el llamado al cambio"],
    "ca": ["Començar nous projectes importants en el dia de l''eclipsi", "Prendre decisions finals (espera 3 dies per claredat)", "Ignorar la crida al canvi"]
  }'::jsonb,
  7,
  'Partial visibility from South Pacific, New Zealand, Antarctica'
);

-- Mercury Retrograde: March 15 - April 7, 2025
INSERT INTO special_astronomical_events (
  event_type,
  start_date,
  end_date,
  event_name,
  traditional_meaning,
  guidance,
  recommended_actions,
  avoid_actions,
  intensity,
  visibility,
  zodiac_sign
) VALUES (
  'mercury_retrograde',
  '2025-03-15',
  '2025-04-07',
  '{
    "en": "Mercury Retrograde in Aries",
    "es": "Mercurio Retrógrado en Aries",
    "ca": "Mercuri Retrògrad en Aries"
  }'::jsonb,
  '{
    "en": "In traditional horary astrology, Mercury retrograde was viewed with caution, with the phrase \"nothing will come of it\" applied to new ventures. Mercury, ruling communication and commerce, appears to move backward, indicating a time for review rather than initiation.",
    "es": "En astrología horaria tradicional, Mercurio retrógrado se veía con cautela, con la frase \"nada saldrá de ello\" aplicada a nuevas empresas. Mercurio, regente de la comunicación y el comercio, parece moverse hacia atrás, indicando un tiempo para revisar en lugar de iniciar.",
    "ca": "En astrologia horària tradicional, Mercuri retrògrad es veia amb cautela, amb la frase \"res en sortirà\" aplicada a noves empreses. Mercuri, regent de la comunicació i el comerç, sembla moure''s cap enrere, indicant un temps per revisar en lloc d''iniciar."
  }'::jsonb,
  '{
    "en": "This is a time for the \"re-\" prefix: review, revise, reconnect, reconsider. Communication mishaps are more likely. Technology may act up. Travel plans may face delays. Instead of fighting these energies, use them to refine and improve what already exists.",
    "es": "Este es un tiempo para el prefijo \"re-\": revisar, reconsiderar, reconectar, repensar. Los errores de comunicación son más probables. La tecnología puede fallar. Los planes de viaje pueden enfrentar retrasos. En lugar de luchar contra estas energías, úsalas para refinar y mejorar lo que ya existe.",
    "ca": "Aquest és un temps per al prefix \"re-\": revisar, reconsiderar, reconnectar, repensar. Els errors de comunicació són més probables. La tecnologia pot fallar. Els plans de viatge poden enfrontar retards. En lloc de lluitar contra aquestes energies, usa-les per refinar i millorar el que ja existeix."
  }'::jsonb,
  '{
    "en": ["Review and revise existing projects", "Reconnect with people from your past", "Back up important data and files", "Double-check all communications before sending", "Finish incomplete projects", "Reflect and journal"],
    "es": ["Revisa y corrige proyectos existentes", "Reconecta con personas de tu pasado", "Respalda datos y archivos importantes", "Verifica todas las comunicaciones antes de enviar", "Termina proyectos incompletos", "Reflexiona y escribe en diario"],
    "ca": ["Revisa i corregeix projectes existents", "Reconnecta amb persones del teu passat", "Fes còpia de seguretat de dades i arxius importants", "Verifica totes les comunicacions abans d''enviar", "Acaba projectes incomplets", "Reflexiona i escriu en diari"]
  }'::jsonb,
  '{
    "en": ["Signing important contracts (if unavoidable, read very carefully)", "Launching new projects or businesses", "Buying expensive technology or vehicles", "Making major communication-dependent decisions", "Assuming people understood what you meant"],
    "es": ["Firmar contratos importantes (si es inevitable, lee con mucho cuidado)", "Lanzar nuevos proyectos o negocios", "Comprar tecnología cara o vehículos", "Tomar decisiones importantes dependientes de comunicación", "Asumir que la gente entendió lo que querías decir"],
    "ca": ["Signar contractes importants (si és inevitable, llegeix amb molta cura)", "Llançar nous projectes o negocis", "Comprar tecnologia cara o vehicles", "Prendre decisions importants dependents de comunicació", "Assumir que la gent va entendre el que volies dir"]
  }'::jsonb,
  7,
  'Global',
  'aries'
);

-- Mercury Retrograde: July 18 - August 11, 2025
INSERT INTO special_astronomical_events (
  event_type,
  start_date,
  end_date,
  event_name,
  traditional_meaning,
  guidance,
  recommended_actions,
  avoid_actions,
  intensity,
  visibility,
  zodiac_sign
) VALUES (
  'mercury_retrograde',
  '2025-07-18',
  '2025-08-11',
  '{
    "en": "Mercury Retrograde in Leo",
    "es": "Mercurio Retrógrado en Leo",
    "ca": "Mercuri Retrògrad en Leo"
  }'::jsonb,
  '{
    "en": "Mercury retrograde marks a period when the mind turns inward for review and reconsideration. In traditional astrology, new projects begun during this time were said to fail or require major revision once Mercury went direct.",
    "es": "Mercurio retrógrado marca un período en que la mente se vuelve hacia adentro para revisar y reconsiderar. En astrología tradicional, los nuevos proyectos comenzados durante este tiempo se decía que fracasaban o requerían revisión importante una vez Mercurio iba directo.",
    "ca": "Mercuri retrògrad marca un període en què la ment es gira cap a dins per revisar i reconsiderar. En astrologia tradicional, els nous projectes començats durant aquest temps es deia que fracassaven o requerien revisió important una vegada Mercuri anava directe."
  }'::jsonb,
  '{
    "en": "With Mercury retrograde in creative Leo, this is an excellent time to revise creative projects, reconnect with your inner child, and reconsider how you express yourself. Communication about ego or pride may be especially tricky. Patience with yourself and others is key.",
    "es": "Con Mercurio retrógrado en Leo creativo, este es un excelente momento para revisar proyectos creativos, reconectar con tu niño interior y reconsiderar cómo te expresas. La comunicación sobre ego u orgullo puede ser especialmente complicada. La paciencia contigo y con los demás es clave.",
    "ca": "Amb Mercuri retrògrad en Leo creatiu, aquest és un excel·lent moment per revisar projectes creatius, reconnectar amb el teu nen interior i reconsiderar com t''expreses. La comunicació sobre ego o orgull pot ser especialment complicada. La paciència amb tu i amb els altres és clau."
  }'::jsonb,
  '{
    "en": ["Revise creative projects and artistic work", "Reflect on how you express yourself authentically", "Reconnect with childhood passions", "Review romantic relationships for patterns", "Practice humility in communications"],
    "es": ["Revisa proyectos creativos y trabajo artístico", "Reflexiona sobre cómo te expresas auténticamente", "Reconecta con pasiones de la infancia", "Revisa relaciones románticas buscando patrones", "Practica humildad en comunicaciones"],
    "ca": ["Revisa projectes creatius i treball artístic", "Reflexiona sobre com t''expreses autènticament", "Reconnecta amb passions de la infantesa", "Revisa relacions romàntiques buscant patrons", "Practica humilitat en comunicacions"]
  }'::jsonb,
  '{
    "en": ["Starting new creative projects for public launch", "Making ego-driven decisions", "Signing entertainment or creative contracts", "Launching new romantic relationships (reconnecting with exes is different)"],
    "es": ["Comenzar nuevos proyectos creativos para lanzamiento público", "Tomar decisiones impulsadas por el ego", "Firmar contratos de entretenimiento o creativos", "Lanzar nuevas relaciones románticas (reconectar con ex es diferente)"],
    "ca": ["Començar nous projectes creatius per llançament públic", "Prendre decisions impulsades per l''ego", "Signar contractes d''entreteniment o creatius", "Llançar noves relacions romàntiques (reconnectar amb ex és diferent)"]
  }'::jsonb,
  7,
  'Global',
  'leo'
);

-- Mercury Retrograde: November 9 - 29, 2025
INSERT INTO special_astronomical_events (
  event_type,
  start_date,
  end_date,
  event_name,
  traditional_meaning,
  guidance,
  recommended_actions,
  avoid_actions,
  intensity,
  visibility,
  zodiac_sign
) VALUES (
  'mercury_retrograde',
  '2025-11-09',
  '2025-11-29',
  '{
    "en": "Mercury Retrograde in Sagittarius",
    "es": "Mercurio Retrógrado en Sagitario",
    "ca": "Mercuri Retrògrad en Sagitari"
  }'::jsonb,
  '{
    "en": "Traditional astrology viewed Mercury retrograde as a time when plans go awry and communication breaks down. The medieval phrase was that retrograde planets \"do not follow tradition\" and thus were considered problematic.",
    "es": "La astrología tradicional veía a Mercurio retrógrado como un tiempo en que los planes salen mal y la comunicación se rompe. La frase medieval era que los planetas retrógrados \"no siguen la tradición\" y por lo tanto se consideraban problemáticos.",
    "ca": "L''astrologia tradicional veia Mercuri retrògrad com un temps en què els plans surten malament i la comunicació es trenca. La frase medieval era que els planetes retrògr ads \"no segueixen la tradició\" i per tant es consideraven problemàtics."
  }'::jsonb,
  '{
    "en": "In philosophical Sagittarius, this retrograde asks you to reconsider your beliefs, revise your understanding, and review your long-term plans. Travel plans may be disrupted. Educational pursuits benefit from review. Question your assumptions.",
    "es": "En Sagitario filosófico, este retrógrado te pide reconsiderar tus creencias, revisar tu comprensión y repasar tus planes a largo plazo. Los planes de viaje pueden verse interrumpidos. Las búsquedas educativas se benefician de la revisión. Cuestiona tus suposiciones.",
    "ca": "En Sagitari filosòfic, aquest retrògrad et demana reconsiderar les teves creences, revisar la teva comprensió i repassar els teus plans a llarg termini. Els plans de viatge poden veure''s interromputs. Les cerques educatives es beneficien de la revisió. Qüestiona les teves suposicions."
  }'::jsonb,
  '{
    "en": ["Review your belief systems and philosophies", "Revise long-term plans and goals", "Reconnect with teachers or mentors", "Study subjects you''ve abandoned", "Question assumptions you''ve taken for granted"],
    "es": ["Revisa tus sistemas de creencias y filosofías", "Revisa planes y metas a largo plazo", "Reconecta con maestros o mentores", "Estudia temas que has abandonado", "Cuestiona suposiciones que has dado por sentadas"],
    "ca": ["Revisa els teus sistemes de creences i filosofies", "Revisa plans i metes a llarg termini", "Reconnecta amb mestres o mentors", "Estudia temes que has abandonat", "Qüestiona suposicions que has donat per fetes"]
  }'::jsonb,
  '{
    "en": ["Booking major international travel", "Starting higher education programs", "Publishing books or major works", "Making final decisions on philosophical matters"],
    "es": ["Reservar viajes internacionales importantes", "Comenzar programas de educación superior", "Publicar libros o trabajos importantes", "Tomar decisiones finales sobre asuntos filosóficos"],
    "ca": ["Reservar viatges internacionals importants", "Començar programes d''educació superior", "Publicar llibres o treballs importants", "Prendre decisions finals sobre assumptes filosòfics"]
  }'::jsonb,
  7,
  'Global',
  'sagittarius'
);

-- =====================================================
-- 2026 EVENTS
-- =====================================================

-- Annular Solar Eclipse - February 17, 2026
INSERT INTO special_astronomical_events (
  event_type,
  start_date,
  end_date,
  event_name,
  traditional_meaning,
  guidance,
  recommended_actions,
  avoid_actions,
  intensity,
  visibility
) VALUES (
  'solar_eclipse_annular',
  '2026-02-17',
  NULL,
  '{
    "en": "Annular Solar Eclipse",
    "es": "Eclipse Solar Anular",
    "ca": "Eclipsi Solar Anular"
  }'::jsonb,
  '{
    "en": "Annular eclipses, where the Moon does not completely cover the Sun, create a \"ring of fire\" effect. In traditional astrology, these mark cycles that return, patterns that repeat. The old is not completely gone; it transforms and comes back in a new form.",
    "es": "Los eclipses anulares, donde la Luna no cubre completamente el Sol, crean un efecto de \"anillo de fuego\". En astrología tradicional, estos marcan ciclos que regresan, patrones que se repiten. Lo viejo no se ha ido completamente; se transforma y regresa en una nueva forma.",
    "ca": "Els eclipsis anulars, on la Lluna no cobreix completament el Sol, creen un efecte d''\"anell de foc\". En astrologia tradicional, aquests marquen cicles que tornen, patrons que es repeteixen. El vell no s''ha anat completament; es transforma i torna en una nova forma."
  }'::jsonb,
  '{
    "en": "An annular eclipse brings themes of recurrence and renewal. What patterns in your life are cycling back? This time, you have the wisdom of experience. Use it to handle familiar situations differently.",
    "es": "Un eclipse anular trae temas de recurrencia y renovación. ¿Qué patrones en tu vida están volviendo? Esta vez, tienes la sabiduría de la experiencia. Úsala para manejar situaciones familiares de manera diferente.",
    "ca": "Un eclipsi anular porta temes de recurrència i renovació. Quins patrons a la teva vida estan tornant? Aquesta vegada, tens la saviesa de l''experiència. Usa-la per manejar situacions familiars de manera diferent."
  }'::jsonb,
  '{
    "en": ["Identify recurring patterns in your life", "Apply lessons learned from past cycles", "Set intentions for how to handle familiar situations", "Honor the spiral nature of growth"],
    "es": ["Identifica patrones recurrentes en tu vida", "Aplica lecciones aprendidas de ciclos pasados", "Establece intenciones sobre cómo manejar situaciones familiares", "Honra la naturaleza espiral del crecimiento"],
    "ca": ["Identifica patrons recurrents a la teva vida", "Aplica lliçons apreses de cicles passats", "Estableix intencions sobre com manejar situacions familiars", "Honora la naturalesa espiral del creixement"]
  }'::jsonb,
  '{
    "en": ["Repeating old mistakes without awareness", "Starting projects without checking if similar ones failed before"],
    "es": ["Repetir viejos errores sin conciencia", "Comenzar proyectos sin verificar si otros similares fracasaron antes"],
    "ca": ["Repetir vells errors sense consciència", "Començar projectes sense verificar si altres similars van fracassar abans"]
  }'::jsonb,
  8,
  'Partial visibility from South America, Africa, Antarctica'
);

-- Total Lunar Eclipse - March 3, 2026
INSERT INTO special_astronomical_events (
  event_type,
  start_date,
  end_date,
  event_name,
  traditional_meaning,
  guidance,
  recommended_actions,
  avoid_actions,
  intensity,
  visibility,
  zodiac_sign
) VALUES (
  'lunar_eclipse_total',
  '2026-03-03',
  NULL,
  '{
    "en": "Total Lunar Eclipse (Blood Moon)",
    "es": "Eclipse Lunar Total (Luna de Sangre)",
    "ca": "Eclipsi Lunar Total (Lluna de Sang)"
  }'::jsonb,
  '{
    "en": "A total lunar eclipse marks a moment of profound emotional and psychic culmination. The Moon, fully shadowed by Earth, reveals what has been hidden. This is a cosmic portal for releasing old emotional patterns and embracing transformation.",
    "es": "Un eclipse lunar total marca un momento de profunda culminación emocional y psíquica. La Luna, totalmente sombreada por la Tierra, revela lo que ha estado oculto. Este es un portal cósmico para liberar viejos patrones emocionales y abrazar la transformación.",
    "ca": "Un eclipsi lunar total marca un moment de profunda culminació emocional i psíquica. La Lluna, totalment ombrejada per la Terra, revela el que ha estat ocult. Aquest és un portal còsmic per alliberar vells patrons emocionals i abraçar la transformació."
  }'::jsonb,
  '{
    "en": "This eclipse visible from North America offers a powerful opportunity for emotional reset. What needs to end to make space for growth? The shadow work done now will shape your path for the next 6 months.",
    "es": "Este eclipse visible desde América del Norte ofrece una poderosa oportunidad para un reinicio emocional. ¿Qué necesita terminar para hacer espacio para el crecimiento? El trabajo de sombra hecho ahora dará forma a tu camino durante los próximos 6 meses.",
    "ca": "Aquest eclipsi visible des d''Amèrica del Nord ofereix una poderosa oportunitat per a un reinici emocional. Què necessita acabar per fer espai per al creixement? El treball d''ombra fet ara donarà forma al teu camí durant els propers 6 mesos."
  }'::jsonb,
  '{
    "en": ["Deep shadow work and emotional release", "Ritual to mark endings and beginnings", "Honest assessment of emotional patterns", "Meditation on transformation"],
    "es": ["Trabajo de sombra profundo y liberación emocional", "Ritual para marcar finales y comienzos", "Evaluación honesta de patrones emocionales", "Meditación sobre transformación"],
    "ca": ["Treball d''ombra profund i alliberament emocional", "Ritual per marcar finals i començaments", "Avaluació honesta de patrons emocionals", "Meditació sobre transformació"]
  }'::jsonb,
  '{
    "en": ["Making impulsive decisions during high emotions", "Ignoring the call for change"],
    "es": ["Tomar decisiones impulsivas durante emociones altas", "Ignorar el llamado al cambio"],
    "ca": ["Prendre decisions impulsives durant emocions altes", "Ignorar la crida al canvi"]
  }'::jsonb,
  10,
  'Visible from North America (best from central/western regions)',
  'virgo'
);

-- Total Solar Eclipse - August 12, 2026
INSERT INTO special_astronomical_events (
  event_type,
  start_date,
  end_date,
  event_name,
  traditional_meaning,
  guidance,
  recommended_actions,
  avoid_actions,
  intensity,
  visibility
) VALUES (
  'solar_eclipse_total',
  '2026-08-12',
  NULL,
  '{
    "en": "Total Solar Eclipse",
    "es": "Eclipse Solar Total",
    "ca": "Eclipsi Solar Total"
  }'::jsonb,
  '{
    "en": "Total solar eclipses were considered the most powerful omens in ancient astrology, capable of changing the fate of kings and nations. The complete darkening of the Sun represents the death of the old self and rebirth into a new identity.",
    "es": "Los eclipses solares totales fueron considerados los presagios más poderosos en astrología antigua, capaces de cambiar el destino de reyes y naciones. El oscurecimiento completo del Sol representa la muerte del viejo yo y el renacimiento en una nueva identidad.",
    "ca": "Els eclipsis solars totals van ser considerats els presagis més poderosos en astrologia antiga, capaços de canviar el destí de reis i nacions. L''enfosquiment complet del Sol representa la mort del vell jo i el renaixement en una nova identitat."
  }'::jsonb,
  '{
    "en": "This is THE most powerful eclipse event. A total reset of your life direction and identity. What version of yourself is dying? What is being born? The path of totality crosses Greenland, Iceland, and northern Spain - if you can witness it, the impact is even stronger.",
    "es": "Este es EL evento de eclipse más poderoso. Un reinicio total de tu dirección de vida e identidad. ¿Qué versión de ti mismo está muriendo? ¿Qué está naciendo? El camino de la totalidad cruza Groenlandia, Islandia y el norte de España - si puedes presenciarlo, el impacto es aún más fuerte.",
    "ca": "Aquest és EL esdeveniment d''eclipsi més poderós. Un reinici total de la teva direcció de vida i identitat. Quina versió de tu mateix està morint? Què està naixent? El camí de la totalitat creua Groenlàndia, Islàndia i el nord d''Espanya - si pots presenciar-lo, l''impacte és encara més fort."
  }'::jsonb,
  '{
    "en": ["Major life direction ritual or ceremony", "Release old identities completely", "Set powerful intentions for who you are becoming", "If possible, witness the eclipse in person"],
    "es": ["Ritual o ceremonia de dirección de vida importante", "Libera viejas identidades completamente", "Establece intenciones poderosas sobre en quién te estás convirtiendo", "Si es posible, presencia el eclipse en persona"],
    "ca": ["Ritual o cerimònia de direcció de vida important", "Allibera velles identitats completament", "Estableix intencions poderoses sobre en qui t''estàs convertint", "Si és possible, presencia l''eclipsi en persona"]
  }'::jsonb,
  '{
    "en": ["Clinging to old versions of yourself", "Resisting major life changes", "Making decisions on eclipse day itself (wait 3 days)"],
    "es": ["Aferrarte a viejas versiones de ti mismo", "Resistir cambios de vida importantes", "Tomar decisiones el día del eclipse (espera 3 días)"],
    "ca": ["Aferrar-te a velles versions de tu mateix", "Resistir canvis de vida importants", "Prendre decisions el dia de l''eclipsi (espera 3 dies)"]
  }'::jsonb,
  10,
  'Path of totality: Greenland, Iceland, northern Spain'
);

-- Partial Lunar Eclipse - August 28, 2026
INSERT INTO special_astronomical_events (
  event_type,
  start_date,
  end_date,
  event_name,
  traditional_meaning,
  guidance,
  recommended_actions,
  avoid_actions,
  intensity,
  visibility
) VALUES (
  'lunar_eclipse_partial',
  '2026-08-28',
  NULL,
  '{
    "en": "Partial Lunar Eclipse",
    "es": "Eclipse Lunar Parcial",
    "ca": "Eclipsi Lunar Parcial"
  }'::jsonb,
  '{
    "en": "A partial lunar eclipse brings moderate but significant emotional shifts. Part of the Moon enters Earth''s shadow, symbolizing partial revelation of hidden emotional material.",
    "es": "Un eclipse lunar parcial trae cambios emocionales moderados pero significativos. Parte de la Luna entra en la sombra de la Tierra, simbolizando la revelación parcial de material emocional oculto.",
    "ca": "Un eclipsi lunar parcial porta canvis emocionals moderats però significatius. Part de la Lluna entra a l''ombra de la Terra, simbolitzant la revelació parcial de material emocional ocult."
  }'::jsonb,
  '{
    "en": "This eclipse brings gentle emotional insights. Not everything needs to be released completely - sometimes adjustment is enough. What emotional patterns need tweaking rather than transformation?",
    "es": "Este eclipse trae perspectivas emocionales suaves. No todo necesita ser liberado completamente - a veces el ajuste es suficiente. ¿Qué patrones emocionales necesitan ajuste en lugar de transformación?",
    "ca": "Aquest eclipsi porta insights emocionals suaus. No tot necessita ser alliberat completament - de vegades l''ajust és suficient. Quins patrons emocionals necessiten ajust en lloc de transformació?"
  }'::jsonb,
  '{
    "en": ["Gentle emotional release work", "Adjust emotional patterns rather than overhaul", "Journal about partial revelations"],
    "es": ["Trabajo suave de liberación emocional", "Ajusta patrones emocionales en lugar de renovar", "Escribe sobre revelaciones parciales"],
    "ca": ["Treball suau d''alliberament emocional", "Ajusta patrons emocionals en lloc de renovar", "Escriu sobre revelacions parcials"]
  }'::jsonb,
  '{
    "en": ["Forcing major emotional transformations", "Treating this like a total eclipse (it''s gentler)"],
    "es": ["Forzar transformaciones emocionales importantes", "Tratar esto como un eclipse total (es más suave)"],
    "ca": ["Forçar transformacions emocionals importants", "Tractar això com un eclipsi total (és més suau)"]
  }'::jsonb,
  6,
  'Global visibility'
);

-- Mercury Retrogrades 2026
INSERT INTO special_astronomical_events (event_type, start_date, end_date, event_name, traditional_meaning, guidance, recommended_actions, avoid_actions, intensity, visibility, zodiac_sign) VALUES
  ('mercury_retrograde', '2026-03-07', '2026-03-30', '{"en": "Mercury Retrograde in Aries/Pisces", "es": "Mercurio Retrógrado en Aries/Piscis", "ca": "Mercuri Retrògrad en Aries/Peixos"}'::jsonb, '{"en": "A time for reviewing communication, plans, and mental processes. Traditional astrology warned against new beginnings during this period.", "es": "Un tiempo para revisar comunicación, planes y procesos mentales. La astrología tradicional advirtió contra nuevos comienzos durante este período.", "ca": "Un temps per revisar comunicació, plans i processos mentals. L''astrologia tradicional va advertir contra nous començaments durant aquest període."}'::jsonb, '{"en": "Review, revise, and reconnect. Communication and technology may be unreliable.", "es": "Revisa, corrige y reconecta. La comunicación y la tecnología pueden ser poco confiables.", "ca": "Revisa, corregeix i reconnecta. La comunicació i la tecnologia poden ser poc fiables."}'::jsonb, '{"en": ["Review and revise projects", "Reconnect with past contacts", "Back up data"], "es": ["Revisa y corrige proyectos", "Reconecta con contactos pasados", "Respalda datos"], "ca": ["Revisa i corregeix projectes", "Reconnecta amb contactes passats", "Fes còpia de dades"]}'::jsonb, '{"en": ["Signing contracts", "Launching new projects", "Buying technology"], "es": ["Firmar contratos", "Lanzar nuevos proyectos", "Comprar tecnología"], "ca": ["Signar contractes", "Llançar nous projectes", "Comprar tecnologia"]}'::jsonb, 7, 'Global', 'aries'),
  ('mercury_retrograde', '2026-06-30', '2026-07-23', '{"en": "Mercury Retrograde in Leo/Cancer", "es": "Mercurio Retrógrado en Leo/Cáncer", "ca": "Mercuri Retrògrad en Leo/Càncer"}'::jsonb, '{"en": "Review creative and emotional communication patterns.", "es": "Revisa patrones de comunicación creativos y emocionales.", "ca": "Revisa patrons de comunicació creatius i emocionals."}'::jsonb, '{"en": "Time to review creative projects and emotional expression.", "es": "Tiempo para revisar proyectos creativos y expresión emocional.", "ca": "Temps per revisar projectes creatius i expressió emocional."}'::jsonb, '{"en": ["Revise creative work", "Review family communication"], "es": ["Revisa trabajo creativo", "Revisa comunicación familiar"], "ca": ["Revisa treball creatiu", "Revisa comunicació familiar"]}'::jsonb, '{"en": ["Launching creative projects", "Starting new romances"], "es": ["Lanzar proyectos creativos", "Comenzar nuevos romances"], "ca": ["Llançar projectes creatius", "Començar nous romanços"]}'::jsonb, 7, 'Global', 'leo'),
  ('mercury_retrograde', '2026-10-25', '2026-11-14', '{"en": "Mercury Retrograde in Scorpio", "es": "Mercurio Retrógrado en Escorpio", "ca": "Mercuri Retrògrad en Escorpi"}'::jsonb, '{"en": "Deep review of hidden matters and psychological patterns.", "es": "Revisión profunda de asuntos ocultos y patrones psicológicos.", "ca": "Revisió profunda d''assumptes ocults i patrons psicològics."}'::jsonb, '{"en": "Time for deep psychological review and revisiting secrets.", "es": "Tiempo para revisión psicológica profunda y revisitar secretos.", "ca": "Temps per revisió psicològica profunda i revisitar secrets."}'::jsonb, '{"en": ["Deep psychological work", "Review financial matters"], "es": ["Trabajo psicológico profundo", "Revisa asuntos financieros"], "ca": ["Treball psicològic profund", "Revisa assumptes financers"]}'::jsonb, '{"en": ["Starting therapy", "Major financial decisions"], "es": ["Comenzar terapia", "Decisiones financieras importantes"], "ca": ["Començar teràpia", "Decisions financeres importants"]}'::jsonb, 7, 'Global', 'scorpio');

-- =====================================================
-- 2027 EVENTS
-- =====================================================

-- Annular Solar Eclipse - February 6, 2027
INSERT INTO special_astronomical_events (event_type, start_date, event_name, traditional_meaning, guidance, recommended_actions, avoid_actions, intensity, visibility) VALUES
  ('solar_eclipse_annular', '2027-02-06', '{"en": "Annular Solar Eclipse (Ring of Fire)", "es": "Eclipse Solar Anular (Anillo de Fuego)", "ca": "Eclipsi Solar Anular (Anell de Foc)"}'::jsonb, '{"en": "Cycles returning, patterns repeating with new wisdom.", "es": "Ciclos que regresan, patrones que se repiten con nueva sabiduría.", "ca": "Cicles que tornen, patrons que es repeteixen amb nova saviesa."}'::jsonb, '{"en": "Recognize recurring patterns and apply lessons learned.", "es": "Reconoce patrones recurrentes y aplica lecciones aprendidas.", "ca": "Reconeix patrons recurrents i aplica lliçons apreses."}'::jsonb, '{"en": ["Identify life patterns", "Apply past wisdom"], "es": ["Identifica patrones de vida", "Aplica sabiduría pasada"], "ca": ["Identifica patrons de vida", "Aplica saviesa passada"]}'::jsonb, '{"en": ["Repeating old mistakes"], "es": ["Repetir viejos errores"], "ca": ["Repetir vells errors"]}'::jsonb, 8, 'South America, Antarctica'),
  ('solar_eclipse_total', '2027-08-02', '{"en": "Total Solar Eclipse", "es": "Eclipse Solar Total", "ca": "Eclipsi Solar Total"}'::jsonb, '{"en": "Complete transformation of identity and life direction.", "es": "Transformación completa de identidad y dirección de vida.", "ca": "Transformació completa d''identitat i direcció de vida."}'::jsonb, '{"en": "Total reset. Death and rebirth of the self.", "es": "Reinicio total. Muerte y renacimiento del yo.", "ca": "Reinici total. Mort i renaixement del jo."}'::jsonb, '{"en": ["Major life transformation ritual", "Release old identity completely"], "es": ["Ritual de transformación de vida importante", "Libera vieja identidad completamente"], "ca": ["Ritual de transformació de vida important", "Allibera vella identitat completament"]}'::jsonb, '{"en": ["Clinging to the past", "Resisting change"], "es": ["Aferrarse al pasado", "Resistir el cambio"], "ca": ["Aferrar-se al passat", "Resistir el canvi"]}'::jsonb, 10, 'North Africa, Middle East, South Asia');

-- Penumbral Lunar Eclipses 2027 (lower intensity)
INSERT INTO special_astronomical_events (event_type, start_date, event_name, traditional_meaning, guidance, recommended_actions, avoid_actions, intensity, visibility) VALUES
  ('lunar_eclipse_penumbral', '2027-02-20', '{"en": "Penumbral Lunar Eclipse", "es": "Eclipse Lunar Penumbral", "ca": "Eclipsi Lunar Penumbral"}'::jsonb, '{"en": "Subtle emotional shifts barely visible to the eye.", "es": "Cambios emocionales sutiles apenas visibles al ojo.", "ca": "Canvis emocionals subtils gairebé visibles a l''ull."}'::jsonb, '{"en": "Gentle emotional awareness. Subtle shifts in feeling.", "es": "Conciencia emocional suave. Cambios sutiles en sentimientos.", "ca": "Consciència emocional suau. Canvis subtils en sentiments."}'::jsonb, '{"en": ["Notice subtle feelings", "Gentle reflection"], "es": ["Nota sentimientos sutiles", "Reflexión suave"], "ca": ["Nota sentiments subtils", "Reflexió suau"]}'::jsonb, '{"en": ["Forcing major changes"], "es": ["Forzar cambios importantes"], "ca": ["Forçar canvis importants"]}'::jsonb, 4, 'Global'),
  ('lunar_eclipse_penumbral', '2027-07-18', '{"en": "Penumbral Lunar Eclipse", "es": "Eclipse Lunar Penumbral", "ca": "Eclipsi Lunar Penumbral"}'::jsonb, '{"en": "Subtle emotional insights.", "es": "Perspectivas emocionales sutiles.", "ca": "Insights emocionals subtils."}'::jsonb, '{"en": "Gentle awareness of emotional undercurrents.", "es": "Conciencia suave de corrientes emocionales subyacentes.", "ca": "Consciència suau de corrents emocionals subjacents."}'::jsonb, '{"en": ["Observe emotions gently"], "es": ["Observa emociones suavemente"], "ca": ["Observa emocions suaument"]}'::jsonb, '{"en": ["Overreacting"], "es": ["Reaccionar exageradamente"], "ca": ["Reaccionar exageradament"]}'::jsonb, 4, 'Global'),
  ('lunar_eclipse_penumbral', '2027-08-17', '{"en": "Penumbral Lunar Eclipse", "es": "Eclipse Lunar Penumbral", "ca": "Eclipsi Lunar Penumbral"}'::jsonb, '{"en": "Subtle emotional completion.", "es": "Finalización emocional sutil.", "ca": "Finalització emocional subtil."}'::jsonb, '{"en": "Gentle closure of emotional cycles.", "es": "Cierre suave de ciclos emocionales.", "ca": "Tancament suau de cicles emocionals."}'::jsonb, '{"en": ["Gentle release"], "es": ["Liberación suave"], "ca": ["Alliberament suau"]}'::jsonb, '{"en": ["Forcing drama"], "es": ["Forzar drama"], "ca": ["Forçar drama"]}'::jsonb, 4, 'Global');

-- Mercury Retrogrades 2027
INSERT INTO special_astronomical_events (event_type, start_date, end_date, event_name, traditional_meaning, guidance, recommended_actions, avoid_actions, intensity, visibility, zodiac_sign) VALUES
  ('mercury_retrograde', '2027-02-18', '2027-03-11', '{"en": "Mercury Retrograde in Pisces", "es": "Mercurio Retrógrado en Piscis", "ca": "Mercuri Retrògrad en Peixos"}'::jsonb, '{"en": "Review intuitive and spiritual communication.", "es": "Revisa comunicación intuitiva y espiritual.", "ca": "Revisa comunicació intuitiva i espiritual."}'::jsonb, '{"en": "Time to review spiritual practices and intuitive messages.", "es": "Tiempo para revisar prácticas espirituales y mensajes intuitivos.", "ca": "Temps per revisar pràctiques espirituals i missatges intuitius."}'::jsonb, '{"en": ["Review spiritual practices", "Reconnect with intuition"], "es": ["Revisa prácticas espirituales", "Reconecta con intuición"], "ca": ["Revisa pràctiques espirituals", "Reconnecta amb intuïció"]}'::jsonb, '{"en": ["Starting new spiritual paths", "Trusting visions without review"], "es": ["Comenzar nuevos caminos espirituales", "Confiar en visiones sin revisar"], "ca": ["Començar nous camins espirituals", "Confiar en visions sense revisar"]}'::jsonb, 7, 'Global', 'pisces'),
  ('mercury_retrograde', '2027-06-13', '2027-07-06', '{"en": "Mercury Retrograde in Cancer", "es": "Mercurio Retrógrado en Cáncer", "ca": "Mercuri Retrògrad en Càncer"}'::jsonb, '{"en": "Review family communication and emotional expression.", "es": "Revisa comunicación familiar y expresión emocional.", "ca": "Revisa comunicació familiar i expressió emocional."}'::jsonb, '{"en": "Time to revisit family matters and emotional communication.", "es": "Tiempo para revisitar asuntos familiares y comunicación emocional.", "ca": "Temps per revisitar assumptes familiars i comunicació emocional."}'::jsonb, '{"en": ["Review family dynamics", "Reconnect with relatives"], "es": ["Revisa dinámicas familiares", "Reconecta con familiares"], "ca": ["Revisa dinàmiques familiars", "Reconnecta amb familiars"]}'::jsonb, '{"en": ["Starting new homes/families", "Major family decisions"], "es": ["Comenzar nuevos hogares/familias", "Decisiones familiares importantes"], "ca": ["Començar nous llars/famílies", "Decisions familiars importants"]}'::jsonb, 7, 'Global', 'cancer'),
  ('mercury_retrograde', '2027-10-08', '2027-10-28', '{"en": "Mercury Retrograde in Scorpio/Libra", "es": "Mercurio Retrógrado en Escorpio/Libra", "ca": "Mercuri Retrògrad en Escorpi/Balança"}'::jsonb, '{"en": "Review relationships and deep psychological patterns.", "es": "Revisa relaciones y patrones psicológicos profundos.", "ca": "Revisa relacions i patrons psicològics profunds."}'::jsonb, '{"en": "Time to review relationships and hidden dynamics.", "es": "Tiempo para revisar relaciones y dinámicas ocultas.", "ca": "Temps per revisar relacions i dinàmiques ocultes."}'::jsonb, '{"en": ["Review relationship patterns", "Examine power dynamics"], "es": ["Revisa patrones de relación", "Examina dinámicas de poder"], "ca": ["Revisa patrons de relació", "Examina dinàmiques de poder"]}'::jsonb, '{"en": ["Starting new partnerships", "Major relationship decisions"], "es": ["Comenzar nuevas asociaciones", "Decisiones de relación importantes"], "ca": ["Començar noves associacions", "Decisions de relació importants"]}'::jsonb, 7, 'Global', 'scorpio');

-- Verification query
SELECT
  event_type,
  start_date,
  COALESCE(end_date::text, 'Single day') as duration,
  COALESCE(event_name->>'en', 'Unnamed') as name,
  intensity,
  COALESCE(zodiac_sign::text, 'N/A') as sign
FROM special_astronomical_events
ORDER BY start_date;
