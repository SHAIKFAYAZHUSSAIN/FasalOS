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

  // Screen size preview mode (null = native responsive)
  Size? _simulatedScreenSize;

  final Map<String, Size?> _previewSizes = {
    'Responsive (Auto)': null,
    '320 × 568 (Compact)': const Size(320, 568),
    '360 × 800 (Standard)': const Size(360, 800),
    '375 × 812 (iPhone X)': const Size(375, 812),
    '390 × 844 (Target)': const Size(390, 844),
    '412 × 915 (Android XL)': const Size(412, 915),
    '430 × 932 (Max)': const Size(430, 932),
  };

  void _onNavigateTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = widget.state;
    final localizationProvider = LocalizationProvider.of(context);

    // If simulated size is active, wrap in a centered container with phone border
    if (_simulatedScreenSize != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF2B3A2C),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Screen size switcher banner
              _buildTopPreviewBar(l10n, localizationProvider),
              const SizedBox(height: 8),
              Container(
                width: _simulatedScreenSize!.width,
                height: _simulatedScreenSize!.height - 50,
                decoration: BoxDecoration(
                  color: FasalColors.background,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(color: Colors.black45, blurRadius: 16, offset: Offset(0, 8)),
                  ],
                  border: Border.all(color: Colors.black87, width: 4),
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildScaffoldContent(context, state, l10n, localizationProvider, isSimulated: true),
              ),
            ],
          ),
        ),
      );
    }

    return _buildScaffoldContent(context, state, l10n, localizationProvider, isSimulated: false);
  }

  Widget _buildTopPreviewBar(AppLocalizations l10n, LocalizationProviderState? localizationProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.devices, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: _previewSizes.entries
                .firstWhere(
                  (e) => e.value == _simulatedScreenSize,
                  orElse: () => _previewSizes.entries.first,
                )
                .key,
            dropdownColor: const Color(0xFF1B241C),
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            underline: const SizedBox.shrink(),
            items: _previewSizes.keys.map((name) {
              return DropdownMenuItem<String>(
                value: name,
                child: Text(name),
              );
            }).toList(),
            onChanged: (selectedName) {
              setState(() {
                _simulatedScreenSize = _previewSizes[selectedName];
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScaffoldContent(
    BuildContext context,
    FasalState state,
    AppLocalizations l10n,
    LocalizationProviderState? localizationProvider, {
    required bool isSimulated,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900 && !isSimulated;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: FasalColors.primaryGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.agriculture, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'FasalOS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: FasalColors.primaryGreenDark,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        _getTabTitle(_currentIndex, l10n),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
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
            actions: [
              // Language Selector Menu
              PopupMenuButton<AppLanguage>(
                tooltip: 'Select Language (భాష / भाषा)',
                icon: const Icon(Icons.translate, size: 20),
                onSelected: (lang) {
                  localizationProvider?.setLanguage(lang);
                },
                itemBuilder: (context) {
                  return AppLanguage.values.map((lang) {
                    final isCurrent = localizationProvider?.currentLanguage == lang;
                    return PopupMenuItem<AppLanguage>(
                      value: lang,
                      child: Row(
                        children: [
                          if (isCurrent)
                            const Icon(Icons.check, size: 16, color: FasalColors.primaryGreen)
                          else
                            const SizedBox(width: 16),
                          const SizedBox(width: 8),
                          Text(
                            lang.displayName,
                            style: TextStyle(
                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                              color: isCurrent ? FasalColors.primaryGreen : FasalColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList();
                },
              ),

              // Device Screen Size Simulator (for easy responsive verification)
              if (!isSimulated)
                PopupMenuButton<String>(
                  tooltip: 'Preview Mobile Sizes',
                  icon: const Icon(Icons.smartphone, size: 20),
                  onSelected: (name) {
                    setState(() {
                      _simulatedScreenSize = _previewSizes[name];
                    });
                  },
                  itemBuilder: (context) {
                    return _previewSizes.keys.map((name) {
                      return PopupMenuItem<String>(
                        value: name,
                        child: Text(name),
                      );
                    }).toList();
                  },
                ),

              // Demo Reset & Options Menu
              PopupMenuButton<String>(
                tooltip: 'FasalOS OS Options',
                icon: const Icon(Icons.more_vert, size: 20),
                onSelected: (val) {
                  if (val == 'reset') {
                    state.resetToDemo();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('FasalOS reset to initial deterministic demo state.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else if (val == 'offline') {
                    state.toggleOfflineMode();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'reset',
                    child: Row(
                      children: const [
                        Icon(Icons.restart_alt, size: 18, color: FasalColors.textSecondary),
                        SizedBox(width: 8),
                        Text('Reset Deterministic Demo'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'offline',
                    child: Row(
                      children: [
                        Icon(
                          state.isOffline ? Icons.wifi : Icons.wifi_off,
                          size: 18,
                          color: state.isOffline ? FasalColors.success : FasalColors.warning,
                        ),
                        const SizedBox(width: 8),
                        Text(state.isOffline ? 'Switch Online' : 'Simulate Offline Mode'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              // Offline & Sync Status Banner
              SyncStatusWidget(
                state: state,
                onToggleOffline: state.toggleOfflineMode,
                onSync: state.triggerSync,
              ),

              // Responsive Body Layout
              Expanded(
                child: isDesktop
                    ? Row(
                        children: [
                          NavigationRail(
                            selectedIndex: _currentIndex,
                            onDestinationSelected: _onNavigateTab,
                            labelType: NavigationRailLabelType.all,
                            selectedIconTheme: const IconThemeData(color: FasalColors.primaryGreen),
                            selectedLabelTextStyle: const TextStyle(
                              color: FasalColors.primaryGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            unselectedLabelTextStyle: const TextStyle(
                              color: FasalColors.textMuted,
                              fontSize: 11,
                            ),
                            destinations: [
                              NavigationRailDestination(
                                icon: const Icon(Icons.grid_view),
                                label: Text(l10n.get('tab_hub')),
                              ),
                              NavigationRailDestination(
                                icon: const Icon(Icons.solar_power),
                                label: Text(l10n.get('tab_solar')),
                              ),
                              NavigationRailDestination(
                                icon: const Icon(Icons.trending_up),
                                label: Text(l10n.get('tab_markets')),
                              ),
                              NavigationRailDestination(
                                icon: const Icon(Icons.merge_type),
                                label: Text(l10n.get('tab_aggregation')),
                              ),
                              NavigationRailDestination(
                                icon: const Icon(Icons.storefront),
                                label: Text(l10n.get('tab_buyer')),
                              ),
                              NavigationRailDestination(
                                icon: const Icon(Icons.account_balance),
                                label: Text(l10n.get('tab_settlement')),
                              ),
                            ],
                          ),
                          const VerticalDivider(width: 1),
                          Expanded(
                            child: _buildTabScreen(_currentIndex, state),
                          ),
                        ],
                      )
                    : _buildTabScreen(_currentIndex, state),
              ),
            ],
          ),
          // Mobile Bottom Navigation Bar with 48x48 logical pixels touch targets
          bottomNavigationBar: isDesktop
              ? null
              : Container(
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: FasalColors.borderSubtle)),
                  ),
                  child: NavigationBar(
                    selectedIndex: _currentIndex,
                    onDestinationSelected: _onNavigateTab,
                    backgroundColor: Colors.white,
                    indicatorColor: FasalColors.primaryGreenSubtle,
                    destinations: [
                      NavigationDestination(
                        icon: const Icon(Icons.grid_view_outlined),
                        selectedIcon: const Icon(Icons.grid_view, color: FasalColors.primaryGreen),
                        label: l10n.get('tab_hub'),
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.solar_power_outlined),
                        selectedIcon: const Icon(Icons.solar_power, color: FasalColors.primaryGreen),
                        label: l10n.get('tab_solar'),
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.trending_up_outlined),
                        selectedIcon: const Icon(Icons.trending_up, color: FasalColors.primaryGreen),
                        label: l10n.get('tab_markets'),
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.merge_type_outlined),
                        selectedIcon: const Icon(Icons.merge_type, color: FasalColors.primaryGreen),
                        label: l10n.get('tab_aggregation'),
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.storefront_outlined),
                        selectedIcon: const Icon(Icons.storefront, color: FasalColors.primaryGreen),
                        label: l10n.get('tab_buyer'),
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.account_balance_outlined),
                        selectedIcon: const Icon(Icons.account_balance, color: FasalColors.primaryGreen),
                        label: l10n.get('tab_settlement'),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildTabScreen(int index, FasalState state) {
    switch (index) {
      case 0:
        return HubDashboardView(state: state, onNavigateTab: _onNavigateTab);
      case 1:
        return ColdRoomSolarView(state: state);
      case 2:
        return MarketMatchingScreen(state: state, onNavigateTab: _onNavigateTab);
      case 3:
        return AggregationScreen(state: state, onNavigateTab: _onNavigateTab);
      case 4:
        return BuyerStoreScreen(state: state, onNavigateTab: _onNavigateTab);
      case 5:
      default:
        return SettlementScreen(state: state);
    }
  }

  String _getTabTitle(int index, AppLocalizations l10n) {
    switch (index) {
      case 0:
        return l10n.get('tab_hub');
      case 1:
        return l10n.get('tab_solar');
      case 2:
        return l10n.get('tab_markets');
      case 3:
        return l10n.get('tab_aggregation');
      case 4:
        return l10n.get('tab_buyer');
      case 5:
      default:
        return l10n.get('tab_settlement');
    }
  }
}
