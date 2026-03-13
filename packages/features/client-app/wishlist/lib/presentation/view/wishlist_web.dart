import 'package:easy_localization/easy_localization.dart';
import '../bloc/wishlist_bloc.dart';
import '../bloc/wishlist_state_x.dart';
import 'wishlist_view.dart';
import '../widgets/empty_wishlist.dart';
import '../widgets/wishlist_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class WishlistWeb extends StatelessWidget {
  const WishlistWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<WishlistBloc, WishlistState>(
      bloc: context.read<WishlistBloc>(),
      builder: (context, state) {
        return state.resolve(
          loading: () => const Center(child: CircularProgressIndicator()),
          failure: (_) => const EmptyWishlist(),
          empty: () => const EmptyWishlist(),
          data: (filtered) => Column(
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
                        onChanged: (value) => context.read<WishlistBloc>().add(
                          WishlistEvent.search(value),
                        ),
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
                              '${'wishlist.not_found'.tr()} "${state.searchQuery}"',
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
                            onTap: () {
                              context.goNamed(
                                WishlistView.pathCountryDetail,
                                pathParameters: {'countryCode': country.cca2},
                                extra: country,
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
