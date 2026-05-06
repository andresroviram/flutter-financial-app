import 'package:bloc_test/bloc_test.dart';
import 'package:core/errors/error.dart';
import 'package:core/errors/result.dart';
import 'package:feature_funds/domain/entities/fund_entity.dart';
import 'package:feature_funds/domain/entities/transaction_entity.dart';
import 'package:feature_funds/domain/usecases/funds_usecases.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_bloc.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_event.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFundsUseCase extends Mock implements GetFundsUseCase {}

class MockGetBalanceUseCase extends Mock implements GetBalanceUseCase {}

class MockSubscribeFundUseCase extends Mock implements SubscribeFundUseCase {}

class MockCancelFundUseCase extends Mock implements CancelFundUseCase {}

const tFund = FundEntity(
  id: '1',
  name: 'FPV_BTG_PACTUAL_RECAUDADORA',
  minimumAmount: 75000,
  category: FundCategory.fpv,
);

final tFundSubscribed = tFund.copyWith(
  isSubscribed: true,
  subscribedAmount: 75000,
);

final tFunds = [tFund];
final tFundsSubscribed = [tFundSubscribed];

void main() {
  late MockGetFundsUseCase mockGetFunds;
  late MockGetBalanceUseCase mockGetBalance;
  late MockSubscribeFundUseCase mockSubscribeFund;
  late MockCancelFundUseCase mockCancelFund;

  setUpAll(() {
    registerFallbackValue(NotificationMethod.email);
  });

  setUp(() {
    mockGetFunds = MockGetFundsUseCase();
    mockGetBalance = MockGetBalanceUseCase();
    mockSubscribeFund = MockSubscribeFundUseCase();
    mockCancelFund = MockCancelFundUseCase();
  });

  FundsBloc buildBloc() => FundsBloc(
    getFunds: mockGetFunds,
    getBalance: mockGetBalance,
    subscribeFund: mockSubscribeFund,
    cancelFund: mockCancelFund,
  );

  group('FundsBloc', () {
    group('FundsLoadRequested', () {
      blocTest<FundsBloc, FundsState>(
        'emite [loading, success] cuando la carga es exitosa',
        setUp: () {
          when(() => mockGetFunds()).thenAnswer((_) async => Success(tFunds));
          when(
            () => mockGetBalance(),
          ).thenAnswer((_) async => const Success(500000));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const FundsEvent.loadRequested()),
        expect: () => [
          const FundsState(status: FundsStatus.loading),
          FundsState(status: FundsStatus.success, funds: tFunds),
        ],
        verify: (_) {
          verify(() => mockGetFunds()).called(1);
          verify(() => mockGetBalance()).called(1);
        },
      );

      blocTest<FundsBloc, FundsState>(
        'emite [loading, failure] cuando getFunds falla',
        setUp: () {
          when(() => mockGetFunds()).thenAnswer(
            (_) async => const Error(UnknownFailure(message: 'DB error')),
          );
          when(
            () => mockGetBalance(),
          ).thenAnswer((_) async => const Success(500000));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const FundsEvent.loadRequested()),
        expect: () => [
          const FundsState(status: FundsStatus.loading),
          const FundsState(
            status: FundsStatus.failure,
            errorMessage: 'DB error',
          ),
        ],
      );
    });

    group('FundsSubscribeRequested', () {
      blocTest<FundsBloc, FundsState>(
        'emite [subscribing, success] y refresca fondos al suscribirse',
        setUp: () {
          when(
            () => mockSubscribeFund(
              fundId: any(named: 'fundId'),
              notificationMethod: any(named: 'notificationMethod'),
            ),
          ).thenAnswer((_) async => const Success(null));
          when(
            () => mockGetFunds(),
          ).thenAnswer((_) async => Success(tFundsSubscribed));
          when(
            () => mockGetBalance(),
          ).thenAnswer((_) async => const Success(425000));
        },
        seed: () => FundsState(status: FundsStatus.success, funds: tFunds),
        build: buildBloc,
        act: (bloc) => bloc.add(
          const FundsEvent.subscribeRequested(
            fundId: '1',
            notificationMethod: NotificationMethod.email,
          ),
        ),
        expect: () => [
          FundsState(status: FundsStatus.subscribing, funds: tFunds),
          FundsState(
            status: FundsStatus.success,
            funds: tFundsSubscribed,
            balance: 425000,
            lastActionSuccess: true,
          ),
        ],
      );

      blocTest<FundsBloc, FundsState>(
        'emite [subscribing, success(errorMessage)] cuando suscripción falla',
        setUp: () {
          when(
            () => mockSubscribeFund(
              fundId: any(named: 'fundId'),
              notificationMethod: any(named: 'notificationMethod'),
            ),
          ).thenAnswer(
            (_) async =>
                const Error(UnknownFailure(message: 'Saldo insuficiente')),
          );
        },
        seed: () =>
            FundsState(status: FundsStatus.success, funds: tFunds, balance: 0),
        build: buildBloc,
        act: (bloc) => bloc.add(
          const FundsEvent.subscribeRequested(
            fundId: '1',
            notificationMethod: NotificationMethod.sms,
          ),
        ),
        expect: () => [
          FundsState(
            status: FundsStatus.subscribing,
            funds: tFunds,
            balance: 0,
          ),
          FundsState(
            status: FundsStatus.success,
            funds: tFunds,
            balance: 0,
            errorMessage: 'Saldo insuficiente',
          ),
        ],
      );
    });

    group('FundsCancelRequested', () {
      blocTest<FundsBloc, FundsState>(
        'emite [canceling, success] y refresca fondos al cancelar',
        setUp: () {
          when(
            () => mockCancelFund(any()),
          ).thenAnswer((_) async => const Success(null));
          when(() => mockGetFunds()).thenAnswer((_) async => Success(tFunds));
          when(
            () => mockGetBalance(),
          ).thenAnswer((_) async => const Success(575000));
        },
        seed: () =>
            FundsState(status: FundsStatus.success, funds: tFundsSubscribed),
        build: buildBloc,
        act: (bloc) => bloc.add(const FundsEvent.cancelRequested('1')),
        expect: () => [
          FundsState(status: FundsStatus.canceling, funds: tFundsSubscribed),
          FundsState(
            status: FundsStatus.success,
            funds: tFunds,
            balance: 575000,
            lastActionSuccess: true,
          ),
        ],
      );

      blocTest<FundsBloc, FundsState>(
        'emite [canceling, success(errorMessage)] cuando cancelación falla',
        setUp: () {
          when(() => mockCancelFund(any())).thenAnswer(
            (_) async => const Error(
              UnknownFailure(message: 'No suscrito a este fondo'),
            ),
          );
        },
        seed: () =>
            FundsState(status: FundsStatus.success, funds: tFundsSubscribed),
        build: buildBloc,
        act: (bloc) => bloc.add(const FundsEvent.cancelRequested('1')),
        expect: () => [
          FundsState(status: FundsStatus.canceling, funds: tFundsSubscribed),
          FundsState(
            status: FundsStatus.success,
            funds: tFundsSubscribed,
            errorMessage: 'No suscrito a este fondo',
          ),
        ],
      );
    });
  });
}
