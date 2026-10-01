import 'package:flutter/material.dart';
import '../services/fasal_state.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../widgets/metric_card.dart';
import '../widgets/photo_produce_card.dart';
import 'intake_flow_sheet.dart';
import 'lot_detail_sheet.dart';

class HubDashboardView extends StatefulWidget {
  final FasalState state;
  final ValueChanged<int>? onNavigateTab;

  const HubDashboardView({
    super.key,
    required this.state,
    this.onNavigateTab,
  });

  @override
  State<HubDashboardView> createState() => _HubDashboardViewState();
}

class _HubDashboardViewState extends State<HubDashboardView> {
  String _selectedCropFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = widget.state;
    final lots = state.lots;

    final filteredLots = _selectedCropFilter == 'All'
        ? lots
        : lots.where((l) => l.cropType.toLowerCase().contains(_selectedCropFilter.toLowerCase())).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Operational Hub Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FasalColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: FasalColors.borderSubtle),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/farmer_lakshmi.jpg',
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(Icons.hub, size: 36),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.get('hub_name'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: FasalColors.primaryGreenDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Direct Farmer Aggregation & Solar Cold-Chain Hub',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: FasalColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Primary Intake Action Button (Accessible 48x48+ touch target)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => IntakeFlowSheet(
                    state: state,
                    onCompleted: () {
                      setState(() {});
                    },
                  ),
                );
              },
              icon: const Icon(Icons.add_circle_outline, size: 22),
              label: Text(
                l10n.get('btn_add_produce'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 4 Big Operational Metric Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 500;
              final crossAxisCount = isWide ? 4 : 2;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: isWide ? 1.5 : 1.35,
                children: [
                  MetricCard(
                    title: 'Stored Harvest',
                    value: '${state.totalStoredProduceKg.toInt()}',
                    unit: 'kg',
                    subtitle: '${lots.length} farm lots active',
                    icon: Icons.inventory_2,
                    accentColor: FasalColors.primaryGreen,
                    onTap: () {},
                  ),
                  MetricCard(
                    title: 'Solar Contribution',
                    value: '${state.solar.solarContributionPct}',
                    unit: '%',
                    subtitle: 'Clean power offset',
                    icon: Icons.solar_power,
                    accentColor: FasalColors.harvestAmber,
                    onTap: () => widget.onNavigateTab?.call(1),
                  ),
                  MetricCard(
                    title: 'Cold Storage Load',
                    value: '${state.solar.coldChainConsumptionKwh.toInt()}',
                    unit: 'kWh',
                    subtitle: 'Chamber 11.8°C stable',
                    icon: Icons.ac_unit,
                    accentColor: FasalColors.coldBlue,
                    onTap: () => widget.onNavigateTab?.call(1),
                  ),
                  MetricCard(
                    title: 'Farmer Earnings',
                    value: '₹${state.totalFarmerEarnings.toInt()}',
                    subtitle: 'Direct DBT settled',
                    icon: Icons.account_balance,
                    accentColor: FasalColors.success,
                    onTap: () => widget.onNavigateTab?.call(5),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),

          // Crop Filter Chips Bar
          Text(
            'Active Inbound Farm Lots (${filteredLots.length})',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: FasalColors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: ['All', 'Tomatoes', 'Onions', 'Chillies'].map((crop) {
                final isSel = _selectedCropFilter == crop;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(crop),
                    selected: isSel,
                    onSelected: (val) {
                      setState(() {
                        _selectedCropFilter = crop;
                      });
                    },
                    selectedColor: FasalColors.primaryGreen,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                      color: isSel ? Colors.white : FasalColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Active Lots Grid/List
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 650;
              final count = isWide ? 2 : 1;

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: count,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: isWide ? 1.6 : 1.35,
                ),
                itemCount: filteredLots.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final lot = filteredLots[index];
                  return PhotoProduceCard(
                    lot: lot,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) => LotDetailSheet(
                          lot: lot,
                          state: state,
                          onAggregateTapped: () => widget.onNavigateTab?.call(3),
                          onMarketTapped: () => widget.onNavigateTab?.call(2),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
