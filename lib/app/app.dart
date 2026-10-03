import 'dart:ui';

import 'package:fitness_trakcer/core/di/injection.dart';
import 'package:fitness_trakcer/core/router/app_router.dart';
import 'package:fitness_trakcer/core/theme/app_theme.dart';
import 'package:fitness_trakcer/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fitness_trakcer/features/gps_tracking/presentation/cubit/tracking_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/active_workout_cubit.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/rest_timer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      ],
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
    );
  }
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
