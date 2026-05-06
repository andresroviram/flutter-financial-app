import 'package:drift/drift.dart';

class BalanceTable extends Table {
  IntColumn get id => integer()(); // always row 1
  IntColumn get amount => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
