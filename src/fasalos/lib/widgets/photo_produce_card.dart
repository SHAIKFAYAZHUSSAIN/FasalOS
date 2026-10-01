import 'package:flutter/material.dart';
import '../models/produce_lot.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class PhotoProduceCard extends StatelessWidget {
  final ProduceLot lot;
  final VoidCallback onTap;
  final bool isSelectionMode;
  final bool isSelected;
  final ValueChanged<bool?>? onSelectChanged;

  const PhotoProduceCard({
    super.key,
    required this.lot,
    required this.onTap,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onSelectChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Color based on stage
    Color stageColor;
    switch (lot.stage) {
      case LotStage.received:
        stageColor = FasalColors.soilBrown;
        break;
      case LotStage.graded:
        stageColor = FasalColors.harvestAmber;
        break;
      case LotStage.stored:
        stageColor = FasalColors.coldBlue;
        break;
      case LotStage.matched:
      case LotStage.aggregating:
        stageColor = FasalColors.primaryGreen;
        break;
      case LotStage.dispatched:
        stageColor = const Color(0xFF7C3AED);
        break;
      case LotStage.delivered:
      case LotStage.paid:
        stageColor = FasalColors.success;
        break;
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: isSelected ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? FasalColors.primaryGreen : FasalColors.borderSubtle,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo & Badges Stack
            Stack(
              children: [
                SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Image.asset(
                    lot.photoAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: FasalColors.primaryGreenSubtle,
                        child: const Center(
                          child: Icon(Icons.agriculture, size: 48, color: FasalColors.primaryGreen),
                        ),
                      );
                    },
                  ),
                ),
                // Subtle gradient overlay for readability
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                ),
                // Lot ID & Grade Pill
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      lot.id,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                // Selection Checkbox or Pending Sync
                Positioned(
                  top: 8,
                  right: 8,
                  child: isSelectionMode
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Checkbox(
                            value: isSelected,
                            onChanged: onSelectChanged,
                            activeColor: FasalColors.primaryGreen,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        )
                      : lot.isPendingSync
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: FasalColors.warning,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.cloud_queue, size: 12, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.get('sync_pending'),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                ),
                // Crop & Quantity Overlay
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          lot.cropType,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              Shadow(color: Colors.black54, offset: Offset(0, 1), blurRadius: 2),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: FasalColors.primaryGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${lot.quantityKg.toInt()} kg',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Details Body
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Farmer info
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.person, size: 14, color: FasalColors.textMuted),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${lot.farmerName} • ${lot.farmerVillage}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: FasalColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Stage pill & Freshness
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: stageColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: stageColor.withValues(alpha: 0.3), width: 1),
                        ),
                        child: Text(
                          lot.stage.displayName,
                          style: TextStyle(
                            color: stageColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.eco, size: 14, color: FasalColors.success),
                          const SizedBox(width: 4),
                          Text(
                            '${lot.quality.grade} (${lot.freshness.freshnessScore}% Fresh)',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: FasalColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
