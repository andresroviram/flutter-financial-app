import 'package:easy_localization/easy_localization.dart';
import 'package:feature_home/presentation/country_detail/view/country_detail_view.dart';
import 'package:feature_wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:feature_wishlist/presentation/bloc/wishlist_state_x.dart';
import 'package:feature_wishlist/presentation/widgets/empty_wishlist.dart';
import 'package:feature_wishlist/presentation/widgets/wishlist_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class WishlistMobile extends StatelessWidget {
  const WishlistMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey('wishlist_${context.locale.toString()}'),
      appBar: AppBar(title: Text('wishlist.title'.tr()), centerTitle: false),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          return state.resolve(
            loading: () => const Center(child: CircularProgressIndicator()),
            failure: (_) => const EmptyWishlist(),
            empty: () => const EmptyWishlist(),
            data: (wishlist) => ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: wishlist.length,
              separatorBuilder: (_, _) => const Gap(8),
              itemBuilder: (context, index) {
                final country = wishlist[index];
                return WishlistCard(
                  country: country,
                  onRemove: () => context.read<WishlistBloc>().add(
                    WishlistEvent.removeFromWishlist(country.cca2),
                  ),
                  onTap: () async {
                    await context.push(
                      CountryDetailView.pathMobile,
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
          );
        },
      ),
    );
  }
}
