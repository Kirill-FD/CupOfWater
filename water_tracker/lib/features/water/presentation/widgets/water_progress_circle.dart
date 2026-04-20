import 'dart:math' as math;
import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

import 'package:water_tracker/core/theme/app_colors.dart';

class WaterProgressCircle extends StatefulWidget {
  const WaterProgressCircle({
    super.key,
    required this.current,
    required this.goal,
    this.size = 280,
  });

  final int current;
  final int goal;
  final double size;

  @override
  State<WaterProgressCircle> createState() => _WaterProgressCircleState();
}

class _WaterProgressCircleState extends State<WaterProgressCircle>
    with TickerProviderStateMixin {
  static const double _kStroke = 16;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );
  late Animation<double> _animation;

  Tween<double> _tweenFor(double begin, double end) {
    return Tween<double>(begin: begin, end: end);
  }

  double get _targetPercent {
    if (widget.goal <= 0) {
      return 0.0;
    }
    return (widget.current / widget.goal).clamp(0.0, 1.0);
  }

  static double _targetPercentFor(int current, int goal) {
    if (goal <= 0) {
      return 0.0;
    }
    return (current / goal).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _animation = _tweenFor(0, _targetPercent).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
    unawaited(_controller.forward());
  }

  @override
  void didUpdateWidget(covariant WaterProgressCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.current == widget.current && oldWidget.goal == widget.goal) {
      return;
    }
    final double oldP =
        _targetPercentFor(oldWidget.current, oldWidget.goal);
    final double newP = _targetPercent;
    if ((oldP - newP).abs() < 1e-6) {
      return;
    }
    _controller.stop();
    _controller.reset();
    _animation = Tween<double>(begin: oldP, end: newP).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
    unawaited(_controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget? _) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _CirclePainter(
                  progress: _animation.value,
                  strokeWidth: _kStroke,
                ),
              );
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '${widget.current}',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                'из ${widget.goal} мл',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '${(_animation.value * 100).round()}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  _CirclePainter({required this.progress, required this.strokeWidth});

  final double progress;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset c = size.center(Offset.zero);
    final double r = (size.shortestSide - strokeWidth) / 2;
    final Rect ring = Rect.fromCircle(center: c, radius: r);

    final Paint track = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const double start = -math.pi / 2;
    const double kFull = math.pi * 2 - 1e-3;

    canvas.drawArc(
      ring,
      start,
      kFull,
      false,
      track,
    );

    if (progress <= 1e-4) {
      return;
    }

    final double sweep = math.min(math.pi * 2 * progress, kFull);
    final Rect gradBounds = Offset.zero & size;
    final Paint fill = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: const <Color>[AppColors.primaryLight, AppColors.primary],
        stops: const <double>[0, 1],
        tileMode: TileMode.clamp,
      ).createShader(gradBounds);

    canvas.drawArc(
      ring,
      start,
      sweep,
      false,
      fill,
    );
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

// -----------------------------------------------------------------------------
// BONUS: [WaterGlassAnimation] — «стакан с волной» (вынести в отдельный файл).
//  - [StatefulWidget] + [AnimationController], fill = percent
//  - [ClipPath(clipper: _WaveClipper(phase, amplitude, fillHeight))], внутри
//    [Container] с [LinearGradient] или [Container(color: ...)]
//  - [CustomClipper<Path>]: [Path] низ = прям. линия, «верх» = синус/куб. Безье
//    (two cycles), [phase] += 2 * pi * controller
//  - [Align] снизу, высота заливки: height = maxHeight * percent, clip сверху
// -----------------------------------------------------------------------------
