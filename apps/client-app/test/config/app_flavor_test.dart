import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wigilabs_sr/config/env/app_flavor.dart';

void main() {
  group('AppFlavor.label', () {
    test('dev returns DEV', () {
      expect(AppFlavor.dev.label, 'DEV');
    });

    test('qa returns QA', () {
      expect(AppFlavor.qa.label, 'QA');
    });

    test('prod returns PROD', () {
      expect(AppFlavor.prod.label, 'PROD');
    });
  });

  group('AppFlavor.showBanner', () {
    test('dev shows banner', () {
      expect(AppFlavor.dev.showBanner, isTrue);
    });

    test('qa shows banner', () {
      expect(AppFlavor.qa.showBanner, isTrue);
    });

    test('prod does NOT show banner', () {
      expect(AppFlavor.prod.showBanner, isFalse);
    });
  });

  group('AppFlavor.bannerColor', () {
    test('dev is green', () {
      expect(AppFlavor.dev.bannerColor, 0xFF4CAF50);
      expect(Color(AppFlavor.dev.bannerColor), const Color(0xFF4CAF50));
    });

    test('qa is orange', () {
      expect(AppFlavor.qa.bannerColor, 0xFFFF9800);
      expect(Color(AppFlavor.qa.bannerColor), const Color(0xFFFF9800));
    });

    test('prod is red', () {
      expect(AppFlavor.prod.bannerColor, 0xFFF44336);
      expect(Color(AppFlavor.prod.bannerColor), const Color(0xFFF44336));
    });
  });

  group('kFlavor', () {
    test('defaults to dev when no --dart-define is provided', () {
      // En tests sin --dart-define=FLAVOR=X el valor es 'dev'
      expect(kFlavor, AppFlavor.dev);
    });
  });
}
