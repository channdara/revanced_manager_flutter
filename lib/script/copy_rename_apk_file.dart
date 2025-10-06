import 'dart:io';

import 'package:yaml/yaml.dart';

/// I can't find a way to change the APK file's name that build with
/// {--release} command. Run this script to do so. Run the command below
/// and provide the env base on your project configuration.
/// This required to add {yaml} package to {pubspec.yaml} before run.
///
/// This will not rename the original {app-release.apk} but will copy
/// the file to the same directory and rename it.
///
/// Run script command line:
///
/// dart run copy_rename_apk_file.dart
/// dart run copy_rename_apk_file.dart dev
/// dart run copy_rename_apk_file.dart stg
/// dart run copy_rename_apk_file.dart prod
///
/// Feel free to modify as you needed.
Future<void> main() async {
  try {
    const appName = 'app-arm64-v8a-release.apk';
    final file = File('build/app/outputs/flutter-apk/$appName');
    if (file.existsSync()) {
      final content = await File('pubspec.yaml').readAsString();
      final yaml = await loadYaml(content);
      final version = yaml['version'].toString();
      final name = yaml['name'].toString();
      final newAppName = '${name}_$version.apk';
      final newPath = '${file.parent.path}/$newAppName';
      await file.copy(newPath);
    }
  } catch (exception) {
    stderr.write(exception);
  }
}
