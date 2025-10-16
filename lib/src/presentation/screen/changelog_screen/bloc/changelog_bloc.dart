import 'package:package_info_plus/package_info_plus.dart';

import '../../../../base/base_bloc.dart';
import '../../../../manager/api_manager.dart';
import '../../../../model/my_application.dart';
import 'changelog_bloc_state.dart';

class ChangelogBloc extends BaseBloc {
  String currentVersion = '';
  MyApplication? latest;

  void fetchGitHubReleases() {
    execute(requesting: () async {
      emitLoading();
      final package = await PackageInfo.fromPlatform();
      final buildNumber = int.parse(package.buildNumber) % 1000;
      currentVersion = '${package.version}+$buildNumber';
      latest = await ApiManager().getMyAppLatestRelease();
      final releases = await ApiManager().getMyAppAllReleases();
      emitLoaded();
      safeEmit(ChangelogStateGotReleases(releases));
    });
  }
}
