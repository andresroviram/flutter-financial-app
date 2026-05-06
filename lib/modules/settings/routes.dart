import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'presentation/view/setting_view.dart';

final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

StatefulShellBranch settingsRoutes = StatefulShellBranch(
  navigatorKey: _settingsNavigatorKey,
  routes: [
    GoRoute(
      path: SettingsView.path,
      name: SettingsView.name,
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: SettingsView.create(),
      ),
    ),
  ],
);
