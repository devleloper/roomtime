import 'package:flutter/foundation.dart';

class IsolateHelper {
  /// Offloads intensive data processing to a background Isolate
  /// to prevent blocking the main Flutter UI thread (guaranteeing 60/120 FPS).
  static Future<R> computeInIsolate<Q, R>(
    ComputeCallback<Q, R> callback,
    Q message,
  ) async {
    return await compute(callback, message);
  }

  // Future sophisticated isolate pool can be added here
}
