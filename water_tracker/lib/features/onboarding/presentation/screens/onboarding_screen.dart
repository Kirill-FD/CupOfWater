import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:water_tracker/core/theme/app_colors.dart';
import 'package:water_tracker/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:water_tracker/features/settings/presentation/providers/settings_provider.dart';
import 'package:water_tracker/features/settings/presentation/providers/user_weight_provider.dart';
import 'package:water_tracker/features/water/presentation/widgets/water_progress_circle.dart';
import 'package:water_tracker/l10n/app_localizations.dart';

/// Три шага onboarding по макету CupOfWater-design (screens-1.jsx).
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _step = 0;
  static const int _total = 3;

  final TextEditingController _weightController = TextEditingController(
    text: '62',
  );
  bool _isFinishing = false;

  @override
  void initState() {
    super.initState();
    _weightController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  int _goalFromWeightKg(double kg) {
    final int raw = (kg * 35).round();
    return ((raw / 50).round() * 50).clamp(1000, 4000).toInt();
  }

  Future<void> _finish({required bool applyWeight}) async {
    if (_isFinishing) {
      return;
    }
    setState(() => _isFinishing = true);
    FocusScope.of(context).unfocus();
    final AppLocalizations l = AppLocalizations.of(context);
    final double? kg = double.tryParse(
      _weightController.text.trim().replaceAll(',', '.'),
    );
    try {
      if (applyWeight && kg != null && kg > 0) {
        await ref.read(userWeightKgProvider.notifier).setKg(kg);
        final int goal = _goalFromWeightKg(kg);
        try {
          // Сохраняем цель до навигации, иначе главный экран и настройки успевают
          // прочитать из БД старый daily_goal_ml (гонка с unawaited updateGoal).
          await ref
              .read(userProfileNotifierProvider.notifier)
              .updateGoal(goal);
        } on Object catch (e) {
          // Завершение onboarding не блокируем: цель можно задать позже в настройках.
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.errorGeneric(e.toString()))),
            );
          }
        }
      }
      await ref.read(onboardingProvider.notifier).markCompleted();
      if (!mounted) {
        return;
      }
      context.go('/home');
    } on Object catch (e) {
      if (!mounted) {
        return;
      }
      setState(() => _isFinishing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.errorGeneric(e.toString()))),
      );
    }
  }

  void _next() {
    if (_step >= _total - 1) {
      unawaited(_finish(applyWeight: true));
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _skip() {
    unawaited(_finish(applyWeight: false));
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final bool dark = theme.brightness == Brightness.dark;
    final Color muted =
        dark ? const Color(0xFF93A8BC) : const Color(0xFF5B7184);

    final List<({String title, String body, IconData icon})> slides =
        <({String title, String body, IconData icon})>[
      (
        title: l.onboardingTitle1,
        body: l.onboardingBody1,
        icon: Icons.water_drop_outlined,
      ),
      (
        title: l.onboardingTitle2,
        body: l.onboardingBody2,
        icon: Icons.local_cafe_outlined,
      ),
      (
        title: l.onboardingTitle3,
        body: l.onboardingBody3,
        icon: Icons.person_outline,
      ),
    ];

    final double progress = (_step + 1) / _total;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(_total, (int i) {
                  final bool active = i == _step;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 4,
                    width: active ? 28 : 8,
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : theme.dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _total,
                  onPageChanged: (int i) {
                    setState(() => _step = i);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final ({String title, String body, IconData icon}) s =
                        slides[index];
                    return ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 260,
                          child: Center(
                            child: Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: dark
                                      ? const <Color>[
                                          Color(0xFF1A3A52),
                                          Color(0xFF0F2A40),
                                        ]
                                      : const <Color>[
                                          Color(0xFFE1F2FB),
                                          Color(0xFFC5E5F7),
                                        ],
                                ),
                              ),
                              alignment: Alignment.center,
                              child: WaterProgressCircle(
                                current: 0,
                                goal: 100,
                                size: 170,
                                animateWave: true,
                                progressOverride:
                                    progress.clamp(0.05, 1.0),
                                centerLabel: '',
                                centerSubLabel: '',
                              ),
                            ),
                          ),
                        ),
                        Text(
                          s.title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          s.body,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: muted,
                            height: 1.45,
                          ),
                        ),
                        if (index == 2) ...<Widget>[
                          const SizedBox(height: 20),
                          _PreviewCard(
                            label: l.onboardingWeightLabel,
                            child: TextField(
                              controller: _weightController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '62',
                                suffixText: l.onboardingKgSuffix,
                              ),
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _PreviewCard(
                            label: l.onboardingSuggestedGoal,
                            child: Text(
                              l.mlFormat(
                                () {
                                  final double? kg = double.tryParse(
                                    _weightController.text
                                        .trim()
                                        .replaceAll(',', '.'),
                                  );
                                  final int goal = kg != null && kg > 0
                                      ? _goalFromWeightKg(kg)
                                      : ref
                                              .watch(
                                                userProfileNotifierProvider,
                                              )
                                              .valueOrNull
                                              ?.dailyGoalMl ??
                                          2000;
                                  return goal;
                                }(),
                              ),
                              style:
                                  theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppColors.waterGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 22,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: _isFinishing ? null : _next,
                      child: Center(
                        child: _isFinishing && _step >= _total - 1
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _step >= _total - 1
                                    ? l.onboardingStart
                                    : l.onboardingNext,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_step < _total - 1)
                TextButton(
                  onPressed: _skip,
                  child: Text(
                    l.onboardingSkip,
                    style: TextStyle(
                      color: muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool dark = theme.brightness == Brightness.dark;
    final Color muted =
        dark ? const Color(0xFF93A8BC) : const Color(0xFF5B7184);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.6)),
        boxShadow: dark
            ? null
            : <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: muted,
              letterSpacing: 0.06,
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}
