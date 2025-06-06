import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../base/base_bloc_state.dart';
import '../../../base/base_stateful_bloc.dart';
import '../../../manager/callback_manager.dart';
import '../../../model/mock_data.dart';
import '../../widget/app_empty_widget.dart';
import '../../widget/app_error_widget.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_bloc_state.dart';
import 'widget/home_app_bar_title_widget.dart';
import 'widget/home_filter_widget.dart';
import 'widget/home_item_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseStatefulBloc<HomeScreen, HomeBloc> {
  @override
  HomeBloc bloc = HomeBloc();

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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: HomeAppBarTitleWidget(bloc: bloc),
          actions: [
            IconButton(
              onPressed: bloc.onSearchPressed,
              icon: bloc.builder(
                buildWhen: (p, c) => c is HomeStateSwitchAppBar,
                builder: (context, state) {
                  return bloc.searchAppBar
                      ? const Icon(Icons.close_rounded)
                      : const Icon(Icons.search_rounded);
                },
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(44.0),
            child: HomeFilterWidget(bloc: bloc),
          ),
        ),
        body: bloc.builder(
          buildWhen: (p, c) =>
              c is AppBlocStateLoading ||
              c is AppBlocStateError ||
              c is HomeStateGotData,
          builder: (context, state) {
            final items = state is HomeStateGotData
                ? bloc.items
                : MockData.mockApplications();
            final itemCount =
                state is AppBlocStateError || items.isEmpty ? 1 : items.length;
            final showError = state is AppBlocStateError && itemCount == 1;
            final showEmpty = state is HomeStateGotData && items.isEmpty;
            return Skeletonizer(
              enabled: state is AppBlocStateLoading,
              child: RefreshIndicator(
                key: bloc.refreshIndicatorKey,
                onRefresh: bloc.refreshRevancedApplications,
                child: ListView.builder(
                  controller: homeScrollController,
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (showEmpty) return const AppEmptyWidget();
                    if (showError) return const AppErrorWidget();
                    return HomeItemWidget(bloc: bloc, app: items[index]);
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
