/// Route paths. Child routes are declared relative to their parent.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';

  static const home = '/home';
  static const settings = '$home/settings';
  static const reminders = '$settings/reminders';
  static const preferences = '$settings/preferences';
  static const devices = '$settings/devices';
  static const pro = '$settings/pro';

  static const workouts = '/workouts';
  static const activeWorkout = '$workouts/active';
  static const exerciseLibrary = '$workouts/library';
  static const exerciseDetail = '$workouts/exercise';
  static const routines = '$workouts/routines';
  static const personalRecords = '$workouts/records';
  static const discover = '$workouts/discover';
  static const calendar = '$workouts/calendar';
  static const timers = '$workouts/timers';
  static const tools = '$workouts/tools';
  static const mind = '$workouts/mind';
  static String workoutDetail(String id) => '$workouts/detail/$id';
  static String routineEditor([String? id]) =>
      id == null ? '$routines/edit' : '$routines/edit?id=$id';

  static const activity = '$workouts/activity';
  static const tracking = '$activity/tracking';
  static const trackingHistory = '$activity/history';
  static const trackingSummary = '$activity/summary';

  static const fuel = '/fuel';
  static const foodSearch = '$fuel/log';
  static const scan = '$fuel/scan';
  static const recipes = '$fuel/recipes';
  static const fasting = '$fuel/fasting';
  static const nutritionTargets = '$fuel/targets';

  static const progress = '/progress';
  static const goals = '$progress/goals';
  static const achievements = '$progress/achievements';
  static const bodyComposition = '$progress/body';
  static const sleep = '$progress/sleep';
  static const recovery = '$progress/recovery';
  static const photos = '$progress/photos';
  static const report = '$progress/report';
  static const habits = '$progress/habits';

  static const community = '/community';
}
