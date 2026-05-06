import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../components/theme_button.dart';
import '../../../core/enum/navigation_item.dart';
import 'navigation_appbar.dart';

class ScaffoldWithNavigation extends StatelessWidget {
  const ScaffoldWithNavigation({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final breakpoint = ResponsiveBreakpoints.of(context).breakpoint;
    final GlobalKey<ScaffoldState> scaffoldDrawerKey =
        GlobalKey<ScaffoldState>();
    return switch (breakpoint.name) {
      MOBILE => _ScaffoldWithNavigationBar(navigationShell, scaffoldDrawerKey),
      TABLET => _ScaffoldWithDrawer(navigationShell, scaffoldDrawerKey),
      (_) => _ScaffoldWithNavigationRail(navigationShell, scaffoldDrawerKey),
    };
  }
}

class _ScaffoldWithNavigationRail extends StatelessWidget {
  const _ScaffoldWithNavigationRail(
    this.navigationShell,
    this.scaffoldDrawerKey,
  );

  final StatefulNavigationShell navigationShell;
  final GlobalKey<ScaffoldState>? scaffoldDrawerKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: NavigationAppBar(scaffoldDrawerKey: scaffoldDrawerKey),
      key: scaffoldDrawerKey,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(border: Border()),
              margin: EdgeInsets.zero,
              child: Center(
                child: Text(
                  'app_title'.tr(),
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 16),
            Expanded(
              child: _NavigationDrawer(
                navigationShell: navigationShell,
                expand: true,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: ThemeModeButton.outlined(),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          Column(
            children: [
              const SizedBox(height: 15),
              Expanded(
                child: _NavigationRail(
                  navigationShell: navigationShell,
                  expand: false,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: ThemeModeButton.icon(),
              ),
            ],
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
            color: colorScheme.primary.withValues(alpha: 0.2),
          ),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}

class _ScaffoldWithDrawer extends StatelessWidget {
  const _ScaffoldWithDrawer(this.navigationShell, this.scaffoldDrawerKey);

  final StatefulNavigationShell navigationShell;
  final GlobalKey<ScaffoldState>? scaffoldDrawerKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: NavigationAppBar(scaffoldDrawerKey: scaffoldDrawerKey),
      body: navigationShell,
      key: scaffoldDrawerKey,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(border: Border()),
              margin: EdgeInsets.zero,
              child: Center(
                child: Text(
                  'app_title'.tr(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _NavigationRail(
                navigationShell: navigationShell,
                expand: true,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: ThemeModeButton.outlined(),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationRail extends StatelessWidget {
  const _NavigationRail({required this.navigationShell, required this.expand});

  final StatefulNavigationShell navigationShell;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    NavigationRailLabelType labelType = expand
        ? NavigationRailLabelType.none
        : NavigationRailLabelType.all;
    final theme = Theme.of(context);
    return NavigationRail(
      extended: expand,
      selectedIndex: navigationShell.currentIndex,
      unselectedLabelTextStyle: theme.textTheme.labelSmall?.copyWith(
        fontSize: 10,
      ),
      selectedLabelTextStyle: theme.textTheme.labelSmall?.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      onDestinationSelected: (index) {
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
      destinations: [
        for (final item in NavigationItem.values)
          NavigationRailDestination(
            icon: Icon(item.iconData),
            label: Text(item.label.tr()),
          ),
      ],
      labelType: labelType,
      indicatorShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
  }
}

class _NavigationDrawer extends StatelessWidget {
  const _NavigationDrawer({
    required this.navigationShell,
    required this.expand,
  });

  final StatefulNavigationShell navigationShell;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) {
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
      indicatorShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Text(
            'dashboard'.tr(),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        for (final item in NavigationItem.values)
          NavigationDrawerDestination(
            icon: Icon(item.iconData),
            label: Text(item.label.tr()),
          ),
        // const Padding(
        //   padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
        //   child: Divider(),
        // ),
      ],
    );
  }
}

class _ScaffoldWithNavigationBar extends StatelessWidget {
  const _ScaffoldWithNavigationBar(
    this.navigationShell,
    this.scaffoldDrawerKey,
  );

  final StatefulNavigationShell navigationShell;
  final GlobalKey<ScaffoldState>? scaffoldDrawerKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigationAppBar(scaffoldDrawerKey: scaffoldDrawerKey),
      key: scaffoldDrawerKey,
      body: navigationShell,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(border: Border()),
              margin: EdgeInsets.zero,
              child: Center(
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.light
                      ? 'assets/img/logo_dark.png'
                      : 'assets/img/logo.png',
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: _NavigationRail(
                navigationShell: navigationShell,
                expand: true,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: ThemeModeButton.outlined(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          for (final item in NavigationItem.values)
            NavigationDestination(
              icon: Icon(item.iconData),
              label: item.label.tr(),
            ),
        ],
      ),
    );
  }
}
