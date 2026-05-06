import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../config/injectable/injectable_dependency.dart';
import '../core/performance/performance_settings.dart';

class PerformanceToggleButton extends StatelessWidget {
  PerformanceToggleButton({super.key});

  final PerformanceSettings _settings = getIt<PerformanceSettings>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _settings.useIsolate,
      builder: (context, useIsolate, _) {
        return Tooltip(
          message: useIsolate
              ? 'performance_toggle.active_tooltip'.tr()
              : 'performance_toggle.inactive_tooltip'.tr(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                useIsolate
                    ? Icons.check_circle_outline
                    : Icons.warning_amber_outlined,
                size: 16,
                color: useIsolate
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.error,
              ),
              const Gap(4),
              Text(
                'performance_toggle.label'.tr(),
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Switch(value: useIsolate, onChanged: (_) => _settings.toggle()),
            ],
          ),
        );
      },
    );
  }
}
