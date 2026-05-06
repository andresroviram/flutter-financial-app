import 'package:core/entities/country_entity.dart';
import 'package:core/errors/error.dart';
import 'package:feature_home/presentation/home/bloc/home_bloc.dart';

extension HomeStateX on HomeState {
  List<CountryEntity> get filteredCountries {
    if (searchQuery.isEmpty) return countries;
    return countries
        .where(
          (c) => c.commonName.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  T resolve<T>({
    required T Function(Failure failure) failure,
    required T Function() loading,
    T Function()? empty,
    required T Function(List<CountryEntity> countries) data,
  }) {
    if (this.failure != null) return failure(this.failure!);
    if (isLoading) return loading();
    if (filteredCountries.isEmpty) return empty?.call() ?? loading();
    return data(filteredCountries);
  }
}
