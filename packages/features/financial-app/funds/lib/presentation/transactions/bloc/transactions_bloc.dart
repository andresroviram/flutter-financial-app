import 'package:bloc/bloc.dart';
import 'package:core/errors/result.dart';
import 'package:feature_funds/domain/usecases/funds_usecases.dart';
import 'package:feature_funds/presentation/transactions/bloc/transactions_event.dart';
import 'package:feature_funds/presentation/transactions/bloc/transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc({required GetTransactionsUseCase getTransactions})
    : _getTransactions = getTransactions,
      super(const TransactionsState()) {
    on<TransactionsLoadRequested>(_onLoad);
  }

  final GetTransactionsUseCase _getTransactions;

  Future<void> _onLoad(
    TransactionsLoadRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(
      state.copyWith(status: TransactionsStatus.loading, errorMessage: null),
    );
    final result = await _getTransactions();
    result.fold(
      onSuccess: (transactions) => emit(
        state.copyWith(
          status: TransactionsStatus.success,
          transactions: transactions,
          errorMessage: null,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: TransactionsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }
}
