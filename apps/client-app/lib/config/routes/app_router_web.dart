import 'package:bot_toast/bot_toast.dart';
import 'package:components/layout/scaffold_with_navigation.dart';
import 'package:core/enum/navigation_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feature_home/presentation/home/view/home_view.dart';
import 'package:feature_home/routes.dart';
import 'package:feature_settings/routes.dart';
import 'package:feature_wishlist/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    initialLocation: HomeView.path,
    observers: [BotToastNavigatorObserver()],
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavigation(
            logoPath: 'assets/logo.png',
            logoDarkPath: 'assets/logo_dark.png',
            key: ValueKey(context.locale.toString()),
            navigationShell: navigationShell,
            navigationItems: const [
              NavigationItem.home,
              NavigationItem.wishlist,
              NavigationItem.settings,
            ],
          );
        },
        branches: [homeRoutes, wishlistRoutes, settingsRoutes],
      ),
    ],
  );
}
