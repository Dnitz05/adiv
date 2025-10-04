import { recordApiMetric, getAllEndpointSummaries } from '../lib/utils/metrics';

describe('Metrics sanity (canonical)', () => {
  it('collects and summarizes basic metrics', async () => {
    recordApiMetric('/api/health', 200, 20);
    recordApiMetric('/api/health', 200, 30);
    recordApiMetric('/api/health', 503, 60);
    recordApiMetric('/api/sessions', 405, 5);

    const summaries = getAllEndpointSummaries();
    const health = summaries.find((s) => s.endpoint === '/api/health');
    const sessions = summaries.find((s) => s.endpoint === '/api/sessions');
    expect(health).toBeTruthy();
    expect(sessions).toBeTruthy();
    if (health) {
      expect(health.p95).toBeGreaterThan(0);
      expect(health.count).toBeGreaterThanOrEqual(3);
    }
  });
});

