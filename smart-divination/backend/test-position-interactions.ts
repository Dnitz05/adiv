/**
 * FASE 2 VALIDATION TEST: Position Interactions Enhancement
 *
 * Tests that position interactions improve interpretation quality by:
 * 1. Comparing interpretations WITH vs WITHOUT position interactions
 * 2. Measuring quality metrics:
 *    - Cross-position references
 *    - Narrative coherence (story flow between cards)
 *    - Interaction guidance adherence
 *    - Depth of relationship analysis
 */

// Load environment variables from .env.local
import * as fs from 'fs';
import * as path from 'path';

const envPath = path.join(__dirname, '.env.local');
if (fs.existsSync(envPath)) {
  const envContent = fs.readFileSync(envPath, 'utf-8');
  envContent.split('\n').forEach(line => {
    const match = line.match(/^([^=]+)=(.*)$/);
    if (match) {
      const key = match[1].trim();
      const value = match[2].trim();
      if (key && !process.env[key]) {
        process.env[key] = value;
      }
    }
  });
}

import { interpretCardsWithGemini } from './lib/services/gemini-ai';
import { getSpreadById } from './lib/data/spreads';

// Test cases covering different spreads with rich interactions
const TEST_CASES = [
  {
    id: 'celtic_cross_major_decision',
    spreadId: 'celtic_cross',
    question: 'Should I accept this job offer in a new city?',
    cards: [
      { name: 'The Tower', upright: false, position: 'Present' },
      { name: 'Two of Swords', upright: true, position: 'Challenge' },
      { name: 'Ten of Pentacles', upright: true, position: 'Distant Past' },
      { name: 'The Fool', upright: true, position: 'Recent Past' },
      { name: 'The World', upright: true, position: 'Goal' },
      { name: 'Three of Wands', upright: true, position: 'Near Future' },
      { name: 'King of Pentacles', upright: false, position: 'Self' },
      { name: 'Six of Swords', upright: true, position: 'Environment' },
      { name: 'The Star', upright: true, position: 'Hopes and Fears' },
      { name: 'Ace of Pentacles', upright: true, position: 'Outcome' },
    ],
    locale: 'en',
    expectedInteractions: [
      'Present ↔ Challenge', // Core conflict
      'Distant Past → Recent Past → Present', // Timeline progression
      'Self ↔ Environment', // Internal vs external
      'Hopes/Fears → Outcome', // Emotional resolution
    ],
  },
  {
    id: 'relationship_love_triangle',
    spreadId: 'relationship',
    question: 'What is the truth about my relationship with Alex?',
    cards: [
      { name: 'The Lovers', upright: false, position: 'You' },
      { name: 'Seven of Swords', upright: true, position: 'Partner' },
      { name: 'Three of Cups', upright: true, position: 'Connection' },
      { name: 'Five of Cups', upright: true, position: 'Obstacles' },
      { name: 'The Moon', upright: true, position: 'Advice' },
    ],
    locale: 'en',
    expectedInteractions: [
      'You ↔ Partner ↔ Connection', // Relationship triangle
      'Obstacles → Advice', // Problem resolution path
    ],
  },
  {
    id: 'five_card_cross_career',
    spreadId: 'five_card_cross',
    question: 'How can I advance in my career this year?',
    cards: [
      { name: 'Eight of Pentacles', upright: true, position: 'Present' },
      { name: 'Four of Wands', upright: true, position: 'Past' },
      { name: 'Knight of Swords', upright: true, position: 'Future' },
      { name: 'Queen of Pentacles', upright: false, position: 'Above (Conscious)' },
      { name: 'The Devil', upright: true, position: 'Below (Unconscious)' },
    ],
    locale: 'en',
    expectedInteractions: [
      'Past → Present → Future', // Timeline
      'Above ↔ Below', // Conscious/unconscious tension
    ],
  },
];

// Quality metrics to analyze
const QUALITY_METRICS = {
  crossPositionReferences: {
    name: 'Cross-Position References',
    description: 'Count explicit mentions of card relationships (e.g., "The Tower in your Present crosses with the Two of Swords")',
    test: (text, testCase) => {
      let count = 0;
      const positions = testCase.cards.map(c => c.position.toLowerCase());

      // Check for explicit position-to-position references
      for (let i = 0; i < positions.length; i++) {
        for (let j = i + 1; j < positions.length; j++) {
          const pos1 = positions[i];
          const pos2 = positions[j];

          // Patterns like "X and Y", "X with Y", "X ↔ Y", etc.
          const patterns = [
            new RegExp(`${pos1}[^.]{0,50}(and|with|crosses|versus|vs\\.?|↔)[^.]{0,50}${pos2}`, 'gi'),
            new RegExp(`${pos2}[^.]{0,50}(and|with|crosses|versus|vs\\.?|↔)[^.]{0,50}${pos1}`, 'gi'),
          ];

          patterns.forEach(pattern => {
            const matches = text.match(pattern);
            if (matches) count += matches.length;
          });
        }
      }

      return count;
    },
  },

  narrativeCoherence: {
    name: 'Narrative Coherence',
    description: 'Measures flow indicators (transitions, therefore, because, thus, etc.)',
    test: (text) => {
      const flowIndicators = [
        'therefore', 'thus', 'because', 'since', 'as a result',
        'this suggests', 'this indicates', 'this reveals',
        'flowing into', 'leading to', 'building on',
        'in contrast', 'however', 'meanwhile', 'simultaneously',
        'dialogue', 'conversation', 'interaction', 'relationship',
        'story', 'narrative', 'journey', 'progression',
      ];

      let count = 0;
      flowIndicators.forEach(indicator => {
        const regex = new RegExp(`\\b${indicator}\\b`, 'gi');
        const matches = text.match(regex);
        if (matches) count += matches.length;
      });

      return count;
    },
  },

  interactionGuidanceAdherence: {
    name: 'Interaction Guidance Adherence',
    description: 'Checks if AI followed specific interaction guidance from educational content',
    test: (text, testCase) => {
      const spread = getSpreadById(testCase.spreadId);
      if (!spread?.educational?.positionInteractions) return 0;

      let adherenceCount = 0;
      const interactions = spread.educational.positionInteractions;

      interactions.forEach(interaction => {
        // Check if the interpretation discusses concepts from aiGuidance
        const guidanceKeywords = interaction.aiGuidance
          .toLowerCase()
          .split(/\s+/)
          .filter(w => w.length > 5); // Only significant words

        const textLower = text.toLowerCase();
        const mentionedKeywords = guidanceKeywords.filter(kw => textLower.includes(kw));

        // If more than 30% of guidance keywords are mentioned, count as adherent
        if (mentionedKeywords.length / guidanceKeywords.length > 0.3) {
          adherenceCount++;
        }
      });

      return adherenceCount;
    },
  },

  depthOfRelationshipAnalysis: {
    name: 'Depth of Relationship Analysis',
    description: 'Measures how deeply card relationships are explored',
    test: (text, testCase) => {
      // Look for deep analysis patterns
      const deepPatterns = [
        /how (the |this )?[\w\s]+ (card |position )?(relates to|connects with|influences|affects|shapes)/gi,
        /the (relationship|connection|dialogue|interaction) between/gi,
        /together[,\s]+(they|these cards|these positions)/gi,
        /(one|this) card[^\.]+(while|whereas|but) (the other|another)/gi,
        /energy (flows?|moves?) (from|between|into)/gi,
        /(contrasts?|complements?|tensions?) (with|between)/gi,
      ];

      let depth = 0;
      deepPatterns.forEach(pattern => {
        const matches = text.match(pattern);
        if (matches) depth += matches.length;
      });

      return depth;
    },
  },
};

// Main test runner
async function runTest(testCase, withInteractions) {
  console.log(`\n${'='.repeat(80)}`);
  console.log(`TEST: ${testCase.id}`);
  console.log(`Spread: ${testCase.spreadId}`);
  console.log(`Mode: ${withInteractions ? 'WITH' : 'WITHOUT'} position interactions`);
  console.log(`${'='.repeat(80)}\n`);

  const spread = getSpreadById(testCase.spreadId);
  const spreadName = spread.name;

  try {
    const interpretation = await interpretCardsWithGemini(
      testCase.question,
      testCase.cards,
      spreadName,
      testCase.locale,
      `test-${testCase.id}-${withInteractions ? 'with' : 'without'}`,
      withInteractions ? testCase.spreadId : undefined, // Key difference!
    );

    console.log('INTERPRETATION RECEIVED:\n');
    console.log(interpretation.substring(0, 500) + '...\n');

    // Analyze quality metrics
    const results = {};
    Object.entries(QUALITY_METRICS).forEach(([key, metric]) => {
      const score = metric.test(interpretation, testCase);
      results[key] = score;
      console.log(`${metric.name}: ${score}`);
    });

    return {
      success: true,
      interpretation,
      metrics: results,
      length: interpretation.length,
    };
  } catch (error) {
    console.error(`ERROR: ${error.message}`);
    return {
      success: false,
      error: error.message,
    };
  }
}

async function main() {
  console.log('\n');
  console.log('╔════════════════════════════════════════════════════════════════════════════╗');
  console.log('║     FASE 2 VALIDATION: Position Interactions Enhancement Test             ║');
  console.log('╚════════════════════════════════════════════════════════════════════════════╝');

  const results = [];

  for (const testCase of TEST_CASES) {
    // Test WITHOUT position interactions
    const withoutResult = await runTest(testCase, false);

    // Small delay to avoid rate limiting
    await new Promise(resolve => setTimeout(resolve, 2000));

    // Test WITH position interactions
    const withResult = await runTest(testCase, true);

    // Compare results
    console.log(`\n${'─'.repeat(80)}`);
    console.log(`COMPARISON FOR: ${testCase.id}`);
    console.log(`${'─'.repeat(80)}\n`);

    if (withoutResult.success && withResult.success) {
      const improvements = {};
      let totalImprovement = 0;

      Object.keys(QUALITY_METRICS).forEach(key => {
        const without = withoutResult.metrics[key];
        const with_ = withResult.metrics[key];
        const improvement = with_ - without;
        const improvementPct = without > 0 ? ((improvement / without) * 100).toFixed(1) : (with_ > 0 ? '∞' : '0');

        improvements[key] = {
          without,
          with: with_,
          improvement,
          improvementPct,
        };

        if (typeof improvementPct === 'number') {
          totalImprovement += parseFloat(improvementPct);
        }

        const symbol = improvement > 0 ? '✅' : improvement < 0 ? '❌' : '➖';
        console.log(`${symbol} ${QUALITY_METRICS[key].name}:`);
        console.log(`   Without: ${without} | With: ${with_} | Δ: ${improvement > 0 ? '+' : ''}${improvement} (${improvementPct}%)`);
      });

      console.log(`\nLength: ${withoutResult.length} → ${withResult.length} (Δ: ${withResult.length - withoutResult.length})`);

      results.push({
        testCase: testCase.id,
        success: true,
        improvements,
        lengthChange: withResult.length - withoutResult.length,
      });
    } else {
      results.push({
        testCase: testCase.id,
        success: false,
        error: !withoutResult.success ? withoutResult.error : withResult.error,
      });
    }

    // Delay before next test case
    await new Promise(resolve => setTimeout(resolve, 3000));
  }

  // Final summary
  console.log(`\n\n${'═'.repeat(80)}`);
  console.log('FINAL SUMMARY');
  console.log(`${'═'.repeat(80)}\n`);

  const successfulTests = results.filter(r => r.success);
  const failedTests = results.filter(r => !r.success);

  console.log(`Total Tests: ${TEST_CASES.length}`);
  console.log(`Successful: ${successfulTests.length} ✅`);
  console.log(`Failed: ${failedTests.length} ${failedTests.length > 0 ? '❌' : ''}\n`);

  if (successfulTests.length > 0) {
    // Calculate average improvements
    const metricKeys = Object.keys(QUALITY_METRICS);
    const avgImprovements = {};

    metricKeys.forEach(key => {
      const improvements = successfulTests.map(r => r.improvements[key].improvement);
      const avg = improvements.reduce((a, b) => a + b, 0) / improvements.length;
      avgImprovements[key] = avg.toFixed(2);
    });

    console.log('AVERAGE IMPROVEMENTS:');
    metricKeys.forEach(key => {
      const avg = avgImprovements[key];
      const symbol = avg > 0 ? '✅' : avg < 0 ? '❌' : '➖';
      console.log(`${symbol} ${QUALITY_METRICS[key].name}: ${avg > 0 ? '+' : ''}${avg}`);
    });

    // Overall verdict
    const positiveImprovements = Object.values(avgImprovements).filter((v: string) => parseFloat(v) > 0).length;
    const totalMetrics = metricKeys.length;
    const successRateNum = (positiveImprovements / totalMetrics) * 100;
    const successRate = successRateNum.toFixed(1);

    console.log(`\n${'═'.repeat(80)}`);
    console.log(`VERDICT: ${successRate}% of metrics improved`);

    if (successRateNum >= 75) {
      console.log('✅ FASE 2 ENHANCEMENT: **EXCELLENT** - Position interactions significantly improve quality');
    } else if (successRateNum >= 50) {
      console.log('⚠️  FASE 2 ENHANCEMENT: **GOOD** - Position interactions show moderate improvement');
    } else {
      console.log('❌ FASE 2 ENHANCEMENT: **NEEDS REVIEW** - Position interactions need refinement');
    }
    console.log(`${'═'.repeat(80)}\n`);
  }

  if (failedTests.length > 0) {
    console.log('\nFAILED TESTS:');
    failedTests.forEach(r => {
      console.log(`❌ ${r.testCase}: ${r.error}`);
    });
  }
}

// Check for Gemini API key
if (!process.env.GEMINI_API_KEY) {
  console.error('ERROR: GEMINI_API_KEY environment variable not set');
  console.error('Please set it with: export GEMINI_API_KEY=your_key_here');
  process.exit(1);
}

main().catch(console.error);
