import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

@immutable
class NotificationModel {
  const NotificationModel({required this.status});

  final PermissionStatus status;

  NotificationModel copyWith({PermissionStatus? status}) =>
      NotificationModel(status: status ?? this.status);
}
