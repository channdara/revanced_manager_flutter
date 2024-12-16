import 'package:dio/dio.dart';

import '../model/my_application.dart';
import '../model/revanced_application.dart';
import 'application_manager.dart';

class ApiManager {
  factory ApiManager() => _instance;

  ApiManager._();

  static final ApiManager _instance = ApiManager._();

  static const Duration _timeout = Duration(seconds: 20);

  String _endpoint = '';

  final Dio _revancedDio = Dio(BaseOptions(
    baseUrl: 'https://revanced.net',
    connectTimeout: _timeout,
    receiveTimeout: _timeout,
    sendTimeout: _timeout,
  ));
  final Dio _gitHubDio = Dio(BaseOptions(
    baseUrl: 'https://api.github.com',
    connectTimeout: _timeout,
    receiveTimeout: _timeout,
    sendTimeout: _timeout,
  ));

  Future<List<RevancedApplication>> getRevancedApplications() async {
    if (_endpoint.isEmpty) _endpoint = await _getEndpointByCPUArchitecture();
    final response = await _revancedDio.get(_endpoint);
    final items = await RevancedApplication.fromJsonList(response.data);
    items.sort((current, next) => current.isInstalled != next.isInstalled
        ? ((next.isInstalled) ? 1 : -1)
        : current.index.compareTo(next.index));
    return items;
  }

  Future<MyApplication> getMyApplicationFromGitHub() async {
    final response = await _gitHubDio.get(
      '/repos/channdara/revanced_manager_flutter/releases/latest',
    );
    return MyApplication.fromJson(response.data);
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
