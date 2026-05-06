import 'package:flutter_wigilabs_sr/core/result.dart';
import 'package:flutter_wigilabs_sr/modules/home/domain/entities/country_entity.dart';
import 'package:injectable/injectable.dart';
import '../repository/i_wishlist_repository.dart';

@lazySingleton
class GetWishlistUseCase {
  const GetWishlistUseCase(this._repository);
  final IWishlistRepository _repository;

  Future<Result<List<CountryEntity>>> call() => _repository.getWishlist();
}

@lazySingleton
class RemoveFromWishlistUseCase {
  const RemoveFromWishlistUseCase(this._repository);
  final IWishlistRepository _repository;

  Future<Result<void>> call(String cca2) =>
      _repository.removeFromWishlist(cca2);
}
