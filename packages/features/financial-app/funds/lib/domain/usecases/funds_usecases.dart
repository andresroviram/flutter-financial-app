import 'package:core/errors/result.dart';
import 'package:feature_funds/domain/entities/fund_entity.dart';
import 'package:feature_funds/domain/entities/transaction_entity.dart';
import 'package:feature_funds/domain/repository/i_funds_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFundsUseCase {
  const GetFundsUseCase(this._repository);
  final IFundsRepository _repository;
  Future<Result<List<FundEntity>>> call() => _repository.getFunds();
}

@injectable
class GetBalanceUseCase {
  const GetBalanceUseCase(this._repository);
  final IFundsRepository _repository;
  Future<Result<int>> call() => _repository.getBalance();
}

@injectable
class SubscribeFundUseCase {
  const SubscribeFundUseCase(this._repository);
  final IFundsRepository _repository;
  Future<Result<void>> call({
    required String fundId,
    required NotificationMethod notificationMethod,
  }) => _repository.subscribeFund(
    fundId: fundId,
    notificationMethod: notificationMethod,
  );
}

@injectable
class CancelFundUseCase {
  const CancelFundUseCase(this._repository);
  final IFundsRepository _repository;
  Future<Result<void>> call(String fundId) => _repository.cancelFund(fundId);
}

@injectable
class GetTransactionsUseCase {
  const GetTransactionsUseCase(this._repository);
  final IFundsRepository _repository;
  Future<Result<List<TransactionEntity>>> call() =>
      _repository.getTransactions();
}
