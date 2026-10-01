import 'package:flutter/foundation.dart';

enum LotStage {
  received,
  graded,
  stored,
  matched,
  aggregating,
  dispatched,
  delivered,
  paid;

  String get displayName {
    switch (this) {
      case LotStage.received:
        return 'Received';
      case LotStage.graded:
        return 'Graded';
      case LotStage.stored:
        return 'Stored';
      case LotStage.matched:
        return 'Matched';
      case LotStage.aggregating:
        return 'Aggregated';
      case LotStage.dispatched:
        return 'Dispatched';
      case LotStage.delivered:
        return 'Delivered';
      case LotStage.paid:
        return 'Settled & Paid';
    }
  }

  int get stepIndex => index;
}

@immutable
class QualityFactors {
  final double colorMaturity; // 0.0 - 1.0 (e.g. 0.89)
  final double sizingUniformity; // 0.0 - 1.0 (e.g. 0.92)
  final double blemishRate; // 0.0 - 1.0 (e.g. 0.03)
  final double firmnessIndex; // 0.0 - 1.0 (e.g. 0.91)
  final double confidence; // 0.0 - 1.0 (e.g. 0.93)
  final String grade; // 'A+', 'A', 'B'

  const QualityFactors({
    required this.colorMaturity,
    required this.sizingUniformity,
    required this.blemishRate,
    required this.firmnessIndex,
    required this.confidence,
    required this.grade,
  });

  QualityFactors copyWith({
    double? colorMaturity,
    double? sizingUniformity,
    double? blemishRate,
    double? firmnessIndex,
    double? confidence,
    String? grade,
  }) {
    return QualityFactors(
      colorMaturity: colorMaturity ?? this.colorMaturity,
      sizingUniformity: sizingUniformity ?? this.sizingUniformity,
      blemishRate: blemishRate ?? this.blemishRate,
      firmnessIndex: firmnessIndex ?? this.firmnessIndex,
      confidence: confidence ?? this.confidence,
      grade: grade ?? this.grade,
    );
  }
}

@immutable
class FreshnessMetrics {
  final int freshnessScore; // 0 - 100 (e.g. 94)
  final double chamberTemperature; // e.g. 11.8 °C
  final double relativeHumidity; // e.g. 88.0 %
  final int storageDurationHours; // e.g. 28 hours
  final int estimatedRemainingDays; // e.g. 14 days
  final String cropCondition; // 'Prime Crisp', 'Optimal', 'Good'
  final String scientificExplanation;

  const FreshnessMetrics({
    required this.freshnessScore,
    required this.chamberTemperature,
    required this.relativeHumidity,
    required this.storageDurationHours,
    required this.estimatedRemainingDays,
    required this.cropCondition,
    required this.scientificExplanation,
  });

  FreshnessMetrics copyWith({
    int? freshnessScore,
    double? chamberTemperature,
    double? relativeHumidity,
    int? storageDurationHours,
    int? estimatedRemainingDays,
    String? cropCondition,
    String? scientificExplanation,
  }) {
    return FreshnessMetrics(
      freshnessScore: freshnessScore ?? this.freshnessScore,
      chamberTemperature: chamberTemperature ?? this.chamberTemperature,
      relativeHumidity: relativeHumidity ?? this.relativeHumidity,
      storageDurationHours: storageDurationHours ?? this.storageDurationHours,
      estimatedRemainingDays: estimatedRemainingDays ?? this.estimatedRemainingDays,
      cropCondition: cropCondition ?? this.cropCondition,
      scientificExplanation: scientificExplanation ?? this.scientificExplanation,
    );
  }
}

class StageHistoryItem {
  final LotStage stage;
  final DateTime timestamp;
  final String actor;
  final String notes;

  const StageHistoryItem({
    required this.stage,
    required this.timestamp,
    required this.actor,
    required this.notes,
  });
}

class ProduceLot {
  final String id; // e.g. 'FOS-20481'
  final String farmerName; // e.g. 'Lakshmi'
  final String farmerVillage; // e.g. 'Dhone, Kurnool'
  final String cropType; // e.g. 'Tomatoes'
  final double quantityKg; // e.g. 250.0
  final String photoAsset; // e.g. 'assets/images/produce_tomatoes.jpg'
  LotStage stage;
  final QualityFactors quality;
  final FreshnessMetrics freshness;
  final DateTime intakeTimestamp;
  final List<StageHistoryItem> stageHistory;
  bool isPendingSync;
  String? aggregatedBatchId;
  String? buyerOrderId;
  double? expectedPricePerKg;

  ProduceLot({
    required this.id,
    required this.farmerName,
    required this.farmerVillage,
    required this.cropType,
    required this.quantityKg,
    required this.photoAsset,
    required this.stage,
    required this.quality,
    required this.freshness,
    required this.intakeTimestamp,
    required this.stageHistory,
    this.isPendingSync = false,
    this.aggregatedBatchId,
    this.buyerOrderId,
    this.expectedPricePerKg,
  });

  ProduceLot copyWith({
    String? id,
    String? farmerName,
    String? farmerVillage,
    String? cropType,
    double? quantityKg,
    String? photoAsset,
    LotStage? stage,
    QualityFactors? quality,
    FreshnessMetrics? freshness,
    DateTime? intakeTimestamp,
    List<StageHistoryItem>? stageHistory,
    bool? isPendingSync,
    String? aggregatedBatchId,
    String? buyerOrderId,
    double? expectedPricePerKg,
  }) {
    return ProduceLot(
      id: id ?? this.id,
      farmerName: farmerName ?? this.farmerName,
      farmerVillage: farmerVillage ?? this.farmerVillage,
      cropType: cropType ?? this.cropType,
      quantityKg: quantityKg ?? this.quantityKg,
      photoAsset: photoAsset ?? this.photoAsset,
      stage: stage ?? this.stage,
      quality: quality ?? this.quality,
      freshness: freshness ?? this.freshness,
      intakeTimestamp: intakeTimestamp ?? this.intakeTimestamp,
      stageHistory: stageHistory ?? List.from(this.stageHistory),
      isPendingSync: isPendingSync ?? this.isPendingSync,
      aggregatedBatchId: aggregatedBatchId ?? this.aggregatedBatchId,
      buyerOrderId: buyerOrderId ?? this.buyerOrderId,
      expectedPricePerKg: expectedPricePerKg ?? this.expectedPricePerKg,
    );
  }
}
