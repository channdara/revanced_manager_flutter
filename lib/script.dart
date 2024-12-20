import 'dart:io';

import 'package:yaml/yaml.dart';

Future<void> main() async {
  try {
    final file = File('build/app/outputs/flutter-apk/app-release.apk');
    if (file.existsSync()) {
      final content = await File('pubspec.yaml').readAsString();
      final yaml = await loadYaml(content);
      final version = yaml['version'].toString();
      final newName = 'revanced_manager_$version.apk';
      final newPath = '${file.parent.path}/$newName';
      await file.copy(newPath);
    }
  } catch (_) {}
}
