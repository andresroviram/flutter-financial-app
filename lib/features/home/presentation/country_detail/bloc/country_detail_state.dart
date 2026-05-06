part of 'country_detail_bloc.dart';

@freezed
abstract class CountryDetailState with _$CountryDetailState {
  const factory CountryDetailState({
    @Default(false) bool isLoading,
    CountryEntity? country,
    @Default(false) bool isInWishlist,
    Failure? failure,
  }) = _CountryDetailState;
}
