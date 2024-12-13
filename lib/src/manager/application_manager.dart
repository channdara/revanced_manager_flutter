import 'package:flutter/services.dart';
import 'package:installed_apps/installed_apps.dart';

import 'callback_manager.dart';

class ApplicationManager {
  factory ApplicationManager() {
    _instance._setMethodCallHandler();
    return _instance;
  }

  ApplicationManager._();

  static final ApplicationManager _instance = ApplicationManager._();

  final MethodChannel _channel =
      const MethodChannel('com.revanced.net.revancedmanager');

  Future<void> install(String filePath) async {
    try {
      await _channel.invokeMethod('installApk', {'filePath': filePath});
    } catch (_) {}
  }

  Future<void> uninstall(String packageName) async {
    try {
      await _channel.invokeMethod('uninstallApk', {'packageName': packageName});
    } catch (_) {}
  }

  Future<void> open(String packageName) async {
    try {
      await InstalledApps.startApp(packageName);
    } catch (_) {}
  }

  void _setMethodCallHandler() {
    _channel.setMethodCallHandler((handler) async {
      switch (handler.method) {
        case 'installApkComplete':
          CallbackManager().appInstallCompleteCallback?.call();
        case 'uninstallApkComplete':
          CallbackManager().appUninstallCompleteCallback?.call();
      }
    });
  }
}
