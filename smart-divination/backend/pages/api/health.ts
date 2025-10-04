/**
 * Health Check Endpoint - System Status Monitoring
 *
 * Provides comprehensive health status for all system components
 * including Random.org, Supabase, and internal services.
 */

import type { NextApiRequest, NextApiResponse } from 'next';
import { createApiResponse, handleApiError, log, createRequestId } from '../../lib/utils/api';
import {
  applyCorsHeaders,
  applyStandardResponseHeaders,
  handleCorsPreflight,
  sendJsonError,
} from '../../lib/utils/nextApi';
import { checkSupabaseHealth } from '../../lib/utils/supabase';
import { checkRandomOrgHealth } from '../../lib/utils/randomness';
import { recordApiMetric } from '../../lib/utils/metrics';
import type { HealthStatus, ServiceStatus, SystemMetrics, UptimeInfo } from '../../lib/types/api';
const METRICS_PATH = '/api/health';
const ALLOW_HEADER_VALUE = 'OPTIONS, GET';

// Track server start time
const serverStartTime = new Date();

// =============================================================================
// HEALTH CHECK HANDLER
// =============================================================================

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const startedAt = Date.now();
  const requestId = createRequestId();

  const corsConfig = { methods: 'GET,OPTIONS' } as const;
  applyCorsHeaders(res, corsConfig);
  applyStandardResponseHeaders(res);

  if (handleCorsPreflight(req, res, corsConfig)) {
    recordApiMetric(METRICS_PATH, 204, Date.now() - startedAt);
    return;
  }

  if (req.method !== 'GET') {
    res.setHeader('Allow', ALLOW_HEADER_VALUE);
    sendJsonError(res, 405, {
      code: 'METHOD_NOT_ALLOWED',
      message: 'Only GET method is allowed for health check',
      requestId,
    });
    recordApiMetric(METRICS_PATH, 405, Date.now() - startedAt);
    return;
  }

  try {
    log('info', 'Health check requested', {
      requestId,
      method: req.method,
      url: req.url,
      userAgent: req.headers['user-agent'],
    });

    const [supabaseHealth, randomOrgHealth, systemMetrics] = await Promise.allSettled([
      checkSupabaseHealth(),
      checkRandomOrgHealth(),
      getSystemMetrics(),
    ]);

    const services: ServiceStatus[] = [
      {
        name: 'supabase',
        status:
          supabaseHealth.status === 'fulfilled' && supabaseHealth.value.status === 'healthy'
            ? 'healthy'
            : 'unhealthy',
        responseTime:
          supabaseHealth.status === 'fulfilled' ? supabaseHealth.value.responseTime : undefined,
        lastCheck: new Date().toISOString(),
        error:
          supabaseHealth.status === 'rejected'
            ? supabaseHealth.reason instanceof Error
              ? supabaseHealth.reason.message
              : String(supabaseHealth.reason)
            : supabaseHealth.status === 'fulfilled'
              ? supabaseHealth.value.error
              : undefined,
      },
      {
        name: 'random_org',
        status:
          randomOrgHealth.status === 'fulfilled' && randomOrgHealth.value.status === 'healthy'
            ? 'healthy'
            : 'degraded',
        responseTime:
          randomOrgHealth.status === 'fulfilled' ? randomOrgHealth.value.responseTime : undefined,
        lastCheck: new Date().toISOString(),
        error:
          randomOrgHealth.status === 'rejected'
            ? randomOrgHealth.reason instanceof Error
              ? randomOrgHealth.reason.message
              : String(randomOrgHealth.reason)
            : randomOrgHealth.status === 'fulfilled'
              ? randomOrgHealth.value.error
              : undefined,
      },
    ];

    const criticalServicesHealthy = services
      .filter((service) => service.name === 'supabase')
      .every((service) => service.status === 'healthy');

    const allServicesHealthy = services.every((service) => service.status === 'healthy');

    const overallStatus: 'healthy' | 'degraded' | 'unhealthy' = !criticalServicesHealthy
      ? 'unhealthy'
      : !allServicesHealthy
        ? 'degraded'
        : 'healthy';

    const metrics =
      systemMetrics.status === 'fulfilled' ? systemMetrics.value : getDefaultMetrics();

    const healthStatus: HealthStatus = {
      status: overallStatus,
      services,
      metrics,
      uptime: getUptimeInfo(),
    };

    const duration = Date.now() - startedAt;
    const apiResponse = createApiResponse(healthStatus, { processingTimeMs: duration, requestId });
    const httpStatus = overallStatus === 'unhealthy' ? 503 : 200;

    res.status(httpStatus).json(apiResponse);
    recordApiMetric(METRICS_PATH, httpStatus, duration);
  } catch (error) {
    handleApiError(res, error, requestId);
    recordApiMetric(METRICS_PATH, res.statusCode || 500, Date.now() - startedAt);
  }
}

// =============================================================================
// HELPER FUNCTIONS
// =============================================================================

/**
 * Get system metrics
 */
async function getSystemMetrics(): Promise<SystemMetrics> {
  // In a real implementation, these would come from monitoring systems
  // For now, we'll provide mock data

  const memoryUsage = process.memoryUsage();

  return {
    requestsPerMinute: 0, // Would be tracked by monitoring
    averageResponseTime: 0, // Would be calculated from recent requests
    errorRate: 0, // Would be calculated from error logs
    memoryUsage: Math.round(memoryUsage.rss / 1024 / 1024), // Convert to MB
  };
}

/**
 * Get default metrics when monitoring is unavailable
 */
function getDefaultMetrics(): SystemMetrics {
  const memoryUsage = process.memoryUsage();

  return {
    requestsPerMinute: 0,
    averageResponseTime: 0,
    errorRate: 0,
    memoryUsage: Math.round(memoryUsage.rss / 1024 / 1024),
  };
}

/**
 * Get uptime information
 */
function getUptimeInfo(): UptimeInfo {
  const now = new Date();
  const uptimeMs = now.getTime() - serverStartTime.getTime();
  const uptimeSeconds = Math.floor(uptimeMs / 1000);

  // Calculate uptime percentage (assuming 99.9% for demonstration)
  // In a real system, this would be calculated from historical data
  const uptimePercentage = 99.9;

  return {
    startTime: serverStartTime.toISOString(),
    uptimeSeconds,
    uptimePercentage,
  };
}

// =============================================================================
// RUNTIME CONFIGURATION
// =============================================================================

export const runtime = 'nodejs';
export const preferredRegion = 'auto';
