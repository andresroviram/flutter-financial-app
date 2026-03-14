import 'package:feature_funds/presentation/funds/bloc/funds_bloc.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_event.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_state.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_state_x.dart';
import 'package:feature_funds/presentation/funds/widgets/balance_header.dart';
import 'package:feature_funds/presentation/funds/widgets/funds_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class FundsWeb extends StatelessWidget {
  const FundsWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FundsBloc, FundsState>(
        builder: (context, state) => state.resolve(
          loading: () => const Center(child: CircularProgressIndicator()),
          failure: (errorMessage) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const Gap(16),
                Text(errorMessage),
                const Gap(16),
                FilledButton(
                  onPressed: () => context.read<FundsBloc>().add(
                    const FundsEvent.loadRequested(),
                  ),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
          data: (state) => Padding(
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
                        child: FundsColumn(
                          title: 'Fondos disponibles',
                          funds: state.availableFunds,
                          status: state.status,
                          onSubscribe: (fundId, method) =>
                              context.read<FundsBloc>().add(
                                FundsEvent.subscribeRequested(
                                  fundId: fundId,
                                  notificationMethod: method,
                                ),
                              ),
                          onCancel: (_) {},
                        ),
                      ),
                      const Gap(24),
                      Expanded(
                        child: FundsColumn(
                          title: 'Fondos suscritos',
                          funds: state.subscribedFunds,
                          status: state.status,
                          onSubscribe: (_, _) {},
                          onCancel: (fundId) => context.read<FundsBloc>().add(
                            FundsEvent.cancelRequested(fundId),
                          ),
                        ),
                      ),
                    ],
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
