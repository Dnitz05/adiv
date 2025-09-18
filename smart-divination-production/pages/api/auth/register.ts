import type { NextApiRequest, NextApiResponse } from 'next';
import jwt from 'jsonwebtoken';
import { JWT_SECRET, isValidEmail } from '../../../lib/utils/auth';
import { getSupabaseServiceClient } from '../../../lib/utils/supabase';

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
    const { email, password, name } = req.body || {};

    if (!email || !password || !name) {
      res.status(400).json({
        error: 'Missing required fields',
        message: 'Name, email and password are required',
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

    const service = getSupabaseServiceClient();

    // Create user in Supabase Auth (admin)
    const { data, error } = await service.auth.admin.createUser({
      email: email.toLowerCase(),
      password: String(password),
      email_confirm: true,
      user_metadata: { name: String(name).trim() },
    });

    if (error || !data?.user) {
      const msg = error?.message || 'Failed to create user';
      if (msg.toLowerCase().includes('already') || msg.toLowerCase().includes('exists')) {
        res
          .status(409)
          .json({ error: 'EMAIL_ALREADY_EXISTS', message: 'This email is already registered' });
        return;
      }
      res.status(500).json({ error: 'INTERNAL', message: msg });
      return;
    }

    const authUser = data.user;

    // Ensure profile exists in public.users
    await service.from('users').upsert(
      {
        id: authUser.id,
        email: authUser.email,
        name: name,
        last_activity: new Date().toISOString(),
      },
      { onConflict: 'id' }
    );

    const token = jwt.sign({ userId: authUser.id, email: authUser.email }, JWT_SECRET, {
      expiresIn: '7d',
    });

    res.status(201).json({
      message: 'Registration successful',
      user: { id: authUser.id, email: authUser.email, name },
      token,
    });
    return;
  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({
      error: 'Internal server error',
      message: 'Failed to register. Please try again.',
    });
    return;
  }
}

export const runtime = 'nodejs';
