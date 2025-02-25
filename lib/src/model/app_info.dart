class AppInfo {
  AppInfo(this.versionName);

  factory AppInfo.from(dynamic data) {
    return AppInfo(data['version_name'] as String? ?? '');
  }

  final String versionName;
}
