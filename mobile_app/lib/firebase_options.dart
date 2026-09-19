import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

/// Firebase project config for Shatably (project: shatably-app-d14cd).
///
/// Only the web target is configured — the deployed build (GitHub Pages) is
/// web-only for now. Android/iOS configs are added later, once native
/// publishing is picked back up (they need their own `google-services.json`
/// / `GoogleService-Info.plist`, not just this options object).
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    throw UnsupportedError(
      'DefaultFirebaseOptions have not been configured for ${defaultTargetPlatform.name} yet — only Web is set up so far.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCuh4ZHizgSuD4NKBg_KvuS1G1gVePDQh4',
    authDomain: 'shatably-app-d14cd.firebaseapp.com',
    projectId: 'shatably-app-d14cd',
    storageBucket: 'shatably-app-d14cd.firebasestorage.app',
    messagingSenderId: '961738204293',
    appId: '1:961738204293:web:009215d8059ac378bcb5ec',
    measurementId: 'G-E418CRNNK9',
  );
}
