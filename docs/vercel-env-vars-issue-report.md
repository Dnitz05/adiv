# Informe Tècnic: Problema amb Variables d'Entorn de Vercel

**Data**: 17 d'octubre de 2025
**Projecte**: Backend Tarot (dnitzs-projects/backend)
**Estat**: Crític - Interpretacions d'IA no funcionen

---

## Resum Executiu

Les interpretacions d'IA del tarot estan fallant amb el missatge "Interpretation unavailable at this time" degut a un problema crític amb com Vercel gestiona les variables d'entorn. Totes les variables afegides via `vercel env add` contenen un caràcter `\n` (newline) corrupte al final que invalida els valors.

---

## Simptomatologia

### Comportament Observat
- **API Response**: `{"generated": false, "interpretation": "Interpretation unavailable at this time."}`
- **Logs DeepSeek**: Error "Model Not Exist" (status 400)
- **Clau API**: Vercel logs mostren `hasApiKey: true, keyLength: 36` però la crida a DeepSeek falla

### Impacte
- ❌ Cap interpretació d'IA funciona
- ❌ Usuaris reben missatge genèric en lloc d'interpretació personalitzada
- ❌ El servei principal de l'aplicació està completament inutilitzable

---

## Diagnòstic Tècnic

### 1. Identificació del Problema

Quan es fa `vercel env pull`, **totes** les variables tenen un `\n` al final:

```bash
DEEPSEEK_API_KEY="sk-9fc9716da2bf4eccb2a577b9caa02fd7\n"
DEEPSEEK_MODEL="deepseek-chat\n"
SUPABASE_URL="https://vanrixxzaawybszeuivb.supabase.co\n"
SUPABASE_ANON_KEY="eyJhbGci...\n"
SUPABASE_SERVICE_ROLE_KEY="eyJhbGci...\n"
```

### 2. Causa Arrel

**Hipòtesi Principal**: El problema es va introduir quan les variables es van afegir inicialment a Vercel. Possibles causes:

1. **Pipe amb echo**: Es van afegir amb `echo "value" | vercel env add`, que afegeix `\n`
2. **Copy-paste amb newline**: Les claus es van enganxar amb un caràcter newline invisible
3. **Bug de Vercel CLI**: Versió 46.0.1 podria tenir un bug

### 3. Impacte del `\n` al Runtime

#### A. `DEEPSEEK_MODEL="deepseek-chat\n"`
```typescript
const DEFAULT_MODEL = envModel === 'deepseek-reasoner' ? 'deepseek-chat' : (envModel ?? 'deepseek-chat');
// envModel = "deepseek-chat\n" !== "deepseek-reasoner" ✓
// Però quan s'envia a DeepSeek API:
{
  "model": "deepseek-chat\n"  // ❌ Model invàlid!
}
```

**Resultat**: DeepSeek API retorna error 400 "Model Not Exist"

#### B. `DEEPSEEK_API_KEY="sk-...\n"`
```typescript
const apiKey = process.env.DEEPSEEK_API_KEY;
// apiKey = "sk-9fc9716da2bf4eccb2a577b9caa02fd7\n"

headers: {
  'authorization': `Bearer ${apiKey}`
  // Valor: "Bearer sk-9fc9716da2bf4eccb2a577b9caa02fd7\n" ❌
}
```

**Resultat**: Clau API invàlida (el `\n` fa que falli l'autenticació)

---

## Evidència dels Logs

### Vercel Logs (backend-h9m9t1u8e)
```json
{
  "level": "info",
  "message": "DeepSeek API key check",
  "ctx": {
    "sessionId": "log_test_1760707588",
    "hasApiKey": true,
    "keyLength": 36
  }
}
{
  "level": "error",
  "message": "DeepSeek request failed",
  "ctx": {
    "sessionId": "log_test_1760707588",
    "status": 400,
    "errorText": "{\"error\":{\"message\":\"Model Not Exist\",\"type\":\"invalid_request_error\"}}"
  }
}
```

### Test Manual de la Clau
```bash
# Clau amb \n (simulant el que té Vercel):
$ curl -H "Authorization: Bearer sk-9fc9716da2bf4eccb2a577b9caa02fd7\n" ...
# ❌ Falla amb error d'autenticació

# Clau sense \n:
$ curl -H "Authorization: Bearer sk-9fc9716da2bf4eccb2a577b9caa02fd7" ...
# ✅ Funciona correctament
```

---

## Intents de Solució

### 1. Re-afegir Variables (Intentat 3 vegades)
```bash
vercel env rm DEEPSEEK_API_KEY production --yes
echo "sk-9fc9716da2bf4eccb2a577b9caa02fd7" | vercel env add DEEPSEEK_API_KEY production
```

**Resultat**: El `\n` persisteix després de re-afegir

### 2. Verificar la Clau Directament
```bash
curl -X POST https://api.deepseek.com/v1/chat/completions \
  -H "Authorization: Bearer sk-9fc9716da2bf4eccb2a577b9caa02fd7" \
  -d '{"model":"deepseek-chat","messages":[{"role":"user","content":"test"}]}'
```

**Resultat**: ✅ La clau és vàlida quan es prova directament (sense `\n`)

### 3. Redesplegar Backend (6 vegades)
- `backend-h9m9t1u8e`
- `backend-kdqc6g2zh`
- `backend-1w0aq4ife`
- `backend-pwgckbvkb`
- `backend-kglyfvdd5`
- `backend-34hcjkl9u`

**Resultat**: El problema persisteix en tots els desplegaments

---

## Configuració Actual

### Variables d'Entorn al Projecte `backend`

| Variable | Entorns | Estat |
|----------|---------|-------|
| `DEEPSEEK_API_KEY` | Production, Preview, Development | ❌ Corrupta amb `\n` |
| `DEEPSEEK_MODEL` | Production | ❌ Corrupta amb `\n` |
| `SUPABASE_URL` | Production, Preview | ❌ Corrupta amb `\n` |
| `SUPABASE_ANON_KEY` | Production, Preview | ❌ Corrupta amb `\n` |
| `SUPABASE_SERVICE_ROLE_KEY` | Production, Preview | ❌ Corrupta amb `\n` |

### Codi Actual (interpret.ts:150)
```typescript
const apiKey = process.env.DEEPSEEK_API_KEY;
log('info', 'DeepSeek API key check', {
  sessionId: params.sessionId,
  hasApiKey: !!apiKey,
  keyLength: apiKey?.length || 0,
});
if (!apiKey) {
  log('warn', 'DeepSeek API key missing');
  return null;
}
```

El codi **NO** fa trim o neteja del `\n`, assumint que les env vars són correctes.

---

## Solucions Proposades

### Opció A: Workaround al Codi (Curt termini) ⭐ RECOMANAT

Modificar `interpret.ts` per netejar el `\n`:

```typescript
const apiKey = process.env.DEEPSEEK_API_KEY?.trim();
const model = (params.model ?? process.env.DEEPSEEK_MODEL ?? 'deepseek-chat').trim();
```

**Avantatges**:
- Solució immediata
- No depèn de Vercel
- Protegeix contra futurs problemes similars

**Desavantatges**:
- No resol la causa arrel
- Altres serveis podrien tenir el mateix problema

### Opció B: Afegir via Web UI de Vercel

1. Anar a https://vercel.com/dnitzs-projects/backend/settings/environment-variables
2. Eliminar totes les variables corruptes
3. Re-afegir manualment via la interfície web (no CLI)

**Avantatges**:
- Podria evitar el bug del CLI
- Solució "neta"

**Desavantatges**:
- Requereix accés web
- Temps per re-configurar totes les variables
- No garanteix que funcioni

### Opció C: Recrear el Projecte Vercel

1. Crear nou projecte `backend-v2`
2. Configurar totes les variables des de zero via web UI
3. Actualitzar dominis i referències

**Avantatges**:
- Parteix d'un estat net
- Elimina qualsevol configuració corrupta

**Desavantatges**:
- Molt temps
- Risc de perdre configuració
- Downtime durant la migració

### Opció D: Contactar Vercel Support

Obrir ticket reportant el bug del CLI amb el `\n`.

**Avantatges**:
- Podria identificar un bug real
- Ajuda a altres usuaris

**Desavantatges**:
- Temps de resposta desconegut
- No soluciona el problema immediat

---

## Recomanació

**IMPLEMENTAR OPCIÓ A + D EN PARAL·LEL**

1. **Immediat**: Afegir `.trim()` al codi per solucionar ara (15 minuts)
2. **Mig termini**: Obrir ticket amb Vercel amb aquest informe (30 minuts)
3. **Llarg termini**: Si Vercel confirma el bug, eliminar el workaround

---

## Passos Següents

### 1. Implementar Workaround (URGENT)

```typescript
// File: smart-divination/backend/pages/api/chat/interpret.ts

async function generateInterpretationFromDeepSeek(
  params: DeepSeekParams
): Promise<GeneratedInterpretation | null> {
  // WORKAROUND: Vercel env vars have trailing \n
  const apiKey = process.env.DEEPSEEK_API_KEY?.trim();

  log('info', 'DeepSeek API key check', {
    sessionId: params.sessionId,
    hasApiKey: !!apiKey,
    keyLength: apiKey?.length || 0,
    rawLength: process.env.DEEPSEEK_API_KEY?.length || 0, // Debug info
  });

  if (!apiKey) {
    log('warn', 'DeepSeek API key missing');
    return null;
  }

  const requestBody = {
    // WORKAROUND: Clean model name
    model: (params.model ?? process.env.DEEPSEEK_MODEL ?? DEFAULT_MODEL).trim(),
    temperature: params.temperature ?? 0.8,
    max_tokens: 1000,
    // ...
  };

  // ...
}
```

### 2. Actualitzar Altres Serveis

Revisar si altres parts del codi també necesssiten `.trim()`:
- `lib/utils/supabase.ts` (SUPABASE_URL, etc.)
- Qualsevol altre servei extern

### 3. Testejar

```bash
# Redesplegar
cd smart-divination/backend && vercel --prod --force

# Testejar interpretació
curl -X POST https://backend-[NEW_ID].vercel.app/api/chat/interpret \
  -H "Content-Type: application/json" \
  -H "x-user-id: anon_test" \
  -d '{"sessionId":"test","results":{"cards":[{"name":"The Magician"}]}}'
```

### 4. Documentar

Afegir comentari al codi explicant el workaround per si cal eliminar-lo en el futur.

---

## Referències

- Vercel CLI Version: 46.0.1
- Node Version: 18.x
- Projecte: https://vercel.com/dnitzs-projects/backend
- Desplegaments fallits: 6+
- Temps invertit: ~3 hores

---

## Apèndix: Comandos Utilitzats

```bash
# Verificar env vars
vercel env ls
vercel env pull --environment=production .env.prod

# Re-afegir variables
vercel env rm DEEPSEEK_API_KEY production --yes
echo "sk-9fc9716da2bf4eccb2a577b9caa02fd7" | vercel env add DEEPSEEK_API_KEY production

# Redesplegar
vercel --prod --force

# Consultar logs
vercel logs [URL] --since 5m

# Testejar clau
curl -X POST https://api.deepseek.com/v1/chat/completions \
  -H "Authorization: Bearer sk-9fc9716da2bf4eccb2a577b9caa02fd7" \
  -H "Content-Type: application/json" \
  -d '{"model":"deepseek-chat","messages":[{"role":"user","content":"test"}],"max_tokens":5}'
```
