import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_wigilabs_sr/core/database/app_database.dart';
import 'package:flutter_wigilabs_sr/features/home/data/datasources/wishlist_local_datasource.dart';
import 'package:flutter_wigilabs_sr/features/home/domain/entities/country_entity.dart';

// ──────────────────────── Fixtures ────────────────────────

const tSpain = CountryEntity(
  cca2: 'ES',
  commonName: 'Spain',
  officialName: 'Kingdom of Spain',
  capital: 'Madrid',
  region: 'Europe',
  population: 47000000,
  flagPng: 'https://flagcdn.com/w320/es.png',
);

const tFrance = CountryEntity(
  cca2: 'FR',
  commonName: 'France',
  officialName: 'French Republic',
  capital: 'Paris',
  region: 'Europe',
  population: 67000000,
  flagPng: 'https://flagcdn.com/w320/fr.png',
);

// ──────────────────────── Tests ────────────────────────

void main() {
  late AppDatabase database;
  late WishlistLocalDatasource datasource;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    datasource = WishlistLocalDatasource(database: database);
  });

  tearDown(() async {
    await database.close();
  });

  group('WishlistLocalDatasource', () {
    group('getWishlist', () {
      test('devuelve lista vacía cuando no hay países guardados', () async {
        final result = await datasource.getWishlist();
        expect(result, isEmpty);
      });

      test('devuelve los países guardados correctamente', () async {
        await datasource.addToWishlist(tSpain);
        await datasource.addToWishlist(tFrance);

        final result = await datasource.getWishlist();

        expect(result.length, 2);
        expect(result.map((c) => c.cca2), containsAll(['ES', 'FR']));
      });
    });

    group('addToWishlist', () {
      test('agrega un país correctamente', () async {
        await datasource.addToWishlist(tSpain);
        final result = await datasource.getWishlist();

        expect(result.length, 1);
        expect(result.first.cca2, 'ES');
        expect(result.first.commonName, 'Spain');
        expect(result.first.capital, 'Madrid');
      });

      test('no genera duplicados al agregar el mismo país dos veces', () async {
        await datasource.addToWishlist(tSpain);
        await datasource.addToWishlist(tSpain); // segunda vez

        final result = await datasource.getWishlist();
        expect(result.length, 1);
      });
    });

    group('removeFromWishlist', () {
      test('elimina el país correctamente', () async {
        await datasource.addToWishlist(tSpain);
        await datasource.addToWishlist(tFrance);

        await datasource.removeFromWishlist('ES');

        final result = await datasource.getWishlist();
        expect(result.length, 1);
        expect(result.first.cca2, 'FR');
      });

      test('no lanza excepción al eliminar un país que no existe', () async {
        expect(
          () => datasource.removeFromWishlist('XX'),
          returnsNormally,
        );
      });
    });

    group('isInWishlist', () {
      test('devuelve true cuando el país está en la lista de deseos', () async {
        await datasource.addToWishlist(tSpain);
        final result = await datasource.isInWishlist('ES');
        expect(result, isTrue);
      });

      test('devuelve false cuando el país NO está en la lista de deseos',
          () async {
        final result = await datasource.isInWishlist('ES');
        expect(result, isFalse);
      });

      test('devuelve false después de eliminar el país', () async {
        await datasource.addToWishlist(tSpain);
        await datasource.removeFromWishlist('ES');

        final result = await datasource.isInWishlist('ES');
        expect(result, isFalse);
      });
    });
  });
}
