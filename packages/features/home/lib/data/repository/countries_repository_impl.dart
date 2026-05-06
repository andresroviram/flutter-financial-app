import 'dart:developer';

import 'package:core/entities/country_entity.dart';
import 'package:core/errors/error.dart';
import 'package:core/errors/result.dart';
import 'package:core/performance/performance_settings.dart';
import 'package:core/utils/isolates/country_isolate_utils.dart';
import 'package:feature_home/data/datasources/countries_remote_datasource.dart';
import 'package:feature_home/data/datasources/wishlist_local_datasource.dart';
import 'package:feature_home/data/models/country_model.dart';
import 'package:feature_home/domain/repository/i_countries_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ICountriesRepository)
class CountriesRepositoryImpl implements ICountriesRepository {
  const CountriesRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.performanceSettings,
  });

  final ICountriesRemoteDatasource remoteDatasource;
  final IWishlistLocalDatasource localDatasource;
  final PerformanceSettingsCubit performanceSettings;

  @override
  Future<Result<List<CountryEntity>>> getCountries() async {
    try {
      final models = await remoteDatasource.getCountries();
      final rawEntities = models.map((m) => m.toEntity()).toList();
      final entities = await compute(
        CountryIsolateUtils.parseCountries,
        rawEntities,
      );
      return Success(entities);
    } on Failure catch (failure) {
      return Error(failure);
    } catch (e) {
      log('getCountries error: $e');
      return Error(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<CountryEntity>> getCountryDetail(String name) async {
    try {
      final model = await remoteDatasource.getCountryDetail(name);
      return Success(model.toEntity());
    } on Failure catch (failure) {
      return Error(failure);
    } catch (e) {
      log('getCountryDetail error: $e');
      return Error(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<CountryEntity>> getCountryByCode(String code) async {
    try {
      final model = await remoteDatasource.getCountryByCode(code);
      return Success(model.toEntity());
    } on Failure catch (failure) {
      return Error(failure);
    } catch (e) {
      log('getCountryByCode error: $e');
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
      if (performanceSettings.state.useIsolate) {
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
