import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_tracker/core/providers/widget_sync_provider.dart';
import 'package:water_tracker/core/theme/app_colors.dart';
import 'package:water_tracker/shared/services/notification_service.dart';
import 'package:water_tracker/features/water/domain/models/water_intake.dart';
import 'package:water_tracker/features/water/presentation/providers/water_provider.dart';
import 'package:water_tracker/features/water/presentation/widgets/intake_list_tile.dart';
import 'package:water_tracker/features/water/presentation/widgets/water_progress_circle.dart';
import 'package:water_tracker/shared/widgets/empty_state_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (!context.mounted) {
        return;
      }
      unawaited(NotificationService.instance.requestPermissionsIfFirstTime());
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(widgetSyncProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сегодня'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(todayIntakesProvider);
            ref.invalidate(dailyWaterGoalProvider);
            await ref.read(todayIntakesProvider.future);
            await ref.read(dailyWaterGoalProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              const SizedBox(height: 32),
              ref.watch(dailyWaterGoalProvider).when(
                data: (int goal) {
                  return Center(
                    child: WaterProgressCircle(
                      current: ref.watch(todayTotalProvider),
                      goal: goal,
                      size: 280,
                    ),
                  );
                },
                error: (Object e, StackTrace s) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Не удалось загрузить цель: $e'),
                  );
                },
                loading: () {
                  return const Center(
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    unawaited(
                      ref
                          .read(todayIntakesProvider.notifier)
                          .addIntake(250),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 72),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.water_drop,
                        size: 28,
                        color: Colors.white,
                      ),
                      SizedBox(width: 12),
                      Text(
                        '+ 250 мл',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <int>[100, 200, 500, 750]
                      .map(
                        (int ml) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: OutlinedButton(
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                unawaited(
                                  ref
                                      .read(todayIntakesProvider.notifier)
                                      .addIntake(ml),
                                );
                              },
                              child: Text('$ml'),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'История сегодня',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 8),
              _TodayIntakesSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodayIntakesSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<WaterIntake>> intakes =
        ref.watch(todayIntakesProvider);
    return intakes.when(
      data: (List<WaterIntake> list) {
        if (list.isEmpty) {
          return const EmptyStateWidget('Добавьте первый стакан');
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: list.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int i) {
            return IntakeListTile(intake: list[i]);
          },
        );
      },
      loading: () {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (Object e, StackTrace s) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                e.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  ref.invalidate(todayIntakesProvider);
                },
                child: const Text('Повторить'),
              ),
            ],
          ),
        );
      },
    );
  }
}
