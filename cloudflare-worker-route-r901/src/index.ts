import { Env } from './types';

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    const url = new URL(request.url);
    
    const targetUrl = new URL(url.pathname + url.search, env.REDIRECT_URL);
    
    const headers = new Headers(request.headers);
    headers.set('x-source', 'cloudflare');
    
    // Proxy the request instead of redirecting
    const response = await fetch(targetUrl.toString(), {
      method: request.method,
      headers: headers,
      body: request.body,
    });
    
    return response;
  }
};
