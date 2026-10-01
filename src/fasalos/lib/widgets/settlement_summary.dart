import 'package:flutter/material.dart';
import '../models/settlement.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class SettlementSummary extends StatelessWidget {
  final List<SettlementRecord> settlements;
  final VoidCallback? onRefresh;

  const SettlementSummary({
    super.key,
    required this.settlements,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final totalDisbursed = settlements.fold(0.0, (acc, s) => acc + s.netFarmerPayout);
    final totalGross = settlements.fold(0.0, (acc, s) => acc + s.grossProduceValue);
    final totalQualityPremium = settlements.fold(0.0, (acc, s) => acc + s.coldChainQualityPremium);
    final totalHubFees = settlements.fold(0.0, (acc, s) => acc + s.hubHandlingFee);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FasalColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: FasalColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: FasalColors.successSubtle,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.account_balance, size: 20, color: FasalColors.success),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.get('settlement_title'),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: FasalColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Text(
                                  'Direct farmer bank credit via NPCI DBT gateway',
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
                        color: FasalColors.successSubtle,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        l10n.get('settlement_complete_badge'),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: FasalColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Top Level Totals Grid
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: FasalColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Net Payout to Farmers',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: FasalColors.textMuted),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '₹${totalDisbursed.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: FasalColors.primaryGreen,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              '${settlements.length} lots (Gross: ₹${totalGross.toStringAsFixed(0)} • Hub: −₹${totalHubFees.toStringAsFixed(0)})',
                              style: const TextStyle(fontSize: 10, color: FasalColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 48, color: FasalColors.borderSubtle),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Cold Storage Bonus Earned',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: FasalColors.textMuted),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '+₹${totalQualityPremium.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: FasalColors.success,
                              ),
                            ),
                            const Text(
                              'Zero distress markdown',
                              style: TextStyle(fontSize: 10, color: FasalColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Transparent Formula Explainer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: FasalColors.primaryGreenSubtle,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: FasalColors.primaryGreen.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: const [
                Icon(Icons.calculate, size: 16, color: FasalColors.primaryGreenDark),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Net Farmer Payout = (Quantity × Buyer Rate) + Solar Quality Premium − Hub Handling Fee',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: FasalColors.primaryGreenDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Individual Farmer Settlement Slips
          Text(
            'Audited Farmer Settlement Slips',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: FasalColors.textPrimary,
                ),
          ),
          const SizedBox(height: 10),

          ...settlements.map((s) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: FasalColors.borderSubtle),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Farmer & Lot Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.farmerName,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            Text(
                              '${s.lotId} • ${s.cropType} (${s.quantityKg.toInt()} kg)',
                              style: const TextStyle(fontSize: 12, color: FasalColors.textSecondary),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: FasalColors.successSubtle,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Net: ₹${s.netFarmerPayout.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: FasalColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Line Items
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: FasalColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _buildLineItem(
                            label: l10n.get('gross_proceeds'),
                            calc: '${s.quantityKg.toInt()} kg × ₹${s.ratePerKg.toStringAsFixed(0)}',
                            amount: '₹${s.grossProduceValue.toStringAsFixed(0)}',
                            isCredit: true,
                          ),
                          const SizedBox(height: 6),
                          _buildLineItem(
                            label: l10n.get('cold_rebate'),
                            calc: 'Saved spoilage + Grade A+ premium',
                            amount: '+₹${s.coldChainQualityPremium.toStringAsFixed(0)}',
                            isCredit: true,
                            amountColor: FasalColors.success,
                          ),
                          const SizedBox(height: 6),
                          _buildLineItem(
                            label: l10n.get('hub_fee'),
                            calc: 'Intake grading, solar cold hub handling',
                            amount: '−₹${s.hubHandlingFee.toStringAsFixed(0)}',
                            isCredit: false,
                            amountColor: FasalColors.error,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // DBT Banking Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Credited to: ${s.bankAccountMasked}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: FasalColors.textSecondary),
                        ),
                        Text(
                          'Ref: ${s.transactionRef}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: FasalColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLineItem({
    required String label,
    required String calc,
    required String amount,
    required bool isCredit,
    Color? amountColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: FasalColors.textPrimary),
              ),
              Text(
                calc,
                style: const TextStyle(fontSize: 10, color: FasalColors.textMuted),
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: amountColor ?? FasalColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
