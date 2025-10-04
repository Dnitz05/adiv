# Supabase Setup Guide

Aquesta guia explica com preparar Supabase per al desenvolupament local del backend Smart Divination. El reforc de produccio (backups, rotacio de claus, observabilitat) queda pendent.

## Prerequisits
- Compte i projecte Supabase
- Supabase CLI (opcional pero recomanat)
- Node 18+ per executar el backend

## 1. Crear o Seleccionar Projecte Supabase
1. A https://app.supabase.com creeu un projecte nou o reutilitzeu-ne un d existent.
2. Trieu una regio propera als usuaris.
3. Anoteu URL, anon key i service role key des de **Project Settings > API**.

## 2. Configurar Variables d Entorn
Dins `smart-divination/backend` copieu el fitxer d exemple i ompliu les claus:
```bash
cd smart-divination/backend
cp .env.example .env.local
```
Valors requerits:
```
SUPABASE_URL=https://<project>.supabase.co
SUPABASE_ANON_KEY=public-anon-key
SUPABASE_SERVICE_ROLE_KEY=service-role-key
DEEPSEEK_API_KEY=sk-...
```
Manteniu la service role key al servidor; no l exposeu a Flutter.

## 3. Aplicar Migracions
Migracions vigents:
1. `supabase/migrations/20250101000001_initial_schema.sql`
2. `supabase/migrations/20250922090000_session_history_schema.sql`

### Opcio A: Supabase CLI
```bash
cd smart-divination
supabase link --project-ref <project-id>
supabase db push
```

### Opcio B: Supabase Dashboard
Executeu cada SQL des de l **SQL Editor** en ordre.

### Opcio C: Scripts del repositori
Per evitar comandes manuals utilitzeu els scripts empaquetats:
```bash
chmod +x scripts/supabase/*.sh
SUPABASE_DB_URL=postgresql://user:pass@host:port/db scripts/supabase/db_push.sh
```
El script detecta si disposeu de `SUPABASE_DB_URL` o be del parell `SUPABASE_PROJECT_ID` + `SUPABASE_ACCESS_TOKEN`.

> **Tip:** Reviseu `supabase/config.toml` i assegureu-vos que `sql_paths` apunta a `./seeds/dev_seed.sql` perquè els seeds s'apliquin durant `db reset`.

Per regenerar els tipus TypeScript:
```bash
cd smart-divination/backend
SUPABASE_DB_URL=postgresql://user:pass@host:port/db npm run supabase:types:ci
```
Aquest comandament delega a `scripts/supabase/generate_types.sh` i falla si `lib/types/generated/supabase.ts` no esta al dia.

## 4. Verificar Esquema
Haurieu de veure:
- Taules: `users`, `sessions`, `user_stats`, `api_usage`, `session_artifacts`, `session_messages`
- Enums: `user_tier`, `divination_technique`, `session_actor_type`, `session_artifact_type`
- Vista: `session_history_expanded`
- Funcio: `touch_session_history()`

## 5. Consells per a Desenvolupament Local
- Sense credencials Supabase el backend respon amb historials buits i no persisteix dades; ompliu `.env.local` per provar el flux complet.
- `npm test` mockeja Supabase, aixi que no cal connexio per a la suite unitaria.
- Podeu utilitzar `supabase start` per aixecar una instancia local i aplicar-hi les migracions.
- Activeu la confirmació de correu i el canvi segur de contrasenya a `supabase/config.toml` (`[auth.email] enable_confirmations = true` i `secure_password_change = true`) per provar el flux email/contrasenya real.

## 6. Dades Seed
Executeu `supabase/seeds/dev_seed.sql` amb la service role key per inserir usuaris, sessions i artefactes de mostra (inclou l'usuari demo `demo-seeker@smartdivination.test` amb contrasenya `TarotDemo1!` ja confirmada):
```bash
cd supabase
psql "$SUPABASE_DB_URL" -f seeds/dev_seed.sql
```
(Si useu la CLI local, `supabase db remote commit seeds/dev_seed.sql` tambe funciona.)

El fitxer conte dades idempotents; podeu editar-lo o afegir-hi nous registres segons necessitats.

## 7. Automatitzacio i CI
- `.github/workflows/backend-canonical-ci.yml` aplica migracions (`scripts/supabase/apply.sh`) i comprova que els tipus Supabase estiguin sincronitzats (`npm run supabase:types:ci`).
- `.github/workflows/flutter-release.yml` construeix artefactes Android/iOS de l app de tarot i admet secrets de signing.
- Definiu els secrets necessaris a Repository Settings > Secrets abans d executar els workflows.

## 8. Checklist de Desplegament
- Configureu variables Supabase i `DEEPSEEK_API_KEY` al vostre entorn (Vercel, etc.).
- Restrict CORS i assegureu-vos que nomes el backend usa la service key.
- Planifiqueu rotacio de claus i copies de seguretat abans d arribar a produccio.

Actualitzeu aquesta guia quan afegiu migracions, triggers o requisits nous.
