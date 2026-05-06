import 'package:core/database/connection/shared.dart';
import 'package:drift/drift.dart';
import 'package:flutter_wigilabs_sr/config/database/tables/wishlist_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [WishlistTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect('countries_wishlist'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}
