# Build Status

_Last reviewed: 2025-10-18_

Smart Divination remains under active development, but the current snapshot ja disposa de tots els fluxos principals en funcionament. Les notes següents reflecteixen l'estat real del repositori; utilitzeu-les com a referència en lloc de documents antics.

## Backend (Next.js)
- Endpoints de tirada `POST /api/draw/cards`, `POST /api/draw/coins` i `POST /api/draw/runes` generen resultats criptogràfics, creen sessions Supabase i registren artefactes i missatges quan hi ha credencials.
- **Nou**: El servei d'interpretació `POST /api/chat/interpret` integra DeepSeek i ara **inclou correctament l'estat de cartes invertides** (Invertida/Invertit/Reversed) als noms de les cartes a les interpretacions, permetent que el client Flutter les detecti i mostri rotades.
- **Nou**: Endpoint de recomanació de spreads `POST /api/spread/recommend` utilitza IA (DeepSeek) per seleccionar la tirada més adequada amb **raonaments càlids i extensos** (2-4 frases) que expliquen el PER QUÈ i el COM llegir la tirada, amb to místic però pràctic.
- Rutes d'historial i perfil (`GET /api/sessions/:userId`, `GET /api/users/:userId/profile`, `GET /api/users/:userId/can-start-session`) retornen dades reals amb Supabase; quan falten claus, fan degradació controlada a respostes buides.
- Mètriques (`GET /api/metrics`) i proves Jest cobreixen draw, interpretació, sessions i usuaris. Encara manca proveir dashboards o alarmes operacionals.
- **Desplegat a Vercel** en producció amb alias `backend-gv4a2ueuy-dnitzs-projects.vercel.app`.

## Flutter Workspace
- **Nou**: `apps/tarot` ha rebut millores significatives d'UI:
  - **Layout estil periòdic**: Les interpretacions de cartes mostren imatges flotades a l'esquerra amb text que flueix al costat i continua sota la imatge.
  - **Cartes invertides**: Les cartes invertides es mostren correctament rotades 180° a les interpretacions.
  - **Capitalització automàtica**: El primer caràcter de cada interpretació de carta es capitalitza automàticament.
  - **Iconografia millorada**: Icones relacionades amb cartes (`Icons.style`) per a les seccions de cartes als globus d'interpretació.
  - **Espaiat optimitzat**: 8px d'espaiat entre la capçalera de la pregunta i el globus d'informació de la tirada.
- `apps/tarot` consumeix tirades, interpretacions i informació de perfil, mostrant historial i límits.
- `apps/iching` i `apps/runes` també criden els endpoints corresponents amb controls d'UI bàsics, historial local i preferències compartides.
- Paquet `packages/common` aporta localitzacions (ca/en/es) i delegats reutilitzats per totes les apps.

## Supabase
- Migracions provisioning per usuaris, sessions, artefactes, missatges, estadístiques i ús d'API (`supabase/migrations`). Triggers mantenen metadades d'historial.
- El backend escriu sessions i artefactes quan es disposa de `SUPABASE_URL` i `SUPABASE_SERVICE_ROLE_KEY`; sense credencials, els endpoints responen sense persistència.
- Falta automatitzar el desplegament de migracions i la gestió de secrets en CI/CD.

## Tooling i CI
- Existeixen scripts locals (`npm test`, `melos run analyze:all`, `flutter test`), però no hi ha pipelines configurats en aquesta instantània.
- La cobertura Flutter és només de smoke tests; cal ampliar-la abans de considerar llançaments.

## Recent Changes (October 2025)
- ✅ **Cartes invertides corregides**: Les interpretacions de l'IA ara inclouen marcadors d'inversió, el Flutter les detecta i rota correctament.
- ✅ **Recomanacions de spreads millorades**: Raonaments IA més càlids, extensos i sensibles (2-4 frases vs 1-2).
- ✅ **Layout d'interpretacions millorat**: Estil periòdic amb imatges flotades, capitalització automàtica, iconografia millorada.
- ✅ **Backend desplegat**: Vercel en producció amb alias configurat i funcionant.
- ✅ **APK construït i instal·lat**: App Flutter actualitzada i desplegada en dispositiu de prova.

## Prioritats Immediates
1. Consolidar proves: mocks HTTP per Flutter, integració end-to-end al backend i tests de migracions.
2. Automatitzar migracions Supabase i preparar pipelines/entorns per desplegar backend i apps.
3. Documentar i monitoritzar mètriques clau (ús, errors, límits) per preparar operacions en producció.
4. Polir UX addicional (actius, copy, estat fora de línia) i unificar patrons entre tarot, I Ching i runes.
