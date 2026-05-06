import 'package:feature_funds/domain/entities/transaction_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transactions_state.freezed.dart';

enum TransactionsStatus { initial, loading, success, failure }

@freezed
abstract class TransactionsState with _$TransactionsState {
  const factory TransactionsState({
    @Default(TransactionsStatus.initial) TransactionsStatus status,
    @Default([]) List<TransactionEntity> transactions,
    String? errorMessage,
  }) = _TransactionsState;
}
