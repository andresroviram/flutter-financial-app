import 'package:components/shimmer/countries_grid_shimmer.dart';
import 'package:core/utils/snackbar_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feature_home/presentation/country_detail/view/country_detail_view.dart';
import 'package:feature_home/presentation/home/bloc/home_bloc.dart';
import 'package:feature_home/presentation/home/widgets/country_card.dart';
import 'package:feature_home/presentation/home/widgets/error_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeMobile extends StatelessWidget {
  const HomeMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey('home_${context.locale.toString()}'),
      appBar: AppBar(
        title: Text('countries_list.title'.tr()),
        centerTitle: false,
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        bloc: context.read<HomeBloc>(),
        listener: (context, state) {
          if (state.failure != null) {
            SnackbarUtils.showErrorSnackbar(context, state.failure!);
            context.read<HomeBloc>().add(const HomeEvent.invalidate());
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.countries.isEmpty) {
            return const CountriesGridShimmer();
          }

          if (state.countries.isEmpty && state.failure != null) {
            return ErrorRetry(
              failure: state.failure!,
              onRetry: () =>
                  context.read<HomeBloc>().add(const HomeEvent.loadCountries()),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(const HomeEvent.loadCountries());
            },
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final country = state.countries[index];
                      final isInWishlist = state.wishlistCca2s.contains(
                        country.cca2,
                      );
                      return RepaintBoundary(
                        child: CountryCard(
                          country: country,
                          isInWishlist: isInWishlist,
                          onTap: () async {
                            await context.push(
                              CountryDetailView.pathMobile,
                              extra: country,
                            );
                            if (context.mounted) {
                              context.read<HomeBloc>().add(
                                const HomeEvent.loadWishlist(),
                              );
                            }
                          },
                        ),
                      );
                    }, childCount: state.countries.length),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
