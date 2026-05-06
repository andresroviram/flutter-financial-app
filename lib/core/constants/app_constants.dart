import 'package:flutter/foundation.dart';

class AppConstants {
  const AppConstants._();

  static const String langEndpoint = '/lang/';
  static const String translationEndpoint = '/translation/';

  static const String appName = 'Country Explorer';
  static const bool isWeb = kIsWeb;
}
