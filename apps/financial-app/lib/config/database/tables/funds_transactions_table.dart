import 'package:drift/drift.dart';

class FundsTransactionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get fundId => text().named('fund_id')();
  TextColumn get fundName => text().named('fund_name')();
  TextColumn get type => text()(); // 'subscribe' or 'cancel'
  IntColumn get amount => integer()();
  DateTimeColumn get date => dateTime()();
  TextColumn get notificationMethod => text().named('notification_method')();

  @override
  Set<Column> get primaryKey => {id};
}
