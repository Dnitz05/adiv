Security Policy

Reporting a Vulnerability
- Please email security issues to security@smart-divination.example (or open a private advisory in GitHub if enabled).
- Include a clear description, reproduction steps, and potential impact.
- We will acknowledge receipt within 3 business days.

Supported Versions
- Main branch of the canonical workspace under `smart-divination/`.

Scope
- Serverless backend under `smart-divination/backend/pages/api/`
- Flutter apps under `smart-divination/apps/`
- Shared Flutter package `smart-divination/packages/common/`

Out of Scope
- Deprecated folders: `smart_tarot/`, `i_ching_app/`, `runes_app/`, `smart-divination-production/`.

Best Practices
- Do not commit secrets; use environment variables and platform secret managers.
- Prefer allowlists for CORS and origin checks.
