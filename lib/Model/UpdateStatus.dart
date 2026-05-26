class UpdateStatus {
  final bool updateAvailable;
  final bool forceUpdate;
  final String downloadUrl;

  UpdateStatus({
    required this.updateAvailable,
    required this.forceUpdate,
    required this.downloadUrl,
  });
}
