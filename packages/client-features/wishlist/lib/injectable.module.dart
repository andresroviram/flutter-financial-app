//@GeneratedMicroModule;FeatureWishlistPackageModule;package:feature_wishlist/injectable.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:core/database/app_database.dart' as _i696;
import 'package:feature_wishlist/data/datasources/wishlist_local_datasource.dart'
    as _i315;
import 'package:feature_wishlist/data/repository/wishlist_repository_impl.dart'
    as _i960;
import 'package:feature_wishlist/domain/repository/i_wishlist_repository.dart'
    as _i167;
import 'package:feature_wishlist/domain/usecases/wishlist_usecases.dart'
    as _i767;
import 'package:injectable/injectable.dart' as _i526;

class FeatureWishlistPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factory<_i315.IWishlistLocalDatasource>(
        () => _i315.WishlistLocalDatasource(database: gh<_i696.AppDatabase>()));
    gh.factory<_i167.IWishlistRepository>(() => _i960.WishlistRepositoryImpl(
        localDatasource: gh<_i315.IWishlistLocalDatasource>()));
    gh.lazySingleton<_i767.GetWishlistUseCase>(
        () => _i767.GetWishlistUseCase(gh<_i167.IWishlistRepository>()));
    gh.lazySingleton<_i767.RemoveFromWishlistUseCase>(
        () => _i767.RemoveFromWishlistUseCase(gh<_i167.IWishlistRepository>()));
  }
}
