import 'package:flutter/material.dart';
import '../services/fasal_state.dart';
import '../widgets/market_recommendation.dart';

class MarketMatchingScreen extends StatelessWidget {
  final FasalState state;
  final ValueChanged<int>? onNavigateTab;

  const MarketMatchingScreen({
    super.key,
    required this.state,
    this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    return MarketRecommendation(
      options: state.marketOptions,
      onSelectOption: (option) {
        state.matchBuyerAndCreateOrder(
          marketOption: option,
          requestedKg: 500.0,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Buyer order contract confirmed with ${option.buyerEntity}!'),
            duration: const Duration(seconds: 2),
          ),
        );
        onNavigateTab?.call(4); // Navigate to Buyer & Dispatch Tracking
      },
    );
  }
}
