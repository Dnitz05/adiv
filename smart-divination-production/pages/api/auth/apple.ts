import type { NextApiRequest, NextApiResponse } from 'next';
import jwt from 'jsonwebtoken';
import {
  users,
  JWT_SECRET,
  generateUserId,
  findUserByEmail,
  userWithoutPassword,
} from '../../../lib/utils/auth';

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
    const { identityToken, email, givenName, familyName } = req.body || {};

    if (!identityToken) {
      res.status(400).json({
        error: 'Missing required fields',
        message: 'Apple identity token is required',
      });
      return;
    }

    let appleId: string | undefined;
    let userEmail: string | undefined = email;
    let userName = `${givenName || ''} ${familyName || ''}`.trim();

    try {
      const decoded = jwt.decode(identityToken);
      if (decoded && typeof decoded === 'object' && 'sub' in decoded) {
        // decoded.sub is expected to be a string
        appleId = decoded.sub;
        const decodedEmail = (decoded as Record<string, unknown>).email;
        if (!userEmail && typeof decodedEmail === 'string') userEmail = decodedEmail;
      }
    } catch (decodeError) {
      console.error('Failed to decode Apple token:', decodeError);
    }

    if (!userEmail) {
      res.status(400).json({
        error: 'Incomplete profile',
        message: 'Apple account must have email',
      });
      return;
    }

    if (!userName) {
      userName = 'Apple User';
    }

    let user = findUserByEmail(userEmail);

    if (user) {
      if (user.provider !== 'apple') {
        user.provider = 'apple';
        user.providerId = appleId;
      }
    } else {
      const newUser = {
        id: generateUserId(),
        email: userEmail.toLowerCase(),
        password: '',
        name: userName.trim(),
        isPremium: false,
        createdAt: new Date(),
        provider: 'apple' as const,
        providerId: appleId,
      };

      users.push(newUser);
      user = newUser;
    }

    const token = jwt.sign({ userId: user.id, email: user.email }, JWT_SECRET, { expiresIn: '7d' });

    res.status(200).json({
      message: 'Apple sign-in successful',
      user: userWithoutPassword(user),
      token,
    });
    return;
  } catch (error) {
    console.error('Apple auth error:', error);
    res.status(500).json({
      error: 'Internal server error',
      message: 'Failed to authenticate with Apple. Please try again.',
    });
    return;
  }
}

export const runtime = 'nodejs';
