import 'package:core/injectable.module.dart';
import 'package:feature_home/injectable.module.dart';
import 'package:feature_wishlist/injectable.module.dart';
import 'package:flutter_wigilabs_sr/config/injectable/injectable_dependency.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit(
  externalPackageModulesBefore: [
    ExternalModule(CorePackageModule),
    ExternalModule(FeatureHomePackageModule),
    ExternalModule(FeatureWishlistPackageModule),
  ],
)
Future<void> configureDependencies() => getIt.init();
