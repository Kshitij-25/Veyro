import 'dart:async';

import 'package:fitness_trakcer/core/di/injection.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:fitness_trakcer/features/reminders/domain/usecases/reschedule_all_reminders.dart';
import 'package:fitness_trakcer/features/workout/data/datasources/exercise_local_data_source.dart';
import 'package:fitness_trakcer/features/workout/domain/usecases/sync_remote_exercises.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/active_workout_cubit.dart';
import 'package:flutter/widgets.dart';

/// One-time start-up work that must finish before the first frame.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  await getIt<ExerciseLocalDataSource>().seedIfEmpty();

  getIt<ProfileCubit>().start();
  getIt<ActiveWorkoutCubit>().start();

  // Notification schedules can be lost (reinstall, reboot, timezone change);
  // rebuild them from storage. A failure here must not block launch.
  await getIt<RescheduleAllReminders>()(const NoParams());

  // Refresh the remote exercise catalogue in the background when it is stale.
  // It must never delay or break launch, e.g. when offline.
  unawaited(getIt<SyncRemoteExercises>()(const SyncRemoteExercisesParams()));
}
