import 'package:flutter/services.dart';
import 'package:installed_apps/installed_apps.dart';

class ApplicationManager {
  factory ApplicationManager() => _instance;

  ApplicationManager._();

  static final ApplicationManager _instance = ApplicationManager._();

  final MethodChannel _channel =
      const MethodChannel('com.revanced.net.revancedmanager');

  Future<void> install(
    String filePath, {
    Function(bool complete)? onInstallComplete,
  }) async {
    try {
      await _channel.invokeMethod('installApk', {'filePath': filePath});
      _channel.setMethodCallHandler((handler) async {
        if (handler.method == 'installApkComplete') {
          onInstallComplete?.call(true == handler.arguments);
        }
      });
    } catch (_) {}
  }

  Future<void> uninstall(String packageName) async {
    try {
      await InstalledApps.uninstallApp(packageName);
    } catch (_) {}
  }

  Future<void> open(String packageName) async {
    try {
      await InstalledApps.startApp(packageName);
    } catch (_) {}
  }
}
