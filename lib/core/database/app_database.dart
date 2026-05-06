import 'package:drift/drift.dart';
import 'tables/wishlist_table.dart';
import 'connection/shared.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [WishlistTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}
