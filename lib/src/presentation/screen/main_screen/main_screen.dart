import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../base/base_bloc_state.dart';
import '../../../base/base_stateful_bloc.dart';
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
            return Skeletonizer(
              enabled: state is AppBlocStateLoading,
              child: RefreshIndicator(
                key: bloc.refreshIndicatorKey,
                onRefresh: bloc.refreshRevancedApplications,
                child: SingleChildScrollView(
                  controller: bloc.scrollController,
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 128.0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: state is AppBlocStateError
                      ? const AppErrorWidget()
                      : Column(
                          children: items.map((app) {
                            return MainItemWidget(app: app);
                          }).toList(),
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
