# Executar Smart Tarot al telèfon - Guia ràpida

Guia per executar l'app al teu telèfon físic i testar en temps real mentre desenvolupes.

---

## 🔧 Configuració inicial (només primera vegada)

### 1. Habilitar mode desenvolupador al telèfon

**Android:**
1. Ves a **Configuració** > **Sobre el telèfon**
2. Toca 7 vegades sobre **Número de compilació**
3. Veuràs un missatge "Ara ets desenvolupador"
4. Torna a **Configuració** > **Opcions de desenvolupador**
5. Activa **Depuració USB**
6. Activa **Instal·lar aplicacions via USB** (si està disponible)

### 2. Connectar telèfon a l'ordinador

1. Connecta el telèfon amb cable USB
2. Quan aparegui el diàleg al telèfon, selecciona **Transferència d'arxius** o **MTP**
3. Accepta la sol·licitud de depuració USB (marca "Confiar sempre en aquest ordinador")

### 3. Verificar connexió

```bash
# Verifica que el telèfon es detecta
adb devices

# Hauries de veure alguna cosa com:
# List of devices attached
# ABC123XYZ    device
```

Si no funciona:
```bash
# Reinicia servidor ADB
adb kill-server
adb start-server
adb devices
```

---

## 🚀 Executar l'app (mode development)

### Opció A: Execució ràpida amb hot reload (RECOMANAT per desenvolupament)

```bash
cd C:/tarot/smart-divination/apps/tarot

# Executar amb backend de producció
flutter run \
  --dart-define=API_BASE_URL=https://backend-4sircya71-dnitzs-projects.vercel.app \
  --dart-define=SUPABASE_URL=https://vanrixxzaawybszeuivb.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhbnJpeHh6YWF3eWJzemV1aXZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc0NDMyMzIsImV4cCI6MjA0MzAxOTIzMn0.KfWe8d5ueKhAh3sZGOUjZ0kTzGq5f2LZ6oYOXPJl7o8
```

**Avantatges:**
- ✅ Hot reload: prem `r` per recarregar canvis
- ✅ Hot restart: prem `R` per reiniciar l'app
- ✅ Logs en temps real a la consola
- ✅ Debugging actiu

**Desavantatges:**
- ⚠️ Necessita mantenir la consola oberta
- ⚠️ Performance lleugerament inferior

### Opció B: Instal·lar APK debug (per testar sense cable)

```bash
cd C:/tarot/smart-divination/apps/tarot

# Build APK debug
flutter build apk --debug \
  --dart-define=API_BASE_URL=https://backend-4sircya71-dnitzs-projects.vercel.app \
  --dart-define=SUPABASE_URL=https://vanrixxzaawybszeuivb.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhbnJpeHh6YWF3eWJzemV1aXZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjYwNjM1NDcsImV4cCI6MjA0MTYzOTU0N30.4CgYdNbVYXHQQ28sNPwRiYdTkXy3W9VT9Ls4sQPMWiY

# Instal·lar al telèfon
adb install build/app/outputs/flutter-apk/app-debug.apk
```

**Avantatges:**
- ✅ Pots desconnectar el cable
- ✅ App queda instal·lada per testar quan vulguis
- ✅ Millor performance que amb `flutter run`

**Desavantatges:**
- ⚠️ Has de rebuildar i reinstal·lar per veure canvis
- ⚠️ Sense hot reload
- ⚠️ Logs només visibles via `adb logcat`

### Opció C: Wireless debugging (Android 11+)

**Configuració inicial:**
```bash
# Primer connecta amb cable
adb tcpip 5555

# Obté la IP del telèfon (Configuració > Sobre el telèfon > Estat > Adreça IP)
# Per exemple: 192.168.1.100

# Connecta via WiFi
adb connect 192.168.1.100:5555

# Ara pots desconnectar el cable
flutter run [--dart-define=...]
```

---

## 🔍 Workflow de desenvolupament recomanat

### Per disseny i UX (iteració ràpida)

1. **Obre dos terminals:**

   **Terminal 1 - App en execució:**
   ```bash
   cd C:/tarot/smart-divination/apps/tarot
   flutter run --dart-define=API_BASE_URL=https://backend-4sircya71-dnitzs-projects.vercel.app
   ```

   **Terminal 2 - Edició de codi:**
   ```bash
   # Obre el teu editor (VS Code, Android Studio, etc.)
   code C:/tarot/smart-divination/apps/tarot
   ```

2. **Fes canvis al codi** (colors, layouts, text, etc.)

3. **Prem `r` al terminal 1** per veure canvis a l'instant

4. **Si canvies widgets amb estat o assets, prem `R`** (hot restart)

### Per testar funcionalitat completa

1. **Instal·la APK debug** (Opció B)
2. **Prova fluxos complets** sense interferència del debugging
3. **Captura screenshots** directament del telèfon o amb ADB

---

## 📱 Comandes útils durant el desenvolupament

### Logs i debugging

```bash
# Veure logs en temps real
adb logcat | grep -i flutter

# Veure només errors
adb logcat *:E

# Netejar logs
adb logcat -c

# Inspeccionar base de dades local (si uses SQLite)
adb shell run-as com.smartdivination.tarot ls /data/data/com.smartdivination.tarot/databases/
```

### Screenshots

```bash
# Capturar screenshot
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png C:/tarot/screenshots/test_$(date +%Y%m%d_%H%M%S).png
adb shell rm /sdcard/screenshot.png
```

### Gestió de l'app

```bash
# Desinstal·lar app
adb uninstall com.smartdivination.tarot

# Esborrar dades de l'app (sense desinstal·lar)
adb shell pm clear com.smartdivination.tarot

# Forçar tancament
adb shell am force-stop com.smartdivination.tarot

# Obrir l'app
adb shell am start -n com.smartdivination.tarot/.MainActivity
```

### Info del telèfon

```bash
# Model i Android version
adb shell getprop ro.product.model
adb shell getprop ro.build.version.release

# Resolució de pantalla
adb shell wm size

# Densitat
adb shell wm density

# Estat de bateria
adb shell dumpsys battery
```

---

## 🎨 Testar disseny i UX - Checklist

Mentre proves l'app al telèfon, documenta:

### Navegació i fluxos
- [ ] Pots arribar a totes les pantalles?
- [ ] Els botons tenen feedback visual (ripple, hover)?
- [ ] Transicions entre pantalles són fluides?
- [ ] El botó "Enrere" funciona correctament?

### Visual i layout
- [ ] Els texts són llegibles (mida, contrast)?
- [ ] Els colors fan sentit (marca, jerarquia)?
- [ ] Espaiat consistent (margins, padding)?
- [ ] Elements alineats correctament?
- [ ] Icona de l'app es mostra bé al launcher?
- [ ] Splash screen (si n'hi ha) és adequat?

### Funcionalitat
- [ ] Pots fer login/signup?
- [ ] Les tirades de tarot funcionen?
- [ ] Les cartes es mostren correctament?
- [ ] La interpretació IA torna respostes?
- [ ] L'historial de sessions es guarda?
- [ ] Pots fer logout?

### Performance
- [ ] Temps de càrrega inicial (<3s)?
- [ ] Scrolls fluids sense lag?
- [ ] Animacions a 60fps?
- [ ] Consum de bateria acceptable?
- [ ] No crashes en fluxos normals?

### Responsiveness
- [ ] Layout s'adapta a la mida de la teva pantalla?
- [ ] Rotació de pantalla funciona (si està suportada)?
- [ ] Teclat no tapa inputs importants?

### Localització
- [ ] Pots canviar idioma (EN/ES/CA)?
- [ ] Tots els texts es mostren en l'idioma seleccionat?
- [ ] Formats de data/hora correctes per l'idioma?

---

## 🐛 Troubleshooting comú

### "No devices found"
```bash
# Windows: pot ser problema de drivers
# Descarrega drivers del fabricant del teu telèfon

# Verifica USB debugging està actiu
adb devices

# Reinicia servidor ADB
adb kill-server
adb start-server
```

### "App crashes on startup"
```bash
# Comprova logs
adb logcat | grep -i flutter

# Possibles causes:
# - Variables d'entorn incorrectes (API_BASE_URL, SUPABASE_*)
# - Permisos d'internet no configurats (AndroidManifest.xml)
# - Backend no accessible
```

### "Can't connect to backend"
```bash
# Verifica backend està actiu
curl https://backend-4sircya71-dnitzs-projects.vercel.app/api/health

# Comprova que el telèfon té internet
adb shell ping -c 3 8.8.8.8

# Verifica AndroidManifest.xml té permisos d'internet
cat android/app/src/main/AndroidManifest.xml | grep INTERNET
```

### "Hot reload not working"
- Prem `R` (hot restart) en lloc de `r` (hot reload)
- Alguns canvis (assets, dependencies, native code) requereixen rebuild complet
- Reinicia `flutter run`

### "Pantalla blanca o splash infinit"
```bash
# Comprova errors a consola
adb logcat | grep -E 'flutter|Error'

# Verifica Supabase keys són correctes
# Comprova que l'app pot inicialitzar Supabase client
```

---

## 📝 Documentar trobades

Mentre proves, crea notes de:

1. **Screenshots d'estat actual** (captures de cada pantalla)
2. **Issues detectats** (bugs, disseny, UX)
3. **Tasques de disseny** (què falta implementar)
4. **Millores de UX** (idees per millorar experiència)

**Format suggerit:**
```markdown
## Testing [DATA]

### Pantalla: Autenticació
- Screenshot: docs/testing/auth_screen_v1.png
- Issues:
  * Botó login massa petit
  * Text d'error no es mostra
- Millores:
  * Afegir opció "Oblidar contrasenya"
  * Indicador de càrrega al fer login

### Pantalla: Three-card draw
...
```

---

## 🚀 Següent pas

Després de testar l'app al telèfon:

1. Documenta l'estat real a un nou arxiu (per exemple: `docs/UI_STATUS.md`)
2. Crea llista prioritzada de tasques de disseny
3. Implementa millores iterativament amb hot reload
4. Captura screenshots quan el disseny estigui a punt

**Comença amb:**
```bash
cd C:/tarot/smart-divination/apps/tarot
flutter run --dart-define=API_BASE_URL=https://backend-4sircya71-dnitzs-projects.vercel.app
```

I prem `r` després de cada canvi per veure'l a l'instant! 🎨

---

## 📦 Instal·lar APK release (versió final signada)

Si vols testar la versió exacta que es pujarà a Play Store:

```bash
cd C:/tarot/smart-divination/apps/tarot

# L'APK release signat ja està generat a:
# build/app/outputs/flutter-apk/app-release.apk (55MB)

# IMPORTANT: Has de desinstal·lar primer versions debug anteriors per evitar conflictes de signatura
adb uninstall com.smartdivination.tarot

# Instal·lar APK release signat
adb install build/app/outputs/flutter-apk/app-release.apk

# Obrir l'app
adb shell monkey -p com.smartdivination.tarot -c android.intent.category.LAUNCHER 1
```

**Diferències amb debug:**
- ✅ Signat amb keystore de producció (`upload-keystore.jks`)
- ✅ Optimitzacions de performance actives
- ✅ Mida idèntica a la versió Play Store
- ✅ No debugging overhead
- ⚠️ No hot reload (has de rebuildar per veure canvis)

**Estat actual (2025-10-16):**
- Keystore generat: `android/upload-keystore.jks` (password: SmartTarot2025!, alias: upload)
- `android/key.properties` configurat amb credencials de signatura
- APK release: 55MB (`app-release.apk`)
- AAB release: 45.7MB (`app-release.aab`)
- App verificada en dispositiu físic Android

---

**Data creació:** 2025-10-13
**Última actualització:** 2025-10-16
