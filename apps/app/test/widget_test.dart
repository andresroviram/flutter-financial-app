import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wigilabs_sr/my_app.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();

    if (!GetIt.instance.isRegistered<GoRouter>()) {
      GetIt.instance.registerSingleton<GoRouter>(
        GoRouter(
          routes: [GoRoute(path: '/', builder: (_, _) => const SizedBox())],
        ),
      );
    }
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  testWidgets('MyApp arranca sin errores', (WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('es'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('es'),
        child: const MyApp(),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
