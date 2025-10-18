import { log } from '../utils/api';

const DEEPSEEK_URL = process.env.DEEPSEEK_API_URL ?? 'https://api.deepseek.com/v1/chat/completions';
const MODEL = process.env.DEEPSEEK_MODEL?.trim() || 'deepseek-chat';

interface FormatterResult {
  formatted: string;
  usedAI: boolean;
}

interface DeepSeekMessage {
  role: 'system' | 'user' | 'assistant';
  content: string;
}

interface DeepSeekChoice {
  message?: {
    content?: string;
  };
}

interface DeepSeekResponse {
  choices?: DeepSeekChoice[];
}

function buildSystemPrompt(locale: string): string {
  const languageLabel =
    locale === 'ca'
      ? 'català (mantingues tots els accents i pronoms propis)'
      : locale === 'es'
        ? 'español (mantén tildes y signos como ¿?)'
        : 'the same language as the user question';

  return `You improve short tarot consultation questions for UI headers.
Rules:
- Answer only with minified JSON: {"formatted":"..."}
- Keep the original intent faithfully; do not add or invent details.
- Fix casing, spelling, accents, punctuation, and clarity.
- Output must stay under 120 characters.
- Preserve the user's language, writing in ${languageLabel}.
- Remove redundant whitespace; keep it on a single line.`;
}

function buildUserPrompt(question: string): string {
  return `Original question: """${question}"""`;
}

function sanitiseFormatted(text: string, fallback: string): string {
  const trimmed = text.replace(/\s+/g, ' ').trim();
  if (!trimmed) {
    return fallback;
  }
  return trimmed;
}

function extractFormattedField(content: string, fallback: string): string {
  try {
    const jsonMatch = content.match(/\{[\s\S]*\}/);
    const toParse = jsonMatch ? jsonMatch[0] : content;
    const parsed = JSON.parse(toParse);
    const candidate = typeof parsed.formatted === 'string' ? parsed.formatted : null;
    if (candidate && candidate.trim()) {
      return sanitiseFormatted(candidate, fallback);
    }
  } catch (error) {
    // Fallback below
  }
  return sanitiseFormatted(content, fallback);
}

export async function formatQuestionWithAI(
  question: string,
  locale: string
): Promise<FormatterResult> {
  const fallback = question.trim();
  const apiKey = process.env.DEEPSEEK_API_KEY?.trim();
  if (!apiKey) {
    log('warn', 'DeepSeek API key missing for question formatter');
    return { formatted: fallback, usedAI: false };
  }

  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), 6000);

  try {
    const messages: DeepSeekMessage[] = [
      { role: 'system', content: buildSystemPrompt(locale) },
      { role: 'user', content: buildUserPrompt(question) },
    ];

    const response = await fetch(DEEPSEEK_URL, {
      method: 'POST',
      headers: {
        'content-type': 'application/json',
        authorization: `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        model: MODEL,
        temperature: 0.2,
        max_tokens: 120,
        messages,
      }),
      signal: controller.signal,
    });

    clearTimeout(timeoutId);

    if (!response.ok) {
      const text = await response.text();
      log('warn', 'Question formatter request failed', {
        status: response.status,
        body: text,
      });
      return { formatted: fallback, usedAI: false };
    }

    const data = (await response.json()) as DeepSeekResponse;
    const content = data.choices?.[0]?.message?.content;
    if (!content) {
      log('warn', 'Question formatter returned empty content');
      return { formatted: fallback, usedAI: false };
    }

    const formatted = extractFormattedField(content, fallback);
    return { formatted, usedAI: true };
  } catch (error) {
    log('warn', 'Question formatter error', {
      error: error instanceof Error ? error.message : 'Unknown error',
    });
    return { formatted: fallback, usedAI: false };
  } finally {
    clearTimeout(timeoutId);
  }
}
