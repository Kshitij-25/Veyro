import 'package:fitness_trakcer/core/layout/navigation_destination_data.dart';
import 'package:fitness_trakcer/core/layout/window_size_class.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:flutter/material.dart';

/// Top-level navigation shell that adapts to the window size:
/// bottom [NavigationBar] on compact, [NavigationRail] on medium and an
/// extended rail on expanded windows.
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    super.key,
  });

  final List<NavigationDestinationData> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final sizeClass = WindowSizeClass.of(context);

    if (sizeClass.isCompact) {
      return Scaffold(
        body: body,
        bottomNavigationBar: _VeyroTabBar(
          destinations: destinations,
          selectedIndex: selectedIndex,
          onSelected: onDestinationSelected,
        ),
      );
    }

    final v = context.veyro;
    return Scaffold(
      body: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: v.bg,
              border: Border(right: BorderSide(color: v.line)),
            ),
            child: SafeArea(
              right: false,
              child: NavigationRail(
                extended: sizeClass.isExpanded,
                minExtendedWidth: 210,
                backgroundColor: Colors.transparent,
                indicatorColor: v.card,
                indicatorShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                selectedIconTheme: IconThemeData(color: v.acc),
                unselectedIconTheme: IconThemeData(color: v.mute),
                selectedLabelTextStyle: VeyroText.body(
                  13,
                  weight: FontWeight.w700,
                  color: v.acc,
                ),
                unselectedLabelTextStyle: VeyroText.body(
                  13,
                  weight: FontWeight.w600,
                  color: v.mute,
                ),
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,
                labelType: sizeClass.isExpanded
                    ? NavigationRailLabelType.none
                    : NavigationRailLabelType.all,
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: v.acc,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Icon(
                          Icons.expand_more_rounded,
                          color: VeyroColors.onAccent,
                          size: 26,
                        ),
                      ),
                      if (sizeClass.isExpanded) ...[
                        const SizedBox(width: 10),
                        Text(
                          'VEYRO',
                          style: VeyroText.display(32, color: v.ink),
                        ),
                      ],
                    ],
                  ),
                ),
                destinations: [
                  for (final d in destinations)
                    NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.selectedIcon),
                      label: Text(d.label),
                    ),
                ],
              ),
            ),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _VeyroTabBar extends StatelessWidget {
  const _VeyroTabBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<NavigationDestinationData> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: v.bg,
        border: Border(top: BorderSide(color: v.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              for (var i = 0; i < destinations.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onSelected(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          i == selectedIndex
                              ? destinations[i].selectedIcon
                              : destinations[i].icon,
                          size: 26,
                          color: i == selectedIndex ? v.acc : v.mute,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          destinations[i].label,
                          style: VeyroText.body(
                            11,
                            weight: FontWeight.w600,
                            color: i == selectedIndex ? v.acc : v.mute,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
