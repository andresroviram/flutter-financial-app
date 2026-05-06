import 'package:cached_network_image/cached_network_image.dart';
import 'package:components/shimmer/country_detail_shimmer_body.dart';
import 'package:components/shimmer/country_detail_shimmer_title.dart';
import 'package:core/entities/country_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feature_home/presentation/country_detail/bloc/country_detail_bloc.dart';
import 'package:feature_home/presentation/country_detail/widgets/chip_list.dart';
import 'package:feature_home/presentation/country_detail/widgets/country_detail_info.dart';
import 'package:feature_home/presentation/country_detail/widgets/detail_section.dart';
import 'package:feature_home/presentation/country_detail/widgets/error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CountryDetailWeb extends StatelessWidget {
  const CountryDetailWeb({super.key, required this.country});
  final CountryEntity country;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountryDetailBloc, CountryDetailState>(
      builder: (context, state) {
        final country = state.country;

        return Scaffold(
          body: Column(
            children: [
              Material(
                elevation: 2,
                child: SizedBox(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 72, bottom: 12),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: [
                          BackButton(onPressed: () => context.pop()),
                          const SizedBox(width: 8),
                          Expanded(
                            child: state.isLoading
                                ? const CountryDetailShimmerTitle()
                                : Text(
                                    country?.commonName ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: state.isLoading
                      ? const CountryDetailShimmerBody()
                      : state.failure != null
                      ? Center(
                          child: ErrorState(
                            failure: state.failure!,
                            onRetry: () =>
                                context.read<CountryDetailBloc>().add(
                                  CountryDetailEvent.loadDetailByCode(
                                    code: this.country.cca2,
                                    previewCountry: this.country,
                                  ),
                                ),
                          ),
                        )
                      : country == null
                      ? const Center(child: Text('No data'))
                      : Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1200),
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
                                          child: CachedNetworkImage(
                                            imageUrl: country.flagPng,
                                            fit: BoxFit.cover,
                                            placeholder: (_, _) => Container(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surfaceContainerHighest,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Gap(32),
                                    Expanded(
                                      flex: 3,
                                      child: CountryDetailInfo(
                                        country: country,
                                        isInWishlist: state.isInWishlist,
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
                                  children: [
                                    if (country.languages?.isNotEmpty ?? false)
                                      SizedBox(
                                        width: 300,
                                        child: DetailSection(
                                          title: 'detail.languages'.tr(),
                                          children: [
                                            ChipList(items: country.languages!),
                                          ],
                                        ),
                                      ),
                                    if (country.currencies?.isNotEmpty ?? false)
                                      SizedBox(
                                        width: 300,
                                        child: DetailSection(
                                          title: 'detail.currencies'.tr(),
                                          children: [
                                            ChipList(
                                              items: country.currencies!,
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (country.timezones?.isNotEmpty ?? false)
                                      SizedBox(
                                        width: 300,
                                        child: DetailSection(
                                          title: 'detail.timezones'.tr(),
                                          children: [
                                            ChipList(items: country.timezones!),
                                          ],
                                        ),
                                      ),
                                    if (country.borders?.isNotEmpty ?? false)
                                      SizedBox(
                                        width: 300,
                                        child: DetailSection(
                                          title: 'detail.borders'.tr(),
                                          children: [
                                            ChipList(items: country.borders!),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                const Gap(48),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
