import 'my_application.dart';
import 'revanced_application.dart';

class MockData {
  static List<RevancedApplication> mockApplications() {
    return List.generate(5, (index) {
      return RevancedApplication(
        'App Name',
        'Android Package Name',
        'Latest Version Code',
        'App Short Description\nApp Short Description\nApp Short Description',
        false,
        'Latest Version Url',
        '',
        index,
        false,
        'Installed Version Code',
      );
    });
  }

  static List<MyApplication> mockMyApplications() {
    return List.generate(5, (index) {
      return MyApplication(
        'Tag Name',
        'Name',
        'Published At',
        'Download Url',
        'Body\nBody\nBody',
      );
    });
  }
}
