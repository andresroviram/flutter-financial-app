import 'package:core/errors/error.dart';
import '../datasources/funds_local_datasource.dart';
import '../../domain/entities/fund_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repository/i_funds_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IFundsRepository)
class FundsRepositoryImpl implements IFundsRepository {
  const FundsRepositoryImpl(this._datasource);
  final IFundsLocalDatasource _datasource;

  @override
  Future<(List<FundEntity>, Failure?)> getFunds() async {
    try {
      return (await _datasource.getFunds(), null);
    } catch (e) {
      return (<FundEntity>[], UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<(int, Failure?)> getBalance() async {
    try {
      return (await _datasource.getBalance(), null);
    } catch (e) {
      return (0, UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<(void, Failure?)> subscribeFund({
    required String fundId,
    required NotificationMethod notificationMethod,
  }) async {
    try {
      await _datasource.subscribeFund(fundId, notificationMethod);
      return (null, null);
    } catch (e) {
      return (null, UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<(void, Failure?)> cancelFund(String fundId) async {
    try {
      await _datasource.cancelFund(fundId);
      return (null, null);
    } catch (e) {
      return (null, UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<(List<TransactionEntity>, Failure?)> getTransactions() async {
    try {
      return (await _datasource.getTransactions(), null);
    } catch (e) {
      return (<TransactionEntity>[], UnknownFailure(message: e.toString()));
    }
  }
}
