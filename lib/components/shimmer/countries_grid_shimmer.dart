import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer skeleton para el grid de países en la pantalla home
class CountriesGridShimmer extends StatelessWidget {
  const CountriesGridShimmer({
    super.key,
    this.itemCount = 6,
    this.gridDelegate = _mobileDelegate,
    this.padding = const EdgeInsets.all(16),
  });

  final int itemCount;
  final SliverGridDelegate gridDelegate;
  final EdgeInsets padding;

  static const _mobileDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: 12,
    crossAxisSpacing: 12,
    childAspectRatio: 0.75,
  );

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Theme.of(context).colorScheme.surface;

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: GridView.builder(
        padding: padding,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: gridDelegate,
        itemCount: itemCount,
        itemBuilder: (_, __) => const _CountryCardSkeleton(),
      ),
    );
  }
}

class _CountryCardSkeleton extends StatelessWidget {
  const _CountryCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bandera — AspectRatio 16:9
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(color: color),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título + botón wishlist
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const Gap(8),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                // InfoRow capital
                _ShimmerInfoRow(color: color),
                const Gap(6),
                // InfoRow población
                _ShimmerInfoRow(color: color, width: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerInfoRow extends StatelessWidget {
  const _ShimmerInfoRow({required this.color, this.width = 100});

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const Gap(6),
        Container(
          width: width,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
