import 'package:flutter/material.dart';
import '../services/fasal_state.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../widgets/solar_flow.dart';

class ColdRoomSolarView extends StatelessWidget {
  final FasalState state;
  const ColdRoomSolarView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final solar = state.solar;
    final isDesktop = MediaQuery.of(context).size.width >= 1100;
    final pad = isDesktop ? 28.0 : 16.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(pad),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero banner
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(children: [
              Image.asset('assets/images/solar_cold_hub.jpg',
                height: isDesktop ? 240 : 180, width: double.infinity, fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(height: isDesktop ? 240 : 180,
                  color: FasalColors.surfaceMuted, child: const Icon(Icons.solar_power, size: 64))),
              Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent])))),
              Positioned(bottom: 24, left: 24, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: FasalColors.harvestAmber, borderRadius: BorderRadius.circular(4)),
                  child: Text(l10n.get('demo_data_badge'),
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800))),
                const SizedBox(height: 6),
                const Text('Kurnool Agro-Solar Cold Hub',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.3)),
                const Text('16 kWp PV Array  •  30 kWh PCM Thermal Storage  •  Andhra Pradesh',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              ])),
              // Live status overlay
              Positioned(top: 20, right: 20, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  const Text('LIVE TELEMETRY', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                ]),
              )),
            ]),
          ),
          SizedBox(height: isDesktop ? 24 : 16),

          // Desktop: two-column layout
          if (isDesktop)
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 3, child: SolarFlow(telemetry: solar)),
              const SizedBox(width: 20),
              Expanded(flex: 2, child: _ChamberPanel(solar: solar)),
            ])
          else ...[
            SolarFlow(telemetry: solar),
            const SizedBox(height: 16),
            _ChamberPanel(solar: solar),
          ],
        ],
      ),
    );
  }
}

class _ChamberPanel extends StatelessWidget {
  final dynamic solar;
  const _ChamberPanel({required this.solar});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.compress, 'Compressor', 'Inverter 62%'),
      (Icons.door_front_door, 'Air-Lock', 'Sealed (0 excursions)'),
      (Icons.air, 'Ethylene', '< 0.05 ppm Active'),
      (Icons.battery_charging_full, 'Off-grid Reserve', solar.batteryReserveFormatted),
      (Icons.thermostat, 'Chamber Temp', '${solar.chamberTempC}°C Stable'),
      (Icons.water_drop, 'Humidity', '${solar.humidity}% RH'),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECE4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.sensor_door, size: 18, color: Color(0xFF0284C7))),
            const SizedBox(width: 10),
            const Expanded(child: Text('Chamber Diagnostics',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF12251A)))),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
              child: const Text('OPTIMAL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF2E7D32)))),
          ]),
          const SizedBox(height: 16),
          ...items.map((it) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFFF0F2EE), borderRadius: BorderRadius.circular(6)),
                child: Icon(it.$1, size: 14, color: const Color(0xFF6B8F72))),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(it.$2, style: const TextStyle(fontSize: 11, color: Color(0xFF8AA890), fontWeight: FontWeight.w500)),
                Text(it.$3, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF12251A))),
              ])),
            ]),
          )),
        ],
      ),
    );
  }
}
