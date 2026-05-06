import 'package:core/entities/country_entity.dart';
import 'package:core/errors/error.dart';
import 'wishlist_bloc.dart';

extension WishlistStateX on WishlistState {
  List<CountryEntity> get filteredWishlist {
    if (searchQuery.isEmpty) return wishlist;
    return wishlist
        .where(
          (c) => c.commonName.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  T resolve<T>({
    required T Function() loading,
    required T Function(Failure failure) failure,
    required T Function(List<CountryEntity> filtered) data,
    T Function()? empty,
  }) {
    if (isLoading) return loading();
    if (this.failure != null) return failure(this.failure!);
    if (wishlist.isEmpty) return empty?.call() ?? loading();
    return data(filteredWishlist);
  }
}
