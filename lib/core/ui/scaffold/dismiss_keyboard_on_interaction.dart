import 'package:flutter/material.dart';

class DismissKeyboardOnInteraction extends StatelessWidget {
  final Widget child;

  const DismissKeyboardOnInteraction({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: NotificationListener<ScrollStartNotification>(
        onNotification: (_) {
          FocusScope.of(context).unfocus();
          return false;
        },
        child: child
      ),
    );
  }
}
