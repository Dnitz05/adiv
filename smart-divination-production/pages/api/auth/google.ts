import type { NextApiRequest, NextApiResponse } from 'next';
import jwt from 'jsonwebtoken';
// Lazy-load to avoid bundling error when dependency is not installed
let OAuth2Client;
try {
  // use computed require to prevent static analysis by bundler
  // eslint-disable-next-line @typescript-eslint/no-var-requires
  const lib = require('google-' + 'auth-library');
  OAuth2Client = lib.OAuth2Client;
} catch (_err) {
  OAuth2Client = null;
}
import {
  users,
  JWT_SECRET,
  generateUserId,
  findUserByEmail,
  userWithoutPassword,
} from '../../../lib/utils/auth';

const client = OAuth2Client ? new OAuth2Client(process.env.GOOGLE_CLIENT_ID) : null;

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
  if (!OAuth2Client || !client) {
    res.status(501).json({ success: false, error: 'Google Auth not configured' });
    return;
  }
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
    const { idToken } = req.body || {};

    if (!idToken) {
      res.status(400).json({
        error: 'Missing required fields',
        message: 'Google ID token is required',
      });
      return;
    }

    const ticket = await client.verifyIdToken({
      idToken,
      audience: process.env.GOOGLE_CLIENT_ID,
    });

    const payload = ticket.getPayload();
    if (!payload) {
      res.status(401).json({
        error: 'Invalid token',
        message: 'Google token verification failed',
      });
      return;
    }

    const { sub: googleId, email, name } = payload;

    if (!email || !name) {
      res.status(400).json({
        error: 'Incomplete profile',
        message: 'Google account must have email and name',
      });
      return;
    }

    let user = findUserByEmail(email);

    if (user) {
      if (user.provider !== 'google') {
        user.provider = 'google';
        user.providerId = googleId;
      }
    } else {
      const newUser = {
        id: generateUserId(),
        email: email.toLowerCase(),
        password: '',
        name: String(name).trim(),
        isPremium: false,
        createdAt: new Date(),
        provider: 'google' as const,
        providerId: googleId,
      };
      users.push(newUser);
      user = newUser;
    }

    const token = jwt.sign({ userId: user.id, email: user.email }, JWT_SECRET, { expiresIn: '7d' });

    res.status(200).json({
      message: 'Google sign-in successful',
      user: userWithoutPassword(user),
      token,
    });
    return;
  } catch (error) {
    console.error('Google auth error:', error);
    res.status(500).json({
      error: 'Internal server error',
      message: 'Failed to authenticate with Google. Please try again.',
    });
    return;
  }
}

export const runtime = 'nodejs';
