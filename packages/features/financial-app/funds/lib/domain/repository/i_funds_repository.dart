import 'package:core/errors/error.dart';
import '../entities/fund_entity.dart';
import '../entities/transaction_entity.dart';

abstract interface class IFundsRepository {
  Future<(List<FundEntity>, Failure?)> getFunds();
  Future<(int, Failure?)> getBalance();
  Future<(void, Failure?)> subscribeFund({
    required String fundId,
    required NotificationMethod notificationMethod,
  });
  Future<(void, Failure?)> cancelFund(String fundId);
  Future<(List<TransactionEntity>, Failure?)> getTransactions();
}
