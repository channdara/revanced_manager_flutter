extension StringExtension on String? {
  int toVersionInteger() {
    final source = this?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0';
    return int.tryParse(source) ?? 0;
  }
}
