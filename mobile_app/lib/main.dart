import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;

import 'app.dart';
import 'state/app_state.dart';

void main() {
  runApp(
    pv.ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const ShatablyApp(),
    ),
  );
}
