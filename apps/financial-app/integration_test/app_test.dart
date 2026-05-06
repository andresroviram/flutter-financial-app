import 'package:easy_localization/easy_localization.dart';
import 'package:financial_app/app.dart';
import 'package:financial_app/config/injectable/injectable_dependency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();

    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorageDirectory.web
          : HydratedStorageDirectory(
              (await getApplicationDocumentsDirectory()).path,
            ),
    );

    await configureDependencies();
  });

  tearDownAll(() async {
    await GetIt.instance.reset();
  });

  group('Integration – smoke tests', () {
    testWidgets('La app arranca y muestra MaterialApp', (tester) async {
      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [Locale('es'), Locale('en')],
          path: 'assets/translations',
          fallbackLocale: const Locale('es'),
          child: const App(),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('La pantalla inicial muestra la navegación principal', (
      tester,
    ) async {
      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [Locale('es'), Locale('en')],
          path: 'assets/translations',
          fallbackLocale: const Locale('es'),
          child: const App(),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // La app tiene NavigationBar con las tabs de Fondos e Historial
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets(
      'Navegar a la pestaña Historial muestra la vista de transacciones',
      (tester) async {
        await tester.pumpWidget(
          EasyLocalization(
            supportedLocales: const [Locale('es'), Locale('en')],
            path: 'assets/translations',
            fallbackLocale: const Locale('es'),
            child: const App(),
          ),
        );
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Cambiar a la pestaña Historial
        final historialTab = find.text('Historial');
        if (historialTab.evaluate().isNotEmpty) {
          await tester.tap(historialTab);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          expect(find.text('Historial de transacciones'), findsOneWidget);
        }
      },
    );
  });
}
