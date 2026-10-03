import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/tables/activity_tables.dart';
import 'package:fitness_trakcer/core/database/tables/app_metadata_tables.dart';
import 'package:fitness_trakcer/core/database/tables/body_metrics_tables.dart';
import 'package:fitness_trakcer/core/database/tables/goal_tables.dart';
import 'package:fitness_trakcer/core/database/tables/profile_tables.dart';
import 'package:fitness_trakcer/core/database/tables/reminder_tables.dart';
import 'package:fitness_trakcer/core/database/tables/routine_tables.dart';
import 'package:fitness_trakcer/core/database/tables/tracking_tables.dart';
import 'package:fitness_trakcer/core/database/tables/workout_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    UserProfiles,
    BodyMeasurements,
    Exercises,
    Workouts,
    WorkoutExercises,
    WorkoutSets,
    Routines,
    RoutineExercises,
    DailyActivities,
    Goals,
    UnlockedAchievements,
    Reminders,
    TrackedActivities,
    AppMetadata,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        // Remote exercise catalogue and metadata.
        await migrator.addColumn(exercises, exercises.source);
        await migrator.addColumn(exercises, exercises.remoteId);
        await migrator.addColumn(exercises, exercises.imageUrl);
        await migrator.addColumn(exercises, exercises.description);
        await migrator.createTable(appMetadata);
      }
      if (from < 3) {
        // The nutrition feature was removed: drop its data and anything that
        // referred to it.
        await customStatement('DROP TABLE IF EXISTS food_entries');
        await customStatement('DROP TABLE IF EXISTS water_entries');
        await customStatement('DROP TABLE IF EXISTS food_items');
        await customStatement(
          "DELETE FROM goals WHERE type IN ('dailyCalories', 'dailyWater')",
        );
        await customStatement(
          "DELETE FROM reminders WHERE type IN ('water', 'meal')",
        );
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
