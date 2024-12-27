import 'my_application.dart';

class CheckUpdate {
  CheckUpdate(
    this.updateAvailable,
    this.appLatest,
  );

  final bool updateAvailable;
  final MyApplication? appLatest;
}
