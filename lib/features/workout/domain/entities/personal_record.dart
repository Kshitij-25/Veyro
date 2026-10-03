import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'personal_record.freezed.dart';

@freezed
abstract class PersonalRecord with _$PersonalRecord {
  const factory PersonalRecord({
    required Exercise exercise,
    required double maxWeightKg,
    required int maxReps,
    required double estimatedOneRepMaxKg,
    required DateTime achievedAt,
  }) = _PersonalRecord;
}
