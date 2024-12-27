import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../base/base_bloc_state.dart';
import '../../../base/base_stateful_bloc.dart';
import '../../../model/mock_data.dart';
import '../../widget/app_error_widget.dart';
import 'bloc/changelog_bloc.dart';
import 'bloc/changelog_bloc_state.dart';
import 'widget/changelog_item_widget.dart';

class ChangelogScreen extends StatefulWidget {
  const ChangelogScreen({super.key});

  @override
  State<ChangelogScreen> createState() => _ChangelogScreenState();
}

class _ChangelogScreenState
    extends BaseStatefulBloc<ChangelogScreen, ChangelogBloc> {
  @override
  ChangelogBloc bloc = ChangelogBloc();

  @override
  void initStatePostFrameCallback() {
    super.initStatePostFrameCallback();
    bloc.fetchGitHubReleases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Changelog')),
      body: bloc.builder(
        builder: (context, state) {
          final items = state is ChangelogStateGotReleases
              ? state.items
              : MockData.mockMyApplications();
          return Skeletonizer(
            enabled: state is AppBlocStateLoading,
            child: state is AppBlocStateError
                ? const AppErrorWidget(padding: EdgeInsets.all(16.0))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 128.0),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isCurrent = item.tagName == bloc.currentVersion;
                      final isLatest = item.tagName == bloc.latest?.tagName;
                      return ChangelogItemWidget(
                        application: item,
                        isCurrent: isCurrent,
                        isLatest: isLatest,
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
