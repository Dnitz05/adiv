export const runtime = 'edge';
// Temporary delegation to legacy handler during migration
export default async function handler(req: Request): Promise<Response> {
  if (req.method === 'OPTIONS') {
    return new Response(null, { status: 204 });
  }
  if (req.method !== 'POST') {
    return new Response(
      JSON.stringify({
        success: false,
        error: {
          code: 'METHOD_NOT_ALLOWED',
          message: 'Only POST method is allowed for chat/interpret',
          timestamp: new Date().toISOString(),
        },
      }),
      { status: 405, headers: { 'content-type': 'application/json' } }
    );
  }

  const body = {
    success: false,
    error: {
      code: 'MIGRATION_IN_PROGRESS',
      message: 'Endpoint migrating to canonical backend',
      timestamp: new Date().toISOString(),
    },
  };
  return new Response(JSON.stringify(body), {
    status: 501,
    headers: { 'content-type': 'application/json' },
  });
}
