import 'package:fitness_trakcer/features/workout/data/models/wger_exercise_dto.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/equipment.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise_source.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise_tracking_type.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/muscle_group.dart';

/// wger muscle ids (see https://wger.de/api/v2/muscle/).
abstract final class _Muscle {
  static const triceps = 5;
  static const gluteus = 8;
  static const quadriceps = 10;
  static const hamstrings = 11;
  static const gastrocnemius = 7;
}

extension WgerExerciseDtoMapper on WgerExerciseDto {
  /// `null` when the exercise has no usable English name.
  Exercise? toExercise() {
    if (name.isEmpty || uuid.isEmpty) return null;
    final equipment = _equipment();
    return Exercise(
      id: 'wger_$uuid',
      name: name,
      muscleGroup: _muscleGroup(),
      equipment: equipment,
      trackingType: _trackingType(equipment),
      source: ExerciseSource.wger,
      remoteId: uuid,
      imageUrl: imageUrl,
      description: _plainText(description),
    );
  }

  MuscleGroup _muscleGroup() {
    switch (categoryName) {
      case 'Abs':
        return MuscleGroup.core;
      case 'Back':
        return MuscleGroup.back;
      case 'Calves':
        return MuscleGroup.legs;
      case 'Cardio':
        return MuscleGroup.cardio;
      case 'Chest':
        return MuscleGroup.chest;
      case 'Shoulders':
        return MuscleGroup.shoulders;
      case 'Arms':
        if (primaryMuscleIds.contains(_Muscle.triceps)) {
          return MuscleGroup.triceps;
        }
        return MuscleGroup.biceps;
      case 'Legs':
        final onlyGlutes =
            primaryMuscleIds.contains(_Muscle.gluteus) &&
            !primaryMuscleIds.any(
              (id) => const [
                _Muscle.quadriceps,
                _Muscle.hamstrings,
                _Muscle.gastrocnemius,
              ].contains(id),
            );
        return onlyGlutes ? MuscleGroup.glutes : MuscleGroup.legs;
      default:
        return MuscleGroup.fullBody;
    }
  }

  Equipment _equipment() {
    bool has(String value) => equipmentNames.contains(value);
    // Loaded equipment wins when several are listed.
    if (has('Barbell') || has('SZ-Bar')) return Equipment.barbell;
    if (has('Dumbbell')) return Equipment.dumbbell;
    if (has('Kettlebell')) return Equipment.kettlebell;
    if (has('Cable machine')) return Equipment.cable;
    if (equipmentNames.isEmpty ||
        has('none (bodyweight exercise)') ||
        has('Pull-up bar') ||
        has('Gym mat')) {
      return Equipment.bodyweight;
    }
    return Equipment.other;
  }

  ExerciseTrackingType _trackingType(Equipment equipment) {
    if (categoryName == 'Cardio') return ExerciseTrackingType.duration;
    return equipment == Equipment.bodyweight
        ? ExerciseTrackingType.repsOnly
        : ExerciseTrackingType.weightAndReps;
  }
}

/// wger descriptions are HTML; keep readable plain text.
String? _plainText(String? html) {
  if (html == null) return null;
  final text = html
      .replaceAll(RegExp(r'</(p|li|div)>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]+>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll(RegExp(r'\n{3,}'), '\n\n')
      .trim();
  if (text.isEmpty) return null;
  return text.length > 1500 ? '${text.substring(0, 1500)}…' : text;
}
