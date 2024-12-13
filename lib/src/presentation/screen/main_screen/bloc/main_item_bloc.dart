import 'dart:async';

import '../../../../base/base_bloc.dart';
import '../../../../manager/application_manager.dart';
import '../../../../manager/download_manager.dart';
import '../../../../model/revanced_application.dart';
import 'main_bloc_state.dart';

class MainItemBloc extends BaseBloc {
  bool downloading = false;
  double progressing = 0.0;

  void startDownloadApplication(RevancedApplication application) {
    execute(requesting: () async {
      downloading = true;
      safeEmit(MainStateDownload());
      DownloadManager().downloadRevancedApplication(
        application,
        (progress) {
          progressing = progress;
        },
      ).then((filePath) {
        downloading = false;
        progressing = 0.0;
        safeEmit(MainStateDownload());
        if (filePath.isNotEmpty) {
          ApplicationManager().install(filePath);
        }
      });
      Timer.periodic(const Duration(milliseconds: 250), (timer) {
        if (progressing >= 0.98) {
          downloading = false;
          progressing = 0.0;
          timer.cancel();
        }
        safeEmit(MainStateDownload());
      });
    });
  }
}
