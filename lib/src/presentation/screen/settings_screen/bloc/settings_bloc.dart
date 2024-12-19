import 'dart:async';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../base/base_bloc.dart';
import '../../../../extension/string_extension.dart';
import '../../../../manager/api_manager.dart';
import '../../../../manager/application_manager.dart';
import '../../../../manager/download_manager.dart';
import '../../../../manager/preferences_manager.dart';
import '../../../../model/my_application.dart';
import 'settings_bloc_state.dart';

class SettingsBloc extends BaseBloc {
  String currentVersion = '';
  String lastUpdateCheck = '';
  bool downloading = false;
  double? progressing;
  int totalCacheSize = 0;

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void openLinkInExternalBrowser(String? uri) {
    if (uri == null || uri.isEmpty) return;
    launchUrl(Uri.parse(uri), mode: LaunchMode.externalApplication);
  }

  Future<void> getCacheDirectorySize() async {
    try {
      totalCacheSize = 0;
      final directory = await getTemporaryDirectory();
      directory.listSync().forEach((file) {
        totalCacheSize += file.statSync().size;
      });
      safeEmit(SettingsStateDirectoryCacheSize());
    } catch (_) {
      totalCacheSize = 0;
      safeEmit(SettingsStateDirectoryCacheSize());
    }
  }

  Future<void> clearCache() async {
    try {
      if (totalCacheSize < 1) return;
      final directory = await getTemporaryDirectory();
      if (directory.existsSync()) {
        directory.deleteSync(recursive: true);
        totalCacheSize = 0;
        safeEmit(SettingsStateDirectoryCacheSize());
      }
    } catch (_) {}
  }

  Future<void> getCurrentAppVersion() async {
    final package = await PackageInfo.fromPlatform();
    currentVersion = '${package.version}+${package.buildNumber}';
    lastUpdateCheck = await PreferencesManager().lastUpdateCheck();
    safeEmit(SettingsStateGotCurrentVersion());
  }

  Future<void> checkForUpdate() async {
    final now = DateTime.now();
    lastUpdateCheck = await PreferencesManager().lastUpdateCheck(now);
    _fetchGitHubLatestRelease();
  }

  void _fetchGitHubLatestRelease() {
    execute(requesting: () async {
      emitLoading();
      final appRelease = await ApiManager().getMyApplicationFromGitHub();
      final versionFromGitHub = appRelease.tagName.toVersionInteger();
      final packageVersion = currentVersion.toVersionInteger();
      final updateAvailable = versionFromGitHub > packageVersion;
      if (updateAvailable) {
        _downloadLatestAppVersion(appRelease);
      } else {
        emitLoaded();
        safeEmit(SettingsStateNoUpdateAvailable());
      }
    }, onError: (_) {
      emitLoaded();
      _resetDownloading();
      safeEmit(SettingsStateNoUpdateAvailable());
    });
  }

  void _downloadLatestAppVersion(MyApplication app) {
    try {
      downloading = true;
      DownloadManager().downloadMyApplication(app, (progress) {
        progressing = progress;
      }).then((filePath) {
        _resetDownloading();
        emitLoaded();
        if (filePath.isNotEmpty) {
          ApplicationManager().installApk(
            filePath,
            callbackWillCall: false,
          );
        }
      });
      _timer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
        if ((progressing ?? 0.0) >= 0.98) _resetDownloading();
        emitLoading();
      });
    } catch (_) {
      _resetDownloading();
      emitLoaded();
    }
  }

  void _resetDownloading() {
    downloading = false;
    progressing = null;
    _timer?.cancel();
    _timer = null;
  }
}