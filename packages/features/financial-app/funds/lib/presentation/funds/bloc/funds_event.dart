import 'package:equatable/equatable.dart';
import 'package:feature_funds/domain/entities/transaction_entity.dart';

abstract class FundsEvent extends Equatable {
  const FundsEvent();

  @override
  List<Object?> get props => [];
}

class FundsLoadRequested extends FundsEvent {
  const FundsLoadRequested();
}

class FundsSubscribeRequested extends FundsEvent {
  const FundsSubscribeRequested({
    required this.fundId,
    required this.notificationMethod,
  });

  final String fundId;
  final NotificationMethod notificationMethod;

  @override
  List<Object?> get props => [fundId, notificationMethod];
}

class FundsCancelRequested extends FundsEvent {
  const FundsCancelRequested(this.fundId);

  final String fundId;

  @override
  List<Object?> get props => [fundId];
}
