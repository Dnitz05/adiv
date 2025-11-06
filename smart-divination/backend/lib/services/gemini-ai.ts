/**
 * Google Gemini AI Service
 * Optimized for mystical, empathetic tarot readings
 */

import { GoogleGenerativeAI } from '@google/generative-ai';
import { log } from '../utils/api';

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
    const content = response.text();

    if (!content) {
      throw new Error('Empty response from Gemini');
    }

    const duration = Date.now() - startTime;
    log('info', 'Gemini AI response received', {
      requestId,
      duration,
      contentLength: content.length,
      finishReason: response.candidates?.[0]?.finishReason || 'unknown',
    });

    return {
      content,
      finishReason: response.candidates?.[0]?.finishReason || 'STOP',
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
    positions?: Array<{ meaning: string; meaningCA: string; meaningES: string }>;
  }>,
  locale: string,
  requestId?: string
): Promise<{ spreadId: string; reason: string; interpretationGuide: string }> {
  const spreadsText = spreads
    .map(s => {
      const positionsText = s.positions?.length
        ? `\n  Positions: ${s.positions.map((p, i) => `${i + 1}. ${locale === 'ca' ? p.meaningCA : locale === 'es' ? p.meaningES : p.meaning}`).join(', ')}`
        : '';
      return `- ${s.id}: ${s.name} (${s.description})${positionsText}`;
    })
    .join('\n');

  const userPrompt = `You are a warm, experienced tarot reader. Select the BEST tarot spread for this question and provide rich, valuable guidance.

Question: "${question}"

Available spreads:
${spreadsText}

CRITICAL INSTRUCTIONS:
- Be creative, natural, and varied. Never repeat the same phrases.
- Each response must feel unique, fresh, and deeply insightful
- NO generic language. NO filler. Only valuable, specific content.

Respond in ${locale} with ONLY this JSON format:
{
  "spreadId": "exact_id_from_list",
  "reason": "Two detailed bullet points ONLY. Format: '• First point\\n\\n• Second point'. NO intro sentence before bullets.\\n\\nFirst bullet (30-50 words): Explain WHY this spread is perfect for their specific question/theme. Be concrete: mention what aspects it illuminates, which card positions address their concern, why the structure fits.\\n\\nSecond bullet (30-50 words): Give a READING GUIDANCE - how to interpret this spread for their situation. Mention what to focus on, which positions hold key insights, or how to connect the cards for their answer.",
  "interpretationGuide": ""
}`;

  const response = await callGemini({
    userPrompt,
    temperature: 0.9,
    maxTokens: 700,
    requestId,
  });

  try {
    const parsed = JSON.parse(response.content);
    return {
      spreadId: parsed.spreadId,
      reason: parsed.reason || 'Tirada recomendada para tu pregunta',
      interpretationGuide: parsed.interpretationGuide || '',
    };
  } catch (error) {
    log('error', 'Failed to parse Gemini spread selection', { requestId, error });
    throw new Error('Invalid spread selection response');
  }
}

/**
 * Generate tarot interpretation using the SAME structure as DeepSeek
 * Uses card placeholders that get replaced with localized names
 */
export async function interpretCardsWithGemini(
  question: string,
  cards: Array<{ name: string; upright: boolean; position: string }>,
  spreadName: string,
  locale: string,
  requestId?: string
): Promise<string> {
  // Calculate dynamic length based on number of cards
  const numCards = cards.length;
  const baseWords = 100; // Opening paragraph
  const wordsPerCard = 80; // Each card gets ~80 words
  const conclusionWords = 60; // Síntesis + Guía
  const totalWords = baseWords + (numCards * wordsPerCard) + conclusionWords;

  // Calculate max tokens (roughly 1.3 tokens per word in Spanish/Catalan)
  const maxTokens = Math.min(4000, Math.max(800, Math.ceil(totalWords * 1.5)));

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

${cardPlaceholdersRef}

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

  return response.content.trim();
}
