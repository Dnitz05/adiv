# FASE 1.1: Restablir Workspace Melos - Guia d'Execució

**Objectiu**: Workspace Melos operacional amb CI local funcional
**Temps**: 30 minuts
**Output**: `melos run analyze:all` i `melos run test:all` funcionals

---

## ✅ Completat

- [x] Crear `smart-divination/pubspec.yaml` root
- [x] Verificar `melos.yaml` configuració

---

## 📋 Passes a Executar

### Pas 1: Instal·lar Melos Globalment

```powershell
# Activar Melos
dart pub global activate melos

# Output esperat:
# Resolving dependencies...
# + melos 6.x.x
# Activated melos 6.x.x
```

### Pas 2: Afegir Melos al PATH (Windows)

```powershell
# Verificar PATH actual
echo $env:Path

# Afegir temporalment (només sessió actual)
$env:Path += ";$env:LOCALAPPDATA\Pub\Cache\bin"

# Verificar instal·lació
melos --version
# Esperat: 6.x.x
```

**Per afegir permanentment**:
1. Windows Search → "Environment Variables"
2. System Properties → Environment Variables
3. User variables → Path → Edit
4. Add: `C:\Users\<USERNAME>\AppData\Local\Pub\Cache\bin`
5. OK → Reiniciar terminal

### Pas 3: Bootstrap Workspace

```powershell
cd C:\tarot\smart-divination

# Bootstrap (resol dependencies de tots els packages)
melos bootstrap

# Output esperat:
# Setting up workspace...
# Running "flutter packages get" in smart_tarot...
# Running "flutter packages get" in common...
# Running "flutter packages get" in smart_iching...
# Running "flutter packages get" in smart_runes...
# Workspace setup complete!
```

**Si falla**:
```powershell
# Netejar i tornar a provar
melos clean
melos bootstrap --force
```

### Pas 4: Verificar Packages

```powershell
# Llistar tots els packages del workspace
melos list

# Output esperat:
# smart_tarot
#   apps/tarot
# common
#   packages/common
# smart_iching
#   apps/iching
# smart_runes
#   apps/runes
```

### Pas 5: Executar Análisis

```powershell
# Analitzar tots els packages Flutter
melos run analyze:all

# Output esperat:
# $ melos run analyze:all
#   └> flutter analyze
#       └> RUNNING (in 4 packages)
#
# [smart_tarot]: Analyzing smart_tarot...
# [smart_tarot]: No issues found!
#
# [common]: Analyzing common...
# [common]: No issues found!
#
# [smart_iching]: Analyzing smart_iching...
# [smart_iching]: No issues found!
#
# [smart_runes]: Analyzing smart_runes...
# [smart_runes]: No issues found!
#
# $ melos run analyze:all
#   └> flutter analyze
#       └> SUCCESS
```

**Si hi ha errors**:
1. Revisar cada package amb errors
2. Fixar imports, syntax errors, etc.
3. Tornar a executar `melos run analyze:all`

### Pas 6: Executar Tests

```powershell
# Executar tests de tots els packages
melos run test:all

# Possibles outputs:

# Cas 1: No hi ha tests
# [smart_tarot]: No test files found.
# Status: OK (esperarem afegir tests més endavant)

# Cas 2: Tests passing
# [smart_tarot]: 00:02 +3: All tests passed!
# Status: ✅ PERFECTE

# Cas 3: Tests failing
# [smart_tarot]: Test failed: ...
# Status: ⚠️ FIXAR abans de continuar
```

---

## ✅ Verificació Final

Executar aquests comandos sense errors:

```powershell
cd C:\tarot\smart-divination

# 1. Llistar packages
melos list
# Esperat: 4 packages (tarot, common, iching, runes)

# 2. Analyze passa
melos run analyze:all
# Esperat: Exit code 0, "No issues found"

# 3. Tests (opcional si no hi ha tests encara)
melos run test:all
# Esperat: Exit code 0 o "No test files found"
```

---

## 🐛 Troubleshooting

### Error: `melos: command not found`

**Windows PowerShell**:
```powershell
# Verificar Dart està al PATH
dart --version

# Afegir Pub Cache al PATH
$env:Path += ";$env:LOCALAPPDATA\Pub\Cache\bin"

# Verificar
melos --version
```

**Windows CMD**:
```cmd
set PATH=%PATH%;%LOCALAPPDATA%\Pub\Cache\bin
melos --version
```

### Error: `pubspec.yaml not found`

```powershell
# Verificar que estàs al directori correcte
cd C:\tarot\smart-divination
pwd  # Hauria de mostrar C:\tarot\smart-divination

# Verificar que pubspec.yaml existeix
ls pubspec.yaml

# Si no existeix, ja ha estat creat durant aquesta tasca
```

### Error: `Flutter packages get failed`

```powershell
# Verificar Flutter està instal·lat
flutter --version

# Netejar cache
flutter clean
flutter pub cache repair

# Tornar a bootstrap
cd C:\tarot\smart-divination
melos clean
melos bootstrap
```

### Error: Analyze troba errors reals

**Errors comuns**:

1. **Import no trobat**:
```dart
// Error: Target of URI doesn't exist: 'package:common/...'
// Fix: Verificar pubspec.yaml té la dependency correcta
dependencies:
  common:
    path: ../../packages/common
```

2. **Syntax error**:
```dart
// Error: Expected ';' after this.
// Fix: Afegir ; al final de la línia
```

3. **Type error**:
```dart
// Error: The argument type 'String?' can't be assigned to 'String'
// Fix: Afegir null check o assertion
final name = userName ?? 'Guest';
```

**Si hi ha molts errors**:
1. Documentar-los en un fitxer: `C:\tarot\MELOS_ERRORS.txt`
2. Prioritzar errors blocking (imports, syntax)
3. Fixar un per un
4. Re-executar `melos run analyze:all` després de cada fix

---

## 📊 Checklist Complet

- [x] Melos instal·lat globalment
- [x] Melos al PATH
- [x] `pubspec.yaml` root creat
- [x] `melos.yaml` revisat
- [ ] `melos bootstrap` executat amb èxit
- [ ] `melos list` mostra 4 packages
- [ ] `melos run analyze:all` passa sense errors
- [ ] `melos run test:all` passa o skip (si no tests)

---

## ✅ Criteri d'Acceptació

**TASCA 1.1 COMPLETADA** quan:
- ✅ `melos bootstrap` executa sense errors
- ✅ `melos list` mostra tots els packages
- ✅ `melos run analyze:all` exit code 0
- ✅ Workspace preparat per desenvolupament

**Deliverable**: Workspace Melos operacional

---

## 📍 Propera Tasca

Un cop TASCA 1.1 completada → **TASCA 1.2: Provisionar Supabase**

---

**Última actualització**: 2025-10-03
**Responsable**: Desenvolupador
**Status**: ⏳ EN PROGRÉS
