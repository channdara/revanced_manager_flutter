import 'application_model.dart';

class MyApplication extends ApplicationModel {
  MyApplication(
    this.tagName,
    this.name,
    this.publishedAt,
    this.downloadUrl,
  );

  factory MyApplication.fromJson(dynamic json) {
    final assets = json['assets'] as List<dynamic>? ?? [];
    final downloadUrl = assets.isNotEmpty
        ? (assets.first['browser_download_url'] as String? ?? '')
        : '';
    return MyApplication(
      json['tag_name'] as String? ?? '',
      json['name'] as String? ?? '',
      json['published_at'] as String? ?? '',
      downloadUrl,
    );
  }

  final String tagName;
  final String name;
  final String publishedAt;
  final String downloadUrl;
}
