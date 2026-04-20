import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;
import 'package:url_launcher/url_launcher.dart';
import 'package:water_tracker/core/providers/app_theme_mode_provider.dart';
import 'package:water_tracker/shared/services/notification_service.dart';
import 'package:water_tracker/core/theme/app_colors.dart';
import 'package:water_tracker/features/auth/domain/models/user_profile.dart';
import 'package:water_tracker/features/auth/presentation/providers/auth_provider.dart';
import 'package:water_tracker/features/settings/presentation/providers/settings_provider.dart';
import 'package:water_tracker/features/water/presentation/providers/water_provider.dart';

const List<int> kReminderIntervalOptions = <int>[30, 45, 60, 90, 120];

/// Замените ссылку на фактическую политику конфиденциальности.
final Uri kPrivacyUrl = Uri.parse('https://www.example.com/privacy');

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? user = ref.watch(currentUserProvider);
    final String email = user?.email ?? '—';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        automaticallyImplyLeading: false,
      ),
      body: ref.watch(userProfileNotifierProvider).when(
            data: (UserProfile p) {
              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: <Widget>[
                  _sectionTitle(context, 'Профиль'),
                  ListTile(
                    title: const Text('Email'),
                    subtitle: Text(email),
                  ),
                  ListTile(
                    title: const Text('Имя'),
                    subtitle: Text(
                      p.displayName?.isNotEmpty == true
                          ? p.displayName!
                          : 'Не указано',
                    ),
                    trailing: const Icon(Icons.edit_outlined),
                    onTap: () {
                      unawaited(_showEditNameDialog(context, ref, p));
                    },
                  ),
                  const Divider(height: 1),
                  _sectionTitle(context, 'Цель'),
                  ListTile(
                    title: const Text('Дневная цель'),
                    subtitle: Text('${p.dailyGoalMl} мл'),
                    onTap: () {
                      unawaited(_showGoalDialog(context, ref, p));
                    },
                  ),
                  const Divider(height: 1),
                  _sectionTitle(context, 'Напоминания'),
                  SwitchListTile(
                    title: const Text('Напоминания'),
                    value: p.reminderEnabled,
                    onChanged: (bool v) {
                      unawaited(
                        ref
                            .read(userProfileNotifierProvider.notifier)
                            .updateReminders(
                              enabled: v,
                              intervalMinutes: p.reminderIntervalMinutes,
                              startTime: p.startTimeOfDay,
                              endTime: p.endTimeOfDay,
                            )
                            .then((void _) {})
                            .catchError(
                              (Object? e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Напоминания: $e'),
                                    ),
                                  );
                                }
                              },
                            ),
                      );
                    },
                  ),
                  if (p.reminderEnabled) ...<Widget>[
                    ListTile(
                      title: const Text('Интервал'),
                      subtitle: Text('${p.reminderIntervalMinutes} минут'),
                      onTap: () {
                        unawaited(
                          _showIntervalBottomSheet(
                            context,
                            ref,
                            p,
                            p.reminderIntervalMinutes,
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('С'),
                      subtitle: Text(
                        MaterialLocalizations.of(context)
                            .formatTimeOfDay(p.startTimeOfDay),
                      ),
                      onTap: () {
                        unawaited(_pickTime(context, ref, p, isStart: true));
                      },
                    ),
                    ListTile(
                      title: const Text('До'),
                      subtitle: Text(
                        MaterialLocalizations.of(context)
                            .formatTimeOfDay(p.endTimeOfDay),
                      ),
                      onTap: () {
                        unawaited(_pickTime(context, ref, p, isStart: false));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextButton(
                        onPressed: () {
                          unawaited(
                            NotificationService.instance
                                .showImmediate('Тест', 'Уведомления настроены'),
                          );
                        },
                        child: const Text('Тестовое уведомление'),
                      ),
                    ),
                  ],
                  const Divider(height: 1),
                  _sectionTitle(context, 'Внешний вид'),
                  ref.watch(appThemeModeProvider).when(
                    data: (ThemeMode m) {
                      return SwitchListTile(
                        title: const Text('Тёмная тема'),
                        value: m == ThemeMode.dark,
                        onChanged: (bool v) {
                          unawaited(
                            ref
                                .read(appThemeModeProvider.notifier)
                                .setDarkMode(v),
                          );
                        },
                      );
                    },
                    loading: () {
                      return const SwitchListTile(
                        title: Text('Тёмная тема'),
                        value: false,
                        onChanged: null,
                      );
                    },
                    error: (Object? _, Object? __) {
                      return const ListTile(
                        title: Text('Ошибка загрузки темы'),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _sectionTitle(context, 'Аккаунт'),
                  ListTile(
                    title: const Text(
                      'Выйти',
                      style: TextStyle(color: AppColors.error),
                    ),
                    leading: const Icon(
                      Icons.logout,
                      color: AppColors.error,
                    ),
                    onTap: () {
                      unawaited(_showLogoutDialog(context, ref));
                    },
                  ),
                  const Divider(height: 1),
                  _sectionTitle(context, 'О приложении'),
                  const ListTile(
                    title: Text('Версия'),
                    subtitle: Text('1.0.0'),
                  ),
                  ListTile(
                    title: const Text('Политика конфиденциальности'),
                    trailing: const Icon(Icons.open_in_new, size: 20),
                    onTap: () {
                      unawaited(_openPrivacy(context));
                    },
                  ),
                ],
              );
            },
            error: (Object e, Object st) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(Icons.error_outline, size: 40),
                    const SizedBox(height: 12),
                    const Text('Не удалось загрузить профиль'),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        ref.invalidate(userProfileNotifierProvider);
                      },
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              );
            },
            loading: () {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
    );
  }

  static Widget _sectionTitle(BuildContext context, String t) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          t,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

Future<void> _showEditNameDialog(
  BuildContext context,
  WidgetRef ref,
  UserProfile profile,
) async {
  final TextEditingController c = TextEditingController(
    text: profile.displayName ?? '',
  );
  try {
    await showDialog<void>(
      context: context,
      builder: (BuildContext dContext) {
        return AlertDialog(
          title: const Text('Имя'),
          content: TextField(
            controller: c,
            decoration: const InputDecoration(
              labelText: 'Как вас зовут',
              hintText: 'Введите имя',
            ),
            textCapitalization: TextCapitalization.words,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dContext).pop();
              },
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () async {
                final NavigatorState nav = Navigator.of(dContext);
                try {
                  await ref
                      .read(userProfileNotifierProvider.notifier)
                      .updateDisplayName(c.text.trim());
                  if (dContext.mounted) {
                    nav.pop();
                  }
                } on Object catch (e) {
                  if (dContext.mounted) {
                    ScaffoldMessenger.of(dContext).showSnackBar(
                      SnackBar(content: Text('Ошибка: $e')),
                    );
                  }
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  } finally {
    c.dispose();
  }
}

Future<void> _showGoalDialog(
  BuildContext context,
  WidgetRef ref,
  UserProfile profile,
) async {
  int goal = profile.dailyGoalMl.clamp(1000, 4000) as int;
  if (goal % 50 != 0) {
    goal = (goal / 50).round() * 50;
  }
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) st) {
          return AlertDialog(
            title: const Text('Дневная цель'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('${goal} мл', style: Theme.of(context).textTheme.titleLarge),
                Slider(
                  value: goal.toDouble(),
                  min: 1000,
                  max: 4000,
                  divisions: 60,
                  label: '$goal мл',
                  onChanged: (double v) {
                    st(() {
                      goal = (v / 50).round() * 50;
                    });
                  },
                ),
                TextButton(
                  onPressed: () {
                    unawaited(
                      _showWeightForGoal(
                        context,
                        (int newGoal) {
                          st(() {
                            goal = newGoal;
                          });
                        },
                      ),
                    );
                  },
                  child: const Text('Рассчитать по весу'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Отмена'),
              ),
              FilledButton(
                onPressed: () {
                  unawaited(
                    ref
                        .read(userProfileNotifierProvider.notifier)
                        .updateGoal(goal)
                        .then(
                      (void _) {
                        if (context.mounted) {
                          ref.invalidate(dailyWaterGoalProvider);
                          Navigator.of(context).pop();
                        }
                      },
                    ).catchError(
                      (Object? e) {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Ошибка: $e'),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
                child: const Text('Сохранить'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> _showWeightForGoal(
  BuildContext parentContext,
  void Function(int goalMl) onGoalComputed,
) async {
  final TextEditingController w = TextEditingController();
  try {
    final bool? done = await showDialog<bool>(
      context: parentContext,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Вес, кг'),
          content: TextField(
            controller: w,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: 'Напр. 70',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    if (done != true) {
      return;
    }
    final double? k = double.tryParse(
      w.text.trim().replaceAll(',', '.'),
    );
    if (k == null) {
      return;
    }
    final int targetMl = (k * 35).round();
    final int snapped = ((targetMl / 50).round() * 50)
        .clamp(1000, 4000)
        .toInt();
    onGoalComputed(snapped);
  } finally {
    w.dispose();
  }
}

Future<void> _showIntervalBottomSheet(
  BuildContext context,
  WidgetRef ref,
  UserProfile profile,
  int current,
) async {
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (BuildContext c) {
      return SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            for (final int m in kReminderIntervalOptions)
              ListTile(
                title: Text('$m мин'),
                selected: m == current,
                onTap: () {
                  Navigator.of(c).pop();
                  unawaited(
                    ref
                        .read(userProfileNotifierProvider.notifier)
                        .updateReminders(
                          enabled: true,
                          intervalMinutes: m,
                          startTime: profile.startTimeOfDay,
                          endTime: profile.endTimeOfDay,
                        )
                        .catchError(
                      (Object? e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Ошибка: $e'),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      );
    },
  );
}

Future<void> _pickTime(
  BuildContext context,
  WidgetRef ref,
  UserProfile p, {
  required bool isStart,
}) async {
  final TimeOfDay initial = isStart ? p.startTimeOfDay : p.endTimeOfDay;
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: initial,
  );
  if (picked == null || !context.mounted) {
    return;
  }
  if (isStart) {
    await ref.read(userProfileNotifierProvider.notifier).updateReminders(
          enabled: p.reminderEnabled,
          intervalMinutes: p.reminderIntervalMinutes,
          startTime: picked,
          endTime: p.endTimeOfDay,
        );
  } else {
    await ref.read(userProfileNotifierProvider.notifier).updateReminders(
          enabled: p.reminderEnabled,
          intervalMinutes: p.reminderIntervalMinutes,
          startTime: p.startTimeOfDay,
          endTime: picked,
        );
  }
}

Future<void> _openPrivacy(BuildContext context) async {
  if (!context.mounted) {
    return;
  }
  final bool ok = await launchUrl(
    kPrivacyUrl,
    mode: LaunchMode.externalApplication,
  );
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Не удалось открыть ссылку'),
      ),
    );
  }
}

Future<void> _showLogoutDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final bool? r = await showDialog<bool>(
    context: context,
    builder: (BuildContext c) {
      return AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(c).pop(false);
            },
            child: const Text('Отмена'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            onPressed: () {
              Navigator.of(c).pop(true);
            },
            child: const Text('Выйти'),
          ),
        ],
      );
    },
  );
  if (r == true) {
    try {
      await ref.read(authRepositoryProvider).signOut();
    } on Object catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не вышли: $e')),
        );
      }
    }
  }
}
