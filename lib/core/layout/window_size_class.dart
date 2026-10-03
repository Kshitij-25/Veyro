import 'package:flutter/widgets.dart';

/// Material 3 window size classes used to adapt layouts.
enum WindowSizeClass {
  /// Phones in portrait (< 600dp).
  compact,

  /// Large phones, small tablets, foldables (600–839dp).
  medium,

  /// Tablets, desktop and web (>= 840dp).
  expanded;

  static const double mediumBreakpoint = 600;
  static const double expandedBreakpoint = 840;

  static WindowSizeClass fromWidth(double width) {
    if (width < mediumBreakpoint) return WindowSizeClass.compact;
    if (width < expandedBreakpoint) return WindowSizeClass.medium;
    return WindowSizeClass.expanded;
  }

  /// Class of the full window; prefer [LayoutBuilder] when a widget should
  /// react to the space it is given rather than the window.
  static WindowSizeClass of(BuildContext context) =>
      fromWidth(MediaQuery.sizeOf(context).width);

  bool get isCompact => this == WindowSizeClass.compact;
  bool get isMedium => this == WindowSizeClass.medium;
  bool get isExpanded => this == WindowSizeClass.expanded;

  /// A sensible column count for card grids at this size.
  int get gridColumns => switch (this) {
    WindowSizeClass.compact => 1,
    WindowSizeClass.medium => 2,
    WindowSizeClass.expanded => 3,
  };
}
