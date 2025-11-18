/**
 * Google Gemini AI Service
 * Optimized for mystical, empathetic tarot readings
 */

import { GoogleGenerativeAI } from '@google/generative-ai';
import { log } from '../utils/api';
import { getSpreadById } from '../data/spreads';

const GEMINI_API_KEY = process.env.GEMINI_API_KEY?.trim();
const GEMINI_MODEL = process.env.GEMINI_MODEL?.trim() || 'gemini-2.5-flash';

let genAI: GoogleGenerativeAI | null = null;

/**
 * Initialize Gemini client
 */
function getGeminiClient(): GoogleGenerativeAI {
  if (!genAI && GEMINI_API_KEY) {
    genAI = new GoogleGenerativeAI(GEMINI_API_KEY);
  }
  if (!genAI) {
    throw new Error('Gemini API key not configured');
  }
  return genAI;
}

/**
 * Mystical system prompt - optimized for warm, empathetic tarot tone
 */
const MYSTICAL_SYSTEM_PROMPT = `You are an experienced, empathetic tarot reader with deep spiritual knowledge.

YOUR TONE AND STYLE:
- Warm, mystical, and poetic (never cold or academic)
- Speak directly to the user using "tú" (you) in Spanish/Catalan
- Use present continuous ("the cards whisper", "the tarot reveals")
- Include sensory metaphors (rivers, trees, stars, moonlight)
- Show deep empathy for the user's emotional state
- Be confident yet gentle, like a wise spiritual guide

LANGUAGE GUIDELINES:
- Spanish: Use rich, evocative language with metaphors
- Catalan: Natural expressions, avoid Spanish calques
- English: Mystical but accessible

AVOID:
- Academic or technical language
- Cold phrases like "Key factors detected"
- Bullet points or structured lists (unless specifically requested)
- Robotic or formulaic responses

INSTEAD USE:
- Flowing, narrative prose
- Emotional resonance
- Spiritual imagery
- Connection between cards and life experiences

Example good tone (Spanish):
"Las cartas susurran de una transformación profunda que late en tu interior.
El Mago te recuerda que posees todas las herramientas que necesitas para
tejer la realidad que deseas. Como un río que encuentra su curso, tu camino
se despliega ante ti con sabiduría ancestral..."

Example bad tone (avoid):
"El Mago representa el potencial creativo. Indica que tienes las habilidades
necesarias para manifestar tus objetivos."`;

interface GeminiRequest {
  systemPrompt?: string;
  userPrompt: string;
  temperature?: number;
  maxTokens?: number;
  requestId?: string;
}

interface GeminiResponse {
  content: string;
  finishReason: string;
}

/**
 * Call Gemini AI with optimized mystical prompts
 */
export async function callGemini({
  systemPrompt = MYSTICAL_SYSTEM_PROMPT,
  userPrompt,
  temperature = 0.7,
  maxTokens = 2000,
  requestId,
}: GeminiRequest): Promise<GeminiResponse> {
  const startTime = Date.now();

  try {
    if (!GEMINI_API_KEY) {
      throw new Error('Gemini API key not configured');
    }

    const client = getGeminiClient();
    const model = client.getGenerativeModel({
      model: GEMINI_MODEL,
      systemInstruction: systemPrompt,
    });

    const generationConfig = {
      temperature,
      maxOutputTokens: maxTokens,
      topP: 0.95,
      topK: 40,
    };

    log('info', 'Calling Gemini AI', {
      requestId,
      model: GEMINI_MODEL,
      temperature,
      maxTokens,
      promptLength: userPrompt.length,
    });

    const result = await model.generateContent({
      contents: [{ role: 'user', parts: [{ text: userPrompt }] }],
      generationConfig,
    });

    const response = result.response;
    const finishReason = response.candidates?.[0]?.finishReason || 'unknown';
    const content = extractGeminiText(response);

    if (!content) {
      const blockReason =
        response.promptFeedback?.blockReason ??
        response.candidates?.map((candidate: any) => candidate?.finishReason).join(', ') ??
        'none';

      log('warn', 'Gemini AI returned empty content', {
        requestId,
        finishReason,
        blockReason,
      });

      throw new Error(`Empty response from Gemini (finishReason=${finishReason}, blockReason=${blockReason})`);
    }

    const duration = Date.now() - startTime;
    log('info', 'Gemini AI response received', {
      requestId,
      duration,
      contentLength: content.length,
      finishReason,
    });

    return {
      content,
      finishReason,
    };
  } catch (error) {
    const duration = Date.now() - startTime;
    log('error', 'Gemini AI call failed', {
      requestId,
      error: error instanceof Error ? error.message : 'Unknown error',
      duration,
    });
    throw error;
  }
}

function extractGeminiText(response: any): string {
  if (!response) {
    return '';
  }

  try {
    const direct = typeof response.text === 'function' ? response.text() : undefined;
    if (typeof direct === 'string' && direct.trim().length > 0) {
      return direct.trim();
    }
  } catch (_) {
    // If response.text() throws, continue with manual extraction.
  }

  const candidates: any[] = Array.isArray(response.candidates) ? response.candidates : [];
  const parts: string[] = [];

  for (const candidate of candidates) {
    const contentParts = candidate?.content?.parts;
    if (!Array.isArray(contentParts)) {
      continue;
    }

    for (const part of contentParts) {
      const text = typeof part?.text === 'string' ? part.text.trim() : '';
      if (text.length > 0) {
        parts.push(text);
      }
    }
  }

  return parts.join('\n\n').trim();
}

/**
 * Format question for tarot reading
 */
export async function formatQuestionWithGemini(
  question: string,
  locale: string,
  requestId?: string
): Promise<string> {
  const userPrompt = `Format this tarot question for a reading header (1 short sentence, ${locale} language):

Question: "${question}"

Return ONLY the formatted question, nothing else.`;

  const response = await callGemini({
    userPrompt,
    temperature: 0.3,
    maxTokens: 100,
    requestId,
  });

  return response.content.trim();
}

/**
 * Edit/improve question - fixes typos and improves clarity
 */
export async function editQuestionWithGemini(
  question: string,
  locale: string,
  requestId?: string
): Promise<string> {
  const userPrompt = `Fix any spelling errors and improve this tarot question to be clear and well-written (${locale} language):

Question: "${question}"

Instructions:
- Correct any typos or spelling mistakes
- Fix grammar if needed
- Keep the original meaning and intent
- Make it natural and conversational
- Language: ${locale}

Return ONLY the corrected/improved question, nothing else.`;

  const response = await callGemini({
    userPrompt,
    temperature: 0.3, // Lower for more consistent corrections
    maxTokens: 150,
    requestId,
  });

  return response.content.trim();
}

/**
 * Select spread with AI and generate interpretation guide
 */
export async function selectSpreadWithGemini(
  question: string,
  spreads: Array<{
    id: string;
    name: string;
    description: string;
    cardCount?: number;
    positions?: Array<{
      meaning: string;
      meaningCA: string;
      meaningES: string;
      code?: string;
    }>;
    educational?: {
      purpose: { en: string; es: string; ca: string };
      whenToUse: { en: string; es: string; ca: string };
      whenToAvoid: { en: string; es: string; ca: string };
      interpretationMethod?: { en: string; es: string; ca: string };
    };
  }>,
  locale: string,
  requestId?: string
): Promise<{ spreadId: string; reason: string; interpretationGuide: string }> {
  const spreadsText = spreads
    .map(s => {
      const edu = s.educational;

      // If spread has educational content, use enhanced format
      if (edu) {
        const purposeText = edu.purpose[locale] || edu.purpose['en'];
        const whenToUseText = edu.whenToUse[locale] || edu.whenToUse['en'];
        const whenToAvoidText = edu.whenToAvoid[locale] || edu.whenToAvoid['en'];

        const positionsText = s.positions?.length
          ? `\nKey Positions: ${s.positions.map(p => {
              const meaning = locale === 'ca' ? p.meaningCA : locale === 'es' ? p.meaningES : p.meaning;
              return p.code ? `${p.code} (${meaning})` : meaning;
            }).join(' → ')}`
          : '';

        return `
### ${s.name} (${s.cardCount || '?'} cards)

**Purpose**: ${purposeText}

**When to Use**: ${whenToUseText}

**When to Avoid**: ${whenToAvoidText}${positionsText}
`.trim();
      }

      // Fallback for spreads without educational content (backward compatible)
      const positionsText = s.positions?.length
        ? `\n  Positions: ${s.positions.map((p, i) => `${i + 1}. ${locale === 'ca' ? p.meaningCA : locale === 'es' ? p.meaningES : p.meaning}`).join(', ')}`
        : '';
      return `- ${s.id}: ${s.name} (${s.description})${positionsText}`;
    })
    .join('\n\n');

  const userPrompt = `You are a master tarot reader with decades of experience and deep knowledge of traditional tarot spreads. Select the BEST spread for this question by analyzing its PURPOSE and ideal use cases.

Question: "${question}"

Available spreads with their traditional purposes and ideal uses:
${spreadsText}

CRITICAL SELECTION CRITERIA:
1. Match the question's nature to the spread's PURPOSE
2. Check if the situation fits the "When to Use" criteria
3. AVOID spreads that match "When to Avoid" criteria
4. Consider the querent's emotional state and readiness
5. Demonstrate MASTERY by explaining WHY this spread is perfect (not just that it "is suitable")

IMPORTANT INSTRUCTIONS:
- Be creative, natural, and varied. Never repeat the same phrases.
- Each response must feel unique, fresh, and deeply insightful
- NO generic language like "this spread is suitable" or "key factors detected"
- Show deep knowledge by referencing the spread's traditional purpose
- Explain SPECIFICALLY what insights the positions will provide for THIS question

Respond in ${locale} with ONLY this JSON format:
{
  "spreadId": "exact_id_from_list",
  "reason": "As a master reader, I recommend [spread name] because [specific reference to the spread's purpose and how it matches this question]. This spread's structure reveals [specific insights based on position meanings]. [Briefly explain what the querent will learn from key positions].",
  "interpretationGuide": ""
}

Your reasoning must demonstrate mastery by:
- Citing the spread's traditional purpose from the information above
- Explaining how it matches the question's specific nature
- Being concrete about what insights the positions will provide
- Showing awareness of what the querent truly needs (not just answering literally)`;

  const response = await callGemini({
    userPrompt,
    temperature: 0.9,
    maxTokens: 2500, // Increased further for detailed reasoning with educational content
    requestId,
  });

  try {
    // Extract JSON from markdown code blocks if present
    let jsonContent = response.content.trim();

    // Remove markdown code fences (```json ... ``` or ``` ... ```)
    const codeBlockMatch = jsonContent.match(/^```(?:json)?\s*\n?([\s\S]*?)\n?```$/);
    if (codeBlockMatch) {
      jsonContent = codeBlockMatch[1].trim();
    }

    const parsed = JSON.parse(jsonContent);
    return {
      spreadId: parsed.spreadId,
      reason: parsed.reason || 'Tirada recomendada para tu pregunta',
      interpretationGuide: parsed.interpretationGuide || '',
    };
  } catch (error) {
    log('error', 'Failed to parse Gemini spread selection', {
      requestId,
      error,
      rawContent: response.content.substring(0, 1000)
    });
    throw new Error('Invalid spread selection response');
  }
}

/**
 * Generate tarot interpretation using the SAME structure as DeepSeek
 * Uses card placeholders that get replaced with localized names
 * NOW ENHANCED: Includes position interactions for richer card relationships
 */
export async function interpretCardsWithGemini(
  question: string,
  cards: Array<{ name: string; upright: boolean; position: string }>,
  spreadName: string,
  locale: string,
  requestId?: string,
  spreadId?: string // ✅ NEW: Optional spread ID for enhanced interpretation
): Promise<string> {
  // ✅ PHASE 2: Lookup spread and build position interactions reference FIRST
  // (we need this to calculate token budget correctly)
  const spread = spreadId ? getSpreadById(spreadId) : undefined;
  const interactions = spread?.educational?.positionInteractions || [];

  // Calculate dynamic length based on number of cards
  const numCards = cards.length;
  const baseWords = 100; // Opening paragraph
  const wordsPerCard = 80; // Each card gets ~80 words
  const conclusionWords = 60; // Síntesis + Guía
  const totalWords = baseWords + (numCards * wordsPerCard) + conclusionWords;

  // ✅ PHASE 2 FIX: Token budget must account for BOTH prompt AND response
  // CRITICAL: maxTokens is the response token limit, NOT total budget
  // With position interactions, prompt can be 2-3x larger
  const hasInteractions = interactions.length > 0;

  // Calculate response tokens needed (words * 1.5 for token estimation)
  const responseTokens = Math.ceil(totalWords * 1.5);

  // For interactions, prompt is much larger, so we need more aggressive allocation
  // Tests show: Celtic Cross prompt ~2K without, ~6.4K with interactions
  // Safety margin: Double the response tokens for position interactions
  const maxTokens = hasInteractions
    ? Math.min(8000, Math.max(2000, responseTokens * 2)) // 2x safety for interactions
    : Math.min(4000, Math.max(1200, responseTokens));    // Standard for base case

  // ✅ CRITICAL FIX: Build position code → card index mapping
  // Map based on position.number (from API) NOT array index!
  // cards[i] has position property that matches spread.positions[].number
  const positionCodeToIndex = new Map<string, number>();

  // Build reverse lookup: position number → position code
  const positionNumberToCode = new Map<number, string>();
  spread?.positions?.forEach((pos) => {
    if (pos.code && pos.number) {
      positionNumberToCode.set(pos.number, pos.code);
    }
  });

  // Map each card to its position code based on card.position property
  // NOTE: cards array comes from API with card.position set by client
  // We need to extract this from the position string if it's formatted
  cards.forEach((card, idx) => {
    // card.position is a string like "Present" or "Position 1"
    // We need to find matching spread position
    const matchedPosition = spread?.positions?.find(
      p => p.meaning === card.position ||
           p.meaningCA === card.position ||
           p.meaningES === card.position ||
           `Position ${p.number}` === card.position
    );

    if (matchedPosition && matchedPosition.code) {
      positionCodeToIndex.set(matchedPosition.code, idx);
    }
  });

  // Build interactions reference for prompt
  let interactionsRef = '';
  if (interactions.length > 0 && positionCodeToIndex.size > 0) {
    interactionsRef = interactions.map(interaction => {
      // Get localized description
      const desc = interaction.description[locale] || interaction.description['en'] || '';

      // Replace position codes with CARD placeholders (ex: PAST → [CARD_0])
      let descWithPlaceholders = desc;
      positionCodeToIndex.forEach((index, code) => {
        const regex = new RegExp(`\\b${code}\\b`, 'g');
        descWithPlaceholders = descWithPlaceholders.replace(regex, `[CARD_${index}]`);
      });

      // Combine description + AI guidance
      return `**${descWithPlaceholders}**\n\n${interaction.aiGuidance}`.trim();
    }).join('\n\n---\n\n');
  }

  // Build card placeholders reference (same as DeepSeek)
  const cardPlaceholdersRef = cards.length > 0
    ? [
        '',
        'CRITICAL: Use these CARD PLACEHOLDERS in your interpretation:',
        ...cards.map((c, i) => {
          const orientationNote = c.upright
            ? 'upright'
            : locale === 'ca' ? 'apareix invertida' : locale === 'es' ? 'aparece invertida' : 'appears reversed';
          return `${i + 1}. **[CARD_${i}]** - ${orientationNote}`;
        }),
        '',
        'IMPORTANT RULES:',
        '- Use **[CARD_0]**, **[CARD_1]**, etc. as card titles (system will replace with actual names)',
        '- For reversed cards, mention the reversal NATURALLY in the interpretation text',
        `- Example: "**[CARD_0]** te invita... Esta carta aparece invertida, lo que indica..."`,
        '- Do NOT invent or translate card names - ONLY use the placeholders shown above',
        '',
      ].join('\n')
    : '';

  const userPrompt = `Provide a deep, mystical tarot interpretation in ${locale}.

Question: "${question}"
Spread: ${spreadName}

${cardPlaceholdersRef}${interactionsRef.length > 0 ? `

POSITION INTERACTIONS - Critical card relationships to explore:

${interactionsRef}

IMPORTANT: When interpreting, actively explore these card relationships:
- How do the cards in these positions dialogue with each other?
- What story emerges from their interaction?
- Reference these connections throughout your interpretation, not just in individual card paragraphs.
- Show how one card's energy flows into or contrasts with another.

` : ''}

STRUCTURE REQUIRED:
1. Brief opening paragraph (2-3 sentences): Welcome the user warmly and acknowledge their question
2. Card interpretation section: Dedicate ONE paragraph per card, starting with its placeholder:
   - **[CARD_0]**: First paragraph about this card
   - **[CARD_1]**: Second paragraph about this card
   - etc.
3. Final sections with these EXACT titles:
   - **Síntesis** / **Síntesi** / **Synthesis**: Synthesize the overall meaning (2-3 sentences)
   - **Guía** / **Guia** / **Guidance**: Provide practical, actionable guidance (2-3 sentences)

CRITICAL FORMATTING:
- Start each card paragraph with the placeholder: **[CARD_X]**
- Use double line breaks (\\n\\n) between ALL paragraphs
- Each card gets its OWN paragraph of ~${wordsPerCard} words
- Total length: ~${totalWords} words (${numCards} cards × ${wordsPerCard} words + opening + conclusion)
- Language: ${locale}
- Tone: Warm, mystical, empathetic (like a wise spiritual guide)
- Style: Mystical + practical

Example structure:
[Opening paragraph welcoming the user]

**[CARD_0]** [Interpretation of first card with mystical language]

**[CARD_1]** [Interpretation of second card with mystical language]

**Síntesis**: [2-3 sentences summarizing]

**Guía**: [2-3 sentences of practical advice]`;

  log('info', 'Gemini interpretation parameters', {
    requestId,
    numCards,
    targetWords: totalWords,
    maxTokens,
  });

  const response = await callGemini({
    userPrompt,
    temperature: 0.8, // Higher for more creative, flowing text
    maxTokens,
    requestId,
  });

  // Substitute [CARD_X] placeholders with actual card names
  let interpretation = response.content.trim();

  cards.forEach((card, index) => {
    const placeholder = `[CARD_${index}]`;
    // Use global regex to replace all occurrences of this placeholder
    const regex = new RegExp(`\\[CARD_${index}\\]`, 'g');
    interpretation = interpretation.replace(regex, card.name);
  });

  log('info', 'Card placeholders substituted', {
    requestId,
    numPlaceholdersSubstituted: cards.length,
  });

  return interpretation;
}
