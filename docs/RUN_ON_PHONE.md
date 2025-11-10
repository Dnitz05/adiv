# Executar Smart Tarot al telÃ¨fon - Guia rÃ pida

Guia per executar l'app al teu telÃ¨fon fÃ­sic i testar en temps real mentre desenvolupes.

---

## ðŸ”§ ConfiguraciÃ³ inicial (nomÃ©s primera vegada)

### 1. Habilitar mode desenvolupador al telÃ¨fon

**Android:**
1. Ves a **ConfiguraciÃ³** > **Sobre el telÃ¨fon**
2. Toca 7 vegades sobre **NÃºmero de compilaciÃ³**
3. VeurÃ s un missatge "Ara ets desenvolupador"
4. Torna a **ConfiguraciÃ³** > **Opcions de desenvolupador**
5. Activa **DepuraciÃ³ USB**
6. Activa **InstalÂ·lar aplicacions via USB** (si estÃ  disponible)

### 2. Connectar telÃ¨fon a l'ordinador

1. Connecta el telÃ¨fon amb cable USB
2. Quan aparegui el diÃ leg al telÃ¨fon, selecciona **TransferÃ¨ncia d'arxius** o **MTP**
3. Accepta la solÂ·licitud de depuraciÃ³ USB (marca "Confiar sempre en aquest ordinador")

### 3. Verificar connexiÃ³

```bash
# Verifica que el telÃ¨fon es detecta
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

## ðŸš€ Executar l'app (mode development)

### OpciÃ³ A: ExecuciÃ³ rÃ pida amb hot reload (RECOMANAT per desenvolupament)

```bash
cd C:/tarot/smart-divination/apps/tarot

# Executar amb backend de producciÃ³
flutter run \
  --dart-define=API_BASE_URL=https://backend-gv4a2ueuy-dnitzs-projects.vercel.app \
  --dart-define=SUPABASE_URL=https://vanrixxzaawybszeuivb.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhbnJpeHh6YWF3eWJzemV1aXZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc0NDMyMzIsImV4cCI6MjA0MzAxOTIzMn0.KfWe8d5ueKhAh3sZGOUjZ0kTzGq5f2LZ6oYOXPJl7o8
```
> Nota: l'antic alias `smart-divination.vercel.app` està retirat i respon 404; utilitza sempre `backend-gv4a2ueuy-dnitzs-projects.vercel.app`.

**Avantatges:**
- âœ… Hot reload: prem `r` per recarregar canvis
- âœ… Hot restart: prem `R` per reiniciar l'app
- âœ… Logs en temps real a la consola
- âœ… Debugging actiu

**Desavantatges:**
- âš ï¸ Necessita mantenir la consola oberta
- âš ï¸ Performance lleugerament inferior

### OpciÃ³ B: InstalÂ·lar APK debug (per testar sense cable)

```bash
cd C:/tarot/smart-divination/apps/tarot

# Build APK debug
flutter build apk --debug \
  --dart-define=API_BASE_URL=https://backend-gv4a2ueuy-dnitzs-projects.vercel.app \
  --dart-define=SUPABASE_URL=https://vanrixxzaawybszeuivb.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhbnJpeHh6YWF3eWJzemV1aXZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjYwNjM1NDcsImV4cCI6MjA0MTYzOTU0N30.4CgYdNbVYXHQQ28sNPwRiYdTkXy3W9VT9Ls4sQPMWiY

# InstalÂ·lar al telÃ¨fon
adb install build/app/outputs/flutter-apk/app-debug.apk
```

**Avantatges:**
- âœ… Pots desconnectar el cable
- âœ… App queda instalÂ·lada per testar quan vulguis
- âœ… Millor performance que amb `flutter run`

**Desavantatges:**
- âš ï¸ Has de rebuildar i reinstalÂ·lar per veure canvis
- âš ï¸ Sense hot reload
- âš ï¸ Logs nomÃ©s visibles via `adb logcat`

### OpciÃ³ C: Wireless debugging (Android 11+)

**ConfiguraciÃ³ inicial:**
```bash
# Primer connecta amb cable
adb tcpip 5555

# ObtÃ© la IP del telÃ¨fon (ConfiguraciÃ³ > Sobre el telÃ¨fon > Estat > AdreÃ§a IP)
# Per exemple: 192.168.1.100

# Connecta via WiFi
adb connect 192.168.1.100:5555

# Ara pots desconnectar el cable
flutter run [--dart-define=...]
```

---

## ðŸ” Workflow de desenvolupament recomanat

### Per disseny i UX (iteraciÃ³ rÃ pida)

1. **Obre dos terminals:**

   **Terminal 1 - App en execuciÃ³:**
   ```bash
   cd C:/tarot/smart-divination/apps/tarot
   flutter run --dart-define=API_BASE_URL=https://backend-gv4a2ueuy-dnitzs-projects.vercel.app
   ```

   **Terminal 2 - EdiciÃ³ de codi:**
   ```bash
   # Obre el teu editor (VS Code, Android Studio, etc.)
   code C:/tarot/smart-divination/apps/tarot
   ```

2. **Fes canvis al codi** (colors, layouts, text, etc.)

3. **Prem `r` al terminal 1** per veure canvis a l'instant

4. **Si canvies widgets amb estat o assets, prem `R`** (hot restart)

### Per testar funcionalitat completa

1. **InstalÂ·la APK debug** (OpciÃ³ B)
2. **Prova fluxos complets** sense interferÃ¨ncia del debugging
3. **Captura screenshots** directament del telÃ¨fon o amb ADB

---

## ðŸ“± Comandes Ãºtils durant el desenvolupament

### Logs i debugging

```bash
# Veure logs en temps real
adb logcat | grep -i flutter

# Veure nomÃ©s errors
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

### GestiÃ³ de l'app

```bash
# DesinstalÂ·lar app
adb uninstall com.smartdivination.tarot

# Esborrar dades de l'app (sense desinstalÂ·lar)
adb shell pm clear com.smartdivination.tarot

# ForÃ§ar tancament
adb shell am force-stop com.smartdivination.tarot

# Obrir l'app
adb shell am start -n com.smartdivination.tarot/.MainActivity
```

### Info del telÃ¨fon

```bash
# Model i Android version
adb shell getprop ro.product.model
adb shell getprop ro.build.version.release

# ResoluciÃ³ de pantalla
adb shell wm size

# Densitat
adb shell wm density

# Estat de bateria
adb shell dumpsys battery
```

---

## ðŸŽ¨ Testar disseny i UX - Checklist

Mentre proves l'app al telÃ¨fon, documenta:

### NavegaciÃ³ i fluxos
- [ ] Pots arribar a totes les pantalles?
- [ ] Els botons tenen feedback visual (ripple, hover)?
- [ ] Transicions entre pantalles sÃ³n fluides?
- [ ] El botÃ³ "Enrere" funciona correctament?

### Visual i layout
- [ ] Els texts sÃ³n llegibles (mida, contrast)?
- [ ] Els colors fan sentit (marca, jerarquia)?
- [ ] Espaiat consistent (margins, padding)?
- [ ] Elements alineats correctament?
- [ ] Icona de l'app es mostra bÃ© al launcher?
- [ ] Splash screen (si n'hi ha) Ã©s adequat?

### Funcionalitat
- [ ] Pots fer login/signup?
- [ ] Les tirades de tarot funcionen?
- [ ] Les cartes es mostren correctament?
- [ ] La interpretaciÃ³ IA torna respostes?
- [ ] L'historial de sessions es guarda?
- [ ] Pots fer logout?

### Performance
- [ ] Temps de cÃ rrega inicial (<3s)?
- [ ] Scrolls fluids sense lag?
- [ ] Animacions a 60fps?
- [ ] Consum de bateria acceptable?
- [ ] No crashes en fluxos normals?

### Responsiveness
- [ ] Layout s'adapta a la mida de la teva pantalla?
- [ ] RotaciÃ³ de pantalla funciona (si estÃ  suportada)?
- [ ] Teclat no tapa inputs importants?

### LocalitzaciÃ³
- [ ] Pots canviar idioma (EN/ES/CA)?
- [ ] Tots els texts es mostren en l'idioma seleccionat?
- [ ] Formats de data/hora correctes per l'idioma?

---

## ðŸ› Troubleshooting comÃº

### "No devices found"
```bash
# Windows: pot ser problema de drivers
# Descarrega drivers del fabricant del teu telÃ¨fon

# Verifica USB debugging estÃ  actiu
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
# Verifica backend estÃ  actiu
curl https://backend-gv4a2ueuy-dnitzs-projects.vercel.app/api/health

# Comprova que el telÃ¨fon tÃ© internet
adb shell ping -c 3 8.8.8.8

# Verifica AndroidManifest.xml tÃ© permisos d'internet
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

# Verifica Supabase keys sÃ³n correctes
# Comprova que l'app pot inicialitzar Supabase client
```

---

## ðŸ“ Documentar trobades

Mentre proves, crea notes de:

1. **Screenshots d'estat actual** (captures de cada pantalla)
2. **Issues detectats** (bugs, disseny, UX)
3. **Tasques de disseny** (quÃ¨ falta implementar)
4. **Millores de UX** (idees per millorar experiÃ¨ncia)

**Format suggerit:**
```markdown
## Testing [DATA]

### Pantalla: AutenticaciÃ³
- Screenshot: docs/testing/auth_screen_v1.png
- Issues:
  * BotÃ³ login massa petit
  * Text d'error no es mostra
- Millores:
  * Afegir opciÃ³ "Oblidar contrasenya"
  * Indicador de cÃ rrega al fer login

### Pantalla: Three-card draw
...
```

---

## ðŸš€ SegÃ¼ent pas

DesprÃ©s de testar l'app al telÃ¨fon:

1. Documenta l'estat real a un nou arxiu (per exemple: `docs/UI_STATUS.md`)
2. Crea llista prioritzada de tasques de disseny
3. Implementa millores iterativament amb hot reload
4. Captura screenshots quan el disseny estigui a punt

**ComenÃ§a amb:**
```bash
cd C:/tarot/smart-divination/apps/tarot
flutter run --dart-define=API_BASE_URL=https://backend-gv4a2ueuy-dnitzs-projects.vercel.app
```

I prem `r` desprÃ©s de cada canvi per veure'l a l'instant! ðŸŽ¨

---

## ðŸ“¦ InstalÂ·lar APK release (versiÃ³ final signada)

Si vols testar la versiÃ³ exacta que es pujarÃ  a Play Store:

```bash
cd C:/tarot/smart-divination/apps/tarot

# L'APK release signat ja estÃ  generat a:
# build/app/outputs/flutter-apk/app-release.apk (55MB)

# IMPORTANT: Has de desinstalÂ·lar primer versions debug anteriors per evitar conflictes de signatura
adb uninstall com.smartdivination.tarot

# InstalÂ·lar APK release signat
adb install build/app/outputs/flutter-apk/app-release.apk

# Obrir l'app
adb shell monkey -p com.smartdivination.tarot -c android.intent.category.LAUNCHER 1
```

**DiferÃ¨ncies amb debug:**
- âœ… Signat amb keystore de producciÃ³ (`upload-keystore.jks`)
- âœ… Optimitzacions de performance actives
- âœ… Mida idÃ¨ntica a la versiÃ³ Play Store
- âœ… No debugging overhead
- âš ï¸ No hot reload (has de rebuildar per veure canvis)

**Estat actual (2025-10-16):**
- Keystore generat: `android/upload-keystore.jks` (password: SmartTarot2025!, alias: upload)
- `android/key.properties` configurat amb credencials de signatura
- APK release: 55MB (`app-release.apk`)
- AAB release: 45.7MB (`app-release.aab`)
- App verificada en dispositiu fÃ­sic Android

---

**Data creaciÃ³:** 2025-10-13
**Ãšltima actualitzaciÃ³:** 2025-10-16
