import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wigilabs_sr/features/home/presentation/country_detail/view/country_detail_view.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../bloc/wishlist_bloc.dart';
import '../widgets/empty_wishlist.dart';
import '../widgets/wishlist_card.dart';

class WishlistMobile extends StatelessWidget {
  const WishlistMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de deseos'), centerTitle: false),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.wishlist.isEmpty) {
            return const EmptyWishlist();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.wishlist.length,
            separatorBuilder: (_, __) => const Gap(8),
            itemBuilder: (context, index) {
              final country = state.wishlist[index];
              return WishlistCard(
                country: country,
                onRemove: () => context.read<WishlistBloc>().add(
                  WishlistEvent.removeFromWishlist(country.cca2),
                ),
                onTap: () async {
                  await context.push(CountryDetailView.path, extra: country);
                  if (context.mounted) {
                    context.read<WishlistBloc>().add(
                      const WishlistEvent.loadWishlist(),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
