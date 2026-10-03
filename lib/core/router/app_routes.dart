/// Route paths. Child routes are declared relative to their parent.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';

  static const home = '/home';
  static const settings = '$home/settings';
  static const reminders = '$settings/reminders';

  static const workouts = '/workouts';
  static const activeWorkout = '$workouts/active';
  static const exerciseLibrary = '$workouts/library';
  static const routines = '$workouts/routines';
  static const personalRecords = '$workouts/records';
  static String workoutDetail(String id) => '$workouts/detail/$id';
  static String routineEditor([String? id]) =>
      id == null ? '$routines/edit' : '$routines/edit?id=$id';

  static const activity = '/activity';
  static const tracking = '$activity/tracking';
  static const trackingHistory = '$activity/history';

  static const progress = '/progress';
  static const goals = '$progress/goals';
  static const achievements = '$progress/achievements';
}
