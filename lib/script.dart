import 'dart:io';

import 'package:yaml/yaml.dart';

Future<void> main() async {
  const String path = 'build/app/outputs/flutter-apk/';
  final Directory directory = Directory(path);
  final List<FileSystemEntity> files = directory.listSync();
  for (final file in files) {
    if (file is File) {
      final fileName = file.uri.pathSegments.last;
      if (fileName == 'app-release.apk') {
        try {
          final content = await File('pubspec.yaml').readAsString();
          final yaml = await loadYaml(content);
          final String version = yaml['version'].toString();
          final String newName = 'revanced_manager_$version.apk';
          final String newPath = '${file.parent.path}/$newName';
          await file.copy(newPath);
        } catch (_) {}
      }
    }
  }
}
