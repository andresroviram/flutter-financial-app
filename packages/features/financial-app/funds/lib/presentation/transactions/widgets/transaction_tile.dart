import '../../../domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction});

  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSubscribe = transaction.type == TransactionType.subscribe;

    final amountFormatted = NumberFormat.currency(
      locale: 'es_CO',
      symbol: 'COP \$',
      decimalDigits: 0,
    ).format(transaction.amount);

    final dateFormatted = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(transaction.date);

    final notifLabel =
        transaction.notificationMethod == NotificationMethod.email
        ? 'Email'
        : 'SMS';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isSubscribe
            ? colorScheme.primaryContainer
            : colorScheme.errorContainer,
        child: Icon(
          isSubscribe ? Icons.trending_up : Icons.trending_down,
          color: isSubscribe ? colorScheme.primary : colorScheme.error,
          size: 20,
        ),
      ),
      title: Text(
        transaction.fundName,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '$dateFormatted · $notifLabel',
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            isSubscribe ? 'Suscripción' : 'Cancelación',
            style: theme.textTheme.labelSmall?.copyWith(
              color: isSubscribe ? colorScheme.primary : colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            isSubscribe ? '-$amountFormatted' : '+$amountFormatted',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isSubscribe ? colorScheme.onSurface : Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
