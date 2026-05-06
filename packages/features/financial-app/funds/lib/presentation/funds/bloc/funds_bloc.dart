import 'package:bloc/bloc.dart';
import 'package:core/errors/result.dart';
import 'package:feature_funds/domain/usecases/funds_usecases.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_event.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_state.dart';

class FundsBloc extends Bloc<FundsEvent, FundsState> {
  FundsBloc({
    required GetFundsUseCase getFunds,
    required GetBalanceUseCase getBalance,
    required SubscribeFundUseCase subscribeFund,
    required CancelFundUseCase cancelFund,
  }) : _getFunds = getFunds,
       _getBalance = getBalance,
       _subscribeFund = subscribeFund,
       _cancelFund = cancelFund,
       super(const FundsState()) {
    on<FundsLoadRequested>(_onLoad);
    on<FundsSubscribeRequested>(_onSubscribe);
    on<FundsCancelRequested>(_onCancel);
  }

  final GetFundsUseCase _getFunds;
  final GetBalanceUseCase _getBalance;
  final SubscribeFundUseCase _subscribeFund;
  final CancelFundUseCase _cancelFund;

  Future<void> _onLoad(
    FundsLoadRequested event,
    Emitter<FundsState> emit,
  ) async {
    emit(state.copyWith(status: FundsStatus.loading, errorMessage: null));
    final fundsResult = await _getFunds();
    final balanceResult = await _getBalance();
    fundsResult.fold(
      onSuccess: (funds) => emit(
        state.copyWith(
          status: FundsStatus.success,
          funds: funds,
          balance: balanceResult.valueOrNull ?? state.balance,
          errorMessage: null,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: FundsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> _onSubscribe(
    FundsSubscribeRequested event,
    Emitter<FundsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FundsStatus.subscribing,
        lastActionSuccess: false,
        errorMessage: null,
      ),
    );
    final result = await _subscribeFund(
      fundId: event.fundId,
      notificationMethod: event.notificationMethod,
    );
    await result.fold(
      onSuccess: (_) async {
        final fundsResult = await _getFunds();
        final balanceResult = await _getBalance();
        emit(
          state.copyWith(
            status: FundsStatus.success,
            funds: fundsResult.valueOrNull ?? state.funds,
            balance: balanceResult.valueOrNull ?? state.balance,
            lastActionSuccess: true,
            errorMessage: null,
          ),
        );
      },
      onFailure: (failure) async => emit(
        state.copyWith(
          status: FundsStatus.success,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> _onCancel(
    FundsCancelRequested event,
    Emitter<FundsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FundsStatus.canceling,
        lastActionSuccess: false,
        errorMessage: null,
      ),
    );
    final result = await _cancelFund(event.fundId);
    await result.fold(
      onSuccess: (_) async {
        final fundsResult = await _getFunds();
        final balanceResult = await _getBalance();
        emit(
          state.copyWith(
            status: FundsStatus.success,
            funds: fundsResult.valueOrNull ?? state.funds,
            balance: balanceResult.valueOrNull ?? state.balance,
            lastActionSuccess: true,
            errorMessage: null,
          ),
        );
      },
      onFailure: (failure) async => emit(
        state.copyWith(
          status: FundsStatus.success,
          errorMessage: failure.message,
        ),
      ),
    );
  }
}
