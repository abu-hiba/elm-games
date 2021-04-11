self.addEventListener('install', function (e) {
    e.waitUntil(
      caches.open('dwylapp').then(function (cache) {
        return cache.addAll([
          '/',
          '/manifest.webmanifest',
          '/*.js',
          '/Icon-48.png',
          '/Icon-72.png',
          '/Icon-144.png',
          '/Icon-167.png',
          '/*.css',
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
