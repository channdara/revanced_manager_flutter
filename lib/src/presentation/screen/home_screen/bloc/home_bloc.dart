import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../base/base_bloc.dart';
import '../../../../manager/api_manager.dart';
import '../../../../manager/application_manager.dart';
import '../../../../manager/download_manager.dart';
import '../../../../model/download_status.dart';
import '../../../../model/home_filter.dart';
import '../../../../model/revanced_application.dart';
import 'home_bloc_state.dart';

final ScrollController homeScrollController = ScrollController();

class HomeBloc extends BaseBloc {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool searchAppBar = false;
  HomeFilter selectedFilter = HomeFilter.ALL;

  final Map<String, DownloadStatus> _mapItem = {};
  List<RevancedApplication> _backupItem = [];
  String _searchText = '';

  List<RevancedApplication> get items {
    final copy = switch (selectedFilter) {
      HomeFilter.ALL => _backupItem,
      HomeFilter.INSTALLED => _backupItem.where((e) => e.isInstalled).toList(),
      HomeFilter.NOT_INSTALLED =>
        _backupItem.where((e) => !e.isInstalled).toList(),
      HomeFilter.UPDATE => _backupItem.where((e) => e.updateAvailable).toList(),
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
    super.dispose();
  }

  void reloadApplications() {
    refreshIndicatorKey.currentState?.show();
  }

  void onChoiceChipSelected(HomeFilter filter) {
    selectedFilter = filter;
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
