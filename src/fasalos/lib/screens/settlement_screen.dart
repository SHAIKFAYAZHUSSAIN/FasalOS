import 'package:flutter/material.dart';
import '../services/fasal_state.dart';
import '../widgets/settlement_summary.dart';

class SettlementScreen extends StatelessWidget {
  final FasalState state;

  const SettlementScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SettlementSummary(
      settlements: state.settlements,
      onRefresh: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settlement ledger refreshed via NPCI DBT gateway.'),
            duration: Duration(seconds: 1),
          ),
        );
      },
    );
  }
}
