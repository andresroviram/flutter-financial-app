import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer skeleton para la pantalla de detalle de país en web
class CountryDetailShimmer extends StatelessWidget {
  const CountryDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlightColor = Theme.of(context).colorScheme.surface;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 80,
          flexibleSpace: FlexibleSpaceBar(
            title: Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                width: 150,
                height: 20,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            centerTitle: false,
            titlePadding: const EdgeInsets.only(left: 72, bottom: 16),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Container(color: baseColor),
                              ),
                            ),
                          ),
                          const Gap(32),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: baseColor,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Gap(16),
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: baseColor,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(24),
                                Container(
                                  width: 150,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: baseColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const Gap(12),
                                ...List.generate(
                                  5,
                                  (i) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 130,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: baseColor,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                        const Gap(16),
                                        Expanded(
                                          child: Container(
                                            height: 14,
                                            decoration: BoxDecoration(
                                              color: baseColor,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(32),
                      const Divider(),
                      const Gap(24),
                      Wrap(
                        spacing: 32,
                        runSpacing: 24,
                        children: List.generate(
                          4,
                          (i) => SizedBox(
                            width: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 120,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: baseColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const Gap(8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: List.generate(
                                    3,
                                    (j) => Container(
                                      width: 80,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: baseColor,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Gap(48),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
