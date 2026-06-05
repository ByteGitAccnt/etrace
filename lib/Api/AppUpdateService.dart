import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:etrace/Api/ApiClient.dart';
import 'package:etrace/Model/AppInfoResponse.dart';
import 'package:etrace/Model/UpdateStatus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

class AppUpdateService {
  final Dio _dio = ApiClient().dio;

  Future<UpdateStatus?> checkForUpdates() async {
    try {
      final response = await _dio.get("/api/app/info");

      final appInfo = AppInfoResponse.fromJson(response.data);

      final packageInfo = await PackageInfo.fromPlatform();

      final currentVersion = Version.parse(packageInfo.version);

      final latestVersion = Version.parse(appInfo.latestVersion);

      final minimumVersion = Version.parse(appInfo.minimumSupportedVersion);

      // OPTIONAL UPDATE
      final updateAvailable = currentVersion < latestVersion;

      // FORCE UPDATE
      final forceUpdate =
          currentVersion < minimumVersion || appInfo.forceUpdate;

      return UpdateStatus(
        updateAvailable: updateAvailable,
        forceUpdate: forceUpdate,
        downloadUrl: appInfo.downloadUrl,
      );
    } catch (e) {
      return null;
    }
  }
}
