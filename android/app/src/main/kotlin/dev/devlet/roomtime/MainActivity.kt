package dev.devlet.roomtime

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "roomtime/call_foreground_service",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> try {
                    CallForegroundService.start(applicationContext)
                    result.success(null)
                } catch (e: RuntimeException) {
                    // e.g. ForegroundServiceStartNotAllowedException
                    result.error("start_failed", e.message, null)
                }
                "stop" -> {
                    CallForegroundService.stop(applicationContext)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
