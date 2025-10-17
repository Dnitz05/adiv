# Informe: Galería de Tiradas en el Header

## 1. Situación Actual

### Assets SVG Disponibles
Actualmente existen **3 iconas SVG** de spreads en `apps/tarot/assets/spread-buttons/`:

1. **three-card-spread.svg** - Representa la tirada de 3 cartas (Past, Present, Future)
   - 3 cartas en fila horizontal
   - Diseño: Botón cuadrado con gradiente azul-púrpura (#6D82CD → #9B8FD9)
   - Dimensiones: 200x200px con border-radius 20px

2. **celtic-cross-spread.svg** - Representa la Cruz Celta (10 cartas)
   - 10 cartas en disposición de cruz celta
   - Una carta rotada 90° en el centro
   - Mismo estilo visual que three-card

3. **simple-cross-spread.svg** - Representa una cruz simple (5 cartas)
   - 5 cartas en disposición de cruz: centro, arriba, abajo, izquierda, derecha
   - Mismo estilo visual consistente

### Spreads Disponibles en la Aplicación
Hay **8 spreads** definidos en `tarot_spread.dart`:

1. **Single Card** (1 carta) - `single` - ❌ SIN ICONA
2. **Three Card Spread** (3 cartas) - `three_card` - ✅ CON ICONA
3. **Relationship** (7 cartas) - `relationship` - ❌ SIN ICONA
4. **Pyramid** (6 cartas) - `pyramid` - ❌ SIN ICONA
5. **Horseshoe** (7 cartas) - `horseshoe` - ❌ SIN ICONA
6. **Celtic Cross** (10 cartas) - `celtic_cross` - ✅ CON ICONA
7. **Star** (7 cartas) - `star` - ❌ SIN ICONA
8. **Year Ahead** (12 cartas) - `year_ahead` - ❌ SIN ICONA

**Conclusión:** Solo 3 de 8 spreads tienen iconas SVG (37.5% cobertura).

### Selector Actual
El `SpreadSelector` actual (`widgets/spread_selector.dart`) es un **dropdown convencional**:
- Usa `DropdownButton` de Flutter
- Muestra nombre del spread + número de cartas
- Texto simple, sin iconas visuales
- Ubicación: En el formulario de inicio de sesión (home page, parte inferior)

### Header Actual
El `AppBar` actual (línea 2110 de `main.dart`):
```dart
appBar: AppBar(
  title: Image.asset(
    'assets/branding/logo-header.png',
    height: 40,
    fit: BoxFit.contain,
  ),
),
```
- Logo centrado
- **Sin acciones (actions) a la derecha**
- Diseño minimalista

---

## 2. Propuesta de Implementación

### Concepto
Añadir un **botón de icona en el header (derecha)** que al hacer clic abra un **modal/bottom sheet** con una **galería visual de spreads** en formato de malla de iconas cuadradas.

### Diseño Visual

#### 2.1. Botón en el Header
```dart
appBar: AppBar(
  title: Image.asset(...),
  actions: [
    IconButton(
      icon: Icon(Icons.grid_view), // o Icons.dashboard
      onPressed: _showSpreadGallery,
      tooltip: 'Seleccionar Tirada',
    ),
  ],
),
```

**Icono sugerido:** `Icons.grid_view` o `Icons.dashboard` (representa una cuadrícula de opciones)

#### 2.2. Modal de Galería (Bottom Sheet)
```dart
void _showSpreadGallery() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => SpreadGalleryModal(
      selectedSpread: _selectedSpread,
      onSpreadSelected: (spread) {
        setState(() {
          _selectedSpread = spread;
        });
        Navigator.pop(context);
      },
    ),
  );
}
```

**Características del modal:**
- Fondo semi-transparente con gradiente cósmico (matching app theme)
- Altura: 70% de la pantalla (scrollable si necesario)
- Border radius superior: 24px
- Animación de entrada: slide up

#### 2.3. Layout de la Galería

**Grid de 2 columnas** en pantallas pequeñas (móvil):
```dart
GridView.builder(
  padding: EdgeInsets.all(16),
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.85, // Ligeramente más alto que ancho
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
  ),
  itemCount: TarotSpreads.all.length,
  itemBuilder: (context, index) {
    final spread = TarotSpreads.all[index];
    return _SpreadCard(
      spread: spread,
      isSelected: spread.id == selectedSpread.id,
      onTap: () => onSpreadSelected(spread),
    );
  },
)
```

#### 2.4. Tarjeta Individual de Spread

Cada tarjeta contendrá:
1. **Icona SVG** (si existe) o placeholder icon
2. **Nombre del spread**
3. **Número de cartas**
4. **Indicador de selección** (borde brillante si seleccionado)

```dart
class _SpreadCard extends StatelessWidget {
  final TarotSpread spread;
  final bool isSelected;
  final VoidCallback onTap;

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              TarotTheme.cosmicBlue.withOpacity(0.2),
              TarotTheme.twilightPurple.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
              ? TarotTheme.cosmicAccent
              : TarotTheme.stardust.withOpacity(0.3),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: TarotTheme.cosmicAccent.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ] : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icona SVG o placeholder
              Expanded(
                flex: 3,
                child: _getSpreadIcon(spread),
              ),
              SizedBox(height: 8),
              // Nombre
              Expanded(
                flex: 1,
                child: Text(
                  spread.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: TarotTheme.moonlight,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Número de cartas
              Text(
                '${spread.cardCount} cartas',
                style: TextStyle(
                  fontSize: 11,
                  color: TarotTheme.stardust.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 3. Mapeo de Iconas SVG a Spreads

### Mapeo Directo
```dart
String? _getSpreadIconPath(String spreadId) {
  switch (spreadId) {
    case 'three_card':
      return 'assets/spread-buttons/three-card-spread.svg';
    case 'celtic_cross':
      return 'assets/spread-buttons/celtic-cross-spread.svg';
    case 'simple_cross':
      // NO HAY SPREAD CON ID 'simple_cross' en la app
      // Esta icona podría usarse para 'horseshoe' o quedar sin usar
      return null;
    default:
      return null; // Usar placeholder icon
  }
}
```

### Placeholder para Spreads sin Icona

Para los 5 spreads sin icona SVG, usar iconas de Material Icons:

```dart
IconData _getPlaceholderIcon(String spreadId) {
  switch (spreadId) {
    case 'single':
      return Icons.rectangle_outlined;
    case 'relationship':
      return Icons.favorite_border;
    case 'pyramid':
      return Icons.change_history; // Triángulo
    case 'horseshoe':
      return Icons.u_turn_right; // Herradura
    case 'star':
      return Icons.star_border;
    case 'year_ahead':
      return Icons.calendar_month;
    default:
      return Icons.grid_on;
  }
}

Widget _getSpreadIcon(TarotSpread spread) {
  final svgPath = _getSpreadIconPath(spread.id);

  if (svgPath != null) {
    // Usar SvgPicture de flutter_svg
    return SvgPicture.asset(
      svgPath,
      fit: BoxFit.contain,
    );
  } else {
    // Usar placeholder icon
    return Icon(
      _getPlaceholderIcon(spread.id),
      size: 64,
      color: TarotTheme.cosmicAccent.withOpacity(0.7),
    );
  }
}
```

---

## 4. Dependencias Necesarias

### flutter_svg
Para renderizar las iconas SVG:

```yaml
# pubspec.yaml
dependencies:
  flutter_svg: ^2.0.0
```

Instalación:
```bash
flutter pub add flutter_svg
```

---

## 5. Tareas Pendientes (TODO)

### Iconas SVG Faltantes (5 spreads)
Para completar la experiencia visual, se deberían crear iconas SVG para:

1. **Single Card** - Una sola carta centrada
2. **Relationship** - Dos cartas enfrentadas con un corazón/conexión
3. **Pyramid** - 6 cartas en forma de pirámide (3-2-1)
4. **Horseshoe** - 7 cartas en forma de herradura
5. **Star** - 7 cartas en forma de estrella de 7 puntas
6. **Year Ahead** - 12 cartas en 2 filas (representando 12 meses)

**Estilo a seguir:** Mismo diseño que las 3 iconas existentes:
- Viewbox: 200x200
- Background: Gradiente #6D82CD → #9B8FD9
- Border radius: 20px
- Cards: Gradiente blanco con sombras
- Stroke: #6D82CD

### Reutilizar simple-cross-spread.svg
La icona `simple-cross-spread.svg` podría asignarse a `horseshoe` temporalmente, ya que no hay ningún spread con ID `simple_cross` en la app.

---

## 6. Flujo de Usuario (UX)

### Estado Inicial
1. Usuario ve el header con logo centrado + icono de cuadrícula a la derecha
2. El icono tiene un badge/dot si hay spreads nuevos o recomendados (opcional)

### Interacción
1. Usuario toca el icono de cuadrícula
2. Modal slide-up animation (300ms)
3. Galería aparece con el spread actualmente seleccionado resaltado
4. Usuario puede scroll si hay muchos spreads
5. Al tocar un spread:
   - Animación de selección (escala + glow)
   - Modal se cierra automáticamente
   - El spread seleccionado se actualiza en el formulario de inicio

### Accesibilidad
- Tooltip en el botón del header
- Labels semánticos para screen readers
- Contraste de colores WCAG AA compliant
- Tap targets de 48x48 dp mínimo

---

## 7. Ventajas de esta Implementación

### Visual Appeal
✅ Experiencia más inmersiva y "táctil"
✅ Iconas SVG crean conexión emocional con cada tirada
✅ Consistencia visual con el tema cósmico de la app

### UX Improvements
✅ Acceso rápido desde cualquier pantalla (header siempre visible)
✅ Vista previa visual ayuda a elegir el spread adecuado
✅ Reduce fricción vs dropdown de texto
✅ Descubribilidad: usuarios ven todos los spreads disponibles

### Escalabilidad
✅ Fácil añadir nuevos spreads en el futuro
✅ Grid responsive se adapta a tablets/pantallas grandes
✅ Placeholder icons permiten lanzar sin todas las SVG listas

### Separación de Concerns
✅ Modal reutilizable en otras partes de la app
✅ Selector actual (dropdown) se mantiene en formulario como fallback
✅ No rompe navegación existente

---

## 8. Alternativas Consideradas

### A. Menu Hamburger
❌ Menos intuitivo para esta acción específica
❌ Requiere más taps (open menu → find option → select)
✅ Más espacio para descripciones largas

### B. Bottom Navigation Bar
❌ Ocupa espacio permanente en pantalla
❌ Limita a 5 opciones máximo (tenemos 8 spreads)
✅ Acceso más rápido (1 tap)

### C. Swipeable Tabs
❌ No escala bien con 8+ opciones
❌ Difícil descubrir todas las opciones
✅ Bueno para 3-4 opciones principales

**Decisión:** Modal con grid es la mejor opción porque:
- Soporta 8+ spreads sin problemas
- Permite iconas grandes y descriptivas
- No consume espacio permanente
- Es el patrón estándar para "seleccionar de galería"

---

## 9. Implementación Paso a Paso

### Fase 1: UI Básica (Sin SVG completas)
1. Añadir `flutter_svg` dependency
2. Crear `SpreadGalleryModal` widget
3. Añadir botón en AppBar actions
4. Implementar grid con placeholder icons
5. Conectar selección con estado del formulario

**Estimación:** 2-3 horas

### Fase 2: Integración de SVG Existentes
1. Cargar 3 SVG existentes en las tarjetas correspondientes
2. Verificar rendering en diferentes tamaños de pantalla
3. Ajustar padding/sizing si necesario

**Estimación:** 30 minutos

### Fase 3: Crear SVG Faltantes
1. Diseñar 5 iconas SVG restantes
2. Mantener consistencia de estilo
3. Optimizar SVG (eliminar metadatos innecesarios)
4. Añadir a assets y pubspec.yaml

**Estimación:** 3-4 horas (depende de habilidad de diseño)

### Fase 4: Polish & Testing
1. Animaciones de transición
2. Haptic feedback en selección
3. Testing en diferentes dispositivos
4. Ajustes de rendimiento

**Estimación:** 1-2 horas

**Total Estimado:** 7-10 horas para implementación completa

---

## 10. Archivos a Crear/Modificar

### Nuevos Archivos
```
apps/tarot/lib/widgets/spread_gallery_modal.dart  # Modal principal
apps/tarot/lib/widgets/spread_card.dart           # Tarjeta individual
apps/tarot/assets/spread-buttons/single-card-spread.svg
apps/tarot/assets/spread-buttons/relationship-spread.svg
apps/tarot/assets/spread-buttons/pyramid-spread.svg
apps/tarot/assets/spread-buttons/horseshoe-spread.svg
apps/tarot/assets/spread-buttons/star-spread.svg
apps/tarot/assets/spread-buttons/year-ahead-spread.svg
```

### Archivos a Modificar
```
apps/tarot/lib/main.dart                          # Añadir botón en AppBar
apps/tarot/pubspec.yaml                           # Añadir flutter_svg + nuevas assets
apps/tarot/lib/models/tarot_spread.dart           # Opcional: añadir getIconPath()
```

---

## 11. Consideraciones Técnicas

### Performance
- SVG pueden ser pesados: optimizar con SVGO
- Lazy loading de iconas si hay muchas
- Cache de SvgPicture para re-renders

### Asset Management
```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/spread-buttons/
```

### Responsive Design
```dart
// Ajustar columnas según ancho de pantalla
int getCrossAxisCount(double width) {
  if (width > 600) return 3; // Tablet landscape
  if (width > 400) return 2; // Phone landscape
  return 2; // Phone portrait
}
```

---

## 12. Próximos Pasos Recomendados

1. **Crear mockup/wireframe** del modal para validar con usuario
2. **Diseñar las 5 iconas SVG faltantes** (o contratar diseñador)
3. **Implementar Fase 1** (UI básica con placeholders)
4. **Testing con usuarios** para validar UX
5. **Completar Fase 2-4** según feedback

---

## Conclusión

La galería de spreads en el header es una mejora significativa de UX que:
- **Reduce fricción** en la selección de tiradas
- **Mejora descubribilidad** de spreads menos conocidos
- **Aumenta engagement** con una experiencia más visual
- **Escala bien** para futuros spreads adicionales

La implementación es **modular y no intrusiva**, permitiendo lanzar incrementalmente y mantener el selector actual como fallback.

**Riesgo Bajo** | **Impacto Alto** | **Esfuerzo Medio**
