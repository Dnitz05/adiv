type HeadersInit = Record<string, string>;

export function makeRequest(
  method: string,
  options: {
    path?: string;
    headers?: HeadersInit;
    body?: any;
  } = {}
) {
  const { path = '/api/health', headers = {}, body } = options;
  const lower: Record<string, string> = {};
  Object.entries(headers).forEach(([k, v]) => (lower[k.toLowerCase()] = String(v)));

  const h: any = {
    ...lower,
    get: (k: string) => lower[k.toLowerCase()] ?? null,
  };

  return {
    method,
    headers: h,
    url: `http://localhost${path}`,
    text: async () => (body !== undefined ? JSON.stringify(body) : ''),
    json: async () => body,
    formData: async () => ({ forEach: () => undefined }),
  } as any;
}

export default makeRequest;

