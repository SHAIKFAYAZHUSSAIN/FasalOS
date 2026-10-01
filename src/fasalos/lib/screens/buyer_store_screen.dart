import 'package:flutter/material.dart';
import '../services/fasal_state.dart';
import '../widgets/buyer_order_widget.dart';
import 'lot_detail_sheet.dart';

class BuyerStoreScreen extends StatelessWidget {
  final FasalState state;
  final ValueChanged<int>? onNavigateTab;

  const BuyerStoreScreen({
    super.key,
    required this.state,
    this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    return BuyerOrderWidget(
      state: state,
      onInspectLot: (lot) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) => LotDetailSheet(
            lot: lot,
            state: state,
            onAggregateTapped: () => onNavigateTab?.call(3),
            onMarketTapped: () => onNavigateTab?.call(2),
          ),
        );
      },
      onOrderPlaced: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Buyer order submitted! Reefer truck assigned.'),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }
}
