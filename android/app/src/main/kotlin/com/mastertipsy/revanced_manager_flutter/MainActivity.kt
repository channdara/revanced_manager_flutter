package com.mastertipsy.revanced_manager_flutter

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File


class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL: String = "com.revanced.net.revancedmanager"
    }

    private lateinit var channel: MethodChannel
    private lateinit var receiver: BroadcastReceiver

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        receiver = PackageInstallReceiver(channel)

        val filter = IntentFilter(Intent.ACTION_PACKAGE_ADDED)
        filter.addDataScheme("package")
        registerReceiver(receiver, filter)

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "installApk" -> call.argument<String>("filePath")?.let { installApk(it) }
            }
        }
    }

    override fun onDestroy() {
        unregisterReceiver(receiver)
        super.onDestroy()
    }

    private fun installApk(filePath: String) {
        val file = File(filePath)
        val uri = FileProvider.getUriForFile(this, "com.revanced.net.revancedmanager", file)
        val intent = Intent(Intent.ACTION_INSTALL_PACKAGE)
        intent.setData(uri)
        intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        startActivity(intent)
    }
}

private class PackageInstallReceiver(private val channel: MethodChannel) : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (Intent.ACTION_PACKAGE_ADDED == intent.action) {
            channel.invokeMethod("installApkComplete", true)
        }
    }
}