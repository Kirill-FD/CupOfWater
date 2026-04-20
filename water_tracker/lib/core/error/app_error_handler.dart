// Глобальные перехваты: build-ошибки и несинхронные сбои.

import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_logger.dart';

/// Устанавливается в [main] до [runApp].
void installAppErrorHandlers() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    logAppError('ErrorWidget', details.exception, details.stack ?? StackTrace.current);
    if (kDebugMode) {
      return ErrorWidget(details.exception);
    }
    return const Material(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Something went wrong. Please restart the app.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    logAppError('PlatformDispatcher', error, stack);
    return !kDebugMode; // true в release, чтобы движок не падал
  };
}
