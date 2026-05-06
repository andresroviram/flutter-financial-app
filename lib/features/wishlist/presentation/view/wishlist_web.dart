import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../home/presentation/country_detail/view/country_detail_view.dart';
import '../bloc/wishlist_bloc.dart';
import '../widgets/empty_wishlist.dart';
import '../widgets/wishlist_card.dart';

class WishlistWeb extends StatefulWidget {
  const WishlistWeb({super.key});

  @override
  State<WishlistWeb> createState() => _WishlistWebState();
}

class _WishlistWebState extends State<WishlistWeb> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<WishlistBloc, WishlistState>(
      bloc: context.read<WishlistBloc>(),
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.wishlist.isEmpty) {
          return const EmptyWishlist();
        }

        final filtered = _search.isEmpty
            ? state.wishlist
            : state.wishlist
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
                      'wishlist.title'.tr(),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Gap(16),
                  SizedBox(
                    width: 280,
                    child: SearchBar(
                      hintText: 'countries_list.search_hint'.tr(),
                      leading: const Icon(Icons.search),
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onChanged: (value) => setState(() => _search = value),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Text(
                '${state.wishlist.length} ${state.wishlist.length == 1 ? 'wishlist.count_singular'.tr() : 'wishlist.count_plural'.tr()}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search_off, size: 64),
                          const Gap(12),
                          Text(
                            '${'wishlist.not_found'.tr()} "$_search"',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 480,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            mainAxisExtent: 96,
                          ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final country = filtered[index];
                        return WishlistCard(
                          country: country,
                          onRemove: () => context.read<WishlistBloc>().add(
                            WishlistEvent.removeFromWishlist(country.cca2),
                          ),
                          onTap: () async {
                            await context.push(
                              CountryDetailView.path,
                              extra: country,
                            );
                            if (context.mounted) {
                              context.read<WishlistBloc>().add(
                                const WishlistEvent.loadWishlist(),
                              );
                            }
                          },
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
