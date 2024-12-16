import 'dart:async';

import '../../../../base/base_bloc.dart';
import '../../../../manager/application_manager.dart';
import '../../../../manager/download_manager.dart';
import '../../../../model/revanced_application.dart';
import 'main_bloc_state.dart';

class MainItemBloc extends BaseBloc {
  bool downloading = false;
  double progressing = 0.0;

  void startDownloadApplication(RevancedApplication app) {
    execute(requesting: () async {
      downloading = true;
      safeEmit(MainStateDownload());
      DownloadManager().downloadRevancedApplication(
        app,
        (progress) {
          progressing = progress;
        },
      ).then((filePath) {
        _resetDownloading();
        safeEmit(MainStateDownload());
        if (filePath.isNotEmpty) {
          ApplicationManager().installApk(filePath);
        }
      });
      Timer.periodic(const Duration(milliseconds: 250), (timer) {
        if (progressing >= 0.98) {
          _resetDownloading();
          timer.cancel();
        }
        safeEmit(MainStateDownload());
      });
    });
  }

  void cancelDownloadingApplication(String packageName) {
    try {
      DownloadManager().cancelDownloading(packageName);
      _resetDownloading();
      safeEmit(MainStateDownload());
    } catch (_) {}
  }

  void _resetDownloading() {
    downloading = false;
    progressing = 0.0;
  }
}
