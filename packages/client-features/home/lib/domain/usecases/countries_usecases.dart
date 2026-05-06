import 'package:core/entities/country_entity.dart';
import 'package:core/errors/result.dart';
import 'package:feature_home/domain/repository/i_countries_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetCountriesUseCase {
  const GetCountriesUseCase(this._repository);
  final ICountriesRepository _repository;

  Future<Result<List<CountryEntity>>> call() => _repository.getCountries();
}

@lazySingleton
class GetCountryDetailUseCase {
  const GetCountryDetailUseCase(this._repository);
  final ICountriesRepository _repository;

  Future<Result<CountryEntity>> call(String name) =>
      _repository.getCountryDetail(name);
}

@lazySingleton
class GetCountryByCodeUseCase {
  const GetCountryByCodeUseCase(this._repository);
  final ICountriesRepository _repository;

  Future<Result<CountryEntity>> call(String code) =>
      _repository.getCountryByCode(code);
}

@lazySingleton
class GetWishlistUseCase {
  const GetWishlistUseCase(this._repository);
  final ICountriesRepository _repository;

  Future<Result<List<CountryEntity>>> call() => _repository.getWishlist();
}

@lazySingleton
class AddToWishlistUseCase {
  const AddToWishlistUseCase(this._repository);
  final ICountriesRepository _repository;

  Future<Result<void>> call(CountryEntity country) =>
      _repository.addToWishlist(country);
}

@lazySingleton
class RemoveFromWishlistUseCase {
  const RemoveFromWishlistUseCase(this._repository);
  final ICountriesRepository _repository;

  Future<Result<void>> call(String cca2) =>
      _repository.removeFromWishlist(cca2);
}

@lazySingleton
class IsInWishlistUseCase {
  const IsInWishlistUseCase(this._repository);
  final ICountriesRepository _repository;

  Future<Result<bool>> call(String cca2) => _repository.isInWishlist(cca2);
}
