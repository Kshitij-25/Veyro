import 'package:fitness_trakcer/core/layout/adaptive_scaffold.dart';
import 'package:fitness_trakcer/core/layout/navigation_destination_data.dart';
import 'package:fitness_trakcer/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// The signed-in app frame: bottom bar or navigation rail around the tabs.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    NavigationDestinationData(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    NavigationDestinationData(
      label: 'Workouts',
      icon: Icons.fitness_center_outlined,
      selectedIcon: Icons.fitness_center,
    ),
    NavigationDestinationData(
      label: 'Activity',
      icon: Icons.directions_walk_outlined,
      selectedIcon: Icons.directions_walk,
    ),
    NavigationDestinationData(
      label: 'Progress',
      icon: Icons.show_chart_outlined,
      selectedIcon: Icons.show_chart,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      destinations: _destinations,
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) {
        // The home summary aggregates every feature; refresh it on return.
        if (index == 0) context.read<DashboardCubit>().load();
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
      body: navigationShell,
    );
  }
}
