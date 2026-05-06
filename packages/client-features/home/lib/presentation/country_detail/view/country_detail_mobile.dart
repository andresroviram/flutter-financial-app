import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/entities/country_entity.dart';
import 'package:core/utils/format_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feature_home/presentation/country_detail/bloc/country_detail_bloc.dart';
import 'package:feature_home/presentation/country_detail/widgets/chip_list.dart';
import 'package:feature_home/presentation/country_detail/widgets/detail_row.dart';
import 'package:feature_home/presentation/country_detail/widgets/detail_section.dart';
import 'package:feature_home/presentation/country_detail/widgets/error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CountryDetailMobile extends StatelessWidget {
  const CountryDetailMobile({super.key, required this.country});
  final CountryEntity country;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<CountryDetailBloc, CountryDetailState>(
      builder: (context, state) {
        final country = state.country;
        return SelectionArea(
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 240,
                  pinned: true,
                  leading: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: colorScheme.onSurface,
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  actions: [
                    if (country != null)
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          tooltip: state.isInWishlist
                              ? 'detail.wishlist_remove'.tr()
                              : 'detail.wishlist_add'.tr(),
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              state.isInWishlist
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              key: ValueKey(state.isInWishlist),
                              color: state.isInWishlist
                                  ? Colors.red
                                  : colorScheme.onSurface,
                            ),
                          ),
                          onPressed: () => context
                              .read<CountryDetailBloc>()
                              .add(CountryDetailEvent.toggleWishlist(country)),
                        ),
                      ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    title: country != null
                        ? Text(
                            country.commonName,
                            style: const TextStyle(
                              shadows: [Shadow(blurRadius: 4)],
                            ),
                          )
                        : null,
                    background: country != null
                        ? CachedNetworkImage(
                            imageUrl: country.flagPng,
                            fit: BoxFit.cover,
                            placeholder: (_, _) => Container(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                            ),
                          )
                        : null,
                  ),
                ),
                if (state.isLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.failure != null)
                  SliverFillRemaining(
                    child: ErrorState(
                      failure: state.failure!,
                      onRetry: () => context.read<CountryDetailBloc>().add(
                        CountryDetailEvent.loadDetail(
                          name: this.country.commonName,
                          previewCountry: this.country,
                        ),
                      ),
                    ),
                  )
                else if (country != null)
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        DetailSection(
                          title: 'detail.general_info'.tr(),
                          children: [
                            DetailRow(
                              label: 'detail.official_name'.tr(),
                              value: country.officialName,
                            ),
                            if (country.capital != null)
                              DetailRow(
                                label: 'detail.capital'.tr(),
                                value: country.capital!,
                              ),
                            DetailRow(
                              label: 'detail.region'.tr(),
                              value:
                                  '${country.region}'
                                  '${country.subregion != null ? ' · ${country.subregion}' : ''}',
                            ),
                            DetailRow(
                              label: 'detail.population'.tr(),
                              value: FormatUtils.formatNumber(
                                country.population,
                              ),
                            ),
                            if (country.area != null)
                              DetailRow(
                                label: 'detail.area'.tr(),
                                value:
                                    '${FormatUtils.formatNumber(country.area!.toInt())} ${'detail.area_unit'.tr()}',
                              ),
                          ],
                        ),
                        if (country.languages?.isNotEmpty ?? false) ...[
                          const Gap(16),
                          DetailSection(
                            title: 'detail.languages'.tr(),
                            children: [ChipList(items: country.languages!)],
                          ),
                        ],
                        if (country.currencies?.isNotEmpty ?? false) ...[
                          const Gap(16),
                          DetailSection(
                            title: 'detail.currencies'.tr(),
                            children: [ChipList(items: country.currencies!)],
                          ),
                        ],
                        if (country.timezones?.isNotEmpty ?? false) ...[
                          const Gap(16),
                          DetailSection(
                            title: 'detail.timezones'.tr(),
                            children: [ChipList(items: country.timezones!)],
                          ),
                        ],
                        if (country.borders?.isNotEmpty ?? false) ...[
                          const Gap(16),
                          DetailSection(
                            title: 'detail.borders'.tr(),
                            children: [ChipList(items: country.borders!)],
                          ),
                        ],
                        const Gap(32),
                      ]),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
