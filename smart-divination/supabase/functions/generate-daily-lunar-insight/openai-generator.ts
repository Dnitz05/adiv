// OpenAI Integration for Lunar Insight Generation
// Generates personalized daily insights based on lunar templates

const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY')!;
const MODEL = 'gpt-4o-mini'; // Cost-effective model
const COST_PER_1K_INPUT = 0.00015; // $0.15 per 1M input tokens
const COST_PER_1K_OUTPUT = 0.0006; // $0.60 per 1M output tokens

interface LunarGuideTemplate {
  id: string;
  phase_id: string;
  element: string | null;
  zodiac_sign: string | null;
  headline: Record<string, string>;
  tagline: Record<string, string> | null;
  focus_areas: Record<string, string[]>;
  energy_description: Record<string, string>;
  recommended_actions: Record<string, string[]>;
  priority: number;
}

interface GenerateInsightParams {
  date: Date;
  phaseId: string;
  zodiacSign: string;
  element: string;
  lunarAge: number;
  illumination: number;
  template: LunarGuideTemplate;
  isSpecialEvent: boolean;
  specialEventType: string | null;
}

interface AIGenerationResult {
  universal_insight: Record<string, string>;
  specific_insight: Record<string, string>;
  model: string;
  cost: number;
}

/**
 * Generate AI-powered insights for today's lunar energy
 */
export async function generateInsightWithAI(
  params: GenerateInsightParams
): Promise<AIGenerationResult> {
  const {
    date,
    phaseId,
    zodiacSign,
    element,
    lunarAge,
    illumination,
    template,
    isSpecialEvent,
    specialEventType,
  } = params;

  // Build context for AI from template
  const contextPrompt = buildContextPrompt(template, phaseId, zodiacSign, element, lunarAge, illumination);

  // Generate universal insight (for everyone, regardless of personal data)
  const universalPrompt = buildUniversalPrompt(contextPrompt, date, isSpecialEvent, specialEventType);
  const universalInsightEn = await callOpenAI(universalPrompt);

  // Generate specific insight (can be personalized in future with user data)
  const specificPrompt = buildSpecificPrompt(contextPrompt, date, isSpecialEvent, specialEventType);
  const specificInsightEn = await callOpenAI(specificPrompt);

  // Translate to Spanish and Catalan
  const universalEs = await translate(universalInsightEn, 'es');
  const universalCa = await translate(universalInsightEn, 'ca');
  const specificEs = await translate(specificInsightEn, 'es');
  const specificCa = await translate(specificInsightEn, 'ca');

  // Estimate cost (rough approximation)
  const totalTokens = estimateTokens(universalPrompt + specificPrompt + universalInsightEn + specificInsightEn);
  const inputCost = (totalTokens * 0.7) / 1000 * COST_PER_1K_INPUT;
  const outputCost = (totalTokens * 0.3) / 1000 * COST_PER_1K_OUTPUT;
  const cost = inputCost + outputCost;

  return {
    universal_insight: {
      en: universalInsightEn,
      es: universalEs,
      ca: universalCa,
    },
    specific_insight: {
      en: specificInsightEn,
      es: specificEs,
      ca: specificCa,
    },
    model: MODEL,
    cost: cost,
  };
}

/**
 * Build context from template for AI prompts
 */
function buildContextPrompt(
  template: LunarGuideTemplate,
  phaseId: string,
  zodiacSign: string,
  element: string,
  lunarAge: number,
  illumination: number
): string {
  const headline = template.headline.en;
  const tagline = template.tagline?.en || '';
  const focusAreas = template.focus_areas.en.join(', ');
  const energyDescription = template.energy_description.en;
  const actions = template.recommended_actions.en.join('; ');

  return `
Today's Lunar Energy Context:
- Phase: ${phaseId.replace('_', ' ')} (${lunarAge.toFixed(1)} days old, ${illumination.toFixed(0)}% illuminated)
- Moon in ${zodiacSign} (${element} element)
- Theme: ${headline}
- Essence: ${tagline}
- Focus Areas: ${focusAreas}
- Energy: ${energyDescription}
- Recommended Actions: ${actions}
`.trim();
}

/**
 * Build universal insight prompt
 */
function buildUniversalPrompt(
  context: string,
  date: Date,
  isSpecialEvent: boolean,
  specialEventType: string | null
): string {
  const dateStr = date.toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });
  const specialNote = isSpecialEvent ? `\n\nNOTE: Today is a special event: ${specialEventType}. Acknowledge this significance.` : '';

  return `You are a wise, warm lunar astrologer writing daily guidance.

${context}${specialNote}

Write a universal insight for ${dateStr} (1-2 short paragraphs, ~80-120 words) that:
- Speaks to the collective energy everyone experiences today
- Weaves together the lunar phase meaning + zodiac + element naturally
- Feels poetic yet accessible, mystical yet practical
- Offers wisdom about this specific day's energy
- Uses "we", "us", "today" to create shared experience
- Avoids generic advice; be specific to TODAY's unique lunar alignment

Tone: Warm, wise, poetic, grounded. Like a trusted guide.

Write ONLY the insight text, no preamble or meta-commentary.`;
}

/**
 * Build specific insight prompt
 */
function buildSpecificPrompt(
  context: string,
  date: Date,
  isSpecialEvent: boolean,
  specialEventType: string | null
): string {
  const dateStr = date.toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });
  const specialNote = isSpecialEvent ? `\n\nNOTE: Today is a special event: ${specialEventType}. Acknowledge this significance.` : '';

  return `You are a wise, warm lunar astrologer writing daily guidance.

${context}${specialNote}

Write a specific, personal insight for ${dateStr} (1-2 short paragraphs, ~80-120 words) that:
- Addresses the reader directly ("you", "your")
- Offers concrete guidance for navigating today's energy personally
- Includes a specific question or reflection prompt
- Feels like personal counsel from a wise mentor
- Connects today's lunar energy to personal growth or awareness
- Avoids generic platitudes; be specific and actionable

Tone: Warm, wise, direct, empowering. Like a personal mentor.

Write ONLY the insight text, no preamble or meta-commentary.`;
}

/**
 * Call OpenAI API
 */
async function callOpenAI(prompt: string): Promise<string> {
  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${OPENAI_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model: MODEL,
      messages: [
        {
          role: 'user',
          content: prompt,
        },
      ],
      temperature: 0.8,
      max_tokens: 250,
    }),
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`OpenAI API error: ${error}`);
  }

  const data = await response.json();
  return data.choices[0].message.content.trim();
}

/**
 * Translate text using OpenAI
 */
async function translate(text: string, targetLang: 'es' | 'ca'): Promise<string> {
  const langName = targetLang === 'es' ? 'Spanish' : 'Catalan';

  const prompt = `Translate this lunar astrology insight to ${langName}. Maintain the warm, poetic, mystical tone. Keep the same level of detail and spiritual depth.

English text:
${text}

${langName} translation:`;

  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${OPENAI_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model: MODEL,
      messages: [
        {
          role: 'user',
          content: prompt,
        },
      ],
      temperature: 0.3, // Lower temperature for more accurate translation
      max_tokens: 300,
    }),
  });

  if (!response.ok) {
    console.warn(`Translation to ${langName} failed, using English fallback`);
    return text; // Fallback to English if translation fails
  }

  const data = await response.json();
  return data.choices[0].message.content.trim();
}

/**
 * Estimate token count (rough approximation)
 */
function estimateTokens(text: string): number {
  // Rough estimate: 1 token ≈ 4 characters
  return Math.ceil(text.length / 4);
}
