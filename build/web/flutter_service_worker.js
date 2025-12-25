'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "be3a45c736e23b4321fcf6b658e13a07",
"assets/AssetManifest.bin.json": "4159ad50f246c8e5618b2a672a05e0a5",
"assets/AssetManifest.json": "6e2071e28c27c69da4e991e3f8d3eea3",
"assets/assets/fonts/abz.ttf": "be26f3332f3b4d552c823c5c045a46bb",
"assets/assets/fonts/giory.ttf": "889a4b5ce3a780faedb74390fc49a07a",
"assets/assets/fonts/gotham.ttf": "39b5ff14a54114e9ae92136578a0e2d3",
"assets/assets/fonts/refsan.ttf": "c8f34a4d8d6a866f095261f987a237a8",
"assets/assets/png/1.png": "8b9ae8ca7375d2fa76ef6389a00e07bc",
"assets/assets/png/aa.png": "ae5378b15a12230c19f124a65d5d4fb5",
"assets/assets/png/africa.png": "224ee29943830cc9cd20295656d8eb16",
"assets/assets/png/ai.png": "61942d0acd44f45becd2ba9d0aaaec32",
"assets/assets/png/badge.png": "faecff031adba1e99c4ab075b41392ad",
"assets/assets/png/bg.png": "5abc0126feadfbfd7127c076aeb6c240",
"assets/assets/png/blackgirl.png": "296563b9642ded531f7409a030a5d939",
"assets/assets/png/blackman.png": "a6cc51121ebd5c17e0997a7645a0cdc3",
"assets/assets/png/bottom.png": "0e5c763f45b18bb59a7bd1573860a94a",
"assets/assets/png/buttonplus.png": "67dcde35cfa28a5ea4c4fc5e82b8ef24",
"assets/assets/png/facil2.png": "c33972391c45adf9e5691c5158b8d68d",
"assets/assets/png/game.png": "37297fea378d0311bfc93b493e02bb1e",
"assets/assets/png/game2.png": "786edf69ff07fe761ef4c64443d7b12c",
"assets/assets/png/glasses.png": "db89fe7bb918678581fda60b518c17ca",
"assets/assets/png/group.png": "874f2e9e58ebfac52cad9c3758ad8550",
"assets/assets/png/group3.png": "f47ba068beb0e0a1e9944080ce1941e7",
"assets/assets/png/house1.png": "ad74a249df60d73f70e7361a8228e92f",
"assets/assets/png/main.png": "fd6a26484bd9fa162981c864866bdf9c",
"assets/assets/png/man.png": "33952e16be1e8fac5b1026a01aa06f30",
"assets/assets/png/man1.png": "169142c68ff9cf73f4986dba4cd56cd0",
"assets/assets/png/mountain.png": "8bee63bd2c05ad62334ce943706e1db4",
"assets/assets/png/ok.png": "18eaae3d7f41084c915eaad2a87ee3f4",
"assets/assets/png/pas.png": "81116862f1eb0e170996b033c9ac29b4",
"assets/assets/png/play2.png": "48a83fc5f69fdbfd9950b3692f82bfe8",
"assets/assets/png/play3.png": "2366420e0392a8ab96a1a2049d0e4cd8",
"assets/assets/png/play4.png": "83f82383908d2f8cfcbc0313b15d3189",
"assets/assets/png/play5.png": "8ea015e6a94bed8d747ba666a38c2c11",
"assets/assets/png/player2.png": "ba7ff5980a06c4cfd346835be85e7310",
"assets/assets/png/prince.png": "5776a18ec293aaee1c9e6a5f818dddfe",
"assets/assets/png/prince2.png": "06bd163493e0fa308861d9c768ec7402",
"assets/assets/png/Profile.png": "f5db88dbeb4c0686f3669184144730a6",
"assets/assets/png/timeout.png": "120f2db090d46836d3044b32d5079f51",
"assets/assets/png/timeout3.png": "9629b9ad9884fb90e1fc985da2f1bfe0",
"assets/assets/png/win1.png": "9efa37599ec261c70b8de747341be472",
"assets/assets/png/win2.png": "811006041b0834afb87cc38645f184a0",
"assets/assets/png/win3.png": "e2169316b7a83c3f24b5a47be044f99b",
"assets/assets/svg/admin.svg": "c937e8eaab918e2c926bed942690312f",
"assets/assets/svg/ai.svg": "0cfa22cbbff46a868af99b28fa9f990c",
"assets/assets/svg/arrowback.svg": "77b22d4b7d94124ca601420549a236f0",
"assets/assets/svg/arrowdown.svg": "3a1562f77e34d697218ce6bbea9925d6",
"assets/assets/svg/bottom.svg": "8404d801d4475a83c4972eed0f14dc9d",
"assets/assets/svg/bulb.svg": "5de0d0bd30c4edc581b3c1bd42bc4dd6",
"assets/assets/svg/calender.svg": "22dc4f24ffd7262738a8d1c119b57772",
"assets/assets/svg/copy.svg": "b573d16e6bf975913f7aaf5572a8897e",
"assets/assets/svg/Crown.svg": "c8d6dec46d34790789200ffe99da2fa2",
"assets/assets/svg/delete.svg": "ce09ae8f7c53678d3d60850178c29d9c",
"assets/assets/svg/div.svg": "821750a6fe75fec388d157028320ed5e",
"assets/assets/svg/edit.svg": "6d7711f0db2cf2f90aa1ce771b89f396",
"assets/assets/svg/export.svg": "4e032a7bde8483708a178ef02a90df98",
"assets/assets/svg/eye.svg": "fc8a5b286af33cf88e091f88012cb411",
"assets/assets/svg/facil.svg": "e07c023dfa6941f7613d169fc2a3a49a",
"assets/assets/svg/filter.svg": "c41c69a6c524e22317979629b3a24526",
"assets/assets/svg/forward.svg": "807932c293b91b50753a09350a956c2c",
"assets/assets/svg/france.svg": "a339e805531acac746f585d9fbc31d52",
"assets/assets/svg/germany.svg": "654f3bbd5e4d043abe2c56526985b91e",
"assets/assets/svg/group1.svg": "5b9eee9909142ad4a1be4d7e7ea61406",
"assets/assets/svg/group3.svg": "1203d5a5260ae31b129c449b9d8e4dc5",
"assets/assets/svg/house.svg": "0418ce0487bca3255d3b975d88d9c134",
"assets/assets/svg/italy.svg": "3f068bb47904365b6e4764921632881c",
"assets/assets/svg/king.svg": "b3963aff5aee4524a07b9c87f8e9765c",
"assets/assets/svg/language.svg": "da2320e4ac5ee52ef5f9d880386aa587",
"assets/assets/svg/leave.svg": "5be6d0a2e691408df3518901e462b162",
"assets/assets/svg/lines.svg": "b20f75124b6406e99fe0d1927a61c712",
"assets/assets/svg/lines2.svg": "552534e24c30234157bb9ea829b97e57",
"assets/assets/svg/lines3.svg": "ae91219f6940d11f9e75a3b338ea76f1",
"assets/assets/svg/maingame.svg": "13ad3210d9b23ec1c56ef0d01f51cba8",
"assets/assets/svg/man.svg": "3f152da0ddfbb53334ee662fa95ab6bd",
"assets/assets/svg/move.svg": "b2f08d3c2acfaf67311b7ed72c5080a8",
"assets/assets/svg/noti.svg": "941206d7501bba40e296ceb3058a722f",
"assets/assets/svg/option.svg": "444a2b77a604812da1837658d7cd1b93",
"assets/assets/svg/person.svg": "eedda9b0e64db434663f9b85ad815b42",
"assets/assets/svg/personadd.svg": "090c32da80d001b0e93a55b0cbb5c2ac",
"assets/assets/svg/phone1.svg": "5db0a076fbd709949f2be399d18b4d0c",
"assets/assets/svg/phone2.svg": "658fe613cb0c0f2f8f0f4945753aa0d0",
"assets/assets/svg/phone3.svg": "80566e5762bacc9ca5f427374b5e623c",
"assets/assets/svg/phone4.svg": "e46640e78460a37ff20e2797f530f28e",
"assets/assets/svg/player.svg": "1ca2f9da76916ac24bc5b6551365b562",
"assets/assets/svg/player1.svg": "def05802169d9ef97e52e4bdb324cb09",
"assets/assets/svg/prince.svg": "b6638611a96c58b3814892c0e435cde2",
"assets/assets/svg/saudi.svg": "692dac739f563196eea22593e3f4e8e3",
"assets/assets/svg/save.svg": "64baed51144975a4a65df8f7c4b3950e",
"assets/assets/svg/spain.svg": "7f69be13b247876d89d9be7bbe2de428",
"assets/assets/svg/splash.svg": "32b6614faf02c07fe721ad797ad1d7eb",
"assets/assets/svg/star.svg": "a69f897c9662ca19af59f94a6d0b4ab9",
"assets/assets/svg/submit.svg": "306467b064e994fce411962249b64681",
"assets/assets/svg/time.svg": "efe6547c9c7b2dcba9126c23a17711cb",
"assets/assets/svg/timeout.svg": "0237d0b5535dd617c2ac38213529d32d",
"assets/assets/svg/timeout1.svg": "e9433048786c490395a148099297701a",
"assets/assets/svg/tropy.svg": "909a0b50d418210aa2703f025874cec0",
"assets/assets/svg/tropy1.svg": "86e3dd0d618506ff8db1f42ee904f5d2",
"assets/assets/svg/uk.svg": "37021aededa55c7895cc44011ae32e48",
"assets/FontManifest.json": "bcd363875f0d2b53eddfab58d4b6c2da",
"assets/fonts/MaterialIcons-Regular.otf": "32f8971810d5fcf8a2c6e832b4039bae",
"assets/NOTICES": "0a246a251cee3e02527426e7afdfd1d6",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/flutter_soloud/web/init_module.dart.js": "ea0b343660fd4dace81cfdc2910d14e6",
"assets/packages/flutter_soloud/web/libflutter_soloud_plugin.js": "fda499f4cf7725c740cf53d28b8970e5",
"assets/packages/flutter_soloud/web/libflutter_soloud_plugin.wasm": "344550f25aa52a7864166bf356d82e80",
"assets/packages/flutter_soloud/web/worker.dart.js": "2fddc14058b5cc9ad8ba3a15749f9aef",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "1227e04108557af384b5967f6c240652",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "8bb5e4c0a5c7d387d6cc68d332802e85",
"/": "8bb5e4c0a5c7d387d6cc68d332802e85",
"main.dart.js": "cfccb34c6a9bd6bf31259607fb576292",
"manifest.json": "4b109dedc117999d6c97a994150acf1d",
"version.json": "287a2c0c939a4ae520224dc5e14e56c4"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
