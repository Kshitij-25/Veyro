import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/achievement.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/achievement_type.dart';
import 'package:fitness_trakcer/features/goals/domain/repositories/achievement_repository.dart';
import 'package:injectable/injectable.dart';

/// Every achievement, marked unlocked or locked.
@lazySingleton
class GetAchievements implements UseCase<List<Achievement>, NoParams> {
  const GetAchievements(this._repository);

  final AchievementRepository _repository;

  @override
  Future<Result<List<Achievement>>> call(NoParams params) async {
    final unlocked = await _repository.getUnlocked();
    return unlocked.map((items) {
      final byType = {for (final a in items) a.type: a};
      return [
        for (final type in AchievementType.values)
          byType[type] ?? Achievement(type: type),
      ];
    });
  }
}
