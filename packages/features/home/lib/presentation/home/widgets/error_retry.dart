import 'package:core/errors/error.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ErrorRetry extends StatelessWidget {
  const ErrorRetry({super.key, required this.failure, required this.onRetry});

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final message = failure is NetworkFailure
        ? 'Sin conexión a internet'
        : 'Error al cargar los países';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const Gap(16),
            Text(message, textAlign: TextAlign.center),
            const Gap(16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
