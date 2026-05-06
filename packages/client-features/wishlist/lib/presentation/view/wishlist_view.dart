import 'package:core/get_it.dart';
import 'package:core/utils/helpers.dart';
import 'package:feature_wishlist/domain/usecases/wishlist_usecases.dart';
import 'package:feature_wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:feature_wishlist/presentation/view/wishlist_mobile.dart';
import 'package:feature_wishlist/presentation/view/wishlist_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class WishlistView extends StatefulWidget {
  const WishlistView({super.key});

  static const String path = '/wishlist';
  static const String name = 'wishlist';

  static const String pathCountryDetail = '/wishlist_country_detail';

  static Widget create() => MultiBlocProvider(
    providers: [
      BlocProvider(
        lazy: false,
        create: (_) => WishlistBloc(
          getWishlist: getIt<GetWishlistUseCase>(),
          removeFromWishlist: getIt<RemoveFromWishlistUseCase>(),
        )..add(const WishlistEvent.loadWishlist()),
      ),
    ],
    child: const WishlistView(),
  );

  @override
  State<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView> {
  static const int _branchIndex = 1;
  int? _prevShellIndex;
  GoRouter? _router;
  String? _prevRoutePath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _router = GoRouter.of(context);
      _prevRoutePath = _router!.routerDelegate.currentConfiguration.uri.path;
      _router!.routerDelegate.addListener(_onRouteChanged);
    });
  }

  @override
  void dispose() {
    _router?.routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  void _onRouteChanged() {
    if (!mounted) return;
    final currentPath = _router!.routerDelegate.currentConfiguration.uri.path;
    if (_prevRoutePath != null &&
        _prevRoutePath != WishlistView.path &&
        currentPath == WishlistView.path) {
      context.read<WishlistBloc>().add(const WishlistEvent.loadWishlist());
    }
    _prevRoutePath = currentPath;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final shell = StatefulNavigationShell.of(context);
    final currentIndex = shell.currentIndex;
    if (_prevShellIndex != null &&
        _prevShellIndex != currentIndex &&
        currentIndex == _branchIndex) {
      context.read<WishlistBloc>().add(const WishlistEvent.loadWishlist());
    }
    _prevShellIndex = currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final breakpoint = ResponsiveBreakpoints.of(context).breakpoint;
    return Scaffold(
      body: BlocListener<WishlistBloc, WishlistState>(
        listenWhen: (previous, current) =>
            previous.failure != current.failure && current.failure != null,
        listener: (context, state) {
          if (context.mounted) {
            ShowFailure.instance.mapFailuresToNotification(
              context,
              failure: state.failure!,
            );
            context.read<WishlistBloc>().add(const WishlistEvent.invalidate());
          }
        },
        child: switch (breakpoint.name) {
          MOBILE => const WishlistMobile(),
          (_) => const WishlistWeb(),
        },
      ),
    );
  }
}
