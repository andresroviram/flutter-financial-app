import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wigilabs_sr/modules/home/presentation/country_detail/view/country_detail_view.dart';
import 'package:flutter_wigilabs_sr/modules/home/presentation/home/bloc/home_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../domain/entities/country_entity.dart';
import '../../../../../core/utils/format_utils.dart';
import 'info_row.dart';
import 'wishlist_button.dart';

class CountryCard extends StatelessWidget {
  const CountryCard({
    super.key,
    required this.country,
    required this.isInWishlist,
  });

  final CountryEntity country;
  final bool isInWishlist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () async {
          await context.push(CountryDetailView.path, extra: country);
          if (context.mounted) {
            context.read<HomeBloc>().add(const HomeEvent.loadWishlist());
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: country.flagPng,
                fit: BoxFit.cover,
                placeholder: (_, _) => Shimmer.fromColors(
                  baseColor: colorScheme.surfaceContainerHighest,
                  highlightColor: colorScheme.surface,
                  child: Container(color: colorScheme.surfaceContainerHighest),
                ),
                errorWidget: (_, _, _) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.flag_outlined, size: 40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          country.commonName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      WishlistButton(
                        country: country,
                        isInWishlist: isInWishlist,
                      ),
                    ],
                  ),
                  const Gap(4),
                  if (country.capital != null)
                    InfoRow(
                      icon: Icons.location_city_outlined,
                      text: country.capital!,
                    ),
                  const Gap(2),
                  InfoRow(
                    icon: Icons.people_outline,
                    text: FormatUtils.formatPopulation(country.population),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
