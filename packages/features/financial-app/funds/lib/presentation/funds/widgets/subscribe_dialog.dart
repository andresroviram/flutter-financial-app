import 'package:easy_localization/easy_localization.dart';
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
      title: Text('funds.dialog.confirm_title'.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'funds.dialog.fund_label'.tr(args: [widget.fundName]),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(16),
          Text(
            'funds.dialog.notification_method'.tr(),
            style: theme.textTheme.bodySmall,
          ),
          RadioGroup<NotificationMethod>(
            groupValue: _selected,
            onChanged: (v) => setState(() => _selected = v!),
            child: Column(
              children: [
                RadioListTile<NotificationMethod>(
                  title: Text('funds.dialog.email'.tr()),
                  value: NotificationMethod.email,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                RadioListTile<NotificationMethod>(
                  title: Text('funds.dialog.sms'.tr()),
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
          child: Text('funds.dialog.cancel'.tr()),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_selected),
          child: Text('funds.dialog.confirm'.tr()),
        ),
      ],
    );
  }
}
