import 'package:flutter/material.dart';

import 'package:water_tracker/core/theme/app_colors.dart';

/// Мини-столбцы недели как в макете (MiniBars в shared.jsx).
class MiniWeekBars extends StatelessWidget {
  const MiniWeekBars({
    super.key,
    required this.valuesMl,
    required this.goalMl,
    required this.todayIndex,
    this.height = 32,
  });

  final List<int> valuesMl;
  final int goalMl;
  final int todayIndex;
  final double height;

  @override
  Widget build(BuildContext context) {
    final Color track = AppColors.primary.withValues(alpha: 0.12);

    final int maxMl = () {
      final Iterable<int> vals = valuesMl.map((int v) => v);
      final int m = vals.isEmpty ? goalMl : vals.reduce((int a, int b) => a > b ? a : b);
      final int cap = (goalMl * 1.2).ceil();
      return m > cap ? m : cap;
    }();

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List<Widget>.generate(valuesMl.length, (int i) {
          final int v = valuesMl[i];
          final double h = maxMl <= 0 ? 2 : (v / maxMl) * height;
          final double barH = h.clamp(2.0, height);
          final bool isToday = i == todayIndex;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Container(
                    height: height,
                    decoration: BoxDecoration(
                      color: track,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: barH,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(
                          alpha: isToday ? 1 : 0.55,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
