# Lunar Academy - Arquitectura Completa

**Data de creació:** 2025-11-17
**Status:** En implementació
**Propòsit:** Plataforma educativa completa sobre astrologia lunar i tarot

---

## 🎯 Visió General

La Lunar Academy és un espai d'aprenentatge dins l'app que combina:
- **Tradició verificable** - Contingut basat en fonts històriques i tradicions reals
- **Didàctica accessible** - Explicacions clares i humanes
- **Pràctica aplicable** - Connexió directa amb les lectures de tarot i la vida quotidiana

---

## 📚 Estructura de Continguts

### 1. **Lunar Phases** (8 Fases) ✅ IMPLEMENTAT

**Contingut:**
- New Moon (Lluna Nova)
- Waxing Crescent (Creixent)
- First Quarter (Primer Quart)
- Waxing Gibbous (Gibosa Creixent)
- Full Moon (Lluna Plena)
- Waning Gibbous (Gibosa Minvant)
- Last Quarter (Últim Quart)
- Waning Crescent (Minvant Final)

**Font:** `lunar_guide_system_architecture.md`, `lunar_astrology_reference.md`
**Status:** Completat amb templates a base de dades
**Pantalla:** `lunar_phases_screen.dart` + `lunar_phase_detail_screen.dart`

---

### 2. **Seasonal Wisdom** (4 Estacions + 8 Sabbats) 🔄 EN PROGRÉS

**Contingut Principal:**

#### 🌱 Primavera (Spring)
- **Sabbats:** Ostara (Equinocci), Beltane
- **Signes:** Aries, Taurus, Gemini
- **Elements:** Foc → Terra → Aire
- **Arquetip:** La Donzella, la Llavor
- **Temes:** Nous començaments, creixement, esperança

#### ☀️ Estiu (Summer)
- **Sabbats:** Litha (Solstici), Lughnasadh
- **Signes:** Cancer, Leo, Virgo
- **Elements:** Aigua → Foc → Terra
- **Arquetip:** La Mare, la Flor
- **Temes:** Abundància, culminació, nutrició

#### 🍁 Tardor (Autumn)
- **Sabbats:** Mabon (Equinocci), Samhain
- **Signes:** Libra, Scorpio, Sagittarius
- **Elements:** Aire → Aigua → Foc
- **Arquetip:** La Crone, la Collita
- **Temes:** Gratitud, transformació, saviesa

#### ❄️ Hivern (Winter)
- **Sabbats:** Yule (Solstici), Imbolc
- **Signes:** Capricorn, Aquarius, Pisces
- **Elements:** Terra → Aire → Aigua
- **Arquetip:** L'Ancià, la Llavor Adormida
- **Temes:** Descans, reflexió, renovació interior

**Els 8 Sabbats:**
1. **Yule** (Solstici d'Hivern, ~21 Des) - Renaixement del Sol
2. **Imbolc** (~1-2 Feb) - Primers signes de primavera
3. **Ostara** (Equinocci de Primavera, ~21 Mar) - ANY NOU ASTROLÒGIC
4. **Beltane** (~1 Mai) - Plenitud de primavera
5. **Litha** (Solstici d'Estiu, ~21 Juny) - Dia més llarg
6. **Lughnasadh** (~1 Ago) - Primera collita
7. **Mabon** (Equinocci de Tardor, ~23 Set) - Segona collita
8. **Samhain** (~31 Oct) - ANY NOU CELTA, tercera collita

**Font:** `wheel_of_the_year.md` (13KB, complet i verificat)
**Status:** Per implementar
**Pantalla proposada:** `seasonal_wisdom_screen.dart` amb navegació a cada estació i sabbat

---

### 3. **Planetary Days** (7 Dies Planetaris) 🔄 PENDENT

**Contingut:**

#### 🌞 Diumenge - SOL
- **Element:** Foc
- **Temes:** Vitalitat, identitat, creativitat, lideratge
- **Activitats:** Augmentar confiança, obtenir reconeixement
- **Color:** Daurat, groc brillant
- **Tarot:** The Sun, carta 19

#### 🌙 Dilluns - LLUNA
- **Element:** Aigua
- **Temes:** Emocions, intuïció, memòria, nutrició
- **Activitats:** Treball amb somnis, endevinació, neteja emocional
- **Color:** Plata, blanc perla
- **Tarot:** The Moon, carta 18

#### ♂️ Dimarts - MART
- **Element:** Foc
- **Temes:** Acció, coratge, passió, independència
- **Activitats:** Establir límits, començar projectes que requereixin acció
- **Color:** Vermell
- **Tarot:** The Tower (Mart tradicional)

#### ☿ Dimecres - MERCURI
- **Element:** Aire
- **Temes:** Comunicació, intel·lecte, aprenentatge, comerç
- **Activitats:** Escriure, estudiar, negociar
- **Color:** Taronja, groc clar
- **Tarot:** The Magician, carta 1

#### ♃ Dijous - JÚPITER
- **Element:** Foc
- **Temes:** Expansió, saviesa, justícia, generositat
- **Activitats:** Atraure abundància, estudis superiors
- **Color:** Porpra, blau reial
- **Tarot:** Wheel of Fortune, carta 10

#### ♀ Divendres - VENUS
- **Element:** Terra i Aigua
- **Temes:** Amor, bellesa, plaer, harmonia
- **Activitats:** Ritual d'amor, crear bellesa, socialitzar
- **Color:** Verd, rosa
- **Tarot:** The Empress, carta 3

#### ♄ Dissabte - SATURN
- **Element:** Terra
- **Temes:** Estructura, disciplina, temps, responsabilitat
- **Activitats:** Planificació llarg termini, organització
- **Color:** Negre, gris, marró fosc
- **Tarot:** The World, carta 21

**Tradició:** Ordre Caldeu (Saturn → Jupiter → Mars → Sol → Venus → Mercury → Lluna)
**Font:** `planetary_weekday_correspondences.md` (9.3KB)
**Status:** Per implementar
**Pantalla proposada:** `planetary_days_screen.dart` amb detall per cada dia

---

### 4. **Lunar Elements** (4 Elements) 🔄 PENDENT

**Contingut:**

#### 🔥 FOC (Fire)
- **Signes:** Aries, Leo, Sagittarius
- **Qualitats:** Calent, Sec, Ardent
- **Característiques:** Passió, acció, creativitat, coratge
- **Modalitats:**
  - Aries: Cardinal (iniciador)
  - Leo: Fix (estable)
  - Sagittarius: Mutable (adaptable)
- **Quan la Lluna passa per Foc:** Temps per acció valenta, començar projectes
- **Tarot:** Bastos (Wands)

#### 🌍 TERRA (Earth)
- **Signes:** Taurus, Virgo, Capricorn
- **Qualitats:** Pesada, Freda, Seca
- **Característiques:** Pràctic, estable, sensorial, manifestació
- **Modalitats:**
  - Taurus: Fix (estable)
  - Virgo: Mutable (adaptable)
  - Capricorn: Cardinal (iniciador)
- **Quan la Lluna passa per Terra:** Temps per manifestar, ser pràctic
- **Tarot:** Oros (Pentacles)

#### 💨 AIRE (Air)
- **Signes:** Gemini, Libra, Aquarius
- **Qualitats:** Lleuger, Calent, Humit
- **Característiques:** Intel·lectual, comunicació, curiositat, social
- **Modalitats:**
  - Gemini: Mutable (adaptable)
  - Libra: Cardinal (iniciador)
  - Aquarius: Fix (estable)
- **Quan la Lluna passa per Aire:** Temps per comunicar, pensar, connectar
- **Tarot:** Espases (Swords)

#### 💧 AIGUA (Water)
- **Signes:** Cancer, Scorpio, Pisces
- **Qualitats:** Fred, Humit, Suau
- **Característiques:** Emocional, intuïtiu, sensible, profund
- **Modalitats:**
  - Cancer: Cardinal (iniciador)
  - Scorpio: Fix (estable)
  - Pisces: Mutable (adaptable)
- **Quan la Lluna passa per Aigua:** Temps per sentir, intuir, connectar emocionalment
- **Tarot:** Copes (Cups)

**Font:** `lunar_astrology_reference.md`
**Status:** Per implementar
**Pantalla proposada:** `lunar_elements_screen.dart` amb connexió a tarot

---

### 5. **Moon in Signs** (12 Signes Zodiacals) 🔄 PENDENT

**Contingut per cada signe:**

**Estructura didàctica:**
- **Dates aproximades** (quan el sol travessa)
- **Element i Modalitat**
- **Arquetip del signe**
- **Quan la Lluna està en aquest signe:**
  - Com afecta les emocions
  - Millors activitats
  - Rituals recomanats
  - Connexió amb tarot

**Exemple: Lluna en Aries**
- **Element:** Foc
- **Modalitat:** Cardinal (iniciador)
- **Arquetip:** El Guerrer, el Pioneer
- **Emocions:** Impulsives, valentes, independents
- **Activitats:** Començar projectes nous, actuar amb coratge
- **Tarot:** The Emperor (Aries tradicional)

**Els 12 Signes:**
1. Aries ♈ (21 Mar - 19 Apr) - Foc Cardinal
2. Taurus ♉ (20 Apr - 20 Mai) - Terra Fix
3. Gemini ♊ (21 Mai - 20 Jun) - Aire Mutable
4. Cancer ♋ (21 Jun - 22 Jul) - Aigua Cardinal
5. Leo ♌ (23 Jul - 22 Ago) - Foc Fix
6. Virgo ♍ (23 Ago - 22 Set) - Terra Mutable
7. Libra ♎ (23 Set - 22 Oct) - Aire Cardinal
8. Scorpio ♏ (23 Oct - 21 Nov) - Aigua Fix
9. Sagittarius ♐ (22 Nov - 21 Des) - Foc Mutable
10. Capricorn ♑ (22 Des - 19 Gen) - Terra Cardinal
11. Aquarius ♒ (20 Gen - 18 Feb) - Aire Fix
12. Pisces ♓ (19 Feb - 20 Mar) - Aigua Mutable

**Font:** `lunar_astrology_reference.md`, tradició astrològica
**Status:** Per implementar
**Pantalla proposada:** `moon_in_signs_screen.dart` amb grid de 12 signes

---

### 6. **Special Moon Events** (6 Esdeveniments) 🔄 PENDENT

**Contingut:**

#### 🌑🌕 Eclipsis
**Solar Eclipse (Eclipse Solar):**
- Què és astronòmicament
- Significat astrològic: Nous començaments poderosos
- Com treballar amb eclipsis solars
- Precaucions i consells

**Lunar Eclipse (Eclipse Lunar):**
- Què és astronòmicament
- Significat astrològic: Finalitzacions i revelacions
- Com treballar amb eclipsis lunars
- Connexió amb els Nodes Lunars

#### 🌕✨ Superluna (Supermoon)
- Definició astronòmica (Lluna al perigeu)
- Per què sembla més gran
- Energia amplificada
- Millors rituals per superluna

#### 🌕🌕 Lluna Blava (Blue Moon)
- Definició: Segona lluna plena en el mateix mes
- Raritat (d'on ve "once in a blue moon")
- Significat: Temps fora del temps, oportunitats úniques
- Ritual especial

#### ♆ ♂ ☿ Retrògrads Planetaris
- Què significa "retrògrad"
- Mercury Retrograde (més conegut)
- Altres planetes retrògrads
- Com navegar aquests períodes
- Connexió amb revisió i reflexió

#### 🌑 Black Moon Lilith
- Què és (punt orbital lunar)
- Significat astrològic: El femení salvatge
- Com treballar amb aquesta energia
- Connexió amb poder personal

#### 🐉 Nodes Lunars
- Què són (intersecció òrbita lunar/solar)
- Node Nord (Rahu) - Futur, creixement
- Node Sud (Ketu) - Passat, alliberament
- Eix del destí en astrologia
- Connexió amb eclipsis

**Font:** `astronomical_events.md` (18KB), tradició astrològica
**Status:** Per implementar
**Pantalla proposada:** `special_events_screen.dart`

---

## 🎨 Principis de Disseny

### Consistència Visual
- **Cards blanques** amb borders subtils
- **Shadows suaus** (alpha: 0.06-0.08)
- **Colors per categoria** però mai agressius
- **Espais respirables** - Més aire que densitat
- **Typography** clara i llegible

### To i Veu
- **Humil i acollidor** - "Descobreix", "Explora", mai "Domina"
- **Didàctic i accessible** - Explicacions clares
- **Verificable** - Sempre basat en tradicions reals
- **Pràctic** - Connexió amb la vida quotidiana i tarot

### Navegació
```
Lunar Academy (main)
├── Lunar Phases (8) ✅
├── Seasonal Wisdom (4 estacions + 8 sabbats)
├── Planetary Days (7 dies)
├── Lunar Elements (4 elements)
├── Moon in Signs (12 signes)
└── Special Events (6 fenòmens)
```

---

## 🔗 Connexions amb Tarot

Cada apartat connecta amb el tarot de manera natural:

### Fases Lunars → Arcans Majors
- New Moon → The Fool (nous començaments)
- Full Moon → The High Priestess (intuïció màxima)
- Waning → The Hermit (introspeccio)

### Elements → Pals
- Foc → Bastos (Wands)
- Aigua → Copes (Cups)
- Aire → Espases (Swords)
- Terra → Oros (Pentacles)

### Signes → Arcans
- Aries → The Emperor
- Cancer → The Chariot
- Libra → Justice
- Etc.

### Dies Planetaris → Arcans
- Dilluns (Lluna) → The Moon
- Divendres (Venus) → The Empress
- Etc.

---

## 📊 Mètriques d'Èxit

- **Completesa:** Tots els 6 apartats implementats amb contingut ric
- **Navegació fluida:** Fàcil explorar tots els temes
- **Contingut verificable:** Totes les afirmacions basades en fonts
- **Disseny consistent:** Estil uniforme i agradable
- **Connexió amb pràctica:** Links clars amb lectures de tarot

---

## 📝 Roadmap d'Implementació

**Setmana 1:**
- ✅ Lunar Phases (completat)
- 🔄 Seasonal Wisdom (en progrés)

**Setmana 2:**
- Planetary Days
- Lunar Elements

**Setmana 3:**
- Moon in Signs
- Special Events

**Setmana 4:**
- Polishing i testing
- Documentació final

---

## 🔍 Referències

**Documents interns:**
- `wheel_of_the_year.md` (13KB) - Estacions i Sabbats
- `planetary_weekday_correspondences.md` (9.3KB) - Dies planetaris
- `lunar_astrology_reference.md` (5.5KB) - Elements i fases
- `astronomical_events.md` (18KB) - Esdeveniments especials
- `lunar_guide_system_architecture.md` (19KB) - Sistema complet

**Fonts externes verificades:**
- Wikipedia - Wheel of the Year, Planetary Hours
- Cafe Astrology - Planetary Days
- The Night Sky - Elements Guide
- Almanac.com - Zodiac Elements

---

**Document viu - S'actualitzarà amb cada implementació**
**Última actualització:** 2025-11-17
