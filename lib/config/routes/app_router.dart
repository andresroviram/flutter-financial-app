import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_wigilabs_sr/components/layout/scaffold_with_navigation.dart';
import 'package:flutter_wigilabs_sr/core/constants/app_constants.dart';
import 'package:flutter_wigilabs_sr/modules/home/presentation/country_detail/view/country_detail_view.dart';
import 'package:flutter_wigilabs_sr/modules/home/presentation/home/view/home_view.dart';
import 'package:flutter_wigilabs_sr/modules/home/routes.dart';
import 'package:flutter_wigilabs_sr/modules/settings/routes.dart';
import 'package:flutter_wigilabs_sr/modules/wishlist/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import '../../modules/home/domain/entities/country_entity.dart';

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
          path: CountryDetailView.pathMobile,
          name: CountryDetailView.name,
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
