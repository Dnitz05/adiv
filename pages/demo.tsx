import { useState, useEffect } from 'react';
import Head from 'next/head';

interface ApiResponse {
  success: boolean;
  message?: string;
  timestamp?: string;
  error?: string;
}

export default function Demo() {
  const [testResult, setTestResult] = useState<ApiResponse | null>(null);
  const [loading, setLoading] = useState(false);

  const testAPI = async () => {
    setLoading(true);
    try {
      const response = await fetch('/api/test');
      const data = await response.json();
      setTestResult(data);
    } catch (error) {
      setTestResult({
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    testAPI();
  }, []);

  return (
    <div style={{ 
      minHeight: '100vh', 
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      color: 'white',
      fontFamily: '"Inter", -apple-system, BlinkMacSystemFont, sans-serif'
    }}>
      <Head>
        <title>Smart Tarot - Demo</title>
      </Head>
      
      <div style={{ 
        maxWidth: '1200px', 
        margin: '0 auto', 
        padding: '20px',
        textAlign: 'center'
      }}>
        
        {/* Header */}
        <div style={{ marginBottom: '40px' }}>
          <h1 style={{ 
            fontSize: '3rem', 
            marginBottom: '10px',
            textShadow: '2px 2px 4px rgba(0,0,0,0.3)'
          }}>
            🎴 Smart Tarot
          </h1>
          <p style={{ 
            fontSize: '1.2rem', 
            opacity: 0.9,
            marginBottom: '20px'
          }}>
            Professional Divination Platform - Demo Interface
          </p>
        </div>

        {/* API Status */}
        <div style={{ 
          background: 'rgba(255,255,255,0.1)', 
          borderRadius: '15px', 
          padding: '30px', 
          marginBottom: '30px',
          backdropFilter: 'blur(10px)'
        }}>
          <h2 style={{ marginBottom: '20px' }}>🔗 API Status</h2>
          
          {loading ? (
            <div style={{ fontSize: '1.1rem' }}>Testing connection...</div>
          ) : testResult ? (
            <div>
              <div style={{ 
                color: testResult.success ? '#4ade80' : '#f87171',
                fontSize: '1.2rem',
                marginBottom: '10px'
              }}>
                {testResult.success ? '✅ Connected' : '❌ Error'}
              </div>
              <div style={{ opacity: 0.8 }}>
                {testResult.message || testResult.error}
              </div>
              {testResult.timestamp && (
                <div style={{ opacity: 0.6, fontSize: '0.9rem', marginTop: '10px' }}>
                  {new Date(testResult.timestamp).toLocaleString()}
                </div>
              )}
            </div>
          ) : null}
          
          <button 
            onClick={testAPI}
            disabled={loading}
            style={{
              marginTop: '20px',
              padding: '12px 24px',
              borderRadius: '8px',
              border: 'none',
              background: 'rgba(255,255,255,0.2)',
              color: 'white',
              cursor: 'pointer',
              fontSize: '1rem',
              transition: 'all 0.3s ease'
            }}
          >
            {loading ? 'Testing...' : 'Test Connection'}
          </button>
        </div>

        {/* Features Grid */}
        <div style={{ 
          display: 'grid', 
          gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', 
          gap: '20px',
          marginBottom: '40px'
        }}>
          
          {/* Tarot Feature */}
          <div style={{ 
            background: 'rgba(255,255,255,0.1)', 
            borderRadius: '15px', 
            padding: '25px',
            backdropFilter: 'blur(10px)'
          }}>
            <h3 style={{ marginBottom: '15px' }}>🎴 Tarot Reading</h3>
            <p style={{ opacity: 0.8, lineHeight: 1.5 }}>
              78-card Rider-Waite-Smith deck with Celtic Cross spreads. 
              Cryptographically secure randomness from Random.org API.
            </p>
          </div>

          {/* I Ching Feature */}
          <div style={{ 
            background: 'rgba(255,255,255,0.1)', 
            borderRadius: '15px', 
            padding: '25px',
            backdropFilter: 'blur(10px)'
          }}>
            <h3 style={{ marginBottom: '15px' }}>☯️ I Ching Oracle</h3>
            <p style={{ opacity: 0.8, lineHeight: 1.5 }}>
              64 hexagram divination system with traditional coin-throwing 
              method and AI-powered interpretations.
            </p>
          </div>

          {/* Runes Feature */}
          <div style={{ 
            background: 'rgba(255,255,255,0.1)', 
            borderRadius: '15px', 
            padding: '25px',
            backdropFilter: 'blur(10px)'
          }}>
            <h3 style={{ marginBottom: '15px' }}>ᚠ Elder Futhark</h3>
            <p style={{ opacity: 0.8, lineHeight: 1.5 }}>
              24 runic symbols from Norse tradition with multiple 
              casting patterns and historical context.
            </p>
          </div>
        </div>

        {/* Architecture Info */}
        <div style={{ 
          background: 'rgba(255,255,255,0.1)', 
          borderRadius: '15px', 
          padding: '30px',
          backdropFilter: 'blur(10px)',
          textAlign: 'left'
        }}>
          <h2 style={{ marginBottom: '20px', textAlign: 'center' }}>🏗️ Technical Architecture</h2>
          
          <div style={{ 
            display: 'grid', 
            gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))', 
            gap: '20px'
          }}>
            <div>
              <h4 style={{ color: '#fbbf24', marginBottom: '10px' }}>Frontend</h4>
              <ul style={{ opacity: 0.9, lineHeight: 1.6 }}>
                <li>Flutter with Material Design 3</li>
                <li>Riverpod state management</li>
                <li>Isar local database</li>
                <li>Multi-language support</li>
              </ul>
            </div>
            
            <div>
              <h4 style={{ color: '#34d399', marginBottom: '10px' }}>Backend</h4>
              <ul style={{ opacity: 0.9, lineHeight: 1.6 }}>
                <li>Vercel serverless functions</li>
                <li>TypeScript + Edge Runtime</li>
                <li>Supabase database</li>
                <li>11 professional API endpoints</li>
              </ul>
            </div>
            
            <div>
              <h4 style={{ color: '#a78bfa', marginBottom: '10px' }}>Integrations</h4>
              <ul style={{ opacity: 0.9, lineHeight: 1.6 }}>
                <li>Random.org verified randomness</li>
                <li>DeepSeek AI interpretations</li>
                <li>In-app purchases</li>
                <li>Premium subscriptions</li>
              </ul>
            </div>
          </div>
        </div>

        {/* Footer */}
        <div style={{ 
          marginTop: '40px', 
          padding: '20px', 
          opacity: 0.7,
          borderTop: '1px solid rgba(255,255,255,0.2)'
        }}>
          <p>Smart Tarot Platform - Production Ready</p>
          <p style={{ fontSize: '0.9rem', marginTop: '5px' }}>
            Backend Server: <span style={{ color: '#4ade80' }}>Running on localhost:3000</span>
          </p>
        </div>
      </div>
    </div>
  );
}