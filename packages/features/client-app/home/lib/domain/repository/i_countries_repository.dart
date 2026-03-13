import 'package:core/entities/country_entity.dart';
import 'package:core/errors/result.dart';

abstract class ICountriesRepository {
  Future<Result<List<CountryEntity>>> getCountries();

  Future<Result<CountryEntity>> getCountryDetail(String translation);

  Future<Result<CountryEntity>> getCountryByCode(String code);

  Future<Result<List<CountryEntity>>> getWishlist();

  Future<Result<void>> addToWishlist(CountryEntity country);

  Future<Result<void>> removeFromWishlist(String cca2);

  Future<Result<bool>> isInWishlist(String cca2);
}
