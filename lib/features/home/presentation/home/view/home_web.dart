import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../bloc/home_bloc.dart';
import '../widgets/country_card.dart';
import '../widgets/error_retry.dart';
import '../widgets/loading_grid.dart';
import '../../../../../core/utils/snackbar_utils.dart';

class HomeWeb extends StatefulWidget {
  const HomeWeb({super.key});

  @override
  State<HomeWeb> createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<HomeBloc, HomeState>(
      bloc: context.read<HomeBloc>(),
      listener: (context, state) {
        if (state.failure != null) {
          SnackbarUtils.showErrorSnackbar(context, state.failure!);
          context.read<HomeBloc>().add(const HomeEvent.invalidate());
        }
      },
      builder: (context, state) {
        if (state.isLoading && state.countries.isEmpty) {
          return const LoadingGrid();
        }

        if (state.countries.isEmpty && state.failure != null) {
          return ErrorRetry(
            failure: state.failure!,
            onRetry: () =>
                context.read<HomeBloc>().add(const HomeEvent.loadCountries()),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Países de Europa',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Gap(16),
                  SizedBox(
                    width: 280,
                    child: SearchBar(
                      hintText: 'Buscar país...',
                      leading: const Icon(Icons.search),
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onChanged: (value) => setState(() => _search = value),
                    ),
                  ),
                  const Gap(8),
                  IconButton.outlined(
                    tooltip: 'Refrescar',
                    icon: const Icon(Icons.refresh),
                    onPressed: () => context.read<HomeBloc>().add(
                      const HomeEvent.loadCountries(),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search_off, size: 64),
                          const Gap(12),
                          Text(
                            'No se encontró "$_search"',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 280,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
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
