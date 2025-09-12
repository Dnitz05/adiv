import { useState } from 'react';
import Head from 'next/head';

interface TestResult {
  endpoint: string;
  method: string;
  success: boolean;
  response?: any;
  error?: string;
  timestamp: string;
}

export default function Testing() {
  const [testResults, setTestResults] = useState<TestResult[]>([]);
  const [testing, setTesting] = useState(false);

  const testEndpoints = [
    { name: 'Health Check', endpoint: '/api/test', method: 'GET' },
    { name: 'POST Test', endpoint: '/api/test', method: 'POST', body: { test: 'data' } }
  ];

  const runTest = async (endpoint: string, method: string, body?: any) => {
    try {
      const options: RequestInit = {
        method,
        headers: { 'Content-Type': 'application/json' },
        ...(body && { body: JSON.stringify(body) })
      };

      const response = await fetch(endpoint, options);
      const data = await response.json();

      return {
        endpoint,
        method,
        success: response.ok,
        response: data,
        timestamp: new Date().toISOString()
      };
    } catch (error) {
      return {
        endpoint,
        method,
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
        timestamp: new Date().toISOString()
      };
    }
  };

  const runAllTests = async () => {
    setTesting(true);
    setTestResults([]);

    for (const test of testEndpoints) {
      const result = await runTest(test.endpoint, test.method, test.body);
      setTestResults(prev => [...prev, result]);
      // Small delay between tests
      await new Promise(resolve => setTimeout(resolve, 500));
    }

    setTesting(false);
  };

  return (
    <div style={{
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #1e293b 0%, #334155 100%)',
      color: 'white',
      fontFamily: '"JetBrains Mono", monospace, sans-serif',
      padding: '20px'
    }}>
      <Head>
        <title>Smart Tarot - API Testing</title>
      </Head>

      <div style={{ maxWidth: '1400px', margin: '0 auto' }}>
        <div style={{ marginBottom: '30px', textAlign: 'center' }}>
          <h1 style={{ fontSize: '2.5rem', marginBottom: '10px' }}>
            🧪 Smart Tarot API Testing
          </h1>
          <p style={{ opacity: 0.8, fontSize: '1.1rem' }}>
            Testing Suite for Backend Endpoints
          </p>
        </div>

        <div style={{
          background: 'rgba(255,255,255,0.05)',
          borderRadius: '12px',
          padding: '20px',
          marginBottom: '30px',
          border: '1px solid rgba(255,255,255,0.1)'
        }}>
          <button
            onClick={runAllTests}
            disabled={testing}
            style={{
              background: testing ? '#64748b' : '#10b981',
              color: 'white',
              border: 'none',
              borderRadius: '8px',
              padding: '12px 24px',
              fontSize: '1rem',
              cursor: testing ? 'not-allowed' : 'pointer',
              transition: 'all 0.3s ease'
            }}
          >
            {testing ? '🔄 Running Tests...' : '▶️ Run All Tests'}
          </button>
          
          <div style={{ marginTop: '15px', fontSize: '0.9rem', opacity: 0.7 }}>
            Available Endpoints: {testEndpoints.length} | 
            Server: localhost:3000
          </div>
        </div>

        {testResults.length > 0 && (
          <div style={{
            background: 'rgba(255,255,255,0.05)',
            borderRadius: '12px',
            padding: '20px',
            border: '1px solid rgba(255,255,255,0.1)'
          }}>
            <h2 style={{ marginBottom: '20px', fontSize: '1.5rem' }}>
              📊 Test Results
            </h2>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '15px' }}>
              {testResults.map((result, index) => (
                <div
                  key={index}
                  style={{
                    background: result.success ? 'rgba(16, 185, 129, 0.1)' : 'rgba(239, 68, 68, 0.1)',
                    border: `1px solid ${result.success ? '#10b981' : '#ef4444'}`,
                    borderRadius: '8px',
                    padding: '15px'
                  }}
                >
                  <div style={{
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    marginBottom: '10px'
                  }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                      <span style={{ fontSize: '1.2rem' }}>
                        {result.success ? '✅' : '❌'}
                      </span>
                      <span style={{ fontWeight: 'bold' }}>
                        {result.method} {result.endpoint}
                      </span>
                    </div>
                    <span style={{ opacity: 0.7, fontSize: '0.9rem' }}>
                      {new Date(result.timestamp).toLocaleTimeString()}
                    </span>
                  </div>

                  {result.response && (
                    <div style={{
                      background: 'rgba(0,0,0,0.3)',
                      borderRadius: '6px',
                      padding: '12px',
                      fontFamily: 'monospace',
                      fontSize: '0.9rem',
                      overflow: 'auto'
                    }}>
                      <pre style={{ margin: 0, whiteSpace: 'pre-wrap' }}>
                        {JSON.stringify(result.response, null, 2)}
                      </pre>
                    </div>
                  )}

                  {result.error && (
                    <div style={{
                      background: 'rgba(239, 68, 68, 0.1)',
                      borderRadius: '6px',
                      padding: '12px',
                      color: '#fca5a5'
                    }}>
                      Error: {result.error}
                    </div>
                  )}
                </div>
              ))}
            </div>
          </div>
        )}

        {!testing && testResults.length === 0 && (
          <div style={{
            textAlign: 'center',
            padding: '40px',
            opacity: 0.6
          }}>
            Click "Run All Tests" to start API endpoint testing
          </div>
        )}

        <div style={{
          marginTop: '30px',
          padding: '20px',
          background: 'rgba(255,255,255,0.05)',
          borderRadius: '12px',
          border: '1px solid rgba(255,255,255,0.1)'
        }}>
          <h3 style={{ marginBottom: '15px' }}>📋 Test Configuration</h3>
          <div style={{ fontSize: '0.9rem', opacity: 0.8, lineHeight: 1.6 }}>
            <p><strong>Base URL:</strong> http://localhost:3000</p>
            <p><strong>Content-Type:</strong> application/json</p>
            <p><strong>Test Delay:</strong> 500ms between requests</p>
            <p><strong>Framework:</strong> Next.js 14 + TypeScript</p>
          </div>
        </div>
      </div>
    </div>
  );
}