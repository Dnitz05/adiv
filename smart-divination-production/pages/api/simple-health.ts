/**
 * Simple Health Check - No dependencies, pure Next.js
 */
import type { NextRequest } from 'next/server';
import { NextResponse } from 'next/server';
import { recordApiMetric } from '../../lib/utils/metrics';

export default async function handler(req: NextRequest): Promise<Response> {
  const start = Date.now();
  if (req.method !== 'GET') {
    const resp405 = NextResponse.json({ error: 'Method not allowed' }, { status: 405 });
    recordApiMetric('/api/simple-health', 405, Date.now() - start);
    return resp405;
  }

  const resp200 = NextResponse.json(
    {
      status: 'healthy',
      timestamp: new Date().toISOString(),
      message: 'Smart Divination Backend is operational',
      environment: {
        nodeEnv: process.env.NODE_ENV || 'unknown',
        hasSupabaseUrl: !!process.env.SUPABASE_URL,
        hasSupabaseKey: !!process.env.SUPABASE_SERVICE_ROLE_KEY,
        hasDeepseekKey: !!process.env.DEEPSEEK_API_KEY,
        hasRandomKey: !!process.env.RANDOM_API_KEY,
      },
    },
    {
      status: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
      },
    }
  );
  recordApiMetric('/api/simple-health', 200, Date.now() - start);
  return resp200;
}

export const runtime = 'edge';
