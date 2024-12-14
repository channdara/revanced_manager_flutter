import 'package:flutter/material.dart';

import '../../../../manager/application_manager.dart';
import '../../../../model/revanced_application.dart';
import '../bloc/main_bloc_state.dart';
import '../bloc/main_item_bloc.dart';

class MainItemActionWidget extends StatelessWidget {
  const MainItemActionWidget({
    super.key,
    required this.bloc,
    required this.app,
  });

  final MainItemBloc bloc;
  final RevancedApplication app;

  String get _packageName => app.androidPackageName ?? '';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (app.updateAvailable)
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green,
                shape: const RoundedRectangleBorder(),
              ),
              child: const Text('Update'),
            ),
          ),
        if (true == app.isInstalled)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                ApplicationManager().uninstallApk(_packageName);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                shape: const RoundedRectangleBorder(),
              ),
              child: const Text('Uninstall'),
            ),
          ),
        if (true == app.isInstalled)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                ApplicationManager().openApp(_packageName);
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(),
              ),
              child: const Text('Open'),
            ),
          ),
        if (true != app.isInstalled)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                bloc.startDownloadApplication(app);
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(),
              ),
              child: bloc.builder(
                buildWhen: (p, c) => c is MainStateDownload,
                builder: (context, state) {
                  if (bloc.downloading) {
                    return LinearProgressIndicator(
                      value: bloc.progressing,
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
