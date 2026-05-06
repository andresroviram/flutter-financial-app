import 'package:easy_localization/easy_localization.dart';
import 'package:financial_app/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _TestAssetLoader extends AssetLoader {
  const _TestAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async => {
    'funds': {
      'title': 'Fondos',
      'balance': 'Saldo disponible',
      'available': 'Fondos Disponibles',
      'subscribed': 'Fondos Suscritos',
      'subscribe': 'Suscribirse',
      'cancel': 'Cancelar suscripcion',
      'subscribed_badge': 'Suscrito',
      'minimum_amount': 'Monto minimo: {}',
      'error_loading': 'Error al cargar fondos',
      'retry': 'Reintentar',
      'empty': 'Sin fondos disponibles',
      'dialog': {
        'confirm_title': 'Confirmar suscripcion',
        'fund_label': 'Fondo: {}',
        'notification_method': 'Metodo de notificacion:',
        'email': 'Email',
        'sms': 'SMS',
        'cancel': 'Cancelar',
        'confirm': 'Confirmar',
      },
    },
    'transactions': {
      'subscribe': 'Suscripcion',
      'cancel': 'Cancelacion',
      'empty': 'Sin transacciones aun',
      'error_loading': 'Error al cargar transacciones',
    },
  };
}

Future<void> initTestLocalization() async {
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
}

/// Envuelve [child] con MaterialApp + EasyLocalization en español.
/// Usa [withBreakpoints] para tests que necesiten ResponsiveBreakpoints.of(context).
Widget makeTestWidget(Widget child, {bool withBreakpoints = false}) {
  final Widget home = withBreakpoints
      ? ResponsiveBreakpoints.builder(
          breakpoints: const [
            Breakpoint(start: 0, end: 450, name: MOBILE),
            Breakpoint(start: 451, end: 960, name: TABLET),
            Breakpoint(start: 961, end: double.infinity, name: DESKTOP),
          ],
          child: child,
        )
      : child;

  return EasyLocalization(
    assetLoader: const _TestAssetLoader(),
    supportedLocales: const [Locale('es')],
    path: 'assets/translations',
    fallbackLocale: const Locale('es'),
    child: Builder(
      builder: (ctx) => MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        localizationsDelegates: ctx.localizationDelegates,
        supportedLocales: ctx.supportedLocales,
        locale: const Locale('es'),
        home: home,
      ),
    ),
  );
}
