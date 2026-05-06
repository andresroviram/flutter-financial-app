import 'package:bot_toast/bot_toast.dart';
import 'package:core/entities/country_entity.dart';
import 'package:design_system/layout/scaffold_with_navigation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feature_home/presentation/country_detail/view/country_detail_view.dart';
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
      GoRoute(
        path: CountryDetailView.pathMobile,
        name: CountryDetailView.nameMobile,
        builder: (context, state) {
          final country = state.extra as CountryEntity;
          return CountryDetailView.create(country: country);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return SelectionArea(
            child: ScaffoldWithNavigation(
              key: ValueKey(context.locale.toString()),
              navigationShell: navigationShell,
            ),
          );
        },
        branches: [homeRoutes, wishlistRoutes, settingsRoutes],
      ),
    ],
  );
}
