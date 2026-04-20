import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:water_tracker/core/theme/app_colors.dart';

/// Круговой прогресс; полная визуализация в следующем прототипе.
class WaterProgressCircle extends StatelessWidget {
  const WaterProgressCircle({
    super.key,
    required this.current,
    required this.goal,
    required this.size,
  });

  final int current;
  final int goal;
  final double size;

  @override
  Widget build(BuildContext context) {
    final int safeGoal = goal <= 0 ? 1 : goal;
    final double ratio = (current / safeGoal).clamp(0.0, 1.0);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _WaterProgressPainter(
          progress: ratio,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '$current / $goal',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'мл',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WaterProgressPainter extends CustomPainter {
  _WaterProgressPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final double stroke = 14;
    final Offset c = size.center(Offset.zero);
    final double r = (size.shortestSide - stroke) / 2;
    final Rect rect = Rect.fromCircle(center: c, radius: r);

    final Paint base = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final Paint fill = Paint()
      ..shader = const LinearGradient(
        colors: <Color>[AppColors.primaryLight, AppColors.primary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    const double start = -math.pi / 2;
    final double sweep = 2 * math.pi * progress;
    final double endAngle = 2 * math.pi - 0.01;

    canvas.drawArc(
      rect,
      start,
      endAngle,
      false,
      base,
    );
    if (sweep > 0) {
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaterProgressPainter old) {
    return old.progress != progress;
  }
}
