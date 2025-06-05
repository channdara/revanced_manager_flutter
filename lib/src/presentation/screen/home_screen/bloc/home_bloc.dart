import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../base/base_bloc.dart';
import '../../../../manager/api_manager.dart';
import '../../../../manager/application_manager.dart';
import '../../../../manager/download_manager.dart';
import '../../../../model/download_status.dart';
import '../../../../model/home_tab_bar.dart';
import '../../../../model/revanced_application.dart';
import 'home_bloc_state.dart';

class HomeBloc extends BaseBloc {
  late TabController tabController;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController scrollController = ScrollController();
  bool searchAppBar = false;

  final Map<String, DownloadStatus> _mapItem = {};
  List<RevancedApplication> _backupItem = [];
  HomeTabBar _selectedTab = HomeTabBar.ALL;
  String _searchText = '';

  bool get canPop =>
      scrollController.hasClients && scrollController.offset < 50.0;

  List<RevancedApplication> get items {
    final copy = switch (_selectedTab) {
      HomeTabBar.ALL => _backupItem,
      HomeTabBar.INSTALLED => _backupItem.where((e) => e.isInstalled).toList(),
      HomeTabBar.NOT_INSTALLED =>
        _backupItem.where((e) => !e.isInstalled).toList(),
      HomeTabBar.UPDATE => _backupItem.where((e) => e.updateAvailable).toList(),
    };
    if (_searchText.isNotEmpty) {
      return copy.where((e) {
        return e.appName.toLowerCase().contains(_searchText.toLowerCase());
      }).toList();
    }
    return copy;
  }

  DownloadStatus? getStatus(String id) => _mapItem[id];

  @override
  void dispose() {
    _mapItem.values.forEach((e) => e.timer?.cancel());
    _mapItem.clear();
    _backupItem.clear();
    _selectedTab = HomeTabBar.ALL;
    super.dispose();
  }

  void initialize(TickerProvider vsync) {
    tabController = TabController(
      length: HomeTabBar.values.length,
      vsync: vsync,
    );
  }

  void animateToTop() {
    if (scrollController.offset < 100) return;
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  void reloadApplications() {
    refreshIndicatorKey.currentState?.show();
  }

  void onTabBarChanged(int index) {
    _selectedTab = HomeTabBar.values[index];
    safeEmit(HomeStateGotData());
  }

  void onSearchPressed() {
    searchAppBar = !searchAppBar;
    if (!searchAppBar) {
      _searchText = '';
      safeEmit(HomeStateGotData());
    }
    safeEmit(HomeStateSwitchAppBar());
  }

  void onSearchTextChanged(String text) {
    _searchText = text;
    safeEmit(HomeStateGotData());
  }

  void getRevancedApplications() {
    execute(requesting: () async {
      emitLoading();
      _backupItem = await ApiManager().getRevancedApplications();
      emitLoaded();
      safeEmit(HomeStateGotData());
    });
  }

  Future<void> refreshRevancedApplications() async {
    await execute(requesting: () async {
      _backupItem = await ApiManager().getRevancedApplications();
      safeEmit(HomeStateGotData());
    });
  }

  void startDownloadApplication(RevancedApplication app) {
    final packageName = app.androidPackageName;
    try {
      _mapItem[packageName] = DownloadStatus();
      final status = getStatus(packageName);
      safeEmit(HomeStateDownloadApplication());
      DownloadManager().downloadRevancedApplication(app, (progress) {
        status?.progressing = progress;
      }).then((filePath) {
        _resetDownloading(packageName);
        safeEmit(HomeStateDownloadApplication());
        if (filePath.isNotEmpty) ApplicationManager().installApk(filePath);
      });
      status?.timer =
          Timer.periodic(const Duration(milliseconds: 250), (timer) {
        if (status.progressing >= 1.0) {
          _resetDownloading(packageName);
        }
        safeEmit(HomeStateDownloadApplication());
      });
    } catch (_) {
      _resetDownloading(packageName);
      safeEmit(HomeStateDownloadApplication());
    }
  }

  void cancelDownloadingApplication(String packageName) {
    try {
      DownloadManager().cancelDownloading(packageName);
      _resetDownloading(packageName);
      safeEmit(HomeStateDownloadApplication());
    } catch (_) {}
  }

  void _resetDownloading(String packageName) {
    final status = getStatus(packageName);
    status?.downloading = false;
    status?.progressing = 0.0;
    status?.timer?.cancel();
    status?.timer = null;
  }
}
