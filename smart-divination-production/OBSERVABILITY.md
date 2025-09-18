Observabilitat – Smart Divination Backend
=========================================

Resum
-----
- Mètriques lleugeres in‑memory (P50/P95, RPS, %errors) amb fallback Edge‑safe.
- Proveïdors opcionals: console (logs) i Datadog (ingestió via API v2).
- Endpoint de mètriques per a dev/staging: `GET /api/metrics` (controlat per env).

Variables d’entorn
------------------
- `METRICS_PROVIDER`: `noop` (defecte), `console` o `datadog`.
- `DATADOG_API_KEY`: clau Datadog (obligatòria si `METRICS_PROVIDER=datadog`).
- `DATADOG_SITE`: domini (defecte `datadoghq.com`; alternatives `datadoghq.eu`, `us3.datadoghq.com`, ...).
- `METRICS_EXPOSE`: `true` per exposar `GET /api/metrics` en dev/staging; en prod no s’exposa per defecte.

Mètriques enviades (Datadog)
----------------------------
- `smart_divination.api.latency_ms` (gauge) amb tags:
  - `endpoint:/api/...`, `status:200|400|...`, `status_group:2xx|3xx|4xx|5xx`.
- `smart_divination.api.requests` (count) amb tags idèntics.

Notes Datadog
-------------
- Per P95 real, Datadog recomana enviar `distribution` (endpoint d’ingestió diferent). Aquí usem gauge + count per simplicitat. El dashboard usa `avg` i `sum` + càlcul d’error rate amb `status_group`.
- Si voleu p95 exacte, es pot estendre el provider per enviar distribucions (`/api/v2/distribution_points`).

Dashboard d’exemple
-------------------
- Fitxer: `observability/DATADOG_DASHBOARD.json`
  - Latència mitjana per endpoint (5m).
  - Requests/min per endpoint.
  - % d’errors 5xx (5m) per endpoint.
- Importa’l a Datadog: Dashboards → New → Import JSON.

Alertes d’exemple
-----------------
- Fitxer: `observability/DATADOG_MONITORS.json`
  - Avg Latency > 800ms (5m) per endpoint.
  - 5xx rate > 1% (5m) per endpoint.
- Importa a Datadog: Monitors → New → Import JSON.
- Ajusta `@pagerduty`/notificadors al teu entorn.

CI – Checks de mètriques
------------------------
- Workflow: `.github/workflows/backend-ci.yml`
  - Executa lint, type-check i tests.
  - Afegeix un test `__tests__/metrics.sanity.test.ts` que valida l’ús bàsic de les mètriques.

Endpoint de mètriques (dev/staging)
-----------------------------------
- `GET /api/metrics` retorna resums per endpoint: P50/P95, promig, RPS, total.
- Control d’exposició via `METRICS_EXPOSE=true` (o `NODE_ENV !== 'production'`).

Bones pràctiques i llindars
---------------------------
- P95 < 500ms rutes crítiques (`/api/sessions`, `/api/draw/*`, `/api/chat/interpret`).
- Error rate 5xx < 1% global i per endpoint.
- Afegir tags d’entorn (`env:staging|prod`) via variables d’entorn i mapat a provider si cal.

