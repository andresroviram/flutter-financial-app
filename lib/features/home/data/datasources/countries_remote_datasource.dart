import 'package:flutter_wigilabs_sr/core/error/error.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/dio_response_converter.dart';
import '../models/country_model.dart';

abstract class ICountriesRemoteDatasource {
  Future<List<CountryModel>> getEuropeanCountries();
  Future<CountryModel> getCountryDetail(String translation);
}

@Injectable(as: ICountriesRemoteDatasource)
class CountriesRemoteDatasource implements ICountriesRemoteDatasource {
  const CountriesRemoteDatasource({required this.dioClient});
  final DioClient dioClient;

  @override
  Future<List<CountryModel>> getEuropeanCountries() async {
    try {
      return (await dioClient.get(
        '${AppConstants.baseUrl}${AppConstants.europeRegionEndpoint}',
      ))
          .withListConverter(callback: CountryModel.fromJson);
    } on Failure catch (_) {
      rethrow;
    }
  }

  @override
  Future<CountryModel> getCountryDetail(String translation) async {
    try {
      return (await dioClient.get(
        '${AppConstants.baseUrl}${AppConstants.translationEndpoint}$translation',
      ))
          .withListConverter(callback: CountryModel.fromJson)
          .first;
    } on Failure catch (_) {
      rethrow;
    }
  }
}
