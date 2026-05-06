import 'package:bloc/bloc.dart';
import 'package:core/entities/country_entity.dart';
import 'package:core/errors/error.dart';
import 'package:core/errors/result.dart';
import 'package:feature_home/domain/usecases/countries_usecases.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_detail_bloc.freezed.dart';
part 'country_detail_event.dart';
part 'country_detail_state.dart';

class CountryDetailBloc extends Bloc<CountryDetailEvent, CountryDetailState> {
  CountryDetailBloc({
    required GetCountryDetailUseCase getCountryDetail,
    required GetCountryByCodeUseCase getCountryByCode,
    required IsInWishlistUseCase isInWishlist,
    required AddToWishlistUseCase addToWishlist,
    required RemoveFromWishlistUseCase removeFromWishlist,
  }) : _getCountryDetail = getCountryDetail,
       _getCountryByCode = getCountryByCode,
       _isInWishlist = isInWishlist,
       _addToWishlist = addToWishlist,
       _removeFromWishlist = removeFromWishlist,
       super(const CountryDetailState()) {
    on<_LoadDetail>(_onLoadDetail);
    on<_LoadDetailByCode>(_onLoadDetailByCode);
    on<_ToggleWishlist>(_onToggleWishlist);
    on<_Invalidate>(_onInvalidate);
  }

  final GetCountryDetailUseCase _getCountryDetail;
  final GetCountryByCodeUseCase _getCountryByCode;
  final IsInWishlistUseCase _isInWishlist;
  final AddToWishlistUseCase _addToWishlist;
  final RemoveFromWishlistUseCase _removeFromWishlist;

  Future<void> _onLoadDetail(
    _LoadDetail event,
    Emitter<CountryDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        country: event.previewCountry,
        failure: null,
      ),
    );

    final results = await Future.wait([
      _getCountryDetail(event.name),
      _isInWishlist(event.previewCountry.cca2),
    ]);

    final detailResult = results[0] as Result<CountryEntity>;
    final wishlistResult = results[1] as Result<bool>;

    final isInWishlist = wishlistResult.fold(
      onSuccess: (v) => v,
      onFailure: (_) => false,
    );

    switch (detailResult) {
      case Error(:final error):
        emit(state.copyWith(isLoading: false, failure: error));
      case Success(:final value):
        emit(
          state.copyWith(
            isLoading: false,
            country: value,
            isInWishlist: isInWishlist,
          ),
        );
    }
  }

  Future<void> _onLoadDetailByCode(
    _LoadDetailByCode event,
    Emitter<CountryDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        country: event.previewCountry,
        failure: null,
      ),
    );

    final results = await Future.wait([
      _getCountryByCode(event.code),
      _isInWishlist(event.previewCountry.cca2),
    ]);

    final detailResult = results[0] as Result<CountryEntity>;
    final wishlistResult = results[1] as Result<bool>;

    final isInWishlist = wishlistResult.fold(
      onSuccess: (v) => v,
      onFailure: (_) => false,
    );

    switch (detailResult) {
      case Error(:final error):
        emit(state.copyWith(isLoading: false, failure: error));
      case Success(:final value):
        emit(
          state.copyWith(
            isLoading: false,
            country: value,
            isInWishlist: isInWishlist,
          ),
        );
    }
  }

  Future<void> _onToggleWishlist(
    _ToggleWishlist event,
    Emitter<CountryDetailState> emit,
  ) async {
    final wasInWishlist = state.isInWishlist;
    emit(state.copyWith(isInWishlist: !wasInWishlist));

    if (wasInWishlist) {
      await _removeFromWishlist(event.country.cca2);
    } else {
      await _addToWishlist(event.country);
    }
  }

  void _onInvalidate(_Invalidate event, Emitter<CountryDetailState> emit) {
    emit(state.copyWith(failure: null));
  }
}
