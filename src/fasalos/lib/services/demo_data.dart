import '../models/produce_lot.dart';
import '../models/market_channel.dart';
import '../models/solar_metrics.dart';
import '../models/settlement.dart';

class DemoData {
  static List<ProduceLot> getInitialLots() {
    final now = DateTime.now();

    return [
      ProduceLot(
        id: 'FOS-20481',
        farmerName: 'Lakshmi Devi',
        farmerVillage: 'Dhone, Kurnool Dist.',
        cropType: 'Country Tomatoes',
        quantityKg: 250.0,
        photoAsset: 'assets/images/produce_tomatoes.jpg',
        stage: LotStage.stored,
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
          storageDurationHours: 28,
          estimatedRemainingDays: 14,
          cropCondition: 'Prime Crisp Harvest',
          scientificExplanation:
              'Chamber maintained between 11.5°C–12.2°C at 88% RH. Controlled respiration rate minimizes ethylene accumulation, preserving turgor pressure. Actual shelf life will vary depending on ambient field transition and transport humidity.',
        ),
        intakeTimestamp: now.subtract(const Duration(hours: 28)),
        stageHistory: [
          StageHistoryItem(
            stage: LotStage.received,
            timestamp: now.subtract(const Duration(hours: 28)),
            actor: 'Operator Somanna (Intake Bay 1)',
            notes: 'Gross weight 250 kg verified across 10 clean plastic crates.',
          ),
          StageHistoryItem(
            stage: LotStage.graded,
            timestamp: now.subtract(const Duration(hours: 27, minutes: 45)),
            actor: 'FasalOS Computer Vision v2.4',
            notes: 'Grade A+ confirmed. Color maturity 89%, sizing uniformity 92%, blemish 3%.',
          ),
          StageHistoryItem(
            stage: LotStage.stored,
            timestamp: now.subtract(const Duration(hours: 27, minutes: 30)),
            actor: 'Cold Hub Chilled Bay 3',
            notes: 'Palletized into Pre-cool Chamber 2 at 11.8°C.',
          ),
        ],
        expectedPricePerKg: 32.0,
      ),
      ProduceLot(
        id: 'FOS-20482',
        farmerName: 'Ravi Kumar',
        farmerVillage: 'Dhone Mandal',
        cropType: 'Country Tomatoes',
        quantityKg: 150.0,
        photoAsset: 'assets/images/produce_tomatoes.jpg',
        stage: LotStage.stored,
        quality: const QualityFactors(
          colorMaturity: 0.88,
          sizingUniformity: 0.90,
          blemishRate: 0.04,
          firmnessIndex: 0.89,
          confidence: 0.92,
          grade: 'A+',
        ),
        freshness: const FreshnessMetrics(
          freshnessScore: 93,
          chamberTemperature: 11.7,
          relativeHumidity: 87.5,
          storageDurationHours: 24,
          estimatedRemainingDays: 14,
          cropCondition: 'Prime Firm',
          scientificExplanation:
              'Equilibrium maintained with active vapor-tight sealing. Ethylene scrubbers nominal.',
        ),
        intakeTimestamp: now.subtract(const Duration(hours: 24)),
        stageHistory: [
          StageHistoryItem(
            stage: LotStage.received,
            timestamp: now.subtract(const Duration(hours: 24)),
            actor: 'Operator Somanna',
            notes: '6 crates weighed and tagged.',
          ),
          StageHistoryItem(
            stage: LotStage.graded,
            timestamp: now.subtract(const Duration(hours: 23, minutes: 40)),
            actor: 'FasalOS Computer Vision',
            notes: 'Grade A+ verified.',
          ),
          StageHistoryItem(
            stage: LotStage.stored,
            timestamp: now.subtract(const Duration(hours: 23, minutes: 20)),
            actor: 'Cold Hub Bay 3',
            notes: 'Stored adjacent to Lot FOS-20481.',
          ),
        ],
        expectedPricePerKg: 32.0,
      ),
      ProduceLot(
        id: 'FOS-20483',
        farmerName: 'Suresh Reddy',
        farmerVillage: 'Peapully, Kurnool',
        cropType: 'Country Tomatoes',
        quantityKg: 100.0,
        photoAsset: 'assets/images/produce_tomatoes.jpg',
        stage: LotStage.stored,
        quality: const QualityFactors(
          colorMaturity: 0.86,
          sizingUniformity: 0.88,
          blemishRate: 0.05,
          firmnessIndex: 0.90,
          confidence: 0.91,
          grade: 'A+',
        ),
        freshness: const FreshnessMetrics(
          freshnessScore: 92,
          chamberTemperature: 11.9,
          relativeHumidity: 88.2,
          storageDurationHours: 19,
          estimatedRemainingDays: 13,
          cropCondition: 'Prime Firm',
          scientificExplanation:
              'Rapid pre-cooling within 2 hours of field picking stabilized respiration.',
        ),
        intakeTimestamp: now.subtract(const Duration(hours: 19)),
        stageHistory: [
          StageHistoryItem(
            stage: LotStage.received,
            timestamp: now.subtract(const Duration(hours: 19)),
            actor: 'Operator Somanna',
            notes: '4 crates intake.',
          ),
          StageHistoryItem(
            stage: LotStage.graded,
            timestamp: now.subtract(const Duration(hours: 18, minutes: 40)),
            actor: 'FasalOS Computer Vision',
            notes: 'Grade A+ classified.',
          ),
          StageHistoryItem(
            stage: LotStage.stored,
            timestamp: now.subtract(const Duration(hours: 18, minutes: 20)),
            actor: 'Cold Hub Bay 3',
            notes: 'Placed for aggregation.',
          ),
        ],
        expectedPricePerKg: 32.0,
      ),
      ProduceLot(
        id: 'FOS-20484',
        farmerName: 'Venkatesh Rao',
        farmerVillage: 'Orvakal, Kurnool',
        cropType: 'Red Onions',
        quantityKg: 600.0,
        photoAsset: 'assets/images/produce_onions.jpg',
        stage: LotStage.stored,
        quality: const QualityFactors(
          colorMaturity: 0.94,
          sizingUniformity: 0.89,
          blemishRate: 0.02,
          firmnessIndex: 0.95,
          confidence: 0.96,
          grade: 'A',
        ),
        freshness: const FreshnessMetrics(
          freshnessScore: 96,
          chamberTemperature: 1.5,
          relativeHumidity: 68.0,
          storageDurationHours: 42,
          estimatedRemainingDays: 45,
          cropCondition: 'Dry Cured Dormant',
          scientificExplanation:
              'Low humidity (68% RH) and low temperature (1.5°C) inhibit sprouting and mold germination.',
        ),
        intakeTimestamp: now.subtract(const Duration(hours: 42)),
        stageHistory: [
          StageHistoryItem(
            stage: LotStage.received,
            timestamp: now.subtract(const Duration(hours: 42)),
            actor: 'Operator Somanna',
            notes: '12 jute sacks (50 kg each) checked.',
          ),
          StageHistoryItem(
            stage: LotStage.graded,
            timestamp: now.subtract(const Duration(hours: 41)),
            actor: 'FasalOS Vision Sensor',
            notes: 'Cured skin uniformity 94%, dry neck verified.',
          ),
          StageHistoryItem(
            stage: LotStage.stored,
            timestamp: now.subtract(const Duration(hours: 40)),
            actor: 'Onion Storage Zone B',
            notes: 'Ventilated pallet rack storage.',
          ),
        ],
        expectedPricePerKg: 28.0,
      ),
      ProduceLot(
        id: 'FOS-20485',
        farmerName: 'Anjaneyulu M.',
        farmerVillage: 'Betamcherla',
        cropType: 'G4 Green Chillies',
        quantityKg: 180.0,
        photoAsset: 'assets/images/produce_chillies.jpg',
        stage: LotStage.stored,
        quality: const QualityFactors(
          colorMaturity: 0.92,
          sizingUniformity: 0.88,
          blemishRate: 0.03,
          firmnessIndex: 0.93,
          confidence: 0.93,
          grade: 'A+',
        ),
        freshness: const FreshnessMetrics(
          freshnessScore: 95,
          chamberTemperature: 8.5,
          relativeHumidity: 92.0,
          storageDurationHours: 14,
          estimatedRemainingDays: 20,
          cropCondition: 'Glossy Crisp Green',
          scientificExplanation:
              'High humidity chamber preserves stem hydration, preventing cap desiccation.',
        ),
        intakeTimestamp: now.subtract(const Duration(hours: 14)),
        stageHistory: [
          StageHistoryItem(
            stage: LotStage.received,
            timestamp: now.subtract(const Duration(hours: 14)),
            actor: 'Operator Somanna',
            notes: '9 green perforated crates.',
          ),
          StageHistoryItem(
            stage: LotStage.graded,
            timestamp: now.subtract(const Duration(hours: 13)),
            actor: 'FasalOS Vision Sensor',
            notes: 'Length & curvature within Grade A+ tolerance.',
          ),
          StageHistoryItem(
            stage: LotStage.stored,
            timestamp: now.subtract(const Duration(hours: 12)),
            actor: 'Chill Chamber Zone A',
            notes: 'Target set at 8.5°C.',
          ),
        ],
        expectedPricePerKg: 55.0,
      ),
    ];
  }

  static SolarTelemetry getInitialSolar() {
    return const SolarTelemetry(
      generatedKwh: 62.0,
      consumedKwh: 84.0,
      solarContributionPct: 74,
      coldChainConsumptionKwh: 56.0,
      batteryReserveFormatted: '6h 20m',
      currentSolarKw: 8.4,
      coldRoomKw: 4.2,
      batterySocPct: 86.0,
      isSimulated: true,
    );
  }

  static List<MarketOption> getMarketOptions() {
    return const [
      MarketOption(
        type: MarketChannelType.buyerOrder,
        title: 'FreshMart Supermarkets (Direct Retail)',
        minPrice: 30.0,
        maxPrice: 34.0,
        expectedPrice: 32.0,
        demandedQuantityKg: 500.0,
        distanceKm: 210,
        qualityRequirement: 'Grade A+ | Uniform Ripeness >85% | Clean Crates',
        timingWindow: 'Pickup in 3 hrs • Delivery within 10 hrs',
        assumptions:
            'Assumes refrigerated reefer transport arranged by buyer. Spot contract locked upon batch aggregation.',
        isRecommended: true,
        buyerEntity: 'FreshMart Logistics Hub (Bengaluru DC)',
      ),
      MarketOption(
        type: MarketChannelType.localMandi,
        title: 'Kurnool APMC Agricultural Mandi',
        minPrice: 21.0,
        maxPrice: 25.0,
        expectedPrice: 23.0,
        demandedQuantityKg: 1000.0,
        distanceKm: 18,
        qualityRequirement: 'All Grades Accepted | Unsorted Allowed',
        timingWindow: 'Immediate auction window (05:00 AM – 10:00 AM)',
        assumptions:
            'Subject to daily bidding volatility, 4% trader commission, and open-air ambient deterioration risk.',
        isRecommended: false,
        buyerEntity: 'Mandi Commission Agents Collective',
      ),
      MarketOption(
        type: MarketChannelType.foodProcessing,
        title: 'Kisan AgroFoods Processing Plant',
        minPrice: 18.0,
        maxPrice: 21.0,
        expectedPrice: 19.5,
        demandedQuantityKg: 3000.0,
        distanceKm: 45,
        qualityRequirement: 'Grade B & A | Min 4.5° Brix Sugar | Paste/Puree Spec',
        timingWindow: 'Scheduled delivery window next 48 hrs',
        assumptions:
            'Guaranteed buyback contract for large volumes; lower price per kg but zero rejection risk for minor skin blemishes.',
        isRecommended: false,
        buyerEntity: 'Kisan Agro Processing Ltd, Nandyal',
      ),
    ];
  }

  static List<SettlementRecord> getInitialSettlements() {
    final now = DateTime.now();
    return [
      SettlementRecord(
        settlementId: 'SET-9011',
        lotId: 'FOS-20481',
        farmerName: 'Lakshmi Devi',
        cropType: 'Country Tomatoes',
        quantityKg: 250.0,
        ratePerKg: 32.0,
        grossProduceValue: 8000.0,
        coldChainQualityPremium: 400.0,
        hubHandlingFee: 300.0,
        netFarmerPayout: 8100.0,
        bankAccountMasked: 'SBI •••• 9821',
        transactionRef: 'DBT-AP-2026-904128',
        settledAt: now.subtract(const Duration(minutes: 15)),
        isDisbursed: true,
      ),
      SettlementRecord(
        settlementId: 'SET-9012',
        lotId: 'FOS-20482',
        farmerName: 'Ravi Kumar',
        cropType: 'Country Tomatoes',
        quantityKg: 150.0,
        ratePerKg: 32.0,
        grossProduceValue: 4800.0,
        coldChainQualityPremium: 240.0,
        hubHandlingFee: 180.0,
        netFarmerPayout: 4860.0,
        bankAccountMasked: 'Andhra Bank •••• 4410',
        transactionRef: 'DBT-AP-2026-904129',
        settledAt: now.subtract(const Duration(minutes: 15)),
        isDisbursed: true,
      ),
      SettlementRecord(
        settlementId: 'SET-9013',
        lotId: 'FOS-20483',
        farmerName: 'Suresh Reddy',
        cropType: 'Country Tomatoes',
        quantityKg: 100.0,
        ratePerKg: 32.0,
        grossProduceValue: 3200.0,
        coldChainQualityPremium: 160.0,
        hubHandlingFee: 120.0,
        netFarmerPayout: 3240.0,
        bankAccountMasked: 'Union Bank •••• 3108',
        transactionRef: 'DBT-AP-2026-904130',
        settledAt: now.subtract(const Duration(minutes: 15)),
        isDisbursed: true,
      ),
    ];
  }
}
