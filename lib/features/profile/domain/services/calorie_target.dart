import 'package:fitness_trakcer/features/profile/domain/entities/sex.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/user_profile.dart';

/// Daily calorie target from the profile: Mifflin-St Jeor resting energy,
/// scaled by activity level, then nudged by the fitness goal.
abstract final class CalorieTarget {
  static int forProfile(UserProfile p, DateTime now) {
    final base = 10 * p.weightKg + 6.25 * p.heightCm - 5 * p.ageOn(now);
    final bmr = switch (p.sex) {
      Sex.male => base + 5,
      Sex.female => base - 161,
      Sex.other => base - 78,
    };
    final target =
        bmr *
        p.activityLevel.multiplier *
        (1 + p.fitnessGoal.calorieAdjustment);
    // Round to 50 so the stepper on the targets page lines up.
    return ((target / 50).round() * 50).clamp(1200, 5000);
  }
}
