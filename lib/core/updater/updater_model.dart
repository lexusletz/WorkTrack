import 'package:flutter/foundation.dart';

@immutable
class Updater {
  const Updater({
    required this.isNewerVersionAvailable,
    required this.currentVersion,
    required this.newVersion,
    required this.downloadUrl,
  });

  final bool isNewerVersionAvailable;
  final String currentVersion;
  final String newVersion;
  final String? downloadUrl;

  bool get hasNewVersion => isNewerVersionAvailable && downloadUrl != null;

  Updater copyWith({
    bool? isNewerVersionAvailable,
    String? currentVersion,
    String? newVersion,
    String? downloadUrl,
  }) => Updater(
    isNewerVersionAvailable:
        isNewerVersionAvailable ?? this.isNewerVersionAvailable,
    currentVersion: currentVersion ?? this.currentVersion,
    newVersion: newVersion ?? this.newVersion,
    downloadUrl: downloadUrl ?? this.downloadUrl,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Updater &&
          isNewerVersionAvailable == other.isNewerVersionAvailable &&
          currentVersion == other.currentVersion &&
          newVersion == other.newVersion &&
          downloadUrl == other.downloadUrl;

  @override
  int get hashCode => Object.hash(
    isNewerVersionAvailable,
    currentVersion,
    newVersion,
    downloadUrl,
  );
}
