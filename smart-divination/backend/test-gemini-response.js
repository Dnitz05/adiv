/**
 * Debug script to see raw Gemini response
 */
const { selectSpreadWithGemini } = require('./lib/services/gemini-ai');
const { SPREADS } = require('./lib/data/spreads');

async function test() {
  try {
    const result = await selectSpreadWithGemini(
      "How did I get here and where am I heading?",
      SPREADS,
      'en'
    );
    console.log('SUCCESS:', JSON.stringify(result, null, 2));
  } catch (error) {
    console.error('ERROR:', error.message);
  }
}

test();
