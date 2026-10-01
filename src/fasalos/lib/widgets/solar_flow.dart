import 'package:flutter/material.dart';
import '../models/solar_metrics.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class SolarFlow extends StatefulWidget {
  final SolarTelemetry telemetry;

  const SolarFlow({
    super.key,
    required this.telemetry,
  });

  @override
  State<SolarFlow> createState() => _SolarFlowState();
}

class _SolarFlowState extends State<SolarFlow> {
  SolarFlowStage _selectedStage = SolarFlowStage.solarPanels;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = widget.telemetry;
    final stages = SolarFlowStage.values;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with simulated demo telemetry badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: FasalColors.harvestAmberLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.wb_sunny, size: 20, color: FasalColors.harvestAmber),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.get('solar_title'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: FasalColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Text(
                              'Kurnool Cold Hub Rooftop Photovoltaic Array',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: FasalColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: FasalColors.harvestAmberLight,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: FasalColors.harvestAmber.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    l10n.get('demo_data_badge'),
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: FasalColors.harvestAmberDark,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Top Key Performance Numbers (62 kWh, 84 kWh, 74%, 56 kWh, 6h20m)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildStatPill(
                    title: l10n.get('solar_generated'),
                    value: '${t.generatedKwh.toInt()} kWh',
                    subtitle: 'Clean power',
                    accentColor: FasalColors.harvestAmber,
                  ),
                  const SizedBox(width: 8),
                  _buildStatPill(
                    title: l10n.get('energy_consumed'),
                    value: '${t.consumedKwh.toInt()} kWh',
                    subtitle: 'Total site load',
                    accentColor: FasalColors.soilBrown,
                  ),
                  const SizedBox(width: 8),
                  _buildStatPill(
                    title: l10n.get('solar_contribution'),
                    value: '${t.solarContributionPct}%',
                    subtitle: 'Grid offset',
                    accentColor: FasalColors.success,
                  ),
                  const SizedBox(width: 8),
                  _buildStatPill(
                    title: l10n.get('cold_consumption'),
                    value: '${t.coldChainConsumptionKwh.toInt()} kWh',
                    subtitle: 'Compressor & fans',
                    accentColor: FasalColors.coldBlue,
                  ),
                  const SizedBox(width: 8),
                  _buildStatPill(
                    title: l10n.get('battery_reserve'),
                    value: t.batteryReserveFormatted,
                    subtitle: 'Thermal buffer',
                    accentColor: FasalColors.primaryGreen,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Visual Pipeline Flow: SUN -> SOLAR -> ENERGY -> REFRIGERATION -> FRESH PRODUCE
            const Text(
              'Interactive Cold-Chain Energy Pipeline (Tap stage to inspect)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: FasalColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(stages.length, (index) {
                  final stage = stages[index];
                  final isSelected = stage == _selectedStage;

                  return Row(
                    children: [
                      Semantics(
                        button: true,
                        label: '${stage.label}. Tap to inspect energy telemetry.',
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedStage = stage;
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            constraints: const BoxConstraints(minWidth: 84, minHeight: 68),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? FasalColors.primaryGreenSubtle
                                  : FasalColors.surfaceMuted,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? FasalColors.primaryGreen
                                    : FasalColors.borderSubtle,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _getStageIcon(stage, isSelected),
                                const SizedBox(height: 6),
                                Text(
                                  stage.shortLabel,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                    color: isSelected
                                        ? FasalColors.primaryGreenDark
                                        : FasalColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (index < stages.length - 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: FasalColors.primaryGreen.withValues(alpha: 0.5),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // Stage Inspection Diagnostic Box
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildStageTelemetryBox(_selectedStage, t),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getStageIcon(SolarFlowStage stage, bool isSelected) {
    switch (stage) {
      case SolarFlowStage.sun:
        return Icon(Icons.wb_sunny, size: 20, color: isSelected ? FasalColors.harvestAmber : FasalColors.textMuted);
      case SolarFlowStage.solarPanels:
        return Icon(Icons.solar_power, size: 20, color: isSelected ? FasalColors.primaryGreen : FasalColors.textMuted);
      case SolarFlowStage.energyInverter:
        return Icon(Icons.battery_charging_full, size: 20, color: isSelected ? FasalColors.success : FasalColors.textMuted);
      case SolarFlowStage.refrigerationChamber:
        return Icon(Icons.ac_unit, size: 20, color: isSelected ? FasalColors.coldBlue : FasalColors.textMuted);
      case SolarFlowStage.freshProduce:
        return Icon(Icons.eco, size: 20, color: isSelected ? FasalColors.primaryGreen : FasalColors.textMuted);
    }
  }

  Widget _buildStatPill({
    required String title,
    required String value,
    required String subtitle,
    required Color accentColor,
  }) {
    return Container(
      constraints: const BoxConstraints(minWidth: 100),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: FasalColors.surfaceMuted,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: accentColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: FasalColors.textMuted),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: FasalColors.textPrimary),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: FasalColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildStageTelemetryBox(SolarFlowStage stage, SolarTelemetry t) {
    String title;
    String description;
    List<Map<String, String>> stats;

    switch (stage) {
      case SolarFlowStage.sun:
        title = 'Solar Irradiance & Atmospheric Condition';
        description =
            'Natural irradiance at Kurnool Hub location is currently 940 W/m² with ambient temperature at 34.5°C. Clean sky conditions offer optimal solar harvesting.';
        stats = [
          {'Label': 'Irradiance', 'Val': '940 W/m²'},
          {'Label': 'Ambient Temp', 'Val': '34.5°C'},
          {'Label': 'Peak Sun Window', 'Val': '10:30–15:30'},
        ];
        break;
      case SolarFlowStage.solarPanels:
        title = 'Photovoltaic Array Generation (16 kWp)';
        description =
            '16 kWp bi-facial polycrystalline rooftop installation generated 62 kWh today, supplying 8.4 kW instantaneous power directly to inverter bus.';
        stats = [
          {'Label': 'Instantaneous Power', 'Val': '${t.currentSolarKw} kW'},
          {'Label': 'Daily Total', 'Val': '${t.generatedKwh.toInt()} kWh'},
          {'Label': 'Inverter Efficiency', 'Val': '97.2%'},
        ];
        break;
      case SolarFlowStage.energyInverter:
        title = 'Smart Inverter & Thermal Battery Bank';
        description =
            'Lithium-Iron-Phosphate (LiFePO4) storage + phase-change thermal storage buffer provides ${t.batteryReserveFormatted} of autonomous cold storage backup during night or cloudy spells.';
        stats = [
          {'Label': 'State of Charge', 'Val': '${t.batterySocPct.toInt()}%'},
          {'Label': 'Autonomous Buffer', 'Val': t.batteryReserveFormatted},
          {'Label': 'Grid Contribution', 'Val': '${100 - t.solarContributionPct}%'},
        ];
        break;
      case SolarFlowStage.refrigerationChamber:
        title = 'Refrigeration Compressor & Cold Room Load';
        description =
            'Variable-frequency scroll compressor actively maintaining 11.8°C at 88% RH. Consumed 56 kWh of solar power today with zero thermal excursions.';
        stats = [
          {'Label': 'Current Load', 'Val': '${t.coldRoomKw} kW'},
          {'Label': 'Refrigerant', 'Val': 'R404A Eco'},
          {'Label': 'Target Delta-T', 'Val': '-22.7°C'},
        ];
        break;
      case SolarFlowStage.freshProduce:
        title = 'Preserved Produce Quality & Farm Value';
        description =
            'Solar pre-cooling prevented an estimated 18% moisture weight loss across 1,130 kg of farmer produce, preserving Grade A+ color and market value.';
        stats = [
          {'Label': 'Produce Stored', 'Val': '1,130 kg'},
          {'Label': 'Spoilage Prevented', 'Val': '~180 kg'},
          {'Label': 'Value Preserved', 'Val': '₹5,760'},
        ];
        break;
    }

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
            children: [
              _getStageIcon(stage, true),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: FasalColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              height: 1.4,
              color: FasalColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: stats.map((s) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: FasalColors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s['Label']!,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: FasalColors.textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s['Val']!,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: FasalColors.textPrimary),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
