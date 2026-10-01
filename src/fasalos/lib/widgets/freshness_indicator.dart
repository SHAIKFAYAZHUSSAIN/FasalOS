import 'package:flutter/material.dart';
import '../models/produce_lot.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class FreshnessIndicator extends StatefulWidget {
  final FreshnessMetrics freshness;
  final String cropType;

  const FreshnessIndicator({
    super.key,
    required this.freshness,
    required this.cropType,
  });

  @override
  State<FreshnessIndicator> createState() => _FreshnessIndicatorState();
}

class _FreshnessIndicatorState extends State<FreshnessIndicator> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final f = widget.freshness;

    Color scoreColor;
    if (f.freshnessScore >= 90) {
      scoreColor = FasalColors.success;
    } else if (f.freshnessScore >= 75) {
      scoreColor = FasalColors.harvestAmber;
    } else {
      scoreColor = FasalColors.error;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: FasalColors.coldBlueLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.ac_unit, size: 20, color: FasalColors.coldBlue),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.get('freshness_title'),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: FasalColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${widget.cropType} • ${f.cropCondition}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: FasalColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Freshness Score Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: scoreColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: scoreColor, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, size: 16, color: scoreColor),
                      const SizedBox(width: 4),
                      Text(
                        '${f.freshnessScore}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: scoreColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Sensor Readings Grid (4 Key Telemetry Metrics)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: FasalColors.surfaceMuted,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: FasalColors.borderSubtle),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildSensorMetric(
                          icon: Icons.thermostat,
                          label: l10n.get('temperature'),
                          value: '${f.chamberTemperature.toStringAsFixed(1)}°C',
                          subtext: 'Cold room target: 11.5–12.5°C',
                          color: FasalColors.coldBlue,
                        ),
                      ),
                      Container(width: 1, height: 48, color: FasalColors.borderSubtle),
                      Expanded(
                        child: _buildSensorMetric(
                          icon: Icons.water_drop,
                          label: l10n.get('humidity'),
                          value: '${f.relativeHumidity.toStringAsFixed(0)}%',
                          subtext: 'Controlled vapor barrier',
                          color: FasalColors.coldBlue,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSensorMetric(
                          icon: Icons.timer,
                          label: l10n.get('storage_duration'),
                          value: '${f.storageDurationHours} hrs',
                          subtext: 'Since farmer bay intake',
                          color: FasalColors.soilBrown,
                        ),
                      ),
                      Container(width: 1, height: 48, color: FasalColors.borderSubtle),
                      Expanded(
                        child: _buildSensorMetric(
                          icon: Icons.event_available,
                          label: l10n.get('freshness_window'),
                          value: '${f.estimatedRemainingDays} days',
                          subtext: 'Under unbroken cold-chain',
                          color: FasalColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Expandable Scientific Explanation Button
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: Row(
                  children: [
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: 20,
                      color: FasalColors.primaryGreen,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isExpanded
                          ? 'Collapse Biological Explanation'
                          : 'Expand Biological Explanation & Storage Caveats',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: FasalColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_isExpanded) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: FasalColors.primaryGreenSubtle,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: FasalColors.primaryGreen.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.science, size: 16, color: FasalColors.primaryGreenDark),
                        SizedBox(width: 6),
                        Text(
                          'Biological Respiration Model',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: FasalColors.primaryGreenDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      f.scientificExplanation,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        color: FasalColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                          const Icon(Icons.info_outline, size: 14, color: FasalColors.harvestAmber),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              l10n.get('freshness_disclaimer'),
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
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSensorMetric({
    required IconData icon,
    required String label,
    required String value,
    required String subtext,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: FasalColors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: FasalColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          Text(
            subtext,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: FasalColors.textMuted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
