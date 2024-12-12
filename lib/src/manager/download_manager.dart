import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../model/revanced_application.dart';

class DownloadManager {
  factory DownloadManager() => _instance;

  DownloadManager._();

  static final DownloadManager _instance = DownloadManager._();

  final Dio _dio = Dio();

  Future<String> downloadRevancedApplication(
    RevancedApplication app,
    Function(double progress) onReceiveProgress,
  ) async {
    final url = app.latestVersionUrl ?? '';
    if (url.isEmpty) return '';
    final fileName = '${app.appName} ${app.latestVersionCode}.apk';
    final filePath = (await getTemporaryDirectory()).path;
    final savePath = '$filePath/$fileName';
    if (!File(savePath).existsSync()) {
      await _dio.downloadUri(
        Uri.parse(url),
        savePath,
        onReceiveProgress: (count, total) {
          onReceiveProgress(
            double.tryParse((count / total).toStringAsFixed(3)) ?? 0.0,
          );
        },
      );
    }
    return savePath;
  }
}
