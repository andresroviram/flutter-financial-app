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

  static const String pathMobile = '/country_detail';
  static const String nameMobile = 'country_detail_mobile';

  static const String pathWeb = 'country/:countryCode';
  static const String nameWeb = 'country_detail_web';

  static Widget create({CountryEntity? country, String? countryCode}) {
    assert(
      country != null || countryCode != null,
      'Either country or countryCode must be provided',
    );

    final effectiveCountry =
        country ??
        CountryEntity(
          cca2: countryCode!,
          commonName: countryCode,
          officialName: countryCode,
          region: '',
          population: 0,
          flagPng: '',
        );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (_) {
            final bloc = CountryDetailBloc(
              getCountryDetail: getIt<GetCountryDetailUseCase>(),
              getCountryByCode: getIt<GetCountryByCodeUseCase>(),
              isInWishlist: getIt<IsInWishlistUseCase>(),
              addToWishlist: getIt<AddToWishlistUseCase>(),
              removeFromWishlist: getIt<RemoveFromWishlistUseCase>(),
            );

            // Si tenemos el objeto country completo, usar loadDetail con el nombre
            // Si solo tenemos el código, usar loadDetailByCode
            if (country != null) {
              bloc.add(
                CountryDetailEvent.loadDetail(
                  name: country.commonName,
                  previewCountry: country,
                ),
              );
            } else {
              bloc.add(
                CountryDetailEvent.loadDetailByCode(
                  code: countryCode!,
                  previewCountry: effectiveCountry,
                ),
              );
            }

            return bloc;
          },
        ),
      ],
      child: CountryDetailView(country: effectiveCountry),
    );
  }

  @override
  Widget build(BuildContext context) {
    final breakpoint = ResponsiveBreakpoints.of(context).breakpoint;
    return Scaffold(
      body: BlocListener<CountryDetailBloc, CountryDetailState>(
        listenWhen: (previous, current) =>
            previous.failure != current.failure && current.failure != null,
        listener: (context, state) {
          if (context.mounted) {
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
