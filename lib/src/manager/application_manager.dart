import 'package:device_info_plus/device_info_plus.dart';
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
      const MethodChannel('com.mastertipsy.revancedmanager');
  bool _willCallInstallCompleteCallback = true;
  bool _willCallUninstallCompleteCallback = true;

  Future<void> installApk(
    String filePath, {
    bool callbackWillCall = true,
  }) async {
    try {
      _willCallInstallCompleteCallback = callbackWillCall;
      await _channel.invokeMethod('installApk', {'filePath': filePath});
    } catch (_) {}
  }

  Future<void> uninstallApk(
    String packageName, {
    bool callbackWillCall = true,
  }) async {
    try {
      _willCallUninstallCompleteCallback = callbackWillCall;
      await _channel.invokeMethod('uninstallApk', {'packageName': packageName});
    } catch (_) {}
  }

  Future<void> openApp(String packageName) async {
    try {
      await InstalledApps.startApp(packageName);
    } catch (_) {}
  }

  Future<String> getCPUArchitecture() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.supportedAbis.join(', ');
  }

  void _setMethodCallHandler() {
    _channel.setMethodCallHandler((handler) async {
      switch (handler.method) {
        case 'installApkComplete':
          if (_willCallInstallCompleteCallback) {
            CallbackManager().appInstallCompleteCallback?.call();
          }
        case 'uninstallApkComplete':
          if (_willCallUninstallCompleteCallback) {
            CallbackManager().appUninstallCompleteCallback?.call();
          }
      }
    });
  }
}
