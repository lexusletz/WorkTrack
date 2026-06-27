import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/date_utils.dart';
import '../../../l10n/app_localizations.dart';

class InstallationInfoSection extends StatefulWidget {
  const InstallationInfoSection({super.key});

  @override
  State<InstallationInfoSection> createState() =>
      _InstallationInfoSectionState();
}

class _InstallationInfoSectionState extends State<InstallationInfoSection> {
  DateTime? _installationTime;
  DateTime? _expirationTime;
  Timer? _timer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDates();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadDates() async {
    final prefs = await SharedPreferences.getInstance();
    final installTs = prefs.getInt('installation_timestamp');
    final expireTs = prefs.getInt('expiration_timestamp');

    if (installTs != null && expireTs != null) {
      _installationTime = DateTime.fromMillisecondsSinceEpoch(installTs);
      _expirationTime = DateTime.fromMillisecondsSinceEpoch(expireTs);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }

    if (_installationTime != null && _expirationTime != null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const SizedBox.shrink();
    if (_installationTime == null || _expirationTime == null) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "04 • ${l10n.aboutLabel.toUpperCase()}",
          style: const TextStyle(color: Color(0xFF9aa59e)),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            children: [
              _infoRow(
                l10n.installationDateLabel,
                DateFormat("d/M/y, h:mm a").format(_installationTime!),
              ),
              const Divider(
                height: 12,
                thickness: 1,
                color: Color(0xFF1F2C26),
              ),
              _infoRow(
                l10n.expirationDateLabel,
                DateFormat("d/M/y, h:mm a").format(_expirationTime!),
              ),
              const Divider(
                height: 12,
                thickness: 1,
                color: Color(0xFF1F2C26),
              ),
              _progressSection(_installationTime!, _expirationTime!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF9aa59e))),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressSection(DateTime install, DateTime expire) {
    final ratio = AppDateUtils.getElapsedRatio(install, expire);
    final remaining = AppDateUtils.getCompactRemaining(expire);

    return Column(
      children: [
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            backgroundColor: const Color(0xFF1F2C26),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${(ratio * 100).toInt()}%",
              style: const TextStyle(color: Color(0xFF9aa59e), fontSize: 12),
            ),
            Text(
              remaining,
              style: const TextStyle(color: Color(0xFF9aa59e), fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
