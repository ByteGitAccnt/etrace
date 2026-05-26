class AppInfoResponse {
  final String latestVersion;
  final String minimumSupportedVersion;
  final bool forceUpdate;
  final String downloadUrl;

  AppInfoResponse({
    required this.latestVersion,
    required this.minimumSupportedVersion,
    required this.forceUpdate,
    required this.downloadUrl,
  });

  factory AppInfoResponse.fromJson(Map<String, dynamic> json) {
    return AppInfoResponse(
      latestVersion: json["latestVersion"],
      minimumSupportedVersion: json["minimumSupportedVersion"],
      forceUpdate: json["forceUpdate"],
      downloadUrl: json["downloadUrl"],
    );
  }
}
