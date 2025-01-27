import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../base/base_bloc_state.dart';
import '../../../base/base_stateful_bloc.dart';
import '../../../extension/context_extension.dart';
import '../../../manager/callback_manager.dart';
import '../../../model/mock_data.dart';
import '../../widget/app_error_widget.dart';
import 'bloc/main_bloc.dart';
import 'bloc/main_bloc_state.dart';
import 'widget/main_action_menu_widget.dart';
import 'widget/main_item_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends BaseStatefulBloc<MainScreen, MainBloc> {
  @override
  MainBloc bloc = MainBloc();

  @override
  void initState() {
    super.initState();
    CallbackManager().appInstallCompleteCallback = bloc.reloadApplications;
    CallbackManager().appUninstallCompleteCallback = bloc.reloadApplications;
  }

  @override
  void initStatePostFrameCallback() {
    super.initStatePostFrameCallback();
    bloc.getRevancedApplications();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (value, result) {
        bloc.canPop
            ? SystemChannels.platform.invokeMethod('SystemNavigator.pop')
            : bloc.animateToTop();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Revanced Manager'),
          actions: [
            bloc.builder(
              buildWhen: (p, c) => c is MainStateCheckUpdate,
              builder: (context, state) {
                final updateAvailable =
                    state is MainStateCheckUpdate && state.updateAvailable;
                return Badge(
                  isLabelVisible: updateAvailable,
                  smallSize: 8.0,
                  backgroundColor: Colors.orange,
                  child: MainActionMenuWidget(updateAvailable: updateAvailable),
                );
              },
            ),
            const SizedBox(width: 12.0),
          ],
        ),
        body: bloc.builder(
          buildWhen: (p, c) =>
              c is AppBlocStateLoading ||
              c is AppBlocStateError ||
              c is MainStateGotData,
          builder: (context, state) {
            final items = state is MainStateGotData
                ? state.items
                : MockData.mockApplications();
            final itemCount = state is AppBlocStateError ? 1 : items.length;
            final showError = state is AppBlocStateError && itemCount == 1;
            return Skeletonizer(
              enabled: state is AppBlocStateLoading,
              child: RefreshIndicator(
                key: bloc.refreshIndicatorKey,
                onRefresh: bloc.refreshRevancedApplications,
                child: ListView.builder(
                  controller: bloc.scrollController,
                  padding: context.defaultListPadding(),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (showError) return const AppErrorWidget();
                    return MainItemWidget(bloc: bloc, app: items[index]);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
