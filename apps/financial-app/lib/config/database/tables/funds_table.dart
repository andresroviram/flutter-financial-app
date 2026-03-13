import 'package:drift/drift.dart';

class FundsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get minimumAmount => integer().named('minimum_amount')();
  TextColumn get category => text()(); // 'fpv' or 'fic'
  BoolColumn get isSubscribed =>
      boolean().named('is_subscribed').withDefault(const Constant(false))();
  IntColumn get subscribedAmount =>
      integer().named('subscribed_amount').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
