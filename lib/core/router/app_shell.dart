import 'dart:async';

import 'package:fitness_trakcer/core/layout/adaptive_scaffold.dart';
import 'package:fitness_trakcer/core/layout/navigation_destination_data.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracking_status.dart';
import 'package:fitness_trakcer/features/gps_tracking/presentation/cubit/tracking_cubit.dart';
import 'package:fitness_trakcer/features/health_sync/presentation/cubit/health_sync_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/active_workout_cubit.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/active_workout_state.dart';
import 'package:fitness_trakcer/features/workout/presentation/widgets/rest_timer_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// The signed-in app frame: bottom bar or navigation rail around the tabs,
/// with floating bars for a running workout, recording and rest timer.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    NavigationDestinationData(
      label: 'Home',
      asset: 'assets/icons/nav_home.svg',
    ),
    NavigationDestinationData(
      label: 'Train',
      asset: 'assets/icons/nav_train.svg',
    ),
    NavigationDestinationData(
      label: 'Food',
      asset: 'assets/icons/nav_food.svg',
    ),
    NavigationDestinationData(
      label: 'Progress',
      asset: 'assets/icons/nav_progress.svg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      destinations: _destinations,
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) {
        // The home summary aggregates every feature; refresh it on return.
        WellnessStore.instance.reloadIfNewDay();
        if (index != 1) context.read<DashboardCubit>().load();
        if (index == 0 || index == 3) {
          unawaited(
            context.read<HealthSyncCubit>().syncIfStale(
              maxAge: const Duration(minutes: 2),
            ),
          );
        }
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
      body: Stack(
        children: [
          Positioned.fill(child: navigationShell),
          const Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: _FloatingBars(),
          ),
        ],
      ),
    );
  }
}

class _FloatingBars extends StatelessWidget {
  const _FloatingBars();

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    return ListenableBuilder(
      listenable: router.routeInformationProvider,
      builder: (context, _) {
        final path = router.routeInformationProvider.value.uri.path;
        final onActive = path == AppRoutes.activeWorkout;
        final onTracking = path == AppRoutes.tracking;
        // With an overlaying (glass) nav bar the body's bottom padding is the
        // bar's height; lift the floating bars above it.
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(context).bottom,
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!onActive) const RestTimerBar(),
                  if (!onActive) const _WorkoutBar(),
                  if (!onTracking) const _RecordingBar(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BarShell extends StatelessWidget {
  const _BarShell({
    required this.color,
    required this.foreground,
    required this.dot,
    required this.title,
    required this.trailing,
    required this.onTap,
    this.border,
  }) : blink = false;

  final Color color;
  final Color foreground;
  final Color dot;
  final String title;
  final Widget trailing;
  final VoidCallback onTap;
  final Border? border;
  final bool blink;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: border,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: VeyroText.body(
                      14,
                      weight: FontWeight.w700,
                      color: foreground,
                    ),
                  ),
                ),
                trailing,
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: foreground),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkoutBar extends StatelessWidget {
  const _WorkoutBar();

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return BlocBuilder<ActiveWorkoutCubit, ActiveWorkoutState>(
      builder: (context, state) {
        final workout = state.workout;
        if (workout == null) return const SizedBox.shrink();
        return _BarShell(
          color: v.ink,
          foreground: v.bg,
          dot: v.acc,
          title: workout.name,
          onTap: () => context.push(AppRoutes.activeWorkout),
          trailing: StreamBuilder<int>(
            stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
            builder: (context, _) => Text(
              DateTime.now().difference(workout.startedAt).clock,
              style: VeyroText.display(24, color: v.bg),
            ),
          ),
        );
      },
    );
  }
}

class _RecordingBar extends StatelessWidget {
  const _RecordingBar();

  @override
  Widget build(BuildContext context) {
    final units = context.unitSystem;
    return BlocBuilder<TrackingCubit, TrackingState>(
      builder: (context, state) {
        if (state.status == TrackingStatus.idle) return const SizedBox.shrink();
        final snap = state.snapshot;
        final km = (snap?.distanceMeters ?? 0) / 1000;
        return _BarShell(
          color: const Color(0xFF101010),
          foreground: const Color(0xFFF5F3F0),
          dot: state.status == TrackingStatus.tracking
              ? VeyroColors.success
              : const Color(0xFFE5A100),
          border: Border.all(color: const Color(0x1FFFFFFF)),
          title:
              '${state.type.label} · ${units.fd(km, 2)} ${units.distanceUnit}',
          onTap: () => context.push(AppRoutes.tracking),
          trailing: Text(
            (snap?.elapsed ?? Duration.zero).clock,
            style: VeyroText.display(24, color: const Color(0xFFF5F3F0)),
          ),
        );
      },
    );
  }
}
