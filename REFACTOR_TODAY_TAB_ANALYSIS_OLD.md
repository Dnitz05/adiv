# 📊 INFORME D'ANÀLISI: Refactor Today Tab

**Data:** 2025-11-09
**Autor:** Claude Code Analysis
**Objectiu:** Validar i millorar el pla de refactorització proposat per unificar la Today Tab i afegir AskMoonBanner

---

## 🎯 RESUM EXECUTIU

### Descobriment Crític
**215 línies de codi mort detectades** (main.dart:3168-3383) que mai s'executen en producció. Aquest codi duplica funcionalitat que ja existeix a `_buildTodayScreen()` i amaga bugs visuals i d'UX.

### Recomanació Principal
**Eliminar el codi mort ABANS de fer qualsevol refactorització.** Això simplifica el 50% del treball planificat i evita over-engineering innecesari.

### Estimació Revisada
- **Original:** 5-8 hores
- **Recomanat:** 5.75 hores
- **Estalvi real:** ~3-4 hores de feina innecessària (evitant crear infraestructura per codi mort)

---

## 🔍 ANÀLISI DEL CODI ACTUAL

### 1. Estructura de Navegació (main.dart:3100-3383)

```dart
Widget build(BuildContext context) {
  // ...
  if (_initialising) {
    bodyContent = const Center(child: CircularProgressIndicator());
  } else if (_selectedBottomNavIndex == 0) {           // ← LÍNIA 3117
    // Today screen - always show home content
    bodyContent = _buildTodayScreen(localisation, topSpacing);
  } else if (_selectedBottomNavIndex == 1 ...) {       // ← Chat
    bodyContent = ChatScreen(...);
  } else if (_selectedBottomNavIndex == 2) {           // ← Spreads
    bodyContent = SpreadsScreen(...);
  } else if (_selectedBottomNavIndex == 3) {           // ← Archive
    bodyContent = ArchiveScreen(...);
  } else if (_selectedBottomNavIndex == 4) {           // ← Learn
    bodyContent = LearnScreen(...);
  } else if (!hasDraw) {                               // ← LÍNIA 3168 - UNREACHABLE!
    // 183 línies de codi duplicat...
  } else {                                             // ← LÍNIA 3352 - UNREACHABLE!
    // "After draw" layout (buit)
  }
}
```

#### Per què és codi mort?

**_selectedBottomNavIndex només pot ser 0, 1, 2, 3 o 4** (5 pestanyes del BottomNavigationBar).

**Flux d'execució:**
1. Si estem a Today (index=0) → Executa `_buildTodayScreen()` a línia 3119
2. Si estem a altres pestanyes → Executa els seus builds (línies 3120-3167)
3. **Els blocs `else if (!hasDraw)` i `else {}` només s'executarien si index != 0,1,2,3,4**
4. **Això és impossible** → Mai s'executen

#### Evidència Additional

Analitzant el codi no hi ha cap flux que estableixi `_selectedBottomNavIndex` a un valor diferent de 0-4:
- Inicialització: `int _selectedBottomNavIndex = 0;` (línia ~650)
- Canvis: Sempre via taps al BottomNavigationBar o setState explícits
- Tots els valors possibles estan coberts abans d'arribar al `else if (!hasDraw)`

---

### 2. Comparativa de Layouts

#### Layout ACTIU: `_buildTodayScreen()` (main.dart:3922-4116)

```dart
Widget _buildTodayScreen(CommonStrings localisation, double topSpacing) {
  return ListView(
    padding: EdgeInsets.only(left: 16, right: 16, top: topSpacing, bottom: 16),
    children: [
      // 1. Daily Draw Panel (condicional)
      if (_dailyCards != null && _dailyCards!.isNotEmpty)
        DailyDrawPanel(...),
      else if (_loadingDailyDraw)
        Container(...), // Loading state
      if ((_dailyCards != null && _dailyCards!.isNotEmpty) || _loadingDailyDraw)
        const SizedBox(height: 24),

      // 2. Unified Lunar Widget
      UnifiedLunarWidget(
        onSelectSpread: (spreadId) {
          setState(() {
            _selectedSpread = spread;
            _selectedBottomNavIndex = 2; // ← NAVEGA a pestanya Spreads
          });
        },
      ),
      const SizedBox(height: 24),

      const SizedBox(height: 16), // ← BUG: Double spacing (línia 4006)

      // 3. Ask the Moon Banner (PRESENT)
      AskMoonBanner(
        onTap: () => Navigator.push(...LunarAdvisorScreen...),
      ),
      const SizedBox(height: 16),

      // 4. Smart Draws Panel
      SmartDrawsPanel(...),
      const SizedBox(height: 24),

      // 5. Chat Banner
      ChatBanner(
        onTap: () {
          if (userId == null) showSnackBar(...);
          else setState(() => _selectedBottomNavIndex = 1);
        },
      ),
      const SizedBox(height: 24),

      // 6. Learn Panel
      LearnPanel(...),
      const SizedBox(height: 24),

      // 7. Archive Banner
      ArchiveBanner(...),

      // 8. Error section (condicional)
      if (_error != null) ...[
        Padding(...Text(_error!)),
        const SizedBox(height: 16),
      ],
    ],
  );
}
```

**Característiques:**
- ✅ Padding lateral: **16px**
- ✅ AskMoonBanner present
- ✅ onSelectSpread navega a pestanya Spreads
- ⚠️ **BUG:** Double spacing abans d'AskMoonBanner (24+16=40px)

#### Layout MORT: `else if (!hasDraw)` (main.dart:3168-3351)

```dart
} else if (!hasDraw) {
  bodyContent = ListView(
    padding: EdgeInsets.only(left: 8, right: 8, top: topSpacing, bottom: 16),
    children: [
      // 1. Daily Draw Panel (idèntic)
      if (_dailyCards != null && _dailyCards!.isNotEmpty)
        DailyDrawPanel(...),
      // ... mateix codi ...

      // 2. Unified Lunar Widget
      UnifiedLunarWidget(
        onSelectSpread: (spreadId) {
          setState(() {
            _selectedSpread = spread;
            // ← NO navega a pestanya Spreads!
          });
        },
      ),
      const SizedBox(height: 24),

      // 3. Ask Moon Banner ABSENT ❌

      // 4. Smart Draws Panel (idèntic)
      // 5. Chat Banner (idèntic)
      // 6. Learn Panel (idèntic)
      // 7. Archive Banner (idèntic)
      // 8. Error section (diferent ubicació)
    ],
  );
}
```

**Característiques:**
- ❌ Padding lateral: **8px** (inconsistent)
- ❌ AskMoonBanner **ABSENT**
- ❌ onSelectSpread **NO navega** a pestanya
- ⚠️ Error handling en ubicació diferent

#### Layout MORT: `else {}` "After draw" (main.dart:3352-3383)

```dart
} else {
  // After draw: show question at top and spread below
  final children = <Widget>[];

  if (_error != null) {
    children.add(Padding(...));
  }

  // Place AI recommendation first when available
  // children.add(_buildLatestDrawCard(localisation)); // ← REMOVED

  bodyContent = ListView(
    padding: EdgeInsets.only(left: 8, right: 8, top: topSpacing, bottom: bottomSpacing),
    children: children, // ← BUIT!
  );
}
```

**Característiques:**
- ❌ Pràcticament buit
- ❌ Té un comentari: `// Removed: user requested removal`
- ⚠️ Confusió: El REAL "after draw" és el `fullScreenOverlay` (DrawFullScreenFlow) a línia 3385

---

### 3. Taula Comparativa Detallada

| **Aspecte** | **_buildTodayScreen** ✅ ACTIU | **!hasDraw** ⚠️ MORT | **else {}** ⚠️ MORT | **Impacte** |
|-------------|--------------------------------|----------------------|---------------------|-------------|
| **Estat execució** | S'executa sempre per Today tab | Mai s'executa | Mai s'executa | Critical |
| **Línies codi** | 194 línies | 183 línies | 32 línies | **215 línies mortes** |
| **Padding lateral** | 16px | 8px | 8px | Visual inconsistency |
| **AskMoonBanner** | ✅ Present (4007-4020) | ❌ Absent | ❌ Absent | **Objectiu del pla** |
| **onSelectSpread nav** | Canvia a tab 2 | NO canvia | N/A | UX diferent |
| **Double spacing** | ⚠️ Bug 24+16px | N/A | N/A | Visual bug |
| **Daily Draw** | Idèntic | Idèntic | N/A | OK |
| **Lunar Widget** | Callback diferent | Callback incomplet | N/A | Behavioral diff |
| **Error handling** | Al final de children | Al final | A l'inici | Positional diff |

---

## ❌ ERRORS EN EL PLA ORIGINAL

### Error #1: No detecta codi mort
**Pla diu:** "Inventari i diagnosi de diferències entre hasDraw i !hasDraw"
**Realitat:** El branch `!hasDraw` mai s'executa
**Impacte:** 50% del treball d'inventari és innecesari

### Error #2: Proposa TodayContentState innecesari
**Pla diu:** "Definir un model TodayContentState { hasDraw, showFullScreenFlow, ... }"
**Realitat:** Només hi ha 1 layout actiu (`_buildTodayScreen`)
**Impacte:** Over-engineering que afegeix complexitat sense benefici

### Error #3: Confon "After draw" amb fullScreenOverlay
**Pla diu:** "Determinar si el bloc else { … } s'utilitza com After draw"
**Realitat:**
- Bloc `else {}` està buit (línia 3352-3383)
- El REAL "After draw" és `fullScreenOverlay` (DrawFullScreenFlow) a línia 3385-3428
**Impacte:** Confusió arquitectònica

### Error #4: No identifica el bug de double spacing
**Bug present:** Línies 4005-4006 tenen `SizedBox(24)` + `SizedBox(16)` abans d'AskMoonBanner
**Impacte:** Quick win visual no aprofitat

### Error #5: Estimació inflada
**Pla estima:** 5-8 hores amb TodayContentState i inventari de 2 layouts
**Realitat:** Amb eliminació de codi mort, només 3-4 hores de refactor efectiu
**Impacte:** 2-4 hores de feina innecessària

---

## ✅ PARTS CORRECTES DEL PLA ORIGINAL

1. **Modularització** de `_buildTodayScreen` en helpers petits → ✅ Bona pràctica
2. **Centralització de callbacks** → ✅ Evita duplicació i errors
3. **Testing i QA** → ✅ Cobertura adequada
4. **Documentació** → ✅ Necessària per mantenibilitat

---

## 🎯 PLA REVISAT I OPTIMITZAT

### FASE 0: Validació de Codi Mort (NOVA - CRÍTICA)
**Durada:** 30 min
**Objectiu:** Confirmar empíricament que els blocs 3168-3383 mai s'executen

#### Accions:
1. Afegir 3 debugPrints temporals:
```dart
} else if (_selectedBottomNavIndex == 0) {
  debugPrint('🟢 TODAY: Executing _buildTodayScreen');
  bodyContent = _buildTodayScreen(localisation, topSpacing);
} else if (_selectedBottomNavIndex == 1 ...) { ... }
// ... altres pestanyes ...
} else if (!hasDraw) {
  debugPrint('🔴 DEAD CODE: !hasDraw branch executed - THIS SHOULD NEVER HAPPEN');
  // ...
} else {
  debugPrint('🔴 DEAD CODE: else branch executed - THIS SHOULD NEVER HAPPEN');
  // ...
}
```

2. Hot reload app
3. Navegar per totes les pestanyes (Today, Chat, Spreads, Archive, Learn)
4. Navegar entre estats (amb/sense daily draw, amb/sense errors)
5. Confirmar que NOMÉS es veu "🟢 TODAY: Executing _buildTodayScreen"

#### Output esperat:
```
Flutter: 🟢 TODAY: Executing _buildTodayScreen
(repetit cada cop que es renderitza Today tab, mai els altres dos missatges)
```

#### Si confirmat:
→ Procedir a Fase 1 (eliminació)

#### Si NO confirmat (improbable):
→ Revisar anàlisi, potser hi ha un cas edge no detectat

---

### FASE 1: Eliminació de Codi Mort
**Durada:** 30 min
**Objectiu:** Eliminar les 215 línies de codi duplicat

#### Accions:
**DELETE línies 3168-3383** del fitxer `smart-divination/apps/tarot/lib/main.dart`

#### Abans (3115-3383):
```dart
if (_initialising) {
  bodyContent = const Center(child: CircularProgressIndicator());
} else if (_selectedBottomNavIndex == 0) {
  bodyContent = _buildTodayScreen(localisation, topSpacing);
} else if (_selectedBottomNavIndex == 1 ...) { ... }
} else if (_selectedBottomNavIndex == 2) { ... }
} else if (_selectedBottomNavIndex == 3) { ... }
} else if (_selectedBottomNavIndex == 4) { ... }
} else if (!hasDraw) {
  // 183 línies de codi duplicat
} else {
  // 32 línies
}

if (_fullScreenStep != null && _latestDraw != null) {
  // fullScreenOverlay logic
}
```

#### Després (3115-3168):
```dart
if (_initialising) {
  bodyContent = const Center(child: CircularProgressIndicator());
} else if (_selectedBottomNavIndex == 0) {
  bodyContent = _buildTodayScreen(localisation, topSpacing);
} else if (_selectedBottomNavIndex == 1 && _userId != null && _userId!.isNotEmpty) {
  bodyContent = ChatScreen(...);
} else if (_selectedBottomNavIndex == 2) {
  bodyContent = SpreadsScreen(...);
} else if (_selectedBottomNavIndex == 3) {
  bodyContent = ArchiveScreen(...);
} else if (_selectedBottomNavIndex == 4) {
  bodyContent = LearnScreen(...);
}

if (_fullScreenStep != null && _latestDraw != null) {
  // fullScreenOverlay logic
}
```

#### Beneficis:
- ✅ -215 línies de codi
- ✅ Font única de veritat
- ✅ Elimina inconsistències (padding, callbacks, widgets)
- ✅ Simplifica manteniment futur

#### Testing:
- Hot reload
- Verificar que Today tab segueix funcionant idènticament
- Navegar per totes les pestanyes
- NO hauria d'haver cap diferència visual o funcional

---

### FASE 2: Fix del Bug de Double Spacing
**Durada:** 15 min
**Objectiu:** Eliminar l'espai excessiu abans d'AskMoonBanner

#### Problema actual (main.dart:4005-4021):
```dart
const SizedBox(height: 24),  // ← Spacing estàndard després de Lunar
const SizedBox(height: 16),  // ← BUG: Spacing extra innecesari
// Ask the Moon Banner
AskMoonBanner(
  strings: localisation,
  onTap: () { ... },
),
const SizedBox(height: 16),
```

**Total spacing:** 24 + 16 = **40px** (inconsistent amb altres seccions que usen 24px)

#### Solució:
**DELETE línia 4006** (el segon `SizedBox(height: 16)`)

```dart
const SizedBox(height: 24),  // ← Spacing estàndard
// Ask the Moon Banner
AskMoonBanner(
  strings: localisation,
  onTap: () { ... },
),
const SizedBox(height: 24),  // ← Canviar de 16 a 24 per consistència
```

#### Beneficis:
- ✅ Spacing consistent entre totes les seccions (24px)
- ✅ Millor simetria visual
- ✅ Quick win (15 min)

---

### FASE 3: Modularització de _buildTodayScreen
**Durada:** 2 hores
**Objectiu:** Descompondre el mètode en helpers reutilitzables i testables

#### Arquitectura proposada:

**NO crear TodayContentState** (innecesari).
Simplement extreure cada secció a un helper que retorna un `Column` amb el widget + spacing.

#### Estructura final:
```dart
Widget _buildTodayScreen(CommonStrings localisation, double topSpacing) {
  return ListView(
    padding: EdgeInsets.only(
      left: 16,
      right: 16,
      top: topSpacing,
      bottom: 16,
    ),
    children: [
      _buildDailyDrawSection(localisation),
      _buildUnifiedLunarSection(localisation),
      _buildAskMoonBannerSection(localisation),
      _buildSmartDrawsSection(localisation),
      _buildChatBannerSection(localisation),
      _buildLearnSection(localisation),
      _buildArchiveBannerSection(localisation),
      if (_error != null) _buildErrorSection(),
    ],
  );
}
```

#### Implementació dels helpers:

##### 1. Daily Draw Section
```dart
Widget _buildDailyDrawSection(CommonStrings localisation) {
  // No daily cards and not loading -> skip section
  if ((_dailyCards == null || _dailyCards!.isEmpty) && !_loadingDailyDraw) {
    return const SizedBox.shrink();
  }

  return Column(
    children: [
      if (_dailyCards != null && _dailyCards!.isNotEmpty)
        DailyDrawPanel(
          cards: _dailyCards!,
          strings: localisation,
          isLoading: _loadingDailyDraw,
          onInterpret: () {
            final response = _dailyDrawResponse;
            if (response == null || response.sessionId == null || response.sessionId!.isEmpty) {
              debugPrint('No session ID available for daily draw interpretation');
              return;
            }
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DailyInterpretationScreen(
                  cards: _dailyCards!,
                  draw: response,
                  sessionId: response.sessionId!,
                ),
              ),
            );
          },
        )
      else if (_loadingDailyDraw)
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  localisation.lunarPanelLoading,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      const SizedBox(height: 24),
    ],
  );
}
```

##### 2. Unified Lunar Section
```dart
Widget _buildUnifiedLunarSection(CommonStrings localisation) {
  return Column(
    children: [
      UnifiedLunarWidget(
        controller: _lunarController,
        strings: localisation,
        userId: _userId,
        onSelectSpread: (spreadId) => _handleSelectSpread(spreadId, navigateToTab: true),
        onRefresh: () => _lunarController.refresh(force: true),
      ),
      const SizedBox(height: 24),
    ],
  );
}
```

##### 3. Ask Moon Banner Section
```dart
Widget _buildAskMoonBannerSection(CommonStrings localisation) {
  return Column(
    children: [
      AskMoonBanner(
        strings: localisation,
        onTap: () => _navigateToLunarAdvisor(localisation),
      ),
      const SizedBox(height: 24),
    ],
  );
}
```

##### 4. Smart Draws Section
```dart
Widget _buildSmartDrawsSection(CommonStrings localisation) {
  return Column(
    children: [
      SmartDrawsPanel(
        strings: localisation,
        onSmartSelection: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SmartSelectionScreen(),
            ),
          );
        },
        onLove: () => debugPrint('Love category tapped'),
        onCareer: () => debugPrint('Career category tapped'),
        onFinances: () => debugPrint('Finances category tapped'),
        onPersonalGrowth: () => debugPrint('Personal Growth category tapped'),
        onDecisions: () => debugPrint('Decisions category tapped'),
        onGeneral: () => debugPrint('General category tapped'),
      ),
      const SizedBox(height: 24),
    ],
  );
}
```

##### 5. Chat Banner Section
```dart
Widget _buildChatBannerSection(CommonStrings localisation) {
  return Column(
    children: [
      ChatBanner(
        strings: localisation,
        onTap: () => _navigateToChatOrShowLogin(localisation),
      ),
      const SizedBox(height: 24),
    ],
  );
}
```

##### 6. Learn Section
```dart
Widget _buildLearnSection(CommonStrings localisation) {
  return Column(
    children: [
      LearnPanel(
        strings: localisation,
        onNavigateToCards: () => _showLearnComingSoon(localisation),
        onNavigateToKnowledge: () => _showLearnComingSoon(localisation),
        onNavigateToSpreads: () => _showLearnComingSoon(localisation),
        onNavigateToAstrology: () => _showLearnComingSoon(localisation),
        onNavigateToKabbalah: () => _showLearnComingSoon(localisation),
        onNavigateToMoonPowers: () => _showLearnComingSoon(localisation),
      ),
      const SizedBox(height: 24),
    ],
  );
}
```

##### 7. Archive Banner Section
```dart
Widget _buildArchiveBannerSection(CommonStrings localisation) {
  return Column(
    children: [
      ArchiveBanner(
        strings: localisation,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ArchiveScreen(
                userId: _userId ?? '',
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 24),
    ],
  );
}
```

##### 8. Error Section
```dart
Widget _buildErrorSection() {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          _error!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
      const SizedBox(height: 16),
    ],
  );
}
```

#### Beneficis:
- ✅ Cada secció és auto-continguda
- ✅ Fàcil reordenar seccions (només canviar ordre a `children`)
- ✅ Fàcil afegir noves seccions (copiar patró)
- ✅ Testable unitàriament
- ✅ Spacing consistent i visible (sempre SizedBox(24) al final)

---

### FASE 4: Centralització de Callbacks
**Durada:** 1 hora
**Objectiu:** Evitar duplicació i errors en la navegació

#### Helpers a crear:

##### 1. Handle Select Spread
```dart
void _handleSelectSpread(String spreadId, {bool navigateToTab = false}) {
  final spread = TarotSpreads.getById(spreadId);
  if (spread != null) {
    setState(() {
      _selectedSpread = spread;
      if (navigateToTab) {
        _selectedBottomNavIndex = 2; // Navigate to Spreads tab
      }
    });
  }
}
```

**Ús:**
```dart
// A UnifiedLunarWidget (amb navegació):
UnifiedLunarWidget(
  onSelectSpread: (id) => _handleSelectSpread(id, navigateToTab: true),
),

// A altres llocs (sense navegació):
onSelectSpread: _handleSelectSpread, // Default navigateToTab=false
```

##### 2. Navigate to Lunar Advisor
```dart
void _navigateToLunarAdvisor(CommonStrings localisation) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => LunarAdvisorScreen(
        strings: localisation,
        userId: _userId,
      ),
    ),
  );
}
```

**Ús:**
```dart
AskMoonBanner(
  onTap: () => _navigateToLunarAdvisor(localisation),
),
```

##### 3. Navigate to Chat or Show Login
```dart
void _navigateToChatOrShowLogin(CommonStrings localisation) {
  final userId = _userId;
  if (userId == null || userId.isEmpty) {
    _showLoginRequiredSnackbar(localisation);
  } else {
    setState(() {
      _selectedBottomNavIndex = 1; // Navigate to Chat tab
    });
  }
}

void _showLoginRequiredSnackbar(CommonStrings localisation) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        _qaText(
          localisation,
          en: 'Please log in to use chat.',
          es: 'Por favor inicia sesión para usar el chat.',
          ca: 'Si us plau inicia sessió per utilitzar el xat.',
        ),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}
```

**Ús:**
```dart
ChatBanner(
  onTap: () => _navigateToChatOrShowLogin(localisation),
),
```

#### Beneficis:
- ✅ Lògica de navegació centralitzada
- ✅ Fàcil modificar comportament (un sol lloc)
- ✅ Testable (mocks més fàcils)
- ✅ Evita inconsistències

---

### FASE 5: Testing i Validació
**Durada:** 1 hora

#### 5.1 Tests Unitaris

```dart
// test/main_test.dart

group('Today Tab Navigation Callbacks', () {
  testWidgets('_handleSelectSpread updates spread without navigation', (tester) async {
    await tester.pumpWidget(MyApp());
    final state = tester.state<_MyAppState>(find.byType(MyApp));

    state._handleSelectSpread('three-card');
    await tester.pump();

    expect(state._selectedSpread.id, 'three-card');
    expect(state._selectedBottomNavIndex, 0); // No tab change
  });

  testWidgets('_handleSelectSpread navigates when flag is true', (tester) async {
    await tester.pumpWidget(MyApp());
    final state = tester.state<_MyAppState>(find.byType(MyApp));

    state._handleSelectSpread('celtic-cross', navigateToTab: true);
    await tester.pump();

    expect(state._selectedSpread.id, 'celtic-cross');
    expect(state._selectedBottomNavIndex, 2); // Navigated to Spreads
  });

  testWidgets('_navigateToChatOrShowLogin shows snackbar when not logged in', (tester) async {
    await tester.pumpWidget(MyApp());
    final state = tester.state<_MyAppState>(find.byType(MyApp));
    state._userId = null;

    state._navigateToChatOrShowLogin(CommonStrings.of(context));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(state._selectedBottomNavIndex, 0); // No navigation
  });

  testWidgets('_navigateToChatOrShowLogin navigates when logged in', (tester) async {
    await tester.pumpWidget(MyApp());
    final state = tester.state<_MyAppState>(find.byType(MyApp));
    state._userId = 'test-user-123';

    state._navigateToChatOrShowLogin(CommonStrings.of(context));
    await tester.pump();

    expect(find.byType(SnackBar), findsNothing);
    expect(state._selectedBottomNavIndex, 1); // Navigated to Chat
  });
});
```

#### 5.2 Widget Tests

```dart
group('Today Tab Widgets', () {
  testWidgets('Today tab shows AskMoonBanner', (tester) async {
    await tester.pumpWidget(MyApp());

    // Ensure we're on Today tab
    expect(find.byType(AskMoonBanner), findsOneWidget);
  });

  testWidgets('AskMoonBanner navigates to LunarAdvisorScreen', (tester) async {
    await tester.pumpWidget(MyApp());

    await tester.tap(find.byType(AskMoonBanner));
    await tester.pumpAndSettle();

    expect(find.byType(LunarAdvisorScreen), findsOneWidget);
  });

  testWidgets('All sections appear in correct order', (tester) async {
    await tester.pumpWidget(MyApp());

    // Find all sections
    final dailyDraw = find.byType(DailyDrawPanel);
    final lunar = find.byType(UnifiedLunarWidget);
    final askMoon = find.byType(AskMoonBanner);
    final smartDraws = find.byType(SmartDrawsPanel);
    final chat = find.byType(ChatBanner);
    final learn = find.byType(LearnPanel);
    final archive = find.byType(ArchiveBanner);

    // Verify order (positions should increase)
    // Note: Some widgets might not render if data is empty
    expect(lunar, findsOneWidget);
    expect(askMoon, findsOneWidget);
    expect(smartDraws, findsOneWidget);
    expect(chat, findsOneWidget);
    expect(learn, findsOneWidget);
    expect(archive, findsOneWidget);
  });
});
```

#### 5.3 Manual QA Checklist

**Navegació i Visibilitat:**
- [ ] Today tab mostra AskMoonBanner entre Unified Lunar i SmartDraws
- [ ] AskMoonBanner té icona de lluna i text adequat
- [ ] Tap a AskMoonBanner obre LunarAdvisorScreen
- [ ] LunarAdvisorScreen rep userId correcte
- [ ] UnifiedLunarWidget → tap a spread recomanat canvia a tab Spreads
- [ ] Tab Spreads mostra el spread seleccionat

**Chat Access:**
- [ ] Chat sense login mostra snackbar amb missatge adequat
- [ ] Snackbar es tanca després de 2 segons
- [ ] Chat amb login canvia a tab Chat
- [ ] ChatScreen es renderitza correctament

**Daily Draw:**
- [ ] Daily Draw Panel apareix quan hi ha cards disponibles
- [ ] Loading state es mostra correctament (_loadingDailyDraw = true)
- [ ] Tap a "Interpret" navega a DailyInterpretationScreen
- [ ] No hi haDaily Draw Panel si no hi ha cards i no està loading

**Error Handling:**
- [ ] Error messages es mostren al final de la llista
- [ ] Error text té el color adequat (theme.colorScheme.error)
- [ ] Errors desapareixen quan _error = null

**Spacing Visual:**
- [ ] 24px consistents entre totes les seccions
- [ ] 16px de padding lateral
- [ ] No hi ha double spacing abans d'AskMoonBanner
- [ ] Scroll suau sense salts visuals

**Accessibilitat:**
- [ ] AskMoonBanner és accessible amb TalkBack (Android)
- [ ] AskMoonBanner és accessible amb VoiceOver (iOS)
- [ ] Text té contrast mínim 4.5:1 (WCAG AA)
- [ ] Tots els widgets interactius tenen semanticLabel adequat
- [ ] Tap targets són mínim 48x48 dp

**Edge Cases:**
- [ ] App funciona amb/sense userId
- [ ] App funciona amb/sense daily cards
- [ ] App funciona amb/sense errors
- [ ] Rotació de pantalla manté estat correcte
- [ ] Hot reload no trenca l'estat

---

### FASE 6: Documentació
**Durada:** 30 min

Crear fitxer `docs/TODAY_TAB_ARCHITECTURE.md`:

```markdown
# Today Tab Architecture

**Última actualització:** [DATA]
**Responsable:** [NOM]

## Overview

La Today Tab és la pantalla principal de l'aplicació, mostrant contingut diari i accés ràpid a funcionalitats clau.

## Layout Structure

Tot el contingut de Today es renderitza via `_buildTodayScreen()` que retorna un `ListView` amb aquestes seccions **en ordre**:

1. **Daily Draw Panel** (condicional) - Mostra les cartes del dia si disponibles
2. **Unified Lunar Widget** - Centre de saviesa lunar amb fase actual i recomanacions
3. **Ask the Moon Banner** - Accés ràpid a consulta lunar personalitzada
4. **Smart Draws Panel** - Categories de tirades intel·ligents
5. **Chat Banner** - Accés al xat (requereix login)
6. **Learn Panel** - Secció educativa (coming soon)
7. **Archive Banner** - Historial de tirades i journal
8. **Error Section** (condicional) - Missatges d'error si n'hi ha

## Code Organization

### Main Method
```dart
Widget _buildTodayScreen(CommonStrings localisation, double topSpacing)
```
Retorna un `ListView` que conté totes les seccions.

### Section Helpers
Cada secció té el seu helper privat que retorna un `Column` amb:
- Widget de la secció
- `SizedBox(height: 24)` al final (spacing estàndard)

**Pattern:**
```dart
Widget _buildXxxxSection(CommonStrings localisation) {
  return Column(
    children: [
      XxxxWidget(...),
      const SizedBox(height: 24),
    ],
  );
}
```

**Helpers disponibles:**
- `_buildDailyDrawSection()`
- `_buildUnifiedLunarSection()`
- `_buildAskMoonBannerSection()`
- `_buildSmartDrawsSection()`
- `_buildChatBannerSection()`
- `_buildLearnSection()`
- `_buildArchiveBannerSection()`
- `_buildErrorSection()`

### Navigation Helpers
Callbacks centralitzats per evitar duplicació:

- `_handleSelectSpread(String id, {bool navigateToTab = false})`
  - Actualitza `_selectedSpread`
  - Opcionalment navega a tab Spreads

- `_navigateToLunarAdvisor(CommonStrings localisation)`
  - Obre `LunarAdvisorScreen` amb userId actual

- `_navigateToChatOrShowLogin(CommonStrings localisation)`
  - Navega a Chat si logged in
  - Mostra snackbar si no està logged in

## Adding New Sections

Per afegir una nova secció a Today:

1. **Crear helper method:**
```dart
Widget _buildMyNewSection(CommonStrings localisation) {
  return Column(
    children: [
      MyNewWidget(
        // ... props
      ),
      const SizedBox(height: 24), // Standard spacing
    ],
  );
}
```

2. **Afegir a `_buildTodayScreen()` children:**
```dart
children: [
  _buildDailyDrawSection(localisation),
  _buildUnifiedLunarSection(localisation),
  _buildAskMoonBannerSection(localisation),
  _buildMyNewSection(localisation), // ← Nova secció aquí
  _buildSmartDrawsSection(localisation),
  // ...
],
```

3. **Si necessita navegació, crear helper:**
```dart
void _navigateToMyNewFeature() {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => MyNewScreen(...),
    ),
  );
}
```

4. **Wire callback:**
```dart
MyNewWidget(
  onTap: _navigateToMyNewFeature,
),
```

## Spacing Convention

**Standard spacing between sections:** `24px`
**Panel internal padding:** `16px`
**Outer horizontal padding:** `16px`
**Top padding:** Dynamic via `topSpacing` parameter
**Bottom padding:** `16px`

### Why 24px?
Provides comfortable visual separation without excessive whitespace on mobile screens.

### Example
```dart
ListView(
  padding: EdgeInsets.only(
    left: 16,   // ← Horizontal
    right: 16,  // ← Horizontal
    top: topSpacing,  // ← Dynamic based on AppBar
    bottom: 16, // ← Bottom safe area
  ),
  children: [
    Widget1(),
    SizedBox(height: 24), // ← Inter-section spacing
    Widget2(),
    SizedBox(height: 24), // ← Inter-section spacing
    Widget3(),
  ],
)
```

## Conditional Rendering

### Daily Draw Panel
Shows **only if**:
- `_dailyCards != null && _dailyCards!.isNotEmpty` (has cards)
- OR `_loadingDailyDraw == true` (loading state)

### Error Section
Shows **only if**:
- `_error != null`

All other sections are **always visible**.

## State Dependencies

The Today tab depends on these state variables:

- `_dailyCards` - Daily draw cards
- `_dailyDrawResponse` - Daily draw API response
- `_loadingDailyDraw` - Loading state for daily draw
- `_lunarController` - Controller for lunar widget
- `_selectedSpread` - Currently selected spread
- `_userId` - Current user ID (null if not logged in)
- `_error` - Error message (null if no error)
- `_selectedBottomNavIndex` - Current tab index

## Testing

### Unit Tests
Located in `test/main_test.dart`:
- `_handleSelectSpread` behavior with/without navigation
- `_navigateToChatOrShowLogin` with/without userId

### Widget Tests
Located in `test/widget_test.dart`:
- Presence of all sections
- Correct ordering
- Navigation flows

### Manual QA
See `REFACTOR_TODAY_TAB_ANALYSIS.md` section 5.3 for complete checklist.

## Common Issues

### "AskMoonBanner not showing"
- Verify you're on Today tab (_selectedBottomNavIndex == 0)
- Check `_buildAskMoonBannerSection()` is in `_buildTodayScreen()` children

### "Double spacing between sections"
- Each section helper should have **exactly one** `SizedBox(height: 24)` at the end
- Don't add extra spacing in `_buildTodayScreen()` children

### "Chat navigation not working"
- Verify `_userId != null` and `_userId!.isNotEmpty`
- Check `_navigateToChatOrShowLogin()` logic

## History

- **2025-11-09:** Major refactor - Removed 215 lines of dead code, modularized sections, added AskMoonBanner
- **[Earlier date]:** Initial implementation

## See Also

- `lib/widgets/ask_moon_banner.dart` - AskMoonBanner widget
- `lib/screens/lunar_advisor_screen.dart` - Lunar Advisor screen
- `lib/widgets/unified_lunar_widget.dart` - Unified Lunar Widget
```

---

## 📊 RESUM D'ESTALVIS I BENEFICIS

### Temps Estalviat
- **Inventari de codi mort:** -1h (no cal comparar 2 layouts)
- **Desenvolupament TodayContentState:** -1h (no cal crear infraestructura)
- **Testing de codi mort:** -0.5h (menys casos edge)
- **TOTAL ESTALVIAT:** ~2.5h

### Codi Eliminat
- **215 línies de codi mort** eliminades
- **Duplicació:** 0% (abans ~40% duplicat)
- **Complexitat ciclomàtica:** Reduïda (menys if/else branches)

### Beneficis de Mantenibilitat
- ✅ Font única de veritat per Today tab
- ✅ Helpers reutilitzables i testables
- ✅ Callbacks centralitzats (menys errors)
- ✅ Documentació clara per futurs canvis
- ✅ Spacing consistent i visual

### Beneficis d'UX
- ✅ AskMoonBanner visible a Today (objectiu assolit)
- ✅ onSelectSpread navega a Spreads (comportament coherent)
- ✅ Fix de double spacing (millor estètica)
- ✅ Error handling consistent

---

## ⚠️ RISCOS I MITIGACIONS

### Risc #1: Regressió Visual
**Probabilitat:** Baixa
**Impacte:** Mitjà
**Mitigació:**
- Captures de pantalla abans/després (ja disponibles al repo)
- QA manual exhaustiu (checklist a Fase 5.3)
- Widget tests per verificar presència de components

### Risc #2: Break de Navegació
**Probabilitat:** Baixa
**Impacte:** Alt
**Mitigació:**
- Unit tests per tots els callbacks de navegació
- QA manual de tots els fluxos
- Verificar que Navigator.push té context vàlid

### Risc #3: Perdre Comportament "After Draw"
**Probabilitat:** Molt Baixa
**Impacte:** Baix
**Mitigació:**
- El REAL "after draw" és `fullScreenOverlay` (DrawFullScreenFlow) que NO es toca
- Els blocs eliminats estan buits o duplicats
- Logs/asserts temporals per verificar

### Risc #4: Breaking Changes en Hot Reload
**Probabilitat:** Baixa
**Impacte:** Baix
**Mitigació:**
- Testejar hot reload després de cada fase
- Mantenir estat consistent (_selectedBottomNavIndex, etc.)

---

## 🎯 ORDRE D'EXECUCIÓ RECOMANAT

1. **FASE 0** (Validació) - **CRÍTICA**
   - No saltar-se aquesta fase
   - Confirmar empíricament que el codi és mort

2. **FASE 1** (Eliminació codi mort)
   - Quick win: -215 línies
   - Test immediat: verificar que tot funciona igual

3. **FASE 2** (Fix double spacing)
   - Quick win visual
   - Baixa complexitat

4. **FASE 3** (Modularització)
   - Refactor més gran
   - Fer en commits petits per facilitar reviews

5. **FASE 4** (Centralització callbacks)
   - Pot fer-se en paral·lel a Fase 3
   - Requereix canvis a múltiples helpers

6. **FASE 5** (Testing)
   - Cobertura completa
   - QA manual abans de merge

7. **FASE 6** (Documentació)
   - Últim pas abans de tancar ticket

---

## 📝 CRITERIS D'ACCEPTACIÓ

### Must Have (Blocker per merge)
- [ ] 215 línies de codi mort eliminades
- [ ] AskMoonBanner visible a Today tab
- [ ] onSelectSpread navega a tab Spreads
- [ ] Tots els tests passen (unit + widget)
- [ ] QA manual checklist completa
- [ ] No hi ha regressions visuals

### Should Have (Important)
- [ ] Fix de double spacing aplicat
- [ ] Helpers de seccions implementats
- [ ] Callbacks centralitzats
- [ ] Spacing consistent (24px entre seccions)
- [ ] Documentació TODAY_TAB_ARCHITECTURE.md creada

### Nice to Have (Optional)
- [ ] Widget tests amb golden files
- [ ] Accessibility audit complet
- [ ] Performance profiling (fps, memory)

---

## 📞 CONTACTE I SUPORT

Per dubtes o bloquejos durant la implementació:
- Revisar aquest document primer
- Consultar `docs/TODAY_TAB_ARCHITECTURE.md` després de Fase 6
- Verificar que no s'està intentant implementar codi mort
- Si cal ajuda amb Flutter/Dart: [ENLLAÇ DOCS]

---

## 📚 APÈNDIX

### A. Referències de Codi

**Fitxers principals:**
- `smart-divination/apps/tarot/lib/main.dart` - Aplicació principal
- `smart-divination/apps/tarot/lib/widgets/ask_moon_banner.dart` - Banner Ask Moon
- `smart-divination/apps/tarot/lib/widgets/unified_lunar_widget.dart` - Widget Lunar
- `smart-divination/apps/tarot/lib/screens/lunar_advisor_screen.dart` - Pantalla Lunar Advisor

**Línies clau:**
- 3100-3383: Build method amb codi mort
- 3922-4116: `_buildTodayScreen()` (layout actiu)
- 4005-4021: AskMoonBanner amb bug de spacing

### B. Historial de Decisions

**Per què no TodayContentState?**
- Només hi ha 1 layout actiu
- Els altres són codi mort
- Over-engineering innecesari
- Afegeix complexitat sense benefici

**Per què 24px de spacing?**
- Consistent amb Material Design guidelines (8dp grid: 24 = 8*3)
- Equilibri entre compacte i respiració visual
- Ja s'utilitza a altres parts de l'app

**Per què eliminar codi abans de refactoritzar?**
- Evita inventariar i testejar codi que no s'executa
- Simplifica arquitectura (menys cases a considerar)
- Preveu confusió futura ("per què hi ha 2 layouts?")

### C. Exemples de Casos Edge

**Cas 1: Usuari nou sense cap dada**
- _userId = null
- _dailyCards = null
- _loadingDailyDraw = false
- **Resultat:** Mostra Lunar, AskMoon, SmartDraws, Chat, Learn, Archive (sense Daily Draw)

**Cas 2: Usuari amb daily draw loading**
- _userId != null
- _dailyCards = null
- _loadingDailyDraw = true
- **Resultat:** Mostra loading placeholder + resta de seccions

**Cas 3: Error de xarxa**
- _error = "Network error"
- **Resultat:** Mostra error section al final + resta de seccions funcionals

**Cas 4: Full screen draw flow actiu**
- _fullScreenStep = FullScreenStep.dealing
- _latestDraw != null
- **Resultat:** `fullScreenOverlay` renderitza per sobre de `bodyContent` (Today segueix renderitzant-se per sota)

---

**FI DE L'INFORME**

*Aquest document és la font de veritat per la implementació del refactor Today Tab. Qualsevol desviació del pla hauria de documentar-se i justificar-se.*
