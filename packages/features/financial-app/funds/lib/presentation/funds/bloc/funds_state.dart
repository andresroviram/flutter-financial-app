import 'package:equatable/equatable.dart';
import '../../../domain/entities/fund_entity.dart';

enum FundsStatus { initial, loading, success, failure, subscribing, canceling }

class FundsState extends Equatable {
  const FundsState({
    this.status = FundsStatus.initial,
    this.funds = const [],
    this.balance = 500000,
    this.errorMessage,
    this.lastActionSuccess = false,
  });

  final FundsStatus status;
  final List<FundEntity> funds;
  final int balance;
  final String? errorMessage;
  final bool lastActionSuccess;

  FundsState copyWith({
    FundsStatus? status,
    List<FundEntity>? funds,
    int? balance,
    String? errorMessage,
    bool? lastActionSuccess,
  }) => FundsState(
    status: status ?? this.status,
    funds: funds ?? this.funds,
    balance: balance ?? this.balance,
    errorMessage: errorMessage,
    lastActionSuccess: lastActionSuccess ?? this.lastActionSuccess,
  );

  List<FundEntity> get availableFunds =>
      funds.where((f) => !f.isSubscribed).toList();
  List<FundEntity> get subscribedFunds =>
      funds.where((f) => f.isSubscribed).toList();

  @override
  List<Object?> get props => [
    status,
    funds,
    balance,
    errorMessage,
    lastActionSuccess,
  ];
}
