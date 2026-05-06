import 'countries_usecases.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class HomeUseCases {
  const HomeUseCases({
    required this.getCountries,
    required this.getWishlist,
    required this.addToWishlist,
    required this.removeFromWishlist,
  });

  final GetCountriesUseCase getCountries;
  final GetWishlistUseCase getWishlist;
  final AddToWishlistUseCase addToWishlist;
  final RemoveFromWishlistUseCase removeFromWishlist;
}
