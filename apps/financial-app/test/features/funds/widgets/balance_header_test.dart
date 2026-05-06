import 'package:feature_funds/presentation/funds/widgets/balance_header.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  setUpAll(initTestLocalization);

  group('BalanceHeader', () {
    testWidgets('renderiza sin excepciones con saldo positivo', (tester) async {
      await tester.pumpWidget(
        makeTestWidget(const BalanceHeader(balance: 500000)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(BalanceHeader), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renderiza sin excepciones con saldo cero', (tester) async {
      await tester.pumpWidget(makeTestWidget(const BalanceHeader(balance: 0)));
      await tester.pumpAndSettle();

      expect(find.byType(BalanceHeader), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renderiza sin excepciones con saldo alto', (tester) async {
      await tester.pumpWidget(
        makeTestWidget(const BalanceHeader(balance: 100000)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(BalanceHeader), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
