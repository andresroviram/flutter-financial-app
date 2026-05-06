import 'package:bloc_test/bloc_test.dart';
import 'package:core/errors/error.dart';
import 'package:core/errors/result.dart';
import 'package:feature_funds/domain/entities/transaction_entity.dart';
import 'package:feature_funds/domain/usecases/funds_usecases.dart';
import 'package:feature_funds/presentation/transactions/bloc/transactions_bloc.dart';
import 'package:feature_funds/presentation/transactions/bloc/transactions_event.dart';
import 'package:feature_funds/presentation/transactions/bloc/transactions_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTransactionsUseCase extends Mock
    implements GetTransactionsUseCase {}

final tDate = DateTime(2025, 3, 1, 10, 30);

final tTransaction = TransactionEntity(
  id: 'tx-1',
  fundId: '1',
  fundName: 'FPV_BTG_PACTUAL_RECAUDADORA',
  type: TransactionType.subscribe,
  amount: 75000,
  date: tDate,
  notificationMethod: NotificationMethod.email,
);

final tTransactions = [tTransaction];

void main() {
  late MockGetTransactionsUseCase mockGetTransactions;

  setUp(() {
    mockGetTransactions = MockGetTransactionsUseCase();
  });

  TransactionsBloc buildBloc() =>
      TransactionsBloc(getTransactions: mockGetTransactions);

  group('TransactionsBloc', () {
    group('TransactionsLoadRequested', () {
      blocTest<TransactionsBloc, TransactionsState>(
        'emite [loading, success] con transacciones cuando la carga es exitosa',
        setUp: () {
          when(
            () => mockGetTransactions(),
          ).thenAnswer((_) async => Success(tTransactions));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const TransactionsEvent.loadRequested()),
        expect: () => [
          const TransactionsState(status: TransactionsStatus.loading),
          TransactionsState(
            status: TransactionsStatus.success,
            transactions: tTransactions,
          ),
        ],
        verify: (_) => verify(() => mockGetTransactions()).called(1),
      );

      blocTest<TransactionsBloc, TransactionsState>(
        'emite [loading, success] con lista vacía cuando no hay transacciones',
        setUp: () {
          when(
            () => mockGetTransactions(),
          ).thenAnswer((_) async => const Success([]));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const TransactionsEvent.loadRequested()),
        expect: () => [
          const TransactionsState(status: TransactionsStatus.loading),
          const TransactionsState(status: TransactionsStatus.success),
        ],
      );

      blocTest<TransactionsBloc, TransactionsState>(
        'emite [loading, failure] con mensaje cuando la carga falla',
        setUp: () {
          when(() => mockGetTransactions()).thenAnswer(
            (_) async => const Error(
              UnknownFailure(message: 'Error al leer la base de datos'),
            ),
          );
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const TransactionsEvent.loadRequested()),
        expect: () => [
          const TransactionsState(status: TransactionsStatus.loading),
          const TransactionsState(
            status: TransactionsStatus.failure,
            errorMessage: 'Error al leer la base de datos',
          ),
        ],
      );
    });
  });
}
