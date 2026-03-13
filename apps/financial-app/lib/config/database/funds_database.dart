import 'package:core/database/connection/shared.dart';
import 'package:drift/drift.dart';
import 'package:financial_app/config/database/tables/balance_table.dart';
import 'package:financial_app/config/database/tables/funds_table.dart';
import 'package:financial_app/config/database/tables/funds_transactions_table.dart';

part 'funds_database.g.dart';

@DriftDatabase(tables: [FundsTable, BalanceTable, FundsTransactionsTable])
class FundsDatabase extends _$FundsDatabase {
  FundsDatabase() : super(connect('financial_app'));

  FundsDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}
