import 'package:flutter_wigilabs_sr/config/database/app_database.dart';
import 'package:flutter_wigilabs_sr/config/database/tables/wishlist_table.dart';
import 'package:flutter_wigilabs_sr/modules/home/domain/entities/country_entity.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/error.dart';

abstract class IWishlistLocalDatasource {
  Future<List<CountryEntity>> getWishlist();
  Future<void> removeFromWishlist(String cca2);
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
          message: 'Error al obtener la lista de deseos: $e');
    }
  }

  @override
  Future<void> removeFromWishlist(String cca2) async {
    try {
      await (database.delete(database.wishlistTable)
            ..where((tbl) => tbl.cca2.equals(cca2)))
          .go();
    } catch (e) {
      throw StorageException(
        message: 'Error al eliminar el país de la lista de deseos: $e',
      );
    }
  }
}
