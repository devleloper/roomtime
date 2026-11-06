import 'package:flutter/foundation.dart';

bool get isMobilePlatform {
  if (kIsWeb) {
    return false;
  }
  return defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;
}

bool get isTouchPlatform {
  return defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;
}

bool get isMacOSApp {
  return !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
}
