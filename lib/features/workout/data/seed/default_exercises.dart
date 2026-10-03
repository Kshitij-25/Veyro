import 'package:fitness_trakcer/features/workout/domain/entities/equipment.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise_tracking_type.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/muscle_group.dart';

Exercise _e(
  String id,
  String name,
  MuscleGroup group,
  Equipment equipment, [
  ExerciseTrackingType type = ExerciseTrackingType.weightAndReps,
]) => Exercise(
  id: 'builtin_$id',
  name: name,
  muscleGroup: group,
  equipment: equipment,
  trackingType: type,
);

/// Built-in exercise library. Ids are stable so routines and history keep
/// pointing at the same exercise across app updates.
final List<Exercise> defaultExercises = [
  _e('bench_press', 'Bench Press', MuscleGroup.chest, Equipment.barbell),
  _e(
    'incline_db_press',
    'Incline Dumbbell Press',
    MuscleGroup.chest,
    Equipment.dumbbell,
  ),
  _e('chest_fly', 'Cable Fly', MuscleGroup.chest, Equipment.cable),
  _e(
    'push_up',
    'Push-up',
    MuscleGroup.chest,
    Equipment.bodyweight,
    ExerciseTrackingType.repsOnly,
  ),
  _e('deadlift', 'Deadlift', MuscleGroup.back, Equipment.barbell),
  _e('barbell_row', 'Barbell Row', MuscleGroup.back, Equipment.barbell),
  _e('lat_pulldown', 'Lat Pulldown', MuscleGroup.back, Equipment.machine),
  _e('seated_row', 'Seated Cable Row', MuscleGroup.back, Equipment.cable),
  _e(
    'pull_up',
    'Pull-up',
    MuscleGroup.back,
    Equipment.bodyweight,
    ExerciseTrackingType.repsOnly,
  ),
  _e(
    'overhead_press',
    'Overhead Press',
    MuscleGroup.shoulders,
    Equipment.barbell,
  ),
  _e(
    'lateral_raise',
    'Lateral Raise',
    MuscleGroup.shoulders,
    Equipment.dumbbell,
  ),
  _e('face_pull', 'Face Pull', MuscleGroup.shoulders, Equipment.cable),
  _e('barbell_curl', 'Barbell Curl', MuscleGroup.biceps, Equipment.barbell),
  _e('hammer_curl', 'Hammer Curl', MuscleGroup.biceps, Equipment.dumbbell),
  _e(
    'tricep_pushdown',
    'Triceps Pushdown',
    MuscleGroup.triceps,
    Equipment.cable,
  ),
  _e('skull_crusher', 'Skull Crusher', MuscleGroup.triceps, Equipment.barbell),
  _e(
    'dip',
    'Dip',
    MuscleGroup.triceps,
    Equipment.bodyweight,
    ExerciseTrackingType.repsOnly,
  ),
  _e('squat', 'Back Squat', MuscleGroup.legs, Equipment.barbell),
  _e('front_squat', 'Front Squat', MuscleGroup.legs, Equipment.barbell),
  _e('leg_press', 'Leg Press', MuscleGroup.legs, Equipment.machine),
  _e('lunge', 'Walking Lunge', MuscleGroup.legs, Equipment.dumbbell),
  _e('leg_curl', 'Leg Curl', MuscleGroup.legs, Equipment.machine),
  _e('leg_extension', 'Leg Extension', MuscleGroup.legs, Equipment.machine),
  _e('calf_raise', 'Calf Raise', MuscleGroup.legs, Equipment.machine),
  _e(
    'romanian_deadlift',
    'Romanian Deadlift',
    MuscleGroup.glutes,
    Equipment.barbell,
  ),
  _e('hip_thrust', 'Hip Thrust', MuscleGroup.glutes, Equipment.barbell),
  _e(
    'plank',
    'Plank',
    MuscleGroup.core,
    Equipment.bodyweight,
    ExerciseTrackingType.duration,
  ),
  _e(
    'crunch',
    'Crunch',
    MuscleGroup.core,
    Equipment.bodyweight,
    ExerciseTrackingType.repsOnly,
  ),
  _e(
    'hanging_leg_raise',
    'Hanging Leg Raise',
    MuscleGroup.core,
    Equipment.bodyweight,
    ExerciseTrackingType.repsOnly,
  ),
  _e(
    'russian_twist',
    'Russian Twist',
    MuscleGroup.core,
    Equipment.bodyweight,
    ExerciseTrackingType.repsOnly,
  ),
  _e(
    'kettlebell_swing',
    'Kettlebell Swing',
    MuscleGroup.fullBody,
    Equipment.kettlebell,
  ),
  _e(
    'burpee',
    'Burpee',
    MuscleGroup.fullBody,
    Equipment.bodyweight,
    ExerciseTrackingType.repsOnly,
  ),
  _e(
    'clean_and_press',
    'Clean and Press',
    MuscleGroup.fullBody,
    Equipment.barbell,
  ),
  _e(
    'running',
    'Running',
    MuscleGroup.cardio,
    Equipment.bodyweight,
    ExerciseTrackingType.distanceAndDuration,
  ),
  _e(
    'cycling',
    'Cycling',
    MuscleGroup.cardio,
    Equipment.machine,
    ExerciseTrackingType.distanceAndDuration,
  ),
  _e(
    'rowing',
    'Rowing Machine',
    MuscleGroup.cardio,
    Equipment.machine,
    ExerciseTrackingType.distanceAndDuration,
  ),
  _e(
    'jump_rope',
    'Jump Rope',
    MuscleGroup.cardio,
    Equipment.other,
    ExerciseTrackingType.duration,
  ),
  _e(
    'stair_climber',
    'Stair Climber',
    MuscleGroup.cardio,
    Equipment.machine,
    ExerciseTrackingType.duration,
  ),
];
