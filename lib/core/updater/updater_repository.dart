import 'dart:convert';

import 'package:android_package_installer/android_package_installer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'updater_model.dart';

class UpdaterRepository {
  final PackageInfo _packageInfo;

  UpdaterRepository(this._packageInfo);

  Future<Updater> checkForUpdates() async {
    final currentVersion = _getLocalVersion();

    try {
      final url = Uri.parse(
        "https://raw.githubusercontent.com/lexusletz/WorkTrack/refs/heads/main/version.json",
      );

      final response = await http.get(url);
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;

      final downloadUrl = decodedResponse['download_url'] as String;
      final newVersionString = decodedResponse['version'] as String;

      final isNewer = _VersionInfo.fromString(
        newVersionString,
      ).isNewerThan(currentVersion);

      return Updater(
        isNewerVersionAvailable: isNewer,
        currentVersion: _packageInfo.version,
        newVersion: newVersionString,
        downloadUrl: isNewer ? downloadUrl : null,
      );
    } catch (e) {
      debugPrint("Error checking for updates: $e");
      return Updater(
        isNewerVersionAvailable: false,
        currentVersion: _packageInfo.version,
        newVersion: "",
        downloadUrl: null,
      );
    }
  }

  Future<void> downloadNewVersion({required String downloadUrl}) async {
    FileDownloader.downloadFile(
      url: downloadUrl,
      name: "WorkTrack.apk",
      onProgress: (String? filename, double progress) {
        debugPrint("filename: $filename, download progress: $progress");
      },
      onDownloadCompleted: (String? path) async {
        if (path != null) {
          debugPrint("download completed at: $path");
          await AndroidPackageInstaller.installApk(apkFilePath: path);
        }
      },
      onDownloadError: (String error) {
        debugPrint("download error: $error");
      },
      notificationType: NotificationType.progressOnly,
    );
  }

  _VersionInfo _getLocalVersion() {
    return _VersionInfo.fromString(_packageInfo.version);
  }
}

class _VersionInfo {
  int _major;
  int _minor;
  int _patch;

  _VersionInfo(this._major, this._minor, this._patch);

  bool isNewerThan(final _VersionInfo other) {
    if (_major > other._major) return true;
    if (_minor > other._minor) return true;
    if (_patch > other._patch) return true;

    return false;
  }

  factory _VersionInfo.fromString(String version) {
    // Remove the prefix 'v' if it exists
    if (version.startsWith('v')) {
      version = version.substring(1);
    }

    final parts = version.split('.');

    return _VersionInfo(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }
}
