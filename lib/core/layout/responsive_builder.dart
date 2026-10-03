import 'package:fitness_trakcer/core/layout/window_size_class.dart';
import 'package:flutter/widgets.dart';

/// Builds a different subtree depending on the space this widget is given.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    required this.compact,
    this.medium,
    this.expanded,
    super.key,
  });

  final WidgetBuilder compact;

  /// Falls back to [compact] when omitted.
  final WidgetBuilder? medium;

  /// Falls back to [medium], then [compact], when omitted.
  final WidgetBuilder? expanded;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final builder = switch (WindowSizeClass.fromWidth(
          constraints.maxWidth,
        )) {
          WindowSizeClass.compact => compact,
          WindowSizeClass.medium => medium ?? compact,
          WindowSizeClass.expanded => expanded ?? medium ?? compact,
        };
        return builder(context);
      },
    );
  }
}
