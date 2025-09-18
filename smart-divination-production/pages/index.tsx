import Link from 'next/link';
import Head from 'next/head';

export default function Home() {
  return (
    <div style={{
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #334155 100%)',
      color: 'white',
      fontFamily: '"Inter", -apple-system, BlinkMacSystemFont, sans-serif',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center'
    }}>
      <Head>
        <title>Smart Tarot - Development Portal</title>
      </Head>

      <div style={{
        textAlign: 'center',
        maxWidth: '600px',
        padding: '40px'
      }}>
        <div style={{ marginBottom: '40px' }}>
          <h1 style={{
            fontSize: '3.5rem',
            marginBottom: '20px',
            background: 'linear-gradient(135deg, #a855f7 0%, #3b82f6 100%)',
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
            backgroundClip: 'text'
          }}>
            🎴 Smart Tarot
          </h1>
          <p style={{
            fontSize: '1.3rem',
            opacity: 0.8,
            marginBottom: '30px',
            lineHeight: 1.5
          }}>
            Professional Divination Platform
            <br />
            <span style={{ fontSize: '1rem', opacity: 0.6 }}>
              Development Environment Portal
            </span>
          </p>
        </div>

        <div style={{
          display: 'flex',
          flexDirection: 'column',
          gap: '15px',
          alignItems: 'center'
        }}>
          <Link href="/demo" style={{
            display: 'block',
            width: '300px',
            padding: '18px 25px',
            background: 'linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%)',
            color: 'white',
            textDecoration: 'none',
            borderRadius: '12px',
            fontSize: '1.1rem',
            fontWeight: '500',
            transition: 'all 0.3s ease',
            boxShadow: '0 4px 20px rgba(99, 102, 241, 0.3)'
          }}>
            🎨 View Demo Interface
          </Link>

          <Link href="/testing" style={{
            display: 'block',
            width: '300px',
            padding: '18px 25px',
            background: 'linear-gradient(135deg, #10b981 0%, #059669 100%)',
            color: 'white',
            textDecoration: 'none',
            borderRadius: '12px',
            fontSize: '1.1rem',
            fontWeight: '500',
            transition: 'all 0.3s ease',
            boxShadow: '0 4px 20px rgba(16, 185, 129, 0.3)'
          }}>
            🧪 API Testing Suite
          </Link>

          <a href="/api/test" style={{
            display: 'block',
            width: '300px',
            padding: '18px 25px',
            background: 'linear-gradient(135deg, #f59e0b 0%, #d97706 100%)',
            color: 'white',
            textDecoration: 'none',
            borderRadius: '12px',
            fontSize: '1.1rem',
            fontWeight: '500',
            transition: 'all 0.3s ease',
            boxShadow: '0 4px 20px rgba(245, 158, 11, 0.3)'
          }}>
            🔗 Raw API Response
          </a>
        </div>

        <div style={{
          marginTop: '40px',
          padding: '25px',
          background: 'rgba(255,255,255,0.05)',
          borderRadius: '12px',
          border: '1px solid rgba(255,255,255,0.1)'
        }}>
          <h3 style={{ marginBottom: '15px', color: '#a78bfa' }}>
            🚀 System Status
          </h3>
          <div style={{
            display: 'grid',
            gridTemplateColumns: '1fr 1fr',
            gap: '10px',
            fontSize: '0.95rem'
          }}>
            <div style={{ opacity: 0.8 }}>
              <strong>Backend:</strong> <span style={{ color: '#4ade80' }}>Running</span>
            </div>
            <div style={{ opacity: 0.8 }}>
              <strong>Port:</strong> 3000
            </div>
            <div style={{ opacity: 0.8 }}>
              <strong>Framework:</strong> Next.js 14
            </div>
            <div style={{ opacity: 0.8 }}>
              <strong>Runtime:</strong> Node.js
            </div>
          </div>
        </div>

        <div style={{
          marginTop: '30px',
          opacity: 0.6,
          fontSize: '0.9rem'
        }}>
          <p>Development environment ready for testing and visualization</p>
        </div>
      </div>
    </div>
  );
}