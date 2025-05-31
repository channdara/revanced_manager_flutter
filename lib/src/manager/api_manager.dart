import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../common/common.dart';
import '../model/check_update.dart';
import '../model/my_application.dart';
import '../model/revanced_application.dart';
import 'application_manager.dart';

class ApiManager {
  factory ApiManager() => _instance;

  ApiManager._();

  static final ApiManager _instance = ApiManager._();

  static const Duration _timeout = Duration(seconds: 20);
  static final _dioLoggerInterceptor = PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    compact: false,
    maxWidth: 180,
    enabled: false,
  );

  String _endpoint = '';

  final Dio _revancedDio = Dio(BaseOptions(
    baseUrl: 'https://vanced.to',
    connectTimeout: _timeout,
    receiveTimeout: _timeout,
    sendTimeout: _timeout,
  ))
    ..interceptors.add(_dioLoggerInterceptor);
  final Dio _gitHubDio = Dio(BaseOptions(
    baseUrl: 'https://api.github.com',
    connectTimeout: _timeout,
    receiveTimeout: _timeout,
    sendTimeout: _timeout,
  ))
    ..interceptors.add(_dioLoggerInterceptor);

  Future<List<RevancedApplication>> getRevancedApplications() async {
    if (_endpoint.isEmpty) _endpoint = await _getEndpointByCPUArchitecture();
    final response = await _revancedDio.get<dynamic>(_endpoint);
    final items = await RevancedApplication.fromJsonList(response.data);
    items.sort((current, next) => current.isInstalled != next.isInstalled
        ? ((next.isInstalled) ? 1 : -1)
        : current.index.compareTo(next.index));
    return items;
  }

  Future<MyApplication> getMyAppLatestRelease() async {
    final response = await _gitHubDio.get<dynamic>(
      '/repos/channdara/revanced_manager_flutter/releases/latest',
    );
    return MyApplication.fromJson(response.data);
  }

  Future<List<MyApplication>> getMyAppAllReleases() async {
    final response = await _gitHubDio.get<dynamic>(
      '/repos/channdara/revanced_manager_flutter/releases',
    );
    return MyApplication.fromJsonList(response.data);
  }

  Future<CheckUpdate> checkUpdateForManagerApp() async {
    try {
      final appRelease = await getMyAppLatestRelease();
      final package = await PackageInfo.fromPlatform();
      final latest = appRelease.tagName;
      final current = '${package.version}+${package.buildNumber}';
      final updateAvailable = newVersionAvailable(current, latest);
      return CheckUpdate(updateAvailable, appRelease);
    } catch (_) {
      return CheckUpdate(false, null);
    }
  }

  Future<String> _getEndpointByCPUArchitecture() async {
    final architecture = await ApplicationManager().getCPUArchitecture();
    if (architecture.contains('arm64-v8a')) {
      return '/revanced-apps-arm64-v8a.json';
    }
    if (architecture.contains('armeabi-v7a')) {
      return '/revanced-apps-armeabi-v7a.json';
    }
    if (architecture.contains('x86')) {
      return '/revanced-apps-x86.json';
    }
    if (architecture.contains('x86_64')) {
      return '/revanced-apps-x86_64.json';
    }
    return '/revanced-apps.json';
  }
}
