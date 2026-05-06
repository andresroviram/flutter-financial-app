import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_wigilabs_sr/components/layout/scaffold_with_navigation.dart';
import 'package:flutter_wigilabs_sr/modules/home/presentation/home/view/home_view.dart';
import 'package:flutter_wigilabs_sr/modules/home/routes.dart';
import 'package:flutter_wigilabs_sr/modules/settings/routes.dart';
import 'package:flutter_wigilabs_sr/modules/wishlist/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

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
