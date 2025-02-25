class MyApplication {
  MyApplication(
    this.tagName,
    this.name,
    this.publishedAt,
    this.downloadUrl,
    this.body,
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
      json['body'] as String? ?? '',
    );
  }

  static List<MyApplication> fromJsonList(dynamic data) {
    try {
      return (data as List<dynamic>)
          .map((json) => MyApplication.fromJson(json))
          .toList();
    } catch (_) {
      return [];
    }
  }

  final String tagName;
  final String name;
  final String publishedAt;
  final String downloadUrl;
  final String body;
}
