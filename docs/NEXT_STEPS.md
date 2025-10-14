# Pròxims passos - Smart Tarot Android Launch

Guia pas a pas per completar el llançament a Google Play Internal Testing.

**Data:** 2025-10-13
**Estat backend:** ✅ Healthy (Supabase respondent en 1.4s)
**Secrets:** ✅ Rotats i segurs (2025-10-06)
**Assets:** ⚠️ Icon completat, screenshots i feature graphic pendents

---

## 🚀 Fase 1: Assets visuals (1-2 dies)

### Prioritat Alta - Screenshots

**Temps estimat:** 1-2 hores

1. **Configurar emulador o dispositiu**
   ```bash
   # Verifica dispositius disponibles
   flutter devices

   # O inicia emulador Android
   emulator -list-avds
   emulator -avd Pixel_6_API_34 &
   ```

2. **Executar app amb backend de producció**
   ```bash
   cd C:/tarot/smart-divination/apps/tarot

   # Obtenir SUPABASE_ANON_KEY des de GitHub Secrets o Vercel dashboard
   flutter run \
     --dart-define=API_BASE_URL=https://backend-4sircya71-dnitzs-projects.vercel.app \
     --dart-define=SUPABASE_URL=https://vanrixxzaawybszeuivb.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=<YOUR_ANON_KEY>
   ```

3. **Capturar screenshots** (mínim 2, recomanat 4-8)
   - Screenshot 1: Autenticació/onboarding
   - Screenshot 2: Three-card spread amb cartes
   - Screenshot 3: Interpretació IA
   - Screenshot 4: Historial de sessions

   Mètode ADB (recomanat):
   ```bash
   adb shell screencap -p /sdcard/screenshot.png
   adb pull /sdcard/screenshot.png C:/tarot/docs/store-assets/screenshots/android/01_authentication.png
   adb shell rm /sdcard/screenshot.png
   ```

   📖 Veure guia completa: `docs/SCREENSHOTS_GUIDE.md`

4. **Verificar screenshots**
   ```bash
   ls -lh C:/tarot/docs/store-assets/screenshots/android/
   ```
   - Resolució mínima: 1080x1920
   - Format: PNG o JPEG
   - Pes màxim: 8MB per imatge

### Prioritat Alta - Feature Graphic

**Temps estimat:** 2-4 hores

1. **Crear banner 1024x500**
   - Eines recomanades:
     - Canva (plantilles per app banners)
     - Figma (disseny professional)
     - GIMP/Photoshop (avançat)

2. **Contingut del banner**
   - Logo/icona de l'app
   - Títol: "Smart Tarot"
   - Tagline: "AI Tarot Readings" o similar
   - Colors de marca (#8C52FF i complements)
   - Fons atractiu (tarot cards, mystic theme)

3. **Guardar i verificar**
   ```bash
   # Guardar a:
   C:/tarot/docs/store-assets/feature_graphic.png

   # Verificar mida:
   file C:/tarot/docs/store-assets/feature_graphic.png
   # Hauria de mostrar: 1024 x 500
   ```

### Opcional - Millorar splash screen

**Temps estimat:** 30 minuts

1. Crear imatge de splash personalitzada
2. Configurar `flutter_native_splash` al pubspec.yaml
3. Regenerar assets amb `flutter pub run flutter_native_splash:create`

---

## 📝 Fase 2: Metadata i documents legals (1 dia)

### Prioritat Alta - Finalitzar Play Store Copy

**Temps estimat:** 1-2 hores

1. **Revisar i expandir descripcions**
   ```bash
   # Editar:
   C:/tarot/docs/store-metadata/play_store_copy.md
   ```

2. **Completar per cada idioma (EN/ES/CA)**
   - Títol definitiu (màx 30 caràcters)
   - Descripció curta (màx 80 caràcters)
   - Descripció llarga (màx 4000 caràcters)
     * Què fa l'app
     * Funcionalitats clau
     * Beneficis per l'usuari
     * Call to action

3. **Revisió legal/màrqueting** (opcional però recomanat)

### Prioritat Mitjana - Hostejar documents legals

**Temps estimat:** 1 hora

**Opció A: GitHub Pages (recomanat, gratuït)**
```bash
cd C:/tarot
mkdir -p docs/legal
cp docs/store-metadata/privacy_policy_template.md docs/legal/privacy-policy.md
cp docs/store-metadata/terms_template.md docs/legal/terms-of-service.md

# Configurar GitHub Pages a Settings > Pages
# Branch: master, Folder: /docs

# URLs finals:
# https://YOUR_USERNAME.github.io/REPO_NAME/legal/privacy-policy.html
# https://YOUR_USERNAME.github.io/REPO_NAME/legal/terms-of-service.html
```

**Opció B: Vercel (alternatiu)**
```bash
cd C:/tarot/docs/legal
vercel deploy --prod
```

**Opció C: Web corporativa** (si existeix)

**Important:**
1. Completar plantilles amb dades reals (contacte, empresa, etc.)
2. Revisió legal GDPR (si possible)
3. Afegir URLs al Play Console i a l'app

---

## 🏗️ Fase 3: Build i preparació final (2-4 hores)

### Prioritat Alta - Build release APK/AAB

**Temps estimat:** 1-2 hores

1. **Verificar signing configuration**
   ```bash
   # Comprovar que existeix:
   ls C:/tarot/smart-divination/apps/tarot/android/upload-keystore.jks
   ls C:/tarot/smart-divination/apps/tarot/android/key.properties
   ```

2. **Build release**
   ```bash
   cd C:/tarot/smart-divination/apps/tarot

   # Per Internal Testing (APK és més ràpid)
   flutter build apk --release \
     --dart-define=API_BASE_URL=https://backend-4sircya71-dnitzs-projects.vercel.app

   # Per Production (AAB requerit)
   flutter build appbundle --release \
     --dart-define=API_BASE_URL=https://backend-4sircya71-dnitzs-projects.vercel.app
   ```

3. **Verificar signatura**
   ```bash
   # APK:
   jarsigner -verify -verbose build/app/outputs/flutter-apk/app-release.apk

   # AAB:
   jarsigner -verify -verbose build/app/outputs/bundle/release/app-release.aab
   ```

4. **Guardar checksum**
   ```bash
   sha256sum build/app/outputs/flutter-apk/app-release.apk > app-release.apk.sha256
   ```

### Prioritat Mitjana - QA manual

**Temps estimat:** 1-2 hores

Instal·lar APK release en dispositiu físic i verificar:

1. **Funcionalitat bàsica**
   - ✅ Signup/Login amb Supabase
   - ✅ Draw de tarot (single card, 3-card, Celtic Cross)
   - ✅ Interpretació IA (DeepSeek)
   - ✅ Historial de sessions
   - ✅ Logout

2. **Integració backend**
   - ✅ API calls responen correctament
   - ✅ Sessions es guarden a Supabase
   - ✅ No hi ha errors 401/403/500

3. **UX i visual**
   - ✅ Icona es mostra correctament
   - ✅ App label: "Smart Tarot"
   - ✅ No crashes en fluxos principals
   - ✅ Localització EN/ES/CA funciona

4. **Performance**
   - ✅ Temps de càrrega acceptable (<3s)
   - ✅ No lag en scrolls/animacions
   - ✅ Memòria dins de límits

**Checklist complet:** `docs/STATUS.md` > Manual QA Checklist

---

## 🎮 Fase 4: Google Play Console (1 dia)

### Prioritat Alta - Configurar compte i app

**Temps estimat:** 2-3 hores (inclou espera de verificació)

1. **Crear Google Play Developer account**
   - URL: https://play.google.com/console/signup
   - Cost: $25 USD (pagament únic)
   - Temps verificació: 24-48 hores

2. **Crear nova app**
   - Nom: Smart Tarot
   - Idioma per defecte: English (UK) o Català
   - App o joc: App
   - Gratuïta o de pagament: Gratuïta

3. **Completar informació bàsica**
   - Categoria: Lifestyle o Entertainment
   - Email de contacte: support@smartdivination.com
   - Privacitat: enllaç a privacy policy hostatjada
   - Classificació de contingut: completar qüestionari

### Prioritat Alta - Pujar APK/AAB a Internal Testing

**Temps estimat:** 30 minuts

1. **Crear Internal Testing track**
   - Play Console > Testing > Internal testing
   - Crear nova release

2. **Pujar APK o AAB**
   - Arrossegar `app-release.aab` (preferit)
   - O `app-release.apk`
   - Afegir release notes (EN/ES/CA)

3. **Configurar testers**
   - Afegir email list (màx 100 per Internal Testing)
   - O crear Google Group
   - Enviar link de testing als testers

4. **Publish release**
   - Revisar pre-launch report (pot trigar 1-2 hores)
   - Corregir issues crítics si n'hi ha
   - Confirmar publicació

### Prioritat Mitjana - Completar Store Listing

**Temps estimat:** 1 hora

1. **Pujar assets**
   - Icona: 512x512 (des de docs/store-assets/icon.png, resize si cal)
   - Feature graphic: 1024x500
   - Screenshots: mínim 2, màxim 8 (1080x1920+)

2. **Afegir descripcions**
   - Títol, descripció curta, descripció llarga
   - Localitzar per EN/ES/CA

3. **Configurar preferències**
   - Privacy policy URL
   - Categoria i tags
   - Classificació de contingut

---

## 📊 Fase 5: Post-llançament (ongoing)

### Prioritat Baixa - Monitoring i feedback

**Temps estimat:** 1 hora/setmana

1. **Configurar observabilitat**
   - Connectar Datadog o Grafana
   - Configurar alerts per errors 5xx
   - Dashboard de mètriques en temps real

2. **Revisar feedback de testers**
   - Play Console > Ratings and reviews
   - Crear issues a GitHub per bugs reportats
   - Prioritzar fixes segons impacte

3. **Iterar i millorar**
   - Planificar sprints de millora
   - Preparar feature flags per I Ching/Runes
   - Expandir content packs

---

## ✅ Checklist de pre-llançament

Abans de publicar a Internal Testing, verifica:

### Assets
- [x] Icona 1024x1024 creada i mipmaps generats
- [ ] Screenshots capturats (mínim 2)
- [ ] Feature graphic 1024x500 creat
- [x] App label "Smart Tarot" configurat

### Metadata
- [x] Play Store copy drafted (EN/ES/CA)
- [x] Privacy policy template ready
- [x] Terms of service template ready
- [ ] Documents legals hostatjats públicament

### Build
- [ ] Release APK/AAB generat i signat
- [ ] Checksum guardat
- [ ] QA manual completat sense blockers

### Backend
- [x] Backend de producció healthy
- [x] Supabase respondent correctament
- [x] Secrets rotats i segurs
- [x] DeepSeek API funcional

### Google Play
- [ ] Developer account creat i verificat
- [ ] App creada al Play Console
- [ ] Internal Testing track configurat
- [ ] Testers afegits
- [ ] Store listing completat

---

## 🆘 Ajuda i recursos

### Documentació del projecte
- **Checklist complet:** `ANDROID_LAUNCH_CHECKLIST.md`
- **Estat actual:** `docs/STATUS.md`
- **Blockers:** `CRITICAL_BLOCKERS_PLAN.md`
- **Screenshots:** `docs/SCREENSHOTS_GUIDE.md`
- **Seguretat:** `SECURITY_INCIDENT_RESPONSE.md`

### Recursos externs
- [Google Play Console](https://play.google.com/console)
- [Flutter deployment docs](https://docs.flutter.dev/deployment/android)
- [Android app signing](https://developer.android.com/studio/publish/app-signing)
- [Play Store guidelines](https://play.google.com/console/about/guides/)

### Contacte i suport
- Backend health: `curl https://backend-4sircya71-dnitzs-projects.vercel.app/api/health`
- Supabase dashboard: https://supabase.com/dashboard/project/vanrixxzaawybszeuivb
- Vercel dashboard: https://vercel.com/dnitzs-projects/backend

---

## 📅 Timeline estimat

| Fase | Temps estimat | Prioritat |
|------|---------------|-----------|
| Assets visuals (screenshots + feature graphic) | 3-6 hores | Alta |
| Metadata i documents legals | 2-3 hores | Alta |
| Build i QA | 2-4 hores | Alta |
| Google Play Console setup | 3-4 hores | Alta |
| **TOTAL** | **10-17 hores** | - |

**ETA per Internal Testing:** 2-4 dies laborables

---

**Última actualització:** 2025-10-13
**Pròxima revisió:** Després de capturar screenshots
