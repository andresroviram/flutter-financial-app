import 'package:feature_funds/domain/entities/transaction_entity.dart';
import 'package:feature_funds/presentation/transactions/bloc/transactions_state.dart';

extension TransactionsStateX on TransactionsState {
  bool get isLoading =>
      status == TransactionsStatus.initial ||
      status == TransactionsStatus.loading;

  bool get hasFailure =>
      status == TransactionsStatus.failure && errorMessage != null;

  T resolve<T>({
    required T Function() loading,
    required T Function(String errorMessage) failure,
    required T Function(List<TransactionEntity> transactions) data,
    T Function()? empty,
  }) {
    if (isLoading) return loading();
    if (hasFailure) return failure(errorMessage!);
    if (transactions.isEmpty) return empty?.call() ?? data(transactions);
    return data(transactions);
  }
}
