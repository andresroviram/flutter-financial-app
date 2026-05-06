part of 'country_detail_bloc.dart';

@freezed
abstract class CountryDetailEvent with _$CountryDetailEvent {
  const factory CountryDetailEvent.loadDetail({
    required String translation,
    required CountryEntity previewCountry,
  }) = _LoadDetail;

  const factory CountryDetailEvent.toggleWishlist(CountryEntity country) =
      _ToggleWishlist;
  const factory CountryDetailEvent.invalidate() = _Invalidate;
}
