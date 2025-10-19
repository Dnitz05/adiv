import { editQuestionWithAI } from '../../lib/services/ai-question-editor';

describe('editQuestionWithAI', () => {
  const originalKey = process.env.DEEPSEEK_API_KEY;

  afterEach(() => {
    process.env.DEEPSEEK_API_KEY = originalKey;
  });

  it('returns fallback text when API key is missing', async () => {
    process.env.DEEPSEEK_API_KEY = '';
    const question = 'Necessito orientació sobre la meva relació.';

    const result = await editQuestionWithAI(question, 'ca');

    expect(result.usedAI).toBe(false);
    expect(result.edited).toBe(question);
  });
});
