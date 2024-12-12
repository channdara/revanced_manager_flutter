import 'package:dio/dio.dart';

import '../model/revanced_application.dart';

class ApiManager {
  factory ApiManager() => _instance;

  ApiManager._();

  static final ApiManager _instance = ApiManager._();

  static const Duration _timeout = Duration(seconds: 20);

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://revanced.net',
    connectTimeout: _timeout,
    receiveTimeout: _timeout,
    sendTimeout: _timeout,
  ));

  Future<List<RevancedApplication>> getRevancedApplications() async {
    final response = await _dio.get('/revanced-apps.json');
    return RevancedApplication.fromJsonList(response.data);
  }
}
