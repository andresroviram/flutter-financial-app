import 'wishlist_usecases.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WishlistUseCases {
  const WishlistUseCases({
    required this.getWishlist,
    required this.removeFromWishlist,
  });

  final GetWishlistUseCase getWishlist;
  final RemoveFromWishlistUseCase removeFromWishlist;
}
