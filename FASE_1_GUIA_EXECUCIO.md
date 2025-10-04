# 🚀 FASE 1: MVP BETA ANDROID - GUIA D'EXECUCIÓ

**Objectiu**: App Android funcional amb backend en producció en **1 setmana**
**Output**: Beta publicada a Google Play Internal Testing amb 10+ testers

---

## ✅ TASCA 1: Restablir Workspace Melos

### Prerequisits
- Dart SDK instal·lat
- Flutter 3.24+ instal·lat
- Git configurat

### Passes

```powershell
# 1. Activar Melos globalment
dart pub global activate melos

# 2. Afegir Dart al PATH (si no està)
# Windows: Afegir al PATH del sistema:
# C:\Users\<USERNAME>\AppData\Local\Pub\Cache\bin

# 3. Verificar instal·lació
melos --version
# Esperat: Melos 6.x.x (o superior)

# 4. Bootstrap workspace
cd C:\tarot\smart-divination
melos bootstrap

# Esperat output:
# - Resolving dependencies for all packages
# - Generating workspace...
# - Workspace setup complete!

# 5. Verificar packages
melos list
# Esperat:
# - smart_tarot
# - common
# - (altres apps si existeixen)

# 6. Executar análisis
melos run analyze:all
# Esperat: No errors crítics

# 7. Executar tests
melos run test:all
# Esperat: Tests passing (o skip si no hi ha tests)
```

### Resolució de problemes comuns

**Error: `melos: command not found`**
```powershell
# Windows
$env:Path += ";$env:LOCALAPPDATA\Pub\Cache\bin"
# O afegir permanent via System Properties → Environment Variables
```

**Error: `pubspec.yaml not found`**
```powershell
# Verificar que estàs a smart-divination/
cd C:\tarot\smart-divination
pwd  # Hauria de mostrar: C:\tarot\smart-divination
```

**Error: `Flutter packages get failed`**
```bash
# Neteja i torna a provar
melos clean
melos bootstrap --force
```

### ✅ Verificació
```powershell
# Tots aquests haurien de funcionar sense errors:
melos list          # Mostra packages
melos run analyze:all   # Analyze passa
```

**Temps estimat**: 15-30 minuts

---

## ✅ TASCA 2: Crear Projecte Supabase de Producció

### Prerequisits
- Compte a https://supabase.com (gratuït)
- Supabase CLI instal·lat (opcional però recomanat)

### Passes

#### 2.1 Crear Projecte

1. Anar a https://supabase.com/dashboard
2. Click **"New Project"**
3. Configuració:
   - **Organization**: Seleccionar o crear nova
   - **Name**: `smart-divination-prod`
   - **Database Password**: Generar fort i **COPIAR A LLOC SEGUR**
     ```
     Exemple: Kx9$mQ2&pL5@wR8#vN3!tB7^yH4
     ```
   - **Region**: `Europe West (eu-west-1)` Frankfurt
   - **Pricing Plan**: Free (suficient per beta)
4. Click **"Create new project"**
5. ⏳ **ESPERAR 2-3 minuts** mentre es crea

#### 2.2 Copiar Credencials

1. Dashboard → **Settings** → **API**
2. **COPIAR a fitxer de notes segur (1Password, Bitwarden, etc.)**:

```ini
# SUPABASE PRODUCTION CREDENTIALS
# Data: 2025-10-03
# IMPORTANT: NO COMPARTIR PÚBLICAMENT

Project URL: https://xxxxxxxxx.supabase.co
Project ID: xxxxxxxxx
anon key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh4eHh4eHh4eCIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNzMzMjE1NDAwLCJleHAiOjIwNDg3OTE0MDB9.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

service_role key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh4eHh4eHh4eCIsInJvbGUiOiJzZXJ2aWNlX3JvbGUiLCJpYXQiOjE3MzMyMTU0MDAsImV4cCI6MjA0ODc5MTQwMH0.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Database Password: Kx9$mQ2&pL5@wR8#vN3!tB7^yH4
```

⚠️ **MOLT IMPORTANT**:
- `anon key` → Pot anar al client (app Flutter)
- `service_role key` → NI MAI al client, només backend!

#### 2.3 Aplicar Migracions

**Opció A: Via Supabase CLI (recomanat)**
```powershell
cd C:\tarot

# Link al projecte
supabase link --project-ref <PROJECT_ID_DE_DASHBOARD>
# Exemple: supabase link --project-ref abcdef123456

# Push migracions
supabase db push

# Verificar
supabase db diff
# Esperat: "No schema differences detected"
```

**Opció B: Via SQL Editor (si CLI no funciona)**
```sql
-- 1. Dashboard → SQL Editor
-- 2. Copiar TOTS els continguts de:
--    C:\tarot\supabase\migrations\20250101000001_initial_schema.sql
-- 3. Enganxar i executar
-- 4. Repetir amb:
--    C:\tarot\supabase\migrations\20250922090000_session_history_schema.sql
```

#### 2.4 Seed Data (Opcional per testing)

```sql
-- Dashboard → SQL Editor
-- Copiar i executar:
-- C:\tarot\supabase\seeds\dev_seed.sql

-- Això crea:
-- - 1 usuari demo
-- - Algunes sessions d'exemple
```

### ✅ Verificació
```sql
-- SQL Editor → Executar:
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public';

-- Hauria de mostrar:
-- users
-- sessions
-- session_artifacts
-- session_messages
-- user_stats
-- api_usage
```

**Temps estimat**: 30-45 minuts

---

## ✅ TASCA 3: Obtenir Clau DeepSeek

### Prerequisits
- Email vàlid
- Targeta de crèdit (només per verificació, free tier disponible)

### Passes

1. Anar a https://platform.deepseek.com/
2. **Sign Up** amb Google/GitHub o email
3. Verificar email si cal
4. Dashboard → **API Keys**
5. Click **"Create API Key"**
6. Name: `Smart Divination Production`
7. **📋 COPIAR IMMEDIATAMENT** (només es mostra un cop!)
   ```
   sk-proj-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   ```
8. Guardar amb credencials Supabase

### Cost Estimat
- Model: DeepSeek Chat
- Preu: ~$0.001 per interpretació (1000 tokens)
- Beta (100 users × 5 sessions/dia): ~$5/mes

### ✅ Verificació
```bash
# Test API key
curl https://api.deepseek.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer sk-proj-xxxxx" \
  -d '{
    "model": "deepseek-chat",
    "messages": [{"role": "user", "content": "Test"}]
  }'

# Esperat: Response JSON amb completion
```

**Temps estimat**: 15 minuts

---

## ✅ TASCA 4: Actualitzar .env.production

### Passes

```powershell
# Editar fitxer
code C:\tarot\smart-divination\backend\.env.production

# O amb notepad
notepad C:\tarot\smart-divination\backend\.env.production
```

**Contingut a actualitzar**:
```bash
# Production Environment Variables
# IMPORTANT: Never commit this file to git!

# Supabase Configuration (REQUIRED)
SUPABASE_URL=https://xxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3...

# DeepSeek AI (REQUIRED for interpretations)
DEEPSEEK_API_KEY=sk-proj-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Random.org (OPTIONAL - signed randomness)
# Deixar buit per ara, usarà crypto.randomInt() per defecte
RANDOM_ORG_KEY=

# Feature Flags (REQUIRED)
ENABLE_ICHING=false
ENABLE_RUNES=false

# Metrics & Observability (Console mode)
METRICS_PROVIDER=console
METRICS_DEBUG=false

# API Configuration
NODE_ENV=production
```

### ⚠️ Checklist de seguretat
- [ ] `.env.production` està a `.gitignore`
- [ ] NO has fet commit del fitxer
- [ ] Còpia de seguretat guardada fora del repo
- [ ] Service role key NO està al codi Flutter

### ✅ Verificació Local

```powershell
cd C:\tarot\smart-divination\backend

# Copiar a .env.local per testejar
copy .env.production .env.local

# Arrancar dev server
npm run dev

# En altra terminal:
curl http://localhost:3001/api/health
# Esperat: {"status":"healthy","timestamp":"..."}

curl http://localhost:3001/api/metrics
# Esperat: JSON amb stats

# Testejar draw (hauria de requerir auth)
curl -X POST http://localhost:3001/api/draw/cards
# Esperat: 401 Unauthorized o error de validació (correcte!)
```

**Si hi ha errors**:
- Verificar que no hi ha espais extra a les URLs
- Verificar que les claus són completes (molt llargues)
- Revisar logs del servidor per detalls

**Temps estimat**: 10-15 minuts

---

## ✅ TASCA 5: Desplegar Backend a Vercel

### Prerequisits
- Compte Vercel (gratuït)
- Vercel CLI instal·lat
- Backend funcionant localment (Tasca 4 OK)

### Passes

#### 5.1 Login i Link Project

```powershell
cd C:\tarot\smart-divination\backend

# Login (obre navegador)
vercel login

# Link project
vercel link

# Respondre:
# ? Set up and deploy? Y
# ? Which scope? <el teu username/org>
# ? Link to existing project? N
# ? What's your project's name? smart-divination-backend
# ? In which directory is your code located? ./

# Això crea: .vercel/project.json
```

#### 5.2 Configurar Environment Variables

**Opció A: Via CLI (més ràpid)**
```powershell
# Copiar cada variable a Vercel
vercel env add SUPABASE_URL production
# Pegar valor i Enter

vercel env add SUPABASE_ANON_KEY production
# Pegar valor i Enter

vercel env add SUPABASE_SERVICE_ROLE_KEY production
# Pegar valor i Enter

vercel env add DEEPSEEK_API_KEY production
# Pegar valor i Enter

vercel env add ENABLE_ICHING production
# Escriure: false

vercel env add ENABLE_RUNES production
# Escriure: false

vercel env add METRICS_PROVIDER production
# Escriure: console

vercel env add NODE_ENV production
# Escriure: production
```

**Opció B: Via Dashboard (més visual)**
1. https://vercel.com/dashboard
2. Seleccionar projecte `smart-divination-backend`
3. Settings → Environment Variables
4. Afegir les 8 variables anteriors
5. Assegurar "Production" està marcat

#### 5.3 Deploy

```powershell
# Deploy a producció
vercel --prod

# Output:
# 🔍  Inspect: https://vercel.com/...
# ✅  Production: https://smart-divination-backend-xxxxx.vercel.app

# ANOTAR AQUESTA URL!
```

### ✅ Verificació

```powershell
# Substituir amb la teva URL
$URL = "https://smart-divination-backend-xxxxx.vercel.app"

# Test 1: Health
curl "$URL/api/health"
# Esperat: {"status":"healthy"}

# Test 2: Metrics
curl "$URL/api/metrics"
# Esperat: JSON amb mètriques

# Test 3: Draw (sense auth)
curl -X POST "$URL/api/draw/cards"
# Esperat: 401 o error validació

# Test 4: Script verificació
cd C:\tarot\scripts
.\verify-deployment.ps1 $URL
```

### Troubleshooting

**Error: Build failed**
- Revisar logs a Vercel Dashboard → Deployments
- Verificar `npm run build` funciona localment
- Verificar `package.json` té `"build": "next build"`

**Error: 500 en production**
- Revisar Function Logs a Vercel Dashboard
- Verificar environment variables configurades
- Verificar Supabase URL és correcte

**Temps estimat**: 45-60 minuts

---

## ✅ TASCA 6: Build APK Android

### Prerequisits
- Flutter 3.24+
- Android SDK instal·lat
- Keystore generat (ja existeix: `apps/tarot/android/app/upload-keystore.jks`)
- Backend desplegat (Tasca 5 OK)

### Passes

```powershell
cd C:\tarot\smart-divination\apps\tarot

# Definir variables
$API_URL = "https://smart-divination-backend-xxxxx.vercel.app"
$SUPABASE_URL = "https://xxxxxxxxx.supabase.co"
$SUPABASE_ANON = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

# Build APK release
flutter build apk --release `
  --dart-define=API_BASE_URL=$API_URL `
  --dart-define=SUPABASE_URL=$SUPABASE_URL `
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON

# Output:
# ✓ Built build\app\outputs\apk\release\app-release.apk (XX.X MB)
```

### Verificar APK

```powershell
# Localització
dir build\app\outputs\apk\release\app-release.apk

# Mida esperada: 45-50 MB

# Verificar signatura
jarsigner -verify -verbose -certs build\app\outputs\apk\release\app-release.apk
# Esperat: "jar verified"
```

### Instal·lar en Dispositiu

**Opció A: Android físic via USB**
```powershell
# Habilitar USB Debugging al mòbil
# Settings → Developer Options → USB Debugging

# Connectar USB i verificar
adb devices
# Esperat: List of devices attached

# Instal·lar
adb install -r build\app\outputs\apk\release\app-release.apk
# Esperat: Success
```

**Opció B: Emulador**
```powershell
# Arrencar emulador des d'Android Studio
# O via CLI:
emulator -list-avds
emulator -avd <AVD_NAME>

# Instal·lar
adb install -r build\app\outputs\apk\release\app-release.apk
```

**Opció C: Compartir APK**
- Pujar `app-release.apk` a Google Drive
- Compartir link amb testers
- Descarregar i instal·lar (cal habilitar "Unknown Sources")

### ✅ Smoke Tests (15 tests crítics)

```markdown
[ ] 1. App obre sense crash
[ ] 2. Splash screen es mostra
[ ] 3. Sign in screen apareix
[ ] 4. Crear nou compte
    Email: test.prod@example.com
    Password: Test1234!
[ ] 5. Rebre confirmació signup
[ ] 6. Sign in amb compte creat
[ ] 7. Dashboard es carrega
[ ] 8. Eligibility card es mostra
[ ] 9. Draw form és visible
[ ] 10. Fer draw de tarot (sense question)
[ ] 11. Resultat es mostra (cartes)
[ ] 12. Demanar interpretació
[ ] 13. Loading indicator apareix
[ ] 14. Interpretació AI es mostra
[ ] 15. Historial conté el draw
```

**Si algun falla**: Documentar error, captura de pantalla, logs

### Troubleshooting

**Error: Keystore not found**
```powershell
# Verificar existeix
ls android\app\upload-keystore.jks
ls android\key.properties

# Si no existeix, seguir docs/IOS_SIGNING_GUIDE.md (Android section)
```

**Error: Build fails**
```powershell
# Neteja i torna a provar
flutter clean
flutter pub get
flutter build apk --release ...
```

**Temps estimat**: 30-45 minuts (build + test)

---

## ✅ TASCA 7: Publicar a Google Play Internal Testing

### Prerequisits
- Compte Google Play Developer ($25, one-time)
- AAB compilat
- Materials mínims (screenshots, icon, descripcions)

### 7.1 Crear Compte Developer

1. https://play.google.com/console/signup
2. Sign in amb Google
3. Pagar $25 USD
4. Completar perfil developer
5. ⏳ Esperar aprovació (normalment instant, pot trigar 48h)

### 7.2 Preparar Materials Mínims

#### Screenshots (mínim 2)
```powershell
# Capturar des de l'app:
# 1. Sign in screen
# 2. Dashboard amb draw result
# 3. Interpretation screen

# Requisits:
# - Mida: 16:9 (ex: 1080x1920)
# - Format: PNG o JPG
# - Mínim: 2 screenshots
```

#### App Icon (512x512)
```powershell
# Localització actual:
C:\tarot\smart-divination\apps\tarot\android\app\src\main\res\mipmap-xxxhdpi\ic_launcher.png

# Cal redimensionar a 512x512 si cal
# Eines: GIMP, Photoshop, online tools
```

#### Descripcions

**Curta** (màx 80 chars):
```
Tarot readings with AI-powered interpretations
```

**Llarga**:
```markdown
Smart Tarot: Your Digital Spiritual Guide

Discover the power of tarot with personalized AI interpretations.

FEATURES:
✨ Traditional tarot spreads
🤖 AI-generated interpretations
📚 Session history
🔒 Secure authentication
🌍 Multilingual (English, Spanish, Catalan)

PRIVACY:
Your data is encrypted and private. Only you can access your readings.

NOTE: This app is in beta. Contact us at support@smartdivination.app
```

#### Privacy Policy (URL obligatori)
```markdown
# Crear fitxer simple:
# C:\tarot\docs\privacy_policy.html

# Contingut mínim:
- Dades recollides: email, session history
- Com s'usen: account, history
- Amb qui es comparteixen: Supabase, DeepSeek
- Drets: accedir, eliminar dades
- Contacte: privacy@smartdivination.app

# Pujar a: GitHub Pages / Vercel
# URL: https://<tu-domini>/privacy
```

### 7.3 Build AAB

```powershell
cd C:\tarot\smart-divination\apps\tarot

# Build Android App Bundle
flutter build appbundle --release `
  --dart-define=API_BASE_URL=https://smart-divination-backend-xxxxx.vercel.app `
  --dart-define=SUPABASE_URL=https://xxxxxxxxx.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Output:
# build\app\outputs\bundle\release\app-release.aab
```

### 7.4 Crear App a Play Console

1. Play Console → **Create app**
   - Name: `Smart Tarot`
   - Default language: English
   - Type: App
   - Free/Paid: Free

2. **Store Listing**
   - App name: Smart Tarot
   - Short description: (de dalt)
   - Full description: (de dalt)
   - App icon: Upload 512x512
   - Screenshots: Upload 2+
   - Category: Lifestyle
   - Email: support@smartdivination.app
   - Privacy policy: https://...

3. **Content Rating**
   - Qüestionari: No violence, no sexual, etc.
   - Result: PEGI 3 / Everyone

4. **Target Audience**
   - Age: 18+

5. **Data Safety**
   - Collected: Email, session history
   - Shared: Service providers
   - Encrypted: Yes

### 7.5 Create Internal Testing Release

1. Dashboard → **Testing** → **Internal testing**
2. **Create new release**
3. Upload `app-release.aab`
4. Release name: `Beta 1.0.0 (1)`
5. Release notes:
   ```
   First beta release:
   - Tarot card draws
   - AI interpretations
   - Session history
   ```
6. **Save** → **Review** → **Start rollout**
7. ⏳ Esperar 1-2h (revisió automàtica)

### 7.6 Afegir Testers

1. **Internal testing** → **Testers**
2. Create email list
3. Add emails (màx 100):
   ```
   tu@example.com
   tester1@example.com
   tester2@example.com
   ```
4. Copy testing link
5. Enviar als testers via email

### ✅ Verificació Final

```markdown
[ ] App apareix a Play Console
[ ] Status: Internal testing
[ ] Testers rebut link
[ ] Al menys 1 tester ha instal·lat
[ ] No crashes reportats
```

**Temps estimat**: 2-3 hores

---

## 📊 RESUM FASE 1

### Temps Total
- Tasca 1: 15-30 min (Melos)
- Tasca 2: 30-45 min (Supabase)
- Tasca 3: 15 min (DeepSeek)
- Tasca 4: 10-15 min (.env)
- Tasca 5: 45-60 min (Vercel)
- Tasca 6: 30-45 min (APK + tests)
- Tasca 7: 2-3h (Play Store)

**TOTAL: 8-11 hores** (2-3 dies a temps parcial)

### Deliverables
- ✅ Workspace Melos funcional
- ✅ Backend en producció (Vercel)
- ✅ Base de dades operacional (Supabase)
- ✅ APK Android signat i testat
- ✅ App a Google Play Internal Testing
- ✅ 10+ testers invitats

### Properes Passes (FASE 2)
- iOS signing i TestFlight
- GitHub Actions secrets
- QA manual complet (45+ tests)
- Auditoria seguretat
- Closed beta amb feedback

---

## 🆘 Suport

Si trobes problemes:
1. Revisar logs (Vercel, Supabase Dashboard)
2. Verificar credencials sense typos
3. Consultar documentació oficial
4. Contactar equip de desenvolupament

**Data document**: 2025-10-03
**Versió**: 1.0 (FASE 1)
