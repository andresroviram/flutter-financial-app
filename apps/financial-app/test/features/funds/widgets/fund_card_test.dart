import 'package:feature_funds/domain/entities/fund_entity.dart';
import 'package:feature_funds/domain/entities/transaction_entity.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_state.dart';
import 'package:feature_funds/presentation/funds/widgets/fund_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

const tFundAvailable = FundEntity(
  id: '1',
  name: 'FPV_BTG_PACTUAL_RECAUDADORA',
  minimumAmount: 75000,
  category: FundCategory.fpv,
);

final tFundSubscribed = tFundAvailable.copyWith(
  isSubscribed: true,
  subscribedAmount: 75000,
);

void main() {
  setUpAll(initTestLocalization);

  Finder anyButton() => find.byWidgetPredicate((w) => w is ButtonStyleButton);

  group('FundCard', () {
    testWidgets('muestra el nombre del fondo', (tester) async {
      await tester.pumpWidget(
        makeTestWidget(
          FundCard(
            fund: tFundAvailable,
            fundsStatus: FundsStatus.success,
            onSubscribe: (_) {},
            onCancel: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('FPV_BTG_PACTUAL_RECAUDADORA'), findsOneWidget);
    });

    testWidgets('renderiza botón para fondo disponible', (tester) async {
      await tester.pumpWidget(
        makeTestWidget(
          FundCard(
            fund: tFundAvailable,
            fundsStatus: FundsStatus.success,
            onSubscribe: (_) {},
            onCancel: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FundCard), findsOneWidget);
      expect(anyButton(), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renderiza botón para fondo suscrito', (tester) async {
      await tester.pumpWidget(
        makeTestWidget(
          FundCard(
            fund: tFundSubscribed,
            fundsStatus: FundsStatus.success,
            onSubscribe: (_) {},
            onCancel: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(anyButton(), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('llama onSubscribe al confirmar diálogo', (tester) async {
      NotificationMethod? receivedMethod;
      await tester.pumpWidget(
        makeTestWidget(
          FundCard(
            fund: tFundAvailable,
            fundsStatus: FundsStatus.success,
            onSubscribe: (m) => receivedMethod = m,
            onCancel: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(anyButton());
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();

      expect(receivedMethod, isNotNull);
    });

    testWidgets('llama onCancel al presionar acción de fondo suscrito', (
      tester,
    ) async {
      var canceled = false;
      await tester.pumpWidget(
        makeTestWidget(
          FundCard(
            fund: tFundSubscribed,
            fundsStatus: FundsStatus.success,
            onSubscribe: (_) {},
            onCancel: () => canceled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(anyButton());
      await tester.pumpAndSettle();

      expect(canceled, isTrue);
    });
  });
}
