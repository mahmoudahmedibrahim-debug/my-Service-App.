import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;

import 'app.dart';
import 'firebase_options.dart';
import 'state/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // If Firebase can't initialize (offline, blocked network, bad config), the
  // app should still boot — phone verification just fails gracefully later,
  // instead of the whole app being stuck on a blank screen. A timeout is
  // required, not just try/catch: when the Firebase JS SDK's dynamic
  // `import()` fails on web, firebase_core_web never completes or rejects
  // its internal Future, so an unprotected `await` hangs forever.
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
        .timeout(const Duration(seconds: 8));
  } catch (e) {
    debugPrint('Firebase failed to initialize: $e');
  }

  runApp(
    pv.ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const ShatablyApp(),
    ),
  );
}
