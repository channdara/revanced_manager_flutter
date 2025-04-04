import 'package:flutter/foundation.dart';

import '../extension/string_extension.dart';

class AppCommon {
  AppCommon._();

  static const String fontFamily = 'Nunito';
}

void logDebug(List<dynamic> contents) {
  if (kDebugMode) print('LOG_DEBUG 👉 ${contents.join(' | ')}');
}

bool newVersionAvailable(String currentVersion, String latestVersion) {
  final List<int> current = currentVersion
      .normalizeVersion()
      .split('.')
      .map((e) => e.toInt())
      .toList();
  final List<int> latest = latestVersion
      .normalizeVersion()
      .split('.')
      .map((e) => e.toInt())
      .toList();
  final int maxLength =
      current.length > latest.length ? current.length : latest.length;
  while (current.length < maxLength) {
    current.add(0);
  }
  while (latest.length < maxLength) {
    latest.add(0);
  }
  for (int i = 0; i < maxLength; i++) {
    if (current[i] < latest[i]) return true;
    if (current[i] > latest[i]) return false;
  }
  return false;
}
