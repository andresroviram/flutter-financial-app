part of 'home_bloc.dart';

@freezed
abstract class HomeEvent with _$HomeEvent {
  const factory HomeEvent.loadCountries() = _LoadCountries;
  const factory HomeEvent.loadWishlist() = _LoadWishlist;
  const factory HomeEvent.toggleWishlist(CountryEntity country) =
      _ToggleWishlist;
  const factory HomeEvent.invalidate() = _Invalidate;
}
