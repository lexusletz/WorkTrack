import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/date_utils.dart';

class SmartRelativeTimeText extends StatefulWidget {
  final DateTime dateTime;
  final String prefix;
  final TextStyle? style;

  const SmartRelativeTimeText({
    super.key,
    required this.dateTime,
    this.prefix = '',
    this.style,
  });

  @override
  State<SmartRelativeTimeText> createState() => _SmartRelativeTimeTextState();
}

class _SmartRelativeTimeTextState extends State<SmartRelativeTimeText> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scheduleNextUpdate();
  }

  @override
  void didUpdateWidget(covariant SmartRelativeTimeText oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the date changes, recalculate timer
    if (oldWidget.dateTime != widget.dateTime) {
      _timer?.cancel();
      _scheduleNextUpdate();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _scheduleNextUpdate() {
    final now = DateTime.now();
    final difference = now.difference(widget.dateTime);

    Duration? nextUpdate;

    if (difference.isNegative) {
      nextUpdate = const Duration(minutes: 1);
    } else if (difference.inSeconds < 60) {
      nextUpdate = const Duration(seconds: 1);
    } else if (difference.inMinutes < 60) {
      // Less than 1 hour
      // Example: now is 14:40:45 and date was 14:15:20,
      // update in 15 seconds
      final secondsUntilNextMinute = 60 - now.second;
      nextUpdate = Duration(seconds: secondsUntilNextMinute);
    } else {
      // More than 1 hour: No update
      nextUpdate = null;
    }

    if (nextUpdate != null) {
      _timer = Timer(nextUpdate, () {
        if (mounted) {
          setState(() {});
          _scheduleNextUpdate();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.prefix}${AppDateUtils.getRemainingTime(widget.dateTime)}',
      style: widget.style,
    );
  }
}
