import 'dart:ui';

typedef EnableDarkModeCallback = void Function(Brightness brightness);
typedef AppInstallCompleteCallback = void Function();
typedef AppUninstallCompleteCallback = void Function();

class CallbackManager {
  factory CallbackManager() => _instance;

  CallbackManager._();

  static final CallbackManager _instance = CallbackManager._();

  EnableDarkModeCallback? enableDarkModeCallback;
  AppInstallCompleteCallback? appInstallCompleteCallback;
  AppUninstallCompleteCallback? appUninstallCompleteCallback;
}
