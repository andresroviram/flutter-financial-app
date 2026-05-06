import 'package:components/shimmer/country_detail_shimmer_title.dart';
import 'package:feature_home/presentation/country_detail/bloc/country_detail_bloc.dart';
import 'package:feature_home/presentation/country_detail/bloc/country_detail_state_x.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailWebHeader extends StatelessWidget {
  const DetailWebHeader({super.key, required this.state});
  final CountryDetailState state;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      child: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 12),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                BackButton(onPressed: () => context.pop()),
                const SizedBox(width: 8),
                Expanded(
                  child: state.resolve(
                    loading: () => const CountryDetailShimmerTitle(),
                    failure: (_) => const SizedBox.shrink(),
                    empty: () => const SizedBox.shrink(),
                    data: (country) => Text(
                      country.commonName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
