import 'package:bloc/bloc.dart';
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
    final (funds, fundsFailure) = await _getFunds();
    final (balance, _) = await _getBalance();
    if (fundsFailure != null) {
      emit(
        state.copyWith(
          status: FundsStatus.failure,
          errorMessage: fundsFailure.message,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: FundsStatus.success,
        funds: funds,
        balance: balance,
        errorMessage: null,
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
    final (_, failure) = await _subscribeFund(
      fundId: event.fundId,
      notificationMethod: event.notificationMethod,
    );
    if (failure != null) {
      emit(
        state.copyWith(
          status: FundsStatus.success,
          errorMessage: failure.message,
        ),
      );
      return;
    }
    final (funds, _) = await _getFunds();
    final (balance, _) = await _getBalance();
    emit(
      state.copyWith(
        status: FundsStatus.success,
        funds: funds,
        balance: balance,
        lastActionSuccess: true,
        errorMessage: null,
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
    final (_, failure) = await _cancelFund(event.fundId);
    if (failure != null) {
      emit(
        state.copyWith(
          status: FundsStatus.success,
          errorMessage: failure.message,
        ),
      );
      return;
    }
    final (funds, _) = await _getFunds();
    final (balance, _) = await _getBalance();
    emit(
      state.copyWith(
        status: FundsStatus.success,
        funds: funds,
        balance: balance,
        lastActionSuccess: true,
        errorMessage: null,
      ),
    );
  }
}
