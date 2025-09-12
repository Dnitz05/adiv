import type { NextRequest } from 'next/server';
import { NextResponse } from 'next/server';

export default async function handler(req: NextRequest) {
  return NextResponse.json({ 
    message: 'minimal API working', 
    timestamp: new Date().toISOString() 
  }, { status: 200 });
}

export const runtime = 'edge';