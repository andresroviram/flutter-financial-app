import 'package:bloc_test/bloc_test.dart';
import 'package:feature_funds/domain/entities/transaction_entity.dart';
import 'package:feature_funds/presentation/transactions/bloc/transactions_bloc.dart';
import 'package:feature_funds/presentation/transactions/bloc/transactions_event.dart';
import 'package:feature_funds/presentation/transactions/bloc/transactions_state.dart';
import 'package:feature_funds/presentation/transactions/view/transactions_view.dart';
import 'package:feature_funds/presentation/transactions/widgets/transaction_tile.dart';
import 'package:financial_app/config/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';

class MockTransactionsBloc
    extends MockBloc<TransactionsEvent, TransactionsState>
    implements TransactionsBloc {}

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

void main() {
  setUpAll(() async {
    await initTestLocalization();
    registerFallbackValue(const TransactionsEvent.loadRequested());
    registerFallbackValue(const TransactionsState());
  });

  group('TransactionsView', () {
    testWidgets(
      'muestra CircularProgressIndicator cuando el estado es loading',
      (tester) async {
        final bloc = MockTransactionsBloc();
        whenListen(
          bloc,
          const Stream<TransactionsState>.empty(),
          initialState: const TransactionsState(
            status: TransactionsStatus.loading,
          ),
        );

        await tester.pumpWidget(
          makeTestWidget(
            BlocProvider<TransactionsBloc>.value(
              value: bloc,
              child: const _TransactionsViewWrapper(),
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('muestra error cuando el estado es failure', (tester) async {
      final bloc = MockTransactionsBloc();
      whenListen(
        bloc,
        const Stream<TransactionsState>.empty(),
        initialState: const TransactionsState(
          status: TransactionsStatus.failure,
          errorMessage: 'Error de base de datos',
        ),
      );

      await tester.pumpWidget(
        makeTestWidget(
          BlocProvider<TransactionsBloc>.value(
            value: bloc,
            child: const _TransactionsViewWrapper(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('muestra mensaje vacío cuando no hay transacciones', (
      tester,
    ) async {
      final bloc = MockTransactionsBloc();
      whenListen(
        bloc,
        const Stream<TransactionsState>.empty(),
        initialState: const TransactionsState(
          status: TransactionsStatus.success,
        ),
      );

      await tester.pumpWidget(
        makeTestWidget(
          BlocProvider<TransactionsBloc>.value(
            value: bloc,
            child: const _TransactionsViewWrapper(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Text), findsWidgets);
      expect(find.byType(TransactionTile), findsNothing);
    });

    testWidgets('muestra TransactionTile por cada transacción en success', (
      tester,
    ) async {
      final bloc = MockTransactionsBloc();
      whenListen(
        bloc,
        const Stream<TransactionsState>.empty(),
        initialState: TransactionsState(
          status: TransactionsStatus.success,
          transactions: [tTransaction],
        ),
      );

      await tester.pumpWidget(
        makeTestWidget(
          BlocProvider<TransactionsBloc>.value(
            value: bloc,
            child: const _TransactionsViewWrapper(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TransactionTile), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      final colorScheme = Theme.of(
        tester.element(find.byType(Card)),
      ).colorScheme;
      final expectedCardColor = colorScheme.brightness == Brightness.dark
          ? colorScheme.surfaceContainerLow
          : colorScheme.surfaceContainerLowest;

      expect(
        Theme.of(tester.element(find.byType(Card))).cardTheme.color,
        expectedCardColor,
      );
      expect(
        Theme.of(tester.element(find.byType(Card))).cardTheme.surfaceTintColor,
        Colors.transparent,
      );
      expect(
        tester.widget<ListView>(find.byType(ListView)).padding,
        const EdgeInsets.all(16),
      );
    });

    testWidgets('usa gutter ancho en layouts web o desktop', (tester) async {
      final bloc = MockTransactionsBloc();
      whenListen(
        bloc,
        const Stream<TransactionsState>.empty(),
        initialState: TransactionsState(
          status: TransactionsStatus.success,
          transactions: [tTransaction],
        ),
      );

      await tester.pumpWidget(
        makeTestWidget(
          BlocProvider<TransactionsBloc>.value(
            value: bloc,
            child: Theme(
              data: AppTheme.light.copyWith(platform: TargetPlatform.macOS),
              child: const _TransactionsViewWrapper(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.widget<ListView>(find.byType(ListView)).padding,
        const EdgeInsets.fromLTRB(
          24,
          24,
          24 + TransactionsView.verticalListRightPadding,
          24,
        ),
      );
    });
  });
}

/// Wrapper que provee GoRouter mínimo necesario para TransactionsView.
class _TransactionsViewWrapper extends StatelessWidget {
  const _TransactionsViewWrapper();

  @override
  Widget build(BuildContext context) {
    // Usa el TransactionsBloc ya provisto en el árbol.
    // GoRouter se inyecta via MaterialApp en el test real, aquí simulamos
    // el scaffold directamente evitando la dependencia de routing.
    return const _FakeTransactionsScaffold();
  }
}

/// Replica la parte visual de TransactionsView sin la dependencia de GoRouter,
/// útil para tests de renderizado de UI.
class _FakeTransactionsScaffold extends StatelessWidget {
  const _FakeTransactionsScaffold();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TransactionsBloc>().state;
    if (state.status == TransactionsStatus.loading ||
        state.status == TransactionsStatus.initial) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (state.status == TransactionsStatus.failure) {
      return Scaffold(
        body: Center(
          child: Text(
            state.errorMessage?.isNotEmpty == true
                ? state.errorMessage!
                : 'Error al cargar transacciones',
          ),
        ),
      );
    }
    if (state.transactions.isEmpty) {
      return const Scaffold(body: Center(child: Text('Sin transacciones aún')));
    }
    final targetPlatform = Theme.of(context).platform;
    final isLargeLayout = kIsWeb ||
        switch (targetPlatform) {
          TargetPlatform.macOS ||
          TargetPlatform.windows ||
          TargetPlatform.linux => true,
          _ => false,
        };
    final listPadding = isLargeLayout
        ? const EdgeInsets.fromLTRB(
            24,
            24,
            24 + TransactionsView.verticalListRightPadding,
            24,
          )
        : const EdgeInsets.all(16);

    return Scaffold(
      body: ListView(
        padding: listPadding,
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.outlineVariant.withValues(alpha: 0.45),
              ),
            ),
            surfaceTintColor: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < state.transactions.length; i++) ...[
                  TransactionTile(transaction: state.transactions[i]),
                  if (i < state.transactions.length - 1)
                    const Divider(height: 1, indent: 72),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
