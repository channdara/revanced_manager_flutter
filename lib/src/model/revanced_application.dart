import 'package:installed_apps/installed_apps.dart';

import '../extension/string_extension.dart';

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
  );

  factory RevancedApplication.fromJson(dynamic json) {
    return RevancedApplication(
      /// From API
      json['appName'] as String? ?? '',
      json['androidPackageName'] as String? ?? '',
      json['latestVersionCode'] as String? ?? 'N/A',
      json['appShortDescription'] as String? ?? '',
      json['requireMicroG'] as bool? ?? false,
      json['latestVersionUrl'] as String? ?? '',
      json['icon'] as String? ?? '',
      json['index'] as int? ?? 0,

      /// From Local
      false,
      'N/A',
    );
  }

  static Future<List<RevancedApplication>> fromJsonList(dynamic json) async {
    try {
      final jsonList = json['packages'] as List<dynamic>;
      final List<RevancedApplication> list = [];
      for (final json in jsonList) {
        RevancedApplication item = RevancedApplication.fromJson(json);
        final packageName = item.androidPackageName;
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
  final String appName;
  final String androidPackageName;
  final String latestVersionCode;
  final String appShortDescription;
  final bool requireMicroG;
  final String latestVersionUrl;
  final String icon;
  final int index;

  /// From Local
  final bool isInstalled;
  final String installedVersionCode;

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
    );
  }

  bool get updateAvailable {
    final installed = installedVersionCode.toVersionInteger();
    final latest = latestVersionCode.toVersionInteger();
    return isInstalled && latest > installed;
  }
}
