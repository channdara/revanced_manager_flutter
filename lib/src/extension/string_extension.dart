extension StringExtension on String? {
  int toInt() {
    return int.tryParse(this ?? '') ?? 0;
  }

  String normalizeVersion() {
    final replaced = this
        ?.replaceAll(RegExp(r'[^0-9]'), '.')
        .replaceAll(RegExp(r'\.+'), '.');
    return replaced ?? '0';
  }
}
