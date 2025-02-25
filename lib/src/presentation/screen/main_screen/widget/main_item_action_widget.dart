import 'package:flutter/material.dart';

import '../../../../manager/application_manager.dart';
import '../../../../model/revanced_application.dart';
import '../../../dialog/cancel_downloading_dialog.dart';
import '../bloc/download_status.dart';
import '../bloc/main_bloc.dart';
import '../bloc/main_bloc_state.dart';

class MainItemActionWidget extends StatelessWidget {
  const MainItemActionWidget({
    super.key,
    required this.bloc,
    required this.app,
  });

  final MainBloc bloc;
  final RevancedApplication app;

  String get _packageName => app.androidPackageName;

  DownloadStatus? get _status => bloc.getStatus(_packageName);

  bool get _downloading => true == _status?.downloading;

  double get _progress => _status?.progressing ?? 0.0;

  void _downloadOrCancel(BuildContext context) {
    if (_downloading) {
      showCancelDownloadingDialog(context, app, () {
        bloc.cancelDownloadingApplication(_packageName);
      });
    } else {
      bloc.startDownloadApplication(app);
    }
  }

  void _cancelAndUninstall() {
    if (_downloading) bloc.cancelDownloadingApplication(_packageName);
    ApplicationManager().uninstallApk(_packageName);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (app.updateAvailable)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _downloadOrCancel(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green,
                padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                shape: const RoundedRectangleBorder(),
              ),
              child: bloc.builder(
                buildWhen: (p, c) => c is MainStateDownloadApplication,
                builder: (context, state) {
                  if (_downloading) {
                    return LinearProgressIndicator(
                      value: _progress,
                      minHeight: 8.0,
                      borderRadius: BorderRadius.circular(6.0),
                    );
                  }
                  return const Text('Update');
                },
              ),
            ),
          ),
        if (app.isInstalled)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _cancelAndUninstall();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                shape: const RoundedRectangleBorder(),
              ),
              child: const Text('Uninstall'),
            ),
          ),
        if (app.isInstalled)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                ApplicationManager().launchApp(_packageName);
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(),
              ),
              child: const Text('Open'),
            ),
          ),
        if (!app.isInstalled)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _downloadOrCancel(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                shape: const RoundedRectangleBorder(),
              ),
              child: bloc.builder(
                buildWhen: (p, c) => c is MainStateDownloadApplication,
                builder: (context, state) {
                  if (_downloading) {
                    return LinearProgressIndicator(
                      value: _progress,
                      minHeight: 8.0,
                      borderRadius: BorderRadius.circular(6.0),
                    );
                  }
                  return const Text('Download');
                },
              ),
            ),
          ),
      ],
    );
  }
}
