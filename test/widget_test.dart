import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:networkclan_kiosk_fcsit_app/main.dart';

void main() {
  group('Kiosk App UI Tests', () {
    testWidgets('App loads Customer Page first', (WidgetTester tester) async {
      await tester.pumpWidget(KioskApp());
      await tester.pumpAndSettle();

      // Check if Customer Interface text is present
      expect(find.text("Customer Interface"), findsOneWidget);
      expect(find.text("View Menu"), findsOneWidget);
    });

    testWidgets('Navigate to Menu Page', (WidgetTester tester) async {
      await tester.pumpWidget(KioskApp());
      await tester.pumpAndSettle();

      // tap "View Menu" button
      await tester.tap(find.text("View Menu"));
      await tester.pumpAndSettle();

      // Check if Menu page is displayed
      expect(find.text("Menu"), findsOneWidget);
    });

    testWidgets('Navigate to Order Type Page', (WidgetTester tester) async {
      await tester.pumpWidget(KioskApp());
      await tester.pumpAndSettle();

      // tap "Choose Order Type"
      await tester.tap(find.text("Choose Order Type"));
      await tester.pumpAndSettle();

      // Check if Order Type page is displayed
      expect(find.text("Order Type"), findsOneWidget);
    });

    testWidgets('Menu items appear correctly', (WidgetTester tester) async {
      await tester.pumpWidget(KioskApp());
      await tester.pumpAndSettle();

      // Go to Menu page
      await tester.tap(find.text("View Menu"));
      await tester.pumpAndSettle();

      // Check menu items exist
      expect(find.text("Nasi Lemak"), findsOneWidget);
      expect(find.text("RM 4.00"), findsOneWidget);
    });
  });
}
