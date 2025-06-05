enum HomeTabBar {
  ALL('All Apps'),
  INSTALLED('Installed'),
  NOT_INSTALLED('Not Installed'),
  UPDATE('Update');

  const HomeTabBar(this.label);

  final String label;
}
