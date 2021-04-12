if ('serviceWorker' in navigator) {
    //Let's register the ServiceWorker
    navigator.serviceWorker.register('/sw.js').then(function () {
      //We're good to go
      console.log("ServiceWorker registered correctly.");
    }).catch(function (err) {
      console.log("ServiceWorker registration failed: " + err);
    });
  }
