import 'package:flutter/material.dart';
import '../models/produce_lot.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class LotJourney extends StatefulWidget {
  final ProduceLot lot;
  final ValueChanged<LotStage>? onStageSelected;

  const LotJourney({
    super.key,
    required this.lot,
    this.onStageSelected,
  });

  @override
  State<LotJourney> createState() => _LotJourneyState();
}

class _LotJourneyState extends State<LotJourney> {
  LotStage? _inspectedStage;

  @override
  void initState() {
    super.initState();
    _inspectedStage = widget.lot.stage;
  }

  @override
  void didUpdateWidget(covariant LotJourney oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lot.stage != widget.lot.stage) {
      _inspectedStage = widget.lot.stage;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentStage = widget.lot.stage;
    final stages = LotStage.values;

    StageHistoryItem? historyItemFor(LotStage stage) {
      final matches = widget.lot.stageHistory.where((h) => h.stage == stage).toList();
      return matches.isNotEmpty ? matches.last : null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lot Journey Lifecycle',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: FasalColors.textPrimary,
                  ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: FasalColors.primaryGreenSubtle,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Stage ${currentStage.stepIndex + 1} of 8: ${currentStage.displayName}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: FasalColors.primaryGreenDark,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Horizontal Scrollable Stepper with 48x48 tap targets
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(stages.length, (index) {
              final stage = stages[index];
              final isPassed = stage.stepIndex < currentStage.stepIndex;
              final isCurrent = stage == currentStage;
              final isSelected = stage == _inspectedStage;
              final hasHistory = historyItemFor(stage) != null;

              Color stageDotColor;
              if (isCurrent) {
                stageDotColor = FasalColors.primaryGreen;
              } else if (isPassed || hasHistory) {
                stageDotColor = FasalColors.success;
              } else {
                stageDotColor = FasalColors.borderStrong;
              }

              return Row(
                children: [
                  Semantics(
                    button: true,
                    label: '${stage.displayName} stage. Tap to reveal stage details.',
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _inspectedStage = stage;
                        });
                        widget.onStageSelected?.call(stage);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 54, minHeight: 64),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? FasalColors.primaryGreenSubtle
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(color: FasalColors.primaryGreen, width: 1.5)
                              : null,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCurrent
                                    ? FasalColors.primaryGreen
                                    : (isPassed ? FasalColors.successSubtle : FasalColors.surfaceMuted),
                                border: Border.all(
                                  color: stageDotColor,
                                  width: isCurrent ? 2 : 1.5,
                                ),
                              ),
                              child: Center(
                                child: isPassed
                                    ? const Icon(Icons.check, size: 14, color: FasalColors.success)
                                    : Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: isCurrent ? Colors.white : FasalColors.textSecondary,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              stage.displayName,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected || isCurrent
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected || isCurrent
                                    ? FasalColors.textPrimary
                                    : FasalColors.textMuted,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (index < stages.length - 1)
                    Container(
                      width: 18,
                      height: 2,
                      color: stage.stepIndex < currentStage.stepIndex
                          ? FasalColors.success
                          : FasalColors.borderSubtle,
                    ),
                ],
              );
            }),
          ),
        ),
        const SizedBox(height: 14),

        // Contextual Stage Reveal Detail Box
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _buildStageDetailCard(context, _inspectedStage ?? currentStage, l10n),
        ),
      ],
    );
  }

  Widget _buildStageDetailCard(BuildContext context, LotStage stage, AppLocalizations l10n) {
    final historyItem = widget.lot.stageHistory.where((h) => h.stage == stage).firstOrNull;
    final isPending = historyItem == null;

    return Container(
      key: ValueKey(stage),
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: FasalColors.surfaceMuted,
        borderRadius: BorderRadius.circular(10),
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
                  Icon(
                    isPending ? Icons.hourglass_empty : Icons.check_circle,
                    size: 16,
                    color: isPending ? FasalColors.textMuted : FasalColors.success,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Stage Verification: ${stage.displayName}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: FasalColors.textPrimary,
                    ),
                  ),
                ],
              ),
              if (historyItem != null)
                Text(
                  '${historyItem.timestamp.hour.toString().padLeft(2, '0')}:${historyItem.timestamp.minute.toString().padLeft(2, '0')} hrs',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: FasalColors.textMuted,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (historyItem != null) ...[
            Text(
              'Verified by: ${historyItem.actor}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: FasalColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              historyItem.notes,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: FasalColors.textPrimary,
              ),
            ),
          ] else ...[
            Text(
              'This stage has not yet executed for Lot ${widget.lot.id}. It will trigger when upstream cold-chain or market milestones are verified.',
              style: const TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: FasalColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
