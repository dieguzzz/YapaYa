import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppBootstrap {
  const AppBootstrap._();

  static Future<void> run(Future<void> Function() runner) async {
    await runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        _registerErrorHandlers();
        await runner();
      },
      (error, stackTrace) {
        _logError('Uncaught zone error', error, stackTrace);
      },
    );
  }

  static void _registerErrorHandlers() {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      _logError('Flutter framework error', details.exception, details.stack);
    };

    PlatformDispatcher.instance.onError = (error, stackTrace) {
      _logError('Platform dispatcher error', error, stackTrace);
      return true;
    };
  }

  static void _logError(String context, Object error, StackTrace? stackTrace) {
    log(
      '$context: $error',
      name: 'AppBootstrap',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
