import 'package:flutter/foundation.dart';

@immutable
class SettlementRecord {
  final String settlementId; // e.g. 'SET-8821'
  final String lotId; // 'FOS-20481'
  final String farmerName; // 'Lakshmi'
  final String cropType; // 'Country Tomatoes'
  final double quantityKg; // 250.0 kg
  final double ratePerKg; // ₹32.00
  final double grossProduceValue; // ₹8,000
  final double coldChainQualityPremium; // +₹400 (saved spoilage & prime grade)
  final double hubHandlingFee; // -₹300 (intake & grading service fee)
  final double netFarmerPayout; // ₹8,100
  final String bankAccountMasked; // 'SBI •••• 9821'
  final String transactionRef; // 'DBT-AP-2026-904128'
  final DateTime settledAt;
  final bool isDisbursed;

  const SettlementRecord({
    required this.settlementId,
    required this.lotId,
    required this.farmerName,
    required this.cropType,
    required this.quantityKg,
    required this.ratePerKg,
    required this.grossProduceValue,
    required this.coldChainQualityPremium,
    required this.hubHandlingFee,
    required this.netFarmerPayout,
    required this.bankAccountMasked,
    required this.transactionRef,
    required this.settledAt,
    required this.isDisbursed,
  });

  SettlementRecord copyWith({
    String? settlementId,
    String? lotId,
    String? farmerName,
    String? cropType,
    double? quantityKg,
    double? ratePerKg,
    double? grossProduceValue,
    double? coldChainQualityPremium,
    double? hubHandlingFee,
    double? netFarmerPayout,
    String? bankAccountMasked,
    String? transactionRef,
    DateTime? settledAt,
    bool? isDisbursed,
  }) {
    return SettlementRecord(
      settlementId: settlementId ?? this.settlementId,
      lotId: lotId ?? this.lotId,
      farmerName: farmerName ?? this.farmerName,
      cropType: cropType ?? this.cropType,
      quantityKg: quantityKg ?? this.quantityKg,
      ratePerKg: ratePerKg ?? this.ratePerKg,
      grossProduceValue: grossProduceValue ?? this.grossProduceValue,
      coldChainQualityPremium: coldChainQualityPremium ?? this.coldChainQualityPremium,
      hubHandlingFee: hubHandlingFee ?? this.hubHandlingFee,
      netFarmerPayout: netFarmerPayout ?? this.netFarmerPayout,
      bankAccountMasked: bankAccountMasked ?? this.bankAccountMasked,
      transactionRef: transactionRef ?? this.transactionRef,
      settledAt: settledAt ?? this.settledAt,
      isDisbursed: isDisbursed ?? this.isDisbursed,
    );
  }
}
