import 'package:feature_funds/domain/entities/fund_entity.dart';
import 'package:feature_funds/domain/entities/transaction_entity.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_state.dart';
import 'package:feature_funds/presentation/funds/widgets/subscribe_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class FundCard extends StatelessWidget {
  const FundCard({
    super.key,
    required this.fund,
    required this.fundsStatus,
    required this.onSubscribe,
    required this.onCancel,
  });

  final FundEntity fund;
  final FundsStatus fundsStatus;
  final void Function(NotificationMethod method) onSubscribe;
  final VoidCallback onCancel;

  void _showSubscribeDialog(BuildContext context) {
    showDialog<NotificationMethod>(
      context: context,
      builder: (_) => SubscribeDialog(fundName: fund.name),
    ).then((method) {
      if (method != null) onSubscribe(method);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLoading =
        fundsStatus == FundsStatus.subscribing ||
        fundsStatus == FundsStatus.canceling;

    final formatted = NumberFormat.currency(
      locale: 'es_CO',
      symbol: 'COP \$',
      decimalDigits: 0,
    ).format(fund.minimumAmount);

    final categoryColor = fund.category == FundCategory.fpv
        ? colorScheme.tertiary
        : colorScheme.secondary;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    fund.category.name.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: categoryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                if (fund.isSubscribed)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 12,
                          color: Colors.green,
                        ),
                        const Gap(4),
                        Text(
                          'Suscrito',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const Gap(10),
            Text(
              fund.name,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(6),
            Text(
              'Monto mínimo: $formatted',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const Gap(14),
            SizedBox(
              width: double.infinity,
              child: fund.isSubscribed
                  ? OutlinedButton.icon(
                      onPressed: isLoading ? null : onCancel,
                      icon: const Icon(Icons.cancel_outlined, size: 16),
                      label: const Text('Cancelar suscripción'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.error,
                        side: BorderSide(color: colorScheme.error),
                      ),
                    )
                  : FilledButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => _showSubscribeDialog(context),
                      icon: const Icon(Icons.add_circle_outline, size: 16),
                      label: const Text('Suscribirse'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
