import 'package:flutter/widgets.dart';

/// Describes one top-level destination of the adaptive navigation shell.
class NavigationDestinationData {
  const NavigationDestinationData({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
