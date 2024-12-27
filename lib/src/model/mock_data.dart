import 'my_application.dart';
import 'revanced_application.dart';

class MockData {
  static List<RevancedApplication> mockApplications() {
    return List.generate(5, (index) {
      return RevancedApplication(
        'appName',
        'androidPackageName',
        'latestVersionCode',
        'appShortDescription\nappShortDescription\nappShortDescription',
        false,
        'latestVersionUrl',
        'icon',
        index,
        false,
        'installedVersionCode',
      );
    });
  }

  static List<MyApplication> mockMyApplications() {
    return List.generate(5, (index) {
      return MyApplication(
        'tagName',
        'name',
        'publishedAt',
        'downloadUrl',
        'body\nbody\nbody',
      );
    });
  }
}
