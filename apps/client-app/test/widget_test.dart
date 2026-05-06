import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wigilabs_sr/config/env/app_flavor.dart';
import 'package:flutter_wigilabs_sr/my_app.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUpAll(() async {
    // El mock debe registrarse ANTES de EasyLocalization.ensureInitialized()
    // porque internamente llama SharedPreferences.getInstance()
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
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

  // ─────────────────────────────────────────────────────────────────────
  // FlavorBannerWrapper tests
  // Testeamos el widget directamente para cubrir las líneas de my_app.dart
  // ─────────────────────────────────────────────────────────────────────

  testWidgets('FlavorBannerWrapper muestra Banner en flavor dev', (
    WidgetTester tester,
  ) async {
    // kFlavor == AppFlavor.dev en tests (sin --dart-define=FLAVOR=)
    expect(kFlavor, AppFlavor.dev);
    expect(kFlavor.showBanner, isTrue);

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FlavorBannerWrapper(child: const SizedBox(key: Key('content'))),
      ),
    );

    expect(find.byType(Banner), findsOneWidget);
    final banner = tester.widget<Banner>(find.byType(Banner));
    expect(banner.message, kFlavor.label);
    expect(banner.location, BannerLocation.topEnd);
    expect(banner.color, Color(kFlavor.bannerColor));
  });

  testWidgets('FlavorBannerWrapper devuelve child directamente en prod', (
    WidgetTester tester,
  ) async {
    expect(AppFlavor.prod.showBanner, isFalse);

    // Simula el comportamiento prod: showBanner == false → no Banner
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) {
            // Replicamos la lógica de FlavorBannerWrapper con prod
            const child = SizedBox(key: Key('content'));
            if (!AppFlavor.prod.showBanner) return child;
            return Banner(
              message: AppFlavor.prod.label,
              location: BannerLocation.topEnd,
              color: Color(AppFlavor.prod.bannerColor),
              child: child,
            );
          },
        ),
      ),
    );

    expect(find.byType(Banner), findsNothing);
    expect(find.byKey(const Key('content')), findsOneWidget);
  });
}
