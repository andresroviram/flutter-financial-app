import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../core/error/error.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.failure});

  final Failure failure;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const Gap(16),
          Text(
            failure is NetworkFailure
                ? 'errors.no_internet'.tr()
                : 'errors.load_detail'.tr(),
          ),
        ],
      ),
    );
  }
}
