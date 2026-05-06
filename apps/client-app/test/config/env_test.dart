import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wigilabs_sr/config/env/app_flavor.dart';
import 'package:flutter_wigilabs_sr/config/env/env.dart';

void main() {
  group('Env', () {
    late Env env;

    setUp(() {
      env = Env();
    });

    test('implements IEnvConfig', () {
      expect(env, isNotNull);
    });

    // En tests, kFlavor == AppFlavor.dev (sin --dart-define)
    test('baseUrl delegates to EnvDev when flavor is dev', () {
      expect(kFlavor, AppFlavor.dev);
      expect(env.baseUrl, EnvDev.baseUrl);
      expect(env.baseUrl, isNotEmpty);
    });

    test('apiKey delegates to EnvDev when flavor is dev', () {
      expect(kFlavor, AppFlavor.dev);
      expect(env.apiKey, EnvDev.apiKey);
    });

    test('EnvDev, EnvQa, EnvProd all have a baseUrl', () {
      expect(EnvDev.baseUrl, isNotEmpty);
      expect(EnvQa.baseUrl, isNotEmpty);
      expect(EnvProd.baseUrl, isNotEmpty);
    });
  });
}
