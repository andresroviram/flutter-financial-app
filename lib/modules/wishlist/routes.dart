import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'presentation/view/wishlist_view.dart';

final _wishlistNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'wishlist');

StatefulShellBranch wishlistRoutes = StatefulShellBranch(
  navigatorKey: _wishlistNavigatorKey,
  routes: [
    GoRoute(
      path: WishlistView.path,
      name: WishlistView.name,
      pageBuilder: (context, state) =>
          NoTransitionPage(key: state.pageKey, child: WishlistView.create()),
    ),
  ],
);
