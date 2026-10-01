import 'package:flutter/foundation.dart';

enum BuyerOrderStatus {
  orderPlaced,
  inColdTransit,
  delivered,
  settled;

  String get label {
    switch (this) {
      case BuyerOrderStatus.orderPlaced:
        return 'Order Confirmed';
      case BuyerOrderStatus.inColdTransit:
        return 'Refrigerated Transport In-Transit';
      case BuyerOrderStatus.delivered:
        return 'Delivered at Buyer Hub';
      case BuyerOrderStatus.settled:
        return 'Payment Settled to Farmers';
    }
  }
}

@immutable
class BuyerOrder {
  final String orderId; // 'ORD-9021'
  final String buyerName; // 'FreshMart Retail Hypermarkets'
  final String buyerLocation; // 'Electronic City, Bengaluru (210 km)'
  final String cropType; // 'Country Tomatoes'
  final String requiredGrade; // 'Grade A+'
  final double requestedQuantityKg; // 500.0 kg
  final double agreedRatePerKg; // ₹32.00
  final double totalOrderAmount; // ₹16,000
  final List<String> contributingLotIds; // ['FOS-20481', 'FOS-20482', 'FOS-20483']
  final BuyerOrderStatus status;
  final DateTime orderTimestamp;
  final String vehicleNumber; // 'AP-21-TJ-4491 (Solar Reefer)'
  final double transportTemp; // 11.6 °C
  final double progressFraction; // 0.0 to 1.0

  const BuyerOrder({
    required this.orderId,
    required this.buyerName,
    required this.buyerLocation,
    required this.cropType,
    required this.requiredGrade,
    required this.requestedQuantityKg,
    required this.agreedRatePerKg,
    required this.totalOrderAmount,
    required this.contributingLotIds,
    required this.status,
    required this.orderTimestamp,
    required this.vehicleNumber,
    required this.transportTemp,
    this.progressFraction = 0.0,
  });

  BuyerOrder copyWith({
    String? orderId,
    String? buyerName,
    String? buyerLocation,
    String? cropType,
    String? requiredGrade,
    double? requestedQuantityKg,
    double? agreedRatePerKg,
    double? totalOrderAmount,
    List<String>? contributingLotIds,
    BuyerOrderStatus? status,
    DateTime? orderTimestamp,
    String? vehicleNumber,
    double? transportTemp,
    double? progressFraction,
  }) {
    return BuyerOrder(
      orderId: orderId ?? this.orderId,
      buyerName: buyerName ?? this.buyerName,
      buyerLocation: buyerLocation ?? this.buyerLocation,
      cropType: cropType ?? this.cropType,
      requiredGrade: requiredGrade ?? this.requiredGrade,
      requestedQuantityKg: requestedQuantityKg ?? this.requestedQuantityKg,
      agreedRatePerKg: agreedRatePerKg ?? this.agreedRatePerKg,
      totalOrderAmount: totalOrderAmount ?? this.totalOrderAmount,
      contributingLotIds: contributingLotIds ?? this.contributingLotIds,
      status: status ?? this.status,
      orderTimestamp: orderTimestamp ?? this.orderTimestamp,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      transportTemp: transportTemp ?? this.transportTemp,
      progressFraction: progressFraction ?? this.progressFraction,
    );
  }
}
