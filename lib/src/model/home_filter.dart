enum HomeFilter {
  ALL('All Apps'),
  UPDATE('Update'),
  INSTALLED('Installed'),
  NOT_INSTALLED('Not Installed');

  const HomeFilter(this.label);

  final String label;
}
