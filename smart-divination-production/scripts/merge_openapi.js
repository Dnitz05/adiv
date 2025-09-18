const fs = require('fs');
const path = require('path');

function readJson(p) {
  const text = fs.readFileSync(p, 'utf8');
  return JSON.parse(text);
}

function ensureDir(p) {
  if (!fs.existsSync(p)) fs.mkdirSync(p, { recursive: true });
}

function main() {
  const root = __dirname.replace(/scripts$/, '');
  const basePath = path.join(root, 'openapi', 'openapi.json');
  const addPath = path.join(root, 'openapi', 'addendum.json');
  const outDir = path.join(root, 'openapi');
  const outPath = path.join(outDir, '_merged.json');

  const base = readJson(basePath);
  const add = fs.existsSync(addPath) ? readJson(addPath) : { paths: {}, components: { schemas: {} } };

  const merged = {
    ...base,
    paths: { ...(base.paths || {}), ...(add.paths || {}) },
    components: {
      ...(base.components || {}),
      schemas: { ...((base.components && base.components.schemas) || {}), ...((add.components && add.components.schemas) || {}) }
    }
  };

  ensureDir(outDir);
  fs.writeFileSync(outPath, JSON.stringify(merged, null, 2));
  console.log(`Merged OpenAPI spec written to ${outPath}`);
}

main();

