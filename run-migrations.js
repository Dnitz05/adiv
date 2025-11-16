const fs = require('fs');
const https = require('https');

const SERVICE_ROLE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhbnJpeHh6YWF3eWJzemV1aXZiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyNzk3MDQ2NSwiZXhwIjoyMDQzNTQ2NDY1fQ.l4lwDL0cfG4LxJr-YH24EMNZ6T1FtWi-b5lPwWujVDw';
const PROJECT_URL = 'https://vanrixxzaawybszeuivb.supabase.co';

async function executeSql(sql) {
  return new Promise((resolve, reject) => {
    const data = JSON.stringify({ query: sql });

    const options = {
      hostname: 'vanrixxzaawybszeuivb.supabase.co',
      port: 443,
      path: '/rest/v1/rpc/exec_sql',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'apikey': SERVICE_ROLE_KEY,
        'Authorization': `Bearer ${SERVICE_ROLE_KEY}`,
        'Content-Length': data.length,
        'Prefer': 'return=representation'
      }
    };

    const req = https.request(options, (res) => {
      let body = '';
      res.on('data', (chunk) => body += chunk);
      res.on('end', () => {
        if (res.statusCode >= 200 && res.statusCode < 300) {
          console.log('✅ SQL executed successfully');
          resolve(body);
        } else {
          console.error('❌ Error:', res.statusCode, body);
          reject(new Error(`HTTP ${res.statusCode}: ${body}`));
        }
      });
    });

    req.on('error', reject);
    req.write(data);
    req.end();
  });
}

async function runMigrations() {
  console.log('📦 Running migrations...\n');

  // Read migration files
  const migration15 = fs.readFileSync('supabase/migrations/20251116000015_create_lunar_guide_templates.sql', 'utf8');
  const migration16 = fs.readFileSync('supabase/migrations/20251116000016_seed_base_templates.sql', 'utf8');

  try {
    console.log('1️⃣ Creating lunar_guide_templates table...');
    await executeSql(migration15);

    console.log('\n2️⃣ Seeding base templates...');
    await executeSql(migration16);

    console.log('\n✅ All migrations completed successfully!');
    console.log('\nRun this to verify:');
    console.log('SELECT COUNT(*) FROM lunar_guide_templates;');
  } catch (error) {
    console.error('\n❌ Migration failed:', error.message);
    process.exit(1);
  }
}

runMigrations();
