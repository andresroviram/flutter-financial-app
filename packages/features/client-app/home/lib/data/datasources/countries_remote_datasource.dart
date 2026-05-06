import 'package:core/constants/app_constants.dart';
import 'package:core/errors/error.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/network/dio_response_converter.dart';
import 'package:feature_home/data/models/country_model.dart';
import 'package:injectable/injectable.dart';

abstract class ICountriesRemoteDatasource {
  Future<List<CountryModel>> getCountries();
  Future<CountryModel> getCountryDetail(String name);
  Future<CountryModel> getCountryByCode(String code);
}

@Injectable(as: ICountriesRemoteDatasource)
class CountriesRemoteDatasource implements ICountriesRemoteDatasource {
  const CountriesRemoteDatasource({required this.dioClient});
  final DioClient dioClient;

  @override
  Future<List<CountryModel>> getCountries() async {
    try {
      return (await dioClient.get(
        '${AppConstants.regionEndpoint}europe',
      )).withListConverter(callback: CountryModel.fromJson);
    } on Failure catch (_) {
      rethrow;
    }
  }

  @override
  Future<CountryModel> getCountryDetail(String name) async {
    try {
      return (await dioClient.get(
        '${AppConstants.translationEndpoint}$name',
      )).withListConverter(callback: CountryModel.fromJson).first;
    } on Failure catch (_) {
      rethrow;
    }
  }

  @override
  Future<CountryModel> getCountryByCode(String code) async {
    try {
      return (await dioClient.get(
        '${AppConstants.alphaEndpoint}$code',
      )).withListConverter(callback: CountryModel.fromJson).first;
    } on Failure catch (_) {
      rethrow;
    }
  }
}
