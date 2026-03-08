import 'package:flutter/foundation.dart';

class IsolateHelper {
  /// Offloads data processing to a background Isolate.
  static Future<R> computeInIsolate<Q, R>(
    ComputeCallback<Q, R> callback,
    Q message,
  ) async {
    return await compute(callback, message);
  }
}
