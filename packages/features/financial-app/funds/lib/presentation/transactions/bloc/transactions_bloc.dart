import 'package:bloc/bloc.dart';
import '../../../domain/usecases/funds_usecases.dart';
import 'transactions_event.dart';
import 'transactions_state.dart';

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
    emit(state.copyWith(status: TransactionsStatus.loading));
    final (transactions, failure) = await _getTransactions();
    if (failure != null) {
      emit(
        state.copyWith(
          status: TransactionsStatus.failure,
          errorMessage: failure.message,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: TransactionsStatus.success,
        transactions: transactions,
      ),
    );
  }
}
