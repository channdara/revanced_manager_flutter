import 'dart:io';

import 'package:yaml/yaml.dart';

Future<void> main() async {
  try {
    final file = File('build/app/outputs/flutter-apk/app-release.apk');
    if (file.existsSync()) {
      final content = await File('pubspec.yaml').readAsString();
      final yaml = await loadYaml(content);
      final String version = yaml['version'].toString();
      final String newName = 'revanced_manager_$version.apk';
      final String newPath = '${file.parent.path}/$newName';
      await file.copy(newPath);
    }
  } catch (_) {}
}
