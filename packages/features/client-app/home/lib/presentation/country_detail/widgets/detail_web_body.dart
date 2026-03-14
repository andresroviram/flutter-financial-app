import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/entities/country_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feature_home/presentation/country_detail/widgets/chip_list.dart';
import 'package:feature_home/presentation/country_detail/widgets/country_detail_info.dart';
import 'package:feature_home/presentation/country_detail/widgets/detail_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DetailWebBody extends StatelessWidget {
  const DetailWebBody({
    super.key,
    required this.country,
    required this.isInWishlist,
  });

  final CountryEntity country;
  final bool isInWishlist;

  @override
  Widget build(BuildContext context) {
    return Center(
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
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
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
                    isInWishlist: isInWishlist,
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
                      children: [ChipList(items: country.languages!)],
                    ),
                  ),
                if (country.currencies?.isNotEmpty ?? false)
                  SizedBox(
                    width: 300,
                    child: DetailSection(
                      title: 'detail.currencies'.tr(),
                      children: [ChipList(items: country.currencies!)],
                    ),
                  ),
                if (country.timezones?.isNotEmpty ?? false)
                  SizedBox(
                    width: 300,
                    child: DetailSection(
                      title: 'detail.timezones'.tr(),
                      children: [ChipList(items: country.timezones!)],
                    ),
                  ),
                if (country.borders?.isNotEmpty ?? false)
                  SizedBox(
                    width: 300,
                    child: DetailSection(
                      title: 'detail.borders'.tr(),
                      children: [ChipList(items: country.borders!)],
                    ),
                  ),
              ],
            ),
            const Gap(48),
          ],
        ),
      ),
    );
  }
}
