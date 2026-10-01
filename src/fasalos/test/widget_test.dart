import 'package:flutter_test/flutter_test.dart';
import 'package:fasalos/main.dart';

void main() {
  testWidgets('FasalOS boots up and renders operational hub', (WidgetTester tester) async {
    await tester.pumpWidget(const FasalOSApp());
    await tester.pumpAndSettle();

    // Verify app title and hub name
    expect(find.text('FasalOS'), findsOneWidget);
    expect(find.textContaining('Agro-Solar Cold Hub'), findsOneWidget);

    // Verify key action button
    expect(find.text('+ Add Produce Intake'), findsOneWidget);

    // Verify key operational tabs in navigation bar
    expect(find.text('Hub Lots'), findsWidgets);
    expect(find.text('Solar Cold Room'), findsWidgets);
    expect(find.text('Market Match'), findsWidgets);
    expect(find.text('Aggregation'), findsWidgets);
    expect(find.text('Buyer Portal'), findsWidgets);
    expect(find.text('Settlement'), findsWidgets);
  });

  testWidgets('Navigation switches tabs smoothly', (WidgetTester tester) async {
    await tester.pumpWidget(const FasalOSApp());
    await tester.pumpAndSettle();

    // Tap Solar Cold Room tab
    await tester.tap(find.text('Solar Cold Room').first);
    await tester.pumpAndSettle();

    // Verify solar telemetry labels
    expect(find.text('Photovoltaic Solar Cold-Chain Flow'), findsOneWidget);
    expect(find.text('62 kWh'), findsWidgets);
    expect(find.text('84 kWh'), findsOneWidget);
    expect(find.text('74%'), findsOneWidget);

    // Tap Aggregation tab
    await tester.tap(find.text('Aggregation').first);
    await tester.pumpAndSettle();
    expect(find.text('Multi-Farmer Lot Aggregation'), findsOneWidget);

    // Tap Settlement tab
    await tester.tap(find.text('Settlement').first);
    await tester.pumpAndSettle();
    expect(find.text('Transparent Farmer Settlement'), findsOneWidget);
  });
}
