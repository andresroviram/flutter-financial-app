import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wigilabs_sr/core/constants/app_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'config/injectable/injectable_dependency.dart';
import 'config/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const title = AppConstants.appName;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: AppTheme.light,
      dark: AppTheme.dark,
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => ResponsiveBreakpoints.builder(
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 960, name: TABLET),
          const Breakpoint(start: 961, end: double.infinity, name: DESKTOP),
        ],
        child: MaterialApp.router(
          title: MyApp.title,
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: getIt<GoRouter>(),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        ),
      ),
    );
  }
}
