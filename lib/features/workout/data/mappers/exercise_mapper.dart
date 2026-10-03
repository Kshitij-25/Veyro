import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/equipment.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise_source.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise_tracking_type.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/muscle_group.dart';

extension ExerciseRowMapper on ExerciseRow {
  Exercise toEntity() => Exercise(
    id: id,
    name: name,
    muscleGroup: MuscleGroup.values.byName(muscleGroup),
    equipment: Equipment.values.byName(equipment),
    trackingType: ExerciseTrackingType.values.byName(trackingType),
    source: ExerciseSource.values.byName(source),
    remoteId: remoteId,
    imageUrl: imageUrl,
    description: description,
  );
}

extension ExerciseEntityMapper on Exercise {
  ExercisesCompanion toCompanion() => ExercisesCompanion(
    id: Value(id),
    name: Value(name),
    muscleGroup: Value(muscleGroup.name),
    equipment: Value(equipment.name),
    trackingType: Value(trackingType.name),
    isCustom: Value(isCustom),
    source: Value(source.name),
    remoteId: Value(remoteId),
    imageUrl: Value(imageUrl),
    description: Value(description),
  );
}
