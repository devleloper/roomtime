import 'package:flutter/foundation.dart';

/// Earpiece routing and the immersive call UI exist only in the native
/// phone and tablet apps.
bool get isMobilePlatform =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);

/// Touch is the main input: phones and tablets, mobile browsers included
/// (UX3-11). Decides autofocus, the camera flip control and the phone Home.
bool get isTouchPlatform =>
    defaultTargetPlatform == TargetPlatform.iOS ||
    defaultTargetPlatform == TargetPlatform.android;

/// The native macOS app (its window title bar overlaps the content).
bool get isMacOSApp => !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
