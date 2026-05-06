import 'package:flutter_wigilabs_sr/config/routes/app_router_web.dart'
    if (dart.library.io) 'app_router_mobile.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RouterModule {
  @singleton
  GoRouter get router => createRouter();
}
