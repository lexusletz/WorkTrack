import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_track/core/settings/settings_providers.dart';
import 'package:work_track/main.dart';

void main() {
  testWidgets('dashboard screen renders', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
        child: const WorkTrackApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('WorkTrack'), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
}
