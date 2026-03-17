import 'package:freezed_annotation/freezed_annotation.dart';

part 'transactions_event.freezed.dart';

@freezed
sealed class TransactionsEvent with _$TransactionsEvent {
  const factory TransactionsEvent.loadRequested() = TransactionsLoadRequested;
}
