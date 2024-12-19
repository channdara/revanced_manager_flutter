import 'dart:async';

import '../../../../base/base_bloc.dart';
import '../../../../manager/application_manager.dart';
import '../../../../manager/download_manager.dart';
import '../../../../model/revanced_application.dart';
import 'main_bloc_state.dart';

class MainItemBloc extends BaseBloc {
  bool downloading = false;
  double progressing = 0.0;

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startDownloadApplication(RevancedApplication app) {
    try {
      downloading = true;
      safeEmit(MainStateDownloadApplication());
      DownloadManager().downloadRevancedApplication(app, (progress) {
        progressing = progress;
      }).then((filePath) {
        _resetDownloading();
        safeEmit(MainStateDownloadApplication());
        if (filePath.isNotEmpty) ApplicationManager().installApk(filePath);
      });
      _timer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
        if (progressing >= 0.98) _resetDownloading();
        safeEmit(MainStateDownloadApplication());
      });
    } catch (_) {
      _resetDownloading();
      safeEmit(MainStateDownloadApplication());
    }
  }

  void cancelDownloadingApplication(String packageName) {
    try {
      DownloadManager().cancelDownloading(packageName);
      _resetDownloading();
      safeEmit(MainStateDownloadApplication());
    } catch (_) {}
  }

  void _resetDownloading() {
    downloading = false;
    progressing = 0.0;
    _timer?.cancel();
    _timer = null;
  }
}
