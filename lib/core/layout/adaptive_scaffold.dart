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
      // The bar floats over the content; the body extends beneath it.
      return Scaffold(
        extendBody: true,
        body: body,
        bottomNavigationBar: _FloatingTabBar(
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
                      icon: NavIcon(d.asset, size: 24),
                      selectedIcon: NavIcon(d.asset, selected: true, size: 24),
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

/// Rounded bar that floats above the content with a soft shadow. The
/// selected tab sits in a tinted capsule that slides between items.
class _FloatingTabBar extends StatelessWidget {
  const _FloatingTabBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<NavigationDestinationData> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _height = 66.0;
  static const _inset = 6.0;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final count = destinations.length;
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 4),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: v.card,
                borderRadius: BorderRadius.circular(_height / 2),
                border: Border.all(color: v.line),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: dark ? .5 : .14),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: SizedBox(
                height: _height,
                child: LayoutBuilder(
                  builder: (context, box) {
                    final slot = box.maxWidth / count;
                    return Stack(
                      children: [
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOutCubic,
                          left: slot * selectedIndex + _inset,
                          top: _inset,
                          width: slot - _inset * 2,
                          height: _height - _inset * 2,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: v.acc.withValues(alpha: dark ? .18 : .12),
                              borderRadius: BorderRadius.circular(
                                (_height - _inset * 2) / 2,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            for (var i = 0; i < count; i++)
                              Expanded(
                                child: Semantics(
                                  button: true,
                                  selected: i == selectedIndex,
                                  label: destinations[i].label,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => onSelected(i),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        NavIcon(
                                          destinations[i].asset,
                                          selected: i == selectedIndex,
                                          size: 25,
                                          color: v.mute,
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              const Color(0xFFFFB347),
                                              v.acc,
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          destinations[i].label,
                                          style: VeyroText.body(
                                            10.5,
                                            weight: FontWeight.w700,
                                            color: i == selectedIndex
                                                ? v.acc
                                                : v.mute,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
