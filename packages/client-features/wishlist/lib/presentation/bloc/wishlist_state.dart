part of 'wishlist_bloc.dart';

@freezed
abstract class WishlistState with _$WishlistState {
  const factory WishlistState({
    @Default([]) List<CountryEntity> wishlist,
    @Default(false) bool isLoading,
    Failure? failure,
  }) = _WishlistState;
}
