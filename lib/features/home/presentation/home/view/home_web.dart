import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../bloc/home_bloc.dart';
import '../widgets/country_card.dart';
import '../widgets/error_retry.dart';
import '../widgets/loading_grid.dart';
import '../../../../../core/utils/snackbar_utils.dart';

const _webGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 280,
  mainAxisSpacing: 16,
  crossAxisSpacing: 16,
  childAspectRatio: 0.75,
);

const _webGridPadding = EdgeInsets.fromLTRB(24, 0, 24, 24);

class HomeWeb extends StatefulWidget {
  const HomeWeb({super.key});

  @override
  State<HomeWeb> createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> {
  String _search = '';

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
            _HomeWebHeader(
              search: _search,
              onSearchChanged: (v) => setState(() => _search = v),
              onRefresh: () => _onRefresh(context),
            ),
            const Gap(16),
            Expanded(
              child: state.isLoading && state.countries.isEmpty
                  ? const LoadingGrid(
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

class _HomeWebHeader extends StatelessWidget {
  const _HomeWebHeader({
    required this.search,
    required this.onSearchChanged,
    required this.onRefresh,
  });

  final String search;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
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
              onChanged: onSearchChanged,
            ),
          ),
          const Gap(8),
          IconButton.outlined(
            tooltip: 'Refrescar',
            icon: const Icon(Icons.refresh),
            onPressed: onRefresh,
          ),
        ],
      ),
    );
  }
}
