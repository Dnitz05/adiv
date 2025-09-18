import type { NextRequest } from 'next/server';
import { NextResponse } from 'next/server';
import { recordApiMetric } from '../../lib/utils/metrics';

// Simple Tarot deck - just first 10 cards for testing
const SIMPLE_TAROT = [
  { id: 0, name: 'The Fool', suit: 'Major Arcana' },
  { id: 1, name: 'The Magician', suit: 'Major Arcana' },
  { id: 2, name: 'The High Priestess', suit: 'Major Arcana' },
  { id: 3, name: 'The Empress', suit: 'Major Arcana' },
  { id: 4, name: 'The Emperor', suit: 'Major Arcana' },
  { id: 5, name: 'The Hierophant', suit: 'Major Arcana' },
  { id: 6, name: 'The Lovers', suit: 'Major Arcana' },
  { id: 7, name: 'The Chariot', suit: 'Major Arcana' },
  { id: 8, name: 'Strength', suit: 'Major Arcana' },
  { id: 9, name: 'The Hermit', suit: 'Major Arcana' },
];

export default async function handler(req: NextRequest): Promise<Response> {
  const start = Date.now();
  try {
    if (req.method !== 'POST') {
      const r405 = NextResponse.json({ error: 'Method not allowed' }, { status: 405 });
      recordApiMetric('/api/simple-tarot', 405, Date.now() - start);
      return r405;
    }

    const body = await req.json();
    const count = body.count || 1;

    // Import randomness
    const { generateRandomCards } = await import('../../lib/utils/randomness');

    // Generate cards with simple deck (0-9)
    const result = await generateRandomCards({
      count: count,
      allowDuplicates: false,
      maxValue: 9, // Only first 10 cards
    });

    // Map to card data with proper decoding
    const cards = result.values.map((encodedValue, position) => {
      const cardIndex = encodedValue >> 1; // Decode index
      const isReversed = (encodedValue & 1) === 1; // Decode reversal

      // Validate index
      if (cardIndex < 0 || cardIndex >= SIMPLE_TAROT.length) {
        throw new Error(`Invalid card index: ${cardIndex}`);
      }

      const cardData = SIMPLE_TAROT[cardIndex];

      return {
        id: cardIndex,
        name: cardData.name,
        suit: cardData.suit,
        isReversed,
        position: position + 1,
      };
    });

    const r200 = NextResponse.json(
      {
        success: true,
        data: cards,
        meta: {
          count: cards.length,
          seed: result.seed,
          method: result.method,
        },
      },
      { status: 200 }
    );
    recordApiMetric('/api/simple-tarot', 200, Date.now() - start);
    return r200;
  } catch (error) {
    const r500 = NextResponse.json(
      {
        success: false,
        error: error instanceof Error ? error.message : String(error),
        stack: error instanceof Error ? error.stack : undefined,
      },
      { status: 500 }
    );
    recordApiMetric('/api/simple-tarot', 500, Date.now() - start);
    return r500;
  }
}

export const runtime = 'edge';
