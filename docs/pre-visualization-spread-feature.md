# Informe Tècnic: Pàgina de Pre-visualització de Tirades

## 1. Visió General

### Concepte
Una nova funcionalitat que transforma l'experiència de tirada de tarot en un procés educatiu, immersiu i progressiu en 4 fases:

1. **Selecció Intel·ligent**: La IA analitza la pregunta i tria la tirada més adequada
2. **Pre-visualització Didàctica**: Es mostra el layout buit amb explicacions de cada posició
3. **Tirada Progressiva**: Les cartes apareixen d'esquena ocupant les posicions
4. **Revelació Interactiva**: L'usuari gira cada carta individualment

### Beneficis
- **Educatiu**: L'usuari aprèn sobre les diferents tirades i significats
- **Personalitzat**: Cada pregunta obté la tirada més adequada
- **Immersiu**: El procés gradual crea anticipació i misteri
- **Professional**: Replica l'experiència d'una lectura real de tarot
- **Memorable**: L'experiència interactiva fa que cada lectura sigui especial

---

## 2. Flux d'Usuari Detallat

### Fase 1: Entrada de pregunta
```
┌─────────────────────────────────────┐
│  Quin és el teu dubte?              │
│  ┌───────────────────────────────┐  │
│  │ [Pregunta de l'usuari]        │  │
│  └───────────────────────────────┘  │
│           [CONSULTAR]                │
└─────────────────────────────────────┘
```

### Fase 2: Anàlisi IA i Pre-visualització
```
┌─────────────────────────────────────────────────┐
│ ✨ Tirada recomanada: CRUZ CELTA                │
│                                                  │
│ "He escollit la Cruz Celta perquè la teva       │
│  pregunta tracta sobre una situació complexa    │
│  que requereix entendre múltiples factors."     │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│          VISUALITZACIÓ DE LA TIRADA              │
│                                                  │
│         [2]    [1]    [3]                        │
│                [5]                               │
│         [4]    [6]    [7]                        │
│                        [8]                       │
│                        [9]                       │
│                       [10]                       │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│  SIGNIFICAT DE LES POSICIONS:                   │
│                                                  │
│  1️⃣ Situació actual - El present                │
│  2️⃣ Desafiament - Obstacles immediats           │
│  3️⃣ Base - Fonament de la situació             │
│  4️⃣ Passat recent - Influències passades       │
│  5️⃣ Possibilitats - Millor resultat possible   │
│  6️⃣ Futur proper - Propers esdeveniments       │
│  7️⃣ Tu mateix - La teva posició                │
│  8️⃣ Entorn - Influències externes              │
│  9️⃣ Esperances/Temors - Emocions internes      │
│  🔟 Resultat final - Desenllaç probable         │
└─────────────────────────────────────────────────┘

          [COMENÇAR TIRADA] 🎴
```

### Fase 3: Tirada progressiva (cartes d'esquena)
```
┌─────────────────────────────────────────────────┐
│     Tirant les cartes...                        │
│                                                  │
│      [🂠]   [🂠]   [🂠]                          │
│             [🂠]                                 │
│      [🂠]   [🂠]   [🂠]                          │
│                    [🂠]                          │
│                    [🂠]                          │
│                    [🂠]                          │
│                                                  │
│  ✨ Animació: cada carta apareix amb efecte     │
└─────────────────────────────────────────────────┘

      [REVELAR CARTES] 🔮
```

### Fase 4: Revelació interactiva
```
┌─────────────────────────────────────────────────┐
│  Clica cada carta per revelar-la                │
│                                                  │
│    [🂠]  [The Fool]  [🂠]                        │
│          [🂠]                                    │
│    [Death]  [🂠]  [Lovers]                       │
│                   [🂠]                           │
│                   [🂠]                           │
│                   [🂠]                           │
│                                                  │
│  💡 3/10 cartes revelades                       │
└─────────────────────────────────────────────────┘

Quan totes les cartes estiguin revelades:
      [INTERPRETAR TIRADA] 🌟
```

---

## 3. Arquitectura Tècnica

### 3.1 Components Frontend (Flutter)

#### Nous arxius necessaris:
```
lib/
├── screens/
│   ├── spread_preview_screen.dart     # Pantalla principal
│   └── spread_reveal_screen.dart      # Pantalla de revelació
├── widgets/
│   ├── spread_selector_card.dart      # Card explicativa IA
│   ├── spread_layout_widget.dart      # Layout de posicions
│   ├── position_placeholder.dart      # Espai buit numerat
│   ├── card_back_widget.dart          # Carta d'esquena
│   ├── flippable_card_widget.dart     # Carta que es pot girar
│   └── position_legend_widget.dart    # Llegenda de posicions
├── models/
│   ├── spread_definition.dart         # Definició de tirada
│   ├── spread_position.dart           # Posició dins tirada
│   └── spread_recommendation.dart     # Resposta de la IA
├── services/
│   ├── spread_selector_service.dart   # Lògica selecció tirada
│   └── card_animation_service.dart    # Animacions
└── state/
    └── spread_state.dart              # Gestió d'estat (Riverpod)
```

#### Estats de la pantalla:
```dart
enum SpreadScreenState {
  showingRecommendation,  // Fase 2: Pre-visualització
  dealing,                // Fase 3: Tirant cartes
  waitingForReveal,       // Fase 4: Cartes d'esquena
  revealing,              // Fase 4: Girant cartes
  allRevealed,            // Totes revelades
  interpreting            // Interpretant
}
```

### 3.2 Models de Dades

```dart
// spread_definition.dart
class SpreadDefinition {
  final String id;
  final String name;
  final String nameCA;
  final String description;
  final int cardCount;
  final List<SpreadPosition> positions;
  final SpreadCategory category;
  final SpreadComplexity complexity;
  final List<String> suitableFor; // ["love", "career", "decision"]

  // Layout information
  final double layoutWidth;
  final double layoutHeight;
}

class SpreadPosition {
  final int number;
  final String meaning;
  final String meaningCA;
  final Offset coordinates; // Posició X,Y en el layout
  final double rotation;    // Rotació de la carta (0, 90, 180, 270)
}

enum SpreadCategory {
  general,
  love,
  career,
  decision,
  spiritual,
  monthly,
  yearly
}

enum SpreadComplexity {
  simple,      // 1-3 cartes
  medium,      // 4-7 cartes
  complex,     // 8-10 cartes
  extended     // 11+ cartes
}

// spread_recommendation.dart
class SpreadRecommendation {
  final SpreadDefinition spread;
  final String reasoning;
  final double confidenceScore; // 0-1
  final List<String> keyFactors; // Factors detectats en la pregunta
}
```

### 3.3 Backend (Next.js API)

#### Nou endpoint:
```typescript
// pages/api/spread/recommend.ts

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  const { question, locale } = req.body;

  // 1. Analitzar pregunta amb IA
  const analysis = await analyzeQuestion(question);

  // 2. Seleccionar tirada més adequada
  const spread = selectBestSpread(analysis);

  // 3. Generar explicació personalitzada
  const reasoning = await generateReasoning(question, spread, locale);

  return res.json({
    spread: spread,
    reasoning: reasoning,
    analysis: {
      category: analysis.category,
      complexity: analysis.complexity,
      keywords: analysis.keywords
    }
  });
}
```

#### Sistema de selecció de tirades:
```typescript
interface QuestionAnalysis {
  category: string;        // "love", "career", "decision", etc.
  complexity: string;      // "simple", "medium", "complex"
  keywords: string[];      // Paraules clau detectades
  tone: string;           // "anxious", "hopeful", "confused"
  specificity: number;    // 0-1, quan específica és
}

function selectBestSpread(analysis: QuestionAnalysis): SpreadDefinition {
  let candidates: SpreadDefinition[] = [];

  // Filtrar per categoria
  if (analysis.category === "love") {
    candidates = SPREADS.filter(s => s.suitableFor.includes("love"));
  } else if (analysis.category === "decision") {
    candidates = SPREADS.filter(s => s.suitableFor.includes("decision"));
  }

  // Filtrar per complexitat
  candidates = candidates.filter(s => {
    if (analysis.complexity === "simple") return s.cardCount <= 3;
    if (analysis.complexity === "medium") return s.cardCount <= 7;
    return true;
  });

  // Si no hi ha candidats, usar tirada per defecte
  if (candidates.length === 0) {
    return THREE_CARD_SPREAD; // Passat-Present-Futur
  }

  // Retornar la més adequada (podríem usar ML aquí)
  return candidates[0];
}
```

---

## 4. Tirades Disponibles (Fase 1)

### 4.1 Tirada de 3 Cartes (Passat-Present-Futur)
**Adequada per**: Preguntes generals, visió ràpida
```
Layout:
   [1]  [2]  [3]

Posicions:
1. Passat - Influències passades
2. Present - Situació actual
3. Futur - Direcció probable
```

### 4.2 Cruz Celta (10 cartes)
**Adequada per**: Situacions complexes, anàlisi profunda
```
Layout:
         [2]
    [4]  [1]  [6]
         [5]
         [3]
                 [7]
                 [8]
                 [9]
                 [10]

Posicions:
1. Situació actual - El nucli del tema
2. Desafiament - Obstacle o influència creuada
3. Base - Fonament subconscient
4. Passat recent - Influències en retirada
5. Possibilitats - Millor resultat possible
6. Futur proper - Esdeveniments propers (6 mesos)
7. Tu mateix - La teva actitud/posició
8. Entorn - Influències externes/persones
9. Esperances i temors - Aspectes emocionals
10. Resultat final - Desenllaç més probable
```

### 4.3 Tirada de Decisió (7 cartes)
**Adequada per**: Triar entre dues opcions
```
Layout:
      [1]
  [2]   [3]
  [4]   [5]
  [6]   [7]

Posicions:
1. Tu/Situació - Posició actual
2. Opció A - Pro
3. Opció B - Pro
4. Opció A - Contra
5. Opció B - Contra
6. Opció A - Resultat
7. Opció B - Resultat
```

### 4.4 Tirada d'Amor (5 cartes)
**Adequada per**: Relacions, amor, connexions
```
Layout:
      [3]
  [1]   [2]
  [4]   [5]

Posicions:
1. Tu - La teva energia/posició
2. L'altra persona - La seva energia
3. Connexió - L'energia entre vosaltres
4. Obstacles - Desafiaments de la relació
5. Potencial - Cap on va la relació
```

### 4.5 Tirada del Camí (5 cartes)
**Adequada per**: Desenvolupament personal, viatge vital
```
Layout:
[1] → [2] → [3] → [4] → [5]

Posicions:
1. On ets ara - Situació present
2. Primer pas - Acció immediata
3. Obstacle - Repte a superar
4. Ajuda - Recursos disponibles
5. Destinació - On et porta el camí
```

---

## 5. Animacions i UX

### 5.1 Animació de tirada (Fase 3)
```dart
class CardDealAnimation extends StatefulWidget {
  final List<SpreadPosition> positions;
  final Function(int) onCardDealt;

  // Seqüència:
  // 1. Carta apareix des del centre amb escala 0 → 1
  // 2. Es mou a la seva posició (curve: Curves.easeOutCubic)
  // 3. Rota a la seva orientació final
  // 4. Delay de 300ms
  // 5. Següent carta

  Duration get delayBetweenCards => Duration(milliseconds: 400);
  Duration get cardDealDuration => Duration(milliseconds: 600);
}
```

### 5.2 Animació de gir (Fase 4)
```dart
class FlippableCard extends StatefulWidget {
  final bool isRevealed;
  final TarotCard card;

  // Efecte 3D:
  // - Transform.rotateY de 0 → π (180 graus)
  // - A 90 graus (π/2) canviar de back → front
  // - Curve: Curves.easeInOut
  // - Duration: 600ms

  void flip() {
    setState(() {
      _animationController.forward();
    });
  }
}
```

### 5.3 Feedback visual
- **Pre-visualització**: Números grans, colors suaus, borders puntejats
- **Cartes d'esquena**: Disseny elegant, possibilitat de personalitzar
- **Carta girant**: Shadow dinàmic, efecte de profunditat
- **Carta revelada**: Brillantor subtil, escala lleugerament més gran

---

## 6. Lògica de Selecció de Tirades per IA

### 6.1 Anàlisi de pregunta amb GPT-4

```typescript
const SPREAD_SELECTION_PROMPT = `
Analitza la següent pregunta de tarot i determina:

1. CATEGORIA (tria una):
   - "love" - Relacions, amor, connexions personals
   - "career" - Treball, carrera, èxit professional
   - "decision" - Triar entre opcions, dilemes
   - "spiritual" - Creixement personal, propòsit
   - "general" - Pregunta general o múltiples aspectes

2. COMPLEXITAT (tria una):
   - "simple" - Pregunta directa, resposta sí/no
   - "medium" - Situació amb alguns factors
   - "complex" - Situació multifacètica, profunda

3. PARAULES CLAU: Llista de 3-5 paraules clau

4. TO EMOCIONAL (tria un):
   - "anxious" - Preocupat, ansiós
   - "hopeful" - Esperançat, optimista
   - "confused" - Confós, necessita claredat
   - "curious" - Curiós, explorant
   - "urgent" - Urgent, necessita resposta ràpida

Pregunta: "{question}"

Respon en format JSON.
`;

async function analyzeQuestion(question: string): Promise<QuestionAnalysis> {
  const response = await openai.chat.completions.create({
    model: "gpt-4",
    messages: [
      { role: "system", content: SPREAD_SELECTION_PROMPT },
      { role: "user", content: question }
    ],
    response_format: { type: "json_object" }
  });

  return JSON.parse(response.choices[0].message.content);
}
```

### 6.2 Generació de l'explicació

```typescript
async function generateReasoning(
  question: string,
  spread: SpreadDefinition,
  locale: string
): Promise<string> {
  const prompt = `
Has recomanat la tirada "${spread.name}" per aquesta pregunta:
"${question}"

Explica en 2-3 frases curtes i clares (màx 150 paraules) PER QUÈ aquesta
tirada és la més adequada. Sigues específic sobre què aspectes de la
pregunta es beneficiaran d'aquesta tirada.

Idioma: ${locale === 'ca' ? 'català' : 'castellà'}
To: Empàtic, místic però accessible
`;

  const response = await openai.chat.completions.create({
    model: "gpt-4",
    messages: [{ role: "user", content: prompt }],
    max_tokens: 200
  });

  return response.choices[0].message.content;
}
```

### 6.3 Matriu de decisió

| Pregunta conté... | Categoria | Tirada recomanada |
|-------------------|-----------|-------------------|
| "amor", "parella", "relació" | love | Tirada d'Amor (5) |
| "decidir", "triar", "opció" | decision | Tirada de Decisió (7) |
| "treball", "carrera", "feina" | career | Cruz Celta (10) |
| Pregunta curta (< 10 paraules) | general | 3 Cartes (simple) |
| Pregunta llarga (> 30 paraules) | general | Cruz Celta (10) |
| "futur", "que passarà" | general | 3 Cartes o El Camí |
| "per què", "causa" | general | Cruz Celta (10) |

---

## 7. Persistència i Historial

### 7.1 Estructura de dades guardada

```typescript
interface SavedSpreadReading {
  id: string;
  userId: string;
  timestamp: Date;

  // Fase 1: Pregunta
  question: string;

  // Fase 2: Selecció
  spreadId: string;
  spreadName: string;
  reasoning: string;

  // Fase 3-4: Cartes
  cards: {
    position: number;
    cardId: string;
    isReversed: boolean;
    revealedAt: Date;
  }[];

  // Fase 5: Interpretació (existent)
  interpretation?: string;

  // Metadata
  locale: string;
  completedAt?: Date;
}
```

### 7.2 Endpoints necessaris

```typescript
// Guardar pre-visualització
POST /api/readings/spread/preview
Body: {
  question: string,
  spreadId: string,
  reasoning: string
}
Response: { readingId: string }

// Actualitzar amb cartes
PUT /api/readings/{readingId}/cards
Body: {
  cards: Array<{position, cardId, isReversed}>
}

// Marcar carta com a revelada
PUT /api/readings/{readingId}/reveal/{position}
Body: { revealedAt: timestamp }

// Obtenir historial amb tirades
GET /api/readings/history?includeSpread=true
```

---

## 8. Implementació per Fases

### FASE 1: Core Structure (Setmana 1-2)
**Objectiu**: Estructura bàsica i models de dades

- [ ] Crear models Dart (SpreadDefinition, SpreadPosition, etc.)
- [ ] Definir les 5 tirades inicials (dades hardcoded)
- [ ] Crear SpreadPreviewScreen amb layout estàtic
- [ ] Implementar PositionPlaceholder widget
- [ ] Crear backend endpoint `/api/spread/recommend` (versió simple)

**Deliverable**: Pantalla que mostra una tirada amb posicions buides

### FASE 2: IA Selection (Setmana 3)
**Objectiu**: Selecció intel·ligent de tirades

- [ ] Implementar anàlisi de preguntes amb GPT-4
- [ ] Crear matriu de decisió per selecció
- [ ] Generar explicacions personalitzades
- [ ] Integrar amb frontend
- [ ] Testing amb diferents tipus de preguntes

**Deliverable**: Sistema que tria automàticament la tirada adequada

### FASE 3: Animations (Setmana 4)
**Objectiu**: Animacions de tirada i revelació

- [ ] Implementar animació de "dealing" (cartes caient)
- [ ] Crear FlippableCard widget amb rotació 3D
- [ ] Afegir CardBackWidget personalitzat
- [ ] Implementar gestió d'estat per revelació progressiva
- [ ] Polir timing i curves d'animació

**Deliverable**: Experiència animada completa

### FASE 4: Integration (Setmana 5)
**Objectiu**: Integrar amb flux existent

- [ ] Connectar amb pantalla de consulta actual
- [ ] Integrar amb sistema d'interpretació existent
- [ ] Actualitzar base de dades per guardar tirades
- [ ] Afegir al historial
- [ ] Testing end-to-end

**Deliverable**: Feature completament integrada

### FASE 5: Polish & Extras (Setmana 6)
**Objectiu**: Refinament i features extra

- [ ] Afegir sons subtils (opcional)
- [ ] Implementar haptic feedback
- [ ] Optimitzar rendiment d'animacions
- [ ] Afegir onboarding/tutorial
- [ ] Testing d'usuaris
- [ ] Fixes i millores

**Deliverable**: Feature production-ready

---

## 9. Consideracions Tècniques

### 9.1 Performance
- **Animacions**: Usar `AnimatedBuilder` i evitar `setState()` innecesaris
- **Imatges**: Precarregar cartes amb `precacheImage()`
- **Layouts**: Usar `CustomPaint` per layouts complexos
- **Gestió d'estat**: Riverpod amb providers específics per cada fase

### 9.2 Responsivitat
```dart
class SpreadLayout {
  // Adaptar layout segons mida de pantalla
  static SpreadLayoutConfig getLayoutConfig(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return SpreadLayoutConfig(
      cardWidth: isTablet ? 120 : 80,
      cardHeight: isTablet ? 180 : 120,
      spacing: isTablet ? 16 : 12,
      padding: isTablet ? 24 : 16,
    );
  }
}
```

### 9.3 Accessibilitat
- **Semantics**: Afegir labels descriptius a cada posició
- **Screen readers**: Anunciar quan carta es revela
- **Alternative input**: Permetre navegació per teclat (web)
- **Contrast**: Assegurar llegibilitat en posicions numerades

### 9.4 Internacionalització
```dart
// l10n/spreads_ca.dart
const spreads_ca = {
  'three_card_spread': {
    'name': 'Tirada de 3 Cartes',
    'description': 'Una visió ràpida del passat, present i futur',
    'positions': {
      1: 'Passat - Influències passades',
      2: 'Present - Situació actual',
      3: 'Futur - Direcció probable',
    }
  },
  // ... més tirades
};
```

---

## 10. Mockups UI/UX

### 10.1 Pre-visualització (Desktop/Tablet)
```
┌───────────────────────────────────────────────────────────────┐
│  ← Tornar              CONSULTA DE TAROT                      │
├───────────────────────────────────────────────────────────────┤
│                                                                │
│  ┌────────────────────────────────────────────────────────┐   │
│  │  ✨ Tirada recomanada                                  │   │
│  │                                                         │   │
│  │  CRUZ CELTA (10 cartes)                               │   │
│  │                                                         │   │
│  │  He escollit aquesta tirada perquè la teva pregunta    │   │
│  │  sobre el teu futur professional requereix una anàlisi │   │
│  │  profunda de múltiples factors: la teva situació       │   │
│  │  actual, obstacles, influències externes i el camí     │   │
│  │  més probable. La Cruz Celta et donarà una visió       │   │
│  │  completa de tots aquests aspectes.                    │   │
│  └────────────────────────────────────────────────────────┘   │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐   │
│  │              DISPOSICIÓ DE LA TIRADA                   │   │
│  │                                                         │   │
│  │                                                         │   │
│  │               ┌───┐                                    │   │
│  │               │ 2 │                                    │   │
│  │               └───┘                                    │   │
│  │         ┌───┐ ┌───┐ ┌───┐         ┌───┐              │   │
│  │         │ 4 │ │ 1 │ │ 6 │         │ 7 │              │   │
│  │         └───┘ └───┘ └───┘         └───┘              │   │
│  │               ┌───┐                ┌───┐              │   │
│  │               │ 5 │                │ 8 │              │   │
│  │               └───┘                └───┘              │   │
│  │               ┌───┐                ┌───┐              │   │
│  │               │ 3 │                │ 9 │              │   │
│  │               └───┘                └───┘              │   │
│  │                                    ┌───┐              │   │
│  │                                    │10 │              │   │
│  │                                    └───┘              │   │
│  └────────────────────────────────────────────────────────┘   │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐   │
│  │  SIGNIFICAT DE LES POSICIONS                           │   │
│  │                                                         │   │
│  │  1️⃣  Situació actual - El nucli del teu dubte          │   │
│  │  2️⃣  Desafiament - Obstacle que et creua              │   │
│  │  3️⃣  Base - Fonament subconscient de la situació      │   │
│  │  4️⃣  Passat recent - Influències que s'allunyen       │   │
│  │  5️⃣  Possibilitats - El millor resultat possible      │   │
│  │  6️⃣  Futur proper - Esdeveniments dels propers mesos  │   │
│  │  7️⃣  Tu mateix - La teva actitud i energia            │   │
│  │  8️⃣  Entorn - Influències externes i persones         │   │
│  │  9️⃣  Esperances/Temors - Els teus sentiments profunds │   │
│  │  🔟 Resultat final - El desenllaç més probable         │   │
│  └────────────────────────────────────────────────────────┘   │
│                                                                │
│                  [COMENÇAR TIRADA] 🎴                         │
│                                                                │
└───────────────────────────────────────────────────────────────┘
```

### 10.2 Durant la tirada
```
┌───────────────────────────────────────────────────────────────┐
│  ← Cancel              TIRANT LES CARTES...                   │
├───────────────────────────────────────────────────────────────┤
│                                                                │
│                        Cruz Celta                              │
│                                                                │
│                    ┌─────┐                                    │
│                    │ 🂠  │   ← Animant                        │
│                    │     │                                    │
│                    └─────┘                                    │
│         ┌─────┐   ┌─────┐   ┌───┐        ┌───┐              │
│         │ 🂠  │   │ 🂠  │   │   │        │   │              │
│         │     │   │     │   │   │        │   │              │
│         └─────┘   └─────┘   └───┘        └───┘              │
│                    ┌───┐                  ┌───┐              │
│                    │   │                  │   │              │
│                    │   │                  │   │              │
│                    └───┘                  └───┘              │
│                                                                │
│                    Tirant carta 4 de 10...                    │
│                    ████████░░░░░░░░░░ 40%                     │
│                                                                │
└───────────────────────────────────────────────────────────────┘
```

### 10.3 Revelació
```
┌───────────────────────────────────────────────────────────────┐
│  ← Tornar              REVELA LES CARTES                      │
├───────────────────────────────────────────────────────────────┤
│                                                                │
│                        Cruz Celta                              │
│             Clica cada carta per revelar-la                    │
│                                                                │
│                    ┌─────┐                                    │
│                    │ 🂠  │   ← Pot clicar                     │
│                    │     │                                    │
│                    └─────┘                                    │
│         ┌─────┐   ┌─────┐   ┌─────┐      ┌─────┐            │
│         │ 🂠  │   │     │   │ 🂠  │      │     │            │
│         │     │   │ The │   │     │      │     │            │
│         └─────┘   │Fool │   └─────┘      │Death│            │
│                    └─────┘                └─────┘            │
│                     ✓ Revelada             ✓ Revelada         │
│                                                                │
│                    💡 2 de 10 revelades                       │
│                                                                │
│                                                                │
│              [REVELAR TOTES] [INTERPRETAR] 🔮                 │
│                                                                │
└───────────────────────────────────────────────────────────────┘
```

---

## 11. Testing

### 11.1 Tests unitaris
```dart
// test/services/spread_selector_test.dart
group('SpreadSelector', () {
  test('selects Three Card spread for simple questions', () {
    final question = "Quin és el meu futur?";
    final spread = SpreadSelector.selectSpread(question);
    expect(spread.id, 'three_card');
  });

  test('selects Celtic Cross for complex questions', () {
    final question = "Com afectarà la meva decisió de canviar de feina...";
    final spread = SpreadSelector.selectSpread(question);
    expect(spread.id, 'celtic_cross');
  });

  test('selects Love spread when love keywords present', () {
    final question = "Què passa amb la meva relació?";
    final spread = SpreadSelector.selectSpread(question);
    expect(spread.id, 'love_spread');
  });
});
```

### 11.2 Tests d'integració
- Flux complet des de pregunta fins interpretació
- Persistència correcta de tirades
- Animacions no bloquegen UI
- Gestió correcta d'errors (network, etc.)

### 11.3 Tests d'usuari
- **Claredat**: Els usuaris entenen la pre-visualització?
- **Engagement**: Les animacions milloren l'experiència?
- **Temps**: El procés és massa llarg o adequat?
- **Educació**: Els usuaris aprenen sobre les tirades?

---

## 12. Mètriques de Èxit

### 12.1 Mètriques tècniques
- **Performance**: 60 FPS durant animacions
- **Load time**: < 2s fins mostrar pre-visualització
- **Error rate**: < 1% en selecció de tirades
- **Completion rate**: % usuaris que completen revelació

### 12.2 Mètriques d'usuari
- **Engagement**: Temps mitjà a la pantalla de revelació
- **Satisfaction**: Rating de la feature
- **Learning**: % usuaris que exploren diferents tirades
- **Retention**: Usuaris que tornen després d'usar la feature

### 12.3 Mètriques de negoci
- **Adoption**: % sessions que usen pre-visualització
- **Premium conversion**: Impacte en subscripcions
- **Session length**: Augment de temps a l'app
- **Viral coefficient**: Usuaris que comparteixen tirades

---

## 13. Riscos i Mitigacions

### Risc 1: Animacions amb baixa performance
**Impacte**: Alta | **Probabilitat**: Mitja
**Mitigació**:
- Usar `RepaintBoundary` per aislar animacions
- Testejar en dispositius low-end
- Opció per desactivar animacions

### Risc 2: IA tria tirada incorrecta
**Impacte**: Mitja | **Probabilitat**: Mitja
**Mitigació**:
- Sistema de feedback d'usuaris
- Botó "Triar una altra tirada"
- Millorar prompt amb iteracions

### Risc 3: Complexitat confon usuaris
**Impacte**: Alta | **Probabilitat**: Baixa
**Mitigació**:
- Onboarding clar amb tutorial
- Opció de "mode simple" (directe a tirada)
- Tooltips contextuals

### Risc 4: Temps de càrrega llarg
**Impacte**: Alta | **Probabilitat**: Baixa
**Mitigació**:
- Precarregar assets
- Caching agressiu
- Loading states clars

---

## 14. Roadmap Futur (Post-MVP)

### Fase 2 (3-6 mesos)
- **Més tirades**: Afegir 5-10 tirades addicionals
- **Tirades personalitzades**: Usuaris poden crear les seves
- **Sharing**: Compartir tirada (sense interpretació)
- **Sounds**: Efectes de so opcionals

### Fase 3 (6-12 mesos)
- **AR Mode**: Veure tirada en realitat augmentada
- **Collaborative readings**: Tirades amb múltiples usuaris
- **ML-powered selection**: Millorar selecció amb machine learning
- **Voice input**: Fer pregunta per veu

### Fase 4 (12+ mesos)
- **Live readings**: Sessions en directe amb tarotistes
- **Community spreads**: Usuaris comparteixen tirades
- **Gamification**: Badges per tirades completades
- **API**: Permetre integració de tercers

---

## 15. Conclusió

Aquesta feature transformarà l'experiència de tarot en l'app de forma significativa:

### Valor per l'usuari:
✅ **Educatiu**: Aprenen sobre tirades i significats
✅ **Personalitzat**: Cada pregunta rep la tirada adequada
✅ **Immersiu**: Procés progressiu crea anticipació
✅ **Professional**: Replica lectura real de tarot
✅ **Memorable**: Experiència única i compartible

### Valor per el negoci:
✅ **Diferenciació**: Cap competidor té aquesta feature
✅ **Engagement**: Augmenta temps a l'app
✅ **Retention**: Experiència més rica → més retorn
✅ **Premium**: Justifica subscripció premium
✅ **Viral**: Usuaris comparteixen experiència

### Viabilitat tècnica:
✅ **Implementable**: Tecnologies provades (Flutter, GPT-4)
✅ **Escalable**: Arquitectura permet créixer
✅ **Maintainable**: Codi modular i ben estructurat
✅ **Performant**: Animacions optimitzables

**Recomanació**: IMPLEMENTAR per fases segons el pla detallat.

---

**Data**: 17 d'octubre de 2025
**Autor**: Informe tècnic generat per anàlisi detallada
**Versió**: 1.0
**Status**: Proposat per implementació
