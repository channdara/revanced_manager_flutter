import 'package:flutter/material.dart';

import '../../../../base/base_bloc.dart';
import '../../../../manager/api_manager.dart';
import 'main_bloc_state.dart';

class MainBloc extends BaseBloc {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

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
