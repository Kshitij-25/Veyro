import 'package:fitness_trakcer/core/di/injection.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/router/app_shell.dart';
import 'package:fitness_trakcer/core/router/go_router_refresh_stream.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/activity/presentation/cubit/activity_cubit.dart';
import 'package:fitness_trakcer/features/activity/presentation/pages/activity_page.dart';
import 'package:fitness_trakcer/features/body_metrics/presentation/cubit/body_metrics_cubit.dart';
import 'package:fitness_trakcer/features/body_metrics/presentation/pages/body_metrics_page.dart';
import 'package:fitness_trakcer/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:fitness_trakcer/features/goals/presentation/cubit/achievements_cubit.dart';
import 'package:fitness_trakcer/features/goals/presentation/cubit/goals_cubit.dart';
import 'package:fitness_trakcer/features/goals/presentation/pages/achievements_page.dart';
import 'package:fitness_trakcer/features/goals/presentation/pages/goals_page.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity.dart';
import 'package:fitness_trakcer/features/gps_tracking/presentation/cubit/tracked_activities_cubit.dart';
import 'package:fitness_trakcer/features/gps_tracking/presentation/pages/tracked_activities_page.dart';
import 'package:fitness_trakcer/features/gps_tracking/presentation/pages/tracking_page.dart';
import 'package:fitness_trakcer/features/gps_tracking/presentation/pages/tracking_summary_page.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/onboarding_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/pages/onboarding_page.dart';
import 'package:fitness_trakcer/features/profile/presentation/pages/settings_page.dart';
import 'package:fitness_trakcer/features/profile/presentation/pages/splash_page.dart';
import 'package:fitness_trakcer/features/reminders/presentation/cubit/reminders_cubit.dart';
import 'package:fitness_trakcer/features/reminders/presentation/pages/reminders_page.dart';
import 'package:fitness_trakcer/features/routines/presentation/cubit/routine_editor_cubit.dart';
import 'package:fitness_trakcer/features/routines/presentation/cubit/routines_cubit.dart';
import 'package:fitness_trakcer/features/routines/presentation/pages/routine_editor_page.dart';
import 'package:fitness_trakcer/features/routines/presentation/pages/routines_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/body_composition_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/calendar_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/community_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/devices_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/discover_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/exercise_detail_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/fasting_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/food_search_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/fuel_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/habits_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/mind_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/nutrition_targets_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/photos_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/preferences_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/pro_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/recipes_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/recovery_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/report_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/scan_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/sleep_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/timers_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/tools_page.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/exercise_library_cubit.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/personal_records_cubit.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/workout_detail_cubit.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/workout_history_cubit.dart';
import 'package:fitness_trakcer/features/workout/presentation/pages/active_workout_page.dart';
import 'package:fitness_trakcer/features/workout/presentation/pages/exercise_library_page.dart';
import 'package:fitness_trakcer/features/workout/presentation/pages/personal_records_page.dart';
import 'package:fitness_trakcer/features/workout/presentation/pages/workout_detail_page.dart';
import 'package:fitness_trakcer/features/workout/presentation/pages/workouts_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

/// Builds the app's [GoRouter]. Until the profile has loaded the splash page
/// is shown; without a profile the user is sent through onboarding.
@lazySingleton
class AppRouter {
  AppRouter(this._profileCubit);

  final ProfileCubit _profileCubit;

  late final GoRouter config = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(_profileCubit.stream),
    redirect: _redirect,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<OnboardingCubit>(),
          child: const OnboardingPage(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          _homeBranch(),
          _workoutsBranch(),
          _fuelBranch(),
          _progressBranch(),
          _communityBranch(),
        ],
      ),
    ],
  );

  String? _redirect(BuildContext context, GoRouterState state) {
    final profileState = _profileCubit.state;
    final location = state.matchedLocation;

    if (profileState.status == ViewStatus.initial ||
        profileState.status == ViewStatus.loading) {
      return location == AppRoutes.splash ? null : AppRoutes.splash;
    }
    if (!profileState.hasProfile) {
      return location == AppRoutes.onboarding ? null : AppRoutes.onboarding;
    }
    if (location == AppRoutes.splash || location == AppRoutes.onboarding) {
      return AppRoutes.home;
    }
    return null;
  }

  StatefulShellBranch _homeBranch() => StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const DashboardPage(),
        routes: [
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsPage(),
            routes: [
              GoRoute(
                path: 'reminders',
                builder: (context, state) => BlocProvider(
                  create: (_) => getIt<RemindersCubit>()..start(),
                  child: const RemindersPage(),
                ),
              ),
              GoRoute(
                path: 'preferences',
                builder: (context, state) => const PreferencesPage(),
              ),
              GoRoute(
                path: 'devices',
                builder: (context, state) => const DevicesPage(),
              ),
              GoRoute(
                path: 'pro',
                builder: (context, state) => const ProPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  StatefulShellBranch _workoutsBranch() => StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.workouts,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<WorkoutHistoryCubit>()..start(),
          child: const WorkoutsPage(),
        ),
        routes: [
          GoRoute(
            path: 'active',
            builder: (context, state) => const ActiveWorkoutPage(),
          ),
          GoRoute(
            path: 'library',
            builder: (context, state) => BlocProvider(
              create: (_) => getIt<ExerciseLibraryCubit>()..start(),
              child: ExerciseLibraryPage(
                selectionMode: state.uri.queryParameters['pick'] == '1',
              ),
            ),
          ),
          GoRoute(
            path: 'detail/:id',
            builder: (context, state) => BlocProvider(
              create: (_) =>
                  getIt<WorkoutDetailCubit>()
                    ..load(state.pathParameters['id']!),
              child: const WorkoutDetailPage(),
            ),
          ),
          GoRoute(
            path: 'records',
            builder: (context, state) => BlocProvider(
              create: (_) => getIt<PersonalRecordsCubit>()..load(),
              child: const PersonalRecordsPage(),
            ),
          ),
          GoRoute(
            path: 'exercise',
            builder: (context, state) {
              final exercise = state.extra;
              return exercise is Exercise
                  ? ExerciseDetailPage(exercise: exercise)
                  : const SizedBox.shrink();
            },
          ),
          GoRoute(
            path: 'discover',
            builder: (context, state) => const DiscoverPage(),
          ),
          GoRoute(
            path: 'calendar',
            builder: (context, state) => const CalendarPage(),
          ),
          GoRoute(
            path: 'timers',
            builder: (context, state) => const TimersPage(),
          ),
          GoRoute(
            path: 'tools',
            builder: (context, state) => ToolsPage(
              initialTab: state.uri.queryParameters['tab'] ?? '1RM',
            ),
          ),
          GoRoute(path: 'mind', builder: (context, state) => const MindPage()),
          GoRoute(
            path: 'activity',
            builder: (context, state) => BlocProvider(
              create: (_) => getIt<ActivityCubit>()..start(),
              child: const ActivityPage(),
            ),
            routes: [
              GoRoute(
                path: 'tracking',
                builder: (context, state) => const TrackingPage(),
              ),
              GoRoute(
                path: 'summary',
                builder: (context, state) {
                  final activity = state.extra;
                  return activity is TrackedActivity
                      ? TrackingSummaryPage(activity: activity)
                      : const SizedBox.shrink();
                },
              ),
              GoRoute(
                path: 'history',
                builder: (context, state) => BlocProvider(
                  create: (_) => getIt<TrackedActivitiesCubit>()..start(),
                  child: const TrackedActivitiesPage(),
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'routines',
            builder: (context, state) => BlocProvider(
              create: (_) => getIt<RoutinesCubit>()..start(),
              child: const RoutinesPage(),
            ),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => BlocProvider(
                  create: (_) =>
                      getIt<RoutineEditorCubit>()
                        ..load(state.uri.queryParameters['id']),
                  child: const RoutineEditorPage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  StatefulShellBranch _progressBranch() => StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.progress,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<BodyMetricsCubit>()..start()),
            BlocProvider(create: (_) => getIt<PersonalRecordsCubit>()..load()),
          ],
          child: const BodyMetricsPage(),
        ),
        routes: [
          GoRoute(
            path: 'goals',
            builder: (context, state) => BlocProvider(
              create: (_) => getIt<GoalsCubit>()..start(),
              child: const GoalsPage(),
            ),
          ),
          GoRoute(
            path: 'achievements',
            builder: (context, state) => BlocProvider(
              create: (_) => getIt<AchievementsCubit>()..load(),
              child: const AchievementsPage(),
            ),
          ),
          GoRoute(
            path: 'body',
            builder: (context, state) => const BodyCompositionPage(),
          ),
          GoRoute(
            path: 'sleep',
            builder: (context, state) => const SleepPage(),
          ),
          GoRoute(
            path: 'recovery',
            builder: (context, state) => const RecoveryPage(),
          ),
          GoRoute(
            path: 'photos',
            builder: (context, state) => const PhotosPage(),
          ),
          GoRoute(
            path: 'report',
            builder: (context, state) => const ReportPage(),
          ),
          GoRoute(
            path: 'habits',
            builder: (context, state) => const HabitsPage(),
          ),
        ],
      ),
    ],
  );

  StatefulShellBranch _fuelBranch() => StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.fuel,
        builder: (context, state) => const FuelPage(),
        routes: [
          GoRoute(
            path: 'log',
            builder: (context, state) => FoodSearchPage(
              initialMeal: state.uri.queryParameters['meal'] ?? 'Snacks',
            ),
          ),
          GoRoute(path: 'scan', builder: (context, state) => const ScanPage()),
          GoRoute(
            path: 'recipes',
            builder: (context, state) => const RecipesPage(),
          ),
          GoRoute(
            path: 'fasting',
            builder: (context, state) => const FastingPage(),
          ),
          GoRoute(
            path: 'targets',
            builder: (context, state) => const NutritionTargetsPage(),
          ),
        ],
      ),
    ],
  );

  StatefulShellBranch _communityBranch() => StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.community,
        builder: (context, state) => const CommunityPage(),
      ),
    ],
  );
}
