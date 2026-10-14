// Budgetarian offline support. Lets the app open without internet.
const VERSION = "budgetarian-v1";
const SHELL = ["./", "index.html", "config.js", "manifest.webmanifest", "privacy.html",
  "vendor/supabase.js", "vendor/xlsx.full.min.js",
  "icons/icon-192.png", "icons/icon-512.png", "icons/apple-touch-icon.png", "icons/maskable-512.png"];
self.addEventListener("install", e => {
  e.waitUntil(caches.open(VERSION).then(c => c.addAll(SHELL.map(u => new Request(u, {cache: "reload"})))).then(() => self.skipWaiting()));
});
self.addEventListener("activate", e => {
  e.waitUntil(caches.keys().then(ks => Promise.all(ks.filter(k => k !== VERSION).map(k => caches.delete(k)))).then(() => self.clients.claim()));
});
self.addEventListener("fetch", e => {
  const req = e.request, url = new URL(req.url);
  if (req.method !== "GET" || url.origin !== location.origin) return; // never cache Supabase data
  const fresh = req.mode === "navigate" || /\/(index\.html|config\.js|version\.json)?$/.test(url.pathname);
  if (fresh) {
    e.respondWith(fetch(req.url, {cache: "no-cache", credentials: "same-origin"}).then(r => { const c = r.clone(); caches.open(VERSION).then(x => x.put(req, c)); return r; })
      .catch(() => caches.match(req).then(r => r || caches.match("index.html"))));
  } else {
    e.respondWith(caches.match(req).then(r => r || fetch(req).then(n => { const c = n.clone(); caches.open(VERSION).then(x => x.put(req, c)); return n; })));
  }
});
