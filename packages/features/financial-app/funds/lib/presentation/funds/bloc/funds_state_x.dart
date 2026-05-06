import 'package:feature_funds/presentation/funds/bloc/funds_state.dart';

extension FundsStateX on FundsState {
  bool get isLoading =>
      status == FundsStatus.initial || status == FundsStatus.loading;

  bool get hasFailure => status == FundsStatus.failure && errorMessage != null;

  T resolve<T>({
    required T Function() loading,
    required T Function(String errorMessage) failure,
    required T Function(FundsState state) data,
    T Function()? empty,
  }) {
    if (isLoading) return loading();
    if (hasFailure) return failure(errorMessage!);
    if (funds.isEmpty) return empty?.call() ?? data(this);
    return data(this);
  }
}
