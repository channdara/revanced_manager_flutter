import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../base/base_bloc_state.dart';
import '../../../base/base_stateful_bloc.dart';
import '../../../manager/callback_manager.dart';
import '../about_screen.dart';
import '../settings_screen/settings_screen.dart';
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
            PopupMenuButton(
              elevation: 1.0,
              menuPadding: EdgeInsets.zero,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              position: PopupMenuPosition.under,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.zero,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const SettingsScreen()));
                    },
                    padding: const EdgeInsets.only(left: 16.0, right: 32.0),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.settings_rounded, size: 20.0),
                        SizedBox(width: 16.0),
                        Text('Settings'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const AboutScreen()));
                    },
                    padding: const EdgeInsets.only(left: 16.0, right: 32.0),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_rounded, size: 20.0),
                        SizedBox(width: 16.0),
                        Text('About'),
                      ],
                    ),
                  ),
                ];
              },
            ),
            const SizedBox(width: 8.0),
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
                    children: state.items.map((app) {
                      return MainItemWidget(app: app);
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
