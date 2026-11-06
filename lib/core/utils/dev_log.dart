import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

void devLog(
  String message, {
  required String name,
  Object? error,
  StackTrace? stackTrace,
}) {
  developer.log(message, name: name, error: error, stackTrace: stackTrace);
  // dart:developer is silent in compiled web builds, so also print to the console in debug/profile.
  if (kReleaseMode) {
    return;
  }

  final category = error == null ? '' : ' [${error.runtimeType}] $error';
  debugPrint('[$name] $message$category');
  if (stackTrace != null) {
    debugPrint('$stackTrace');
  }
}
