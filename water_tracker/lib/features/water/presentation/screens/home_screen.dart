import 'dart:async' show unawaited;
import 'dart:math' show pi;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_tracker/core/providers/widget_sync_provider.dart';
import 'package:water_tracker/core/theme/app_colors.dart';
import 'package:water_tracker/l10n/app_localizations.dart';
import 'package:water_tracker/shared/services/notification_service.dart';
import 'package:water_tracker/shared/widgets/empty_state.dart';
import 'package:water_tracker/shared/widgets/shimmer_placeholder.dart';
import 'package:water_tracker/shared/widgets/water_drop_overlay.dart';
import 'package:water_tracker/features/water/domain/models/water_intake.dart';
import 'package:water_tracker/features/water/presentation/providers/water_provider.dart';
import 'package:water_tracker/features/water/presentation/widgets/intake_list_tile.dart';
import 'package:water_tracker/features/water/presentation/widgets/water_progress_circle.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final ConfettiController _confetti = ConfettiController(
    duration: const Duration(seconds: 2),
  );

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
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  Future<void> _onAdd(int amountMl) async {
    if (!mounted) {
      return;
    }
    HapticFeedback.mediumImpact();
    showWaterDropOverlay(Navigator.of(context));
    final AddIntakeResult r = await ref
        .read(todayIntakesProvider.notifier)
        .addIntake(amountMl);
    if (!mounted) {
      return;
    }
    final AppLocalizations l = AppLocalizations.of(context);
    if (r.queuedOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.addWater),
        ),
      );
    }
    if (r.goalFirstHit) {
      HapticFeedback.heavyImpact();
      _confetti.play();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.goalReached),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context);
    ref.watch(widgetSyncProvider);
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text(l.homeTitle),
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
                        child: Text(l.goalLoadError(e.toString())),
                      );
                    },
                    loading: () {
                      return const Center(
                        child: ShimmerCircleStat(diameter: 220),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      onPressed: () {
                        unawaited(_onAdd(250));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 72),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.water_drop,
                            size: 28,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l.addWaterAction,
                            style: const TextStyle(
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: OutlinedButton(
                                  onPressed: () {
                                    HapticFeedback.selectionClick();
                                    unawaited(_onAdd(ml));
                                  },
                                  child: Text(l.mlFormat(ml)),
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
                      l.todayHistory,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _TodayIntakesSection(
                    onAdd: _onAdd,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              maxBlastForce: 20,
              minBlastForce: 8,
              numberOfParticles: 18,
              shouldLoop: false,
              colors: const <Color>[
                AppColors.primary,
                AppColors.accent,
                AppColors.success,
                Colors.amber,
              ],
              blastDirection: -pi / 2,
            ),
          ),
        ),
      ],
    );
  }
}

class _TodayIntakesSection extends ConsumerWidget {
  const _TodayIntakesSection({required this.onAdd});

  final Future<void> Function(int amountMl) onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<WaterIntake>> intakes =
        ref.watch(todayIntakesProvider);
    final AppLocalizations l = AppLocalizations.of(context);
    return intakes.when(
      data: (List<WaterIntake> list) {
        if (list.isEmpty) {
          return AppEmptyState(
            message: l.addFirstIntake,
            actionLabel: l.emptyCta,
            onAction: () {
              unawaited(onAdd(250));
            },
          );
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
        return const ShimmerListPlaceholder();
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
                child: Text(l.retry),
              ),
            ],
          ),
        );
      },
    );
  }
}
