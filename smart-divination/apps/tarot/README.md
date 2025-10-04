# Smart Tarot (Prototype)

The tarot app is the only Flutter client with partial functionality. It integrates with the Next.js backend to draw cards and display recent sessions. The experience is still a prototype: graphics, copy, localisation, and release polish remain pending.

## Features Today
- Draw three-card spreads via `POST /api/draw/cards`.
- Toggle reversed cards and supply an optional seed or question.
- View the most recent session history entry (requires Supabase session data).
- Persist a generated user identifier with `shared_preferences`.

## Getting Started
```bash
cd smart-divination
melos bootstrap
cd apps/tarot
flutter pub get
flutter run \
  --dart-define=API_BASE_URL=http://10.0.2.2:3001 \
  --dart-define=SUPABASE_URL=https://<project>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<public-anon-key> \
  --dart-define=SUPABASE_PASSWORD_RESET_REDIRECT=smarttarot://auth-reset  # ajusteu les claus segons el vostre projecte
```

### Environment Notes
- `API_BASE_URL` should point to your backend instance (emulator: `http://10.0.2.2:3001`, device: use machine IP).
- Provide `SUPABASE_URL` and `SUPABASE_ANON_KEY` via `--dart-define` so the app can sign in against your Supabase project.
- `SUPABASE_PASSWORD_RESET_REDIRECT` must match a deep link configured per plataforma (p. ex. `smarttarot://auth-reset`) i ha d'estar afegit al panell de redireccions de Supabase.
- Without Supabase credentials the backend returns empty history; draws still succeed but nothing persists.

## Testing
```bash
flutter test
```
Tests currently include widget smoke coverage only. Expand before shipping features.

## Release Configuration

### Android
1. Copy `android/key.properties.sample` to `android/key.properties` and fill in the real keystore passwords and alias.
2. Place your release keystore at `android/app/upload-keystore.jks` (or update `storeFile` accordingly).
3. `build.gradle.kts` reads those values at build time; when missing, it falls back to debug signing so local release builds still run.
4. Provide the same secrets to the `flutter-release.yml` workflow (`ANDROID_KEYSTORE_*`, `ANDROID_API_BASE_URL`) so CI can produce a signed AAB.

### iOS
1. The bundle identifier is `com.smartdivination.tarot` (tests use `com.smartdivination.tarot.RunnerTests`).
2. Create a distribution certificate and provisioning profile for that identifier, then let Xcode manage signing or import them before running `flutter build ipa`.
3. For CI, supply the certificate (`IOS_CERTIFICATE_P12_BASE64` + password) and App Store Connect key secrets so `flutter-release.yml` can produce signed archives.

## Outstanding Work
- Replace default Material theming and add tarot-specific assets.
- Surface interpretation content when Supabase artefacts are available.
- Handle offline states, backend errors, and eligibility failures gracefully.
- Finalise store metadata (icons, splash screens, copy) and extend automated tests.

Treat this app as a starting point rather than a store-ready product.

## Authentication
- El flux d'inici de sessió permet registre amb correu/contrasenya i canvi segur de contrasenya via enllaç de recuperació.
- Executeu les seeds de Supabase (`supabase/seeds/dev_seed.sql`) per obtenir l'usuari demo `demo-seeker@smartdivination.test / TarotDemo1!` ja confirmat.
- Configureu correu transaccional (SMTP real o Inbucket local) per verificar que els correus de confirmació i de reset s'enviïn correctament.
