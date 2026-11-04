import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Logs a diagnostic. `dart:developer` alone prints nothing in a compiled
/// web app, so debug and profile builds also print it to the console (the
/// browser's DevTools on web). Release builds keep only `developer.log`.
void devLog(
  String message, {
  required String name,
  Object? error,
  StackTrace? stackTrace,
}) {
  developer.log(message, name: name, error: error, stackTrace: stackTrace);
  if (kReleaseMode) return;
  final category = error == null ? '' : ' [${error.runtimeType}] $error';
  debugPrint('[$name] $message$category');
  if (stackTrace != null) debugPrint('$stackTrace');
}
