/**
 * Debug endpoint - minimal functionality to test deployment
 */
import type { NextRequest } from 'next/server';
import { NextResponse } from 'next/server';

export default async function handler(req: NextRequest) {
  try {
    return NextResponse.json({
      success: true,
      message: 'Backend is working!',
      timestamp: new Date().toISOString(),
      method: req.method,
      url: req.url,
      environment_check: {
        SUPABASE_URL: process.env.SUPABASE_URL ? 'SET' : 'MISSING',
        SUPABASE_SERVICE_ROLE_KEY: process.env.SUPABASE_SERVICE_ROLE_KEY ? 'SET' : 'MISSING',
        DEEPSEEK_API_KEY: process.env.DEEPSEEK_API_KEY ? 'SET' : 'MISSING',
        RANDOM_API_KEY: process.env.RANDOM_API_KEY ? 'SET' : 'MISSING',
        NODE_ENV: process.env.NODE_ENV || 'unknown'
      }
    }, { status: 200 });
  } catch (error) {
    return NextResponse.json({
      success: false,
      error: error instanceof Error ? error.message : String(error),
      timestamp: new Date().toISOString()
    }, { status: 500 });
  }
}

export const runtime = 'edge';