import 'package:flutter/material.dart';
import '../services/fasal_state.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class SyncStatusWidget extends StatelessWidget {
  final FasalState state;
  final VoidCallback? onToggleOffline;
  final VoidCallback? onSync;

  const SyncStatusWidget({
    super.key,
    required this.state,
    this.onToggleOffline,
    this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isOffline = state.isOffline;
    final pendingCount = state.pendingSyncQueue;
    final isSyncing = state.isSyncing;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isOffline ? FasalColors.warningSubtle : FasalColors.primaryGreenSubtle,
        border: Border(
          bottom: BorderSide(
            color: isOffline
                ? FasalColors.warning.withValues(alpha: 0.3)
                : FasalColors.primaryGreen.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: Row(
        children: [
          // Indicator Dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOffline ? FasalColors.warning : FasalColors.success,
            ),
          ),
          const SizedBox(width: 8),
          // Status Text
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    isOffline ? l10n.get('sync_offline') : l10n.get('sync_online'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isOffline ? FasalColors.warning : FasalColors.primaryGreenDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (pendingCount > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: FasalColors.warning,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$pendingCount ${l10n.get('sync_pending')}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Action Buttons
          if (pendingCount > 0 && !isOffline)
            TextButton(
              onPressed: isSyncing ? null : onSync,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: const Size(60, 32),
                backgroundColor: FasalColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: isSyncing
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      l10n.get('sync_now'),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
            ),
          const SizedBox(width: 4),
          IconButton(
            tooltip: l10n.get('toggle_offline'),
            icon: Icon(
              isOffline ? Icons.wifi_off : Icons.wifi,
              size: 18,
              color: isOffline ? FasalColors.warning : FasalColors.primaryGreen,
            ),
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            onPressed: onToggleOffline,
          ),
        ],
      ),
    );
  }
}
