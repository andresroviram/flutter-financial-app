import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/country_entity.dart';

part 'country_model.g.dart';

@JsonSerializable(createToJson: false)
class CountryNameJson {
  const CountryNameJson({required this.common, required this.official});

  final String common;
  final String official;

  factory CountryNameJson.fromJson(Map<String, dynamic> json) =>
      _$CountryNameJsonFromJson(json);
}

@JsonSerializable(createToJson: false)
class CountryFlagsJson {
  const CountryFlagsJson({this.png, this.svg, this.alt});

  final String? png;
  final String? svg;
  final String? alt;

  factory CountryFlagsJson.fromJson(Map<String, dynamic> json) =>
      _$CountryFlagsJsonFromJson(json);
}

@JsonSerializable(createToJson: false)
class CountryCurrencyJson {
  const CountryCurrencyJson({this.name, this.symbol});

  final String? name;
  final String? symbol;

  factory CountryCurrencyJson.fromJson(Map<String, dynamic> json) =>
      _$CountryCurrencyJsonFromJson(json);
}

List<double>? _latlngFromJson(List<dynamic>? list) =>
    list?.map((e) => (e as num).toDouble()).toList();

@JsonSerializable(createToJson: false)
class CountryModel {
  const CountryModel({
    required this.cca2,
    required this.name,
    this.capital,
    required this.region,
    this.subregion,
    required this.population,
    required this.flags,
    this.area,
    this.languages,
    this.timezones,
    this.borders,
    this.currencies,
    this.latlng,
  });

  final String cca2;
  final CountryNameJson name;
  final List<String>? capital;
  final String region;
  final String? subregion;
  final int population;
  final CountryFlagsJson flags;
  final double? area;

  final Map<String, String>? languages;

  final List<String>? timezones;
  final List<String>? borders;

  final Map<String, CountryCurrencyJson>? currencies;

  @JsonKey(fromJson: _latlngFromJson)
  final List<double>? latlng;

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);
}

extension CountryModelMapper on CountryModel {
  CountryEntity toEntity() => CountryEntity(
        cca2: cca2,
        commonName: name.common,
        officialName: name.official,
        capital: capital?.isNotEmpty == true ? capital!.first : null,
        region: region,
        subregion: subregion,
        population: population,
        flagPng: flags.png ?? flags.svg ?? '',
        flagAlt: flags.alt,
        area: area,
        languages: languages?.values.toList(),
        timezones: timezones,
        borders: borders,
        currencies: currencies?.values.map((c) => c.name ?? 'Unknown').toList(),
        latlng: latlng,
      );
}
