import 'package:collection/collection.dart';

extension StringExtension on String? {
  int toInt() {
    return int.tryParse(this ?? '') ?? 0;
  }

  String normalizeVersion() {
    final replaced = this
        ?.replaceAll(RegExp(r'[^0-9]'), '.')
        .replaceAll(RegExp(r'\.+'), '.');
    return replaced ?? '0';
  }

  bool compareVersionTo(String? other) {
    final current = normalizeVersion();
    final latest = other.normalizeVersion();
    final currentVersion = current.split('.').map((e) => e.toInt()).sum;
    final latestVersion = latest.split('.').map((e) => e.toInt()).sum;
    return latestVersion > currentVersion;
  }
}
