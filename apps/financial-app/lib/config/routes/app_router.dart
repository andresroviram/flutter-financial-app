import 'package:bot_toast/bot_toast.dart';
import 'package:components/language_switcher.dart';
import 'package:components/layout/scaffold_with_navigation.dart';
import 'package:components/theme_button.dart';
import 'package:core/enum/navigation_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feature_funds/presentation/funds/view/funds_view.dart';
import 'package:feature_funds/routes.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RouterModule {
  @singleton
  GoRouter get router => _createRouter();
}

GoRouter _createRouter() {
  final rootKey = GlobalKey<NavigatorState>();
  return GoRouter(
    navigatorKey: rootKey,
    debugLogDiagnostics: kDebugMode,
    initialLocation: FundsView.path,
    observers: [BotToastNavigatorObserver()],
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavigation(
            appBarActions: [
              const ThemeModeButton.icon(),
              const LanguageSwitcherButton(),
              const Gap(2),
            ],
            logoPath: 'assets/img/logo.png',
            logoDarkPath: 'assets/img/logo_dark.png',
            key: ValueKey(context.locale.toString()),
            navigationShell: navigationShell,
            navigationItems: const [
              NavigationItem.funds,
              NavigationItem.transactions,
            ],
          );
        },
        branches: [fundsRoutes, transactionsRoutes],
      ),
    ],
  );
}
