import 'package:flutter/material.dart';
import '../services/fasal_state.dart';
import '../widgets/aggregation_view.dart';

class AggregationScreen extends StatelessWidget {
  final FasalState state;
  final ValueChanged<int>? onNavigateTab;

  const AggregationScreen({
    super.key,
    required this.state,
    this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    return AggregationView(
      state: state,
      onCombine: () {
        state.combineSelectedLots();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lots successfully combined into buyer-ready batch!'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      onMatchBuyer: () {
        onNavigateTab?.call(2); // Go to Market Match
      },
      onDispatch: () {
        if (state.buyerOrders.isNotEmpty) {
          state.dispatchOrder(state.buyerOrders.first.orderId);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Solar Reefer Truck Dispatched! Tracking activated.'),
              duration: Duration(seconds: 2),
            ),
          );
          onNavigateTab?.call(4); // Go to Buyer/Logistics
        }
      },
    );
  }
}
