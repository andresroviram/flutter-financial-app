import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_wigilabs_sr/components/layout/scaffold_with_navigation.dart';
import 'package:flutter_wigilabs_sr/core/constants/app_constants.dart';
import 'package:flutter_wigilabs_sr/features/home/presentation/country_detail/view/country_detail_view.dart';
import 'package:flutter_wigilabs_sr/features/home/presentation/home/view/home_view.dart';
import 'package:flutter_wigilabs_sr/features/home/routes.dart';
import 'package:flutter_wigilabs_sr/features/settings/routes.dart';
import 'package:flutter_wigilabs_sr/features/wishlist/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import '../../features/home/domain/entities/country_entity.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@module
abstract class RouterModule {
  @singleton
  GoRouter get router => GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    initialLocation: HomeView.path,
    observers: [BotToastNavigatorObserver()],
    routes: [
      if (!AppConstants.isWeb)
        GoRoute(
          path: CountryDetailView.path,
          name: CountryDetailView.name,
          builder: (context, state) {
            final country = state.extra as CountryEntity;
            return CountryDetailView.create(country: country);
          },
        ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return SelectionArea(
            child: ScaffoldWithNavigation(navigationShell: navigationShell),
          );
        },
        branches: [homeRoutes, wishlistRoutes, settingsRoutes],
      ),
    ],
  );
}
