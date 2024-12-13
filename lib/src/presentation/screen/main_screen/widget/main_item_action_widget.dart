import 'package:flutter/material.dart';

import '../../../../manager/application_manager.dart';
import '../../../../model/revanced_application.dart';
import '../bloc/main_bloc_state.dart';
import '../bloc/main_item_bloc.dart';

class MainItemActionWidget extends StatelessWidget {
  const MainItemActionWidget({
    super.key,
    required this.bloc,
    required this.application,
  });

  final MainItemBloc bloc;
  final RevancedApplication application;

  String get _packageName => application.androidPackageName ?? '';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (application.updateAvailable)
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
        if (true == application.isInstalled)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                ApplicationManager().uninstall(_packageName);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                shape: const RoundedRectangleBorder(),
              ),
              child: const Text('Uninstall'),
            ),
          ),
        if (true == application.isInstalled)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                ApplicationManager().open(_packageName);
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(),
              ),
              child: const Text('Open'),
            ),
          ),
        if (true != application.isInstalled)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                bloc.startDownloadApplication(application);
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
                      minHeight: 16.0,
                      borderRadius: BorderRadius.circular(8.0),
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
