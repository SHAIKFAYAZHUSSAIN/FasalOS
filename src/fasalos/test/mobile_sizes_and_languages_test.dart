import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fasalos/main.dart';
import 'package:fasalos/l10n/app_localizations.dart';

void main() {
  const targetSizes = [
    Size(320, 568), // iPhone SE 1st Gen
    Size(360, 800), // Standard Android
    Size(375, 812), // iPhone X / 11 Pro
    Size(390, 844), // Primary Target (iPhone 12/13/14)
    Size(412, 915), // Pixel 7 / Galaxy S21
    Size(430, 932), // iPhone 14 Pro Max
  ];

  for (final size in targetSizes) {
    testWidgets('Verify screen dimensions ${size.width.toInt()}x${size.height.toInt()} with zero overflows',
        (WidgetTester tester) async {
      tester.view.physicalSize = Size(size.width * 2, size.height * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const FasalOSApp());
      await tester.pumpAndSettle();

      // Check Hub Lots
      expect(find.text('FasalOS'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Check Solar Cold Room
      await tester.tap(find.text('Solar Cold Room').first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Check Markets
      await tester.tap(find.text('Market Match').first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Check Aggregation
      await tester.tap(find.text('Aggregation').first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Check Buyer Portal
      await tester.tap(find.text('Buyer Portal').first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Check Settlement
      await tester.tap(find.text('Settlement').first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Verify multilingual switching across all 5 languages without overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FasalOSApp());
    await tester.pumpAndSettle();

    for (final lang in AppLanguage.values) {
      // Find language switcher
      await tester.tap(find.byIcon(Icons.translate));
      await tester.pumpAndSettle();

      // Tap language
      await tester.tap(find.text(lang.displayName).last);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Verify produce intake modal interaction flow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FasalOSApp());
    await tester.pumpAndSettle();

    // Tap + Add Produce Intake
    await tester.tap(find.text('+ Add Produce Intake'));
    await tester.pumpAndSettle();

    // Step 1: Verify Intake form
    expect(find.text('Farmer Produce Intake'), findsOneWidget);
    expect(find.text('1. Crop & Farmer Details'), findsOneWidget);

    // Tap Run AI Assessment button
    await tester.tap(find.text('Analyze Produce with Computer Vision'));
    await tester.pumpAndSettle();

    // Step 2: Verify Computer vision factor inspection
    expect(find.text('2. Crate Photo & Visual AI'), findsOneWidget);
    expect(find.text('Operator Confirm & Create Lot'), findsOneWidget);

    // Operator confirms and creates lot
    await tester.tap(find.text('Operator Confirm & Create Lot'));
    // Advance timers for the automated state transitions (300ms + 300ms)
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    // Step 3: State transition stream verified
    expect(find.textContaining('Lot Created: FOS-'), findsOneWidget);
    expect(find.text('Automated State Transition Stream'), findsOneWidget);
    expect(find.text('View Lot in Cold Storage Hub'), findsOneWidget);

    // Close and view in hub
    await tester.tap(find.text('View Lot in Cold Storage Hub'));
    await tester.pumpAndSettle();

    expect(find.text('FasalOS'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
