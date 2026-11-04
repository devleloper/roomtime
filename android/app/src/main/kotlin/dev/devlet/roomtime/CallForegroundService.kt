package dev.devlet.roomtime

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import android.util.Log

/**
 * Keeps the process in the foreground while a call is active so audio keeps
 * flowing when the app is in the background or the screen is off
 * (Android 14+ requires a typed foreground service for the microphone).
 *
 * Started and stopped from Dart over the `roomtime/call_foreground_service`
 * channel (see MainActivity). The only type is `microphone`: the camera is
 * paused in the background by the Dart side, so no camera type is declared.
 */
class CallForegroundService : Service() {
    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val notification = buildNotification()
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                startForeground(NOTIFICATION_ID, notification, grantedServiceTypes(this))
            } else {
                startForeground(NOTIFICATION_ID, notification)
            }
        } catch (e: RuntimeException) {
            // e.g. ForegroundServiceStartNotAllowedException; the call goes on
            // without background protection.
            Log.w(TAG, "Could not start the call foreground service", e)
            stopSelf()
        }
        return START_NOT_STICKY
    }

    private fun buildNotification(): Notification {
        val launch = packageManager.getLaunchIntentForPackage(packageName)
        val contentIntent = PendingIntent.getActivity(
            this,
            0,
            launch,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ensureChannel()
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }
        return builder
            .setContentTitle(getString(R.string.call_notification_title))
            .setContentText(getString(R.string.call_notification_text))
            .setSmallIcon(android.R.drawable.presence_audio_online)
            .setContentIntent(contentIntent)
            .setOngoing(true)
            .setCategory(Notification.CATEGORY_CALL)
            .build()
    }

    private fun ensureChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = getSystemService(NotificationManager::class.java)
        if (manager.getNotificationChannel(CHANNEL_ID) != null) return
        manager.createNotificationChannel(
            NotificationChannel(
                CHANNEL_ID,
                getString(R.string.call_notification_channel),
                NotificationManager.IMPORTANCE_LOW,
            ),
        )
    }

    companion object {
        private const val TAG = "CallForegroundService"
        private const val CHANNEL_ID = "ongoing_call"
        private const val NOTIFICATION_ID = 1001

        fun start(context: Context) {
            // Nothing to keep alive without microphone access, and a typed
            // service cannot start without it.
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R &&
                grantedServiceTypes(context) == 0
            ) {
                return
            }
            val intent = Intent(context, CallForegroundService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        private fun grantedServiceTypes(context: Context): Int {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) return 0
            return if (isGranted(context, Manifest.permission.RECORD_AUDIO)) {
                ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE
            } else {
                0
            }
        }

        private fun isGranted(context: Context, permission: String) =
            context.checkSelfPermission(permission) == PackageManager.PERMISSION_GRANTED

        fun stop(context: Context) {
            context.stopService(Intent(context, CallForegroundService::class.java))
        }
    }
}
