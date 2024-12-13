import 'package:installed_apps/installed_apps.dart';

class RevancedApplication {
  RevancedApplication(
    /// From API
    this.appName,
    this.androidPackageName,
    this.latestVersionCode,
    this.appShortDescription,
    this.requireMicroG,
    this.latestVersionUrl,
    this.icon,
    this.index,

    /// From Local
    this.isInstalled,
    this.installedVersionCode,
    this.isManagerApp,
  );

  factory RevancedApplication.fromJson(dynamic json) {
    final packageName = json['androidPackageName'] as String?;
    return RevancedApplication(
      /// From API
      json['appName'] as String?,
      packageName,
      json['latestVersionCode'] as String?,
      json['appShortDescription'] as String?,
      json['requireMicroG'] as bool?,
      json['latestVersionUrl'] as String?,
      json['icon'] as String?,
      json['index'] as int?,

      /// From Local
      null,
      null,
      packageName?.contains('revancedmanager'),
    );
  }

  static Future<List<RevancedApplication>> fromJsonList(dynamic json) async {
    try {
      final jsonList = json['packages'] as List<dynamic>;
      final List<RevancedApplication> list = [];
      for (final json in jsonList) {
        RevancedApplication item = RevancedApplication.fromJson(json);
        final packageName = item.androidPackageName ?? '';
        if (packageName.isNotEmpty) {
          final appInfo = await InstalledApps.getAppInfo(packageName);
          item = item.copy(
            isInstalled: appInfo != null,
            installedVersionCode: appInfo?.versionName,
          );
        }
        list.add(item);
      }
      return list;
    } catch (_) {
      return [];
    }
  }

  /// From API
  final String? appName;
  final String? androidPackageName;
  final String? latestVersionCode;
  final String? appShortDescription;
  final bool? requireMicroG;
  final String? latestVersionUrl;
  final String? icon;
  final int? index;

  /// From Local
  final bool? isInstalled;
  final String? installedVersionCode;
  final bool? isManagerApp;

  RevancedApplication copy({
    bool? isInstalled,
    String? installedVersionCode,
  }) {
    return RevancedApplication(
      appName,
      androidPackageName,
      latestVersionCode,
      appShortDescription,
      requireMicroG,
      latestVersionUrl,
      icon,
      index,
      isInstalled ?? this.isInstalled,
      installedVersionCode ?? this.installedVersionCode,
      isManagerApp,
    );
  }

  bool get updateAvailable {
    final installed = int.tryParse(
          installedVersionCode?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0',
        ) ??
        0;
    final latest = int.tryParse(
          latestVersionCode?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0',
        ) ??
        0;
    return (isInstalled ?? false) && latest > installed;
  }
}
