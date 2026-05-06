import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../../core/utils/format_utils.dart';
import '../../../domain/entities/country_entity.dart';
import '../bloc/country_detail_bloc.dart';
import '../widgets/chip_list.dart';
import '../widgets/detail_row.dart';
import '../widgets/detail_section.dart';
import '../widgets/error_state.dart';

class CountryDetailMobile extends StatelessWidget {
  const CountryDetailMobile({super.key, required this.country});
  final CountryEntity country;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountryDetailBloc, CountryDetailState>(
      builder: (context, state) {
        final country = state.country;
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 240,
                pinned: true,
                actions: [
                  if (country != null)
                    IconButton(
                      tooltip: state.isInWishlist
                          ? 'Quitar de lista de deseos'
                          : 'Agregar a lista de deseos',
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          state.isInWishlist
                              ? Icons.favorite
                              : Icons.favorite_border,
                          key: ValueKey(state.isInWishlist),
                          color: state.isInWishlist ? Colors.red : null,
                        ),
                      ),
                      onPressed: () => context
                          .read<CountryDetailBloc>()
                          .add(CountryDetailEvent.toggleWishlist(country)),
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
                          placeholder: (_, __) => Container(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
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
                  child: ErrorState(failure: state.failure!),
                )
              else if (country != null)
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      DetailSection(
                        title: 'Información general',
                        children: [
                          DetailRow(
                            label: 'Nombre oficial',
                            value: country.officialName,
                          ),
                          if (country.capital != null)
                            DetailRow(
                              label: 'Capital',
                              value: country.capital!,
                            ),
                          DetailRow(
                            label: 'Región',
                            value: '${country.region}'
                                '${country.subregion != null ? ' · ${country.subregion}' : ''}',
                          ),
                          DetailRow(
                            label: 'Población',
                            value: FormatUtils.formatNumber(country.population),
                          ),
                          if (country.area != null)
                            DetailRow(
                              label: 'Área',
                              value:
                                  '${FormatUtils.formatNumber(country.area!.toInt())} km²',
                            ),
                        ],
                      ),
                      if (country.languages?.isNotEmpty ?? false) ...[
                        const Gap(16),
                        DetailSection(
                          title: 'Idiomas',
                          children: [
                            ChipList(items: country.languages!),
                          ],
                        ),
                      ],
                      if (country.currencies?.isNotEmpty ?? false) ...[
                        const Gap(16),
                        DetailSection(
                          title: 'Monedas',
                          children: [
                            ChipList(items: country.currencies!),
                          ],
                        ),
                      ],
                      if (country.timezones?.isNotEmpty ?? false) ...[
                        const Gap(16),
                        DetailSection(
                          title: 'Zonas horarias',
                          children: [
                            ChipList(items: country.timezones!),
                          ],
                        ),
                      ],
                      if (country.borders?.isNotEmpty ?? false) ...[
                        const Gap(16),
                        DetailSection(
                          title: 'Países fronterizos',
                          children: [
                            ChipList(items: country.borders!),
                          ],
                        ),
                      ],
                      const Gap(32),
                    ]),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
