import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/food_catalog/domain/entities/catalog_food.dart';
import 'package:fitness_trakcer/features/food_catalog/presentation/cubit/food_catalog_cubit.dart';
import 'package:fitness_trakcer/features/wellness/presentation/catalog_food_mapper.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/food_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

const _panel = Color(0xFF242220);
const _fg = Color(0xFFF5F3F0);
const _muted = Color(0xFF9A948F);

enum _Stage { scanning, looking, found, notFound, failed }

/// Scans a packaged-food barcode and looks it up in Open Food Facts.
class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final _controller = MobileScannerController(
    formats: const [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
    ],
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  final _manual = TextEditingController();

  _Stage _stage = _Stage.scanning;
  CatalogFood? _food;
  String _code = '';

  @override
  void dispose() {
    _controller.dispose();
    _manual.dispose();
    super.dispose();
  }

  Future<void> _lookup(String raw) async {
    final code = raw.replaceAll(RegExp(r'\D'), '');
    if (code.length < 8 || _stage == _Stage.looking) return;
    setState(() {
      _stage = _Stage.looking;
      _code = code;
    });
    // UPC-A codes are EAN-13 with a leading zero in the database.
    final result = await context.read<FoodCatalogCubit>().lookupBarcode(code);
    if (!mounted) return;
    result.when(
      success: (food) => setState(() {
        _food = food;
        _stage = food == null ? _Stage.notFound : _Stage.found;
      }),
      failure: (_) => setState(() => _stage = _Stage.failed),
    );
  }

  void _again() {
    setState(() {
      _stage = _Stage.scanning;
      _food = null;
      _manual.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FoodCatalogCubit>();
    final scanning = _stage == _Stage.scanning;
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: ContentConstraint(
          maxWidth: 560,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              0,
              16,
              16 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 52,
                    width: 52,
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
                        Container(color: _panel),
                        MobileScanner(
                          controller: _controller,
                          onDetect: (capture) {
                            final code = capture.barcodes
                                .map((b) => b.rawValue)
                                .whereType<String>()
                                .firstOrNull;
                            if (code != null && scanning) _lookup(code);
                          },
                          errorBuilder: (context, error) => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                error.errorCode ==
                                        MobileScannerErrorCode.permissionDenied
                                    ? 'Camera access is off. Allow it in Settings, or type the barcode below.'
                                    : 'The camera isn\'t available here. Type the barcode below instead.',
                                textAlign: TextAlign.center,
                                style: VeyroText.body(14, color: _muted),
                              ),
                            ),
                          ),
                        ),
                        IgnorePointer(
                          child: LayoutBuilder(
                            builder: (context, c) => Stack(
                              children: [
                                Positioned(
                                  left: c.maxWidth * .12,
                                  right: c.maxWidth * .12,
                                  top: c.maxHeight * .3,
                                  bottom: c.maxHeight * .3,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: VeyroColors.accent,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_stage == _Stage.looking)
                          const ColoredBox(
                            color: Color(0x99000000),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (scanning || _stage == _Stage.looking)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _manual,
                          keyboardType: TextInputType.number,
                          style: VeyroText.body(15, color: _fg),
                          decoration: InputDecoration(
                            hintText: 'Or type the barcode number',
                            hintStyle: VeyroText.body(14, color: _muted),
                            fillColor: _panel,
                          ),
                          onSubmitted: _lookup,
                        ),
                      ),
                      const SizedBox(width: 8),
                      VButton(
                        'Look up',
                        height: 48,
                        onPressed: () => _lookup(_manual.text),
                      ),
                    ],
                  )
                else if (_stage == _Stage.found && _food != null) ...[
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
                          _food!.name,
                          style: VeyroText.body(
                            18,
                            weight: FontWeight.w700,
                            color: _fg,
                          ),
                        ),
                        Text(
                          '${_food!.extraBrand == null ? '' : '${_food!.extraBrand} · '}${_food!.servingLabel} · ${_food!.kcal.round()} kcal',
                          style: VeyroText.body(13, color: _muted),
                        ),
                        Text(
                          'P ${_food!.protein.round()}  C ${_food!.carbs.round()}  F ${_food!.fat.round()}',
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
                    onPressed: () => showFoodSheet(
                      context,
                      _food!.toFoodItem(),
                      'Snacks',
                      onLogged: () => cubit.markUsed(_food!),
                    ),
                  ),
                  TextButton(
                    onPressed: _again,
                    child: Text(
                      'Scan another',
                      style: VeyroText.body(
                        14,
                        weight: FontWeight.w600,
                        color: _fg,
                      ),
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _panel,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _stage == _Stage.notFound
                          ? 'Barcode $_code isn\'t in Open Food Facts yet. You can create the food by hand.'
                          : 'Couldn\'t look that up. Check your connection and try again.',
                      style: VeyroText.body(14, color: _fg, height: 1.4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_stage == _Stage.notFound)
                    VButton(
                      'Create this food',
                      height: 54,
                      radius: 16,
                      expand: true,
                      onPressed: () => showCreateFoodSheet(context, cubit),
                    ),
                  TextButton(
                    onPressed: _again,
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
