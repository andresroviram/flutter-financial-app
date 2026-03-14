import 'package:feature_funds/presentation/funds/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('SectionTitle', () {
    testWidgets('muestra el título correctamente', (tester) async {
      await tester.pumpWidget(
        _wrap(const SectionTitle(title: 'Fondos suscritos', count: 3)),
      );

      expect(find.text('Fondos suscritos'), findsOneWidget);
    });

    testWidgets('muestra el contador en el badge', (tester) async {
      await tester.pumpWidget(
        _wrap(const SectionTitle(title: 'Disponibles', count: 5)),
      );

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('badge muestra 0 cuando count es cero', (tester) async {
      await tester.pumpWidget(
        _wrap(const SectionTitle(title: 'Suscritos', count: 0)),
      );

      expect(find.text('0'), findsOneWidget);
    });
  });
}
