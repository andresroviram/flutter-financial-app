part of 'wishlist_bloc.dart';

@freezed
abstract class WishlistEvent with _$WishlistEvent {
  const factory WishlistEvent.loadWishlist() = _LoadWishlist;
  const factory WishlistEvent.removeFromWishlist(String cca2) =
      _RemoveFromWishlist;
  const factory WishlistEvent.search(String query) = _Search;
  const factory WishlistEvent.invalidate() = _Invalidate;
}
