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

  Future<void> getRevancedApplications([bool isRefresh = true]) async {
    await execute(requesting: () async {
      if (!isRefresh) emitLoading();
      final items = await ApiManager().getRevancedApplications();
      emitLoaded();
      safeEmit(MainStateGotData(items));
    });
  }
}
