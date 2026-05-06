import 'package:core/database/connection/shared.dart';
import 'package:core/database/tables/wishlist_table.dart';
import 'package:drift/drift.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [WishlistTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}
