import 'dart:ui';

import 'package:fitness_trakcer/core/di/injection.dart';
import 'package:fitness_trakcer/core/router/app_router.dart';
import 'package:fitness_trakcer/core/theme/app_theme.dart';
import 'package:fitness_trakcer/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracking_status.dart';
import 'package:fitness_trakcer/features/gps_tracking/presentation/cubit/tracking_cubit.dart';
import 'package:fitness_trakcer/features/health_sync/presentation/cubit/health_sync_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/profile_state.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/active_workout_cubit.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/rest_timer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Cubits whose state must outlive any single screen.
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<ProfileCubit>()),
        BlocProvider.value(value: getIt<ActiveWorkoutCubit>()),
        BlocProvider.value(value: getIt<RestTimerCubit>()),
        BlocProvider.value(value: getIt<TrackingCubit>()),
        BlocProvider.value(value: getIt<DashboardCubit>()..load()),
        BlocProvider.value(value: getIt<HealthSyncCubit>()),
      ],
      child: _HealthAutoSync(
        child: BlocListener<ProfileCubit, ProfileState>(
          listenWhen: (a, b) => a.profile != b.profile,
          listener: (context, state) =>
              WellnessStore.instance.useProfile(state.profile),
          child: ListenableBuilder(
            listenable: WellnessStore.instance,
            builder: (context, _) => MaterialApp.router(
              title: 'Veyro',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: WellnessStore.instance.themeMode,
              routerConfig: getIt<AppRouter>().config,
              scrollBehavior: const _AppScrollBehavior(),
            ),
          ),
        ),
      ),
    );
  }
}

/// Syncs Health data at launch and whenever the app comes back to the
/// foreground, then refreshes Home with what arrived.
class _HealthAutoSync extends StatefulWidget {
  const _HealthAutoSync({required this.child});

  final Widget child;

  @override
  State<_HealthAutoSync> createState() => _HealthAutoSyncState();
}

class _HealthAutoSyncState extends State<_HealthAutoSync>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WellnessStore.instance.addListener(_syncAwake);
    context.read<HealthSyncCubit>().start();
    // The profile may already be loaded: the listener below only sees changes.
    WellnessStore.instance.useProfile(
      context.read<ProfileCubit>().state.profile,
    );
  }

  /// Keeps the screen on during a workout or recording when the setting is on.
  void _syncAwake() {
    if (!mounted) return;
    final active = context.read<ActiveWorkoutCubit>().state.workout != null;
    final tracking =
        context.read<TrackingCubit>().state.status != TrackingStatus.idle;
    final enable = WellnessStore.instance.keepAwake && (active || tracking);
    // Not every platform supports wake locks; a failure is harmless.
    WakelockPlus.toggle(enable: enable).catchError((Object _) {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WellnessStore.instance.removeListener(_syncAwake);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<HealthSyncCubit>().syncIfStale();
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<HealthSyncCubit, HealthSyncState>(
        listenWhen: (a, b) => a.lastSync != b.lastSync,
        listener: (context, _) => context.read<DashboardCubit>().load(),
        child: widget.child,
      );
}

/// Lets lists be dragged with a mouse or trackpad on web and desktop.
class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    ...super.dragDevices,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}
