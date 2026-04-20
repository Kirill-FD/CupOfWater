// Централизованный вывод: debugPrint, при необходимости заменить на logger

import 'package:flutter/foundation.dart';

void logAppError(String where, Object error, StackTrace stack) {
  debugPrint('[ERROR][$where] $error');
  debugPrint(stack.toString());
}
