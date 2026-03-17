import 'package:easy_localization/easy_localization.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_bloc.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_event.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_state.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_state_x.dart';
import 'package:feature_funds/presentation/funds/widgets/balance_header.dart';
import 'package:feature_funds/presentation/funds/widgets/fund_card.dart';
import 'package:feature_funds/presentation/funds/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class FundsMobile extends StatelessWidget {
  const FundsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FundsBloc, FundsState>(
        buildWhen: (prev, curr) =>
            prev.status != curr.status ||
            prev.funds != curr.funds ||
            prev.balance != curr.balance ||
            prev.errorMessage != curr.errorMessage,
        builder: (context, state) => state.resolve(
          loading: () => const Center(child: CircularProgressIndicator()),
          failure: (errorMessage) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const Gap(16),
                Text(
                  errorMessage.isEmpty
                      ? 'funds.error_loading'.tr()
                      : errorMessage,
                ),
                const Gap(16),
                FilledButton(
                  onPressed: () => context.read<FundsBloc>().add(
                    const FundsEvent.loadRequested(),
                  ),
                  child: Text('funds.retry'.tr()),
                ),
              ],
            ),
          ),
          data: (state) => RefreshIndicator(
            onRefresh: () async =>
                context.read<FundsBloc>().add(const FundsEvent.loadRequested()),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text('funds.title'.tr()),
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
                        SectionTitle(
                          title: 'funds.subscribed'.tr(),
                          count: state.subscribedFunds.length,
                        ),
                        const Gap(8),
                        ...state.subscribedFunds.map(
                          (fund) => FundCard(
                            fund: fund,
                            fundsStatus: state.status,
                            onSubscribe: (_) {},
                            onCancel: () => context.read<FundsBloc>().add(
                              FundsEvent.cancelRequested(fund.id),
                            ),
                          ),
                        ),
                        const Gap(16),
                      ],
                      SectionTitle(
                        title: 'funds.available'.tr(),
                        count: state.availableFunds.length,
                      ),
                      const Gap(8),
                      ...state.availableFunds.map(
                        (fund) => FundCard(
                          fund: fund,
                          fundsStatus: state.status,
                          onSubscribe: (method) =>
                              context.read<FundsBloc>().add(
                                FundsEvent.subscribeRequested(
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
          ),
        ),
      ),
    );
  }
}
