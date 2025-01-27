import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../base/base_bloc.dart';
import '../../../../manager/api_manager.dart';
import '../../../../manager/application_manager.dart';
import '../../../../manager/download_manager.dart';
import '../../../../model/revanced_application.dart';
import 'download_status.dart';
import 'main_bloc_state.dart';

class MainBloc extends BaseBloc {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController scrollController = ScrollController();

  final Map<String, DownloadStatus> _mapItem = {};

  bool get canPop =>
      scrollController.hasClients && scrollController.offset < 50.0;

  DownloadStatus? getStatus(String id) => _mapItem[id];

  @override
  void dispose() {
    _mapItem.values.forEach((e) => e.timer?.cancel());
    _mapItem.clear();
    super.dispose();
  }

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

  void startDownloadApplication(RevancedApplication app) {
    final packageName = app.androidPackageName;
    try {
      _mapItem[packageName] = DownloadStatus();
      final status = getStatus(packageName);
      safeEmit(MainStateDownloadApplication());
      DownloadManager().downloadRevancedApplication(app, (progress) {
        status?.progressing = progress;
      }).then((filePath) {
        _resetDownloading(packageName);
        safeEmit(MainStateDownloadApplication());
        if (filePath.isNotEmpty) ApplicationManager().installApk(filePath);
      });
      status?.timer =
          Timer.periodic(const Duration(milliseconds: 250), (timer) {
        if (status.progressing >= 0.98) {
          _resetDownloading(packageName);
        }
        safeEmit(MainStateDownloadApplication());
      });
    } catch (_) {
      _resetDownloading(packageName);
      safeEmit(MainStateDownloadApplication());
    }
  }

  void cancelDownloadingApplication(String packageName) {
    try {
      DownloadManager().cancelDownloading(packageName);
      _resetDownloading(packageName);
      safeEmit(MainStateDownloadApplication());
    } catch (_) {}
  }

  void _fetchGitHubLatestRelease() {
    ApiManager().checkUpdateForManagerApp().then((data) {
      safeEmit(MainStateCheckUpdate(data.updateAvailable));
    });
  }

  void _resetDownloading(String packageName) {
    final status = getStatus(packageName);
    status?.downloading = false;
    status?.progressing = 0.0;
    status?.timer?.cancel();
    status?.timer = null;
  }
}
