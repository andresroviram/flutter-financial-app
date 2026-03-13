import 'package:core/entities/country_entity.dart';
import 'package:core/errors/result.dart';

abstract class IWishlistRepository {
  Future<Result<List<CountryEntity>>> getWishlist();
  Future<Result<void>> removeFromWishlist(String cca2);
}
