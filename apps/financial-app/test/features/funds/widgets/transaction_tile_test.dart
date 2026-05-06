import 'package:feature_funds/domain/entities/transaction_entity.dart';
import 'package:feature_funds/presentation/transactions/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

final tDate = DateTime(2025, 3, 1, 10, 30);

final tSubscribeTx = TransactionEntity(
  id: 'tx-1',
  fundId: '1',
  fundName: 'FPV_BTG_PACTUAL_RECAUDADORA',
  type: TransactionType.subscribe,
  amount: 75000,
  date: tDate,
  notificationMethod: NotificationMethod.email,
);

final tCancelTx = TransactionEntity(
  id: 'tx-2',
  fundId: '2',
  fundName: 'DEUDAPRIVADA',
  type: TransactionType.cancel,
  amount: 50000,
  date: tDate,
  notificationMethod: NotificationMethod.sms,
);

void main() {
  setUpAll(initTestLocalization);

  group('TransactionTile', () {
    testWidgets('muestra el nombre del fondo', (tester) async {
      await tester.pumpWidget(
        makeTestWidget(
          Scaffold(body: TransactionTile(transaction: tSubscribeTx)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('FPV_BTG_PACTUAL_RECAUDADORA'), findsOneWidget);
    });

    testWidgets('muestra ícono trending_up en transacción de suscripción', (
      tester,
    ) async {
      await tester.pumpWidget(
        makeTestWidget(
          Scaffold(body: TransactionTile(transaction: tSubscribeTx)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.trending_up), findsOneWidget);
    });

    testWidgets('muestra ícono trending_down en transacción de cancelación', (
      tester,
    ) async {
      await tester.pumpWidget(
        makeTestWidget(Scaffold(body: TransactionTile(transaction: tCancelTx))),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.trending_down), findsOneWidget);
    });

    testWidgets('renderiza sin excepciones para transacción subscribe', (
      tester,
    ) async {
      await tester.pumpWidget(
        makeTestWidget(
          Scaffold(body: TransactionTile(transaction: tSubscribeTx)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TransactionTile), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renderiza sin excepciones para transacción cancel', (
      tester,
    ) async {
      await tester.pumpWidget(
        makeTestWidget(Scaffold(body: TransactionTile(transaction: tCancelTx))),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TransactionTile), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('muestra el nombre del fondo en subscribe', (tester) async {
      await tester.pumpWidget(
        makeTestWidget(
          Scaffold(body: TransactionTile(transaction: tSubscribeTx)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('FPV_BTG_PACTUAL_RECAUDADORA'), findsOneWidget);
    });

    testWidgets('incluye separador de fecha y notificación en subtitle', (
      tester,
    ) async {
      await tester.pumpWidget(
        makeTestWidget(
          Scaffold(body: TransactionTile(transaction: tSubscribeTx)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('·'), findsOneWidget);
    });

    testWidgets('muestra icono correcto para cancelación', (tester) async {
      await tester.pumpWidget(
        makeTestWidget(Scaffold(body: TransactionTile(transaction: tCancelTx))),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.trending_down), findsOneWidget);
    });
  });
}
