extension IntExtension on int {
  static const int _bytesInKB = 1024;
  static const int _bytesInMB = 1024 * _bytesInKB;
  static const int _bytesInGB = 1024 * _bytesInMB;

  String toFileSize() {
    return switch (this) {
      < 1 => '',
      < _bytesInKB => '$this Bytes',
      < _bytesInMB => '${(this / _bytesInKB).toStringAsFixed(2)} KB',
      < _bytesInGB => '${(this / _bytesInMB).toStringAsFixed(2)} MB',
      _ => '${(this / _bytesInGB).toStringAsFixed(2)} GB',
    };
  }
}
