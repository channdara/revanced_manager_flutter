import 'dart:async';

class DownloadStatus {
  bool downloading = true;
  double progressing = 0.0;
  Timer? timer;
}
