import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/activity_level.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/fitness_goal.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/sex.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String name,
    required DateTime birthDate,
    required Sex sex,
    required double heightCm,
    required double weightKg,
    required ActivityLevel activityLevel,
    required FitnessGoal fitnessGoal,
    required UnitSystem unitSystem,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserProfile;

  const UserProfile._();

  /// There is exactly one profile on a device.
  static const localId = 'me';

  int ageOn(DateTime date) {
    var age = date.year - birthDate.year;
    final hadBirthday =
        date.month > birthDate.month ||
        (date.month == birthDate.month && date.day >= birthDate.day);
    if (!hadBirthday) age--;
    return age;
  }
}
