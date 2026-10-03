import 'dart:math' as math;

import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:flutter/material.dart';

/// Circular progress ring with an optional centre widget.
class VRing extends StatelessWidget {
  const VRing({
    required this.fraction,
    required this.color,
    this.size = 100,
    this.stroke = 9,
    this.child,
    super.key,
  });

  final double fraction;
  final Color color;
  final double size;
  final double stroke;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(fraction.clamp(0.0, 1.0), color, stroke),
        child: Center(child: child),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.fraction, this.color, this.stroke);

  final double fraction;
  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final arc = (Offset.zero & size).deflate(stroke / 2);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = const Color(0x47808080);
    canvas.drawArc(arc, 0, math.pi * 2, false, base);
    canvas.drawArc(
      arc,
      -math.pi / 2,
      math.pi * 2 * fraction,
      false,
      base
        ..color = color
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fraction != fraction || old.color != color || old.stroke != stroke;
}

/// Simple line (optionally filled) chart over [values].
class VLinePlot extends StatelessWidget {
  const VLinePlot({
    required this.values,
    this.height = 60,
    this.color = VeyroColors.accent,
    this.fill = false,
    this.strokeWidth = 3,
    super.key,
  });

  final List<double> values;
  final double height;
  final Color color;
  final bool fill;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: CustomPaint(painter: _LinePainter(values, color, fill, strokeWidth)),
  );
}

class _LinePainter extends CustomPainter {
  _LinePainter(this.values, this.color, this.fill, this.strokeWidth);

  final List<double> values;
  final Color color;
  final bool fill;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final lo = values.reduce(math.min);
    final hi = values.reduce(math.max);
    final span = (hi - lo) == 0 ? 1.0 : hi - lo;
    const pad = 6.0;
    Offset at(int i) => Offset(
      i / (values.length - 1) * size.width,
      pad + (1 - (values[i] - lo) / span) * (size.height - 2 * pad),
    );
    final path = Path()..moveTo(at(0).dx, at(0).dy);
    for (var i = 1; i < values.length; i++) {
      path.lineTo(at(i).dx, at(i).dy);
    }
    if (fill) {
      final area = Path.from(path)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(area, Paint()..color = color.withValues(alpha: .14));
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_LinePainter old) =>
      old.values != values || old.color != color || old.fill != fill;
}

/// Vertical bar chart with a value caption above and a label below each bar.
class VBarChart extends StatelessWidget {
  const VBarChart({
    required this.values,
    required this.labels,
    required this.colors,
    this.captions,
    this.height = 140,
    this.maxValue,
    super.key,
  });

  final List<double> values;
  final List<String> labels;
  final List<Color> colors;
  final List<String>? captions;
  final double height;
  final double? maxValue;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final top = maxValue ?? values.reduce(math.max);
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < values.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (captions != null)
                      Text(
                        captions![i],
                        style: VeyroText.body(
                          10.5,
                          weight: FontWeight.w700,
                          color: v.mute,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Container(
                      height: math.max(3, (height - 44) * values[i] / top),
                      decoration: BoxDecoration(
                        color: colors[i],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                          bottom: Radius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      labels[i],
                      style: VeyroText.body(
                        12,
                        weight: FontWeight.w700,
                        color: v.mute,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Striped box standing in for photos, maps and videos.
class VPlaceholder extends StatelessWidget {
  const VPlaceholder(
    this.label, {
    this.height = 110,
    this.width,
    this.radius = 18,
    super.key,
  });

  final String label;
  final double height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(
        painter: _StripePainter(v.bg, v.line),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
            ).copyWith(color: v.mute),
          ),
        ),
      ),
    );
  }
}

class _StripePainter extends CustomPainter {
  _StripePainter(this.a, this.b);

  final Color a;
  final Color b;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = a);
    final p = Paint()
      ..color = b
      ..strokeWidth = 1;
    for (var x = -size.height; x < size.width; x += 9) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), p);
    }
  }

  @override
  bool shouldRepaint(_StripePainter old) => old.a != a || old.b != b;
}
