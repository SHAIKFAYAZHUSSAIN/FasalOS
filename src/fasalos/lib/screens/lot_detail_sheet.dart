import 'package:flutter/material.dart';
import '../models/produce_lot.dart';
import '../services/fasal_state.dart';
import '../theme/app_theme.dart';
import '../widgets/lot_journey.dart';
import '../widgets/freshness_indicator.dart';
import '../widgets/quality_assessment.dart';

class LotDetailSheet extends StatelessWidget {
  final ProduceLot lot;
  final FasalState state;
  final VoidCallback? onAggregateTapped;
  final VoidCallback? onMarketTapped;

  const LotDetailSheet({
    super.key,
    required this.lot,
    required this.state,
    this.onAggregateTapped,
    this.onMarketTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: FasalColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: FasalColors.borderStrong,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Top Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          lot.id,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: FasalColors.primaryGreenDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: FasalColors.primaryGreenSubtle,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            lot.stage.displayName,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: FasalColors.primaryGreenDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${lot.farmerName} • ${lot.farmerVillage}',
                      style: const TextStyle(fontSize: 12, color: FasalColors.textSecondary),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(),

          // Scrollable Deep Inspection Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo Banner with Key Details
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.asset(
                          lot.photoAsset,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            height: 160,
                            color: FasalColors.surfaceMuted,
                            child: const Icon(Icons.agriculture, size: 48),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.75),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  lot.cropType,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: FasalColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${lot.quantityKg.toInt()} kg',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Signature Interaction 6: Lot Journey (8 Stages)
                  LotJourney(
                    lot: lot,
                    onStageSelected: (stage) {
                      // Tap to reveal
                    },
                  ),
                  const SizedBox(height: 16),

                  // Signature Interaction 2: Freshness Diagnostics (with explanation expander)
                  FreshnessIndicator(
                    freshness: lot.freshness,
                    cropType: lot.cropType,
                  ),
                  const SizedBox(height: 16),

                  // Computer Vision Quality Assessment
                  QualityAssessmentWidget(
                    quality: lot.quality,
                    cropType: lot.cropType,
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            state.toggleLotSelectionForAggregation(lot.id);
                            Navigator.of(context).pop();
                            onAggregateTapped?.call();
                          },
                          icon: const Icon(Icons.merge_type, size: 18),
                          label: const Text('Add to Batch'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            onMarketTapped?.call();
                          },
                          icon: const Icon(Icons.trending_up, size: 18),
                          label: const Text('Match Market'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
