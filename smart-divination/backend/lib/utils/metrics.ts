/**
 * Lightweight in-memory metrics for latency and error rates.
 *
 * Note: In production, prefer an external provider (Datadog/New Relic/Grafana).
 * This module serves as a robust fallback and for local observability.
 */

type EndpointKey = string;

type EndpointStore = {
  durations: number[]; // recent durations (ms)
  statuses: Record<number, number>; // status code -> count
  hits: number[]; // timestamps (ms) for RPS calculation (last 60s)
};

const MAX_SAMPLES = 1000;
const WINDOW_MS = 60_000; // 1 minute window for RPS

const store: Map<EndpointKey, EndpointStore> = new Map();
const METRICS_DEBUG = process.env.METRICS_DEBUG === 'true';

// ----------------------------------------------------------------------------
// Optional external provider (no-op by default)
// ----------------------------------------------------------------------------

type MetricEvent = {
  endpoint: string;
  status: number;
  durationMs: number;
  ts: number;
};

interface MetricsProvider {
  send(event: MetricEvent): Promise<void>;
}

class NoopProvider implements MetricsProvider {
  // eslint-disable-next-line @typescript-eslint/require-await
  async send(_event: MetricEvent): Promise<void> {
    // no-op
  }
}

class ConsoleProvider implements MetricsProvider {
  // eslint-disable-next-line @typescript-eslint/require-await
  async send(event: MetricEvent): Promise<void> {
    // Keep it terse to avoid noise
    // eslint-disable-next-line no-console
    console.info(
      JSON.stringify({ t: 'metric', ep: event.endpoint, s: event.status, d: event.durationMs })
    );
  }
}

type DatadogProviderOptions = {
  apiKey: string;
  site?: string;
  service?: string;
  env?: string;
  metricPrefix?: string;
  defaultTags?: string[];
  timeoutMs?: number;
};

async function getFetchImpl(): Promise<typeof fetch> {
  // Use native fetch if available (Node 18+)
  if (typeof fetch === 'function') {
    return fetch;
  }

  // Fallback to node-fetch for older Node versions
  // Note: This won't work in browser/edge environments due to bundler limitations
  if (METRICS_DEBUG) {
    // eslint-disable-next-line no-console
    console.warn('metrics: native fetch not available, metrics will be disabled');
  }
  throw new Error('Fetch not available');
}

class DatadogProvider implements MetricsProvider {
  private readonly apiKey: string;

  private readonly site: string;

  private readonly service?: string;

  private readonly env?: string;

  private readonly metricPrefix: string;

  private readonly defaultTags: string[];

  private readonly timeoutMs: number;

  constructor(options: DatadogProviderOptions) {
    this.apiKey = options.apiKey;
    this.site = options.site ?? 'datadoghq.com';
    this.service = options.service;
    this.env = options.env;
    this.metricPrefix = options.metricPrefix ?? 'smart_divination';
    this.defaultTags = options.defaultTags ?? [];
    this.timeoutMs = options.timeoutMs ?? 2000;
  }

  private buildTags(event: MetricEvent): string[] {
    const statusGroup =
      event.status >= 500
        ? '5xx'
        : event.status >= 400
          ? '4xx'
          : event.status >= 300
            ? '3xx'
            : '2xx';
    const tagSet = new Set<string>([
      ...this.defaultTags,
      `endpoint:${event.endpoint}`,
      `status:${event.status}`,
      `status_group:${statusGroup}`,
    ]);
    if (this.service) tagSet.add(`service:${this.service}`);
    if (this.env) tagSet.add(`env:${this.env}`);
    return Array.from(tagSet);
  }

  async send(event: MetricEvent): Promise<void> {
    try {
      const fetchFn = await getFetchImpl();
      const url = `https://api.${this.site}/api/v2/series`;
      const tags = this.buildTags(event);
      const tsSeconds = Math.floor(event.ts / 1000);
      const payload = {
        series: [
          {
            metric: `${this.metricPrefix}.api.latency_ms`,
            type: 3, // gauge
            points: [[tsSeconds, event.durationMs]],
            tags,
          },
          {
            metric: `${this.metricPrefix}.api.requests`,
            type: 1, // count
            points: [[tsSeconds, 1]],
            tags,
          },
        ],
      };

      const controller = new AbortController();
      const timeout = setTimeout(() => controller.abort(), this.timeoutMs);
      try {
        const response = await fetchFn(url, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'DD-API-KEY': this.apiKey,
          },
          body: JSON.stringify(payload),
          signal: controller.signal,
        });
        if (!response.ok && METRICS_DEBUG) {
          // eslint-disable-next-line no-console
          console.warn('metrics: datadog response not ok', response.status, response.statusText);
        }
      } finally {
        clearTimeout(timeout);
      }
    } catch (error) {
      if (METRICS_DEBUG) {
        // eslint-disable-next-line no-console
        console.warn('metrics: failed to send metric to Datadog', error);
      }
    }
  }
}

function parseTags(value?: string): string[] {
  if (!value) return [];
  return value
    .split(',')
    .map((tag) => tag.trim())
    .filter((tag) => tag.length > 0);
}

function resolveProviderFromEnv(): MetricsProvider {
  const provider = (process.env.METRICS_PROVIDER || '').trim().toLowerCase();
  if (provider === 'console') {
    return new ConsoleProvider();
  }
  if (provider === 'datadog') {
    const apiKey = process.env.DATADOG_API_KEY;
    if (!apiKey) {
      if (METRICS_DEBUG) {
        // eslint-disable-next-line no-console
        console.warn('metrics: DATADOG_API_KEY missing, falling back to noop');
      }
      return new NoopProvider();
    }
    return new DatadogProvider({
      apiKey,
      site: process.env.DATADOG_SITE || 'datadoghq.com',
      service: process.env.DATADOG_SERVICE,
      env: process.env.DATADOG_ENV,
      metricPrefix: process.env.DATADOG_METRIC_PREFIX || 'smart_divination',
      defaultTags: parseTags(process.env.DATADOG_TAGS),
      timeoutMs: process.env.DATADOG_TIMEOUT_MS ? Number(process.env.DATADOG_TIMEOUT_MS) : undefined,
    });
  }
  return new NoopProvider();
}

let activeProvider: MetricsProvider = resolveProviderFromEnv();

export function getMetricsProvider(): MetricsProvider {
  return activeProvider;
}

export function configureMetricsProvider(provider?: MetricsProvider): void {
  activeProvider = provider ?? resolveProviderFromEnv();
}

function getOrCreate(key: EndpointKey): EndpointStore {
  let s = store.get(key);
  if (!s) {
    s = { durations: [], statuses: {}, hits: [] };
    store.set(key, s);
  }
  return s;
}

export function recordApiMetric(endpoint: string, status: number, durationMs: number): void {
  const now = Date.now();
  const s = getOrCreate(endpoint);

  // durations (ring buffer)
  s.durations.push(durationMs);
  if (s.durations.length > MAX_SAMPLES) s.durations.shift();

  // statuses
  s.statuses[status] = (s.statuses[status] || 0) + 1;

  // hits for RPS (rolling window)
  s.hits.push(now);
  // prune old hits
  const cutoff = now - WINDOW_MS;
  while (s.hits.length && s.hits[0] < cutoff) s.hits.shift();

  // fire-and-forget provider emission (non-blocking)
  const evt: MetricEvent = { endpoint, status, durationMs, ts: now };
  void getMetricsProvider().send(evt).catch(() => undefined);
}

function percentile(sortedValues: number[], p: number): number {
  if (sortedValues.length === 0) return 0;
  const idx = Math.min(
    sortedValues.length - 1,
    Math.max(0, Math.floor((p / 100) * (sortedValues.length - 1)))
  );
  return sortedValues[idx];
}

function summarizeEndpoint(key: EndpointKey, s: EndpointStore) {
  const durations = [...s.durations].sort((a, b) => a - b);
  const p50 = percentile(durations, 50);
  const p95 = percentile(durations, 95);
  const avg = durations.length
    ? Math.round((durations.reduce((acc, v) => acc + v, 0) / durations.length) * 100) / 100
    : 0;
  const total = Object.values(s.statuses).reduce((a, v) => a + v, 0);
  const errors = Object.entries(s.statuses)
    .filter(([code]) => Number(code) >= 400)
    .reduce((a, [, v]) => a + v, 0);
  const errorRate = total ? Math.round((errors / total) * 10000) / 100 : 0; // % with 2 decimals
  const rps = Math.round((s.hits.length / (WINDOW_MS / 1000)) * 100) / 100; // requests per second in last minute
  return { endpoint: key, p50, p95, avg, errorRate, rps, count: total };
}

export function getAllEndpointSummaries() {
  const out: Array<ReturnType<typeof summarizeEndpoint>> = [];
  for (const [key, s] of store.entries()) out.push(summarizeEndpoint(key, s));
  return out;
}

export function getOverallMetrics() {
  const summaries = getAllEndpointSummaries();
  if (summaries.length === 0) {
    return {
      requestsPerMinute: 0,
      averageResponseTime: 0,
      errorRate: 0,
      memoryUsage: 64,
    };
  }

  const totalCount = summaries.reduce((a, s) => a + s.count, 0) || 1;
  const weightedAvg = summaries.reduce((a, s) => a + s.avg * s.count, 0) / totalCount;
  const weightedError =
    summaries.reduce((a, s) => a + (s.errorRate / 100) * s.count, 0) / totalCount;
  const totalRps = summaries.reduce((a, s) => a + s.rps, 0);

  return {
    requestsPerMinute: Math.round(totalRps * 60),
    averageResponseTime: Math.round(weightedAvg * 100) / 100,
    errorRate: Math.round(weightedError * 10000) / 100, // %
    memoryUsage: 64, // Edge-safe placeholder
  };
}
