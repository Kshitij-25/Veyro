import 'package:fitness_trakcer/core/layout/window_size_class.dart';
import 'package:flutter/material.dart';

/// List/detail layout: both panes side by side when there is room, otherwise
/// only [primary] is shown (the detail is expected to be pushed as a route).
class AdaptiveTwoPane extends StatelessWidget {
  const AdaptiveTwoPane({
    required this.primary,
    required this.secondary,
    this.primaryWidth = 380,
    super.key,
  });

  final Widget primary;
  final Widget secondary;
  final double primaryWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!WindowSizeClass.fromWidth(constraints.maxWidth).isExpanded) {
          return primary;
        }
        return Row(
          children: [
            SizedBox(width: primaryWidth, child: primary),
            const VerticalDivider(width: 1),
            Expanded(child: secondary),
          ],
        );
      },
    );
  }
}
