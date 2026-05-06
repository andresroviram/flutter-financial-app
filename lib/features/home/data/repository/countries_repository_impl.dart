import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_wigilabs_sr/core/result.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/error.dart';
import '../../../../core/performance/performance_settings.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/repository/i_countries_repository.dart';
import '../datasources/countries_remote_datasource.dart';
import '../datasources/wishlist_local_datasource.dart';
import '../models/country_model.dart';
import '../../../../core/utils/isolates/country_isolate_utils.dart';

@Injectable(as: ICountriesRepository)
class CountriesRepositoryImpl implements ICountriesRepository {
  const CountriesRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.performanceSettings,
  });

  final ICountriesRemoteDatasource remoteDatasource;
  final IWishlistLocalDatasource localDatasource;
  final PerformanceSettings performanceSettings;

  @override
  Future<Result<List<CountryEntity>>> getEuropeanCountries() async {
    try {
      final models = await remoteDatasource.getEuropeanCountries();
      final entities = await compute(
        CountryIsolateUtils.parseCountries,
        models,
      );
      return Success(entities);
    } on Failure catch (failure) {
      return Error(failure);
    } catch (e) {
      log('getEuropeanCountries error: $e');
      return Error(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<CountryEntity>> getCountryDetail(String translation) async {
    try {
      final model = await remoteDatasource.getCountryDetail(translation);
      return Success(model.toEntity());
    } on Failure catch (failure) {
      return Error(failure);
    } catch (e) {
      log('getCountryDetail error: $e');
      return Error(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<CountryEntity>>> getWishlist() async {
    try {
      final entities = await localDatasource.getWishlist();
      return Success(entities);
    } on StorageException catch (e) {
      return Error(StorageReadFailure(message: e.message));
    } catch (e) {
      log('getWishlist error: $e');
      return Error(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> addToWishlist(CountryEntity country) async {
    try {
      final CountryEntity processed;
      if (performanceSettings.useIsolate.value) {
        processed = await compute(
          CountryIsolateUtils.preprocessCountry,
          country,
        );
      } else {
        processed = CountryIsolateUtils.preprocessCountry(country);
      }
      await localDatasource.addToWishlist(processed);
      return const Success(null);
    } on StorageException catch (e) {
      return Error(StorageFailure(message: e.message));
    } catch (e) {
      log('addToWishlist error: $e');
      return Error(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> removeFromWishlist(String cca2) async {
    try {
      await localDatasource.removeFromWishlist(cca2);
      return const Success(null);
    } on StorageException catch (e) {
      return Error(StorageReadFailure(message: e.message));
    } catch (e) {
      log('removeFromWishlist error: $e');
      return Error(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<bool>> isInWishlist(String cca2) async {
    try {
      final result = await localDatasource.isInWishlist(cca2);
      return Success(result);
    } on StorageException catch (e) {
      return Error(StorageReadFailure(message: e.message));
    } catch (e) {
      log('isInWishlist error: $e');
      return Error(UnknownFailure(message: e.toString()));
    }
  }
}
