# Backend URL - Solució Definitiva

**Data**: 2025-11-09
**Problema**: Confusió entre múltiples URLs de backend

## URLs Verificades

| URL | Estat | Ús |
|-----|-------|-----|
| `smart-divination-production.vercel.app` | ✅ FUNCIONA | **PRODUCTION (oficial)** |
| `backend-gv4a2ueuy-dnitzs-projects.vercel.app` | ✅ FUNCIONA | Antic (legacy) |
| `smart-divination.vercel.app` | ❌ 404 | Monorepo (no backend) |

## Solució Implementada

### 1. Codi Actualitzat

**Fitxer**: `smart-divination/apps/tarot/lib/api/api_client.dart`

```dart
const String _productionApiBase =
    'https://smart-divination-production.vercel.app';
```

### 2. Lògica de Resolució

```dart
String _resolveApiBaseUrl() {
  // 1. Runtime override (per testing manual)
  if (_runtimeApiBaseOverride != null) return _runtimeApiBaseOverride;

  // 2. Compile-time environment (--dart-define)
  if (_environmentApiBaseUrl.isNotEmpty) return _environmentApiBaseUrl;

  // 3. Local development mode
  if (_useLocalApi) return 'http://localhost:3001';

  // 4. Production fallback (DEFAULT)
  return 'https://smart-divination-production.vercel.app';
}
```

### 3. Builds

**Production APK** (recomanat):
```bash
cd smart-divination/apps/tarot
JAVA_HOME="/c/tarot/temp/jdk/jdk-17.0.2" flutter build apk --release
```

**IMPORTANT**: NO usar `--dart-define=API_BASE_URL=...` en production builds.

## Tests Realitzats

- ✅ App arranca correctament
- ✅ Lunar widget es carrega
- ✅ Daily draw es genera (amb backend production)
- ✅ Navigation funciona
- ✅ No crashes

## Manteniment

Per actualitzar la URL production en el futur:
1. Editar `api_client.dart` línea 14
2. Rebuild APK sense --dart-define
3. Test exhaustiu
