import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worktrack/features/preferences/widgets/hourly_rate_section.dart';
import 'package:worktrack/l10n/app_localizations.dart';

void main() {
  group("HourlyRateSection Widget Tests", () {
    testWidgets("Should allow numbers, comma and dot", (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: HourlyRateSection(
              value: 8.5, 
              symbol: "\$", 
              onChange: (value) {}
            ),
          ),
        )
      );

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, "15,50");
      await tester.pump();

      expect(find.text("15,50"), findsOneWidget);
    });

    testWidgets("Should reject or filter invalid characters like letters", (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: HourlyRateSection(
              value: 8.5,
              symbol: r'$',
              onChange: (_) {}
            ),
          ),
        )
      );

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, "An invalid text");
      await tester.pump();

      expect(find.text("An invalid text"), findsNothing);
    });

    testWidgets("Should truncate on to 2 decimals", (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: HourlyRateSection(
              value: 8.5,
              symbol: r'$',
              onChange: (_) {}
            ),
          ),
        )
      );

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, "8.5555");
      await tester.pump();

      expect(find.text("8.55"), findsOneWidget);
    });
  });
}
