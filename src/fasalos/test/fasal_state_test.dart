import 'package:flutter_test/flutter_test.dart';
import 'package:fasalos/services/fasal_state.dart';
import 'package:fasalos/models/produce_lot.dart';
import 'package:fasalos/models/market_channel.dart';

void main() {
  group('FasalState Lifecycle Tests', () {
    late FasalState state;

    setUp(() {
      state = FasalState();
    });

    test('Initial deterministic data is properly configured', () {
      expect(state.lots.length, greaterThanOrEqualTo(5));
      expect(state.lots.any((l) => l.farmerName.contains('Lakshmi')), isTrue);
      expect(state.solar.generatedKwh, equals(62.0));
      expect(state.solar.consumedKwh, equals(84.0));
      expect(state.solar.solarContributionPct, equals(74));
      expect(state.settlements.isNotEmpty, isTrue);
      expect(state.isOffline, isFalse);
    });

    test('Signature Interaction 1: Produce Intake creates lot and transitions states', () async {
      final initialCount = state.lots.length;

      final lot = await state.createProduceIntake(
        farmerName: 'Lakshmi Devi',
        farmerVillage: 'Dhone, Kurnool Dist.',
        cropType: 'Country Tomatoes',
        quantityKg: 250.0,
        photoAsset: 'assets/images/produce_tomatoes.jpg',
        quality: const QualityFactors(
          colorMaturity: 0.89,
          sizingUniformity: 0.92,
          blemishRate: 0.03,
          firmnessIndex: 0.91,
          confidence: 0.94,
          grade: 'A+',
        ),
        freshness: const FreshnessMetrics(
          freshnessScore: 94,
          chamberTemperature: 11.8,
          relativeHumidity: 88.0,
          storageDurationHours: 1,
          estimatedRemainingDays: 14,
          cropCondition: 'Prime Crisp Harvest',
          scientificExplanation: 'Stable controlled atmosphere test.',
        ),
      );

      expect(state.lots.length, equals(initialCount + 1));
      expect(lot.id, startsWith('FOS-'));
      expect(lot.stage, equals(LotStage.stored));
      expect(lot.stageHistory.length, greaterThanOrEqualTo(3));
    });

    test('Signature Interaction 4: Multi-farmer aggregation combines lots', () {
      state.toggleLotSelectionForAggregation('FOS-20481');
      state.toggleLotSelectionForAggregation('FOS-20482');
      state.toggleLotSelectionForAggregation('FOS-20483');

      expect(state.selectedLotIdsForAggregation.length, equals(3));

      state.combineSelectedLots();

      expect(state.activeBatch, isNotNull);
      expect(state.activeBatch!.totalWeightKg, equals(500.0));
      expect(state.activeBatch!.memberLots.length, equals(3));
      expect(state.selectedLotIdsForAggregation.isEmpty, isTrue);
    });

    test('Signature Interaction 7 & 8: Order placement, delivery, and settlement calculation', () {
      final option = state.marketOptions.firstWhere((o) => o.type == MarketChannelType.buyerOrder);

      final order = state.matchBuyerAndCreateOrder(
        marketOption: option,
        requestedKg: 500.0,
      );

      expect(order.orderId, startsWith('ORD-'));
      expect(order.agreedRatePerKg, equals(option.expectedPrice));

      final initialSettlementsCount = state.settlements.length;

      // Deliver order
      state.deliverOrderAndCalculateSettlement(order.orderId);

      // Verify settlements generated for contributing lots
      expect(state.settlements.length, equals(initialSettlementsCount + order.contributingLotIds.length));
      expect(state.settlements.first.isDisbursed, isTrue);
      expect(state.settlements.first.netFarmerPayout, greaterThan(0));
    });

    test('Offline mode toggling and sync queue handling', () async {
      expect(state.isOffline, isFalse);
      state.toggleOfflineMode();
      expect(state.isOffline, isTrue);

      // Create intake while offline
      await state.createProduceIntake(
        farmerName: 'Ramu',
        farmerVillage: 'Kurnool',
        cropType: 'Red Onions',
        quantityKg: 100.0,
        photoAsset: 'assets/images/produce_onions.jpg',
        quality: const QualityFactors(
          colorMaturity: 0.9,
          sizingUniformity: 0.9,
          blemishRate: 0.05,
          firmnessIndex: 0.9,
          confidence: 0.9,
          grade: 'A',
        ),
        freshness: const FreshnessMetrics(
          freshnessScore: 90,
          chamberTemperature: 2.0,
          relativeHumidity: 70.0,
          storageDurationHours: 1,
          estimatedRemainingDays: 30,
          cropCondition: 'Good',
          scientificExplanation: 'Dormancy test',
        ),
      );

      expect(state.pendingSyncQueue, equals(1));
      expect(state.lots.first.isPendingSync, isTrue);

      // Go online and trigger sync
      state.toggleOfflineMode();
      await state.triggerSync();

      expect(state.pendingSyncQueue, equals(0));
      expect(state.lots.first.isPendingSync, isFalse);
    });
  });
}
