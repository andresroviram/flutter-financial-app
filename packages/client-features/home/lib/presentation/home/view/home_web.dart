import 'package:components/shimmer/countries_grid_shimmer.dart';
import 'package:core/utils/snackbar_utils.dart';
import 'package:feature_home/presentation/country_detail/view/country_detail_view.dart';
import 'package:feature_home/presentation/home/bloc/home_bloc.dart';
import 'package:feature_home/presentation/home/widgets/country_card.dart';
import 'package:feature_home/presentation/home/widgets/error_retry.dart';
import 'package:feature_home/presentation/home/widgets/home_web_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HomeWeb extends StatefulWidget {
  const HomeWeb({super.key});

  @override
  State<HomeWeb> createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> {
  String _search = '';

  static const _webGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 280,
    mainAxisSpacing: 16,
    crossAxisSpacing: 16,
    childAspectRatio: 0.75,
  );

  static const _webGridPadding = EdgeInsets.fromLTRB(24, 0, 24, 24);

  void _onRefresh(BuildContext context) =>
      context.read<HomeBloc>().add(const HomeEvent.loadCountries());

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: context.read<HomeBloc>(),
      listener: (context, state) {
        if (state.failure != null) {
          SnackbarUtils.showErrorSnackbar(context, state.failure!);
          context.read<HomeBloc>().add(const HomeEvent.invalidate());
        }
      },
      builder: (context, state) {
        if (state.countries.isEmpty && state.failure != null) {
          return ErrorRetry(
            failure: state.failure!,
            onRetry: () => _onRefresh(context),
          );
        }

        final filtered = _search.isEmpty
            ? state.countries
            : state.countries
                  .where(
                    (c) => c.commonName.toLowerCase().contains(
                      _search.toLowerCase(),
                    ),
                  )
                  .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeWebHeader(
              search: _search,
              onSearchChanged: (v) => setState(() => _search = v),
              onRefresh: () => _onRefresh(context),
            ),
            const Gap(16),
            Expanded(
              child: state.isLoading && state.countries.isEmpty
                  ? const CountriesGridShimmer(
                      itemCount: 12,
                      padding: _webGridPadding,
                      gridDelegate: _webGridDelegate,
                    )
                  : filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search_off, size: 64),
                          const Gap(12),
                          Text(
                            'No se encontró "$_search"',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: _webGridPadding,
                      gridDelegate: _webGridDelegate,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final country = filtered[index];
                        final isInWishlist = state.wishlistCca2s.contains(
                          country.cca2,
                        );
                        return RepaintBoundary(
                          child: CountryCard(
                            country: country,
                            isInWishlist: isInWishlist,
                            onTap: () {
                              context.goNamed(
                                CountryDetailView.nameWeb,
                                pathParameters: {'countryCode': country.cca2},
                                extra: country,
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
