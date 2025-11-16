# Sistema de Guies Lunars - Arquitectura Completa

## Visió General

Sistema modular de composició de guies lunars diàries basades **estrictament** en tradicions astrològiques verificables. **Cost: $0** (sense IA externa). **Varietat: Infinita** (a través de combinacions cícliques naturals).

---

## Principis Fonamentals

### ✅ QUÈ SÍ FEM

- **Fonamentació estricta**: Tot el contingut basat en tradicions astrològiques verificables
- **Fonts citades**: Cada element té fonts acadèmiques o tradicionals
- **Composició modular**: Combinar elements base amb overlays estacionals, energies diàries, i esdeveniments especials
- **Cicles naturals**: Aprofitar els cicles astronòmics reals per crear varietat infinita
- **Cost zero**: Contingut pre-escrit per Claude, sense APIs externes

### ❌ QUÈ NO FEM

- **NO inventem tradicions**: Prohibit crear simbolisme sense fonamentació
- **NO utilitzem OpenAI**: Eliminat completament del sistema
- **NO generem contingut aleatori**: Tot és determinístic basat en data i posicions astronòmiques

---

## Arquitectura del Sistema

### Nivell 1: Elements Base (32 Templates)

**Taula:** `lunar_guide_templates`
**Quantitat:** 32 templates (8 fases lunars × 4 elements)
**Status:** ✅ Ja existeix i està poblada

**Estructura:**
- 8 fases lunars: New Moon, Waxing Crescent, First Quarter, Waxing Gibbous, Full Moon, Waning Gibbous, Last Quarter, Waning Crescent
- 4 elements: Fire, Earth, Air, Water
- Cada template conté:
  - Headline, tagline, energy description (multilingual: en, es, ca)
  - Focus areas (keywords)
  - Recommended actions
  - Correspon a un element específic (opcional: zodiac sign per templates zodíac-específics)

**Prioritat de templates:**
1. Zodiac-specific (priority 2): Template per a fase + signe zodiacal específic
2. Element-specific (priority 1): Template per a fase + element
3. Generic (priority 0): Template per a fase (sense element ni zodíac)

---

### Nivell 2: Overlays Estacionals (128 Overlays)

**Taula:** `seasonal_overlays`
**Quantitat:** 128 overlays (32 templates × 4 estacions)
**Fonamentació:** Wheel of the Year (8 sabbats + 4 estacions astrològiques)

**Estructura:**
```sql
seasonal_overlays {
  template_id: UUID (referència a lunar_guide_templates)
  season: ENUM ('spring', 'summer', 'autumn', 'winter')
  overlay_headline: JSONB {en, es, ca}
  overlay_description: JSONB {en, es, ca}
  energy_shift: JSONB {en, es, ca}
  themes: JSONB {en: [], es: [], ca: []}
  seasonal_actions: JSONB {en: [], es: [], ca: []}
}
```

**Les 4 Estacions Astrològiques:**

1. **PRIMAVERA** (21 març - 20 juny)
   - **Signes:** Aries (Foc), Taurus (Terra), Gemini (Aire)
   - **Modalitats:** Cardinal → Fix → Mutable
   - **Arquetip:** La Donzella, la Llavor, el Nen
   - **Energia:** Expansió, creixement, renovació, inici
   - **Temes:** Nous començaments, esperança, potencial, joventut
   - **Sabbats:** Ostara (equinocci de primavera, 21 març), Beltane (1 maig)

2. **ESTIU** (21 juny - 22 setembre)
   - **Signes:** Cancer (Aigua), Leo (Foc), Virgo (Terra)
   - **Modalitats:** Cardinal → Fix → Mutable
   - **Arquetip:** La Mare, la Flor en Plena Floració, l'Adult
   - **Energia:** Culminació, plenitud, abundància, llum màxima
   - **Temes:** Nutrició, celebració, creativitat, protecció
   - **Sabbats:** Litha (solstici d'estiu, 21 juny), Lughnasadh (1 agost)

3. **TARDOR** (23 setembre - 20 desembre)
   - **Signes:** Libra (Aire), Scorpio (Aigua), Sagittarius (Foc)
   - **Modalitats:** Cardinal → Fix → Mutable
   - **Arquetip:** La Crone, la Collita, l'Avi
   - **Energia:** Declivi, preparació, saviesa, deixar anar
   - **Temes:** Gratitud, transformació, mort/renaixement, saviesa
   - **Sabbats:** Mabon (equinocci de tardor, 23 setembre), Samhain (31 octubre)

4. **HIVERN** (21 desembre - 20 març)
   - **Signes:** Capricorn (Terra), Aquarius (Aire), Pisces (Aigua)
   - **Modalitats:** Cardinal → Fix → Mutable
   - **Arquetip:** L'Ancià, la Llavor Adormida, l'Esperit
   - **Energia:** Introspeccio, descans, mort, incubació
   - **Temes:** Reflexió, silenci, saviesa interior, esperança en foscor
   - **Sabbats:** Yule (solstici d'hivern, 21 desembre), Imbolc (1 febrer)

**Com s'apliquen:**
Cada seasonal overlay modifica lleugerament el template base per reflectir l'energia de l'estació:
- **Primavera + Waxing Crescent:** "Els primers brots de la lluna creixent s'alineen amb l'explosió de vida primaveral"
- **Hivern + Waning Crescent:** "L'última llum abans de la nova lluna ressona amb el silenci profund de l'hivern"

---

### Nivell 3: Energies Setmanals (7 Weekday Energies)

**Taula:** `weekday_energies`
**Quantitat:** 7 energies (dilluns-diumenge)
**Fonamentació:** Ordre Caldeu (astrologia babilònica/hel·lenística, 2000+ anys)

**Estructura:**
```sql
weekday_energies {
  weekday: ENUM ('sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday')
  planet: ENUM ('sun', 'moon', 'mars', 'mercury', 'jupiter', 'venus', 'saturn')
  element: element_type
  qualities: JSONB {polarity, temperature, moisture}
  description: JSONB {en, es, ca}
  traditional_meaning: JSONB {en, es, ca}
  areas_of_influence: JSONB {en: [], es: [], ca: []}
  favorable_activities: JSONB {en: [], es: [], ca: []}
  color: TEXT
  metal: TEXT
  stones: JSONB []
  herbs: JSONB []
}
```

**Les 7 Energies:**

1. **DIUMENGE - SOL ☀️**
   - Element: Foc | Qualitats: Calor, Sec, Yang
   - Temes: Vitalitat, ego, autoritat, creativitat, propòsit
   - Favorable: Ritual de confiança, reconeixement, planificació important

2. **DILLUNS - LLUNA 🌙**
   - Element: Aigua | Qualitats: Fred, Humit, Yin
   - Temes: Emocions, intuïció, memòria, nutrició, cicles
   - Favorable: Treball amb somnis, neteja emocional, connexió familiar

3. **DIMARTS - MART ♂️**
   - Element: Foc | Qualitats: Calor, Sec, Yang
   - Temes: Acció, coratge, conflicte, passió, independència
   - Favorable: Ritual de coratge, establir límits, projectes d'acció

4. **DIMECRES - MERCURI ☿**
   - Element: Aire | Qualitats: Neutre, Adaptable
   - Temes: Comunicació, intel·lecte, comerç, viatges curts
   - Favorable: Escriure, estudiar, negociar, organitzar

5. **DIJOUS - JÚPITER ♃**
   - Element: Foc | Qualitats: Calor, Humit
   - Temes: Expansió, saviesa, justícia, generositat, fe
   - Favorable: Ritual d'abundància, estudis superiors, gratitud

6. **DIVENDRES - VENUS ♀**
   - Element: Terra/Aigua (dual) | Qualitats: Fred, Humit, Yin
   - Temes: Amor, bellesa, plaer, valors, pau
   - Favorable: Ritual d'amor, crear bellesa, socialitzar

7. **DISSABTE - SATURN ♄**
   - Element: Terra | Qualitats: Fred, Sec, Yin
   - Temes: Estructura, límits, responsabilitat, temps, saviesa
   - Favorable: Planificació llarg termini, organització, límits saludables

**Com s'apliquen:**
Cada dia de la setmana afegeix una capa addicional d'energia:
- **Dilluns + Full Moon:** "La lluna plena en el seu propi dia amplifica les marees emocionals"
- **Divendres + Waxing Moon in Taurus:** "Venus governa divendres i Taurus - doble èmfasi en bellesa i plaer"

---

### Nivell 4: Esdeveniments Astronòmics Especials (Variable)

**Taula:** `special_astronomical_events`
**Quantitat:** Variable (poblada amb esdeveniments 2025-2030+)
**Fonamentació:** Tradicions antigues (eclipsis, retrògrads) + fenòmens moderns verificables (supermoon, blue moon)

**Tipus d'esdeveniments:**

**Eclipsis (Tradició: Mesopotàmia/Hel·lenística)**
- Solar Total, Parcial, Anular
- Lunar Total, Parcial, Penumbral
- Intensitat: 8-10
- Significat: Canvis profunds, transformació, destí

**Fenòmens Lunars Moderns**
- Supermoon (terme modern 1979, fenomen real)
- Blue Moon (folklore americà modern post-1946)
- Intensitat: 4-6
- Significat: Amplificació, raresa, segones oportunitats

**Retrògrads (Tradició: Astrologia Horària Medieval)**
- Mercury, Venus, Mars (també Jupiter, Saturn)
- Intensitat: 6-8
- Significat: Revisió, reconsideració, precaució amb nous començaments

**Estructura:**
```sql
special_astronomical_events {
  event_type: astronomical_event_type
  start_date: DATE
  end_date: DATE (nullable per esdeveniments d'un dia)
  event_name: JSONB {en, es, ca}
  traditional_meaning: JSONB {en, es, ca}
  guidance: JSONB {en, es, ca}
  recommended_actions: JSONB {en: [], es: [], ca: []}
  avoid_actions: JSONB {en: [], es: [], ca: []}
  intensity: INTEGER (1-10)
  visibility: TEXT
  zodiac_sign: zodiac_sign_type
}
```

**Com s'apliquen:**
Si la data de la guia coincideix amb un esdeveniment especial actiu:
- Afegir secció "Special Event" a la guia
- Modificar recomanacions segons l'esdeveniment
- Ajustar to (més intens per eclipsis, més caute per retrògrads)

---

## Sistema de Composició

### Edge Function: `generate-daily-lunar-insight`

**Input:** Data (YYYY-MM-DD)

**Procés de Composició:**

```
1. CALCULAR DADES ASTRONÒMIQUES
   - Fase lunar (0-1) → phase_id (new_moon, waxing_crescent, etc.)
   - Signe zodiacal del Sol
   - Element del signe zodiacal
   - Dia de la setmana

2. BUSCAR TEMPLATE BASE
   Prioritat de fallback:
   a) Template zodíac-específic (phase_id + zodiac_sign)
   b) Template element-específic (phase_id + element)
   c) Template genèric (phase_id)

3. BUSCAR SEASONAL OVERLAY
   - Determinar estació segons data
   - Buscar overlay per (template_id + season)

4. BUSCAR WEEKDAY ENERGY
   - Buscar energia per dia de la setmana

5. BUSCAR SPECIAL EVENTS (si n'hi ha)
   - Query: events actius en aquesta data
   - Ordenar per intensitat (DESC)

6. COMPONDRE GUIA FINAL
   Base Template
   + Seasonal Overlay (modifica headline, afegeix temes estacionals)
   + Weekday Energy (afegeix nota sobre energia planetària del dia)
   + Special Events (si n'hi ha, afegir seccions especials)

7. GUARDAR A daily_lunar_insights
   - Guardar referències (template_id, seasonal_overlay_id, weekday, special_event_ids)
   - Marcar composed_at timestamp
   - Versió de composició
```

**Output:** LunarGuide complet amb tots els nivells integrats

---

## Taula de Composició Final

**Taula:** `daily_lunar_insights`
**Funció:** Emmagatzemar la composició final de cada dia

**Estructura ACTUALITZADA:**
```sql
daily_lunar_insights {
  id: UUID
  date: DATE (UNIQUE)

  -- Referències a components
  phase_id: phase_type
  template_id: UUID → lunar_guide_templates
  seasonal_overlay_id: UUID → seasonal_overlays
  weekday: weekday_type
  zodiac_sign: zodiac_sign_type
  special_event_ids: UUID[] → special_astronomical_events

  -- Metadata de composició
  composed_at: TIMESTAMPTZ
  composition_version: TEXT

  -- ELIMINAT: ai_universal_insight, ai_specific_insight, openai_model, tokens_used
}
```

---

## Matemàtica de Combinacions

### Combinacions Úniques Possibles

**Base:**
- 8 fases lunars
- 4 elements
- 4 estacions
- 7 dies de la setmana

**Total combinacions base:**
`8 fases × 4 elements × 4 estacions × 7 dies = 896 combinacions úniques`

**Amb esdeveniments especials:**
- ~10-15 esdeveniments especials actius per any
- Cada esdeveniment pot durar de 1 dia (eclipsi) a 3 setmanes (retrògrad)

**Combinacions totals amb events:**
`896 × (1 + events actius) = 1000+ combinacions`

### Cicles Naturals (Varietat Infinita)

- **Lluna:** 29.53 dies per cicle complet
- **Zodíac:** ~30 dies per signe (12 signes = 365 dies)
- **Estacions:** ~91 dies per estació (4 estacions = 365 dies)
- **Setmana:** 7 dies per cicle

**Resultat:** Cada dia obté una combinació única que NEVER repeteix exactament (la mateixa fase lunar + mateix signe + mateixa estació + mateix dia de setmana només coincideix cada ~19 anys aprox, i encara així amb diferències per esdeveniments especials).

---

## Flux de Dades

```
USER REQUEST
    ↓
Flutter App (GuideTab)
    ↓
LunarGuideService.getTodaysGuide()
    ↓
    ├─→ Check local cache (SharedPreferences)
    │   └─→ If cached & valid → Return cached guide
    │
    └─→ If not cached:
        ↓
    Supabase Query: daily_lunar_insights (WHERE date = today)
        ↓
        ├─→ If exists → Fetch template, overlay, weekday, events
        │   └─→ Compose LunarGuide → Cache → Return
        │
        └─→ If not exists:
            ↓
        Edge Function: generate-daily-lunar-insight (cron or on-demand)
            ↓
        [Composition Process - see above]
            ↓
        Insert into daily_lunar_insights
            ↓
        Return to Flutter
            ↓
        Cache locally
            ↓
        Display to user
```

---

## Exemples de Composició

### Exemple 1: Dia Normal

**Data:** 15 març 2025 (dissabte)
**Fase Lunar:** First Quarter (0.27)
**Signe Solar:** Pisces
**Element:** Water
**Estació:** Winter (encara, abans del 21 març)
**Esdeveniments Especials:** Mercury Retrograde (15 març - 7 abril)

**Composició:**
```
BASE TEMPLATE:
  Phase: First Quarter
  Element: Water
  Headline: "Nurture the seeds you've planted"
  Energy: "Time of action balanced with emotion"

+ SEASONAL OVERLAY (Winter):
  Overlay: "In the quiet of winter, your actions take root in silence"
  Themes: [reflection, inner work, patience]

+ WEEKDAY ENERGY (Saturday - Saturn):
  Note: "Saturn's day calls for structure and long-term planning"
  Favorable: [organizing, setting boundaries, elder wisdom]

+ SPECIAL EVENT (Mercury Retrograde):
  Alert: "Mercury is retrograde - review and revise"
  Avoid: [starting new projects, signing contracts]
  Favor: [reconnecting with past, reviewing plans]

= FINAL GUIDE:
  "🌓 Nurture the seeds you've planted - In Winter's Quiet Reflection

  Today's Energy: Time of action balanced with emotion. In the quiet
  of winter, your actions take root in silence. Saturn's structured
  energy on Saturday supports deep planning and organization.

  ⚠️ Mercury Retrograde Active: This is a time for review, not new
  beginnings. Reconnect with past projects and revise your plans.

  Recommended Actions:
  • Review and organize long-term goals
  • Reconnect with old contacts or projects
  • Set healthy boundaries
  • Practice patience with communication delays"
```

### Exemple 2: Dia amb Eclipsi

**Data:** 7 setembre 2025 (diumenge)
**Fase Lunar:** Full Moon (eclipsi lunar total)
**Signe Solar:** Virgo
**Element:** Earth
**Estació:** Autumn (després del 23 setembre, estaria a tardor, però setembre encara és estiu fins dia 22)
**Esdeveniments Especials:** Total Lunar Eclipse (intensity: 10)

**Composició:**
```
BASE TEMPLATE:
  Phase: Full Moon
  Element: Earth
  Headline: "Harvest the fruits of your labor"
  Energy: "Culmination and manifestation"

+ SEASONAL OVERLAY (Summer, encara):
  Overlay: "Summer's abundance reaches its peak"
  Themes: [celebration, gratitude, fullness]

+ WEEKDAY ENERGY (Sunday - Sun):
  Note: "The Sun's day amplifies vitality and purpose"
  Favorable: [recognition, creative expression, leadership]

+ SPECIAL EVENT (Total Lunar Eclipse):
  🌕🌑 POWERFUL EVENT:
  "Total Lunar Eclipse - A moment of profound transformation"
  Guidance: "Eclipses mark destiny points. What needs to end to make
  space for rebirth? This is not a regular Full Moon - this is a
  cosmic reset button."

  Intensity: 10/10 - Life-changing potential

  Recommended:
  • Deep emotional release work
  • Honor what's ending
  • Prepare for major life shifts
  • Avoid: Making impulsive decisions in the heat of emotion

= FINAL GUIDE:
  "🌕 TOTAL LUNAR ECLIPSE - Profound Transformation

  🔥 INTENSITY ALERT: This is not a regular Full Moon. A Total Lunar
  Eclipse creates a cosmic portal for deep transformation.

  Today's Energy: Culmination and manifestation meet summer's peak
  abundance. The Sun's day (Sunday) amplifies this already powerful
  energy.

  Eclipse Guidance: What chapter of your life is ending? Eclipses
  mark destiny points where we cannot turn back. Honor the harvest
  of summer, but prepare for profound release. Effects will be felt
  for 6 months.

  Recommended Actions:
  • Emotional release ceremony
  • Journal about what you're ready to let go
  • Honor your achievements before releasing them
  • Meditate on the theme of death and rebirth

  Avoid Today:
  • Making impulsive life decisions
  • Forcing outcomes - let the eclipse do its work"
```

---

## Roadmap d'Implementació

### ✅ FASE 1: INVESTIGACIÓ (COMPLETADA)
- [x] planetary_weekday_correspondences.md
- [x] wheel_of_the_year.md
- [x] astronomical_events.md

### ✅ FASE 2: DATABASE SCHEMA (COMPLETADA)
- [x] Migració: seasonal_overlays
- [x] Migració: weekday_energies
- [x] Migració: special_astronomical_events
- [x] Migració: update daily_lunar_insights

### 📝 FASE 3: CONTINGUT (EN CURS)
- [ ] 128 seasonal overlays (seed migration)
- [ ] 7 weekday energies (seed migration)
- [ ] Special events 2025-2027 (seed migration)

### 🔧 FASE 4: EDGE FUNCTION
- [ ] Eliminar openai-generator.ts
- [ ] Crear content-composer.ts
- [ ] Actualitzar index.ts amb lògica de composició

### 📱 FASE 5: FLUTTER CLIENT
- [ ] Models: SeasonalOverlay, WeekdayEnergy, SpecialEvent
- [ ] Actualitzar DailyLunarInsight model
- [ ] Actualitzar LunarGuideService
- [ ] Actualitzar GuideTab UI per mostrar events

### ✅ FASE 6: TESTING
- [ ] Unit tests composició
- [ ] Generar 30 dies consecutius
- [ ] Verificar varietat

### 🚀 FASE 7: DESPLEGAMENT
- [ ] Apply migrations a Supabase
- [ ] Deploy Edge Function
- [ ] Remove OPENAI_API_KEY
- [ ] Git commit & push

---

## Referències i Documentació

**Documents de Recerca:**
- `docs/planetary_weekday_correspondences.md` - Fonamentació dels 7 dies
- `docs/wheel_of_the_year.md` - Fonamentació de les 4 estacions
- `docs/astronomical_events.md` - Fonamentació d'esdeveniments especials
- `docs/lunar_astrology_reference.md` - Referència original de fases lunars

**Codi Existent:**
- `lunar_guide_templates` - 32 templates base (ja existeix)
- Edge Function - `generate-daily-lunar-insight/` (a refactoritzar)
- Flutter models & services (a actualitzar)

---

**Document creat:** 2025-11-15
**Versió:** 1.0
**Status:** Arquitectura completa definida, implementació en curs
