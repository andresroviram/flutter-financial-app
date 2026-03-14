import 'package:core/errors/result.dart';
import 'package:feature_funds/domain/entities/fund_entity.dart';
import 'package:feature_funds/domain/entities/transaction_entity.dart';

abstract interface class IFundsRepository {
  Future<Result<List<FundEntity>>> getFunds();
  Future<Result<int>> getBalance();
  Future<Result<void>> subscribeFund({
    required String fundId,
    required NotificationMethod notificationMethod,
  });
  Future<Result<void>> cancelFund(String fundId);
  Future<Result<List<TransactionEntity>>> getTransactions();
}
