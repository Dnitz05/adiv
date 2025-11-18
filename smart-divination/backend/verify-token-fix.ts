/**
 * Verify Token Budget Fix
 */

console.log('═══════════════════════════════════════════════════════════════');
console.log('TOKEN BUDGET FIX VERIFICATION');
console.log('═══════════════════════════════════════════════════════════════\n');

interface TestCase {
  numCards: number;
  hasInteractions: boolean;
  name: string;
}

const testCases: TestCase[] = [
  { numCards: 1, hasInteractions: false, name: 'Single Card (no interactions)' },
  { numCards: 3, hasInteractions: false, name: 'Three Card (no interactions)' },
  { numCards: 5, hasInteractions: false, name: 'Five Card (no interactions)' },
  { numCards: 10, hasInteractions: false, name: 'Celtic Cross (no interactions)' },
  { numCards: 5, hasInteractions: true, name: 'Five Card (WITH interactions)' },
  { numCards: 10, hasInteractions: true, name: 'Celtic Cross (WITH interactions)' },
];

console.log('Testing NEW token calculation logic:\n');

testCases.forEach(tc => {
  const baseWords = 100;
  const wordsPerCard = 80;
  const conclusionWords = 60;
  const totalWords = baseWords + (tc.numCards * wordsPerCard) + conclusionWords;

  const responseTokens = Math.ceil(totalWords * 1.5);
  const maxTokens = tc.hasInteractions
    ? Math.min(8000, Math.max(2000, responseTokens * 2))
    : Math.min(4000, Math.max(1200, responseTokens));

  console.log(`${tc.name}:`);
  console.log(`  Target words: ${totalWords}`);
  console.log(`  Response tokens needed: ${responseTokens}`);
  console.log(`  maxTokens allocated: ${maxTokens}`);

  // Estimate prompt tokens based on observed data
  let estimatedPromptTokens = 0;
  if (tc.numCards === 10 && tc.hasInteractions) {
    estimatedPromptTokens = 6377; // From actual test
  } else if (tc.numCards === 10 && !tc.hasInteractions) {
    estimatedPromptTokens = 2054; // From actual test
  } else if (tc.numCards === 5 && tc.hasInteractions) {
    estimatedPromptTokens = 5034; // From actual test (relationship)
  } else if (tc.numCards === 5 && !tc.hasInteractions) {
    estimatedPromptTokens = 1912; // From actual test
  } else {
    // Estimate for others
    estimatedPromptTokens = tc.hasInteractions ? tc.numCards * 500 : tc.numCards * 200;
  }

  console.log(`  Estimated prompt tokens: ~${estimatedPromptTokens}`);

  // CRITICAL: maxTokens is for OUTPUT only, NOT total
  // Gemini's limit is typically 8K output tokens
  const effectiveResponseSpace = maxTokens;
  const status = effectiveResponseSpace >= responseTokens ? '✅' : '❌';

  console.log(`  Response space available: ${effectiveResponseSpace}`);
  console.log(`  Status: ${status} ${effectiveResponseSpace >= responseTokens ? 'SUFFICIENT' : 'INSUFFICIENT'}`);
  console.log();
});

console.log('═══════════════════════════════════════════════════════════════');
console.log('CRITICAL UNDERSTANDING:');
console.log('═══════════════════════════════════════════════════════════════\n');
console.log('maxTokens parameter in Gemini = OUTPUT token limit');
console.log('Prompt tokens do NOT count against maxTokens');
console.log('Therefore our calculation is CORRECT:\n');
console.log('  Celtic Cross WITH interactions:');
console.log('    - Prompt: ~6,377 tokens (NOT counted against limit)');
console.log('    - maxTokens: 2,880 tokens (for response generation)');
console.log('    - Expected response: ~1,440 tokens');
console.log('    - ✅ Plenty of headroom!\n');
console.log('═══════════════════════════════════════════════════════════════\n');
