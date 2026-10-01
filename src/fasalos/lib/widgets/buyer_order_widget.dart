import 'package:flutter/material.dart';
import '../services/fasal_state.dart';
import '../models/produce_lot.dart';
import '../models/buyer_order_model.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class BuyerOrderWidget extends StatefulWidget {
  final FasalState state;
  final ValueChanged<ProduceLot>? onInspectLot;
  final VoidCallback? onOrderPlaced;

  const BuyerOrderWidget({
    super.key,
    required this.state,
    this.onInspectLot,
    this.onOrderPlaced,
  });

  @override
  State<BuyerOrderWidget> createState() => _BuyerOrderWidgetState();
}

class _BuyerOrderWidgetState extends State<BuyerOrderWidget> {
  String _selectedCropFilter = 'All';
  double _requestedKg = 500.0;
  bool _isOrdering = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lots = widget.state.lots;
    final filteredLots = _selectedCropFilter == 'All'
        ? lots
        : lots.where((l) => l.cropType.toLowerCase().contains(_selectedCropFilter.toLowerCase())).toList();

    final activeOrders = widget.state.buyerOrders;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FasalColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: FasalColors.borderSubtle),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: FasalColors.coldBlueLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.store, size: 22, color: FasalColors.coldBlue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.get('tab_buyer'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: FasalColors.textPrimary,
                        ),
                      ),
                      const Text(
                        'Direct institutional procurement with guaranteed cold-chain integrity',
                        style: TextStyle(
                          fontSize: 11,
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

          // Active Refrigerated Deliveries Section
          if (activeOrders.isNotEmpty) ...[
            Text(
              'Active Refrigerated Dispatches',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: FasalColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            ...activeOrders.map((order) => _buildOrderTrackingCard(context, order, l10n)),
            const SizedBox(height: 20),
          ],

          // Crop Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: ['All', 'Tomatoes', 'Onions', 'Chillies'].map((filter) {
                final isSelected = _selectedCropFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter == 'All' ? 'All Farm Crops' : filter),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        _selectedCropFilter = filter;
                      });
                    },
                    selectedColor: FasalColors.primaryGreen,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : FasalColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // Available Produce Catalog
          Text(
            l10n.get('buyer_catalogue'),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: FasalColors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),

          ...filteredLots.map((lot) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        lot.photoAsset,
                        width: 76,
                        height: 76,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 76,
                          height: 76,
                          color: FasalColors.surfaceMuted,
                          child: const Icon(Icons.agriculture),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lot.cropType,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                '₹${(lot.expectedPricePerKg ?? 32).toInt()}/kg',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: FasalColors.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Farmer: ${lot.farmerName} • ${lot.farmerVillage}',
                            style: const TextStyle(fontSize: 11, color: FasalColors.textSecondary),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: FasalColors.successSubtle,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Grade ${lot.quality.grade}',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: FasalColors.success),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: FasalColors.coldBlueLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${lot.freshness.freshnessScore}% Fresh • ${lot.freshness.chamberTemperature}°C',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: FasalColors.coldBlue),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Available: ${lot.quantityKg.toInt()} kg',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: FasalColors.textMuted),
                              ),
                              TextButton(
                                onPressed: () => widget.onInspectLot?.call(lot),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  minimumSize: const Size(60, 32),
                                ),
                                child: const Text('Inspect Quality', style: TextStyle(fontSize: 11)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // Order Request Panel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FasalColors.surfaceMuted,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: FasalColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Procure High-Quality Farm Batch',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: FasalColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.get('order_quantity'),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${_requestedKg.toInt()} kg',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: FasalColors.primaryGreen),
                    ),
                  ],
                ),
                Slider(
                  value: _requestedKg,
                  min: 100,
                  max: 1000,
                  divisions: 18,
                  label: '${_requestedKg.toInt()} kg',
                  activeColor: FasalColors.primaryGreen,
                  onChanged: (val) {
                    setState(() {
                      _requestedKg = val;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Procurement Value:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    Text(
                      '₹${(_requestedKg * 32).toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: FasalColors.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _isOrdering
                        ? null
                        : () async {
                            setState(() {
                              _isOrdering = true;
                            });
                            final option = widget.state.marketOptions.first;
                            widget.state.matchBuyerAndCreateOrder(
                              marketOption: option,
                              requestedKg: _requestedKg,
                            );
                            await Future.delayed(const Duration(milliseconds: 300));
                            setState(() {
                              _isOrdering = false;
                            });
                            widget.onOrderPlaced?.call();
                          },
                    icon: _isOrdering
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.shopping_cart_checkout),
                    label: Text(l10n.get('place_order')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTrackingCard(BuildContext context, BuyerOrder order, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: FasalColors.coldBlue, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: FasalColors.coldBlueLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    order.orderId,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: FasalColors.coldBlueDark),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: order.status == BuyerOrderStatus.delivered || order.status == BuyerOrderStatus.settled
                        ? FasalColors.successSubtle
                        : FasalColors.harvestAmberLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    order.status.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: order.status == BuyerOrderStatus.delivered || order.status == BuyerOrderStatus.settled
                          ? FasalColors.success
                          : FasalColors.harvestAmberDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${order.requestedQuantityKg.toInt()} kg ${order.cropType} (${order.requiredGrade})',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            Text(
              'Buyer: ${order.buyerName} • ${order.buyerLocation}',
              style: const TextStyle(fontSize: 12, color: FasalColors.textSecondary),
            ),
            const SizedBox(height: 10),

            // Live cold transit telematics bar
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: FasalColors.surfaceMuted,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_shipping, size: 18, color: FasalColors.coldBlue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vehicle: ${order.vehicleNumber}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Reefer Temp: ${order.transportTemp}°C (Continuous Log OK)',
                          style: const TextStyle(fontSize: 11, color: FasalColors.success, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Delivery completion / settlement trigger button
            if (order.status == BuyerOrderStatus.inColdTransit) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    widget.state.deliverOrderAndCalculateSettlement(order.orderId);
                  },
                  icon: const Icon(Icons.done_all, size: 18),
                  label: const Text('Confirm DC Delivery & Trigger Farmer Settlement'),
                ),
              ),
            ] else if (order.status == BuyerOrderStatus.delivered || order.status == BuyerOrderStatus.settled) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: FasalColors.successSubtle,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Text(
                    '✓ Delivered & Fully Settled to Smallholder Bank Accounts',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: FasalColors.success),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
