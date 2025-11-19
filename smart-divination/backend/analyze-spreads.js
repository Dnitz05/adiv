const { SPREADS } = require('./lib/data/spreads');

const pending = SPREADS.filter(s => s.id !== 'three_card');

console.log('SPREADS PENDENTS (sorted by priority):\n');

pending
  .sort((a, b) => {
    // Prioritize: freemium > simple > card count
    if (a.isFreemium !== b.isFreemium) return a.isFreemium ? -1 : 1;
    if (a.complexity !== b.complexity) {
      const order = { simple: 0, medium: 1, complex: 2 };
      return order[a.complexity] - order[b.complexity];
    }
    return a.cardCount - b.cardCount;
  })
  .forEach((s, i) => {
    const freemium = s.isFreemium ? 'YES' : 'NO ';
    console.log(`${String(i+1).padStart(2)}. ${s.id.padEnd(18)} | ${String(s.cardCount).padStart(2)} cards | ${s.complexity.padEnd(8)} | freemium: ${freemium} | ${s.category}`);
  });
