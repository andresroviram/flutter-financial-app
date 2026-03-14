import 'package:core/errors/error.dart';
import 'package:core/errors/result.dart';
import 'package:feature_funds/data/datasources/funds_local_datasource.dart';
import 'package:feature_funds/domain/entities/fund_entity.dart';
import 'package:feature_funds/domain/entities/transaction_entity.dart';
import 'package:feature_funds/domain/repository/i_funds_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IFundsRepository)
class FundsRepositoryImpl implements IFundsRepository {
  const FundsRepositoryImpl(this._datasource);
  final IFundsLocalDatasource _datasource;

  @override
  Future<Result<List<FundEntity>>> getFunds() async {
    try {
      return Success(await _datasource.getFunds());
    } catch (e) {
      return Error(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<int>> getBalance() async {
    try {
      return Success(await _datasource.getBalance());
    } catch (e) {
      return Error(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> subscribeFund({
    required String fundId,
    required NotificationMethod notificationMethod,
  }) async {
    try {
      await _datasource.subscribeFund(fundId, notificationMethod);
      return const Success(null);
    } catch (e) {
      return Error(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> cancelFund(String fundId) async {
    try {
      await _datasource.cancelFund(fundId);
      return const Success(null);
    } catch (e) {
      return Error(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<TransactionEntity>>> getTransactions() async {
    try {
      return Success(await _datasource.getTransactions());
    } catch (e) {
      return Error(UnknownFailure(message: e.toString()));
    }
  }
}
