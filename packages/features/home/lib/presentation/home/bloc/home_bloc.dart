import 'package:bloc/bloc.dart';
import 'package:core/entities/country_entity.dart';
import 'package:core/errors/error.dart';
import 'package:core/errors/result.dart';
import 'package:feature_home/domain/usecases/countries_usecases.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required GetCountriesUseCase getCountries,
    required GetWishlistUseCase getWishlist,
    required AddToWishlistUseCase addToWishlist,
    required RemoveFromWishlistUseCase removeFromWishlist,
  }) : _getCountries = getCountries,
       _getWishlist = getWishlist,
       _addToWishlist = addToWishlist,
       _removeFromWishlist = removeFromWishlist,
       super(const _Initial()) {
    on<_LoadCountries>(_onLoadCountries);
    on<_LoadWishlist>(_onLoadWishlist);
    on<_ToggleWishlist>(_onToggleWishlist);
    on<_Invalidate>(_onInvalidate);
  }

  final GetCountriesUseCase _getCountries;
  final GetWishlistUseCase _getWishlist;
  final AddToWishlistUseCase _addToWishlist;
  final RemoveFromWishlistUseCase _removeFromWishlist;

  Future<void> _onLoadCountries(
    _LoadCountries event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, failure: null));

    final countriesResult = await _getCountries();
    final wishlistResult = await _getWishlist();

    final wishlistCca2s = wishlistResult.fold(
      onSuccess: (list) => list.map((c) => c.cca2).toSet(),
      onFailure: (_) => <String>{},
    );

    switch (countriesResult) {
      case Error(:final error):
        emit(state.copyWith(isLoading: false, failure: error));
      case Success(:final value):
        emit(
          state.copyWith(
            isLoading: false,
            countries: value,
            wishlistCca2s: wishlistCca2s,
          ),
        );
    }
  }

  Future<void> _onLoadWishlist(
    _LoadWishlist event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _getWishlist();
    final wishlistCca2s = result.fold(
      onSuccess: (list) => list.map((c) => c.cca2).toSet(),
      onFailure: (_) => <String>{},
    );
    emit(state.copyWith(wishlistCca2s: wishlistCca2s));
  }

  Future<void> _onToggleWishlist(
    _ToggleWishlist event,
    Emitter<HomeState> emit,
  ) async {
    final cca2 = event.country.cca2;
    final alreadyInWishlist = state.wishlistCca2s.contains(cca2);

    final updatedSet = Set<String>.from(state.wishlistCca2s);
    if (alreadyInWishlist) {
      updatedSet.remove(cca2);
    } else {
      updatedSet.add(cca2);
    }
    emit(state.copyWith(wishlistCca2s: updatedSet));

    if (alreadyInWishlist) {
      await _removeFromWishlist(cca2);
    } else {
      await _addToWishlist(event.country);
    }
  }

  void _onInvalidate(_Invalidate event, Emitter<HomeState> emit) {
    emit(state.copyWith(failure: null));
  }
}
