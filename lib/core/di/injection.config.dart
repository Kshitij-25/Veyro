// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:fitness_trakcer/core/database/app_database.dart' as _i160;
import 'package:fitness_trakcer/core/di/modules/database_module.dart' as _i365;
import 'package:fitness_trakcer/core/di/modules/network_module.dart' as _i162;
import 'package:fitness_trakcer/core/di/modules/platform_module.dart' as _i196;
import 'package:fitness_trakcer/core/router/app_router.dart' as _i951;
import 'package:fitness_trakcer/core/router/startup_gate.dart' as _i20;
import 'package:fitness_trakcer/core/utils/clock.dart' as _i369;
import 'package:fitness_trakcer/core/utils/id_generator.dart' as _i586;
import 'package:fitness_trakcer/features/activity/data/datasources/activity_local_data_source.dart'
    as _i1020;
import 'package:fitness_trakcer/features/activity/data/datasources/health_data_source.dart'
    as _i984;
import 'package:fitness_trakcer/features/activity/data/repositories/activity_repository_impl.dart'
    as _i591;
import 'package:fitness_trakcer/features/activity/domain/repositories/activity_repository.dart'
    as _i507;
import 'package:fitness_trakcer/features/activity/domain/usecases/get_activity_range.dart'
    as _i205;
import 'package:fitness_trakcer/features/activity/domain/usecases/get_health_access_status.dart'
    as _i493;
import 'package:fitness_trakcer/features/activity/domain/usecases/log_manual_activity.dart'
    as _i876;
import 'package:fitness_trakcer/features/activity/domain/usecases/request_health_access.dart'
    as _i233;
import 'package:fitness_trakcer/features/activity/domain/usecases/sync_activity_from_health.dart'
    as _i188;
import 'package:fitness_trakcer/features/activity/domain/usecases/watch_daily_activity.dart'
    as _i340;
import 'package:fitness_trakcer/features/activity/presentation/cubit/activity_cubit.dart'
    as _i504;
import 'package:fitness_trakcer/features/body_metrics/data/datasources/body_metrics_local_data_source.dart'
    as _i302;
import 'package:fitness_trakcer/features/body_metrics/data/repositories/body_metrics_repository_impl.dart'
    as _i371;
import 'package:fitness_trakcer/features/body_metrics/domain/repositories/body_metrics_repository.dart'
    as _i328;
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/delete_body_measurement.dart'
    as _i687;
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/get_body_progress.dart'
    as _i936;
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/get_latest_weight.dart'
    as _i310;
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/log_body_measurement.dart'
    as _i1056;
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/update_body_measurement.dart'
    as _i807;
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/watch_body_measurements.dart'
    as _i285;
import 'package:fitness_trakcer/features/body_metrics/presentation/cubit/body_metrics_cubit.dart'
    as _i849;
import 'package:fitness_trakcer/features/dashboard/domain/usecases/get_dashboard_summary.dart'
    as _i711;
import 'package:fitness_trakcer/features/dashboard/presentation/cubit/dashboard_cubit.dart'
    as _i656;
import 'package:fitness_trakcer/features/data_management/data/repositories/data_management_repository_impl.dart'
    as _i347;
import 'package:fitness_trakcer/features/data_management/domain/repositories/data_management_repository.dart'
    as _i284;
import 'package:fitness_trakcer/features/data_management/domain/usecases/data_management_use_cases.dart'
    as _i778;
import 'package:fitness_trakcer/features/food_catalog/data/datasources/open_food_facts_data_source.dart'
    as _i454;
import 'package:fitness_trakcer/features/food_catalog/data/datasources/saved_food_local_data_source.dart'
    as _i958;
import 'package:fitness_trakcer/features/food_catalog/data/datasources/usda_data_source.dart'
    as _i228;
import 'package:fitness_trakcer/features/food_catalog/data/repositories/food_catalog_repository_impl.dart'
    as _i923;
import 'package:fitness_trakcer/features/food_catalog/domain/repositories/food_catalog_repository.dart'
    as _i659;
import 'package:fitness_trakcer/features/food_catalog/presentation/cubit/food_catalog_cubit.dart'
    as _i107;
import 'package:fitness_trakcer/features/goals/data/datasources/achievement_local_data_source.dart'
    as _i98;
import 'package:fitness_trakcer/features/goals/data/datasources/goal_local_data_source.dart'
    as _i978;
import 'package:fitness_trakcer/features/goals/data/repositories/achievement_repository_impl.dart'
    as _i527;
import 'package:fitness_trakcer/features/goals/data/repositories/goal_repository_impl.dart'
    as _i774;
import 'package:fitness_trakcer/features/goals/domain/repositories/achievement_repository.dart'
    as _i550;
import 'package:fitness_trakcer/features/goals/domain/repositories/goal_repository.dart'
    as _i492;
import 'package:fitness_trakcer/features/goals/domain/services/goal_progress_calculator.dart'
    as _i668;
import 'package:fitness_trakcer/features/goals/domain/usecases/create_goal.dart'
    as _i968;
import 'package:fitness_trakcer/features/goals/domain/usecases/delete_goal.dart'
    as _i391;
import 'package:fitness_trakcer/features/goals/domain/usecases/evaluate_achievements.dart'
    as _i155;
import 'package:fitness_trakcer/features/goals/domain/usecases/get_achievements.dart'
    as _i950;
import 'package:fitness_trakcer/features/goals/domain/usecases/get_goal_progress.dart'
    as _i139;
import 'package:fitness_trakcer/features/goals/domain/usecases/update_goal.dart'
    as _i1018;
import 'package:fitness_trakcer/features/goals/domain/usecases/watch_goals.dart'
    as _i1031;
import 'package:fitness_trakcer/features/goals/presentation/cubit/achievements_cubit.dart'
    as _i452;
import 'package:fitness_trakcer/features/goals/presentation/cubit/goals_cubit.dart'
    as _i152;
import 'package:fitness_trakcer/features/gps_tracking/data/datasources/tracked_activity_local_data_source.dart'
    as _i4;
import 'package:fitness_trakcer/features/gps_tracking/data/repositories/tracked_activity_repository_impl.dart'
    as _i164;
import 'package:fitness_trakcer/features/gps_tracking/domain/repositories/tracked_activity_repository.dart'
    as _i1059;
import 'package:fitness_trakcer/features/gps_tracking/domain/services/location_tracker.dart'
    as _i922;
import 'package:fitness_trakcer/features/gps_tracking/domain/usecases/delete_tracked_activity.dart'
    as _i404;
import 'package:fitness_trakcer/features/gps_tracking/domain/usecases/get_location_permission.dart'
    as _i980;
import 'package:fitness_trakcer/features/gps_tracking/domain/usecases/get_tracked_activity.dart'
    as _i185;
import 'package:fitness_trakcer/features/gps_tracking/domain/usecases/request_location_permission.dart'
    as _i541;
import 'package:fitness_trakcer/features/gps_tracking/domain/usecases/save_tracked_activity.dart'
    as _i148;
import 'package:fitness_trakcer/features/gps_tracking/domain/usecases/watch_location.dart'
    as _i587;
import 'package:fitness_trakcer/features/gps_tracking/domain/usecases/watch_tracked_activities.dart'
    as _i413;
import 'package:fitness_trakcer/features/gps_tracking/presentation/cubit/tracked_activities_cubit.dart'
    as _i548;
import 'package:fitness_trakcer/features/gps_tracking/presentation/cubit/tracking_cubit.dart'
    as _i886;
import 'package:fitness_trakcer/features/health_sync/data/datasources/recovery_history_local_data_source.dart'
    as _i327;
import 'package:fitness_trakcer/features/health_sync/data/repositories/health_sync_repository_impl.dart'
    as _i170;
import 'package:fitness_trakcer/features/health_sync/domain/repositories/health_sync_repository.dart'
    as _i920;
import 'package:fitness_trakcer/features/health_sync/domain/usecases/sync_health_data.dart'
    as _i752;
import 'package:fitness_trakcer/features/health_sync/presentation/cubit/health_sync_cubit.dart'
    as _i1054;
import 'package:fitness_trakcer/features/profile/data/datasources/profile_local_data_source.dart'
    as _i953;
import 'package:fitness_trakcer/features/profile/data/repositories/profile_repository_impl.dart'
    as _i249;
import 'package:fitness_trakcer/features/profile/domain/repositories/profile_repository.dart'
    as _i910;
import 'package:fitness_trakcer/features/profile/domain/usecases/get_user_profile.dart'
    as _i1037;
import 'package:fitness_trakcer/features/profile/domain/usecases/save_user_profile.dart'
    as _i414;
import 'package:fitness_trakcer/features/profile/domain/usecases/watch_user_profile.dart'
    as _i698;
import 'package:fitness_trakcer/features/profile/presentation/cubit/onboarding_cubit.dart'
    as _i852;
import 'package:fitness_trakcer/features/profile/presentation/cubit/profile_cubit.dart'
    as _i946;
import 'package:fitness_trakcer/features/programs/data/repositories/program_repository_impl.dart'
    as _i157;
import 'package:fitness_trakcer/features/programs/domain/repositories/program_repository.dart'
    as _i77;
import 'package:fitness_trakcer/features/programs/domain/usecases/program_use_cases.dart'
    as _i981;
import 'package:fitness_trakcer/features/programs/presentation/cubit/programs_cubit.dart'
    as _i614;
import 'package:fitness_trakcer/features/progress_photos/data/datasources/check_in_local_data_source.dart'
    as _i1053;
import 'package:fitness_trakcer/features/progress_photos/data/repositories/check_in_repository_impl.dart'
    as _i1048;
import 'package:fitness_trakcer/features/progress_photos/data/services/image_picker_photo_picker.dart'
    as _i489;
import 'package:fitness_trakcer/features/progress_photos/data/services/photo_file_store.dart'
    as _i312;
import 'package:fitness_trakcer/features/progress_photos/domain/repositories/check_in_repository.dart'
    as _i375;
import 'package:fitness_trakcer/features/progress_photos/domain/services/photo_picker.dart'
    as _i85;
import 'package:fitness_trakcer/features/progress_photos/domain/usecases/check_in_use_cases.dart'
    as _i815;
import 'package:fitness_trakcer/features/progress_photos/presentation/cubit/check_ins_cubit.dart'
    as _i151;
import 'package:fitness_trakcer/features/recovery/data/repositories/recovery_repository_impl.dart'
    as _i729;
import 'package:fitness_trakcer/features/recovery/domain/repositories/recovery_repository.dart'
    as _i683;
import 'package:fitness_trakcer/features/recovery/domain/usecases/get_recovery_details.dart'
    as _i261;
import 'package:fitness_trakcer/features/recovery/domain/usecases/get_recovery_snapshot.dart'
    as _i551;
import 'package:fitness_trakcer/features/recovery/presentation/cubit/recovery_details_cubit.dart'
    as _i1039;
import 'package:fitness_trakcer/features/reminders/data/datasources/reminder_local_data_source.dart'
    as _i30;
import 'package:fitness_trakcer/features/reminders/data/repositories/reminder_repository_impl.dart'
    as _i53;
import 'package:fitness_trakcer/features/reminders/domain/repositories/reminder_repository.dart'
    as _i979;
import 'package:fitness_trakcer/features/reminders/domain/services/reminder_scheduler.dart'
    as _i509;
import 'package:fitness_trakcer/features/reminders/domain/usecases/delete_reminder.dart'
    as _i303;
import 'package:fitness_trakcer/features/reminders/domain/usecases/request_reminder_permission.dart'
    as _i389;
import 'package:fitness_trakcer/features/reminders/domain/usecases/reschedule_all_reminders.dart'
    as _i3;
import 'package:fitness_trakcer/features/reminders/domain/usecases/save_reminder.dart'
    as _i41;
import 'package:fitness_trakcer/features/reminders/domain/usecases/set_reminder_enabled.dart'
    as _i848;
import 'package:fitness_trakcer/features/reminders/domain/usecases/watch_reminders.dart'
    as _i456;
import 'package:fitness_trakcer/features/reminders/presentation/cubit/reminders_cubit.dart'
    as _i823;
import 'package:fitness_trakcer/features/report/domain/usecases/get_weekly_report.dart'
    as _i817;
import 'package:fitness_trakcer/features/routines/data/datasources/routine_local_data_source.dart'
    as _i1029;
import 'package:fitness_trakcer/features/routines/data/repositories/routine_repository_impl.dart'
    as _i796;
import 'package:fitness_trakcer/features/routines/domain/repositories/routine_repository.dart'
    as _i866;
import 'package:fitness_trakcer/features/routines/domain/usecases/delete_routine.dart'
    as _i542;
import 'package:fitness_trakcer/features/routines/domain/usecases/get_routine.dart'
    as _i192;
import 'package:fitness_trakcer/features/routines/domain/usecases/get_routines_for_date.dart'
    as _i141;
import 'package:fitness_trakcer/features/routines/domain/usecases/save_routine.dart'
    as _i254;
import 'package:fitness_trakcer/features/routines/domain/usecases/start_workout_from_routine.dart'
    as _i260;
import 'package:fitness_trakcer/features/routines/domain/usecases/watch_routines.dart'
    as _i726;
import 'package:fitness_trakcer/features/routines/presentation/cubit/routine_editor_cubit.dart'
    as _i850;
import 'package:fitness_trakcer/features/routines/presentation/cubit/routines_cubit.dart'
    as _i18;
import 'package:fitness_trakcer/features/sleep/data/repositories/sleep_repository_impl.dart'
    as _i939;
import 'package:fitness_trakcer/features/sleep/domain/repositories/sleep_repository.dart'
    as _i945;
import 'package:fitness_trakcer/features/sleep/domain/usecases/get_sleep_nights.dart'
    as _i1012;
import 'package:fitness_trakcer/features/sleep/presentation/cubit/sleep_cubit.dart'
    as _i555;
import 'package:fitness_trakcer/features/wellness/data/datasources/wellness_local_data_source.dart'
    as _i695;
import 'package:fitness_trakcer/features/workout/data/datasources/exercise_local_data_source.dart'
    as _i613;
import 'package:fitness_trakcer/features/workout/data/datasources/metadata_local_data_source.dart'
    as _i874;
import 'package:fitness_trakcer/features/workout/data/datasources/wger_remote_data_source.dart'
    as _i146;
import 'package:fitness_trakcer/features/workout/data/datasources/workout_local_data_source.dart'
    as _i692;
import 'package:fitness_trakcer/features/workout/data/repositories/exercise_repository_impl.dart'
    as _i797;
import 'package:fitness_trakcer/features/workout/data/repositories/workout_repository_impl.dart'
    as _i926;
import 'package:fitness_trakcer/features/workout/domain/repositories/exercise_repository.dart'
    as _i7;
import 'package:fitness_trakcer/features/workout/domain/repositories/workout_repository.dart'
    as _i956;
import 'package:fitness_trakcer/features/workout/domain/usecases/create_custom_exercise.dart'
    as _i982;
import 'package:fitness_trakcer/features/workout/domain/usecases/delete_custom_exercise.dart'
    as _i48;
import 'package:fitness_trakcer/features/workout/domain/usecases/delete_workout.dart'
    as _i372;
import 'package:fitness_trakcer/features/workout/domain/usecases/edit_workout.dart'
    as _i370;
import 'package:fitness_trakcer/features/workout/domain/usecases/finish_workout.dart'
    as _i444;
import 'package:fitness_trakcer/features/workout/domain/usecases/get_active_workout.dart'
    as _i741;
import 'package:fitness_trakcer/features/workout/domain/usecases/get_exercise_sync_status.dart'
    as _i733;
import 'package:fitness_trakcer/features/workout/domain/usecases/get_personal_records.dart'
    as _i575;
import 'package:fitness_trakcer/features/workout/domain/usecases/get_workout.dart'
    as _i337;
import 'package:fitness_trakcer/features/workout/domain/usecases/start_workout.dart'
    as _i17;
import 'package:fitness_trakcer/features/workout/domain/usecases/sync_remote_exercises.dart'
    as _i696;
import 'package:fitness_trakcer/features/workout/domain/usecases/watch_active_workout.dart'
    as _i654;
import 'package:fitness_trakcer/features/workout/domain/usecases/watch_exercises.dart'
    as _i225;
import 'package:fitness_trakcer/features/workout/domain/usecases/watch_workout_history.dart'
    as _i896;
import 'package:fitness_trakcer/features/workout/presentation/cubit/active_workout_cubit.dart'
    as _i760;
import 'package:fitness_trakcer/features/workout/presentation/cubit/exercise_library_cubit.dart'
    as _i877;
import 'package:fitness_trakcer/features/workout/presentation/cubit/personal_records_cubit.dart'
    as _i1033;
import 'package:fitness_trakcer/features/workout/presentation/cubit/rest_timer_cubit.dart'
    as _i1050;
import 'package:fitness_trakcer/features/workout/presentation/cubit/workout_detail_cubit.dart'
    as _i56;
import 'package:fitness_trakcer/features/workout/presentation/cubit/workout_history_cubit.dart'
    as _i86;
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final databaseModule = _$DatabaseModule();
    final networkModule = _$NetworkModule();
    final platformModule = _$PlatformModule();
    gh.singleton<_i160.AppDatabase>(
      () => databaseModule.database,
      dispose: _i365.closeAppDatabase,
    );
    gh.lazySingleton<_i519.Client>(() => networkModule.httpClient);
    gh.lazySingleton<_i984.HealthDataSource>(
      () => platformModule.healthDataSource,
    );
    gh.lazySingleton<_i922.LocationTracker>(
      () => platformModule.locationTracker,
    );
    gh.lazySingleton<_i509.ReminderScheduler>(
      () => platformModule.reminderScheduler,
    );
    gh.lazySingleton<_i369.Clock>(() => const _i369.Clock());
    gh.lazySingleton<_i586.IdGenerator>(() => const _i586.IdGenerator());
    gh.lazySingleton<_i312.PhotoFileStore>(() => _i312.PhotoFileStore());
    gh.lazySingleton<_i1050.RestTimerCubit>(() => _i1050.RestTimerCubit());
    gh.lazySingleton<_i284.DataManagementRepository>(
      () => _i347.DataManagementRepositoryImpl(
        gh<_i160.AppDatabase>(),
        gh<_i312.PhotoFileStore>(),
        gh<_i509.ReminderScheduler>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i85.PhotoPicker>(() => _i489.ImagePickerPhotoPicker());
    gh.lazySingleton<_i980.GetLocationPermission>(
      () => _i980.GetLocationPermission(gh<_i922.LocationTracker>()),
    );
    gh.lazySingleton<_i541.RequestLocationPermission>(
      () => _i541.RequestLocationPermission(gh<_i922.LocationTracker>()),
    );
    gh.lazySingleton<_i587.WatchLocation>(
      () => _i587.WatchLocation(gh<_i922.LocationTracker>()),
    );
    gh.lazySingleton<_i683.RecoveryRepository>(
      () => _i729.RecoveryRepositoryImpl(gh<_i984.HealthDataSource>()),
    );
    gh.lazySingleton<_i778.ExportAllData>(
      () => _i778.ExportAllData(gh<_i284.DataManagementRepository>()),
    );
    gh.lazySingleton<_i778.DeleteAllData>(
      () => _i778.DeleteAllData(gh<_i284.DataManagementRepository>()),
    );
    gh.lazySingleton<_i778.RestoreAllData>(
      () => _i778.RestoreAllData(gh<_i284.DataManagementRepository>()),
    );
    gh.lazySingleton<_i389.RequestReminderPermission>(
      () => _i389.RequestReminderPermission(gh<_i509.ReminderScheduler>()),
    );
    gh.lazySingleton<_i454.OpenFoodFactsDataSource>(
      () => _i454.OpenFoodFactsDataSource(gh<_i519.Client>()),
    );
    gh.lazySingleton<_i228.UsdaDataSource>(
      () => _i228.UsdaDataSource(gh<_i519.Client>()),
    );
    gh.lazySingleton<_i146.WgerRemoteDataSource>(
      () => _i146.WgerRemoteDataSource(gh<_i519.Client>()),
    );
    gh.lazySingleton<_i551.GetRecoverySnapshot>(
      () => _i551.GetRecoverySnapshot(
        gh<_i683.RecoveryRepository>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i1020.ActivityLocalDataSource>(
      () => _i1020.ActivityLocalDataSource(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i302.BodyMetricsLocalDataSource>(
      () => _i302.BodyMetricsLocalDataSource(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i958.SavedFoodLocalDataSource>(
      () => _i958.SavedFoodLocalDataSource(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i98.AchievementLocalDataSource>(
      () => _i98.AchievementLocalDataSource(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i978.GoalLocalDataSource>(
      () => _i978.GoalLocalDataSource(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i4.TrackedActivityLocalDataSource>(
      () => _i4.TrackedActivityLocalDataSource(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i327.RecoveryHistoryLocalDataSource>(
      () => _i327.RecoveryHistoryLocalDataSource(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i953.ProfileLocalDataSource>(
      () => _i953.ProfileLocalDataSource(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i1053.CheckInLocalDataSource>(
      () => _i1053.CheckInLocalDataSource(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i30.ReminderLocalDataSource>(
      () => _i30.ReminderLocalDataSource(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i1029.RoutineLocalDataSource>(
      () => _i1029.RoutineLocalDataSource(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i695.WellnessLocalDataSource>(
      () => _i695.WellnessLocalDataSource(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i613.ExerciseLocalDataSource>(
      () => _i613.ExerciseLocalDataSource(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i874.MetadataLocalDataSource>(
      () => _i874.MetadataLocalDataSource(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i692.WorkoutLocalDataSource>(
      () => _i692.WorkoutLocalDataSource(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i956.WorkoutRepository>(
      () => _i926.WorkoutRepositoryImpl(gh<_i692.WorkoutLocalDataSource>()),
    );
    gh.lazySingleton<_i492.GoalRepository>(
      () => _i774.GoalRepositoryImpl(gh<_i978.GoalLocalDataSource>()),
    );
    gh.lazySingleton<_i979.ReminderRepository>(
      () => _i53.ReminderRepositoryImpl(gh<_i30.ReminderLocalDataSource>()),
    );
    gh.lazySingleton<_i945.SleepRepository>(
      () => _i939.SleepRepositoryImpl(
        gh<_i984.HealthDataSource>(),
        gh<_i327.RecoveryHistoryLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i375.CheckInRepository>(
      () => _i1048.CheckInRepositoryImpl(
        gh<_i1053.CheckInLocalDataSource>(),
        gh<_i312.PhotoFileStore>(),
      ),
    );
    gh.lazySingleton<_i370.EditWorkout>(
      () => _i370.EditWorkout(
        gh<_i956.WorkoutRepository>(),
        gh<_i586.IdGenerator>(),
      ),
    );
    gh.lazySingleton<_i17.StartWorkout>(
      () => _i17.StartWorkout(
        gh<_i956.WorkoutRepository>(),
        gh<_i586.IdGenerator>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i328.BodyMetricsRepository>(
      () => _i371.BodyMetricsRepositoryImpl(
        gh<_i302.BodyMetricsLocalDataSource>(),
        gh<_i984.HealthDataSource>(),
      ),
    );
    gh.lazySingleton<_i303.DeleteReminder>(
      () => _i303.DeleteReminder(
        gh<_i979.ReminderRepository>(),
        gh<_i509.ReminderScheduler>(),
      ),
    );
    gh.lazySingleton<_i3.RescheduleAllReminders>(
      () => _i3.RescheduleAllReminders(
        gh<_i979.ReminderRepository>(),
        gh<_i509.ReminderScheduler>(),
      ),
    );
    gh.lazySingleton<_i41.SaveReminder>(
      () => _i41.SaveReminder(
        gh<_i979.ReminderRepository>(),
        gh<_i509.ReminderScheduler>(),
      ),
    );
    gh.lazySingleton<_i456.WatchReminders>(
      () => _i456.WatchReminders(gh<_i979.ReminderRepository>()),
    );
    gh.lazySingleton<_i910.ProfileRepository>(
      () => _i249.ProfileRepositoryImpl(gh<_i953.ProfileLocalDataSource>()),
    );
    gh.lazySingleton<_i7.ExerciseRepository>(
      () => _i797.ExerciseRepositoryImpl(
        gh<_i613.ExerciseLocalDataSource>(),
        gh<_i146.WgerRemoteDataSource>(),
        gh<_i874.MetadataLocalDataSource>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i687.DeleteBodyMeasurement>(
      () => _i687.DeleteBodyMeasurement(gh<_i328.BodyMetricsRepository>()),
    );
    gh.lazySingleton<_i807.UpdateBodyMeasurement>(
      () => _i807.UpdateBodyMeasurement(gh<_i328.BodyMetricsRepository>()),
    );
    gh.lazySingleton<_i285.WatchBodyMeasurements>(
      () => _i285.WatchBodyMeasurements(gh<_i328.BodyMetricsRepository>()),
    );
    gh.lazySingleton<_i1037.GetUserProfile>(
      () => _i1037.GetUserProfile(gh<_i910.ProfileRepository>()),
    );
    gh.lazySingleton<_i698.WatchUserProfile>(
      () => _i698.WatchUserProfile(gh<_i910.ProfileRepository>()),
    );
    gh.lazySingleton<_i815.SetCheckInPhoto>(
      () => _i815.SetCheckInPhoto(
        gh<_i375.CheckInRepository>(),
        gh<_i85.PhotoPicker>(),
      ),
    );
    gh.lazySingleton<_i391.DeleteGoal>(
      () => _i391.DeleteGoal(gh<_i492.GoalRepository>()),
    );
    gh.lazySingleton<_i1018.UpdateGoal>(
      () => _i1018.UpdateGoal(gh<_i492.GoalRepository>()),
    );
    gh.lazySingleton<_i1031.WatchGoals>(
      () => _i1031.WatchGoals(gh<_i492.GoalRepository>()),
    );
    gh.lazySingleton<_i659.FoodCatalogRepository>(
      () => _i923.FoodCatalogRepositoryImpl(
        gh<_i958.SavedFoodLocalDataSource>(),
        gh<_i454.OpenFoodFactsDataSource>(),
        gh<_i228.UsdaDataSource>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i1059.TrackedActivityRepository>(
      () => _i164.TrackedActivityRepositoryImpl(
        gh<_i4.TrackedActivityLocalDataSource>(),
        gh<_i984.HealthDataSource>(),
      ),
    );
    gh.lazySingleton<_i696.SyncRemoteExercises>(
      () => _i696.SyncRemoteExercises(
        gh<_i7.ExerciseRepository>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i866.RoutineRepository>(
      () => _i796.RoutineRepositoryImpl(gh<_i1029.RoutineLocalDataSource>()),
    );
    gh.lazySingleton<_i981.StartPlannedWorkout>(
      () => _i981.StartPlannedWorkout(
        gh<_i7.ExerciseRepository>(),
        gh<_i956.WorkoutRepository>(),
        gh<_i586.IdGenerator>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i372.DeleteWorkout>(
      () => _i372.DeleteWorkout(gh<_i956.WorkoutRepository>()),
    );
    gh.lazySingleton<_i741.GetActiveWorkout>(
      () => _i741.GetActiveWorkout(gh<_i956.WorkoutRepository>()),
    );
    gh.lazySingleton<_i575.GetPersonalRecords>(
      () => _i575.GetPersonalRecords(gh<_i956.WorkoutRepository>()),
    );
    gh.lazySingleton<_i337.GetWorkout>(
      () => _i337.GetWorkout(gh<_i956.WorkoutRepository>()),
    );
    gh.lazySingleton<_i654.WatchActiveWorkout>(
      () => _i654.WatchActiveWorkout(gh<_i956.WorkoutRepository>()),
    );
    gh.lazySingleton<_i896.WatchWorkoutHistory>(
      () => _i896.WatchWorkoutHistory(gh<_i956.WorkoutRepository>()),
    );
    gh.lazySingleton<_i261.GetRecoveryDetails>(
      () => _i261.GetRecoveryDetails(
        gh<_i956.WorkoutRepository>(),
        gh<_i1059.TrackedActivityRepository>(),
        gh<_i683.RecoveryRepository>(),
        gh<_i910.ProfileRepository>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i1056.LogBodyMeasurement>(
      () => _i1056.LogBodyMeasurement(
        gh<_i328.BodyMetricsRepository>(),
        gh<_i586.IdGenerator>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i550.AchievementRepository>(
      () => _i527.AchievementRepositoryImpl(
        gh<_i98.AchievementLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i848.SetReminderEnabled>(
      () => _i848.SetReminderEnabled(
        gh<_i979.ReminderRepository>(),
        gh<_i41.SaveReminder>(),
      ),
    );
    gh.lazySingleton<_i507.ActivityRepository>(
      () => _i591.ActivityRepositoryImpl(
        gh<_i1020.ActivityLocalDataSource>(),
        gh<_i984.HealthDataSource>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i20.StartupGate>(
      () => _i20.StartupGate(gh<_i695.WellnessLocalDataSource>()),
    );
    gh.lazySingleton<_i77.ProgramRepository>(
      () => _i157.ProgramRepositoryImpl(gh<_i695.WellnessLocalDataSource>()),
    );
    gh.lazySingleton<_i542.DeleteRoutine>(
      () => _i542.DeleteRoutine(gh<_i866.RoutineRepository>()),
    );
    gh.lazySingleton<_i192.GetRoutine>(
      () => _i192.GetRoutine(gh<_i866.RoutineRepository>()),
    );
    gh.lazySingleton<_i141.GetRoutinesForDate>(
      () => _i141.GetRoutinesForDate(gh<_i866.RoutineRepository>()),
    );
    gh.lazySingleton<_i726.WatchRoutines>(
      () => _i726.WatchRoutines(gh<_i866.RoutineRepository>()),
    );
    gh.factory<_i1039.RecoveryDetailsCubit>(
      () => _i1039.RecoveryDetailsCubit(gh<_i261.GetRecoveryDetails>()),
    );
    gh.lazySingleton<_i815.WatchCheckIns>(
      () => _i815.WatchCheckIns(gh<_i375.CheckInRepository>()),
    );
    gh.lazySingleton<_i815.RemoveCheckInPhoto>(
      () => _i815.RemoveCheckInPhoto(gh<_i375.CheckInRepository>()),
    );
    gh.lazySingleton<_i815.DeleteCheckIn>(
      () => _i815.DeleteCheckIn(gh<_i375.CheckInRepository>()),
    );
    gh.lazySingleton<_i1012.GetSleepNights>(
      () =>
          _i1012.GetSleepNights(gh<_i945.SleepRepository>(), gh<_i369.Clock>()),
    );
    gh.factory<_i555.SleepCubit>(
      () => _i555.SleepCubit(
        gh<_i1012.GetSleepNights>(),
        gh<_i945.SleepRepository>(),
      ),
    );
    gh.factory<_i86.WorkoutHistoryCubit>(
      () => _i86.WorkoutHistoryCubit(
        gh<_i896.WatchWorkoutHistory>(),
        gh<_i372.DeleteWorkout>(),
      ),
    );
    gh.lazySingleton<_i981.LeaveProgram>(
      () => _i981.LeaveProgram(gh<_i77.ProgramRepository>()),
    );
    gh.factory<_i823.RemindersCubit>(
      () => _i823.RemindersCubit(
        gh<_i456.WatchReminders>(),
        gh<_i41.SaveReminder>(),
        gh<_i848.SetReminderEnabled>(),
        gh<_i303.DeleteReminder>(),
        gh<_i389.RequestReminderPermission>(),
      ),
    );
    gh.lazySingleton<_i936.GetBodyProgress>(
      () => _i936.GetBodyProgress(
        gh<_i328.BodyMetricsRepository>(),
        gh<_i910.ProfileRepository>(),
      ),
    );
    gh.lazySingleton<_i310.GetLatestWeight>(
      () => _i310.GetLatestWeight(
        gh<_i328.BodyMetricsRepository>(),
        gh<_i910.ProfileRepository>(),
      ),
    );
    gh.lazySingleton<_i815.CreateCheckIn>(
      () => _i815.CreateCheckIn(
        gh<_i375.CheckInRepository>(),
        gh<_i328.BodyMetricsRepository>(),
        gh<_i586.IdGenerator>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i254.SaveRoutine>(
      () => _i254.SaveRoutine(
        gh<_i866.RoutineRepository>(),
        gh<_i586.IdGenerator>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i444.FinishWorkout>(
      () => _i444.FinishWorkout(
        gh<_i956.WorkoutRepository>(),
        gh<_i310.GetLatestWeight>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i981.EnrollInProgram>(
      () => _i981.EnrollInProgram(
        gh<_i77.ProgramRepository>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i48.DeleteCustomExercise>(
      () => _i48.DeleteCustomExercise(gh<_i7.ExerciseRepository>()),
    );
    gh.lazySingleton<_i733.GetExerciseSyncStatus>(
      () => _i733.GetExerciseSyncStatus(gh<_i7.ExerciseRepository>()),
    );
    gh.lazySingleton<_i225.WatchExercises>(
      () => _i225.WatchExercises(gh<_i7.ExerciseRepository>()),
    );
    gh.factory<_i107.FoodCatalogCubit>(
      () => _i107.FoodCatalogCubit(
        gh<_i659.FoodCatalogRepository>(),
        gh<_i586.IdGenerator>(),
      ),
    );
    gh.factory<_i849.BodyMetricsCubit>(
      () => _i849.BodyMetricsCubit(
        gh<_i285.WatchBodyMeasurements>(),
        gh<_i936.GetBodyProgress>(),
        gh<_i1056.LogBodyMeasurement>(),
        gh<_i807.UpdateBodyMeasurement>(),
        gh<_i687.DeleteBodyMeasurement>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i414.SaveUserProfile>(
      () => _i414.SaveUserProfile(
        gh<_i910.ProfileRepository>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i205.GetActivityRange>(
      () => _i205.GetActivityRange(gh<_i507.ActivityRepository>()),
    );
    gh.lazySingleton<_i493.GetHealthAccessStatus>(
      () => _i493.GetHealthAccessStatus(gh<_i507.ActivityRepository>()),
    );
    gh.lazySingleton<_i876.LogManualActivity>(
      () => _i876.LogManualActivity(gh<_i507.ActivityRepository>()),
    );
    gh.lazySingleton<_i233.RequestHealthAccess>(
      () => _i233.RequestHealthAccess(gh<_i507.ActivityRepository>()),
    );
    gh.lazySingleton<_i188.SyncActivityFromHealth>(
      () => _i188.SyncActivityFromHealth(gh<_i507.ActivityRepository>()),
    );
    gh.lazySingleton<_i340.WatchDailyActivity>(
      () => _i340.WatchDailyActivity(gh<_i507.ActivityRepository>()),
    );
    gh.factory<_i504.ActivityCubit>(
      () => _i504.ActivityCubit(
        gh<_i340.WatchDailyActivity>(),
        gh<_i205.GetActivityRange>(),
        gh<_i493.GetHealthAccessStatus>(),
        gh<_i233.RequestHealthAccess>(),
        gh<_i188.SyncActivityFromHealth>(),
        gh<_i876.LogManualActivity>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i982.CreateCustomExercise>(
      () => _i982.CreateCustomExercise(
        gh<_i7.ExerciseRepository>(),
        gh<_i586.IdGenerator>(),
      ),
    );
    gh.factory<_i852.OnboardingCubit>(
      () => _i852.OnboardingCubit(
        gh<_i414.SaveUserProfile>(),
        gh<_i1056.LogBodyMeasurement>(),
      ),
    );
    gh.lazySingleton<_i817.GetWeeklyReport>(
      () => _i817.GetWeeklyReport(
        gh<_i956.WorkoutRepository>(),
        gh<_i1059.TrackedActivityRepository>(),
        gh<_i507.ActivityRepository>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i260.StartWorkoutFromRoutine>(
      () => _i260.StartWorkoutFromRoutine(
        gh<_i866.RoutineRepository>(),
        gh<_i956.WorkoutRepository>(),
        gh<_i586.IdGenerator>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.factory<_i56.WorkoutDetailCubit>(
      () => _i56.WorkoutDetailCubit(gh<_i337.GetWorkout>()),
    );
    gh.lazySingleton<_i946.ProfileCubit>(
      () => _i946.ProfileCubit(
        gh<_i698.WatchUserProfile>(),
        gh<_i414.SaveUserProfile>(),
      ),
    );
    gh.factory<_i877.ExerciseLibraryCubit>(
      () => _i877.ExerciseLibraryCubit(
        gh<_i225.WatchExercises>(),
        gh<_i982.CreateCustomExercise>(),
        gh<_i48.DeleteCustomExercise>(),
        gh<_i696.SyncRemoteExercises>(),
        gh<_i733.GetExerciseSyncStatus>(),
      ),
    );
    gh.lazySingleton<_i404.DeleteTrackedActivity>(
      () => _i404.DeleteTrackedActivity(gh<_i1059.TrackedActivityRepository>()),
    );
    gh.lazySingleton<_i185.GetTrackedActivity>(
      () => _i185.GetTrackedActivity(gh<_i1059.TrackedActivityRepository>()),
    );
    gh.lazySingleton<_i413.WatchTrackedActivities>(
      () =>
          _i413.WatchTrackedActivities(gh<_i1059.TrackedActivityRepository>()),
    );
    gh.factory<_i1033.PersonalRecordsCubit>(
      () => _i1033.PersonalRecordsCubit(gh<_i575.GetPersonalRecords>()),
    );
    gh.lazySingleton<_i950.GetAchievements>(
      () => _i950.GetAchievements(gh<_i550.AchievementRepository>()),
    );
    gh.lazySingleton<_i668.GoalProgressCalculator>(
      () => _i668.GoalProgressCalculator(
        gh<_i507.ActivityRepository>(),
        gh<_i956.WorkoutRepository>(),
        gh<_i1059.TrackedActivityRepository>(),
        gh<_i310.GetLatestWeight>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i920.HealthSyncRepository>(
      () => _i170.HealthSyncRepositoryImpl(
        gh<_i507.ActivityRepository>(),
        gh<_i328.BodyMetricsRepository>(),
        gh<_i1059.TrackedActivityRepository>(),
        gh<_i327.RecoveryHistoryLocalDataSource>(),
        gh<_i984.HealthDataSource>(),
        gh<_i695.WellnessLocalDataSource>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i951.AppRouter>(
      () => _i951.AppRouter(gh<_i946.ProfileCubit>(), gh<_i20.StartupGate>()),
    );
    gh.lazySingleton<_i981.GetProgramProgress>(
      () => _i981.GetProgramProgress(
        gh<_i77.ProgramRepository>(),
        gh<_i956.WorkoutRepository>(),
        gh<_i1059.TrackedActivityRepository>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i968.CreateGoal>(
      () => _i968.CreateGoal(
        gh<_i492.GoalRepository>(),
        gh<_i310.GetLatestWeight>(),
        gh<_i586.IdGenerator>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i139.GetGoalProgress>(
      () => _i139.GetGoalProgress(
        gh<_i492.GoalRepository>(),
        gh<_i668.GoalProgressCalculator>(),
      ),
    );
    gh.factory<_i18.RoutinesCubit>(
      () => _i18.RoutinesCubit(
        gh<_i726.WatchRoutines>(),
        gh<_i542.DeleteRoutine>(),
        gh<_i260.StartWorkoutFromRoutine>(),
      ),
    );
    gh.factory<_i850.RoutineEditorCubit>(
      () => _i850.RoutineEditorCubit(
        gh<_i192.GetRoutine>(),
        gh<_i254.SaveRoutine>(),
      ),
    );
    gh.lazySingleton<_i151.CheckInsCubit>(
      () => _i151.CheckInsCubit(
        gh<_i815.WatchCheckIns>(),
        gh<_i815.CreateCheckIn>(),
        gh<_i815.SetCheckInPhoto>(),
        gh<_i815.RemoveCheckInPhoto>(),
        gh<_i815.DeleteCheckIn>(),
      ),
    );
    gh.factory<_i614.ProgramsCubit>(
      () => _i614.ProgramsCubit(
        gh<_i981.GetProgramProgress>(),
        gh<_i981.EnrollInProgram>(),
        gh<_i981.LeaveProgram>(),
        gh<_i981.StartPlannedWorkout>(),
      ),
    );
    gh.lazySingleton<_i148.SaveTrackedActivity>(
      () => _i148.SaveTrackedActivity(
        gh<_i1059.TrackedActivityRepository>(),
        gh<_i310.GetLatestWeight>(),
        gh<_i586.IdGenerator>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i752.SyncHealthData>(
      () => _i752.SyncHealthData(gh<_i920.HealthSyncRepository>()),
    );
    gh.lazySingleton<_i1054.HealthSyncCubit>(
      () => _i1054.HealthSyncCubit(
        gh<_i493.GetHealthAccessStatus>(),
        gh<_i233.RequestHealthAccess>(),
        gh<_i752.SyncHealthData>(),
        gh<_i920.HealthSyncRepository>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i760.ActiveWorkoutCubit>(
      () => _i760.ActiveWorkoutCubit(
        gh<_i654.WatchActiveWorkout>(),
        gh<_i17.StartWorkout>(),
        gh<_i370.EditWorkout>(),
        gh<_i444.FinishWorkout>(),
        gh<_i372.DeleteWorkout>(),
      ),
    );
    gh.lazySingleton<_i886.TrackingCubit>(
      () => _i886.TrackingCubit(
        gh<_i541.RequestLocationPermission>(),
        gh<_i587.WatchLocation>(),
        gh<_i148.SaveTrackedActivity>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.factory<_i548.TrackedActivitiesCubit>(
      () => _i548.TrackedActivitiesCubit(
        gh<_i413.WatchTrackedActivities>(),
        gh<_i404.DeleteTrackedActivity>(),
      ),
    );
    gh.factory<_i152.GoalsCubit>(
      () => _i152.GoalsCubit(
        gh<_i1031.WatchGoals>(),
        gh<_i139.GetGoalProgress>(),
        gh<_i968.CreateGoal>(),
        gh<_i391.DeleteGoal>(),
      ),
    );
    gh.lazySingleton<_i155.EvaluateAchievements>(
      () => _i155.EvaluateAchievements(
        gh<_i550.AchievementRepository>(),
        gh<_i956.WorkoutRepository>(),
        gh<_i1059.TrackedActivityRepository>(),
        gh<_i507.ActivityRepository>(),
        gh<_i139.GetGoalProgress>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.lazySingleton<_i711.GetDashboardSummary>(
      () => _i711.GetDashboardSummary(
        gh<_i507.ActivityRepository>(),
        gh<_i956.WorkoutRepository>(),
        gh<_i141.GetRoutinesForDate>(),
        gh<_i310.GetLatestWeight>(),
        gh<_i139.GetGoalProgress>(),
        gh<_i551.GetRecoverySnapshot>(),
        gh<_i817.GetWeeklyReport>(),
        gh<_i1059.TrackedActivityRepository>(),
        gh<_i369.Clock>(),
      ),
    );
    gh.factory<_i656.DashboardCubit>(
      () => _i656.DashboardCubit(
        gh<_i711.GetDashboardSummary>(),
        gh<_i155.EvaluateAchievements>(),
      ),
    );
    gh.factory<_i452.AchievementsCubit>(
      () => _i452.AchievementsCubit(
        gh<_i155.EvaluateAchievements>(),
        gh<_i950.GetAchievements>(),
      ),
    );
    return this;
  }
}

class _$DatabaseModule extends _i365.DatabaseModule {}

class _$NetworkModule extends _i162.NetworkModule {}

class _$PlatformModule extends _i196.PlatformModule {}
