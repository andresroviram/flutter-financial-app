import 'package:bloc_test/bloc_test.dart';
import 'package:feature_funds/domain/entities/fund_entity.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_bloc.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_event.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_state.dart';
import 'package:feature_funds/presentation/funds/view/funds_mobile.dart';
import 'package:feature_funds/presentation/funds/widgets/balance_header.dart';
import 'package:feature_funds/presentation/funds/widgets/fund_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';

class MockFundsBloc extends MockBloc<FundsEvent, FundsState>
    implements FundsBloc {}

const tFund = FundEntity(
  id: '1',
  name: 'FPV_BTG_PACTUAL_RECAUDADORA',
  minimumAmount: 75000,
  category: FundCategory.fpv,
);

void main() {
  setUpAll(() async {
    await initTestLocalization();
    registerFallbackValue(const FundsEvent.loadRequested());
    registerFallbackValue(const FundsState());
  });

  group('FundsMobile', () {
    Widget buildSubject(FundsBloc bloc) => makeTestWidget(
      BlocProvider<FundsBloc>.value(value: bloc, child: const FundsMobile()),
    );

    testWidgets(
      'muestra CircularProgressIndicator cuando el estado es loading',
      (tester) async {
        final bloc = MockFundsBloc();
        whenListen(
          bloc,
          const Stream<FundsState>.empty(),
          initialState: const FundsState(status: FundsStatus.loading),
        );

        await tester.pumpWidget(buildSubject(bloc));
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('muestra ícono de error y botón reintentar en estado failure', (
      tester,
    ) async {
      final bloc = MockFundsBloc();
      whenListen(
        bloc,
        const Stream<FundsState>.empty(),
        initialState: const FundsState(
          status: FundsStatus.failure,
          errorMessage: 'Error de prueba',
        ),
      );

      await tester.pumpWidget(buildSubject(bloc));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Error de prueba'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets(
      'reintentar dispara FundsLoadRequested al presionar el botón retry',
      (tester) async {
        final bloc = MockFundsBloc();
        whenListen(
          bloc,
          const Stream<FundsState>.empty(),
          initialState: const FundsState(
            status: FundsStatus.failure,
            errorMessage: 'Fallo de red',
          ),
        );

        await tester.pumpWidget(buildSubject(bloc));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FilledButton));
        await tester.pumpAndSettle();

        verify(() => bloc.add(const FundsEvent.loadRequested())).called(1);
      },
    );

    testWidgets(
      'muestra BalanceHeader y FundCards cuando el estado es success con fondos',
      (tester) async {
        final bloc = MockFundsBloc();
        whenListen(
          bloc,
          const Stream<FundsState>.empty(),
          initialState: const FundsState(
            status: FundsStatus.success,
            funds: [tFund],
          ),
        );

        await tester.pumpWidget(buildSubject(bloc));
        await tester.pumpAndSettle();

        expect(find.byType(BalanceHeader), findsOneWidget);
        expect(find.byType(FundCard), findsWidgets);
      },
    );

    testWidgets(
      'muestra BalanceHeader pero no FundCards cuando la lista de fondos está vacía',
      (tester) async {
        final bloc = MockFundsBloc();
        whenListen(
          bloc,
          const Stream<FundsState>.empty(),
          initialState: const FundsState(status: FundsStatus.success),
        );

        await tester.pumpWidget(buildSubject(bloc));
        await tester.pumpAndSettle();

        expect(find.byType(BalanceHeader), findsOneWidget);
        expect(find.byType(FundCard), findsNothing);
      },
    );

    testWidgets('muestra vista de error cuando errorMessage está vacío', (
      tester,
    ) async {
      final bloc = MockFundsBloc();
      whenListen(
        bloc,
        const Stream<FundsState>.empty(),
        initialState: const FundsState(
          status: FundsStatus.failure,
          errorMessage: '',
        ),
      );

      await tester.pumpWidget(buildSubject(bloc));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });
  });
}
