import 'package:freezed_annotation/freezed_annotation.dart';

part 'transactions_event.freezed.dart';

@freezed
abstract class TransactionsEvent with _$TransactionsEvent {
  const factory TransactionsEvent.loadRequested() =
      TransactionsLoadRequested;
}
