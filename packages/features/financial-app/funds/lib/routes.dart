import 'presentation/funds/view/funds_view.dart';
import 'presentation/transactions/view/transactions_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> fundsNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'funds',
);
final GlobalKey<NavigatorState> transactionsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'transactions');

StatefulShellBranch get fundsRoutes => StatefulShellBranch(
  navigatorKey: fundsNavigatorKey,
  routes: [
    GoRoute(
      path: FundsView.path,
      name: FundsView.name,
      pageBuilder: (context, state) =>
          NoTransitionPage(key: state.pageKey, child: FundsView.create()),
    ),
  ],
);

StatefulShellBranch get transactionsRoutes => StatefulShellBranch(
  navigatorKey: transactionsNavigatorKey,
  routes: [
    GoRoute(
      path: TransactionsView.path,
      name: TransactionsView.name,
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: TransactionsView.create(),
      ),
    ),
  ],
);
