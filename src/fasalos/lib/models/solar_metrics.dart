import 'package:flutter/foundation.dart';

enum SolarFlowStage {
  sun,
  solarPanels,
  energyInverter,
  refrigerationChamber,
  freshProduce;

  String get label {
    switch (this) {
      case SolarFlowStage.sun:
        return 'Solar Irradiance';
      case SolarFlowStage.solarPanels:
        return 'Photovoltaic Array';
      case SolarFlowStage.energyInverter:
        return 'Smart Microgrid & Battery';
      case SolarFlowStage.refrigerationChamber:
        return 'Thermal Cold Chamber';
      case SolarFlowStage.freshProduce:
        return 'Preserved Produce Quality';
    }
  }

  String get shortLabel {
    switch (this) {
      case SolarFlowStage.sun:
        return 'SUN';
      case SolarFlowStage.solarPanels:
        return 'SOLAR';
      case SolarFlowStage.energyInverter:
        return 'ENERGY';
      case SolarFlowStage.refrigerationChamber:
        return 'REFRIGERATION';
      case SolarFlowStage.freshProduce:
        return 'FRESH PRODUCE';
    }
  }
}

@immutable
class SolarTelemetry {
  final double generatedKwh; // 62 kWh
  final double consumedKwh; // 84 kWh
  final int solarContributionPct; // 74%
  final double coldChainConsumptionKwh; // 56 kWh
  final String batteryReserveFormatted; // "6h 20m"
  final double currentSolarKw; // e.g. 8.4 kW instantaneous
  final double coldRoomKw; // e.g. 4.2 kW compressor load
  final double batterySocPct; // e.g. 86% state of charge
  final bool isSimulated;

  const SolarTelemetry({
    required this.generatedKwh,
    required this.consumedKwh,
    required this.solarContributionPct,
    required this.coldChainConsumptionKwh,
    required this.batteryReserveFormatted,
    required this.currentSolarKw,
    required this.coldRoomKw,
    required this.batterySocPct,
    this.isSimulated = true,
  });
}
