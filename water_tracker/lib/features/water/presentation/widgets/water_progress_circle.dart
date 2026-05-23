import 'dart:math' as math;
import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:water_tracker/core/theme/app_colors.dart';

/// Круговой прогресс «стакан с волной» по макету CupOfWater-design (shared.jsx).
class WaterProgressCircle extends StatefulWidget {
  const WaterProgressCircle({
    super.key,
    required this.current,
    required this.goal,
    this.size = 280,
    this.animateWave = true,
    this.progressOverride,
    this.centerLabel,
    this.centerSubLabel,
    this.darkOverride,
  });

  final int current;
  final int goal;
  final double size;
  final bool animateWave;

  /// Явная доля заполнения 0..1 (например onboarding).
  final double? progressOverride;

  /// Заголовок по центру; `null` — число [current] с локальным форматированием.
  final String? centerLabel;

  /// Подзаголовок; `null` — строка вида «из N мл» при [goal] > 0.
  final String? centerSubLabel;

  /// Явная тёмная тема для отрисовки.
  final bool? darkOverride;

  @override
  State<WaterProgressCircle> createState() => _WaterProgressCircleState();
}

class _WaterProgressCircleState extends State<WaterProgressCircle>
    with TickerProviderStateMixin {
  static const double _kStroke = 14;

  late final AnimationController _fillController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );
  late Animation<double> _fillAnimation;

  late final AnimationController _wave1 = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  );
  late final AnimationController _wave2 = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  );

  double get _targetPercent {
    if (widget.progressOverride != null) {
      return widget.progressOverride!.clamp(0.0, 1.0);
    }
    if (widget.goal <= 0) {
      return 0;
    }
    return (widget.current / widget.goal).clamp(0.0, 1.0);
  }

  static double _percentFor({
    required int current,
    required int goal,
    double? override,
  }) {
    if (override != null) {
      return override.clamp(0.0, 1.0);
    }
    if (goal <= 0) {
      return 0;
    }
    return (current / goal).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _fillAnimation = Tween<double>(begin: 0, end: _targetPercent).animate(
      CurvedAnimation(parent: _fillController, curve: Curves.easeOutCubic),
    );
    unawaited(_fillController.forward());
    if (widget.animateWave) {
      unawaited(_wave1.repeat());
      unawaited(_wave2.repeat());
    }
  }

  @override
  void didUpdateWidget(covariant WaterProgressCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    final double oldP = _percentFor(
      current: oldWidget.current,
      goal: oldWidget.goal,
      override: oldWidget.progressOverride,
    );
    final double newP = _percentFor(
      current: widget.current,
      goal: widget.goal,
      override: widget.progressOverride,
    );
    if ((oldP - newP).abs() < 1e-6) {
      return;
    }
    _fillController.stop();
    _fillController.reset();
    _fillAnimation = Tween<double>(begin: oldP, end: newP).animate(
      CurvedAnimation(parent: _fillController, curve: Curves.easeOutCubic),
    );
    unawaited(_fillController.forward());
  }

  @override
  void dispose() {
    _fillController.dispose();
    _wave1.dispose();
    _wave2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool dark =
        widget.darkOverride ?? Theme.of(context).brightness == Brightness.dark;
    final String locale = Localizations.localeOf(context).toString();
    final NumberFormat fmt = NumberFormat.decimalPattern(locale);

    final String mainLabel =
        widget.centerLabel ?? fmt.format(widget.current);

    final String subResolved = widget.centerSubLabel ??
        (widget.goal > 0 ? 'из ${fmt.format(widget.goal)} мл' : '');

    final Color textMain = dark ? Colors.white : const Color(0xFF0E2235);

    return AnimatedBuilder(
      animation: _fillAnimation,
      builder: (BuildContext context, Widget? _) {
        final bool shadowText = _fillAnimation.value > 0.4;
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AnimatedBuilder(
                animation: Listenable.merge(
                  <Listenable>[_fillAnimation, _wave1, _wave2],
                ),
                builder: (BuildContext context, Widget? _) {
                  return CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _CircularWaterPainter(
                      progress: _fillAnimation.value,
                      wavePhase1:
                          widget.animateWave ? _wave1.value * 2 * math.pi : 0,
                      wavePhase2:
                          widget.animateWave ? _wave2.value * 2 * math.pi : 0,
                      strokeWidth: _kStroke,
                      dark: dark,
                      animateWave: widget.animateWave,
                    ),
                  );
                },
              ),
              IgnorePointer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (mainLabel.isNotEmpty)
                      Text(
                        mainLabel,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: widget.size * 0.18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.02 * widget.size * 0.18,
                          height: 1,
                          color: textMain,
                          shadows: shadowText
                              ? const <Shadow>[
                                  Shadow(
                                    blurRadius: 8,
                                    color: Color(0x2E000000),
                                    offset: Offset(0, 1),
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    if (subResolved.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 6),
                      Text(
                        subResolved,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: widget.size * 0.055,
                          fontWeight: FontWeight.w500,
                          color: textMain.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CircularWaterPainter extends CustomPainter {
  _CircularWaterPainter({
    required this.progress,
    required this.wavePhase1,
    required this.wavePhase2,
    required this.strokeWidth,
    required this.dark,
    required this.animateWave,
  });

  final double progress;
  final double wavePhase1;
  final double wavePhase2;
  final double strokeWidth;
  final bool dark;
  final bool animateWave;

  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = (size.shortestSide - strokeWidth) / 2;
    final double innerR = r - strokeWidth / 2 - 4;

    final Color accent = dark ? AppColors.primaryLight : AppColors.primary;
    final Color accentDeep =
        dark ? AppColors.primary : AppColors.primaryDark;
    final Color accentLight =
        dark ? const Color(0xFF81D4FA) : AppColors.primaryLight;

    final Paint trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = dark
          ? Colors.white.withValues(alpha: 0.08)
          : AppColors.primary.withValues(alpha: 0.12);

    canvas.drawCircle(Offset(cx, cy), r, trackPaint);

    final Path clipInner = Path()
      ..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: innerR));

    canvas.save();
    canvas.clipPath(clipInner);

    final double waveLevel = cy + innerR - innerR * 2 * progress;

    final Paint gradPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[accentLight, accent],
      ).createShader(Rect.fromLTWH(0, waveLevel, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, waveLevel, size.width, size.height - waveLevel),
      gradPaint,
    );

    if (animateWave) {
      final Paint wave1 = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[accentLight, accent],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;

      _drawWaveLayer(
        canvas,
        size,
        baseY: waveLevel,
        amplitude: 10,
        wavelength: size.width / 2,
        phase: wavePhase1,
        paint: wave1..color = accent.withValues(alpha: 0.85),
      );

      final Paint wave2 = Paint()
        ..color = accentDeep.withValues(alpha: 0.45)
        ..style = PaintingStyle.fill;
      _drawWaveLayer(
        canvas,
        size,
        baseY: waveLevel + 4,
        amplitude: 8,
        wavelength: size.width / 2.5,
        phase: -wavePhase2 + 1.2,
        paint: wave2,
      );
    }

    final Paint shine = Paint()
      ..color = Colors.white.withValues(alpha: 0.4);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx - innerR * 0.35, waveLevel + 16),
        width: innerR * 0.55,
        height: 6,
      ),
      shine,
    );

    canvas.restore();

    final Paint arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = accent;

    final double sweep = 2 * math.pi * progress * 0.999;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -math.pi / 2,
      sweep,
      false,
      arcPaint,
    );

    final Paint rim = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = dark
          ? Colors.white.withValues(alpha: 0.06)
          : Colors.white.withValues(alpha: 0.6);
    canvas.drawCircle(Offset(cx, cy), innerR, rim);
  }

  void _drawWaveLayer(
    Canvas canvas,
    Size size, {
    required double baseY,
    required double amplitude,
    required double wavelength,
    required double phase,
    required Paint paint,
  }) {
    final Path path = Path();
    path.moveTo(-size.width, baseY);
    const double step = 6;
    for (double x = -size.width; x <= size.width * 2; x += step) {
      final double y =
          baseY + amplitude * math.sin(x / wavelength * 2 * math.pi + phase);
      path.lineTo(x, y);
    }
    path.lineTo(size.width * 2, size.height + size.height);
    path.lineTo(-size.width, size.height + size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CircularWaterPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.wavePhase1 != wavePhase1 ||
        oldDelegate.wavePhase2 != wavePhase2 ||
        oldDelegate.dark != dark ||
        oldDelegate.animateWave != animateWave;
  }
}
