import type { NextRequest } from 'next/server';
import { NextResponse } from 'next/server';
import { getAllEndpointSummaries } from '../../lib/utils/metrics';

export default async function handler(_req: NextRequest): Promise<Response> {
  const expose = process.env.METRICS_EXPOSE === 'true' || process.env.NODE_ENV !== 'production';
  if (!expose) {
    return NextResponse.json({ error: 'Forbidden' }, { status: 403 });
  }

  const summaries = getAllEndpointSummaries();
  return NextResponse.json(
    {
      success: true,
      data: { endpoints: summaries },
      meta: { generatedAt: new Date().toISOString() },
    },
    { status: 200 }
  );
}

export const runtime = 'edge';

