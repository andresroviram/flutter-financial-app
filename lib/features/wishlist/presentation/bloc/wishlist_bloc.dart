import 'package:bloc/bloc.dart';
import 'package:flutter_wigilabs_sr/core/result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../../core/error/error.dart';
import '../../../home/domain/entities/country_entity.dart';
import '../../domain/usecases/wishlist_usecases.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';
part 'wishlist_bloc.freezed.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc({
    required GetWishlistUseCase getWishlist,
    required RemoveFromWishlistUseCase removeFromWishlist,
  })  : _getWishlist = getWishlist,
        _removeFromWishlist = removeFromWishlist,
        super(const WishlistState()) {
    on<_LoadWishlist>(_onLoadWishlist);
    on<_RemoveFromWishlist>(_onRemoveFromWishlist);
  }

  final GetWishlistUseCase _getWishlist;
  final RemoveFromWishlistUseCase _removeFromWishlist;

  Future<void> _onLoadWishlist(
    _LoadWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, failure: null));
    final result = await _getWishlist();
    result.fold(
      onSuccess: (wishlist) =>
          emit(state.copyWith(isLoading: false, wishlist: wishlist)),
      onFailure: (failure) =>
          emit(state.copyWith(isLoading: false, failure: failure)),
    );
  }

  Future<void> _onRemoveFromWishlist(
    _RemoveFromWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    final updated = state.wishlist.where((c) => c.cca2 != event.cca2).toList();
    emit(state.copyWith(wishlist: updated));

    final result = await _removeFromWishlist(event.cca2);
    result.fold(
      onSuccess: (_) => null,
      onFailure: (failure) {
        add(const WishlistEvent.loadWishlist());
      },
    );
  }
}
