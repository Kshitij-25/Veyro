import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Describes one top-level destination of the adaptive navigation shell.
///
/// [asset] is the outline icon; the selected state uses `<asset>_active.svg`
/// (same shape, bolder stroke, soft fill).
class NavigationDestinationData {
  const NavigationDestinationData({required this.label, required this.asset});

  final String label;
  final String asset;
}

/// A navigation SVG tinted with [color] (or the ambient icon colour), or
/// painted with [gradient] when given. Selecting an icon swaps to its
/// `_active` artwork and gives it a small springy pop.
class NavIcon extends StatelessWidget {
  const NavIcon(
    this.asset, {
    this.selected = false,
    this.color,
    this.gradient,
    this.size = 26,
    super.key,
  });

  final String asset;
  final bool selected;
  final Color? color;
  final Gradient? gradient;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tint =
        color ?? IconTheme.of(context).color ?? const Color(0xFF888888);
    final useGradient = selected && gradient != null;
    Widget icon = SvgPicture.asset(
      selected ? asset.replaceFirst('.svg', '_active.svg') : asset,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        useGradient ? const Color(0xFFFFFFFF) : tint,
        BlendMode.srcIn,
      ),
    );
    if (useGradient) {
      icon = ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (rect) => gradient!.createShader(rect),
        child: icon,
      );
    }
    return AnimatedScale(
      scale: selected ? 1.14 : 1,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutBack,
      child: icon,
    );
  }
}
