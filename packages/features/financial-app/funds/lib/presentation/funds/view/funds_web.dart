import 'package:feature_funds/domain/entities/fund_entity.dart';
import 'package:feature_funds/domain/entities/transaction_entity.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_bloc.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_event.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_state.dart';
import 'package:feature_funds/presentation/funds/widgets/balance_header.dart';
import 'package:feature_funds/presentation/funds/widgets/fund_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class FundsWeb extends StatelessWidget {
  const FundsWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FundsBloc, FundsState>(
        builder: (context, state) {
          if (state.status == FundsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == FundsStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const Gap(16),
                  Text(state.errorMessage ?? 'Error al cargar fondos'),
                  const Gap(16),
                  FilledButton(
                    onPressed: () => context.read<FundsBloc>().add(
                      const FundsLoadRequested(),
                    ),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mis Fondos',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Gap(16),
                BalanceHeader(balance: state.balance),
                const Gap(24),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _FundColumn(
                          title: 'Fondos disponibles',
                          funds: state.availableFunds,
                          status: state.status,
                          onSubscribe: (fundId, method) =>
                              context.read<FundsBloc>().add(
                                FundsSubscribeRequested(
                                  fundId: fundId,
                                  notificationMethod: method,
                                ),
                              ),
                          onCancel: (_) {},
                        ),
                      ),
                      const Gap(24),
                      Expanded(
                        child: _FundColumn(
                          title: 'Fondos suscritos',
                          funds: state.subscribedFunds,
                          status: state.status,
                          onSubscribe: (_, _) {},
                          onCancel: (fundId) => context.read<FundsBloc>().add(
                            FundsCancelRequested(fundId),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FundColumn extends StatelessWidget {
  const _FundColumn({
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
                  'Sin fondos',
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
