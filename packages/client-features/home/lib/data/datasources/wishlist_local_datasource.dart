import 'package:core/database/app_database.dart';
import 'package:core/database/tables/wishlist_table.dart';
import 'package:core/entities/country_entity.dart';
import 'package:core/errors/error.dart';
import 'package:drift/drift.dart' as drift;
import 'package:injectable/injectable.dart';

abstract class IWishlistLocalDatasource {
  Future<List<CountryEntity>> getWishlist();
  Future<void> addToWishlist(CountryEntity country);
  Future<void> removeFromWishlist(String cca2);
  Future<bool> isInWishlist(String cca2);
}

@Injectable(as: IWishlistLocalDatasource)
class WishlistLocalDatasource implements IWishlistLocalDatasource {
  const WishlistLocalDatasource({required this.database});
  final AppDatabase database;

  @override
  Future<List<CountryEntity>> getWishlist() async {
    try {
      final rows = await database.select(database.wishlistTable).get();
      return rows.map((r) => r.toEntity()).toList();
    } catch (e) {
      throw StorageException(
        message: 'Error al obtener la lista de deseos: $e',
      );
    }
  }

  @override
  Future<void> addToWishlist(CountryEntity country) async {
    try {
      await database
          .into(database.wishlistTable)
          .insertOnConflictUpdate(
            WishlistTableCompanion.insert(
              cca2: country.cca2,
              commonName: country.commonName,
              officialName: country.officialName,
              capital: drift.Value(country.capital),
              region: country.region,
              population: country.population,
              flagPng: country.flagPng,
              flagAlt: drift.Value(country.flagAlt),
              addedAt: DateTime.now(),
            ),
          );
    } catch (e) {
      throw StorageException(
        message: 'Error al agregar el país a la lista de deseos: $e',
      );
    }
  }

  @override
  Future<void> removeFromWishlist(String cca2) async {
    try {
      await (database.delete(
        database.wishlistTable,
      )..where((tbl) => tbl.cca2.equals(cca2))).go();
    } catch (e) {
      throw StorageException(
        message: 'Error al eliminar el país de la lista de deseos: $e',
      );
    }
  }

  @override
  Future<bool> isInWishlist(String cca2) async {
    try {
      final query = database.select(database.wishlistTable)
        ..where((tbl) => tbl.cca2.equals(cca2));
      final row = await query.getSingleOrNull();
      return row != null;
    } catch (e) {
      throw StorageException(
        message: 'Error al verificar la lista de deseos: $e',
      );
    }
  }
}
