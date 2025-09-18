/**
 * Health Check Endpoint - System Status Monitoring
 *
 * Provides comprehensive health status for all system components
 * including Random.org, Supabase, and internal services.
 */

import type { NextRequest } from 'next/server';
import {
  sendApiResponse,
  createApiResponse,
  handleApiError,
  handleCors,
  addStandardHeaders,
  log,
} from '../../lib/utils/api';
import { checkSupabaseHealth } from '../../lib/utils/supabase';
import { getOverallMetrics, recordApiMetric } from '../../lib/utils/metrics';
import { checkRandomOrgHealth } from '../../lib/utils/randomness';
import type { HealthStatus, ServiceStatus, SystemMetrics, UptimeInfo } from '../../lib/types/api';

// Track server start time
const serverStartTime = new Date();

// =============================================================================
// HEALTH CHECK HANDLER
// =============================================================================

export default async function handler(req: NextRequest): Promise<Response> {
  const startTime = Date.now();

  try {
    // Handle CORS
    const corsResponse = handleCors(req);
    if (corsResponse) return corsResponse;

    // Only allow GET requests
    if (req.method !== 'GET') {
      return sendApiResponse(
        {
          success: false,
          error: {
            code: 'METHOD_NOT_ALLOWED',
            message: 'Only GET method is allowed for health check',
            timestamp: new Date().toISOString(),
          },
        },
        405
      );
    }

    log('info', 'Health check requested', {
      method: req.method,
      url: req.url,
      userAgent: req.headers['user-agent'],
    });

    // Run all health checks in parallel
    const [supabaseHealth, randomOrgHealth, systemMetrics] = await Promise.allSettled([
      checkSupabaseHealth(),
      checkRandomOrgHealth(),
      getSystemMetrics(),
    ]);

    // Build service status array
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
            ? supabaseHealth.reason?.message
            : supabaseHealth.status === 'fulfilled' && supabaseHealth.value.error
              ? supabaseHealth.value.error
              : undefined,
      },
      {
        name: 'random_org',
        status:
          randomOrgHealth.status === 'fulfilled' && randomOrgHealth.value.status === 'healthy'
            ? 'healthy'
            : 'degraded', // Random.org failure is not critical (we have fallbacks)
        responseTime:
          randomOrgHealth.status === 'fulfilled' ? randomOrgHealth.value.responseTime : undefined,
        lastCheck: new Date().toISOString(),
        error:
          randomOrgHealth.status === 'rejected'
            ? randomOrgHealth.reason?.message
            : randomOrgHealth.status === 'fulfilled' && randomOrgHealth.value.error
              ? randomOrgHealth.value.error
              : undefined,
      },
    ];

    // Determine overall system status
    const criticalServicesHealthy = services
      .filter((s) => s.name === 'supabase') // Only Supabase is critical
      .every((s) => s.status === 'healthy');

    const allServicesHealthy = services.every((s) => s.status === 'healthy');

    const overallStatus: 'healthy' | 'degraded' | 'unhealthy' = !criticalServicesHealthy
      ? 'unhealthy'
      : !allServicesHealthy
        ? 'degraded'
        : 'healthy';

    // Get system metrics
    const metrics =
      systemMetrics.status === 'fulfilled' ? systemMetrics.value : getDefaultMetrics();

    // Build health status
    const healthStatus: HealthStatus = {
      status: overallStatus,
      services,
      metrics,
      uptime: getUptimeInfo(),
    };

    const processingTime = Date.now() - startTime;

    // Create response
    const response = createApiResponse(healthStatus, {
      processingTimeMs: processingTime,
    });

    // Log health check result
    log('info', 'Health check completed', {
      status: overallStatus,
      processingTimeMs: processingTime,
      servicesChecked: services.length,
    });

    // Send response with appropriate status code
    const httpStatus = overallStatus === 'healthy' ? 200 : overallStatus === 'degraded' ? 200 : 503;

    const nextResponse = sendApiResponse(response, httpStatus);
    addStandardHeaders(nextResponse);
    // Record metrics
    recordApiMetric('/api/health', httpStatus, processingTime);

    return nextResponse;
  } catch (error) {
    log('error', 'Health check failed', {
      error: error instanceof Error ? error.message : String(error),
    });

    return handleApiError(error);
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
  // We aggregate local metrics as a robust fallback
  const m = getOverallMetrics();
  return {
    requestsPerMinute: m.requestsPerMinute,
    averageResponseTime: m.averageResponseTime,
    errorRate: m.errorRate,
    memoryUsage: m.memoryUsage,
  };
}

/**
 * Get default metrics when monitoring is unavailable
 */
function getDefaultMetrics(): SystemMetrics {
  // Edge Runtime compatible - no process.memoryUsage() available

  return {
    requestsPerMinute: 0,
    averageResponseTime: 0,
    errorRate: 0,
    memoryUsage: 64, // Mock value for Edge Runtime compatibility (MB)
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
// EDGE FUNCTION CONFIGURATION
// =============================================================================

export const runtime = 'edge';
export const preferredRegion = 'auto';
