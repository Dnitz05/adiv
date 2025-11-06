describe('callGemini', () => {
  const originalGeminiKey = process.env.GEMINI_API_KEY;
  const originalGeminiModel = process.env.GEMINI_MODEL;

  beforeEach(() => {
    jest.resetModules();
    process.env.GEMINI_API_KEY = 'test-key';
    process.env.GEMINI_MODEL = 'test-model';
  });

  afterEach(() => {
    process.env.GEMINI_API_KEY = originalGeminiKey;
    process.env.GEMINI_MODEL = originalGeminiModel;
    jest.resetModules();
    jest.clearAllMocks();
    jest.restoreAllMocks();
  });

  it('returns concatenated text when response.text() is empty', async () => {
    const mockGenerateContent = jest.fn().mockResolvedValue({
      response: {
        text: () => '',
        candidates: [
          {
            finishReason: 'STOP',
            content: {
              parts: [
                { text: 'Primera línia ' },
                { text: 'Segona línia' },
              ],
            },
          },
        ],
        promptFeedback: undefined,
      },
    });

    const mockGetGenerativeModel = jest.fn().mockReturnValue({
      generateContent: mockGenerateContent,
    });

    jest.doMock('@google/generative-ai', () => ({
      GoogleGenerativeAI: jest.fn().mockImplementation(() => ({
        getGenerativeModel: mockGetGenerativeModel,
      })),
    }));

    jest.doMock('../lib/utils/api', () => ({
      log: jest.fn(),
      logInfo: jest.fn(),
      logWarn: jest.fn(),
      logError: jest.fn(),
      logDebug: jest.fn(),
    }));

    const { callGemini } = await import('../lib/services/gemini-ai');

    const result = await callGemini({
      userPrompt: 'Hola',
      temperature: 0.1,
      maxTokens: 64,
      requestId: 'req-test',
    });

    expect(result.content).toBe('Primera línia\n\nSegona línia');
    expect(result.finishReason).toBe('STOP');

    expect(mockGetGenerativeModel).toHaveBeenCalledWith({
      model: 'test-model',
      systemInstruction: expect.any(String),
    });

    expect(mockGenerateContent).toHaveBeenCalledWith({
      contents: [{ role: 'user', parts: [{ text: 'Hola' }] }],
      generationConfig: expect.objectContaining({
        maxOutputTokens: 64,
        temperature: 0.1,
      }),
    });
  });
});
