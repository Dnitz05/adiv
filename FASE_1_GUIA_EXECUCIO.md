# ðŸš€ FASE 1: MVP BETA ANDROID - GUIA D'EXECUCIÃ“

**Objectiu**: App Android funcional amb backend en producciÃ³ en **1 setmana**
**Output**: Beta publicada a Google Play Internal Testing amb 10+ testers

---

## âœ… TASCA 1: Restablir Workspace Melos

### Prerequisits
- Dart SDK instalÂ·lat
- Flutter 3.24+ instalÂ·lat
- Git configurat

### Passes

```powershell
# 1. Activar Melos globalment
dart pub global activate melos

# 2. Afegir Dart al PATH (si no estÃ )
# Windows: Afegir al PATH del sistema:
# C:\Users\<USERNAME>\AppData\Local\Pub\Cache\bin

# 3. Verificar instalÂ·laciÃ³
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

# 6. Executar anÃ¡lisis
melos run analyze:all
# Esperat: No errors crÃ­tics

# 7. Executar tests
melos run test:all
# Esperat: Tests passing (o skip si no hi ha tests)
```

### ResoluciÃ³ de problemes comuns

**Error: `melos: command not found`**
```powershell
# Windows
$env:Path += ";$env:LOCALAPPDATA\Pub\Cache\bin"
# O afegir permanent via System Properties â†’ Environment Variables
```

**Error: `pubspec.yaml not found`**
```powershell
# Verificar que estÃ s a smart-divination/
cd C:\tarot\smart-divination
pwd  # Hauria de mostrar: C:\tarot\smart-divination
```

**Error: `Flutter packages get failed`**
```bash
# Neteja i torna a provar
melos clean
melos bootstrap --force
```

### âœ… VerificaciÃ³
```powershell
# Tots aquests haurien de funcionar sense errors:
melos list          # Mostra packages
melos run analyze:all   # Analyze passa
```

**Temps estimat**: 15-30 minuts

---

## âœ… TASCA 2: Crear Projecte Supabase de ProducciÃ³

### Prerequisits
- Compte a https://supabase.com (gratuÃ¯t)
- Supabase CLI instalÂ·lat (opcional perÃ² recomanat)

### Passes

#### 2.1 Crear Projecte

1. Anar a https://supabase.com/dashboard
2. Click **"New Project"**
3. ConfiguraciÃ³:
   - **Organization**: Seleccionar o crear nova
   - **Name**: `smart-divination-prod`
   - **Database Password**: Generar fort i **COPIAR A LLOC SEGUR**
     ```
     Exemple: Kx9$mQ2&pL5@wR8#vN3!tB7^yH4
     ```
   - **Region**: `Europe West (eu-west-1)` Frankfurt
   - **Pricing Plan**: Free (suficient per beta)
4. Click **"Create new project"**
5. â³ **ESPERAR 2-3 minuts** mentre es crea

#### 2.2 Copiar Credencials

1. Dashboard â†’ **Settings** â†’ **API**
2. **COPIAR a fitxer de notes segur (1Password, Bitwarden, etc.)**:

```ini
# SUPABASE PRODUCTION CREDENTIALS
# Data: 2025-10-03
# IMPORTANT: NO COMPARTIR PÃšBLICAMENT

Project URL: https://xxxxxxxxx.supabase.co
Project ID: xxxxxxxxx
anon key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh4eHh4eHh4eCIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNzMzMjE1NDAwLCJleHAiOjIwNDg3OTE0MDB9.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

service_role key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh4eHh4eHh4eCIsInJvbGUiOiJzZXJ2aWNlX3JvbGUiLCJpYXQiOjE3MzMyMTU0MDAsImV4cCI6MjA0ODc5MTQwMH0.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Database Password: Kx9$mQ2&pL5@wR8#vN3!tB7^yH4
```

âš ï¸ **MOLT IMPORTANT**:
- `anon key` â†’ Pot anar al client (app Flutter)
- `service_role key` â†’ NI MAI al client, nomÃ©s backend!

#### 2.3 Aplicar Migracions

**OpciÃ³ A: Via Supabase CLI (recomanat)**
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

**OpciÃ³ B: Via SQL Editor (si CLI no funciona)**
```sql
-- 1. Dashboard â†’ SQL Editor
-- 2. Copiar TOTS els continguts de:
--    C:\tarot\supabase\migrations\20250101000001_initial_schema.sql
-- 3. Enganxar i executar
-- 4. Repetir amb:
--    C:\tarot\supabase\migrations\20250922090000_session_history_schema.sql
```

#### 2.4 Seed Data (Opcional per testing)

```sql
-- Dashboard â†’ SQL Editor
-- Copiar i executar:
-- C:\tarot\supabase\seeds\dev_seed.sql

-- AixÃ² crea:
-- - 1 usuari demo
-- - Algunes sessions d'exemple
```

### âœ… VerificaciÃ³
```sql
-- SQL Editor â†’ Executar:
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

## âœ… TASCA 3: Obtenir Clau DeepSeek

### Prerequisits
- Email vÃ lid
- Targeta de crÃ¨dit (nomÃ©s per verificaciÃ³, free tier disponible)

### Passes

1. Anar a https://platform.deepseek.com/
2. **Sign Up** amb Google/GitHub o email
3. Verificar email si cal
4. Dashboard â†’ **API Keys**
5. Click **"Create API Key"**
6. Name: `Smart Divination Production`
7. **ðŸ“‹ COPIAR IMMEDIATAMENT** (nomÃ©s es mostra un cop!)
   ```
   sk-proj-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   ```
8. Guardar amb credencials Supabase

### Cost Estimat
- Model: DeepSeek Chat
- Preu: ~$0.001 per interpretaciÃ³ (1000 tokens)
- Beta (100 users Ã— 5 sessions/dia): ~$5/mes

### âœ… VerificaciÃ³
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

## âœ… TASCA 4: Actualitzar .env.production

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
# Deixar buit per ara, usarÃ  crypto.randomInt() per defecte
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

### âš ï¸ Checklist de seguretat
- [ ] `.env.production` estÃ  a `.gitignore`
- [ ] NO has fet commit del fitxer
- [ ] CÃ²pia de seguretat guardada fora del repo
- [ ] Service role key NO estÃ  al codi Flutter

### âœ… VerificaciÃ³ Local

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
# Esperat: 401 Unauthorized o error de validaciÃ³ (correcte!)
```

**Si hi ha errors**:
- Verificar que no hi ha espais extra a les URLs
- Verificar que les claus sÃ³n completes (molt llargues)
- Revisar logs del servidor per detalls

**Temps estimat**: 10-15 minuts

---

## âœ… TASCA 5: Desplegar Backend a Vercel

### Prerequisits
- Compte Vercel (gratuÃ¯t)
- Vercel CLI instalÂ·lat
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

# AixÃ² crea: .vercel/project.json
```

#### 5.2 Configurar Environment Variables

**OpciÃ³ A: Via CLI (mÃ©s rÃ pid)**
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

**OpciÃ³ B: Via Dashboard (mÃ©s visual)**
1. https://vercel.com/dashboard
2. Seleccionar projecte `smart-divination-backend`
3. Settings â†’ Environment Variables
4. Afegir les 8 variables anteriors
5. Assegurar "Production" estÃ  marcat

#### 5.3 Deploy

```powershell
# Deploy a producciÃ³
vercel --prod

# Output:
# ðŸ”  Inspect: https://vercel.com/...
# âœ…  Production: https://backend-gv4a2ueuy-dnitzs-projects.vercel.app

# ANOTAR AQUESTA URL!
```

### âœ… VerificaciÃ³

```powershell
# Substituir amb la teva URL
$URL = "https://backend-gv4a2ueuy-dnitzs-projects.vercel.app"

# Test 1: Health
curl "$URL/api/health"
# Esperat: {"status":"healthy"}

# Test 2: Metrics
curl "$URL/api/metrics"
# Esperat: JSON amb mÃ¨triques

# Test 3: Draw (sense auth)
curl -X POST "$URL/api/draw/cards"
# Esperat: 401 o error validaciÃ³

# Test 4: Script verificaciÃ³
cd C:\tarot\scripts
.\verify-deployment.ps1 $URL
```

### Troubleshooting

**Error: Build failed**
- Revisar logs a Vercel Dashboard â†’ Deployments
- Verificar `npm run build` funciona localment
- Verificar `package.json` tÃ© `"build": "next build"`

**Error: 500 en production**
- Revisar Function Logs a Vercel Dashboard
- Verificar environment variables configurades
- Verificar Supabase URL Ã©s correcte

**Temps estimat**: 45-60 minuts

---

## âœ… TASCA 6: Build APK Android

### Prerequisits
- Flutter 3.24+
- Android SDK instalÂ·lat
- Keystore generat (ja existeix: `apps/tarot/android/app/upload-keystore.jks`)
- Backend desplegat (Tasca 5 OK)

### Passes

```powershell
cd C:\tarot\smart-divination\apps\tarot

# Definir variables
$API_URL = "https://backend-gv4a2ueuy-dnitzs-projects.vercel.app"
$SUPABASE_URL = "https://xxxxxxxxx.supabase.co"
$SUPABASE_ANON = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

# Build APK release
flutter build apk --release `
  --dart-define=API_BASE_URL=$API_URL `
  --dart-define=SUPABASE_URL=$SUPABASE_URL `
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON

# Output:
# âœ“ Built build\app\outputs\apk\release\app-release.apk (XX.X MB)
```

### Verificar APK

```powershell
# LocalitzaciÃ³
dir build\app\outputs\apk\release\app-release.apk

# Mida esperada: 45-50 MB

# Verificar signatura
jarsigner -verify -verbose -certs build\app\outputs\apk\release\app-release.apk
# Esperat: "jar verified"
```

### InstalÂ·lar en Dispositiu

**OpciÃ³ A: Android fÃ­sic via USB**
```powershell
# Habilitar USB Debugging al mÃ²bil
# Settings â†’ Developer Options â†’ USB Debugging

# Connectar USB i verificar
adb devices
# Esperat: List of devices attached

# InstalÂ·lar
adb install -r build\app\outputs\apk\release\app-release.apk
# Esperat: Success
```

**OpciÃ³ B: Emulador**
```powershell
# Arrencar emulador des d'Android Studio
# O via CLI:
emulator -list-avds
emulator -avd <AVD_NAME>

# InstalÂ·lar
adb install -r build\app\outputs\apk\release\app-release.apk
```

**OpciÃ³ C: Compartir APK**
- Pujar `app-release.apk` a Google Drive
- Compartir link amb testers
- Descarregar i instalÂ·lar (cal habilitar "Unknown Sources")

### âœ… Smoke Tests (15 tests crÃ­tics)

```markdown
[ ] 1. App obre sense crash
[ ] 2. Splash screen es mostra
[ ] 3. Sign in screen apareix
[ ] 4. Crear nou compte
    Email: test.prod@example.com
    Password: Test1234!
[ ] 5. Rebre confirmaciÃ³ signup
[ ] 6. Sign in amb compte creat
[ ] 7. Dashboard es carrega
[ ] 8. Eligibility card es mostra
[ ] 9. Draw form Ã©s visible
[ ] 10. Fer draw de tarot (sense question)
[ ] 11. Resultat es mostra (cartes)
[ ] 12. Demanar interpretaciÃ³
[ ] 13. Loading indicator apareix
[ ] 14. InterpretaciÃ³ AI es mostra
[ ] 15. Historial contÃ© el draw
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

## âœ… TASCA 7: Publicar a Google Play Internal Testing

### Prerequisits
- Compte Google Play Developer ($25, one-time)
- AAB compilat
- Materials mÃ­nims (screenshots, icon, descripcions)

### 7.1 Crear Compte Developer

1. https://play.google.com/console/signup
2. Sign in amb Google
3. Pagar $25 USD
4. Completar perfil developer
5. â³ Esperar aprovaciÃ³ (normalment instant, pot trigar 48h)

### 7.2 Preparar Materials MÃ­nims

#### Screenshots (mÃ­nim 2)
```powershell
# Capturar des de l'app:
# 1. Sign in screen
# 2. Dashboard amb draw result
# 3. Interpretation screen

# Requisits:
# - Mida: 16:9 (ex: 1080x1920)
# - Format: PNG o JPG
# - MÃ­nim: 2 screenshots
```

#### App Icon (512x512)
```powershell
# LocalitzaciÃ³ actual:
C:\tarot\smart-divination\apps\tarot\android\app\src\main\res\mipmap-xxxhdpi\ic_launcher.png

# Cal redimensionar a 512x512 si cal
# Eines: GIMP, Photoshop, online tools
```

#### Descripcions

**Curta** (mÃ x 80 chars):
```
Tarot readings with AI-powered interpretations
```

**Llarga**:
```markdown
Smart Tarot: Your Digital Spiritual Guide

Discover the power of tarot with personalized AI interpretations.

FEATURES:
âœ¨ Traditional tarot spreads
ðŸ¤– AI-generated interpretations
ðŸ“š Session history
ðŸ”’ Secure authentication
ðŸŒ Multilingual (English, Spanish, Catalan)

PRIVACY:
Your data is encrypted and private. Only you can access your readings.

NOTE: This app is in beta. Contact us at support@smartdivination.app
```

#### Privacy Policy (URL obligatori)
```markdown
# Crear fitxer simple:
# C:\tarot\docs\privacy_policy.html

# Contingut mÃ­nim:
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
  --dart-define=API_BASE_URL=https://backend-gv4a2ueuy-dnitzs-projects.vercel.app `
  --dart-define=SUPABASE_URL=https://xxxxxxxxx.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Output:
# build\app\outputs\bundle\release\app-release.aab
```

### 7.4 Crear App a Play Console

1. Play Console â†’ **Create app**
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
   - QÃ¼estionari: No violence, no sexual, etc.
   - Result: PEGI 3 / Everyone

4. **Target Audience**
   - Age: 18+

5. **Data Safety**
   - Collected: Email, session history
   - Shared: Service providers
   - Encrypted: Yes

### 7.5 Create Internal Testing Release

1. Dashboard â†’ **Testing** â†’ **Internal testing**
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
6. **Save** â†’ **Review** â†’ **Start rollout**
7. â³ Esperar 1-2h (revisiÃ³ automÃ tica)

### 7.6 Afegir Testers

1. **Internal testing** â†’ **Testers**
2. Create email list
3. Add emails (mÃ x 100):
   ```
   tu@example.com
   tester1@example.com
   tester2@example.com
   ```
4. Copy testing link
5. Enviar als testers via email

### âœ… VerificaciÃ³ Final

```markdown
[ ] App apareix a Play Console
[ ] Status: Internal testing
[ ] Testers rebut link
[ ] Al menys 1 tester ha instalÂ·lat
[ ] No crashes reportats
```

**Temps estimat**: 2-3 hores

---

## ðŸ“Š RESUM FASE 1

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
- âœ… Workspace Melos funcional
- âœ… Backend en producciÃ³ (Vercel)
- âœ… Base de dades operacional (Supabase)
- âœ… APK Android signat i testat
- âœ… App a Google Play Internal Testing
- âœ… 10+ testers invitats

### Properes Passes (FASE 2)
- iOS signing i TestFlight
- GitHub Actions secrets
- QA manual complet (45+ tests)
- Auditoria seguretat
- Closed beta amb feedback

---

## ðŸ†˜ Suport

Si trobes problemes:
1. Revisar logs (Vercel, Supabase Dashboard)
2. Verificar credencials sense typos
3. Consultar documentaciÃ³ oficial
4. Contactar equip de desenvolupament

**Data document**: 2025-10-03
**VersiÃ³**: 1.0 (FASE 1)
