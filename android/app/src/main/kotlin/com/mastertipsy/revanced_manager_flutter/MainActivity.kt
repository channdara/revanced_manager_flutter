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
import androidx.core.net.toUri

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL: String = "com.mastertipsy.revancedmanager"
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
                        result.success(installApk(it))
                    }
                }

                "uninstallApk" -> {
                    call.argument<String>("packageName")?.let {
                        result.success(uninstallApk(it))
                    }
                }

                "launchApp" -> {
                    call.argument<String>("packageName")?.let {
                        result.success(launchApp(it))
                    }
                }

                "getPackageInfo" -> {
                    call.argument<String>("packageName")?.let {
                        result.success(getPackageInfo(it))
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

    private fun installApk(filePath: String): Boolean {
        try {
            val file = File(filePath)
            val uri = FileProvider.getUriForFile(
                this,
                "com.mastertipsy.revancedmanager",
                file,
            )
            val intent = Intent(Intent.ACTION_INSTALL_PACKAGE)
            intent.data = uri
            intent.flags = Intent.FLAG_GRANT_READ_URI_PERMISSION
            startActivity(intent)
            return true
        } catch (_: Exception) {
            return false
        }
    }

    private fun uninstallApk(packageName: String): Boolean {
        try {
            val uri = "package:$packageName".toUri()
            val intent = Intent(Intent.ACTION_UNINSTALL_PACKAGE)
            intent.data = uri
            startActivity(intent)
            return true
        } catch (_: Exception) {
            return false
        }
    }

    private fun launchApp(packageName: String): Boolean {
        try {
            val intent = packageManager.getLaunchIntentForPackage(packageName)
            startActivity(intent)
            return true
        } catch (_: Exception) {
            return false
        }
    }

    private fun getPackageInfo(packageName: String): Map<String, Any?>? {
        try {
            val packageInfo = packageManager.getPackageInfo(packageName, 0)
            if (packageInfo != null) {
                return mapOf("version_name" to packageInfo.versionName)
            }
            return null
        } catch (_: Exception) {
            return null
        }
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
