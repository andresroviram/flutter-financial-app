import 'package:core/constants/app_constants.dart';
import 'package:core/entities/country_entity.dart';
import 'package:feature_home/presentation/country_detail/view/country_detail_view.dart';
import 'package:feature_home/presentation/home/view/home_view.dart';
import 'package:flutter/material.dart';
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
      routes: [
        if (AppConstants.isWeb)
          GoRoute(
            path: CountryDetailView.pathWeb,
            name: CountryDetailView.nameWeb,
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
