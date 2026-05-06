import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wigilabs_sr/modules/wishlist/domain/usecases/wishlist_usecases.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_wigilabs_sr/core/result.dart';
import 'package:flutter_wigilabs_sr/modules/home/domain/entities/country_entity.dart';
import 'package:flutter_wigilabs_sr/modules/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:flutter_wigilabs_sr/core/error/error.dart';

class MockGetWishlistUseCase extends Mock implements GetWishlistUseCase {}

class MockRemoveFromWishlistUseCase extends Mock
    implements RemoveFromWishlistUseCase {}

const tCountry1 = CountryEntity(
  cca2: 'FR',
  commonName: 'France',
  officialName: 'French Republic',
  capital: 'Paris',
  region: 'Europe',
  population: 67000000,
  flagPng: 'https://flagcdn.com/w320/fr.png',
);

const tCountry2 = CountryEntity(
  cca2: 'DE',
  commonName: 'Germany',
  officialName: 'Federal Republic of Germany',
  capital: 'Berlin',
  region: 'Europe',
  population: 83000000,
  flagPng: 'https://flagcdn.com/w320/de.png',
);

void main() {
  late MockGetWishlistUseCase mockGetWishlist;
  late MockRemoveFromWishlistUseCase mockRemoveFromWishlist;

  setUp(() {
    mockGetWishlist = MockGetWishlistUseCase();
    mockRemoveFromWishlist = MockRemoveFromWishlistUseCase();
  });

  WishlistBloc buildBloc() => WishlistBloc(
    getWishlist: mockGetWishlist,
    removeFromWishlist: mockRemoveFromWishlist,
  );

  group('WishlistBloc', () {
    group('LoadWishlist', () {
      blocTest<WishlistBloc, WishlistState>(
        'emite [loading, loaded] con la lista de países cuando tiene éxito',
        setUp: () {
          when(
            () => mockGetWishlist(),
          ).thenAnswer((_) async => const Success([tCountry1, tCountry2]));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const WishlistEvent.loadWishlist()),
        expect: () => [
          const WishlistState(isLoading: true),
          const WishlistState(
            isLoading: false,
            wishlist: [tCountry1, tCountry2],
          ),
        ],
        verify: (_) => verify(() => mockGetWishlist()).called(1),
      );

      blocTest<WishlistBloc, WishlistState>(
        'emite [loading, error] cuando falla la carga de wishlist',
        setUp: () {
          when(() => mockGetWishlist()).thenAnswer(
            (_) async => const Error(StorageFailure(message: 'DB error')),
          );
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const WishlistEvent.loadWishlist()),
        expect: () => [
          const WishlistState(isLoading: true),
          const WishlistState(
            isLoading: false,
            failure: StorageFailure(message: 'DB error'),
          ),
        ],
      );

      blocTest<WishlistBloc, WishlistState>(
        'emite lista vacía cuando la wishlist no tiene países',
        setUp: () {
          when(
            () => mockGetWishlist(),
          ).thenAnswer((_) async => const Success([]));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const WishlistEvent.loadWishlist()),
        expect: () => [
          const WishlistState(isLoading: true),
          const WishlistState(isLoading: false, wishlist: []),
        ],
      );
    });

    group('RemoveFromWishlist', () {
      blocTest<WishlistBloc, WishlistState>(
        'elimina el país de la lista con actualización optimista',
        setUp: () {
          when(
            () => mockRemoveFromWishlist(any()),
          ).thenAnswer((_) async => const Success(null));
        },
        build: buildBloc,
        seed: () => const WishlistState(wishlist: [tCountry1, tCountry2]),
        act: (bloc) => bloc.add(const WishlistEvent.removeFromWishlist('FR')),
        expect: () => [
          const WishlistState(wishlist: [tCountry2]),
        ],
        verify: (_) => verify(() => mockRemoveFromWishlist('FR')).called(1),
      );

      blocTest<WishlistBloc, WishlistState>(
        'hace rollback si la eliminación falla en la base de datos',
        setUp: () {
          when(() => mockRemoveFromWishlist(any())).thenAnswer(
            (_) async => const Error(StorageFailure(message: 'DB error')),
          );
          when(
            () => mockGetWishlist(),
          ).thenAnswer((_) async => const Success([tCountry1, tCountry2]));
        },
        build: buildBloc,
        seed: () => const WishlistState(wishlist: [tCountry1, tCountry2]),
        act: (bloc) => bloc.add(const WishlistEvent.removeFromWishlist('FR')),
        expect: () => [
          const WishlistState(wishlist: [tCountry2]),
          const WishlistState(isLoading: true, wishlist: [tCountry2]),
          const WishlistState(
            wishlist: [tCountry1, tCountry2],
            isLoading: false,
          ),
        ],
      );
    });
  });
}
