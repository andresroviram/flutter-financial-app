import '../bloc/funds_bloc.dart';
import '../bloc/funds_event.dart';
import '../bloc/funds_state.dart';
import '../widgets/balance_header.dart';
import '../widgets/fund_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class FundsMobile extends StatelessWidget {
  const FundsMobile({super.key});

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
          return RefreshIndicator(
            onRefresh: () async =>
                context.read<FundsBloc>().add(const FundsLoadRequested()),
            child: CustomScrollView(
              slivers: [
                const SliverAppBar(
                  title: Text('Mis Fondos'),
                  floating: true,
                  snap: true,
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      BalanceHeader(balance: state.balance),
                      const Gap(24),
                      if (state.subscribedFunds.isNotEmpty) ...[
                        _SectionTitle(
                          title: 'Fondos suscritos',
                          count: state.subscribedFunds.length,
                        ),
                        const Gap(8),
                        ...state.subscribedFunds.map(
                          (fund) => FundCard(
                            fund: fund,
                            fundsStatus: state.status,
                            onSubscribe: (_) {},
                            onCancel: () => context.read<FundsBloc>().add(
                              FundsCancelRequested(fund.id),
                            ),
                          ),
                        ),
                        const Gap(16),
                      ],
                      _SectionTitle(
                        title: 'Fondos disponibles',
                        count: state.availableFunds.length,
                      ),
                      const Gap(8),
                      ...state.availableFunds.map(
                        (fund) => FundCard(
                          fund: fund,
                          fundsStatus: state.status,
                          onSubscribe: (method) =>
                              context.read<FundsBloc>().add(
                                FundsSubscribeRequested(
                                  fundId: fund.id,
                                  notificationMethod: method,
                                ),
                              ),
                          onCancel: () {},
                        ),
                      ),
                      const Gap(80),
                    ]),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.count});
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ],
    );
  }
}
