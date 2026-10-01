import 'package:flutter/material.dart';
import '../models/produce_lot.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class QualityAssessmentWidget extends StatelessWidget {
  final QualityFactors quality;
  final String cropType;
  final ValueChanged<String>? onGradeChanged;
  final bool isConfirmed;

  const QualityAssessmentWidget({
    super.key,
    required this.quality,
    required this.cropType,
    this.onGradeChanged,
    this.isConfirmed = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FasalColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FasalColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with AI Model tag
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
                    child: const Icon(Icons.psychology, size: 20, color: FasalColors.primaryGreen),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.get('quality_grade'),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: FasalColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Computer Vision v2.4 • ${(quality.confidence * 100).toInt()}% Confidence',
                        style: const TextStyle(
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: FasalColors.successSubtle,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: FasalColors.success, width: 1.5),
                ),
                child: Text(
                  'Grade ${quality.grade}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: FasalColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Quality Factor Breakdown Bars
          _buildFactorRow(
            label: l10n.get('color_maturity'),
            fraction: quality.colorMaturity,
            displayValue: '${(quality.colorMaturity * 100).toInt()}% (Optimal)',
            color: FasalColors.success,
          ),
          const SizedBox(height: 10),
          _buildFactorRow(
            label: l10n.get('sizing_uniformity'),
            fraction: quality.sizingUniformity,
            displayValue: '${(quality.sizingUniformity * 100).toInt()}% (Uniform 55–65mm)',
            color: FasalColors.primaryGreen,
          ),
          const SizedBox(height: 10),
          _buildFactorRow(
            label: l10n.get('blemish_rate'),
            fraction: quality.blemishRate,
            displayValue: '${(quality.blemishRate * 100).toInt()}% (Clean Spec)',
            color: FasalColors.harvestAmber,
            isInverse: true,
          ),
          const SizedBox(height: 10),
          _buildFactorRow(
            label: l10n.get('firmness_index'),
            fraction: quality.firmnessIndex,
            displayValue: '${(quality.firmnessIndex * 100).toInt()}% (Firm & Resilient)',
            color: FasalColors.coldBlue,
          ),
          const SizedBox(height: 16),

          // Operator Grade Selection Controls
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: FasalColors.surfaceMuted,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: FasalColors.borderSubtle),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Operator Grade Override:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: FasalColors.textSecondary,
                  ),
                ),
                Row(
                  children: ['A+', 'A', 'B'].map((g) {
                    final isSel = quality.grade == g;
                    return Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: InkWell(
                        onTap: () => onGradeChanged?.call(g),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSel ? FasalColors.primaryGreen : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSel ? FasalColors.primaryGreen : FasalColors.borderStrong,
                            ),
                          ),
                          child: Text(
                            g,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isSel ? Colors.white : FasalColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactorRow({
    required String label,
    required double fraction,
    required String displayValue,
    required Color color,
    bool isInverse = false,
  }) {
    final barValue = isInverse ? (1.0 - fraction).clamp(0.0, 1.0) : fraction.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: FasalColors.textSecondary,
              ),
            ),
            Text(
              displayValue,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: FasalColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: barValue,
            minHeight: 6,
            backgroundColor: FasalColors.borderSubtle,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
