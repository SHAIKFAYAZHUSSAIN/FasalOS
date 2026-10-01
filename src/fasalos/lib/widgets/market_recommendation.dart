import 'package:flutter/material.dart';
import '../models/market_channel.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class MarketRecommendation extends StatefulWidget {
  final List<MarketOption> options;
  final ValueChanged<MarketOption>? onSelectOption;

  const MarketRecommendation({
    super.key,
    required this.options,
    this.onSelectOption,
  });

  @override
  State<MarketRecommendation> createState() => _MarketRecommendationState();
}

class _MarketRecommendationState extends State<MarketRecommendation> {
  MarketOption? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.options.firstWhere(
      (o) => o.isRecommended,
      orElse: () => widget.options.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
                            color: FasalColors.harvestAmberLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.hub, size: 20, color: FasalColors.harvestAmber),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.get('market_title'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: FasalColors.textPrimary,
                              ),
                            ),
                            const Text(
                              'Optimizing price realization based on grade & cold life',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: FasalColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: FasalColors.harvestAmberLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        l10n.get('demo_data_badge'),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: FasalColors.harvestAmberDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'FasalOS matches stored lot attributes (Grade A+, 94% freshness) against current institutional and local purchase tenders to prevent distress sales.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: FasalColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Options List
          ...widget.options.map((option) {
            final isSelected = _selectedOption?.title == option.title;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Card(
                elevation: isSelected ? 2 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? FasalColors.primaryGreen : FasalColors.borderSubtle,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedOption = option;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Bar with Channel Badge and Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                if (option.isRecommended) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: FasalColors.success,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'RECOMMENDED',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Text(
                                  _getChannelName(option.type, l10n),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: FasalColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            // Expected Price
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                const Text(
                                  '₹',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: FasalColors.primaryGreen,
                                  ),
                                ),
                                Text(
                                  option.expectedPrice.toStringAsFixed(0),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: FasalColors.primaryGreen,
                                  ),
                                ),
                                const Text(
                                  ' /kg',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: FasalColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Title & Buyer Entity
                        Text(
                          option.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: FasalColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Target: ${option.buyerEntity}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: FasalColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Details Grid
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: FasalColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              _buildDetailRow(
                                icon: Icons.currency_rupee,
                                label: 'Expected Range',
                                value: '₹${option.minPrice.toInt()} – ₹${option.maxPrice.toInt()}/kg',
                              ),
                              const SizedBox(height: 6),
                              _buildDetailRow(
                                icon: Icons.scale,
                                label: 'Demanded Batch',
                                value: '${option.demandedQuantityKg.toInt()} kg capacity',
                              ),
                              const SizedBox(height: 6),
                              _buildDetailRow(
                                icon: Icons.route,
                                label: 'Transit Distance',
                                value: '${option.distanceKm} km (cold transit)',
                              ),
                              const SizedBox(height: 6),
                              _buildDetailRow(
                                icon: Icons.verified,
                                label: 'Quality Specs',
                                value: option.qualityRequirement,
                              ),
                              const SizedBox(height: 6),
                              _buildDetailRow(
                                icon: Icons.schedule,
                                label: 'Timing',
                                value: option.timingWindow,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Assumptions box
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: FasalColors.borderSubtle),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.lightbulb_outline, size: 14, color: FasalColors.harvestAmber),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Assumptions: ${option.assumptions}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    height: 1.35,
                                    color: FasalColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Selection Action Button
                        SizedBox(
                          width: double.infinity,
                          child: isSelected
                              ? ElevatedButton.icon(
                                  onPressed: () => widget.onSelectOption?.call(option),
                                  icon: const Icon(Icons.check, size: 18),
                                  label: const Text('Lock Route & Confirm Buyer Contract'),
                                )
                              : OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedOption = option;
                                    });
                                  },
                                  child: const Text('Select This Route'),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  String _getChannelName(MarketChannelType type, AppLocalizations l10n) {
    switch (type) {
      case MarketChannelType.localMandi:
        return l10n.get('channel_local');
      case MarketChannelType.buyerOrder:
        return l10n.get('channel_buyer');
      case MarketChannelType.foodProcessing:
        return l10n.get('channel_processing');
    }
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: FasalColors.textMuted),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: FasalColors.textMuted),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: FasalColors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
