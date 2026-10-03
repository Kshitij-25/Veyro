import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/programs/domain/repositories/program_repository.dart';
import 'package:fitness_trakcer/features/wellness/data/datasources/wellness_local_data_source.dart';
import 'package:injectable/injectable.dart';

/// Keeps the single active enrollment in the key/value settings table.
@LazySingleton(as: ProgramRepository)
class ProgramRepositoryImpl implements ProgramRepository {
  const ProgramRepositoryImpl(this._settings);

  static const _idKey = 'program_id';
  static const _startKey = 'program_started';

  final WellnessLocalDataSource _settings;

  @override
  Future<Result<ProgramEnrollment?>> getEnrollment() => guard(() async {
    final id = await _settings.getSetting(_idKey);
    final started = DateTime.tryParse(
      await _settings.getSetting(_startKey) ?? '',
    );
    if (id == null || id.isEmpty || started == null) return null;
    return ProgramEnrollment(id, started);
  });

  @override
  Future<Result<void>> enroll(String programId, DateTime startedAt) =>
      guard(() async {
        await _settings.setSetting(_idKey, programId);
        await _settings.setSetting(_startKey, startedAt.toIso8601String());
      });

  @override
  Future<Result<void>> leave() => guard(() => _settings.setSetting(_idKey, ''));
}
