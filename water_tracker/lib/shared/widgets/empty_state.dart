// Пустое состояние: иллюстрация + текст + CTA (по заданию).

import 'package:flutter/material.dart';
import 'package:water_tracker/core/theme/app_colors.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.message,
    this.assetPath = 'assets/empty/illustration.png',
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? assetPath;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (assetPath != null) ...<Widget>[
              Image.asset(
                assetPath!,
                width: 200,
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (BuildContext c, Object e, StackTrace? s) {
                  return const Icon(
                    Icons.water_drop_outlined,
                    size: 72,
                    color: AppColors.primary,
                  );
                },
              ),
              const SizedBox(height: 16),
            ] else
              const Icon(
                Icons.water_drop_outlined,
                size: 72,
                color: AppColors.primary,
              ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (actionLabel != null && onAction != null) ...<Widget>[
              const SizedBox(height: 20),
              FilledButton.tonal(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
