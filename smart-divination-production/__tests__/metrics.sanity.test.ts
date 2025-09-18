import { recordApiMetric, getAllEndpointSummaries } from '../lib/utils/metrics';

describe('Metrics sanity', () => {
  it('collects and summarizes basic metrics', async () => {
    // Simulate a few calls
    recordApiMetric('/api/health', 200, 25);
    recordApiMetric('/api/health', 200, 30);
    recordApiMetric('/api/health', 503, 55);
    recordApiMetric('/api/sessions', 405, 2);

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

