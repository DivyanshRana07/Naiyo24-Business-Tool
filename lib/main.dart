import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // Riverpod ProviderScope wraps the entire widget tree.
    const ProviderScope(
      child: AppShell(),
    ),
  );
}
