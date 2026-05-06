import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../config/injectable/injectable_dependency.dart';
import '../core/performance/performance_settings.dart';
import '../core/performance/performance_settings_state.dart';

class PerformanceToggleButton extends StatelessWidget {
  PerformanceToggleButton({super.key});

  final PerformanceSettingsCubit _cubit = getIt<PerformanceSettingsCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PerformanceSettingsCubit, PerformanceSettingsState>(
      bloc: _cubit,
      builder: (context, state) {
        final useIsolate = state.useIsolate;
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
              Switch(
                value: useIsolate,
                onChanged: (_) => _cubit.toggleIsolate(),
              ),
            ],
          ),
        );
      },
    );
  }
}
