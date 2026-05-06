import 'package:core/database/connection/shared.dart';
import 'package:drift/drift.dart';
import 'package:financial_app/config/database/tables/balance_table.dart';
import 'package:financial_app/config/database/tables/funds_table.dart';
import 'package:financial_app/config/database/tables/funds_transactions_table.dart';

part 'funds_database.g.dart';

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

@DriftDatabase(tables: [FundsTable, BalanceTable, FundsTransactionsTable])
class FundsDatabase extends _$FundsDatabase {
  FundsDatabase() : super(connect('financial_app'));

  FundsDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await batch((b) {
        b.insertAll(
          fundsTable,
          _initialFunds.map(
            (f) => FundsTableCompanion.insert(
              id: f.id,
              name: f.name,
              minimumAmount: f.minimumAmount,
              category: f.category,
            ),
          ),
        );
        b.insert(
          balanceTable,
          BalanceTableCompanion.insert(id: const Value(1), amount: 500000),
        );
      });
    },
  );
}
