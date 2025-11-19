/**
 * PoC Tests: Educational Content Enhances AI Spread Selection
 *
 * These tests validate that educational content improves:
 * 1. Selection accuracy (right spread for right question)
 * 2. Reasoning quality (specific, demonstrates mastery, not generic)
 * 3. Multilingual consistency
 */

import { selectSpreadWithGemini } from '../../lib/services/gemini-ai';
import { SPREADS } from '../../lib/data/spreads';

// Helper to check if API key is available
const hasGeminiKey = !!process.env.GEMINI_API_KEY?.trim();

// Skip tests if no API key (integration tests only run when key is available)
const describeIfGemini = hasGeminiKey ? describe : describe.skip;

describeIfGemini('PoC: Educational Content Enhances Selection', () => {
  // Increase timeout for real API calls
  jest.setTimeout(15000);

  describe('Selection Accuracy', () => {
    it('selects Three Card for timeline/progression questions', async () => {
      const question = "How did I get here and where am I heading?";

      const result = await selectSpreadWithGemini(question, SPREADS, 'en');

      expect(result.spreadId).toBe('three_card');
    });

    it('selects Three Card for daily guidance questions', async () => {
      const question = "What do I need to know today?";

      const result = await selectSpreadWithGemini(question, SPREADS, 'en');

      // Should select simple spread (single or three_card)
      expect(['single', 'three_card']).toContain(result.spreadId);
    });

    it('selects Three Card for understanding current situation', async () => {
      const question = "Help me understand what's happening in my life right now";

      const result = await selectSpreadWithGemini(question, SPREADS, 'en');

      expect(result.spreadId).toBe('three_card');
    });

    it('avoids Three Card for complex multi-factor situations', async () => {
      const question = "I'm dealing with career crisis, relationship problems, family issues, and financial stress all at the same time. What should I do?";

      const result = await selectSpreadWithGemini(question, SPREADS, 'en');

      // Should NOT select three_card (too simple for this complexity)
      expect(result.spreadId).not.toBe('three_card');

      // Should select comprehensive spread like celtic_cross or horseshoe
      expect(['celtic_cross', 'horseshoe', 'five_card_cross']).toContain(result.spreadId);
    });

    it('avoids Three Card for yes/no questions', async () => {
      const question = "Should I call my friend today?";

      const result = await selectSpreadWithGemini(question, SPREADS, 'en');

      // Should select single card for yes/no
      expect(result.spreadId).toBe('single');
    });

    it('selects appropriate spread for love questions', async () => {
      const question = "What's the dynamic between me and my partner?";

      const result = await selectSpreadWithGemini(question, SPREADS, 'en');

      // Should select relationship spread or three_card
      expect(['relationship', 'three_card']).toContain(result.spreadId);
    });

    it('selects appropriate spread for binary decisions', async () => {
      const question = "Should I take job A or job B?";

      const result = await selectSpreadWithGemini(question, SPREADS, 'en');

      // Should select two_card for binary choice
      expect(['two_card', 'three_card']).toContain(result.spreadId);
    });
  });

  describe('Reasoning Quality - Demonstrates Mastery', () => {
    it('reasoning references spread purpose or key concepts', async () => {
      const question = "How did I get here and where am I heading?";

      const result = await selectSpreadWithGemini(question, SPREADS, 'en');

      expect(result.spreadId).toBe('three_card');

      const reasoning = result.reason.toLowerCase();

      // Should mention concepts from the purpose/whenToUse
      const keyPhrases = [
        'flow',
        'time',
        'narrative',
        'progression',
        'timeline',
        'past',
        'present',
        'future',
        'arc',
        'causation',
      ];

      const matchesAny = keyPhrases.some(phrase => reasoning.includes(phrase));
      expect(matchesAny).toBe(true);
    });

    it('reasoning is substantive (>100 words)', async () => {
      const question = "What's happening in my life right now?";

      const result = await selectSpreadWithGemini(question, SPREADS, 'en');

      // Count words in reasoning
      const wordCount = result.reason.split(/\s+/).length;
      expect(wordCount).toBeGreaterThan(100);
    });

    it('reasoning is NOT generic', async () => {
      const question = "Help me understand my situation";

      const result = await selectSpreadWithGemini(question, SPREADS, 'en');

      // Should NOT contain generic phrases
      expect(result.reason).not.toMatch(/this spread is suitable/i);
      expect(result.reason).not.toMatch(/key factors detected/i);
      expect(result.reason).not.toMatch(/this spread will help you/i);
      expect(result.reason).not.toMatch(/appropriate for your question/i);
    });

    it('reasoning explains WHAT insights will be revealed', async () => {
      const question = "Where is my life heading?";

      const result = await selectSpreadWithGemini(question, SPREADS, 'en');

      const reasoning = result.reason.toLowerCase();

      // Should mention what positions will reveal
      const insightPhrases = [
        'reveal',
        'show',
        'illuminate',
        'insight',
        'understand',
        'see',
        'discover',
      ];

      const mentionsInsights = insightPhrases.some(phrase => reasoning.includes(phrase));
      expect(mentionsInsights).toBe(true);
    });

    it('reasoning references position meanings', async () => {
      const question = "How did I get here?";

      const result = await selectSpreadWithGemini(question, SPREADS, 'en');

      expect(result.spreadId).toBe('three_card');

      const reasoning = result.reason.toLowerCase();

      // Should mention PAST, PRESENT, or FUTURE positions
      const mentionsPositions =
        reasoning.includes('past') ||
        reasoning.includes('present') ||
        reasoning.includes('future');

      expect(mentionsPositions).toBe(true);
    });
  });

  describe('Multilingual Consistency', () => {
    it('selects same spread for equivalent questions in different languages', async () => {
      const questionEN = "How did I get here and where am I heading?";
      const questionES = "¿Cómo llegué aquí y hacia dónde me dirijo?";
      const questionCA = "Com vaig arribar aquí i cap on em dirigeixo?";

      const [resultEN, resultES, resultCA] = await Promise.all([
        selectSpreadWithGemini(questionEN, SPREADS, 'en'),
        selectSpreadWithGemini(questionES, SPREADS, 'es'),
        selectSpreadWithGemini(questionCA, SPREADS, 'ca'),
      ]);

      // All should select three_card
      expect(resultEN.spreadId).toBe('three_card');
      expect(resultES.spreadId).toBe('three_card');
      expect(resultCA.spreadId).toBe('three_card');
    });

    it('reasoning is in correct language (Spanish)', async () => {
      const question = "¿Cómo llegué aquí?";

      const result = await selectSpreadWithGemini(question, SPREADS, 'es');

      // Reasoning should contain Spanish text
      // Check for common Spanish words
      const containsSpanish =
        result.reason.includes('pasado') ||
        result.reason.includes('presente') ||
        result.reason.includes('futuro') ||
        result.reason.includes('porque') ||
        result.reason.includes('tirada');

      expect(containsSpanish).toBe(true);
    });

    it('reasoning is in correct language (Catalan)', async () => {
      const question = "Com vaig arribar aquí?";

      const result = await selectSpreadWithGemini(question, SPREADS, 'ca');

      // Reasoning should contain Catalan text
      // Check for common Catalan words
      const containsCatalan =
        result.reason.includes('passat') ||
        result.reason.includes('present') ||
        result.reason.includes('futur') ||
        result.reason.includes('perquè') ||
        result.reason.includes('tirada');

      expect(containsCatalan).toBe(true);
    });
  });

  describe('Edge Cases', () => {
    it('handles vague questions appropriately', async () => {
      const question = "I need help";

      const result = await selectSpreadWithGemini(question, SPREADS, 'en');

      // Should select simple, general spread
      expect(['single', 'three_card']).toContain(result.spreadId);
    });

    it('handles very long questions', async () => {
      const question = "I'm going through a really difficult time. I lost my job three months ago, my relationship is falling apart because of the stress, my family doesn't understand what I'm going through, and I'm worried about money constantly. I don't know what to do or where to turn. Everything feels overwhelming and I can't see a way forward. What should I focus on?";

      const result = await selectSpreadWithGemini(question, SPREADS, 'en');

      // Should select comprehensive spread for complex situation
      expect(['celtic_cross', 'horseshoe']).toContain(result.spreadId);

      // Reasoning should still be substantive
      const wordCount = result.reason.split(/\s+/).length;
      expect(wordCount).toBeGreaterThan(80);
    });

    it('handles spiritual/growth questions', async () => {
      const question = "What spiritual lessons am I meant to learn right now?";

      const result = await selectSpreadWithGemini(question, SPREADS, 'en');

      // Should select spiritual-oriented spread
      expect(['star', 'three_card', 'astrological']).toContain(result.spreadId);
    });
  });
});

// Unit tests (don't require API key) - test data structure
describe('PoC: Data Structure Validation', () => {
  it('Three Card spread has educational content', () => {
    const threeCard = SPREADS.find(s => s.id === 'three_card');

    expect(threeCard).toBeDefined();
    expect(threeCard?.educational).toBeDefined();
    expect(threeCard?.educational?.purpose).toBeDefined();
    expect(threeCard?.educational?.whenToUse).toBeDefined();
    expect(threeCard?.educational?.whenToAvoid).toBeDefined();
  });

  it('Three Card educational content is multilingual', () => {
    const threeCard = SPREADS.find(s => s.id === 'three_card');
    const edu = threeCard?.educational;

    expect(edu?.purpose.en).toBeDefined();
    expect(edu?.purpose.es).toBeDefined();
    expect(edu?.purpose.ca).toBeDefined();

    expect(edu?.whenToUse.en).toBeDefined();
    expect(edu?.whenToUse.es).toBeDefined();
    expect(edu?.whenToUse.ca).toBeDefined();

    expect(edu?.whenToAvoid.en).toBeDefined();
    expect(edu?.whenToAvoid.es).toBeDefined();
    expect(edu?.whenToAvoid.ca).toBeDefined();
  });

  it('Three Card has semantic position codes', () => {
    const threeCard = SPREADS.find(s => s.id === 'three_card');

    expect(threeCard?.positions[0].code).toBe('PAST');
    expect(threeCard?.positions[1].code).toBe('PRESENT');
    expect(threeCard?.positions[2].code).toBe('FUTURE');
  });

  it('Three Card has animation indices', () => {
    const threeCard = SPREADS.find(s => s.id === 'three_card');

    expect(threeCard?.positions[0].index).toBe(0);
    expect(threeCard?.positions[1].index).toBe(1);
    expect(threeCard?.positions[2].index).toBe(2);
  });

  it('educational content has position interactions', () => {
    const threeCard = SPREADS.find(s => s.id === 'three_card');
    const interactions = threeCard?.educational?.positionInteractions;

    expect(interactions).toBeDefined();
    expect(interactions?.length).toBeGreaterThan(0);

    // Check structure of first interaction
    const firstInteraction = interactions?.[0];
    expect(firstInteraction?.description).toBeDefined();
    expect(firstInteraction?.positions).toBeDefined();
    expect(firstInteraction?.aiGuidance).toBeDefined();
  });

  it('educational content has AI selection criteria', () => {
    const threeCard = SPREADS.find(s => s.id === 'three_card');
    const criteria = threeCard?.educational?.aiSelectionCriteria;

    expect(criteria).toBeDefined();
    expect(criteria?.questionPatterns).toBeDefined();
    expect(criteria?.questionPatterns.length).toBeGreaterThan(0);
    expect(criteria?.emotionalStates).toBeDefined();
    expect(criteria?.preferWhen).toBeDefined();
  });

  it('educational content text is substantive', () => {
    const threeCard = SPREADS.find(s => s.id === 'three_card');
    const edu = threeCard?.educational;

    // Purpose should be 50-80 words
    const purposeWords = edu?.purpose.en.split(/\s+/).length || 0;
    expect(purposeWords).toBeGreaterThan(40);
    expect(purposeWords).toBeLessThan(100);

    // WhenToUse should be 80-120 words
    const whenToUseWords = edu?.whenToUse.en.split(/\s+/).length || 0;
    expect(whenToUseWords).toBeGreaterThan(70);
    expect(whenToUseWords).toBeLessThan(150);

    // InterpretationMethod should be 120-200 words
    const methodWords = edu?.interpretationMethod.en.split(/\s+/).length || 0;
    expect(methodWords).toBeGreaterThan(100);
    expect(methodWords).toBeLessThan(250);
  });
});
