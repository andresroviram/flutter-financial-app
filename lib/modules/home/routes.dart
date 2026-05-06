import 'package:flutter/material.dart';
import 'package:flutter_wigilabs_sr/modules/home/presentation/home/view/home_view.dart';
import 'package:go_router/go_router.dart';

final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');

StatefulShellBranch homeRoutes = StatefulShellBranch(
  navigatorKey: _homeNavigatorKey,
  routes: [
    GoRoute(
      path: HomeView.path,
      name: HomeView.name,
      pageBuilder: (context, state) =>
          NoTransitionPage(key: state.pageKey, child: HomeView.create()),
    ),
  ],
);
