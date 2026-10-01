import 'package:flutter/material.dart';
import '../services/fasal_state.dart';
import '../models/produce_lot.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class AggregationView extends StatelessWidget {
  final FasalState state;
  final VoidCallback onCombine;
  final VoidCallback onMatchBuyer;
  final VoidCallback onDispatch;

  const AggregationView({
    super.key,
    required this.state,
    required this.onCombine,
    required this.onMatchBuyer,
    required this.onDispatch,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final storedLots = state.lots.where((l) => l.stage == LotStage.stored || l.stage == LotStage.aggregating).toList();
    final selectedIds = state.selectedLotIdsForAggregation;
    final selectedLots = state.lots.where((l) => selectedIds.contains(l.id)).toList();
    final totalSelectedWeight = selectedLots.fold(0.0, (acc, l) => acc + l.quantityKg);
    final activeBatch = state.activeBatch;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FasalColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: FasalColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: FasalColors.primaryGreenSubtle,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.layers, size: 22, color: FasalColors.primaryGreen),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.get('aggregation_title'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: FasalColors.textPrimary,
                              ),
                            ),
                            const Text(
                              'Consolidate smallholder lots for institutional scale',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: FasalColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.get('aggregation_desc'),
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: FasalColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Consolidated Active Batch (if aggregated)
          if (activeBatch != null) ...[
            _buildActiveBatchCard(context, activeBatch, l10n),
            const SizedBox(height: 20),
          ],

          // Multi-Lot Selection Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Smallholder Lots for Aggregation',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: FasalColors.textPrimary,
                    ),
              ),
              if (selectedIds.isNotEmpty)
                TextButton(
                  onPressed: state.clearAggregationSelection,
                  child: const Text('Clear Selection'),
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Lots list with checkbox selectors
          ...storedLots.map((lot) {
            final isSelected = selectedIds.contains(lot.id);
            final isAggregatedInBatch = activeBatch != null && activeBatch.memberLots.any((m) => m.id == lot.id);

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isSelected ? FasalColors.primaryGreenSubtle : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? FasalColors.primaryGreen : FasalColors.borderSubtle,
                  width: isSelected ? 1.8 : 1,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    lot.photoAsset,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(Icons.agriculture, size: 32),
                  ),
                ),
                title: Text(
                  '${lot.farmerName} (${lot.farmerVillage})',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  '${lot.id} • ${lot.cropType} • Grade ${lot.quality.grade} (${lot.freshness.freshnessScore}% Fresh)',
                  style: const TextStyle(fontSize: 12, color: FasalColors.textSecondary),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: FasalColors.primaryGreen,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${lot.quantityKg.toInt()} kg',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isAggregatedInBatch)
                      const Icon(Icons.check_circle, color: FasalColors.success, size: 24)
                    else
                      Checkbox(
                        value: isSelected,
                        onChanged: (val) => state.toggleLotSelectionForAggregation(lot.id),
                        activeColor: FasalColors.primaryGreen,
                      ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // Tally Bar & Combine Action
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FasalColors.surfaceMuted,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: FasalColors.borderSubtle),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected for Aggregation',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: FasalColors.textMuted),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${selectedIds.length} Lots Selected',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: FasalColors.textPrimary),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${totalSelectedWeight.toInt()}',
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: FasalColors.primaryGreen),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'kg',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: FasalColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: selectedIds.isNotEmpty ? onCombine : null,
                    icon: const Icon(Icons.merge_type),
                    label: Text(
                      selectedIds.isNotEmpty
                          ? 'Combine ${selectedIds.length} Lots into ${totalSelectedWeight.toInt()} kg Batch'
                          : 'Select Lots Above to Combine',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveBatchCard(BuildContext context, ConsolidatedBatch batch, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FasalColors.primaryGreenSubtle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FasalColors.primaryGreen.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: FasalColors.primaryGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'BATCH: ${batch.batchId}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: FasalColors.success),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, size: 14, color: FasalColors.success),
                    const SizedBox(width: 4),
                    Text(
                      batch.isDispatched ? 'Dispatched' : 'Buyer-Ready',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: FasalColors.success),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${batch.totalWeightKg.toInt()} kg Consolidated ${batch.cropType} (${batch.grade})',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: FasalColors.primaryGreenDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Aggregated from ${batch.memberLots.length} smallholder farmers: ${batch.memberLots.map((m) => '${m.farmerName} (${m.quantityKg.toInt()}kg)').join(', ')}',
            style: const TextStyle(fontSize: 12, height: 1.4, color: FasalColors.textSecondary),
          ),
          const SizedBox(height: 14),

          // Next Step Action Flow: Match Buyer -> Confirm Order -> Prepare Shipment -> Dispatch
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onMatchBuyer,
                  icon: const Icon(Icons.storefront, size: 18),
                  label: const Text('Match Buyer'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: batch.isDispatched ? null : onDispatch,
                  icon: const Icon(Icons.local_shipping, size: 18),
                  label: Text(batch.isDispatched ? 'Dispatched' : 'Dispatch Reefer'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
