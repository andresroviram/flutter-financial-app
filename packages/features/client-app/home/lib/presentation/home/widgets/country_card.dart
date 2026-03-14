import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/entities/country_entity.dart';
import 'package:core/utils/format_utils.dart';
import 'package:feature_home/presentation/home/widgets/info_row.dart';
import 'package:feature_home/presentation/home/widgets/wishlist_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class CountryCard extends StatelessWidget {
  const CountryCard({
    super.key,
    required this.country,
    required this.isInWishlist,
    required this.onTap,
  });

  final CountryEntity country;
  final bool isInWishlist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
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
