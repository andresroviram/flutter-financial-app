import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'config/injectable/injectable_dependency.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  configureDependencies();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('es'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('es'),
      child: const MyApp(),
    ),
  );
}
