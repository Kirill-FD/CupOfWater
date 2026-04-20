import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:water_tracker/core/theme/app_colors.dart';
import 'package:water_tracker/features/water/domain/models/water_intake.dart';
import 'package:water_tracker/features/water/presentation/providers/water_provider.dart';

class IntakeListTile extends ConsumerWidget {
  const IntakeListTile({
    super.key,
    required this.intake,
  });

  final WaterIntake intake;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey<String>(intake.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (DismissDirection d) {
        unawaited(
          ref.read(todayIntakesProvider.notifier).deleteIntake(intake.id),
        );
      },
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Icon(
            Icons.water_drop,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text('${intake.amountMl} мл'),
        subtitle: Text(DateFormat('HH:mm').format(intake.consumedAt)),
      ),
    );
  }
}
