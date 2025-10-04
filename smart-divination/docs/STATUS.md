# Build Status

_Last reviewed: 2025-09-22_

Smart Divination remains under active development, but the current snapshot ja disposa de tots els fluxos principals en funcionament. Les notes següents reflecteixen l'estat real del repositori; utilitzeu-les com a referència en lloc de documents antics.

## Backend (Next.js)
- Endpoints de tirada `POST /api/draw/cards`, `POST /api/draw/coins` i `POST /api/draw/runes` generen resultats criptogràfics, creen sessions Supabase i registren artefactes i missatges quan hi ha credencials.
- El servei d'interpretació `POST /api/chat/interpret` integra DeepSeek i desa resums/mots clau com a artefactes opcionalment.
- Rutes d'historial i perfil (`GET /api/sessions/:userId`, `GET /api/users/:userId/profile`, `GET /api/users/:userId/can-start-session`) retornen dades reals amb Supabase; quan falten claus, fan degradació controlada a respostes buides.
- Mètriques (`GET /api/metrics`) i proves Jest cobreixen draw, interpretació, sessions i usuaris. Encara manca proveir dashboards o alarmes operacionals.

## Flutter Workspace
- `apps/tarot` consumeix tirades, interpretacions i informació de perfil, mostrant historial i límits. El codi funciona però necessita refinament visual, estat modular i més proves.
- `apps/iching` i `apps/runes` també criden els endpoints corresponents amb controls d'UI bàsics, historial local i preferències compartides.
- Paquet `packages/common` aporta localitzacions (ca/en/es) i delegats reutilitzats per totes les apps.

## Supabase
- Migracions provisioning per usuaris, sessions, artefactes, missatges, estadístiques i ús d'API (`supabase/migrations`). Triggers mantenen metadades d'historial.
- El backend escriu sessions i artefactes quan es disposa de `SUPABASE_URL` i `SUPABASE_SERVICE_ROLE_KEY`; sense credencials, els endpoints responen sense persistència.
- Falta automatitzar el desplegament de migracions i la gestió de secrets en CI/CD.

## Tooling i CI
- Existeixen scripts locals (`npm test`, `melos run analyze:all`, `flutter test`), però no hi ha pipelines configurats en aquesta instantània.
- La cobertura Flutter és només de smoke tests; cal ampliar-la abans de considerar llançaments.

## Prioritats Immediates
1. Polir UX (actius, copy, estat fora de línia) i unificar patrons entre tarot, I Ching i runes.
2. Consolidar proves: mocks HTTP per Flutter, integració end-to-end al backend i tests de migracions.
3. Automatitzar migracions Supabase i preparar pipelines/entorns per desplegar backend i apps.
4. Documentar i monitoritzar mètriques clau (ús, errors, límits) per preparar operacions en producció.
