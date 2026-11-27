// Cloudflare Worker for nvim.ronchang.io
//   /         dnvim.sh for curl/wget, README for browsers
//   /install  install.sh
const RAW = 'https://raw.githubusercontent.com/Ron-Chang/dnvim/main/';

export default {
  async fetch(request) {
    const path = new URL(request.url).pathname.replace(/\/+$/, '');
    const ua = request.headers.get('user-agent') || '';
    const browser = /Mozilla/.test(ua) && !/curl|wget/i.test(ua);

    let file;
    if (path === '/install') file = 'install.sh';
    else if (path === '') file = browser ? 'README.md' : 'dnvim.sh';
    else return new Response('not found\n', { status: 404 });

    const upstream = await fetch(RAW + file, { cf: { cacheTtl: 300, cacheEverything: true } });
    if (!upstream.ok) {
      return new Response(`upstream error: ${upstream.status}\n`, { status: 502 });
    }
    return new Response(upstream.body, {
      headers: {
        'content-type': 'text/plain; charset=utf-8',
        'cache-control': 'public, max-age=300',
      },
    });
  },
};
