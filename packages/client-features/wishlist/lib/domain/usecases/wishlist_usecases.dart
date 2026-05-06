import 'package:core/entities/country_entity.dart';
import 'package:core/errors/result.dart';
import 'package:feature_wishlist/domain/repository/i_wishlist_repository.dart';
import 'package:injectable/injectable.dart';

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
