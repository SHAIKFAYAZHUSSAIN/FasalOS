import 'package:flutter/material.dart';
import '../services/fasal_state.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../models/produce_lot.dart';
import '../widgets/photo_produce_card.dart';
import 'intake_flow_sheet.dart';
import 'lot_detail_sheet.dart';

class HubDashboardView extends StatefulWidget {
  final FasalState state;
  final ValueChanged<int>? onNavigateTab;
  const HubDashboardView({super.key, required this.state, this.onNavigateTab});

  @override
  State<HubDashboardView> createState() => _HubDashboardViewState();
}

class _HubDashboardViewState extends State<HubDashboardView> {
  String _filter = 'All';
  ProduceLot? _selectedLot;

  void _openIntake() {
    final w = MediaQuery.of(context).size.width;
    if (w >= 700) {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SizedBox(
            width: 560,
            height: MediaQuery.of(context).size.height * 0.85,
            child: IntakeFlowSheet(state: widget.state, onCompleted: () => setState(() {})),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
        builder: (_) => IntakeFlowSheet(state: widget.state, onCompleted: () => setState(() {})),
      );
    }
  }

  void _openDetail(ProduceLot lot) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1100) {
      setState(() => _selectedLot = lot);
    } else {
      showModalBottomSheet(
        context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
        builder: (_) => LotDetailSheet(lot: lot, state: widget.state,
          onAggregateTapped: () => widget.onNavigateTab?.call(3),
          onMarketTapped: () => widget.onNavigateTab?.call(2)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final lots = state.lots;
    final filtered = _filter == 'All' ? lots
        : lots.where((l) => l.cropType.toLowerCase().contains(_filter.toLowerCase())).toList();
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1100;

    return Row(
      children: [
        Expanded(
          child: _buildMain(state, lots, filtered, isDesktop),
        ),
        // Desktop detail panel
        if (isDesktop && _selectedLot != null)
          Container(
            width: 380,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(left: BorderSide(color: Color(0xFFE8ECE4))),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE8ECE4)))),
                  child: Row(
                    children: [
                      Expanded(child: Text(_selectedLot!.id,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF12251A)))),
                      IconButton(icon: const Icon(Icons.close, size: 18, color: Color(0xFF6B8F72)),
                        onPressed: () => setState(() => _selectedLot = null)),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: LotDetailSheet(
                      lot: _selectedLot!,
                      state: state,
                      inlineMode: true,
                      onAggregateTapped: () => widget.onNavigateTab?.call(3),
                      onMarketTapped: () => widget.onNavigateTab?.call(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMain(FasalState state, lots, filtered, bool isDesktop) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 28 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── KPI Row ──────────────────────────────────────────────────
          _KpiRow(state: state, onNavigateTab: widget.onNavigateTab),
          SizedBox(height: isDesktop ? 28 : 16),

          // ── Pipeline Banner ──────────────────────────────────────────
          _PipelineBanner(state: state),
          SizedBox(height: isDesktop ? 28 : 16),

          // ── Lots section ─────────────────────────────────────────────
          // Title + Add button row
          Row(children: [
            Text('Active Farm Lots',
              style: TextStyle(fontSize: isDesktop ? 18 : 15,
                fontWeight: FontWeight.w800, color: const Color(0xFF12251A))),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
              child: Text('${filtered.length}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF2E7D32))),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: _openIntake,
              icon: const Icon(Icons.add, size: 18),
              label: Text(isDesktop ? 'Add Produce' : 'Add',
                style: const TextStyle(fontWeight: FontWeight.w700)),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 18 : 12, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          // Filter chips — horizontal scroll on mobile
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: ['All', 'Tomatoes', 'Onions', 'Chillies'].map((c) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _FilterChip(label: c, selected: _filter == c, onTap: () => setState(() => _filter = c)),
              )).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // ── Lot Grid ─────────────────────────────────────────────────
          LayoutBuilder(builder: (ctx, box) {
            final cols = box.maxWidth > 1100 ? 4 : box.maxWidth > 700 ? 3 : box.maxWidth > 400 ? 2 : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols, crossAxisSpacing: 14, mainAxisSpacing: 14,
                mainAxisExtent: 300,
              ),
              itemCount: filtered.length,
              itemBuilder: (_, i) => PhotoProduceCard(
                lot: filtered[i],
                isSelected: _selectedLot?.id == filtered[i].id,
                onTap: () => _openDetail(filtered[i]),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _KpiRow extends StatelessWidget {
  final FasalState state;
  final ValueChanged<int>? onNavigateTab;
  const _KpiRow({required this.state, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final kpis = [
      _KpiData('Stored Harvest', '${state.totalStoredProduceKg.toInt()} kg',
        '${state.lots.length} lots active', Icons.inventory_2_rounded,
        const Color(0xFF2E7D32), const Color(0xFFE8F5E9), null),
      _KpiData('Solar Power', '${state.solar.solarContributionPct}%',
        'Clean energy offset', Icons.solar_power_rounded,
        const Color(0xFFD97706), const Color(0xFFFEF3C7), 1),
      _KpiData('Chamber Temp', '${state.solar.chamberTempC}°C',
        'Stable cold chain', Icons.ac_unit_rounded,
        const Color(0xFF0284C7), const Color(0xFFE0F2FE), 1),
      _KpiData('Farmer Earnings', '₹${state.totalFarmerEarnings.toInt()}',
        'DBT settled direct', Icons.account_balance_rounded,
        const Color(0xFF7B3F00), const Color(0xFFFFF3E0), 5),
    ];

    return LayoutBuilder(builder: (_, box) {
      final cols = box.maxWidth > 600 ? 4 : 2;
      return GridView.count(
        crossAxisCount: cols, shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 14, mainAxisSpacing: 14,
        mainAxisExtent: 180,
        children: kpis.map((k) => _KpiCard(data: k, onNavigateTab: onNavigateTab)).toList(),
      );
    });
  }
}

class _KpiData {
  final String title, value, sub;
  final IconData icon;
  final Color color, bg;
  final int? navTarget;
  const _KpiData(this.title, this.value, this.sub, this.icon, this.color, this.bg, this.navTarget);
}

class _KpiCard extends StatelessWidget {
  final _KpiData data;
  final ValueChanged<int>? onNavigateTab;
  const _KpiCard({required this.data, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.navTarget != null ? () => onNavigateTab?.call(data.navTarget!) : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8ECE4)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: data.bg, borderRadius: BorderRadius.circular(8)),
                child: Icon(data.icon, size: 18, color: data.color)),
              const Spacer(),
              if (data.navTarget != null)
                Icon(Icons.arrow_forward_ios, size: 12, color: data.color.withOpacity(0.5)),
            ]),
            const Spacer(),
            Text(data.value, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFF12251A), letterSpacing: -0.5)),
            const SizedBox(height: 3),
            Text(data.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF4A5A4D))),
            Text(data.sub, style: const TextStyle(fontSize: 11, color: Color(0xFF8AA890))),
          ],
        ),
      ),
    );
  }
}

class _PipelineBanner extends StatelessWidget {
  final FasalState state;
  const _PipelineBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    // Short labels that won't word-wrap on mobile
    final stages = [
      ('In', state.lots.where((l) => l.stage == LotStage.received).length, const Color(0xFF6B8F72)),
      ('Graded', state.lots.where((l) => l.stage == LotStage.graded).length, const Color(0xFFD97706)),
      ('Stored', state.lots.where((l) => l.stage == LotStage.stored).length, const Color(0xFF0284C7)),
      ('Matched', state.lots.where((l) => l.stage == LotStage.matched).length, const Color(0xFF7B3F00)),
      ('Transit', state.lots.where((l) => l.stage == LotStage.dispatched).length, const Color(0xFF2E7D32)),
      ('Done', state.lots.where((l) => l.stage == LotStage.delivered).length, const Color(0xFF1B4D24)),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECE4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Supply Chain Pipeline',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF4A5A4D))),
          const SizedBox(height: 10),
          Row(
            children: stages.asMap().entries.map((e) {
              final i = e.key;
              final s = e.value;
              return Expanded(
                child: Row(children: [
                  Expanded(
                    child: Column(children: [
                      Text('${s.$2}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: s.$3)),
                      const SizedBox(height: 2),
                      Text(s.$1,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B8F72)),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                      ),
                    ]),
                  ),
                  if (i < stages.length - 1)
                    const Icon(Icons.chevron_right, size: 12, color: Color(0xFFBDC7B9)),
                ]),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2E7D32) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? const Color(0xFF2E7D32) : const Color(0xFFDDE3D9)),
        ),
        child: Text(label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF4A5A4D))),
      ),
    );
  }
}
