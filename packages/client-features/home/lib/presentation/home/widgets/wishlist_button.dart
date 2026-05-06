import 'package:core/entities/country_entity.dart';
import 'package:feature_home/presentation/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistButton extends StatelessWidget {
  const WishlistButton({
    super.key,
    required this.country,
    required this.isInWishlist,
  });

  final CountryEntity country;
  final bool isInWishlist;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: IconButton(
        visualDensity: VisualDensity.compact,
        tooltip: isInWishlist
            ? 'Quitar de lista de deseos'
            : 'Agregar a lista de deseos',
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isInWishlist ? Icons.favorite : Icons.favorite_border,
            key: ValueKey(isInWishlist),
            color: isInWishlist ? Colors.red : null,
          ),
        ),
        onPressed: () =>
            context.read<HomeBloc>().add(HomeEvent.toggleWishlist(country)),
      ),
    );
  }
}
