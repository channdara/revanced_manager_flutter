import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../base/base_bloc_state.dart';
import '../../../base/base_stateful_bloc.dart';
import '../../../manager/callback_manager.dart';
import '../settings_screen.dart';
import 'bloc/main_bloc.dart';
import 'bloc/main_bloc_state.dart';
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
    bloc.getRevancedApplications(false);
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
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsScreen()));
              },
              icon: const Icon(Icons.settings_rounded),
            ),
          ],
        ),
        body: bloc.builder(
          builder: (context, state) {
            if (state is AppBlocStateLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(strokeWidth: 3.0),
              );
            }
            if (state is MainStateGotData) {
              return RefreshIndicator(
                key: bloc.refreshIndicatorKey,
                onRefresh: bloc.getRevancedApplications,
                child: SingleChildScrollView(
                  controller: bloc.scrollController,
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 128.0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: state.items.map((application) {
                      return MainItemWidget(application: application);
                    }).toList(),
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
