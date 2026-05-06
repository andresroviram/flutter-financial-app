part of 'home_bloc.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<CountryEntity> countries,
    @Default(<String>{}) Set<String> wishlistCca2s,
    @Default(false) bool isLoading,
    Failure? failure,
  }) = _Initial;
}
