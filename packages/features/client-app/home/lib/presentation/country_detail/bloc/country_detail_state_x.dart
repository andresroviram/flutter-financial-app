import 'package:core/entities/country_entity.dart';
import 'package:core/errors/error.dart';
import 'package:feature_home/presentation/country_detail/bloc/country_detail_bloc.dart';

extension CountryDetailStateX on CountryDetailState {
  T resolve<T>({
    required T Function() loading,
    required T Function(Failure failure) failure,
    required T Function(CountryEntity country) data,
    T Function()? empty,
  }) {
    if (isLoading) return loading();
    if (this.failure != null) return failure(this.failure!);
    if (country != null) return data(country!);
    return empty?.call() ?? loading();
  }
}
