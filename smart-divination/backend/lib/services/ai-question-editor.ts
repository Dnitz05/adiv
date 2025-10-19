import { log } from '../utils/api';

const DEEPSEEK_URL = process.env.DEEPSEEK_API_URL ?? 'https://api.deepseek.com/v1/chat/completions';
const MODEL = process.env.DEEPSEEK_MODEL?.trim() || 'deepseek-chat';

interface EditorResult {
  edited: string;
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
      ? 'català (mantén accents, pronoms i registres propis)'
      : locale === 'es'
        ? 'español (respeta tildes, signos de apertura y registros)'
        : 'the same language as the user question';

  return `You are an attentive tarot assistant polishing a consultation question.
Rules:
- Reply strictly with minified JSON: {"edited":"..."}
- Keep the user intention intact; do not add new content or remove key details.
- Fix grammar, spelling, accents, punctuation, and improve flow for a tarot reading context.
- Preserve the original language (${languageLabel}).
- Keep the output under 160 characters, single line, trimmed.
- Remove duplicated whitespace and emoji spam, but keep meaningful symbols.`;
}

function buildUserPrompt(question: string): string {
  return `Clean this tarot consultation question for display:\n${question}`;
}

function sanitiseEdited(text: string, fallback: string): string {
  const trimmed = text.replace(/\s+/g, ' ').trim();
  return trimmed || fallback;
}

function extractEditedField(content: string, fallback: string): string {
  try {
    const jsonMatch = content.match(/\{[\s\S]*\}/);
    const toParse = jsonMatch ? jsonMatch[0] : content;
    const parsed = JSON.parse(toParse);
    const candidate = typeof parsed.edited === 'string' ? parsed.edited : null;
    if (candidate && candidate.trim()) {
      return sanitiseEdited(candidate, fallback);
    }
  } catch (error) {
    // Fallback handled below
  }
  return sanitiseEdited(content, fallback);
}

export async function editQuestionWithAI(
  question: string,
  locale: string
): Promise<EditorResult> {
  const fallback = question.trim();
  const apiKey = process.env.DEEPSEEK_API_KEY?.trim();
  if (!apiKey) {
    log('warn', 'DeepSeek API key missing for question editor');
    return { edited: fallback, usedAI: false };
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
        max_tokens: 160,
        messages,
      }),
      signal: controller.signal,
    });

    clearTimeout(timeoutId);

    if (!response.ok) {
      const text = await response.text();
      log('warn', 'Question editor request failed', {
        status: response.status,
        body: text,
      });
      return { edited: fallback, usedAI: false };
    }

    const data = (await response.json()) as DeepSeekResponse;
    const content = data.choices?.[0]?.message?.content;
    if (!content) {
      log('warn', 'Question editor returned empty content');
      return { edited: fallback, usedAI: false };
    }

    const edited = extractEditedField(content, fallback);
    return { edited, usedAI: true };
  } catch (error) {
    log('warn', 'Question editor error', {
      error: error instanceof Error ? error.message : 'Unknown error',
    });
    return { edited: fallback, usedAI: false };
  } finally {
    clearTimeout(timeoutId);
  }
}
