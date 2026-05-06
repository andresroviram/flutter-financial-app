import 'package:core/get_it.dart';
import 'package:core/utils/helpers.dart';
import 'package:feature_home/domain/usecases/countries_usecases.dart';
import 'package:feature_home/presentation/home/bloc/home_bloc.dart';
import 'package:feature_home/presentation/home/view/home_mobile.dart';
import 'package:feature_home/presentation/home/view/home_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const String path = '/';
  static const String name = 'home';

  static Widget create() => MultiBlocProvider(
    providers: [
      BlocProvider(
        lazy: false,
        create: (_) => HomeBloc(
          getCountries: getIt<GetCountriesUseCase>(),
          getWishlist: getIt<GetWishlistUseCase>(),
          addToWishlist: getIt<AddToWishlistUseCase>(),
          removeFromWishlist: getIt<RemoveFromWishlistUseCase>(),
        ),
      ),
    ],
    child: const HomeView(),
  );

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const int _branchIndex = 0;
  int? _prevShellIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final shell = StatefulNavigationShell.of(context);
    final currentIndex = shell.currentIndex;
    if (_prevShellIndex != null &&
        _prevShellIndex != currentIndex &&
        currentIndex == _branchIndex) {
      context.read<HomeBloc>().add(const HomeEvent.loadWishlist());
    }
    _prevShellIndex = currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final breakpoint = ResponsiveBreakpoints.of(context).breakpoint;
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: BlocListener<HomeBloc, HomeState>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure && current.failure != null,
          listener: (context, state) {
            if (context.mounted) {
              ShowFailure.instance.mapFailuresToNotification(
                context,
                failure: state.failure!,
              );
              context.read<HomeBloc>().add(const HomeEvent.invalidate());
            }
          },
          child: switch (breakpoint.name) {
            MOBILE => const HomeMobile(),
            (_) => const HomeWeb(),
          },
        ),
      ),
    );
  }
}
