import type { NextRequest } from 'next/server';
import { NextResponse } from 'next/server';

export default async function handler(req: NextRequest): Promise<Response> {
  if (req.method === 'GET') {
    return NextResponse.json(
      {
        success: true,
        message: 'Smart Tarot API is working!',
        timestamp: new Date().toISOString(),
        method: req.method,
        url: req.url,
      },
      { status: 200 }
    );
  }

  if (req.method === 'POST') {
    const body = await req.json().catch(() => ({}));
    return NextResponse.json(
      {
        success: true,
        message: 'POST endpoint working!',
        data: body,
        timestamp: new Date().toISOString(),
      },
      { status: 200 }
    );
  }

  return NextResponse.json(
    { error: 'Method not allowed' },
    {
      status: 405,
      headers: { Allow: 'GET, POST' },
    }
  );
}

export const runtime = 'edge';
