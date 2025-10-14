import type { NextApiRequest, NextApiResponse } from 'next';

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const apiKey = process.env.RANDOM_ORG_KEY || process.env.RANDOM_ORG_API_KEY;

  if (!apiKey) {
    res.status(500).json({
      error: 'No API key found',
      env: Object.keys(process.env).filter((k) => k.includes('RANDOM')),
    });
    return;
  }

  const payload = {
    jsonrpc: '2.0',
    method: 'generateSignedIntegers',
    params: {
      apiKey,
      n: 1,
      min: 1,
      max: 10,
      replacement: true,
      base: 10,
    },
    id: 1,
  };

  try {
    const response = await fetch('https://api.random.org/json-rpc/4/invoke', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    });

    const data: unknown = await response.json();
    res.status(200).json({
      success: true,
      apiKeyFound: !!apiKey,
      apiKeyPrefix: apiKey?.substring(0, 8),
      apiKeyLength: apiKey?.length,
      response: data,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error instanceof Error ? error.message : String(error),
      apiKeyFound: !!apiKey,
    });
  }
}
