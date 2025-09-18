import type { NextRequest } from 'next/server';
import { NextResponse } from 'next/server';

export default async function handler(req: NextRequest): Promise<Response> {
  try {
    if (req.method !== 'POST') {
      return NextResponse.json({ error: 'Method not allowed' }, { status: 405 });
    }

    await req.json();

    // Test 1: Basic Web Crypto
    const array = new Uint32Array(1);
    globalThis.crypto.getRandomValues(array);
    const basicRandom = array[0] / 0x100000000;

    // Test 2: Import universalCrypto
    let cryptoTest = 'failed';
    try {
      const { getSecureRandom } = await import('../../lib/utils/universalCrypto');
      const secureRandom = getSecureRandom();
      cryptoTest = `success: ${secureRandom}`;
    } catch (error) {
      cryptoTest = `error: ${error instanceof Error ? error.message : String(error)}`;
    }

    // Test 3: Import randomness
    let randomnessTest = 'failed';
    try {
      const { generateRandomCards } = await import('../../lib/utils/randomness');
      const result = await generateRandomCards({
        count: 1,
        allowDuplicates: false,
        maxValue: 77,
      });
      randomnessTest = `success: ${JSON.stringify(result)}`;
    } catch (error) {
      randomnessTest = `error: ${error instanceof Error ? error.message : String(error)}`;
    }

    return NextResponse.json(
      {
        success: true,
        tests: {
          basicWebCrypto: `success: ${basicRandom}`,
          universalCrypto: cryptoTest,
          randomnessService: randomnessTest,
        },
        environment: {
          runtime: 'edge',
          hasGlobalThis: typeof globalThis !== 'undefined',
          hasCrypto: typeof globalThis.crypto !== 'undefined',
        },
      },
      { status: 200 }
    );
  } catch (error) {
    return NextResponse.json(
      {
        success: false,
        error: error instanceof Error ? error.message : String(error),
        stack: error instanceof Error ? error.stack : undefined,
      },
      { status: 500 }
    );
  }
}

export const runtime = 'edge';
