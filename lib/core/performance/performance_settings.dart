import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PerformanceSettings {
  final ValueNotifier<bool> useIsolate = ValueNotifier(true);

  void toggle() => useIsolate.value = !useIsolate.value;
}
