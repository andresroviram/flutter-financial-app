import 'package:flutter_wigilabs_sr/core/result.dart';
import 'package:flutter_wigilabs_sr/features/home/domain/entities/country_entity.dart';

abstract class IWishlistRepository {
  Future<Result<List<CountryEntity>>> getWishlist();
  Future<Result<void>> removeFromWishlist(String cca2);
}
