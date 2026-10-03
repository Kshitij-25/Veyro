import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:flutter/material.dart';

/// Shown while the app starts. The V sits exactly where the native launch
/// screen draws it, so the hand-over from the OS splash is seamless; the
/// wordmark then fades in below it.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  static const _background = Color(0xFF141210);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    return Scaffold(
      backgroundColor: _background,
      body: Stack(
        children: [
          const Center(child: SizedBox(width: 96, height: 88, child: _VMark())),
          Align(
            alignment: const Alignment(0, .22),
            child: FadeTransition(
              opacity: fade,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, .25),
                  end: Offset.zero,
                ).animate(fade),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'VEYRO',
                      style: VeyroText.display(
                        54,
                        color: const Color(0xFFF5F3F0),
                        height: 1,
                      ).copyWith(letterSpacing: 4),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'TRAIN · EAT · RECOVER',
                      style: VeyroText.body(
                        11.5,
                        color: const Color(0xFF9A948F),
                        letterSpacing: 2.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The Veyro "V", drawn from the same outline as the app icon.
class _VMark extends StatelessWidget {
  const _VMark();

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _VPainter());
}

class _VPainter extends CustomPainter {
  // The icon outline in its 1024 grid, cropped to the shape's bounds.
  static const _points = [
    Offset(200, 230),
    Offset(390, 230),
    Offset(512, 600),
    Offset(634, 230),
    Offset(824, 230),
    Offset(600, 800),
    Offset(424, 800),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    for (final (i, p) in _points.indexed) {
      final x = (p.dx - 200) / 624 * size.width;
      final y = (p.dy - 230) / 570 * size.height;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(
      path..close(),
      Paint()
        ..color = VeyroColors.accent
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(_VPainter oldDelegate) => false;
}
