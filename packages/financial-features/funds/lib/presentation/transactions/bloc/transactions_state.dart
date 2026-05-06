import 'package:equatable/equatable.dart';
import 'package:feature_funds/domain/entities/transaction_entity.dart';

enum TransactionsStatus { initial, loading, success, failure }

class TransactionsState extends Equatable {
  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactions = const [],
    this.errorMessage,
  });

  final TransactionsStatus status;
  final List<TransactionEntity> transactions;
  final String? errorMessage;

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<TransactionEntity>? transactions,
    String? errorMessage,
  }) => TransactionsState(
    status: status ?? this.status,
    transactions: transactions ?? this.transactions,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => [status, transactions, errorMessage];
}
