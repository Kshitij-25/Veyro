import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_charts.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/food_search_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';

const _panel = Color(0xFF242220);
const _fg = Color(0xFFF5F3F0);
const _muted = Color(0xFF9A948F);

/// Barcode scan flow. The camera and product lookup are simulated.
class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _line = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);
  bool _scanned = false;

  @override
  void dispose() {
    _line.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = WellnessStore.foods[3];
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: ContentConstraint(
          maxWidth: 560,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 52,
                    child: Center(
                      child: IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: _panel,
                          foregroundColor: _fg,
                        ),
                        onPressed: () =>
                            veyroBack(context, fallback: AppRoutes.fuel),
                        icon: const Icon(Icons.chevron_left),
                      ),
                    ),
                  ),
                ),
                Text(
                  'SCAN BARCODE',
                  style: VeyroText.display(46, color: _fg, height: .92),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const VPlaceholder(
                          'camera preview',
                          height: double.infinity,
                          radius: 0,
                        ),
                        LayoutBuilder(
                          builder: (context, c) => Stack(
                            children: [
                              Positioned(
                                left: c.maxWidth * .12,
                                right: c.maxWidth * .12,
                                top: c.maxHeight * .3,
                                bottom: c.maxHeight * .3,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: VeyroColors.accent,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                              ),
                              if (!_scanned)
                                AnimatedBuilder(
                                  animation: _line,
                                  builder: (context, _) => Positioned(
                                    left: c.maxWidth * .14,
                                    right: c.maxWidth * .14,
                                    top:
                                        c.maxHeight * (.32 + .36 * _line.value),
                                    child: Container(
                                      height: 2,
                                      color: VeyroColors.accent,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (!_scanned)
                  VButton(
                    'Simulate scan',
                    height: 54,
                    radius: 16,
                    expand: true,
                    onPressed: () => setState(() => _scanned = true),
                  )
                else ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _panel,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PRODUCT FOUND',
                          style: VeyroText.label(color: _muted),
                        ),
                        Text(
                          product.name,
                          style: VeyroText.body(
                            18,
                            weight: FontWeight.w700,
                            color: _fg,
                          ),
                        ),
                        Text(
                          '${product.serving} · ${product.kcal} kcal',
                          style: VeyroText.body(13, color: _muted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  VButton(
                    'Add to diary',
                    height: 54,
                    radius: 16,
                    expand: true,
                    onPressed: () => showFoodSheet(context, product, 'Snacks'),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _scanned = false),
                    child: Text(
                      'Scan another',
                      style: VeyroText.body(
                        14,
                        weight: FontWeight.w600,
                        color: _fg,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
