import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});
