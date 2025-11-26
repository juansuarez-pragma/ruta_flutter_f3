import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/core/core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FakeStoreApp());
}

/// Se asegura de liberar recursos al cerrar la app.
class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      InjectionContainer.dispose();
    }
  }
}
