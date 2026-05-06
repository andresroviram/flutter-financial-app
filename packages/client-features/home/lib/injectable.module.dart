//@GeneratedMicroModule;FeatureHomePackageModule;package:feature_home/injectable.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:core/database/app_database.dart' as _i696;
import 'package:core/network/dio_client.dart' as _i732;
import 'package:core/performance/performance_settings.dart' as _i707;
import 'package:feature_home/data/datasources/countries_remote_datasource.dart'
    as _i715;
import 'package:feature_home/data/datasources/wishlist_local_datasource.dart'
    as _i129;
import 'package:feature_home/data/repository/countries_repository_impl.dart'
    as _i433;
import 'package:feature_home/domain/repository/i_countries_repository.dart'
    as _i303;
import 'package:feature_home/domain/usecases/countries_usecases.dart' as _i740;
import 'package:injectable/injectable.dart' as _i526;

class FeatureHomePackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factory<_i129.IWishlistLocalDatasource>(
        () => _i129.WishlistLocalDatasource(database: gh<_i696.AppDatabase>()));
    gh.factory<_i715.ICountriesRemoteDatasource>(() =>
        _i715.CountriesRemoteDatasource(dioClient: gh<_i732.DioClient>()));
    gh.factory<_i303.ICountriesRepository>(() => _i433.CountriesRepositoryImpl(
          remoteDatasource: gh<_i715.ICountriesRemoteDatasource>(),
          localDatasource: gh<_i129.IWishlistLocalDatasource>(),
          performanceSettings: gh<_i707.PerformanceSettingsCubit>(),
        ));
    gh.lazySingleton<_i740.GetCountriesUseCase>(
        () => _i740.GetCountriesUseCase(gh<_i303.ICountriesRepository>()));
    gh.lazySingleton<_i740.GetCountryDetailUseCase>(
        () => _i740.GetCountryDetailUseCase(gh<_i303.ICountriesRepository>()));
    gh.lazySingleton<_i740.GetCountryByCodeUseCase>(
        () => _i740.GetCountryByCodeUseCase(gh<_i303.ICountriesRepository>()));
    gh.lazySingleton<_i740.GetWishlistUseCase>(
        () => _i740.GetWishlistUseCase(gh<_i303.ICountriesRepository>()));
    gh.lazySingleton<_i740.AddToWishlistUseCase>(
        () => _i740.AddToWishlistUseCase(gh<_i303.ICountriesRepository>()));
    gh.lazySingleton<_i740.RemoveFromWishlistUseCase>(() =>
        _i740.RemoveFromWishlistUseCase(gh<_i303.ICountriesRepository>()));
    gh.lazySingleton<_i740.IsInWishlistUseCase>(
        () => _i740.IsInWishlistUseCase(gh<_i303.ICountriesRepository>()));
  }
}
