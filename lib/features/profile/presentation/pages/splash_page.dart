import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = VeyroColors.onAccent;
    return Scaffold(
      backgroundColor: VeyroColors.accent,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.expand_more_rounded, size: 120, color: ink),
            const SizedBox(height: 4),
            Text(
              'VEYRO',
              style: VeyroText.display(84, color: ink, height: .85),
            ),
            const SizedBox(height: 26),
            const SizedBox.square(
              dimension: 30,
              child: CircularProgressIndicator(strokeWidth: 3, color: ink),
            ),
          ],
        ),
      ),
    );
  }
}
