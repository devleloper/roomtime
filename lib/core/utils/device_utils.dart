import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceUtils {
  static bool? _hasDynamicIsland;

  /// Specifically checks if the current iOS device has a Dynamic Island
  /// based on the UTSName (Model Identifier).
  /// Falls back to false for non-iOS devices or unrecognized models.
  static Future<bool> hasDynamicIsland() async {
    // Return memoized result if available
    if (_hasDynamicIsland != null) {
      return _hasDynamicIsland!;
    }

    if (!Platform.isIOS) {
      _hasDynamicIsland = false;
      return false;
    }

    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final iosInfo = await deviceInfoPlugin.iosInfo;
      final machineId = iosInfo.utsname.machine;

      // Machine IDs that have a Dynamic Island:
      // iPhone 14 Pro: iPhone15,2
      // iPhone 14 Pro Max: iPhone15,3
      // iPhone 15: iPhone15,4
      // iPhone 15 Plus: iPhone15,5
      // iPhone 15 Pro: iPhone16,1
      // iPhone 15 Pro Max: iPhone16,2
      // iPhone 16 range: iPhone17,*

      final dynamicIslandModels = [
        'iPhone15,2',
        'iPhone15,3',
        'iPhone15,4',
        'iPhone15,5',
        'iPhone16,1',
        'iPhone16,2',
      ];

      // Any future iPhone starting from the 16 line will likely include the island
      bool hasIsland =
          dynamicIslandModels.contains(machineId) ||
          (machineId.startsWith('iPhone17,'));

      // Note: Simulators return "x86_64" or "arm64" for machine IDs.
      _hasDynamicIsland = hasIsland;
      return hasIsland;
    } catch (e) {
      // Fallback
      _hasDynamicIsland = false;
      return false;
    }
  }
}
