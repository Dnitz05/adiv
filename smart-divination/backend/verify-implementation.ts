/**
 * ULTRATHINK REVIEW: Verify Position Interactions Implementation
 */

const { SPREADS } = require('./lib/data/spreads');
const { SPREADS_EDUCATIONAL } = require('./lib/data/spreads-educational');

console.log('═══════════════════════════════════════════════════════════════');
console.log('ULTRATHINK REVIEW: Position Interactions Implementation');
console.log('═══════════════════════════════════════════════════════════════\n');

// 1. Verify all spreads have position codes
console.log('1. POSITION CODES VERIFICATION\n');
let totalPositions = 0;
let positionsWithCodes = 0;
const spreadsWithMissingCodes = [];

SPREADS.forEach(spread => {
  const positions = spread.positions || [];
  const withCodes = positions.filter(p => p.code).length;
  totalPositions += positions.length;
  positionsWithCodes += withCodes;

  if (withCodes < positions.length) {
    spreadsWithMissingCodes.push({
      id: spread.id,
      missing: positions.length - withCodes,
      total: positions.length
    });
  }
});

console.log(`Total positions: ${totalPositions}`);
console.log(`Positions with codes: ${positionsWithCodes} (${((positionsWithCodes/totalPositions)*100).toFixed(1)}%)`);
if (spreadsWithMissingCodes.length > 0) {
  console.log(`\n⚠️  Spreads with missing codes:`);
  spreadsWithMissingCodes.forEach(s => {
    console.log(`   - ${s.id}: ${s.missing}/${s.total} missing`);
  });
} else {
  console.log('✅ All positions have codes!');
}

// 2. Verify all spreads have educational content
console.log('\n\n2. EDUCATIONAL CONTENT VERIFICATION\n');
let spreadsWithEducational = 0;
let spreadsWithInteractions = 0;
let totalInteractions = 0;

SPREADS.forEach(spread => {
  if (spread.educational) {
    spreadsWithEducational++;
    if (spread.educational.positionInteractions && spread.educational.positionInteractions.length > 0) {
      spreadsWithInteractions++;
      totalInteractions += spread.educational.positionInteractions.length;
    }
  }
});

console.log(`Spreads with educational content: ${spreadsWithEducational}/${SPREADS.length}`);
console.log(`Spreads with position interactions: ${spreadsWithInteractions}/${SPREADS.length}`);
console.log(`Total interactions defined: ${totalInteractions}`);

// 3. Verify position code mapping consistency
console.log('\n\n3. POSITION CODE MAPPING CONSISTENCY\n');
const inconsistencies = [];

SPREADS.forEach(spread => {
  if (!spread.educational || !spread.educational.positionInteractions) return;

  const positionCodes = new Set(spread.positions.map(p => p.code).filter(Boolean));
  const usedCodes = new Set();

  spread.educational.positionInteractions.forEach(interaction => {
    interaction.positions.forEach(code => usedCodes.add(code));
  });

  // Check if all used codes exist in position definitions
  const invalidCodes = [...usedCodes].filter(code => !positionCodes.has(code));
  if (invalidCodes.length > 0) {
    inconsistencies.push({
      spreadId: spread.id,
      invalidCodes
    });
  }
});

if (inconsistencies.length > 0) {
  console.log('⚠️  Position code inconsistencies found:');
  inconsistencies.forEach(inc => {
    console.log(`   - ${inc.spreadId}: uses undefined codes: ${inc.invalidCodes.join(', ')}`);
  });
} else {
  console.log('✅ All interaction codes map to valid positions!');
}

// 4. Sample interaction example
console.log('\n\n4. SAMPLE INTERACTION EXAMPLE (Celtic Cross)\n');
const celtic = SPREADS.find(s => s.id === 'celtic_cross');
if (celtic && celtic.educational) {
  console.log(`Celtic Cross has ${celtic.educational.positionInteractions.length} interactions\n`);

  const firstInteraction = celtic.educational.positionInteractions[0];
  console.log('First interaction:');
  console.log(`  Description (EN): ${firstInteraction.description.en}`);
  console.log(`  Positions: ${firstInteraction.positions.join(', ')}`);
  console.log(`  AI Guidance: ${firstInteraction.aiGuidance.substring(0, 150)}...`);

  // Verify position code mapping
  console.log('\n  Position code mapping:');
  firstInteraction.positions.forEach(code => {
    const pos = celtic.positions.find(p => p.code === code);
    console.log(`    ${code} → Index ${pos?.index}, Meaning: ${pos?.meaning}`);
  });
}

// 5. Token budget analysis
console.log('\n\n5. TOKEN BUDGET ANALYSIS\n');
const sampleCounts = [1, 3, 5, 10]; // Single, Three Card, Relationship/Five Card, Celtic Cross
sampleCounts.forEach(numCards => {
  const baseWords = 100;
  const wordsPerCard = 80;
  const conclusionWords = 60;
  const totalWords = baseWords + (numCards * wordsPerCard) + conclusionWords;

  const baseMultiplier = 2.0;
  const interactionsMultiplier = 3.0;

  const baseTokens = Math.min(8000, Math.max(1200, Math.ceil(totalWords * baseMultiplier)));
  const interactionsTokens = Math.min(8000, Math.max(1200, Math.ceil(totalWords * interactionsMultiplier)));

  console.log(`${numCards} card(s):`);
  console.log(`  Target words: ${totalWords}`);
  console.log(`  Tokens (base): ${baseTokens}`);
  console.log(`  Tokens (with interactions): ${interactionsTokens} (+${interactionsTokens - baseTokens})`);
});

// 6. Check for multilingual consistency
console.log('\n\n6. MULTILINGUAL CONSISTENCY CHECK\n');
let multilingualIssues = [];

Object.entries(SPREADS_EDUCATIONAL).forEach(([key, content]) => {
  const interactions = content.positionInteractions || [];
  interactions.forEach((int, idx) => {
    const hasEn = int.description.en && int.description.en.length > 0;
    const hasEs = int.description.es && int.description.es.length > 0;
    const hasCa = int.description.ca && int.description.ca.length > 0;

    if (!hasEn || !hasEs || !hasCa) {
      multilingualIssues.push({
        spread: key,
        interaction: idx,
        missing: [!hasEn && 'en', !hasEs && 'es', !hasCa && 'ca'].filter(Boolean)
      });
    }
  });
});

if (multilingualIssues.length > 0) {
  console.log(`⚠️  Found ${multilingualIssues.length} interactions with missing translations:`);
  multilingualIssues.slice(0, 5).forEach(issue => {
    console.log(`   - ${issue.spread} interaction ${issue.interaction}: missing ${issue.missing.join(', ')}`);
  });
} else {
  console.log('✅ All interactions have complete translations (en/es/ca)!');
}

// 7. Summary
console.log('\n\n═══════════════════════════════════════════════════════════════');
console.log('SUMMARY');
console.log('═══════════════════════════════════════════════════════════════\n');

const allChecks = [
  { name: 'Position codes', passed: spreadsWithMissingCodes.length === 0 },
  { name: 'Educational content', passed: spreadsWithEducational === SPREADS.length },
  { name: 'Position interactions', passed: spreadsWithInteractions > 0 },
  { name: 'Code consistency', passed: inconsistencies.length === 0 },
  { name: 'Multilingual content', passed: multilingualIssues.length === 0 }
];

allChecks.forEach(check => {
  const symbol = check.passed ? '✅' : '❌';
  console.log(`${symbol} ${check.name}`);
});

const allPassed = allChecks.every(c => c.passed);
console.log(`\n${allPassed ? '🎉 ALL CHECKS PASSED!' : '⚠️  Some checks failed - review needed'}`);
console.log('═══════════════════════════════════════════════════════════════\n');
