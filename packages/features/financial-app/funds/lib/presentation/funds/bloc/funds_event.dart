import 'package:feature_funds/domain/entities/transaction_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'funds_event.freezed.dart';

@freezed
abstract class FundsEvent with _$FundsEvent {
  const factory FundsEvent.loadRequested() = FundsLoadRequested;
  const factory FundsEvent.subscribeRequested({
    required String fundId,
    required NotificationMethod notificationMethod,
  }) = FundsSubscribeRequested;
  const factory FundsEvent.cancelRequested(String fundId) =
      FundsCancelRequested;
}
