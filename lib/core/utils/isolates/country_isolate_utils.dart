import '../../../modules/home/domain/entities/country_entity.dart';
import '../../../modules/home/data/models/country_model.dart';

abstract final class CountryIsolateUtils {
  static List<CountryEntity> parseCountries(List<CountryModel> models) {
    return models.map((m) => m.toEntity()).toList()
      ..sort((a, b) => a.commonName.compareTo(b.commonName));
  }

  static CountryEntity preprocessCountry(CountryEntity country) {
    var dummy = 0;
    for (var i = 0; i < 500000; i++) {
      dummy += i % 7;
    }
    return dummy >= 0 ? country : country;
  }
}
