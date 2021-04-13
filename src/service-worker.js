self.addEventListener('install', function (e) {
    e.waitUntil(
      caches.open('dwylapp').then(function (cache) {
        return cache.addAll([
          './',
          './index.html',
          ...cardImageFiles,
        ]);
      })
    );
  });
  
  self.addEventListener('fetch', function (event) {
    event.respondWith(
      caches.match(event.request).then(function (response) {
        return response || fetch(event.request);
      })
    );
  });

  const cardImageFiles = [
    './cards/ad.svg',
    './cards/2d.svg',
    './cards/3d.svg',
    './cards/4d.svg',
    './cards/5d.svg',
    './cards/6d.svg',
    './cards/7d.svg',
    './cards/8d.svg',
    './cards/9d.svg',
    './cards/10d.svg',
    './cards/jd.svg',
    './cards/qd.svg',
    './cards/kd.svg',
    './cards/as.svg',
    './cards/2s.svg',
    './cards/3s.svg',
    './cards/4s.svg',
    './cards/5s.svg',
    './cards/6s.svg',
    './cards/7s.svg',
    './cards/8s.svg',
    './cards/9s.svg',
    './cards/10s.svg',
    './cards/js.svg',
    './cards/qs.svg',
    './cards/ks.svg',
    './cards/ah.svg',
    './cards/2h.svg',
    './cards/3h.svg',
    './cards/4h.svg',
    './cards/5h.svg',
    './cards/6h.svg',
    './cards/7h.svg',
    './cards/8h.svg',
    './cards/9h.svg',
    './cards/10h.svg',
    './cards/jh.svg',
    './cards/qh.svg',
    './cards/kh.svg',
    './cards/ac.svg',
    './cards/2c.svg',
    './cards/3c.svg',
    './cards/4c.svg',
    './cards/5c.svg',
    './cards/6c.svg',
    './cards/7c.svg',
    './cards/8c.svg',
    './cards/9c.svg',
    './cards/10c.svg',
    './cards/jc.svg',
    './cards/qc.svg',
    './cards/kc.svg',
    './cards/blank_card.svg',
    './cards/card_back.svg',
    './cards/joker_black.svg',
    './cards/joker_red.svg',
  ]
