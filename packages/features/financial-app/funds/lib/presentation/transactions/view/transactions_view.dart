import 'package:core/get_it.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feature_funds/domain/usecases/funds_usecases.dart';
import 'package:feature_funds/presentation/transactions/bloc/transactions_bloc.dart';
import 'package:feature_funds/presentation/transactions/bloc/transactions_event.dart';
import 'package:feature_funds/presentation/transactions/bloc/transactions_state.dart';
import 'package:feature_funds/presentation/transactions/bloc/transactions_state_x.dart';
import 'package:feature_funds/presentation/transactions/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class TransactionsView extends StatefulWidget {
  const TransactionsView({super.key});

  static const String path = '/transactions';
  static const String name = 'transactions';
  static const double verticalListRightPadding = 16;

  static Widget create() => BlocProvider(
    create: (_) =>
        TransactionsBloc(getTransactions: getIt<GetTransactionsUseCase>())
          ..add(const TransactionsEvent.loadRequested()),
    child: const TransactionsView(),
  );

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  GoRouterDelegate? _delegate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newDelegate = GoRouter.of(context).routerDelegate;
    if (_delegate != newDelegate) {
      _delegate?.removeListener(_onRouteChanged);
      _delegate = newDelegate;
      newDelegate.addListener(_onRouteChanged);
    }
  }

  void _onRouteChanged() {
    if (!mounted) return;
    final uri = _delegate?.currentConfiguration.uri.path;
    if (uri == TransactionsView.path) {
      context.read<TransactionsBloc>().add(
        const TransactionsEvent.loadRequested(),
      );
    }
  }

  @override
  void dispose() {
    _delegate?.removeListener(_onRouteChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('transactions.title'.tr()),
        forceMaterialTransparency: true,
      ),
      body: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) => state.resolve(
          loading: () => const Center(child: CircularProgressIndicator()),
          failure: (errorMessage) => Center(
            child: Text(
              errorMessage.isEmpty
                  ? 'transactions.error_loading'.tr()
                  : errorMessage,
            ),
          ),
          empty: () => Center(
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
                  'transactions.empty'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          data: (transactions) => RefreshIndicator(
            onRefresh: () async => context.read<TransactionsBloc>().add(
              const TransactionsEvent.loadRequested(),
            ),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                24,
                24,
                24 + TransactionsView.verticalListRightPadding,
                24,
              ),
              children: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < transactions.length; i++) ...[
                        TransactionTile(transaction: transactions[i]),
                        if (i < transactions.length - 1)
                          const Divider(height: 1, indent: 72),
                      ],
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
