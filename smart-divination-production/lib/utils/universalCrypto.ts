/**
 * Universal Cryptographic Random - ULTRATHINK SOLUTION
 * 
 * Cross-platform cryptographically secure random number generation that works in:
 * - Vercel Edge Runtime (Web Crypto API)
 * - Node.js (crypto module)
 * - Browser (Web Crypto API)
 * 
 * SOLVES: Math.random() incompatibility with Vercel Edge Runtime
 */

// =============================================================================
// ENVIRONMENT DETECTION & CRYPTO SELECTION
// =============================================================================

interface CryptoEnvironment {
  type: 'web-crypto' | 'node-crypto' | 'fallback';
  available: boolean;
  description: string;
}

/**
 * Detect available cryptographic environment
 */
function detectCryptoEnvironment(): CryptoEnvironment {
  // Priority 1: Web Crypto API (Vercel Edge + Browser)
  if (typeof globalThis !== 'undefined' && 
      typeof globalThis.crypto !== 'undefined' && 
      typeof globalThis.crypto.getRandomValues === 'function') {
    return {
      type: 'web-crypto',
      available: true,
      description: 'Web Crypto API (Edge Runtime/Browser)'
    };
  }
  
  // Priority 2: Node.js crypto module
  if (typeof require !== 'undefined') {
    try {
      // eslint-disable-next-line @typescript-eslint/no-var-requires
      const nodeCrypto = require('crypto');
      if (nodeCrypto && typeof nodeCrypto.randomBytes === 'function') {
        return {
          type: 'node-crypto',
          available: true,
          description: 'Node.js crypto module'
        };
      }
    } catch (error) {
      // Node crypto not available
    }
  }
  
  // Priority 3: Check window.crypto (browser fallback)
  if (typeof window !== 'undefined' && 
      typeof window.crypto !== 'undefined' && 
      typeof window.crypto.getRandomValues === 'function') {
    return {
      type: 'web-crypto',
      available: true,
      description: 'Browser Web Crypto API'
    };
  }
  
  return {
    type: 'fallback',
    available: false,
    description: 'No cryptographically secure random available'
  };
}

// =============================================================================
// SECURE RANDOM GENERATION
// =============================================================================

/**
 * Generate cryptographically secure random number [0, 1)
 * REPLACEMENT for Math.random() - works in all environments
 */
export function getSecureRandom(): number {
  const env = detectCryptoEnvironment();
  
  switch (env.type) {
    case 'web-crypto': {
      // Use Web Crypto API (Vercel Edge Runtime + Browser)
      const array = new Uint32Array(1);
      
      // Try globalThis.crypto first (Edge Runtime)
      if (typeof globalThis !== 'undefined' && globalThis.crypto) {
        globalThis.crypto.getRandomValues(array);
      }
      // Fallback to window.crypto (Browser)
      else if (typeof window !== 'undefined' && window.crypto) {
        window.crypto.getRandomValues(array);
      }
      else {
        throw new Error('Web Crypto API not accessible');
      }
      
      return array[0] / 0x100000000;
    }
    
    case 'node-crypto': {
      // Use Node.js crypto module
      // eslint-disable-next-line @typescript-eslint/no-var-requires
      const crypto = require('crypto');
      const bytes = crypto.randomBytes(4);
      return bytes.readUInt32BE(0) / 0x100000000;
    }
    
    default: {
      throw new Error(`ULTRATHINK ERROR: ${env.description}. Cannot generate secure random numbers.`);
    }
  }
}

/**
 * Generate secure random string (replacement for Math.random().toString(36))
 * DIRECT REPLACEMENT for request ID generation
 */
export function getSecureRandomString(length: number = 9): string {
  const chars = '0123456789abcdefghijklmnopqrstuvwxyz';
  let result = '';
  
  for (let i = 0; i < length; i++) {
    const randomIndex = Math.floor(getSecureRandom() * chars.length);
    result += chars[randomIndex];
  }
  
  return result;
}

/**
 * Generate secure request ID (replacement for validation files)
 */
export function generateSecureRequestId(prefix: string = 'req'): string {
  const timestamp = Date.now();
  const randomPart = getSecureRandomString(9);
  return `${prefix}_${timestamp}_${randomPart}`;
}

/**
 * Generate secure random integer in range [min, max] inclusive
 */
export function getSecureRandomInt(min: number, max: number): number {
  if (min >= max) {
    throw new Error('Min must be less than max');
  }
  
  const range = max - min + 1;
  const randomFloat = getSecureRandom();
  return Math.floor(randomFloat * range) + min;
}

// =============================================================================
// COMPATIBILITY & VALIDATION
// =============================================================================

/**
 * Test crypto functionality and environment compatibility
 */
export function testCryptoCompatibility(): {
  success: boolean;
  environment: CryptoEnvironment;
  testResults: {
    randomGeneration: boolean;
    stringGeneration: boolean;
    requestIdGeneration: boolean;
  };
  error?: string;
} {
  const environment = detectCryptoEnvironment();
  const testResults = {
    randomGeneration: false,
    stringGeneration: false,
    requestIdGeneration: false
  };
  
  try {
    // Test 1: Random number generation
    const randomNum = getSecureRandom();
    testResults.randomGeneration = typeof randomNum === 'number' && 
                                   randomNum >= 0 && randomNum < 1;
    
    // Test 2: Random string generation  
    const randomStr = getSecureRandomString(10);
    testResults.stringGeneration = typeof randomStr === 'string' && 
                                  randomStr.length === 10;
    
    // Test 3: Request ID generation
    const requestId = generateSecureRequestId('test');
    testResults.requestIdGeneration = typeof requestId === 'string' && 
                                     requestId.includes('test_');
    
    const success = testResults.randomGeneration && 
                   testResults.stringGeneration && 
                   testResults.requestIdGeneration;
    
    return { success, environment, testResults };
    
  } catch (error) {
    return {
      success: false,
      environment,
      testResults,
      error: error instanceof Error ? error.message : String(error)
    };
  }
}

/**
 * Get environment info for debugging
 */
export function getCryptoEnvironmentInfo(): {
  detected: CryptoEnvironment;
  runtimeInfo: {
    hasGlobalThis: boolean;
    hasWindow: boolean;
    hasRequire: boolean;
    hasNodeProcess: boolean;
    userAgent?: string;
  };
} {
  const detected = detectCryptoEnvironment();
  
  const runtimeInfo = {
    hasGlobalThis: typeof globalThis !== 'undefined',
    hasWindow: typeof window !== 'undefined',
    hasRequire: typeof require !== 'undefined',
    hasNodeProcess: typeof process !== 'undefined',
    userAgent: typeof navigator !== 'undefined' ? navigator.userAgent : undefined
  };
  
  return { detected, runtimeInfo };
}

// =============================================================================
// LEGACY COMPATIBILITY (for drop-in replacement)
// =============================================================================

/**
 * Drop-in replacement for Math.random() - DEPRECATED, use getSecureRandom()
 * @deprecated Use getSecureRandom() instead
 */
export const secureRandom = getSecureRandom;

export default {
  getSecureRandom,
  getSecureRandomString,
  generateSecureRequestId,
  getSecureRandomInt,
  testCryptoCompatibility,
  getCryptoEnvironmentInfo,
  // Legacy
  secureRandom
};
