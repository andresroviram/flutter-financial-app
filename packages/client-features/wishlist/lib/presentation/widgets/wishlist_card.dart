import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/entities/country_entity.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class WishlistCard extends StatelessWidget {
  const WishlistCard({
    super.key,
    required this.country,
    required this.onRemove,
    required this.onTap,
  });

  final CountryEntity country;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: country.flagPng,
                  width: 72,
                  height: 48,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => Container(
                    width: 72,
                    height: 48,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.flag_outlined),
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      country.commonName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (country.capital != null) ...[
                      const Gap(2),
                      Text(
                        country.capital!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Eliminar de lista de deseos',
                icon: const Icon(Icons.delete_outline),
                color: theme.colorScheme.error,
                onPressed: onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
