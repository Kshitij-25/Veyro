import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/route_point.dart';
import 'package:flutter/material.dart';

/// Draws the recorded route scaled to fit; stands in for a real map.
class RoutePainter extends CustomPainter {
  const RoutePainter(this.route, {this.markers = false});

  final bool markers;

  final List<RoutePoint> route;

  @override
  void paint(Canvas canvas, Size size) {
    if (route.length < 2) return;
    final lats = route.map((p) => p.latitude);
    final lons = route.map((p) => p.longitude);
    final minLat = lats.reduce((a, b) => a < b ? a : b);
    final maxLat = lats.reduce((a, b) => a > b ? a : b);
    final minLon = lons.reduce((a, b) => a < b ? a : b);
    final maxLon = lons.reduce((a, b) => a > b ? a : b);
    final spanLat = (maxLat - minLat).clamp(1e-6, double.infinity);
    final spanLon = (maxLon - minLon).clamp(1e-6, double.infinity);
    const pad = 28.0;
    final scale = [
      (size.width - pad * 2) / spanLon,
      (size.height - pad * 2) / spanLat,
    ].reduce((a, b) => a < b ? a : b);
    final dx = (size.width - spanLon * scale) / 2;
    final dy = (size.height - spanLat * scale) / 2;
    final path = Path();
    for (final (i, p) in route.indexed) {
      final x = dx + (p.longitude - minLon) * scale;
      final y = size.height - dy - (p.latitude - minLat) * scale;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = VeyroColors.accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(RoutePainter old) => old.route != route;
}
