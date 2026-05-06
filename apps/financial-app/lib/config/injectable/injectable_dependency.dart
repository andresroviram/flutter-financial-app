import 'package:core/injectable.module.dart';
import 'package:feature_funds/injectable.module.dart';
import 'package:financial_app/config/injectable/injectable_dependency.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit(
  externalPackageModulesBefore: [
    ExternalModule(CorePackageModule),
    ExternalModule(FeatureFundsPackageModule),
  ],
)
Future<void> configureDependencies() => getIt.init();
