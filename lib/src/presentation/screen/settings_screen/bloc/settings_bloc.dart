import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../base/base_bloc.dart';
import '../../../../extension/string_extension.dart';
import '../../../../manager/api_manager.dart';
import '../../../../manager/preferences_manager.dart';
import 'settings_bloc_state.dart';

class SettingsBloc extends BaseBloc {
  String currentVersion = '';
  String lastUpdateCheck = '';
  double? progressing;

  Future<void> checkForUpdate() async {
    final now = DateTime.now();
    lastUpdateCheck = await PreferencesManager().lastUpdateCheck(now);
    _fetchGitHubLatestRelease();
  }

  Future<void> getCurrentAppVersion() async {
    final package = await PackageInfo.fromPlatform();
    currentVersion = package.version;
    lastUpdateCheck = await PreferencesManager().lastUpdateCheck();
    safeEmit(SettingsStateGotCurrentVersion());
  }

  void _fetchGitHubLatestRelease() {
    execute(
      requesting: () async {
        emitLoading();
        final appRelease = await ApiManager().getMyApplicationFromGitHub();
        final versionFromGitHub = appRelease.tagName.toVersionInteger();
        final packageVersion = currentVersion.toVersionInteger();
        final updateAvailable = versionFromGitHub > packageVersion;
        emitLoaded();
        if (updateAvailable) safeEmit(SettingsStateUpdateAvailable());
      },
      onError: (exception) {
        safeEmit(SettingsStateUpdateAvailable());
      },
    );
  }

  void openLinkInExternalBrowser(String? uri) {
    if (uri == null || uri.isEmpty) return;
    launchUrl(Uri.parse(uri), mode: LaunchMode.externalApplication);
  }
}
