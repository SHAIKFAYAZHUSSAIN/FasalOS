import 'package:flutter/foundation.dart';

enum MarketChannelType {
  localMandi,
  buyerOrder,
  foodProcessing;

  String get defaultTitle {
    switch (this) {
      case MarketChannelType.localMandi:
        return 'Local APMC Mandi (Kurnool)';
      case MarketChannelType.buyerOrder:
        return 'Retail Chain Buyer Order (FreshMart)';
      case MarketChannelType.foodProcessing:
        return 'Food Processing Unit (Kisan AgroFoods)';
    }
  }
}

@immutable
class MarketOption {
  final MarketChannelType type;
  final String title;
  final double minPrice;
  final double maxPrice;
  final double expectedPrice;
  final double demandedQuantityKg;
  final int distanceKm;
  final String qualityRequirement;
  final String timingWindow;
  final String assumptions;
  final bool isRecommended;
  final String buyerEntity;

  const MarketOption({
    required this.type,
    required this.title,
    required this.minPrice,
    required this.maxPrice,
    required this.expectedPrice,
    required this.demandedQuantityKg,
    required this.distanceKm,
    required this.qualityRequirement,
    required this.timingWindow,
    required this.assumptions,
    required this.isRecommended,
    required this.buyerEntity,
  });
}
