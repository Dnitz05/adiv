# PrÃ²xims passos - Smart Tarot Android Launch

Guia pas a pas per completar el llanÃ§ament a Google Play Internal Testing.

**Data:** 2025-10-13
**Estat backend:** âœ… Healthy (Supabase respondent en 1.4s)
**Secrets:** âœ… Rotats i segurs (2025-10-06)
**Assets:** âš ï¸ Icon completat, screenshots i feature graphic pendents

---

## ðŸš€ Fase 1: Assets visuals (1-2 dies)

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

2. **Executar app amb backend de producciÃ³**
   ```bash
   cd C:/tarot/smart-divination/apps/tarot

   # Obtenir SUPABASE_ANON_KEY des de GitHub Secrets o Vercel dashboard
   flutter run \
     --dart-define=API_BASE_URL=https://backend-gv4a2ueuy-dnitzs-projects.vercel.app \
     --dart-define=SUPABASE_URL=https://vanrixxzaawybszeuivb.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=<YOUR_ANON_KEY>
   ```

3. **Capturar screenshots** (mÃ­nim 2, recomanat 4-8)
   - Screenshot 1: AutenticaciÃ³/onboarding
   - Screenshot 2: Three-card spread amb cartes
   - Screenshot 3: InterpretaciÃ³ IA
   - Screenshot 4: Historial de sessions

   MÃ¨tode ADB (recomanat):
   ```bash
   adb shell screencap -p /sdcard/screenshot.png
   adb pull /sdcard/screenshot.png C:/tarot/docs/store-assets/screenshots/android/01_authentication.png
   adb shell rm /sdcard/screenshot.png
   ```

   ðŸ“– Veure guia completa: `docs/SCREENSHOTS_GUIDE.md`

4. **Verificar screenshots**
   ```bash
   ls -lh C:/tarot/docs/store-assets/screenshots/android/
   ```
   - ResoluciÃ³ mÃ­nima: 1080x1920
   - Format: PNG o JPEG
   - Pes mÃ xim: 8MB per imatge

### Prioritat Alta - Feature Graphic

**Temps estimat:** 2-4 hores

1. **Crear banner 1024x500**
   - Eines recomanades:
     - Canva (plantilles per app banners)
     - Figma (disseny professional)
     - GIMP/Photoshop (avanÃ§at)

2. **Contingut del banner**
   - Logo/icona de l'app
   - TÃ­tol: "Smart Tarot"
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

## ðŸ“ Fase 2: Metadata i documents legals (1 dia)

### Prioritat Alta - Finalitzar Play Store Copy

**Temps estimat:** 1-2 hores

1. **Revisar i expandir descripcions**
   ```bash
   # Editar:
   C:/tarot/docs/store-metadata/play_store_copy.md
   ```

2. **Completar per cada idioma (EN/ES/CA)**
   - TÃ­tol definitiu (mÃ x 30 carÃ cters)
   - DescripciÃ³ curta (mÃ x 80 carÃ cters)
   - DescripciÃ³ llarga (mÃ x 4000 carÃ cters)
     * QuÃ¨ fa l'app
     * Funcionalitats clau
     * Beneficis per l'usuari
     * Call to action

3. **RevisiÃ³ legal/mÃ rqueting** (opcional perÃ² recomanat)

### Prioritat Mitjana - Hostejar documents legals

**Temps estimat:** 1 hora

**OpciÃ³ A: GitHub Pages (recomanat, gratuÃ¯t)**
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

**OpciÃ³ B: Vercel (alternatiu)**
```bash
cd C:/tarot/docs/legal
vercel deploy --prod
```

**OpciÃ³ C: Web corporativa** (si existeix)

**Important:**
1. Completar plantilles amb dades reals (contacte, empresa, etc.)
2. RevisiÃ³ legal GDPR (si possible)
3. Afegir URLs al Play Console i a l'app

---

## ðŸ—ï¸ Fase 3: Build i preparaciÃ³ final (2-4 hores)

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

   # Per Internal Testing (APK Ã©s mÃ©s rÃ pid)
   flutter build apk --release \
     --dart-define=API_BASE_URL=https://backend-gv4a2ueuy-dnitzs-projects.vercel.app

   # Per Production (AAB requerit)
   flutter build appbundle --release \
     --dart-define=API_BASE_URL=https://backend-gv4a2ueuy-dnitzs-projects.vercel.app
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

InstalÂ·lar APK release en dispositiu fÃ­sic i verificar:

1. **Funcionalitat bÃ sica**
   - âœ… Signup/Login amb Supabase
   - âœ… Draw de tarot (single card, 3-card, Celtic Cross)
   - âœ… InterpretaciÃ³ IA (DeepSeek)
   - âœ… Historial de sessions
   - âœ… Logout

2. **IntegraciÃ³ backend**
   - âœ… API calls responen correctament
   - âœ… Sessions es guarden a Supabase
   - âœ… No hi ha errors 401/403/500

3. **UX i visual**
   - âœ… Icona es mostra correctament
   - âœ… App label: "Smart Tarot"
   - âœ… No crashes en fluxos principals
   - âœ… LocalitzaciÃ³ EN/ES/CA funciona

4. **Performance**
   - âœ… Temps de cÃ rrega acceptable (<3s)
   - âœ… No lag en scrolls/animacions
   - âœ… MemÃ²ria dins de lÃ­mits

**Checklist complet:** `docs/STATUS.md` > Manual QA Checklist

---

## ðŸŽ® Fase 4: Google Play Console (1 dia)

### Prioritat Alta - Configurar compte i app

**Temps estimat:** 2-3 hores (inclou espera de verificaciÃ³)

1. **Crear Google Play Developer account**
   - URL: https://play.google.com/console/signup
   - Cost: $25 USD (pagament Ãºnic)
   - Temps verificaciÃ³: 24-48 hores

2. **Crear nova app**
   - Nom: Smart Tarot
   - Idioma per defecte: English (UK) o CatalÃ 
   - App o joc: App
   - GratuÃ¯ta o de pagament: GratuÃ¯ta

3. **Completar informaciÃ³ bÃ sica**
   - Categoria: Lifestyle o Entertainment
   - Email de contacte: support@smartdivination.com
   - Privacitat: enllaÃ§ a privacy policy hostatjada
   - ClassificaciÃ³ de contingut: completar qÃ¼estionari

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
   - Afegir email list (mÃ x 100 per Internal Testing)
   - O crear Google Group
   - Enviar link de testing als testers

4. **Publish release**
   - Revisar pre-launch report (pot trigar 1-2 hores)
   - Corregir issues crÃ­tics si n'hi ha
   - Confirmar publicaciÃ³

### Prioritat Mitjana - Completar Store Listing

**Temps estimat:** 1 hora

1. **Pujar assets**
   - Icona: 512x512 (des de docs/store-assets/icon.png, resize si cal)
   - Feature graphic: 1024x500
   - Screenshots: mÃ­nim 2, mÃ xim 8 (1080x1920+)

2. **Afegir descripcions**
   - TÃ­tol, descripciÃ³ curta, descripciÃ³ llarga
   - Localitzar per EN/ES/CA

3. **Configurar preferÃ¨ncies**
   - Privacy policy URL
   - Categoria i tags
   - ClassificaciÃ³ de contingut

---

## ðŸ“Š Fase 5: Post-llanÃ§ament (ongoing)

### Prioritat Baixa - Monitoring i feedback

**Temps estimat:** 1 hora/setmana

1. **Configurar observabilitat**
   - Connectar Datadog o Grafana
   - Configurar alerts per errors 5xx
   - Dashboard de mÃ¨triques en temps real

2. **Revisar feedback de testers**
   - Play Console > Ratings and reviews
   - Crear issues a GitHub per bugs reportats
   - Prioritzar fixes segons impacte

3. **Iterar i millorar**
   - Planificar sprints de millora
   - Preparar feature flags per I Ching/Runes
   - Expandir content packs

---

## âœ… Checklist de pre-llanÃ§ament

Abans de publicar a Internal Testing, verifica:

### Assets
- [x] Icona 1024x1024 creada i mipmaps generats
- [ ] Screenshots capturats (mÃ­nim 2)
- [ ] Feature graphic 1024x500 creat
- [x] App label "Smart Tarot" configurat

### Metadata
- [x] Play Store copy drafted (EN/ES/CA)
- [x] Privacy policy template ready
- [x] Terms of service template ready
- [ ] Documents legals hostatjats pÃºblicament

### Build
- [ ] Release APK/AAB generat i signat
- [ ] Checksum guardat
- [ ] QA manual completat sense blockers

### Backend
- [x] Backend de producciÃ³ healthy
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

## ðŸ†˜ Ajuda i recursos

### DocumentaciÃ³ del projecte
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
- Backend health: `curl https://backend-gv4a2ueuy-dnitzs-projects.vercel.app/api/health`
- Supabase dashboard: https://supabase.com/dashboard/project/vanrixxzaawybszeuivb
- Vercel dashboard: https://vercel.com/dnitzs-projects/backend

---

## ðŸ“… Timeline estimat

| Fase | Temps estimat | Prioritat |
|------|---------------|-----------|
| Assets visuals (screenshots + feature graphic) | 3-6 hores | Alta |
| Metadata i documents legals | 2-3 hores | Alta |
| Build i QA | 2-4 hores | Alta |
| Google Play Console setup | 3-4 hores | Alta |
| **TOTAL** | **10-17 hores** | - |

**ETA per Internal Testing:** 2-4 dies laborables

---

**Ãšltima actualitzaciÃ³:** 2025-10-13
**PrÃ²xima revisiÃ³:** DesprÃ©s de capturar screenshots
