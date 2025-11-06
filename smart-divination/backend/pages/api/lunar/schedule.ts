import type { NextApiRequest, NextApiResponse } from 'next';
import { z } from 'zod';

import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
  sendJsonError,
} from '../../../lib/utils/nextApi';
import {
  baseRequestSchema,
  createApiError,
  createApiResponse,
  createRequestId,
  handleApiError,
  parseApiRequest,
} from '../../../lib/utils/api';
import {
  deleteLunarReminder,
  fetchLunarReminders,
  insertLunarReminder,
  updateLunarReminder,
} from '../../../lib/utils/supabase';
import type { LunarReminderPayload } from '../../../lib/types/api';

const reminderCreateSchema = baseRequestSchema.extend({
  date: z.string().min(1, 'date is required'),
  time: z
    .string()
    .regex(/^\d{2}:\d{2}$/, 'time must be HH:MM')
    .optional()
    .or(z.null()),
  topic: z
    .enum(['intentions', 'projects', 'relationships', 'wellbeing', 'creativity'])
    .default('intentions'),
  intention: z.string().trim().max(160).optional(),
});

const reminderUpdateSchema = baseRequestSchema.extend({
  id: z.string().min(1, 'id is required'),
  date: z.string().optional(),
  time: z
    .string()
    .regex(/^\d{2}:\d{2}$/, 'time must be HH:MM')
    .optional()
    .or(z.null()),
  topic: z.enum(['intentions', 'projects', 'relationships', 'wellbeing', 'creativity']).optional(),
  intention: z.string().trim().max(160).optional().or(z.null()),
  locale: z.string().optional(),
});

const reminderListSchema = baseRequestSchema.extend({
  limit: z.coerce.number().int().min(1).max(100).default(20),
  from: z.string().optional(),
  to: z.string().optional(),
  locale: z.string().optional(),
});

type ReminderCreateBody = z.infer<typeof reminderCreateSchema>;
type ReminderUpdateBody = z.infer<typeof reminderUpdateSchema>;
type ReminderListQuery = z.infer<typeof reminderListSchema>;

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse,
) {
  const requestId = createRequestId();

  applyCorsHeaders(res);
  applyStandardResponseHeaders(res);

  if (req.method === 'OPTIONS') {
    return handleCorsPreflight(req, res);
  }

  try {
    switch (req.method) {
      case 'GET':
        return await handleList(req, res, requestId);
      case 'POST':
        return await handleCreate(req, res, requestId);
      case 'PATCH':
        return await handleUpdate(req, res, requestId);
      case 'DELETE':
        return await handleDelete(req, res, requestId);
      default:
        return sendJsonError(res, 405, {
          code: 'METHOD_NOT_ALLOWED',
          message: 'Method not allowed',
          requestId,
          details: { allowedMethods: ['GET', 'POST', 'PATCH', 'DELETE'] },
        });
    }
  } catch (error) {
    return handleApiError(res, error, requestId);
  }
}

async function handleCreate(
  req: NextApiRequest,
  res: NextApiResponse,
  requestId: string,
) {
  const { data: body, auth } = await parseApiRequest<ReminderCreateBody>(
    req,
    reminderCreateSchema,
  );

  const userId = (auth?.userId ?? body.userId ?? '').trim();
  if (!userId) {
    return sendJsonError(res, 401, {
      code: 'UNAUTHENTICATED',
      message: 'User authentication required',
      requestId,
    });
  }

  const reminder = await insertLunarReminder({
    userId,
    date: body.date,
    time: body.time ?? null,
    topic: body.topic,
    intention: body.intention,
    locale: body.locale ?? auth?.locale ?? 'en',
    requestId,
  });

  if (!reminder) {
    throw createApiError('REMINDER_CREATE_FAILED', 'Failed to create reminder', 500, undefined, requestId);
  }

  return res.status(201).json(
    createApiResponse<{ reminder: LunarReminderPayload }>(
      { reminder },
      { processingTimeMs: 0 },
      requestId,
    ),
  );
}

async function handleList(
  req: NextApiRequest,
  res: NextApiResponse,
  requestId: string,
) {
  const { data: query, auth } = await parseApiRequest<ReminderListQuery>(
    req,
    reminderListSchema,
  );

  const userId = (auth?.userId ?? query.userId ?? '').trim();
  if (!userId) {
    return sendJsonError(res, 401, {
      code: 'UNAUTHENTICATED',
      message: 'User authentication required',
      requestId,
    });
  }

  const reminders = await fetchLunarReminders(userId, {
    from: query.from,
    to: query.to,
    locale: query.locale ?? auth?.locale,
    limit: query.limit,
  });

  return res.status(200).json(
    createApiResponse<{ reminders: LunarReminderPayload[] }>(
      { reminders },
      { processingTimeMs: 0 },
      requestId,
    ),
  );
}

async function handleUpdate(
  req: NextApiRequest,
  res: NextApiResponse,
  requestId: string,
) {
  const { data: body, auth } = await parseApiRequest<ReminderUpdateBody>(
    req,
    reminderUpdateSchema,
  );

  const userId = (auth?.userId ?? body.userId ?? '').trim();
  if (!userId) {
    return sendJsonError(res, 401, {
      code: 'UNAUTHENTICATED',
      message: 'User authentication required',
      requestId,
    });
  }

  const reminder = await updateLunarReminder({
    id: body.id,
    userId,
    date: body.date,
    time: body.time ?? undefined,
    topic: body.topic,
    intention: body.intention,
    locale: body.locale,
    requestId,
  });

  if (!reminder) {
    throw createApiError('REMINDER_UPDATE_FAILED', 'Failed to update reminder', 500, undefined, requestId);
  }

  return res.status(200).json(
    createApiResponse<{ reminder: LunarReminderPayload }>(
      { reminder },
      { processingTimeMs: 0 },
      requestId,
    ),
  );
}

async function handleDelete(
  req: NextApiRequest,
  res: NextApiResponse,
  requestId: string,
) {
  const { data: body, auth } = await parseApiRequest<{ id: string }>(
    req,
    baseRequestSchema.extend({
      id: z.string().min(1, 'id is required'),
    }),
  );

  const userId = (auth?.userId ?? body.userId ?? '').trim();
  if (!userId) {
    return sendJsonError(res, 401, {
      code: 'UNAUTHENTICATED',
      message: 'User authentication required',
      requestId,
    });
  }

  const success = await deleteLunarReminder(body.id, userId, requestId);
  if (!success) {
    throw createApiError('REMINDER_DELETE_FAILED', 'Failed to delete reminder', 500, undefined, requestId);
  }

  return res.status(200).json(
    createApiResponse<{ ok: boolean }>(
      { ok: true },
      { processingTimeMs: 0 },
      requestId,
    ),
  );
}
