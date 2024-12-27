import 'package:flutter/material.dart';

import '../../../../base/base_bloc.dart';
import '../../../../manager/api_manager.dart';
import 'main_bloc_state.dart';

class MainBloc extends BaseBloc {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController scrollController = ScrollController();

  bool get canPop =>
      scrollController.hasClients && scrollController.offset < 50.0;

  void animateToTop() {
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  void reloadApplications() {
    refreshIndicatorKey.currentState?.show();
  }

  void getRevancedApplications() {
    execute(requesting: () async {
      emitLoading();
      final items = await ApiManager().getRevancedApplications();
      emitLoaded();
      safeEmit(MainStateGotData(items));
      _fetchGitHubLatestRelease();
    });
  }

  Future<void> refreshRevancedApplications() async {
    await execute(requesting: () async {
      final items = await ApiManager().getRevancedApplications();
      safeEmit(MainStateGotData(items));
    });
  }

  void _fetchGitHubLatestRelease() {
    ApiManager().checkUpdateForManagerApp().then((data) {
      safeEmit(MainStateCheckUpdate(data.updateAvailable));
    });
  }
}
