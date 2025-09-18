import type { NextRequest } from 'next/server';
import { NextResponse } from 'next/server';

// Leverage resolveJsonModule to import the static spec
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import baseSpec from '../../openapi/openapi.json';
import addendum from '../../openapi/addendum.json';

type OpenApiDoc = {
  openapi: string;
  info: unknown;
  servers?: unknown[];
  tags?: unknown[];
  paths: Record<string, unknown>;
  components?: { schemas?: Record<string, unknown> };
};

export default async function handler(_req: NextRequest): Promise<Response> {
  const base = baseSpec as OpenApiDoc;
  const extra = addendum as Partial<OpenApiDoc>;
  const mergedPaths: Record<string, unknown> = {
    ...(base.paths || {}),
    ...((extra.paths as unknown as Record<string, unknown>) || {}),
  };
  const mergedSchemas: Record<string, unknown> = {
    ...((base.components?.schemas as unknown as Record<string, unknown>) || {}),
    ...(((extra.components || {}).schemas as unknown as Record<string, unknown>) || {}),
  };
  const merged: OpenApiDoc = {
    ...(base as OpenApiDoc),
    paths: mergedPaths,
    components: { ...(base.components || {}), schemas: mergedSchemas },
  };
  return NextResponse.json(merged as unknown as object, { status: 200 });
}
export const runtime = 'edge';
