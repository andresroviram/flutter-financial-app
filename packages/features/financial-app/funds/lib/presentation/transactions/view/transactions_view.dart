import 'package:core/get_it.dart';
import '../../../domain/usecases/funds_usecases.dart';
import '../bloc/transactions_bloc.dart';
import '../bloc/transactions_event.dart';
import '../bloc/transactions_state.dart';
import '../widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  static const String path = '/transactions';
  static const String name = 'transactions';

  static Widget create() => BlocProvider(
    create: (_) =>
        TransactionsBloc(getTransactions: getIt<GetTransactionsUseCase>())
          ..add(const TransactionsLoadRequested()),
    child: const TransactionsView(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de transacciones')),
      body: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          if (state.status == TransactionsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == TransactionsStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Error al cargar transacciones',
              ),
            );
          }
          if (state.transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const Gap(16),
                  Text(
                    'Sin transacciones aún',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => context.read<TransactionsBloc>().add(
              const TransactionsLoadRequested(),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.transactions.length,
              separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
              itemBuilder: (_, i) =>
                  TransactionTile(transaction: state.transactions[i]),
            ),
          );
        },
      ),
    );
  }
}
