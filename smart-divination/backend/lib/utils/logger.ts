import type { ApiError, LogLevel } from '../types/api';

export function log(level: LogLevel, message: string, ctx?: Record<string, unknown>): void {
  const entry = {
    level,
    message,
    timestamp: new Date().toISOString(),
    ...(ctx ? { ctx } : {}),
  };
  const line = JSON.stringify(entry);

  if (level === 'error' || level === 'fatal') {
    console.error(line);
  } else if (level === 'warn') {
    console.warn(line);
  } else {
    console.log(line);
  }
}

export const logInfo = (message: string, ctx?: Record<string, unknown>): void =>
  log('info', message, ctx);

export const logWarn = (message: string, ctx?: Record<string, unknown>): void =>
  log('warn', message, ctx);

export const logDebug = (message: string, ctx?: Record<string, unknown>): void =>
  log('debug', message, ctx);

export function logError(error: ApiError, statusCode: number): void {
  log('error', 'API Error', {
    requestId: error.requestId,
    code: error.code,
    details: error.details,
    statusCode,
  });
}
