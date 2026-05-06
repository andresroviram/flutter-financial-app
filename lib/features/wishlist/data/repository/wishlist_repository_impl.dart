import 'dart:developer';
import 'package:flutter_wigilabs_sr/core/result.dart';
import 'package:flutter_wigilabs_sr/features/home/domain/entities/country_entity.dart';
import 'package:flutter_wigilabs_sr/features/wishlist/domain/repository/i_wishlist_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/error.dart';
import '../datasources/wishlist_local_datasource.dart';

@Injectable(as: IWishlistRepository)
class WishlistRepositoryImpl implements IWishlistRepository {
  const WishlistRepositoryImpl({
    required this.localDatasource,
  });

  final IWishlistLocalDatasource localDatasource;

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
}
