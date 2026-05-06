import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../../core/utils/format_utils.dart';
import '../../../domain/entities/country_entity.dart';
import '../bloc/country_detail_bloc.dart';
import 'detail_row.dart';
import 'detail_section.dart';

class CountryDetailInfo extends StatelessWidget {
  const CountryDetailInfo({
    super.key,
    required this.country,
    required this.isInWishlist,
  });

  final CountryEntity country;
  final bool isInWishlist;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                country.commonName,
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            IconButton.filledTonal(
              tooltip: isInWishlist
                  ? 'detail.wishlist_remove'.tr()
                  : 'detail.wishlist_add'.tr(),
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isInWishlist ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(isInWishlist),
                  color: isInWishlist ? Colors.red : null,
                ),
              ),
              onPressed: () => context.read<CountryDetailBloc>().add(
                CountryDetailEvent.toggleWishlist(country),
              ),
            ),
          ],
        ),
        const Gap(24),
        DetailSection(
          title: 'detail.general_info'.tr(),
          children: [
            DetailRow(
              label: 'detail.official_name'.tr(),
              value: country.officialName,
            ),
            if (country.capital != null)
              DetailRow(label: 'detail.capital'.tr(), value: country.capital!),
            DetailRow(
              label: 'detail.region'.tr(),
              value:
                  '${country.region}'
                  '${country.subregion != null ? ' · ${country.subregion}' : ''}',
            ),
            DetailRow(
              label: 'detail.population'.tr(),
              value: FormatUtils.formatNumber(country.population),
            ),
            if (country.area != null)
              DetailRow(
                label: 'detail.area'.tr(),
                value:
                    '${FormatUtils.formatNumber(country.area!.toInt())} ${'detail.area_unit'.tr()}',
              ),
          ],
        ),
      ],
    );
  }
}
