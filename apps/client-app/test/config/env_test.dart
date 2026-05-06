import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wigilabs_sr/config/env/app_flavor.dart';
import 'package:flutter_wigilabs_sr/config/env/env.dart';

void main() {
  group('Env', () {
    test('implements IEnvConfig', () {
      expect(Env(), isNotNull);
    });

    // ── dev (kFlavor default en tests) ────────────────────────────────
    test('baseUrl delegates to EnvDev when flavor is dev', () {
      final env = Env(flavor: AppFlavor.dev);
      expect(env.baseUrl, EnvDev.baseUrl);
      expect(env.baseUrl, isNotEmpty);
    });

    test('apiKey delegates to EnvDev when flavor is dev', () {
      final env = Env(flavor: AppFlavor.dev);
      expect(env.apiKey, EnvDev.apiKey);
    });

    // ── qa ────────────────────────────────────────────────────────────
    test('baseUrl delegates to EnvQa when flavor is qa', () {
      final env = Env(flavor: AppFlavor.qa);
      expect(env.baseUrl, EnvQa.baseUrl);
      expect(env.baseUrl, isNotEmpty);
    });

    test('apiKey delegates to EnvQa when flavor is qa', () {
      final env = Env(flavor: AppFlavor.qa);
      expect(env.apiKey, EnvQa.apiKey);
    });

    // ── prod ──────────────────────────────────────────────────────────
    test('baseUrl delegates to EnvProd when flavor is prod', () {
      final env = Env(flavor: AppFlavor.prod);
      expect(env.baseUrl, EnvProd.baseUrl);
      expect(env.baseUrl, isNotEmpty);
    });

    test('apiKey delegates to EnvProd when flavor is prod', () {
      final env = Env(flavor: AppFlavor.prod);
      expect(env.apiKey, EnvProd.apiKey);
    });

    // ── static fields ─────────────────────────────────────────────────
    test('all flavors expose a non-empty baseUrl', () {
      expect(EnvDev.baseUrl, isNotEmpty);
      expect(EnvQa.baseUrl, isNotEmpty);
      expect(EnvProd.baseUrl, isNotEmpty);
    });

    test('all flavors expose an apiKey (may be empty)', () {
      expect(EnvDev.apiKey, isNotNull);
      expect(EnvQa.apiKey, isNotNull);
      expect(EnvProd.apiKey, isNotNull);
    });
  });
}
