import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../model/my_application.dart';
import '../model/revanced_application.dart';
import 'application_manager.dart';

class DownloadManager {
  factory DownloadManager() => _instance;

  DownloadManager._();

  static final DownloadManager _instance = DownloadManager._();

  final Dio _dio = Dio();
  final Map<String, CancelToken> _cancelTokens = {};

  Future<String> downloadRevancedApplication(
    RevancedApplication app,
    void Function(double progress) onReceiveProgress,
  ) async {
    final url = app.latestVersionUrl;
    if (url.isEmpty) return '';
    final fileName = '${app.appName} ${app.latestVersionCode}.apk';
    final filePath = (await getTemporaryDirectory()).path;
    final savePath = '$filePath/$fileName';
    if (!File(savePath).existsSync()) {
      final cancelToken = CancelToken();
      _cancelTokens[app.androidPackageName] = cancelToken;
      _enableScreenWakeOn();
      await _dio.downloadUri(
        Uri.parse(url),
        savePath,
        onReceiveProgress: (count, total) {
          onReceiveProgress(
            double.tryParse((count / total).toStringAsFixed(3)) ?? 0.0,
          );
        },
        cancelToken: cancelToken,
      );
      _cancelTokens.remove(app.androidPackageName);
      _disableKeepScreenOn();
    }
    return savePath;
  }

  Future<String> downloadMyApplication(
    MyApplication app,
    void Function(double progress) onReceiveProgress,
  ) async {
    final url = app.downloadUrl;
    if (url.isEmpty) return '';
    final fileName = 'Revanced Manager ${app.tagName}.apk';
    final filePath = (await getTemporaryDirectory()).path;
    final savePath = '$filePath/$fileName';
    if (!File(savePath).existsSync()) {
      const myAppId = 'com.mastertipsy.revancedmanager';
      final cancelToken = CancelToken();
      _cancelTokens[myAppId] = cancelToken;
      _enableScreenWakeOn();
      await _dio.downloadUri(
        Uri.parse(url),
        savePath,
        onReceiveProgress: (count, total) {
          onReceiveProgress(
            double.tryParse((count / total).toStringAsFixed(3)) ?? 0.0,
          );
        },
        cancelToken: cancelToken,
      );
      _cancelTokens.remove(myAppId);
      _disableKeepScreenOn();
    }
    return savePath;
  }

  void cancelDownloading(String packageName) {
    _cancelTokens[packageName]?.cancel();
    _cancelTokens.remove(packageName);
    _disableKeepScreenOn();
  }

  void cancelAllDownloading() {
    _cancelTokens.values.forEach((e) => e.cancel());
    _cancelTokens.clear();
    _disableKeepScreenOn();
  }

  void _enableScreenWakeOn() {
    if (_cancelTokens.isEmpty) return;
    ApplicationManager().enableKeepScreenOn();
  }

  void _disableKeepScreenOn() {
    if (_cancelTokens.isNotEmpty) return;
    ApplicationManager().disableKeepScreenOn();
  }
}
