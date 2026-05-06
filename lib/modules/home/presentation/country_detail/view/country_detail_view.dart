import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wigilabs_sr/config/injectable/injectable_dependency.dart';
import 'package:flutter_wigilabs_sr/core/utils/helpers.dart';
import 'package:flutter_wigilabs_sr/modules/home/domain/entities/country_entity.dart';
import 'package:flutter_wigilabs_sr/modules/home/domain/usecases/countries_usecases.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../bloc/country_detail_bloc.dart';
import 'country_detail_mobile.dart';
import 'country_detail_web.dart';

class CountryDetailView extends StatelessWidget {
  const CountryDetailView({super.key, required this.country});
  final CountryEntity country;

  static const String path = '/country_detail';
  static const String name = 'country_detail';

  static Widget create({required CountryEntity country}) => MultiBlocProvider(
    providers: [
      BlocProvider(
        lazy: false,
        create: (_) =>
            CountryDetailBloc(
              getCountryDetail: getIt<GetCountryDetailUseCase>(),
              isInWishlist: getIt<IsInWishlistUseCase>(),
              addToWishlist: getIt<AddToWishlistUseCase>(),
              removeFromWishlist: getIt<RemoveFromWishlistUseCase>(),
            )..add(
              CountryDetailEvent.loadDetail(
                translation: country.commonName,
                previewCountry: country,
              ),
            ),
      ),
    ],
    child: CountryDetailView(country: country),
  );

  @override
  Widget build(BuildContext context) {
    final breakpoint = ResponsiveBreakpoints.of(context).breakpoint;
    return Scaffold(
      body: BlocListener<CountryDetailBloc, CountryDetailState>(
        listener: (context, state) {
          if (state.failure != null) {
            ShowFailure.instance.mapFailuresToNotification(
              context,
              failure: state.failure!,
            );
            context.read<CountryDetailBloc>().add(
              const CountryDetailEvent.invalidate(),
            );
          }
        },
        child: switch (breakpoint.name) {
          MOBILE => CountryDetailMobile(country: country),
          (_) => CountryDetailWeb(country: country),
        },
      ),
    );
  }
}
