import 'package:drift/drift.dart';
import 'package:flutter_wigilabs_sr/core/database/app_database.dart';
import 'package:flutter_wigilabs_sr/modules/home/domain/entities/country_entity.dart';

class WishlistTable extends Table {
  TextColumn get cca2 => text()();
  TextColumn get commonName => text().named('common_name')();
  TextColumn get officialName => text().named('official_name')();
  TextColumn get capital => text().nullable()();
  TextColumn get region => text()();
  IntColumn get population => integer()();
  TextColumn get flagPng => text().named('flag_png')();
  TextColumn get flagAlt => text().nullable().named('flag_alt')();
  DateTimeColumn get addedAt => dateTime().named('added_at')();

  @override
  Set<Column> get primaryKey => {cca2};
}

extension WishlistMapper on WishlistTableData {
  CountryEntity toEntity() {
    return CountryEntity(
      cca2: cca2,
      commonName: commonName,
      officialName: officialName,
      capital: capital,
      region: region,
      population: population,
      flagPng: flagPng,
      flagAlt: flagAlt,
    );
  }
}
