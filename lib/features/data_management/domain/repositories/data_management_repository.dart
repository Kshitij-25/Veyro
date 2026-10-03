import 'package:fitness_trakcer/core/utils/result.dart';

abstract interface class DataManagementRepository {
  /// Writes everything the user entered to a JSON file and returns its path.
  Future<Result<String>> exportToFile();

  /// Replaces everything with the contents of an export file at [path] and
  /// returns the number of rows restored. Nothing changes if the file is
  /// invalid.
  Future<Result<int>> restoreFromFile(String path);

  /// Permanently erases everything the user entered: logs, workouts, goals,
  /// profile, photos, reminders and settings.
  Future<Result<void>> deleteEverything();
}
