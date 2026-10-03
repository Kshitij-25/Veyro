import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/activity_level.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/fitness_goal.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/sex.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/user_profile.dart';

extension UserProfileRowMapper on UserProfileRow {
  UserProfile toEntity() => UserProfile(
    id: id,
    name: name,
    birthDate: birthDate,
    sex: Sex.values.byName(sex),
    heightCm: heightCm,
    weightKg: weightKg,
    activityLevel: ActivityLevel.values.byName(activityLevel),
    fitnessGoal: FitnessGoal.values.byName(fitnessGoal),
    unitSystem: UnitSystem.values.byName(unitSystem),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension UserProfileEntityMapper on UserProfile {
  UserProfilesCompanion toCompanion() => UserProfilesCompanion(
    id: Value(id),
    name: Value(name),
    birthDate: Value(birthDate),
    sex: Value(sex.name),
    heightCm: Value(heightCm),
    weightKg: Value(weightKg),
    activityLevel: Value(activityLevel.name),
    fitnessGoal: Value(fitnessGoal.name),
    unitSystem: Value(unitSystem.name),
    createdAt: Value(createdAt),
    updatedAt: Value(updatedAt),
  );
}
