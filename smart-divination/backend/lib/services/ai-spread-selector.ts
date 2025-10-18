/**
 * AI-powered spread selector using DeepSeek
 * Ultra-optimized for minimal latency (<2s target)
 */

import { log } from '../utils/api';
import { SPREADS, type SpreadDefinition } from '../data/spreads';

// Model configuration - using deepseek-chat for speed and reliability
const DEEPSEEK_URL = process.env.DEEPSEEK_API_URL ?? 'https://api.deepseek.com/v1/chat/completions';
// Use DeepSeek Chat (fast, reliable model for spread selection)
const MODEL = process.env.DEEPSEEK_MODEL?.trim() || 'deepseek-chat';

interface SpreadSelection {
  spreadId: string;
  reason: string;
  confidence: number;
}

interface DeepSeekMessage {
  role: 'system' | 'user' | 'assistant';
  content: string;
}

interface DeepSeekResponse {
  choices?: Array<{
    message?: {
      content?: string;
    };
  }>;
}

/**
 * Build prompt for spread selection with warm, knowledgeable tone
 */
function buildSpreadSelectionPrompt(question: string, locale: string): string {
  // Build compact spread list with full names
  const spreadList = SPREADS.map((s) => {
    const locName = locale === 'ca' ? s.nameCA : locale === 'es' ? s.nameES : s.name;
    return `${s.id}|${locName}|${s.cardCount}c|${s.category}|${s.suitableFor.slice(0, 3).join(',')}`;
  }).join('\n');

  return `Q: ${question}

Spreads (id|name|cards|category|keywords):
${spreadList}

Return JSON only: {"spreadId":"id","reason":"2-4 sentences in ${locale}"}`;
}

/**
 * Build system prompt - cached by DeepSeek for speed
 */
function buildSystemPrompt(): string {
  // Get all valid spread IDs for validation
  const validIds = SPREADS.map(s => s.id).join(', ');

  return `You are a sensitive, knowledgeable tarot reader. Select the BEST spread for the question with warmth and understanding.

CRITICAL: spreadId MUST be EXACTLY one of these IDs (do NOT invent new IDs):
${validIds}

Selection guidelines:
- Quick question or daily → single
- Binary choice → two_card
- General situation → three_card
- With obstacles → five_card_cross
- Love/relationship → relationship (NOT "love")
- Goal with aspects → pyramid
- Comprehensive → horseshoe
- Very complex → celtic_cross
- Self-discovery → star
- Life overview → astrological
- Year planning → year_ahead

IMPORTANT: Respond ONLY with clean JSON, no extra text.
Format: {"spreadId":"exact_id_from_list","reason":"warm explanation in user's language"}

The "reason" field (2-4 sentences) should:
- Show sensitivity to the user's question and emotional state
- Explain WHY this spread is chosen (what it reveals, its strengths)
- Briefly describe HOW to read it (what each position means or the overall flow)
- Use a warm, confident, mystical-yet-practical tone
- Demonstrate deep tarot knowledge and atmosphere
- Avoid cold phrases like "Key factors detected" or technical jargon
- Make the user feel understood and guided by an expert

Example tone: "He escogido la Tirada de Tres Cartas porque tu pregunta busca claridad sobre tu situación actual. Esta tirada clásica te muestra el pasado que te ha traído aquí, el presente que estás viviendo, y el futuro que se despliega ante ti. Es perfecta para obtener una visión completa sin abrumarte, permitiéndote ver el hilo conductor de tu camino."`;
}

/**
 * Select spread using AI with streaming support
 * Streams the reasoning as it's generated for better UX
 */
export async function selectSpreadWithAIStreaming(
  question: string,
  locale: string = 'es',
  requestId?: string,
  onChunk?: (chunk: string) => void
): Promise<SpreadSelection> {
  const startTime = Date.now();
  const apiKey = process.env.DEEPSEEK_API_KEY?.trim();

  if (!apiKey) {
    log('warn', 'DeepSeek API key missing for spread selection', { requestId });
    return {
      spreadId: 'three_card',
      reason: 'Tirada versátil para tu pregunta',
      confidence: 0.5,
    };
  }

  try {
    const messages: DeepSeekMessage[] = [
      { role: 'system', content: buildSystemPrompt() },
      { role: 'user', content: buildSpreadSelectionPrompt(question, locale) },
    ];

    const requestBody = {
      model: MODEL,
      temperature: 0.3,
      max_tokens: 250, // Increased for warmer, more extensive reasoning
      messages,
      stream: true, // Enable streaming
    };

    log('info', 'Calling DeepSeek for spread selection (streaming)', {
      requestId,
      questionLength: question.length,
      locale,
    });

    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 10000);

    try {
      const response = await fetch(DEEPSEEK_URL, {
        method: 'POST',
        headers: {
          'content-type': 'application/json',
          authorization: `Bearer ${apiKey}`,
        },
        body: JSON.stringify(requestBody),
        signal: controller.signal,
      });

      clearTimeout(timeoutId);

      if (!response.ok) {
        throw new Error(`DeepSeek failed: ${response.status}`);
      }

      if (!response.body) {
        throw new Error('No response body for streaming');
      }

      // Process streaming response
      const reader = response.body.getReader();
      const decoder = new TextDecoder();
      let fullContent = '';
      let buffer = '';

      while (true) {
        const { done, value } = await reader.read();
        if (done) break;

        buffer += decoder.decode(value, { stream: true });
        const lines = buffer.split('\n');
        buffer = lines.pop() || '';

        for (const line of lines) {
          if (line.startsWith('data: ')) {
            const data = line.slice(6);
            if (data === '[DONE]') continue;

            try {
              const parsed = JSON.parse(data);
              const content = parsed.choices?.[0]?.delta?.content;
              if (content) {
                fullContent += content;
                if (onChunk) onChunk(content);
              }
            } catch (e) {
              // Skip invalid JSON
            }
          }
        }
      }

      // Parse final JSON response
      const parsed = JSON.parse(fullContent);
      const spreadId = parsed.spreadId;
      const reason = parsed.reason || 'Tirada recomendada para tu pregunta';

      const spread = SPREADS.find((s) => s.id === spreadId);
      if (!spread) {
        throw new Error(`Invalid spread ID: ${spreadId}`);
      }

      const duration = Date.now() - startTime;
      log('info', 'AI spread selection successful (streaming)', {
        requestId,
        spreadId,
        duration,
      });

      return {
        spreadId,
        reason,
        confidence: 0.9,
      };
    } catch (fetchError) {
      clearTimeout(timeoutId);
      throw fetchError;
    }
  } catch (error) {
    const duration = Date.now() - startTime;
    log('error', 'AI spread selection failed', {
      requestId,
      error: error instanceof Error ? error.message : 'Unknown error',
      duration,
    });
    return fallbackSpreadSelection(question, locale);
  }
}

/**
 * Select spread using AI with ultra-low latency (non-streaming)
 * Target: <2 seconds
 */
export async function selectSpreadWithAI(
  question: string,
  locale: string = 'es',
  requestId?: string
): Promise<SpreadSelection> {
  const startTime = Date.now();

  // Get API key
  const apiKey = process.env.DEEPSEEK_API_KEY?.trim();
  if (!apiKey) {
    log('warn', 'DeepSeek API key missing for spread selection', { requestId });
    // Fallback to three_card
    return {
      spreadId: 'three_card',
      reason: 'Tirada versátil para tu pregunta',
      confidence: 0.5,
    };
  }

  try {
    const messages: DeepSeekMessage[] = [
      {
        role: 'system',
        content: buildSystemPrompt(),
      },
      {
        role: 'user',
        content: buildSpreadSelectionPrompt(question, locale),
      },
    ];

    const requestBody = {
      model: MODEL,
      temperature: 0.3, // Low = faster + more deterministic
      max_tokens: 250, // Increased for warmer, more extensive reasoning
      messages,
    };

    log('info', 'Calling DeepSeek for spread selection', {
      requestId,
      questionLength: question.length,
      locale,
    });

    // Make request with timeout
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 5000); // 5s timeout

    try {
      const response = await fetch(DEEPSEEK_URL, {
        method: 'POST',
        headers: {
          'content-type': 'application/json',
          authorization: `Bearer ${apiKey}`,
        },
        body: JSON.stringify(requestBody),
        signal: controller.signal,
      });

      clearTimeout(timeoutId);

      if (!response.ok) {
        throw new Error(`DeepSeek failed: ${response.status}`);
      }

      const payload = (await response.json()) as DeepSeekResponse;
      const content = payload?.choices?.[0]?.message?.content;

      if (!content) {
        throw new Error('Empty response from DeepSeek');
      }

      // Parse JSON response
      const parsed = JSON.parse(content);
      const spreadId = parsed.spreadId;
      const reason = parsed.reason || 'Tirada recomendada para tu pregunta';

      // Validate spread exists
      const spread = SPREADS.find((s) => s.id === spreadId);
      if (!spread) {
        throw new Error(`Invalid spread ID: ${spreadId}`);
      }

      const duration = Date.now() - startTime;
      log('info', 'AI spread selection successful', {
        requestId,
        spreadId,
        duration,
      });

      return {
        spreadId,
        reason,
        confidence: 0.9,
      };
    } catch (fetchError) {
      clearTimeout(timeoutId);
      throw fetchError;
    }
  } catch (error) {
    const duration = Date.now() - startTime;
    log('error', 'AI spread selection failed', {
      requestId,
      error: error instanceof Error ? error.message : 'Unknown error',
      duration,
    });

    // Fallback: use keyword-based selection
    return fallbackSpreadSelection(question, locale);
  }
}

/**
 * Fast fallback when AI fails
 * Uses simple keyword matching
 */
function fallbackSpreadSelection(question: string, locale: string): SpreadSelection {
  const lowerQuestion = question.toLowerCase();

  // Quick keyword checks
  if (lowerQuestion.length < 30) {
    return {
      spreadId: 'single',
      reason: locale === 'ca'
        ? 'Pregunta ràpida, resposta directa'
        : 'Pregunta rápida, respuesta directa',
      confidence: 0.7,
    };
  }

  if (lowerQuestion.includes('o ') || lowerQuestion.includes('decidir') || lowerQuestion.includes('elegir')) {
    return {
      spreadId: 'two_card',
      reason: locale === 'ca'
        ? 'Perfecta per comparar dues opcions'
        : 'Perfecta para comparar dos opciones',
      confidence: 0.75,
    };
  }

  if (lowerQuestion.includes('amor') || lowerQuestion.includes('relació') || lowerQuestion.includes('relación') || lowerQuestion.includes('pareja')) {
    return {
      spreadId: 'relationship',
      reason: locale === 'ca'
        ? 'Ideal per explorar dinàmiques de relació'
        : 'Ideal para explorar dinámicas de relación',
      confidence: 0.8,
    };
  }

  if (lowerQuestion.includes('año') || lowerQuestion.includes('any') || lowerQuestion.includes('futuro')) {
    return {
      spreadId: 'year_ahead',
      reason: locale === 'ca'
        ? 'Per veure el camí de l\'any que ve'
        : 'Para ver el camino del próximo año',
      confidence: 0.75,
    };
  }

  // Default to three_card
  return {
    spreadId: 'three_card',
    reason: locale === 'ca'
      ? 'Tirada versàtil per a la teva situació'
      : 'Tirada versátil para tu situación',
    confidence: 0.7,
  };
}

/**
 * Get spread definition with localized info
 */
export function getSpreadWithLocale(spreadId: string, locale: string): SpreadDefinition | null {
  return SPREADS.find((s) => s.id === spreadId) || null;
}
