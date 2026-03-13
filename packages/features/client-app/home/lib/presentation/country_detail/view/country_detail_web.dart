import 'package:components/shimmer/country_detail_shimmer_body.dart';
import 'package:core/entities/country_entity.dart';
import '../bloc/country_detail_bloc.dart';
import '../bloc/country_detail_state_x.dart';
import '../widgets/detail_web_body.dart';
import '../widgets/detail_web_header.dart';
import '../widgets/error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryDetailWeb extends StatelessWidget {
  const CountryDetailWeb({super.key, required this.country});
  final CountryEntity country;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountryDetailBloc, CountryDetailState>(
      builder: (context, state) {
        return SelectionArea(
          child: Column(
            children: [
              DetailWebHeader(state: state),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: state.resolve(
                    loading: () => const CountryDetailShimmerBody(),
                    failure: (failure) => Center(
                      child: ErrorState(
                        failure: failure,
                        onRetry: () => context.read<CountryDetailBloc>().add(
                          CountryDetailEvent.loadDetailByCode(
                            code: country.cca2,
                            previewCountry: country,
                          ),
                        ),
                      ),
                    ),
                    empty: () => const Center(child: Text('No data')),
                    data: (country) => DetailWebBody(
                      country: country,
                      isInWishlist: state.isInWishlist,
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
