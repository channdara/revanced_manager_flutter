enum HomeFilter {
  ALL('All Apps'),
  INSTALLED('Installed'),
  NOT_INSTALLED('Not Installed'),
  UPDATE('Update');

  const HomeFilter(this.label);

  final String label;
}
