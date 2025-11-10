# PLA CONSOLIDAT FINAL - SMART DIVINATION TAROT

**Versio**: 2.0 (Ajustada amb feedback programador)
**Data**: 2025-10-03
**Enfocament**: Balanced - MVP -> Hardening -> Full Platform

---

**Decisio actual**: Prioritzem el llancament Android (Fase 1). Tasques iOS (Fase 2) queden en pausa fins que disposem d'un Mac per signatura i builds.

## CANVIS RESPECTE VERSIO ANTERIOR

### [OK] Ajustos Implementats

1. **GitHub Actions secrets mogut a final Fase 1** (abans Fase 2)
   - Rao: CI/CD pipeline necessita validar builds abans de publicar
   - Nova posicio: Tasca 1.7 (abans de Play Store metadata)

2. **QA manual critica abans de publicar** (abans nomes smoke tests)
   - Rao: Reduir risc abans d'alliberar binaris
   - Cobertura: 45 tests (20 core, 3 de seguretat, 22 de regressio manual)
   - Nova posicio: Tasca 1.6 (abans de Play Store)

3. **Fix workspace Melos inclos a Fase 1**
   - Rao: Bloqueja validacio local (`melos run analyze:all/test:all`)
   - Accio: Crear `pubspec.yaml` root si necessari
   - Nova posicio: Tasca 1.1 (primera tasca)

4. **Verificacio Supabase schema afegida**
   - Rao: Assegurar `supabase db push` aplicat correctament
   - Accio: Query SQL per verificar taules + seed data
   - Nova posicio: Tasca 1.2 (ampliada)

5. **Metadades Play Store documentades**
   - Rao: Consolidar requisits de Play Console abans de la submissio
   - Accio: Consultar `docs/PLAY_STORE_SUBMISSION.md`
   - Nova posicio: Tasca 1.8 (nova)

6. **Auditoria RLS combinada amb tests penetracio**
   - Rao: Eficiencia + cobertura completa
   - Tests: RLS policies + SQL injection + XSS + auth bypass
   - Nova posicio: Tasca 2.3 (fusionada)

---

## ESTRUCTURA DEL PLA (3 FASES - 20 TASQUES)

### **FASE 1: MVP BETA (Setmana 1) - 9 tasques**
Objectiu: Android beta validat i publicat amb CI/CD funcional

### **FASE 2: HARDENING (Setmana 2-3) - 5 tasques**
Objectiu: iOS + QA complet + seguretat auditada + closed beta
**Dependencia critica**: requereix acces a un Mac amb Xcode per signar i compilar l'app iOS; sense aquest hardware, les tasques 2.1-2.4 romanen bloquejades.

### **FASE 3: FULL PLATFORM (Setmana 4-6) - 6 tasques**
Objectiu: Features completes + observabilitat + documentacio

---

## FASE 1: MVP BETA ANDROID (Setmana 1)

**Temps total**: 10-14 hores
**Output**: Beta funcional a Google Play Internal Testing + CI/CD operacional

---

### [OK] **TASCA 1.1: Restablir Workspace Melos**
**Temps**: 30 min
**Prioritat**:  CRITICA

#### Problema Actual
```bash
cd C:\tarot\smart-divination
melos run analyze:all
# Error: No pubspec.yaml found at root
```

#### Solucio

**Pas 1: Verificar si cal pubspec.yaml root**
```bash
cd C:\tarot\smart-divination

# Verificar estructura
ls
# Esperat: melos.yaml, apps/, packages/

# Testar sense pubspec.yaml root
melos bootstrap

# Si falla amb error "No pubspec.yaml", crear-lo
```

**Pas 2: Crear pubspec.yaml root (si necessari)**
```yaml
# C:\tarot\smart-divination\pubspec.yaml
name: smart_divination_workspace
description: Melos workspace for Smart Divination monorepo
publish_to: none

environment:
  sdk: '>=3.5.0 <4.0.0'

# No dependencies - aixo es nomes per Melos
dependencies:

dev_dependencies:
  melos: ^6.0.0
```

**Pas 3: Bootstrap i verificar**
```bash
# Activar Melos
dart pub global activate melos

# Afegir al PATH (Windows)
# System Properties -> Environment Variables -> Path
# Afegir: C:\Users\<USERNAME>\AppData\Local\Pub\Cache\bin

# Bootstrap
cd C:\tarot\smart-divination
melos bootstrap

# Verificar packages
melos list
# Esperat:
# - smart_tarot (apps/tarot)
# - common (packages/common)

# Executar analisis
melos run analyze:all
# Esperat: [OK] No issues found

# Executar tests
melos run test:all
# Esperat: Tests pass o skip si no hi ha
```

**Troubleshooting**:
```bash
# Si bootstrap falla:
melos clean
flutter clean
melos bootstrap --force

# Si analyze falla amb errors reals:
# Documentar errors i fixar abans de continuar
```

#### [OK] Verificacio
```bash
melos list           # Mostra 2+ packages
melos run analyze:all    # Exit code 0
# melos run test:all      # Opcional - pot skip si no tests
```

**Deliverable**: Workspace Melos operacional amb CI local funcional

---

### [OK] **TASCA 1.2: Crear Supabase Produccio + Verificar Schema**
**Temps**: 45-60 min
**Prioritat**:  CRITICA

#### Pas 1: Crear Projecte
1. https://supabase.com/dashboard -> **New Project**
2. Config:
   - Name: `smart-divination-prod`
   - Password: Generar fort (guardar!)
   - Region: `eu-west-1` (Frankfurt)
   - Plan: Free
3.  Esperar 2-3 min

#### Pas 2: Copiar Credencials
Dashboard -> Settings -> API

```ini
# GUARDAR EN LLOC SEGUR (1Password, Bitwarden)
Project URL: https://xxxxxx.supabase.co
Project ID: xxxxxx
anon key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
service_role key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Database Password: <el que has generat>
```

#### Pas 3: Aplicar Migracions
```bash
cd C:\tarot

# Link project
supabase link --project-ref <PROJECT_ID>

# Push migracions
supabase db push

# Esperat:
# [OK] Applying migration 20250101000001_initial_schema.sql
# [OK] Applying migration 20250922090000_session_history_schema.sql
```

#### Pas 4: **VERIFICAR SCHEMA (NOU)** [Important]
```sql
-- Dashboard -> SQL Editor
-- Executar aquesta query:

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- Esperat (minim):
-- api_usage
-- session_artifacts
-- session_messages
-- sessions
-- user_stats
-- users
```

**Verificar views i functions**:
```sql
-- Verificar view session_history_expanded existeix
SELECT COUNT(*) FROM session_history_expanded;
-- Esperat: 0 (buit pero existeix)

-- Verificar trigger function
SELECT routine_name
FROM information_schema.routines
WHERE routine_schema = 'public'
  AND routine_name = 'touch_session_history';
-- Esperat: 1 row (touch_session_history)
```

#### Pas 5: Seed Data (Opcional)
```sql
-- Copiar tot de: C:\tarot\supabase\seeds\dev_seed.sql
-- Executar al SQL Editor

-- Verificar seed
SELECT email FROM users;
-- Esperat: demo@smartdivination.app
```

#### [OK] Verificacio Final
```bash
# Test connexio
supabase db diff
# Esperat: No differences

# Ping database
psql $DATABASE_URL -c "SELECT NOW();"
# Esperat: Current timestamp
```

**Deliverable**:
- Supabase prod operacional
- Schema aplicat i verificat
- Credencials guardades segures

---

### [OK] **TASCA 1.3: DeepSeek + .env.production**
**Temps**: 20 min
**Prioritat**:  CRITICA

*(Sense canvis respecte versio anterior)*

#### DeepSeek
1. https://platform.deepseek.com/
2. Sign up
3. API Keys -> Create
4. Copiar `sk-proj-...`

#### .env.production
```bash
code C:\tarot\smart-divination\backend\.env.production
```

```env
# Supabase (de Tasca 1.2)
SUPABASE_URL=https://xxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGci...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGci...

# DeepSeek
DEEPSEEK_API_KEY=sk-proj-xxxxxx

# Feature Flags
ENABLE_ICHING=false
ENABLE_RUNES=false

# Metrics
METRICS_PROVIDER=console
NODE_ENV=production
```

#### Verificar Local
```bash
cd smart-divination/backend
copy .env.production .env.local
npm run dev

# Test
curl http://localhost:3001/api/health
# Esperat: {"status":"healthy"}
```

**Deliverable**: `.env.production` amb credencials reals verificat localment

---

### [OK] **TASCA 1.4: Deploy Vercel**
**Temps**: 60 min
**Prioritat**:  CRITICA

*(Sense canvis respecte versio anterior)*

```bash
cd C:\tarot\smart-divination\backend

vercel login
vercel link
# Name: smart-divination-backend

# Configurar env vars (8 variables)
vercel env add SUPABASE_URL production
vercel env add SUPABASE_ANON_KEY production
vercel env add SUPABASE_SERVICE_ROLE_KEY production
vercel env add DEEPSEEK_API_KEY production
vercel env add ENABLE_ICHING production  # false
vercel env add ENABLE_RUNES production   # false
vercel env add METRICS_PROVIDER production  # console
vercel env add NODE_ENV production

# Deploy
vercel --prod

# ANOTAR URL:
# https://backend-gv4a2ueuy-dnitzs-projects.vercel.app
```

#### Verificar
```bash
$URL = "https://backend-gv4a2ueuy-dnitzs-projects.vercel.app"
curl "$URL/api/health"
curl "$URL/api/metrics"
```

**Deliverable**: Backend en produccio verificat

---

### [OK] **TASCA 1.5: Build APK Android Test**
**Temps**: 30 min
**Prioritat**:  CRITICA

```bash
cd C:\tarot\smart-divination\apps\tarot

$API_URL = "https://backend-gv4a2ueuy-dnitzs-projects.vercel.app"
$SUPABASE_URL = "https://xxxxxx.supabase.co"
$SUPABASE_ANON = "eyJhbGci..."

flutter build apk --release `
  --dart-define=API_BASE_URL=$API_URL `
  --dart-define=SUPABASE_URL=$SUPABASE_URL `
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON

# Output: build\app\outputs\apk\release\app-release.apk
```

#### Instal-lar
```bash
# USB
adb install -r build\app\outputs\apk\release\app-release.apk

# O compartir APK via Drive/Dropbox
```

**Deliverable**: APK instal-lat en 1+ dispositius test

---

### [OK] **TASCA 1.6: QA Manual Critic + Seguretat Basica** [Priority]
**Temps**: 2-3h
**Prioritat**:  CRITICA (NOU - abans era opcional)

#### Tests Core (20 tests obligatoris)

**Categoria: Authentication (5 tests)**
```markdown
[ ] 1. App obre sense crash
[ ] 2. Sign up amb email nou
[ ] 3. Sign in amb credencials correctes
[ ] 4. Sign in amb password incorrecte (error esperat)
[ ] 5. Sign out funcional
```

**Categoria: Tarot Draw (7 tests)**
```markdown
[ ] 6. Dashboard es carrega amb eligibility
[ ] 7. Draw form visible i editable
[ ] 8. Draw sense question funciona
[ ] 9. Draw amb question funciona
[ ] 10. Cartes es mostren correctament
[ ] 11. Seed es consistent (mateix seed = mateixes cartes)
[ ] 12. Allow reversed toggle funciona
```

**Categoria: Interpretation (3 tests)**
```markdown
[ ] 13. Request interpretation button apareix
[ ] 14. Loading indicator durant generacio
[ ] 15. Interpretacio AI es mostra (text llarg generat)
```

**Categoria: History (3 tests)**
```markdown
[ ] 16. Historial mostra draws recents
[ ] 17. Details correctes (cartes, question, data)
[ ] 18. Historial persisteix despres sign out/in
```

**Categoria: Session Limits (2 tests)**
```markdown
[ ] 19. Eligibility card mostra limits correctes
[ ] 20. Bloqueig quan limits exhaurits (si aplica)
```

#### Tests Seguretat Basica (3 tests obligatoris) [Required]

**Test 1: SQL Injection**
```bash
# Testar API directament
curl -X POST https://<backend-url>/api/draw/cards \
  -H "Content-Type: application/json" \
  -d '{
    "question": "test'; DROP TABLE users; --",
    "spread": "three-card"
  }'

# Esperat:
# - NO crash del servidor
# - Error 400/401 o resposta normal
# - Taula users existeix encara
```

**Test 2: XSS (Cross-Site Scripting)**
```bash
# Crear draw amb payload XSS
curl -X POST https://<backend-url>/api/draw/cards \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "question": "<script>alert(\"XSS\")</script>",
    "spread": "three-card"
  }'

# Verificar a l'app:
# - El script NO s'executa
# - Es mostra com text pla o sanititzat
```

**Test 3: Auth Bypass**
```bash
# Intent accedir session d'altre user
curl https://<backend-url>/api/sessions/<OTHER_USER_ID>

# Esperat: 401 Unauthorized o 403 Forbidden
```

#### Documentar Resultats

Crear: `C:\tarot\QA_FASE1_RESULTS.md`
```markdown
# QA FASE 1 - Resultats

**Data**: 2025-10-03
**Build**: app-release.apk v1.0.0 (1)
**Tester**: <nom>

## Core Tests (20/20)
- [x] Auth: 5/5 [OK]
- [x] Draw: 7/7 [OK]
- [x] Interpretation: 3/3 [OK]
- [x] History: 3/3 [OK]
- [x] Limits: 2/2 [OK]

## Seguretat (3/3)
- [x] SQL Injection: PASS [OK]
- [x] XSS: PASS [OK]
- [x] Auth Bypass: PASS [OK]

## Bugs Trobats
1. (cap) o llistat de bugs

## Sign-off
- [ ] APK aprovat per internal testing
```

#### [OK] Verificacio
- **Minim**: 18/20 core tests passing (90%)
- **Obligatori**: 3/3 seguretat tests passing (100%)
- Bugs bloquejants documentats i fixats

**Deliverable**: QA report amb sign-off

---

### [OK] **TASCA 1.7: GitHub Actions Secrets** [Priority]
**Temps**: 1-2h
**Prioritat**:  ALTA (MOGUDA de Fase 2)

**Rao del canvi**: Necessari per validar builds via CI/CD abans de futures publishes.

#### Executar Script
```powershell
cd C:\tarot\scripts
.\setup-github-secrets.ps1
```

#### Estat actual
- Consultar `scripts/github-secrets-output.txt` per veure tots els valors marcats com READY.
- Android: `smart-tarot-upload` / `SmartTarot2025!` + `ANDROID_KEYSTORE_BASE64` ja generat pel script.
- Backend/Supabase/DeepSeek/Random.org: valors extrets de `.env.production` i listats al fitxer.
- Vercel: `VERCEL_ORG_ID` i `VERCEL_PROJECT_ID` disponibles; cal generar `VERCEL_TOKEN` manualment a https://vercel.com/account/tokens.
- iOS: secrets marcats com "on hold" fins disposar d'entorn macOS (s'apuntara a Tasca 2.1).

#### Passos
1. Obrir GitHub -> Settings -> Secrets and variables -> Actions.
2. Afegir cadascun dels secrets READY (Android, Supabase, DeepSeek, Random.org, Vercel IDs) copiant des del fitxer.
3. Crear `VERCEL_TOKEN`, afegir-lo com a secret i provar `vercel --prod --confirm` manualment.
4. Documentar al mateix fitxer que els secrets iOS resten pendents (referencia Tasca 2.1).
5. Llancar workflow de prova:
```bash
git commit --allow-empty -m "ci: secret smoke"
git push
```
6. Confirmar que el pipeline passa (`npm test`, `npm run type-check`, `flutter test` si aplicable).

#### [OK] Verificacio
- [ ] `scripts/github-secrets-output.txt` revisat i compartit.
- [ ] Secrets Android + backend + Vercel afegits a GitHub.
- [ ] `VERCEL_TOKEN` creat i provat.
- [ ] Workflow de CI complet sense errors.
- [ ] Secrets iOS registrats com a pendents (Tasca 2.1).

**Deliverable**: CI/CD Android operatiu amb secrets configurats i iOS diferit.

---


**Temps total**: 12-18 hores
**Output**: iOS beta + QA complet + seguretat auditada

---


### [OK] **TASCA 1.8: Preparar Metadades Play Store** [Priority]
**Temps**: 1-2h
**Prioritat**:  ALTA (NOVA TASCA)

#### Estat actual
- `docs/PLAY_STORE_SUBMISSION.md` ja cont? la checklist detallada d'Android (focus internal testing).
- Descripcio curta/llarga en esborrany, pendent d'aprovacio final i localitzacions (es-ES, ca-ES).
- Falten materials grafics definitius (icon 512, feature 1024x500, captures 1080x1920).
- URL de privacitat pendent de desplegar a https://smartdivination.app/privacy.

#### Passos
1. Revisar i aprovar el copy (short + long) i generar versions es/ca.
2. Coordinar amb disseny per exportar icon i feature graphic segons rutes definides.
3. Capturar captures de pantalla en dispositius Android (sign-in, tres cartes, interpretacio, historial).
4. Publicar la politica de privacitat (Vercel static) i verificar l'URL.
5. Actualitzar el document de Play Store amb l'estat de cada element.

#### [OK] Verificacio
- [ ] Copy (en/es/ca) aprovat i enganxat a Play Console.
- [ ] Icona i feature graphic penjades.
- [ ] Captures validades (sense dades sensibles).
- [ ] URL de privacitat accessible i referenciat.
- [ ] Checklist de `docs/PLAY_STORE_SUBMISSION.md` marcada com completa.

**Deliverable**: Metadades Play Store llestes per carregar al tancament de Tasca 1.9.

### [OK] **TASCA 1.9: Build AAB + Publicar Internal Testing**
**Temps**: 2-3h
**Prioritat**:  CRITICA

#### Prerequisits
- Tasca 1.6 OK (QA passed)
- Tasca 1.8 OK (Materials preparats)
- Compte Google Play Developer ($25)

#### Build AAB
```bash
cd C:\tarot\smart-divination\apps\tarot

flutter build appbundle --release `
  --dart-define=API_BASE_URL=https://backend-gv4a2ueuy-dnitzs-projects.vercel.app `
  --dart-define=SUPABASE_URL=https://xxxxxx.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=eyJhbGci...

# Output: build\app\outputs\bundle\release\app-release.aab
```

#### Play Console Setup
1. https://play.google.com/console -> **Create app**
2. Store Listing (usar materials Tasca 1.8)
3. Content Rating
4. Target Audience
5. Data Safety
6. Internal Testing -> Upload AAB
7. Release notes: "First beta release"
8. Start rollout

#### Afegir Testers
```
Internal testing -> Testers -> Add email list:
tu@example.com
tester1@example.com
(max 100)
```

#### [OK] Verificacio
- [ ] AAB pujat correctament
- [ ] Internal testing actiu
- [ ] Link enviat a testers
- [ ] 1+ tester ha instal-lat

**Deliverable**: Beta publicada amb 5-10 testers

---
## RESUM FASE 1

### Temps Total
- 1.1 Melos: 30 min
- 1.2 Supabase + verificacio: 60 min
- 1.3 DeepSeek: 20 min
- 1.4 Vercel: 60 min
- 1.5 APK: 30 min
- 1.6 QA critic: 2-3h
- 1.7 GitHub secrets: 1-2h
- 1.8 Metadades: 1-2h
- 1.9 Play Store: 2-3h

**TOTAL: 10-14 hores** (3-4 dies a temps parcial)

### Deliverables
1. [OK] Workspace Melos funcional amb CI local
2. [OK] Supabase prod amb schema verificat
3. [OK] Backend Vercel en produccio
4. [OK] APK testat amb QA + seguretat
5. [OK] CI/CD pipeline amb secrets configurats
6. [OK] Metadades Play Store documentades
7. [OK] Beta a Internal Testing activa

### Blockers Resolts
-  Melos analyze/test fallaven -> [OK] Fixat (1.1)
-  Schema no verificat -> [OK] Verificacio SQL afegida (1.2)
-  QA insuficient pre-publish -> [OK] 20+3 tests obligatoris (1.6)
-  CI/CD sense secrets -> [OK] Secrets configurats (1.7)
-  Docs Play Store TODO -> [OK] Document creat (1.8)

---

## FASE 2: HARDENING (Setmana 2-3)
**Temps total**: 12-18 hores
**Output**: iOS beta + QA complet + seguretat auditada (en pausa)
**Blocador actual**: Sense acces a macOS per signatura i builds; reprendre quan hi hagi maquinari disponible.

### [OK] **TASCA 2.1: iOS Signing**
**Temps**: 2-4h
**Prerequisit**: Apple Developer Account + macOS

Seguir: `docs/IOS_SIGNING_GUIDE.md`

---

### [OK] **TASCA 2.2: QA Manual Complet** [Priority]
**Temps**: 4-6h
**Prioritat**:  CRITICA (MOGUDA abans de TestFlight)

**Rao**: Reduir risc abans de publish iOS

#### Preparacio build iOS per QA (sense TestFlight)
```bash
cd C:\tarot\smart-divination\apps\tarot
flutter build ipa --release \
  --dart-define=API_BASE_URL=https://backend-gv4a2ueuy-dnitzs-projects.vercel.app \
  --dart-define=SUPABASE_URL=https://xxxxxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGci...
# Utilitzar l'IPA localment via Xcode o Diawi per QA interna
```
Executar **TOTS** els 45 tests de `docs/QA_MANUAL_CHECKLIST.md`:
- Backend API: 14 tests
- Android App: 27 tests
- Security: 3 tests (ja fets a Fase 1, repetir)
- iOS App: 27 tests (quan iOS estigui)

**Deliverable**: Report complet amb <5% failure rate

---

### [OK] **TASCA 2.3: Auditoria Seguretat RLS + Penetracio** [Priority]
**Temps**: 3-4h
**Prioritat**:  CRITICA (FUSIONADA)

**Rao**: Combinar RLS audit amb penetration tests per eficiencia

#### RLS Policies Review
```sql
-- Verificar policies existeixen
SELECT schemaname, tablename, policyname
FROM pg_policies
WHERE schemaname = 'public';

-- Tests:
-- 1. User A no pot veure sessions User B
-- 2. Service role key bypassa RLS (backend only)
-- 3. Anon key te acces minim
```

#### Penetration Tests`\r\nExecutar **TOTS** els tests de `docs/QA_MANUAL_CHECKLIST.md` seccio Security:
- SQL Injection (API i Supabase)
- XSS (stored i reflected)
- CSRF
- Auth bypass
- IDOR
- Rate limiting

**Deliverable**: Security audit report + fixes aplicats

---

### [OK] **TASCA 2.4: Build iOS + TestFlight**
**Temps**: 2-3h
**Prerequisit**: Tasca 2.1 i 2.2 OK

```bash
flutter build ipa --release \
  --dart-define=API_BASE_URL=...

# Upload via Xcode o Transporter
# Configurar TestFlight
```

**Deliverable**: iOS beta a TestFlight amb testers

---

### [OK] **TASCA 2.5: Closed Beta Feedback**
**Temps**: Ongoing (1-2 setmanes)

- Invitar 100-500 users
- Recopilar feedback
- Iterar sobre bugs
- Preparar public launch

---

## FASE 3: FULL PLATFORM (Setmana 4-6)

*(Sense canvis respecte versio anterior - 6 tasques)*

3.1. I Ching + Runes persistencia
3.2. Premium packs + IAP
3.3. Datadog observability
3.4. Test coverage >80%
3.5. Store metadata complet
3.6. Public launch prep

**Temps total**: 24-34 hores

---

## COMPARACIO AMB VERSIO ANTERIOR

| Aspecte | v1.0 | v2.0 (Ajustada) |
|---------|------|-----------------|
| **Tasques Fase 1** | 6 | **9** (expanded) |
| **Melos fix** |  Absent | [OK] Tasca 1.1 |
| **Schema verification** |  Basica | [OK] SQL queries |
| **QA pre-publish** |  10 tests | [OK] 20+3 tests |
| **Metadades docs** |  TODO | [OK] Document creat |
| **GitHub secrets** | Fase 2 | [OK] Fase 1.9 |
| **Seguretat** | Fase 2 separate | [OK] Fusionat 2.3 |
| **Temps Fase 1** | 8-11h | **10-14h** |
| **Qualitat** |  Beta rapida | [OK] Beta validada |

---

## [OK] CHECKLIST FINAL

### Abans de comencar
- [ ] Dart/Flutter instal-lat
- [ ] Vercel CLI instal-lat
- [ ] Supabase CLI instal-lat
- [ ] Git configurat
- [ ] Android SDK configurat

### Fase 1 Completada
- [ ] Melos analyze/test passa
- [ ] Backend en produccio
- [ ] Supabase schema verificat
- [ ] QA 45/45 tests passing
- [ ] Play Store Internal Testing actiu
- [ ] CI/CD pipeline funcional

### Ready for Fase 2
- [ ] 10+ testers actius
- [ ] No crashes reportats
- [ ] Feedback positiu inicial

---

**Ultima actualitzacio**: 2025-10-03 (v2.0)
**Propera revisio**: Despres Fase 1 completada
