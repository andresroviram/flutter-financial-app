import 'package:easy_localization/easy_localization.dart';
import 'package:feature_funds/domain/entities/fund_entity.dart';
import 'package:feature_funds/domain/entities/transaction_entity.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_state.dart';
import 'package:feature_funds/presentation/funds/widgets/fund_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FundsColumn extends StatelessWidget {
  const FundsColumn({
    super.key,
    required this.title,
    required this.funds,
    required this.status,
    required this.onSubscribe,
    required this.onCancel,
  });

  final String title;
  final List<FundEntity> funds;
  final FundsStatus status;
  final void Function(String fundId, NotificationMethod method) onSubscribe;
  final void Function(String fundId) onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(12),
        if (funds.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'funds.empty'.tr(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: funds.length,
              itemBuilder: (_, i) {
                final fund = funds[i];
                return FundCard(
                  fund: fund,
                  fundsStatus: status,
                  onSubscribe: (method) => onSubscribe(fund.id, method),
                  onCancel: () => onCancel(fund.id),
                );
              },
            ),
          ),
      ],
    );
  }
}
