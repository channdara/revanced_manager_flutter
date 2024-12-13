package com.mastertipsy.revanced_manager_flutter

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
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
    private lateinit var installReceiver: BroadcastReceiver
    private lateinit var uninstallReceiver: BroadcastReceiver

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        installReceiver = PackageInstallReceiver()
        uninstallReceiver = PackageUninstallReceiver()

        registerInstallReceiver()
        registerUninstallReceiver()

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "installApk" -> {
                    call.argument<String>("filePath")?.let {
                        installApk(it)
                        result.success("Method installApk called")
                    }
                }

                "uninstallApk" -> {
                    call.argument<String>("packageName")?.let {
                        uninstallApk(it)
                        result.success("Method uninstallApk called")
                    }
                }
            }
        }
    }

    override fun onDestroy() {
        unregisterReceiver(installReceiver)
        unregisterReceiver(uninstallReceiver)
        super.onDestroy()
    }

    private fun installApk(filePath: String) {
        val file = File(filePath)
        val uri = FileProvider.getUriForFile(this, "com.revanced.net.revancedmanager", file)
        val intent = Intent(Intent.ACTION_INSTALL_PACKAGE)
        intent.data = uri
        intent.flags = Intent.FLAG_GRANT_READ_URI_PERMISSION
        startActivity(intent)
    }

    private fun uninstallApk(packageName: String) {
        val uri = Uri.parse("package:$packageName")
        val intent = Intent(Intent.ACTION_UNINSTALL_PACKAGE)
        intent.data = uri
        startActivity(intent)
    }

    private fun registerInstallReceiver() {
        val filter = IntentFilter(Intent.ACTION_PACKAGE_ADDED)
        filter.addDataScheme("package")
        registerReceiver(installReceiver, filter)
    }

    private fun registerUninstallReceiver() {
        val filter = IntentFilter(Intent.ACTION_PACKAGE_REMOVED)
        filter.addDataScheme("package")
        registerReceiver(uninstallReceiver, filter)
    }

    private inner class PackageInstallReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (Intent.ACTION_PACKAGE_ADDED == intent.action) {
                channel.invokeMethod("installApkComplete", true)
            }
        }
    }

    private inner class PackageUninstallReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (Intent.ACTION_PACKAGE_REMOVED == intent.action) {
                channel.invokeMethod("uninstallApkComplete", true)
            }
        }
    }
}
