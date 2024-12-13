import 'dart:ui';

typedef EnableDarkModeCallback = void Function(Brightness brightness);
typedef UpdateAccentColorCallback = void Function(Color color);
typedef AppInstallCompleteCallback = void Function();
typedef AppUninstallCompleteCallback = void Function();

class CallbackManager {
  factory CallbackManager() => _instance;

  CallbackManager._();

  static final CallbackManager _instance = CallbackManager._();

  EnableDarkModeCallback? enableDarkModeCallback;
  UpdateAccentColorCallback? updateAccentColorCallback;
  AppInstallCompleteCallback? appInstallCompleteCallback;
  AppUninstallCompleteCallback? appUninstallCompleteCallback;
}
