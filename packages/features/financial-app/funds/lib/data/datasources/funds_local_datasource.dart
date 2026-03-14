import 'package:drift/drift.dart';
import 'package:feature_funds/domain/entities/fund_entity.dart';
import 'package:feature_funds/domain/entities/transaction_entity.dart';
import 'package:financial_app/config/database/funds_database.dart';
import 'package:injectable/injectable.dart';

abstract interface class IFundsLocalDatasource {
  Future<List<FundEntity>> getFunds();
  Future<int> getBalance();
  Future<void> subscribeFund(
    String fundId,
    NotificationMethod notificationMethod,
  );
  Future<void> cancelFund(String fundId);
  Future<List<TransactionEntity>> getTransactions();
}

const _initialFunds = [
  (
    id: '1',
    name: 'FPV_BTG_PACTUAL_RECAUDADORA',
    minimumAmount: 75000,
    category: 'fpv',
  ),
  (
    id: '2',
    name: 'FPV_BTG_PACTUAL_ECOPETROL',
    minimumAmount: 125000,
    category: 'fpv',
  ),
  (id: '3', name: 'DEUDAPRIVADA', minimumAmount: 50000, category: 'fic'),
  (id: '4', name: 'FDO-ACCIONES', minimumAmount: 250000, category: 'fic'),
  (
    id: '5',
    name: 'FPV_BTG_PACTUAL_DINAMICA',
    minimumAmount: 100000,
    category: 'fpv',
  ),
];

@LazySingleton(as: IFundsLocalDatasource)
class FundsLocalDatasource implements IFundsLocalDatasource {
  const FundsLocalDatasource({required this.database});

  final FundsDatabase database;

  Future<void> _ensureSeeded() async {
    final count = await database.fundsTable.count().getSingle();
    if (count == 0) {
      await database.batch((batch) {
        batch.insertAll(
          database.fundsTable,
          _initialFunds
              .map(
                (f) => FundsTableCompanion.insert(
                  id: f.id,
                  name: f.name,
                  minimumAmount: f.minimumAmount,
                  category: f.category,
                ),
              )
              .toList(),
        );
        batch.insert(
          database.balanceTable,
          BalanceTableCompanion.insert(id: const Value(1), amount: 500000),
        );
      });
    }
  }

  @override
  Future<List<FundEntity>> getFunds() async {
    await _ensureSeeded();
    final rows = await database.select(database.fundsTable).get();
    return rows.map(_fundRowToEntity).toList();
  }

  @override
  Future<int> getBalance() async {
    await _ensureSeeded();
    final row = await (database.select(
      database.balanceTable,
    )..where((t) => t.id.equals(1))).getSingle();
    return row.amount;
  }

  @override
  Future<void> subscribeFund(
    String fundId,
    NotificationMethod notificationMethod,
  ) async {
    await _ensureSeeded();
    await database.transaction(() async {
      final fundRow = await (database.select(
        database.fundsTable,
      )..where((t) => t.id.equals(fundId))).getSingleOrNull();
      if (fundRow == null) throw Exception('Fondo no encontrado');
      if (fundRow.isSubscribed) {
        throw Exception('Ya está suscrito a este fondo');
      }

      final balanceRow = await (database.select(
        database.balanceTable,
      )..where((t) => t.id.equals(1))).getSingle();
      if (balanceRow.amount < fundRow.minimumAmount) {
        throw Exception(
          'No tiene saldo disponible para vincularse al fondo ${fundRow.name}',
        );
      }

      await (database.update(
        database.fundsTable,
      )..where((t) => t.id.equals(fundId))).write(
        FundsTableCompanion(
          isSubscribed: const Value(true),
          subscribedAmount: Value(fundRow.minimumAmount),
        ),
      );

      await (database.update(
        database.balanceTable,
      )..where((t) => t.id.equals(1))).write(
        BalanceTableCompanion(
          amount: Value(balanceRow.amount - fundRow.minimumAmount),
        ),
      );

      await database
          .into(database.fundsTransactionsTable)
          .insert(
            FundsTransactionsTableCompanion.insert(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              fundId: fundId,
              fundName: fundRow.name,
              type: 'subscribe',
              amount: fundRow.minimumAmount,
              date: DateTime.now(),
              notificationMethod: notificationMethod.name,
            ),
          );
    });
  }

  @override
  Future<void> cancelFund(String fundId) async {
    await _ensureSeeded();
    await database.transaction(() async {
      final fundRow = await (database.select(
        database.fundsTable,
      )..where((t) => t.id.equals(fundId))).getSingleOrNull();
      if (fundRow == null) throw Exception('Fondo no encontrado');
      if (!fundRow.isSubscribed) {
        throw Exception('No está suscrito a este fondo');
      }

      final amount = fundRow.subscribedAmount ?? fundRow.minimumAmount;
      final balanceRow = await (database.select(
        database.balanceTable,
      )..where((t) => t.id.equals(1))).getSingle();

      await (database.update(
        database.fundsTable,
      )..where((t) => t.id.equals(fundId))).write(
        const FundsTableCompanion(
          isSubscribed: Value(false),
          subscribedAmount: Value(null),
        ),
      );

      await (database.update(
        database.balanceTable,
      )..where((t) => t.id.equals(1))).write(
        BalanceTableCompanion(amount: Value(balanceRow.amount + amount)),
      );

      await database
          .into(database.fundsTransactionsTable)
          .insert(
            FundsTransactionsTableCompanion.insert(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              fundId: fundId,
              fundName: fundRow.name,
              type: 'cancel',
              amount: amount,
              date: DateTime.now(),
              notificationMethod: NotificationMethod.email.name,
            ),
          );
    });
  }

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    await _ensureSeeded();
    final rows = await (database.select(
      database.fundsTransactionsTable,
    )..orderBy([(t) => OrderingTerm.desc(t.date)])).get();
    return rows.map(_txRowToEntity).toList();
  }

  static FundEntity _fundRowToEntity(FundsTableData r) => FundEntity(
    id: r.id,
    name: r.name,
    minimumAmount: r.minimumAmount,
    category: r.category == 'fpv' ? FundCategory.fpv : FundCategory.fic,
    isSubscribed: r.isSubscribed,
    subscribedAmount: r.subscribedAmount,
  );

  static TransactionEntity _txRowToEntity(FundsTransactionsTableData r) =>
      TransactionEntity(
        id: r.id,
        fundId: r.fundId,
        fundName: r.fundName,
        type: r.type == 'subscribe'
            ? TransactionType.subscribe
            : TransactionType.cancel,
        amount: r.amount,
        date: r.date,
        notificationMethod: r.notificationMethod == 'sms'
            ? NotificationMethod.sms
            : NotificationMethod.email,
      );
}
