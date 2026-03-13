import 'countries_usecases.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CountryDetailUseCases {
  const CountryDetailUseCases({
    required this.getCountryDetail,
    required this.getCountryByCode,
    required this.isInWishlist,
    required this.addToWishlist,
    required this.removeFromWishlist,
  });

  final GetCountryDetailUseCase getCountryDetail;
  final GetCountryByCodeUseCase getCountryByCode;
  final IsInWishlistUseCase isInWishlist;
  final AddToWishlistUseCase addToWishlist;
  final RemoveFromWishlistUseCase removeFromWishlist;
}
