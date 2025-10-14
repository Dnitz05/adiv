import type { NextApiRequest, NextApiResponse } from 'next';

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  const hasDeepSeekKey = !!process.env.DEEPSEEK_API_KEY;
  const keyLength = process.env.DEEPSEEK_API_KEY?.length || 0;
  const keyPrefix = process.env.DEEPSEEK_API_KEY?.substring(0, 8) || '';

  res.status(200).json({
    hasDeepSeekKey,
    keyLength,
    keyPrefix,
    allEnvKeys: Object.keys(process.env).sort(),
  });
}
