/**
 * AI Provider Selector
 * Centralizes AI provider selection (DeepSeek vs Gemini)
 */

import { log } from '../utils/api';
import { formatQuestionWithGemini, editQuestionWithGemini, interpretCardsWithGemini } from './gemini-ai';

const AI_PROVIDER = process.env.AI_PROVIDER?.trim()?.toLowerCase() || 'deepseek';

export function getAIProvider(): 'deepseek' | 'gemini' {
  return AI_PROVIDER === 'gemini' ? 'gemini' : 'deepseek';
}

export function isUsingGemini(): boolean {
  return getAIProvider() === 'gemini';
}

/**
 * Format question using selected AI provider
 */
export async function formatQuestion(
  question: string,
  locale: string,
  requestId?: string
): Promise<string> {
  if (isUsingGemini()) {
    log('info', 'Using Gemini for question formatting', { requestId });
    try {
      return await formatQuestionWithGemini(question, locale, requestId);
    } catch (error) {
      log('error', 'Gemini question formatting failed, using fallback', {
        requestId,
        error: error instanceof Error ? error.message : 'Unknown',
      });
      return question.trim();
    }
  }

  // Import DeepSeek formatter lazily
  const { formatQuestionWithAI } = await import('./ai-question-formatter');
  const result = await formatQuestionWithAI(question, locale);
  return result.formatted;
}

/**
 * Edit question using selected AI provider
 */
export async function editQuestion(
  question: string,
  locale: string,
  requestId?: string
): Promise<string> {
  if (isUsingGemini()) {
    log('info', 'Using Gemini for question editing', { requestId });
    try {
      return await editQuestionWithGemini(question, locale, requestId);
    } catch (error) {
      log('error', 'Gemini question editing failed, using fallback', {
        requestId,
        error: error instanceof Error ? error.message : 'Unknown',
      });
      return question.trim();
    }
  }

  // Import DeepSeek editor lazily
  const { editQuestionWithAI } = await import('./ai-question-editor');
  const result = await editQuestionWithAI(question, locale);
  return result.edited;
}

/**
 * Generate interpretation using selected AI provider
 */
export async function generateInterpretation(
  question: string,
  cards: Array<{ name: string; upright: boolean; position: string }>,
  spreadName: string,
  locale: string,
  requestId?: string
): Promise<string> {
  if (isUsingGemini()) {
    log('info', 'Using Gemini for interpretation', { requestId });
    return await interpretCardsWithGemini(question, cards, spreadName, locale, requestId);
  }

  // For DeepSeek, return empty to use existing endpoint logic
  // (interpret.ts endpoint will handle it)
  throw new Error('DeepSeek interpretation should use existing endpoint logic');
}
