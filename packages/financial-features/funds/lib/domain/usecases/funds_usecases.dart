import 'package:core/errors/error.dart';
import 'package:feature_funds/domain/entities/fund_entity.dart';
import 'package:feature_funds/domain/entities/transaction_entity.dart';
import 'package:feature_funds/domain/repository/i_funds_repository.dart';

class GetFundsUseCase {
  const GetFundsUseCase(this._repository);
  final IFundsRepository _repository;
  Future<(List<FundEntity>, Failure?)> call() => _repository.getFunds();
}

class GetBalanceUseCase {
  const GetBalanceUseCase(this._repository);
  final IFundsRepository _repository;
  Future<(int, Failure?)> call() => _repository.getBalance();
}

class SubscribeFundUseCase {
  const SubscribeFundUseCase(this._repository);
  final IFundsRepository _repository;
  Future<(void, Failure?)> call({
    required String fundId,
    required NotificationMethod notificationMethod,
  }) => _repository.subscribeFund(
    fundId: fundId,
    notificationMethod: notificationMethod,
  );
}

class CancelFundUseCase {
  const CancelFundUseCase(this._repository);
  final IFundsRepository _repository;
  Future<(void, Failure?)> call(String fundId) =>
      _repository.cancelFund(fundId);
}

class GetTransactionsUseCase {
  const GetTransactionsUseCase(this._repository);
  final IFundsRepository _repository;
  Future<(List<TransactionEntity>, Failure?)> call() =>
      _repository.getTransactions();
}
