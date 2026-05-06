import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../components/shimmer/countries_grid_shimmer.dart';
import '../../../../../core/utils/locale_utils.dart';
import '../bloc/home_bloc.dart';
import '../widgets/country_card.dart';
import '../widgets/error_retry.dart';
import '../../../../../core/utils/snackbar_utils.dart';

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
              onRetry: () => context.read<HomeBloc>().add(
                HomeEvent.loadCountries(LocaleUtils.toLang(context.locale)),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(
                HomeEvent.loadCountries(LocaleUtils.toLang(context.locale)),
              );
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
