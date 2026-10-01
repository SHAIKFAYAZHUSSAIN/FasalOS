import 'package:flutter/material.dart';
import '../services/fasal_state.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../widgets/sync_status.dart';
import 'hub_dashboard_view.dart';
import 'cold_room_solar_view.dart';
import 'market_matching_screen.dart';
import 'aggregation_screen.dart';
import 'buyer_store_screen.dart';
import 'settlement_screen.dart';

class MainShell extends StatefulWidget {
  final FasalState state;
  const MainShell({super.key, required this.state});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const List<_NavItem> _navItems = [
    _NavItem(Icons.grid_view_rounded, Icons.grid_view, 'Hub Overview', 'tab_hub'),
    _NavItem(Icons.solar_power_rounded, Icons.solar_power, 'Solar & Cold Chain', 'tab_solar'),
    _NavItem(Icons.trending_up_rounded, Icons.trending_up, 'Market Intelligence', 'tab_markets'),
    _NavItem(Icons.layers_rounded, Icons.layers, 'Aggregation', 'tab_aggregation'),
    _NavItem(Icons.storefront_rounded, Icons.storefront, 'Buyer & Logistics', 'tab_buyer'),
    _NavItem(Icons.account_balance_rounded, Icons.account_balance, 'Settlement', 'tab_settlement'),
  ];

  void _onNavigateTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = widget.state;
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 700;
    final isTablet = w >= 700 && w < 1100;
    final _ = w >= 1100; // desktop breakpoint available to child widgets via LayoutBuilder

    if (isMobile) return _MobileShell(state: state, currentIndex: _currentIndex, onNavigateTab: _onNavigateTab, navItems: _navItems);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2EE),
      body: Row(
        children: [
          // ── Sidebar ───────────────────────────────────────────────
          _Sidebar(
            currentIndex: _currentIndex,
            onNavigateTab: _onNavigateTab,
            navItems: _navItems,
            state: state,
            collapsed: isTablet,
            l10n: l10n,
          ),
          // ── Main Content ──────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                _TopBar(state: state, currentIndex: _currentIndex, navItems: _navItems, l10n: l10n),
                // Offline banner
                SyncStatusWidget(
                  state: state,
                  onToggleOffline: state.toggleOfflineMode,
                  onSync: state.triggerSync,
                ),
                Expanded(
                  child: _buildScreen(_currentIndex, state),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreen(int index, FasalState state) {
    switch (index) {
      case 0:  return HubDashboardView(state: state, onNavigateTab: _onNavigateTab);
      case 1:  return ColdRoomSolarView(state: state);
      case 2:  return MarketMatchingScreen(state: state, onNavigateTab: _onNavigateTab);
      case 3:  return AggregationScreen(state: state, onNavigateTab: _onNavigateTab);
      case 4:  return BuyerStoreScreen(state: state, onNavigateTab: _onNavigateTab);
      default: return SettlementScreen(state: state);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sidebar
// ─────────────────────────────────────────────────────────────────────────────
class _Sidebar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onNavigateTab;
  final List<_NavItem> navItems;
  final FasalState state;
  final bool collapsed;
  final AppLocalizations l10n;

  const _Sidebar({
    required this.currentIndex,
    required this.onNavigateTab,
    required this.navItems,
    required this.state,
    required this.collapsed,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final localizationProvider = LocalizationProvider.of(context);
    final sidebarWidth = collapsed ? 72.0 : 240.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: sidebarWidth,
      decoration: const BoxDecoration(
        color: Color(0xFF12251A),
        border: Border(right: BorderSide(color: Color(0xFF1E3828), width: 1)),
      ),
      child: Column(
        children: [
          // Logo
          Container(
            height: 64,
            padding: EdgeInsets.symmetric(horizontal: collapsed ? 16 : 20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF1E3828))),
            ),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.agriculture, color: Colors.white, size: 20),
                ),
                if (!collapsed) ...[
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('FasalOS',
                          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                        Text('Agricultural OS',
                          style: TextStyle(color: Color(0xFF6B8F72), fontSize: 11, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Nav Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                if (!collapsed)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                    child: Text('OPERATIONS',
                      style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                  ),
                ...List.generate(navItems.length, (i) {
                  final item = navItems[i];
                  final isSelected = currentIndex == i;
                  return _SidebarItem(
                    icon: isSelected ? item.selectedIcon : item.outlinedIcon,
                    label: item.label,
                    isSelected: isSelected,
                    collapsed: collapsed,
                    onTap: () => onNavigateTab(i),
                  );
                }),
              ],
            ),
          ),

          // Bottom: Language + Status
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF1E3828))),
            ),
            padding: EdgeInsets.all(collapsed ? 8 : 16),
            child: Column(
              children: [
                if (!collapsed) ...[
                  // Solar status pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A3022),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(width: 8, height: 8,
                          decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text('Solar ${state.solar.solarContributionPct}% Active',
                          style: const TextStyle(color: Color(0xFF81C784), fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Language
                  _LanguageSelector(l10n: l10n, localizationProvider: localizationProvider),
                ] else ...[
                  // Collapsed: just solar dot
                  Container(width: 8, height: 8,
                    decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool collapsed;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon, required this.label,
    required this.isSelected, required this.collapsed, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: collapsed ? label : '',
      preferBelow: false,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          padding: EdgeInsets.symmetric(horizontal: collapsed ? 16 : 14, vertical: 11),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2E7D32).withOpacity(0.25) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isSelected ? Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)) : null,
          ),
          child: Row(
            mainAxisAlignment: collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(icon, size: 20,
                color: isSelected ? const Color(0xFF81C784) : const Color(0xFF6B8F72)),
              if (!collapsed) ...[
                const SizedBox(width: 12),
                Text(label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF8AA890),
                    fontSize: 13.5, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  )),
              ],
              if (!collapsed && isSelected) ...[
                const Spacer(),
                Container(width: 6, height: 6,
                  decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final AppLocalizations l10n;
  final LocalizationProviderState? localizationProvider;
  const _LanguageSelector({required this.l10n, required this.localizationProvider});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AppLanguage>(
      tooltip: 'Language',
      offset: const Offset(0, -220),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A3022),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.translate, size: 14, color: Color(0xFF6B8F72)),
            const SizedBox(width: 8),
            Text(localizationProvider?.currentLanguage.displayName ?? 'English',
              style: const TextStyle(color: Color(0xFF8AA890), fontSize: 12)),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_up, size: 14, color: Color(0xFF6B8F72)),
          ],
        ),
      ),
      onSelected: (lang) => localizationProvider?.setLanguage(lang),
      itemBuilder: (_) => AppLanguage.values.map((lang) {
        final isCur = localizationProvider?.currentLanguage == lang;
        return PopupMenuItem<AppLanguage>(
          value: lang,
          child: Row(children: [
            if (isCur) const Icon(Icons.check, size: 14, color: Color(0xFF4CAF50))
            else const SizedBox(width: 14),
            const SizedBox(width: 8),
            Text(lang.displayName, style: TextStyle(fontWeight: isCur ? FontWeight.bold : FontWeight.normal)),
          ]),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Top Bar
// ─────────────────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final FasalState state;
  final int currentIndex;
  final List<_NavItem> navItems;
  final AppLocalizations l10n;

  const _TopBar({required this.state, required this.currentIndex, required this.navItems, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final item = navItems[currentIndex];
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE8ECE4))),
      ),
      child: Row(
        children: [
          // Page title
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.label,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF12251A), letterSpacing: -0.4)),
              Text('Kurnool FPO Hub · ${DateTime.now().day} Oct 2026',
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B8F72), fontWeight: FontWeight.w500)),
            ],
          ),
          const Spacer(),

          // Hub status badges
          _StatusBadge(
            icon: Icons.ac_unit,
            label: '${state.solar.chamberTempC}°C',
            color: const Color(0xFF0284C7),
            bg: const Color(0xFFE0F2FE),
          ),
          const SizedBox(width: 8),
          _StatusBadge(
            icon: Icons.solar_power,
            label: '${state.solar.solarContributionPct}% solar',
            color: const Color(0xFFD97706),
            bg: const Color(0xFFFEF3C7),
          ),
          const SizedBox(width: 8),
          _StatusBadge(
            icon: Icons.inventory_2,
            label: '${state.totalStoredProduceKg.toInt()} kg',
            color: const Color(0xFF2E7D32),
            bg: const Color(0xFFE8F5E9),
          ),
          const SizedBox(width: 16),

          // Action buttons
          IconButton(
            tooltip: state.isOffline ? 'Switch Online' : 'Simulate Offline',
            onPressed: state.toggleOfflineMode,
            icon: Icon(state.isOffline ? Icons.wifi_off : Icons.wifi,
              color: state.isOffline ? const Color(0xFFD97706) : const Color(0xFF2E7D32), size: 20),
          ),
          IconButton(
            tooltip: 'Reset Demo',
            onPressed: () {
              state.resetToDemo();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('FasalOS reset to deterministic demo state.'), duration: Duration(seconds: 2)));
            },
            icon: const Icon(Icons.restart_alt, size: 20, color: Color(0xFF6B8F72)),
          ),

          // Avatar
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF2E7D32),
            child: const Text('FO', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
  const _StatusBadge({required this.icon, required this.label, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mobile Shell (unchanged interaction-first mobile layout)
// ─────────────────────────────────────────────────────────────────────────────
class _MobileShell extends StatelessWidget {
  final FasalState state;
  final int currentIndex;
  final ValueChanged<int> onNavigateTab;
  final List<_NavItem> navItems;

  const _MobileShell({required this.state, required this.currentIndex, required this.onNavigateTab, required this.navItems});

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:  return HubDashboardView(state: state, onNavigateTab: onNavigateTab);
      case 1:  return ColdRoomSolarView(state: state);
      case 2:  return MarketMatchingScreen(state: state, onNavigateTab: onNavigateTab);
      case 3:  return AggregationScreen(state: state, onNavigateTab: onNavigateTab);
      case 4:  return BuyerStoreScreen(state: state, onNavigateTab: onNavigateTab);
      default: return SettlementScreen(state: state);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizationProvider = LocalizationProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Container(padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: FasalColors.primaryGreen, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.agriculture, color: Colors.white, size: 18)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            const Text('FasalOS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: FasalColors.primaryGreenDark)),
            Text(navItems[currentIndex].label, style: const TextStyle(fontSize: 11, color: FasalColors.textSecondary), overflow: TextOverflow.ellipsis),
          ])),
        ]),
        actions: [
          PopupMenuButton<AppLanguage>(
            tooltip: 'Language',
            icon: const Icon(Icons.translate, size: 20),
            onSelected: (lang) => localizationProvider?.setLanguage(lang),
            itemBuilder: (_) => AppLanguage.values.map((lang) {
              final isCur = localizationProvider?.currentLanguage == lang;
              return PopupMenuItem<AppLanguage>(value: lang, child: Row(children: [
                if (isCur) const Icon(Icons.check, size: 16, color: FasalColors.primaryGreen)
                else const SizedBox(width: 16),
                const SizedBox(width: 8),
                Text(lang.displayName),
              ]));
            }).toList(),
          ),
        ],
      ),
      body: Column(children: [
        SyncStatusWidget(state: state, onToggleOffline: state.toggleOfflineMode, onSync: state.triggerSync),
        Expanded(child: _buildScreen(currentIndex)),
      ]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onNavigateTab,
        backgroundColor: Colors.white,
        indicatorColor: FasalColors.primaryGreenSubtle,
        destinations: navItems.asMap().entries.map((e) => NavigationDestination(
          icon: Icon(e.value.outlinedIcon),
          selectedIcon: Icon(e.value.selectedIcon, color: FasalColors.primaryGreen),
          label: e.value.label.split(' ').first,
        )).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Nav Item data
// ─────────────────────────────────────────────────────────────────────────────
class _NavItem {
  final IconData outlinedIcon;
  final IconData selectedIcon;
  final String label;
  final String l10nKey;
  const _NavItem(this.outlinedIcon, this.selectedIcon, this.label, this.l10nKey);
}
