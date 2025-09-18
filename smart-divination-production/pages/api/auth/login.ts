import type { NextApiRequest, NextApiResponse } from 'next';
import { isValidEmail } from '../../../lib/utils/auth';
import { getSupabaseClient, getSupabaseServiceClient } from '../../../lib/utils/supabase';

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  // CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  try {
    const { email, password } = req.body || {};

    if (!email || !password) {
      res.status(400).json({
        error: 'Missing required fields',
        message: 'Email and password are required',
      });
      return;
    }

    if (!isValidEmail(email)) {
      res.status(400).json({
        error: 'Invalid email format',
        message: 'Please enter a valid email address',
      });
      return;
    }

    const client = getSupabaseClient();
    const { data, error } = await client.auth.signInWithPassword({
      email: email.toLowerCase(),
      password: String(password),
    });

    if (error || !data?.user || !data?.session) {
      res
        .status(401)
        .json({ error: 'INVALID_CREDENTIALS', message: 'Email or password is incorrect' });
      return;
    }

    // Ensure profile exists in public.users (best-effort)
    try {
      const service = getSupabaseServiceClient();
      await service.from('users').upsert(
        {
          id: data.user.id,
          email: data.user.email,
          last_activity: new Date().toISOString(),
        },
        { onConflict: 'id' }
      );
    } catch {}

    // Return Supabase access token as API token for the app
    const token = data.session.access_token;
    const meta = data.user.user_metadata as Record<string, unknown> | null;
    const name = meta && typeof meta['name'] === 'string' ? (meta['name'] as string) : null;

    res.status(200).json({
      message: 'Login successful',
      user: { id: data.user.id, email: data.user.email, name },
      token,
    });
    return;
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      error: 'Internal server error',
      message: 'Failed to sign in. Please try again.',
    });
    return;
  }
}

export const runtime = 'nodejs';
