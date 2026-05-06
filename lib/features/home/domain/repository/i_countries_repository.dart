import 'package:flutter_wigilabs_sr/core/result.dart';
import '../entities/country_entity.dart';

abstract class ICountriesRepository {
  Future<Result<List<CountryEntity>>> getCountriesByLang(String lang);

  Future<Result<CountryEntity>> getCountryDetail(String translation);

  Future<Result<List<CountryEntity>>> getWishlist();

  Future<Result<void>> addToWishlist(CountryEntity country);

  Future<Result<void>> removeFromWishlist(String cca2);

  Future<Result<bool>> isInWishlist(String cca2);
}
