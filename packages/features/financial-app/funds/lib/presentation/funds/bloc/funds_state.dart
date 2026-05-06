import 'package:feature_funds/domain/entities/fund_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'funds_state.freezed.dart';

enum FundsStatus { initial, loading, success, failure, subscribing, canceling }

@freezed
abstract class FundsState with _$FundsState {
  const FundsState._();
  const factory FundsState({
    @Default(FundsStatus.initial) FundsStatus status,
    @Default([]) List<FundEntity> funds,
    @Default(500000) int balance,
    String? errorMessage,
    @Default(false) bool lastActionSuccess,
  }) = _FundsState;

  List<FundEntity> get availableFunds =>
      funds.where((f) => !f.isSubscribed).toList();
  List<FundEntity> get subscribedFunds =>
      funds.where((f) => f.isSubscribed).toList();
}
