import 'package:flutter/material.dart';
import 'package:flutter_wigilabs_sr/core/constants/app_constants.dart';
import 'package:flutter_wigilabs_sr/modules/home/domain/entities/country_entity.dart';
import 'package:flutter_wigilabs_sr/modules/home/presentation/country_detail/view/country_detail_view.dart';

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
      routes: [
        if (AppConstants.isWeb)
          GoRoute(
            path: CountryDetailView.pathWeb,
            name: WishlistView.pathCountryDetail,
            pageBuilder: (context, state) {
              final countryCode = state.pathParameters['countryCode']!;
              final country = state.extra as CountryEntity?;
              return MaterialPage(
                key: state.pageKey,
                child: CountryDetailView.create(
                  country: country,
                  countryCode: countryCode,
                ),
              );
            },
          ),
      ],
    ),
  ],
);
