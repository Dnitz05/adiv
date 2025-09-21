interface InvokeOptions {
  path?: string;
  headers?: Record<string, string>;
  body?: any;
  query?: Record<string, string | string[]>;
}

export async function invokeNodeHandler(
  handler: (req: any, res: any) => void | Promise<void>,
  method: string,
  options: InvokeOptions = {}
): Promise<Response> {
  const { path = '/api/test', headers = {}, body, query = {} } = options;
  const lowerCaseHeaders: Record<string, string> = {};
  for (const [key, value] of Object.entries(headers)) {
    lowerCaseHeaders[key.toLowerCase()] = String(value);
  }

  const requestHeaders: any = {
    ...lowerCaseHeaders,
    get: (key: string) => lowerCaseHeaders[key.toLowerCase()] ?? null,
  };

  const req: any = {
    method,
    url: `http://localhost${path}`,
    headers: requestHeaders,
    query,
    body,
  };

  let statusCode = 200;
  let ended = false;
  let payload: any = undefined;
  const headerStore = new Map<string, string>();

  const res: any = {
    status(code: number) {
      statusCode = code;
      res.statusCode = code;
      return res;
    },
    setHeader(name: string, value: string | string[]) {
      const normalized = Array.isArray(value) ? value.join(', ') : String(value);
      headerStore.set(name.toLowerCase(), normalized);
    },
    getHeader(name: string) {
      return headerStore.get(name.toLowerCase());
    },
    json(data: any) {
      payload = data;
      if (!headerStore.has('content-type')) {
        headerStore.set('content-type', 'application/json');
      }
      ended = true;
      return res;
    },
    end(data?: any) {
      if (data !== undefined) {
        payload = data;
      }
      ended = true;
      return res;
    },
    send(data: any) {
      return res.end(data);
    },
  };

  await handler(req, res);

  if (!ended && payload === undefined) {
    payload = '';
  }

  let bodyInit: BodyInit | undefined;
  if (payload instanceof Buffer || payload instanceof Uint8Array) {
    bodyInit = payload as any;
  } else if (typeof payload === 'string') {
    bodyInit = payload;
  } else if (payload === null || payload === undefined) {
    bodyInit = '';
  } else {
    bodyInit = JSON.stringify(payload);
    if (!headerStore.has('content-type')) {
      headerStore.set('content-type', 'application/json');
    }
  }

  const headersInit: Record<string, string> = {};
  headerStore.forEach((value, key) => {
    headersInit[key] = value;
  });

  return new Response(bodyInit, {
    status: statusCode,
    headers: headersInit,
  });
}

export default invokeNodeHandler;
