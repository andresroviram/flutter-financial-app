import 'package:bloc_test/bloc_test.dart';
import 'package:core/entities/country_entity.dart';
import 'package:core/errors/error.dart';
import 'package:core/errors/result.dart';
import 'package:feature_home/domain/usecases/countries_usecases.dart';
import 'package:feature_home/presentation/home/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCountriesUseCase extends Mock implements GetCountriesUseCase {}

class MockGetWishlistUseCase extends Mock implements GetWishlistUseCase {}

class MockAddToWishlistUseCase extends Mock implements AddToWishlistUseCase {}

class MockRemoveFromWishlistUseCase extends Mock
    implements RemoveFromWishlistUseCase {}

const tCountry = CountryEntity(
  cca2: 'ES',
  commonName: 'Spain',
  officialName: 'Kingdom of Spain',
  capital: 'Madrid',
  region: 'Europe',
  population: 47000000,
  flagPng: 'https://flagcdn.com/w320/es.png',
);

final tCountries = [tCountry];

void main() {
  late MockGetCountriesUseCase mockGetCountries;
  late MockGetWishlistUseCase mockGetWishlist;
  late MockAddToWishlistUseCase mockAddToWishlist;
  late MockRemoveFromWishlistUseCase mockRemoveFromWishlist;

  setUpAll(() {
    registerFallbackValue(tCountry);
  });

  setUp(() {
    mockGetCountries = MockGetCountriesUseCase();
    mockGetWishlist = MockGetWishlistUseCase();
    mockAddToWishlist = MockAddToWishlistUseCase();
    mockRemoveFromWishlist = MockRemoveFromWishlistUseCase();
  });

  HomeBloc buildBloc() => HomeBloc(
    getCountries: mockGetCountries,
    getWishlist: mockGetWishlist,
    addToWishlist: mockAddToWishlist,
    removeFromWishlist: mockRemoveFromWishlist,
  );

  group('HomeBloc', () {
    group('LoadCountries', () {
      blocTest<HomeBloc, HomeState>(
        'emite [loading, loaded] cuando la petición es exitosa',
        setUp: () {
          when(
            () => mockGetCountries(),
          ).thenAnswer((_) async => Success(tCountries));
          when(
            () => mockGetWishlist(),
          ).thenAnswer((_) async => const Success([]));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const HomeEvent.loadCountries()),
        expect: () => [
          const HomeState(isLoading: true),
          HomeState(countries: tCountries),
        ],
        verify: (_) {
          verify(() => mockGetCountries()).called(1);
          verify(() => mockGetWishlist()).called(1);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'emite [loading, error] cuando la API falla con NetworkFailure',
        setUp: () {
          when(
            () => mockGetCountries(),
          ).thenAnswer((_) async => const Error(NetworkFailure()));
          when(
            () => mockGetWishlist(),
          ).thenAnswer((_) async => const Success([]));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const HomeEvent.loadCountries()),
        expect: () => [
          const HomeState(isLoading: true),
          const HomeState(failure: NetworkFailure()),
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'carga correctamente la wishlist junto con los países',
        setUp: () {
          when(
            () => mockGetCountries(),
          ).thenAnswer((_) async => Success(tCountries));
          when(
            () => mockGetWishlist(),
          ).thenAnswer((_) async => const Success([tCountry]));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const HomeEvent.loadCountries()),
        expect: () => [
          const HomeState(isLoading: true),
          HomeState(countries: tCountries, wishlistCca2s: const {'ES'}),
        ],
      );
    });

    group('ToggleWishlist', () {
      blocTest<HomeBloc, HomeState>(
        'agrega país a la wishlist con actualización optimista',
        setUp: () {
          when(
            () => mockAddToWishlist(any()),
          ).thenAnswer((_) async => const Success(null));
        },
        build: buildBloc,
        seed: () => HomeState(countries: tCountries),
        act: (bloc) => bloc.add(const HomeEvent.toggleWishlist(tCountry)),
        expect: () => [
          HomeState(countries: tCountries, wishlistCca2s: const {'ES'}),
        ],
        verify: (_) => verify(() => mockAddToWishlist(tCountry)).called(1),
      );

      blocTest<HomeBloc, HomeState>(
        'elimina país de la wishlist con actualización optimista',
        setUp: () {
          when(
            () => mockRemoveFromWishlist(any()),
          ).thenAnswer((_) async => const Success(null));
        },
        build: buildBloc,
        seed: () =>
            HomeState(countries: tCountries, wishlistCca2s: const {'ES'}),
        act: (bloc) => bloc.add(const HomeEvent.toggleWishlist(tCountry)),
        expect: () => [HomeState(countries: tCountries)],
        verify: (_) => verify(() => mockRemoveFromWishlist('ES')).called(1),
      );
    });

    group('Invalidate', () {
      blocTest<HomeBloc, HomeState>(
        'limpia el failure del estado',
        build: buildBloc,
        seed: () => const HomeState(failure: NetworkFailure()),
        act: (bloc) => bloc.add(const HomeEvent.invalidate()),
        expect: () => [const HomeState()],
      );
    });
  });
}
