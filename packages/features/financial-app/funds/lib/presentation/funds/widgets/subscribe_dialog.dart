import 'package:feature_funds/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SubscribeDialog extends StatefulWidget {
  const SubscribeDialog({super.key, required this.fundName});

  final String fundName;

  @override
  State<SubscribeDialog> createState() => _SubscribeDialogState();
}

class _SubscribeDialogState extends State<SubscribeDialog> {
  NotificationMethod _selected = NotificationMethod.email;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Confirmar suscripción'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fondo: ${widget.fundName}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(16),
          Text('Método de notificación:', style: theme.textTheme.bodySmall),
          RadioGroup<NotificationMethod>(
            groupValue: _selected,
            onChanged: (v) => setState(() => _selected = v!),
            child: const Column(
              children: [
                RadioListTile<NotificationMethod>(
                  title: Text('Email'),
                  value: NotificationMethod.email,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                RadioListTile<NotificationMethod>(
                  title: Text('SMS'),
                  value: NotificationMethod.sms,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_selected),
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
