import 'package:drift/drift.dart' show Value;
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/core/di/injection.dart';
import 'package:fitness_trakcer/core/utils/id_generator.dart';
import 'package:fitness_trakcer/features/reminders/domain/services/reminder_scheduler.dart';
import 'package:fitness_trakcer/features/wellness/data/datasources/wellness_local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A food in the sample catalogue.
class FoodItem {
  const FoodItem(this.name, this.serving, this.kcal, this.p, this.c, this.f);

  final String name;
  final String serving;
  final int kcal;
  final int p;
  final int c;
  final int f;
}

/// A catalogue food logged with a quantity of servings.
class LoggedFood {
  LoggedFood(this.food, this.quantity, {this.id = ''});

  final String id;
  final FoodItem food;
  final double quantity;

  double get kcal => food.kcal * quantity;
  double get p => food.p * quantity;
  double get c => food.c * quantity;
  double get f => food.f * quantity;
}

class Habit {
  Habit({
    required this.id,
    required this.name,
    required this.tag,
    required this.streak,
    required this.week,
    required this.today,
  });

  final String id;
  final String name;
  final String tag;

  /// Consecutive completed days ending yesterday.
  int streak;

  /// The six days before today, oldest first.
  List<bool> week;
  bool today;

  int get shownStreak => streak + (today ? 1 : 0);
}

/// A logged mind or breathing session.
class MindRecord {
  const MindRecord(
    this.id,
    this.name,
    this.category,
    this.startedAt,
    this.seconds,
  );

  final String id;
  final String name;
  final String category;
  final DateTime startedAt;
  final int seconds;
}

/// A finished fast.
class FastRecord {
  const FastRecord(this.id, this.start, this.end, this.goalHours);

  final String id;
  final DateTime start;
  final DateTime end;
  final int goalHours;

  Duration get duration => end.difference(start);
  bool get reachedGoal => duration.inMinutes >= goalHours * 60;
}

/// Shared state for the wellness screens.
///
/// Saved in the database: water, the food diary, calorie/macro/water targets,
/// habits, fasting, mind sessions and the Settings values.
class WellnessStore extends ChangeNotifier {
  WellnessStore._();

  static final WellnessStore instance = WellnessStore._();

  WellnessLocalDataSource? _data;
  final IdGenerator _ids = const IdGenerator();
  String _today = _dayKey(DateTime.now());

  static String _dayKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Loads saved data. Call once after dependencies are configured.
  Future<void> init(WellnessLocalDataSource data) async {
    _data = data;
    await _load();
  }

  /// Reloads today's data after midnight (or when the app was backgrounded).
  Future<void> reloadIfNewDay() async {
    if (_dayKey(DateTime.now()) != _today) await _load();
  }

  Future<void> _load() async {
    final data = _data;
    if (data == null) return;
    _today = _dayKey(DateTime.now());

    kcalGoal = int.tryParse(await data.getSetting('kcal_goal') ?? '') ?? 2400;
    themeMode = switch (await data.getSetting('theme_mode')) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    autoRest = await data.getSetting('auto_rest') != '0';
    keepAwake = await data.getSetting('keep_awake') != '0';
    haptic = await data.getSetting('haptic') != '0';
    syncHealth = await data.getSetting('health_auto_sync') != '0';
    restSeconds =
        (int.tryParse(await data.getSetting('rest_seconds') ?? '') ?? 90).clamp(
          15,
          600,
        );
    sleepGoalHours =
        double.tryParse(await data.getSetting('sleep_goal_h') ?? '') ?? 8;
    macroPreset = await data.getSetting('macro_preset') ?? 'Balanced';
    if (!macroPresets.containsKey(macroPreset)) macroPreset = 'Balanced';
    waterGoalMl =
        int.tryParse(await data.getSetting('water_goal_ml') ?? '') ?? 2500;
    _applyMacros();

    waterMl = await data.getWater(_today);

    for (final m in mealNames) {
      meals[m] = [];
    }
    for (final r in await data.getFood(_today)) {
      final meal = mealNames.contains(r.meal) ? r.meal : 'Snacks';
      meals[meal]!.add(
        LoggedFood(
          FoodItem(
            r.name,
            r.serving,
            r.kcal.round(),
            r.protein.round(),
            r.carbs.round(),
            r.fat.round(),
          ),
          r.quantity,
          id: r.id,
        ),
      );
    }
    await _loadHabits();
    await _loadFasting();
    await _loadMind();
    notifyListeners();
  }

  // ---- appearance & settings (session only) ----
  ThemeMode themeMode = ThemeMode.system;
  bool autoRest = true;
  bool keepAwake = true;
  bool haptic = true;
  bool syncHealth = true;
  int restSeconds = 90;

  Duration get restDuration => Duration(seconds: restSeconds);

  /// Short vibration when [haptic] is on.
  void buzz({bool strong = false}) {
    if (!haptic) return;
    strong ? HapticFeedback.heavyImpact() : HapticFeedback.mediumImpact();
  }

  // ---- nutrition (saved) ----
  static const mealNames = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
  final Map<String, List<LoggedFood>> meals = {
    'Breakfast': [],
    'Lunch': [],
    'Dinner': [],
    'Snacks': [],
  };
  int kcalGoal = 2400;
  String macroPreset = 'Balanced';
  int proteinGoal = 180;
  int carbGoal = 240;
  int fatGoal = 80;
  int waterMl = 0;
  int waterGoalMl = 2500;

  /// Calories burned today, pushed in from the dashboard summary.
  int exerciseKcal = 0;

  static const macroPresets = <String, List<int>>{
    'Balanced': [30, 40, 30],
    'High protein': [40, 30, 30],
    'Low carb': [35, 20, 45],
  };

  double get eatenKcal =>
      meals.values.expand((e) => e).fold(0.0, (a, b) => a + b.kcal);
  double get eatenProtein =>
      meals.values.expand((e) => e).fold(0.0, (a, b) => a + b.p);
  double get eatenCarbs =>
      meals.values.expand((e) => e).fold(0.0, (a, b) => a + b.c);
  double get eatenFat =>
      meals.values.expand((e) => e).fold(0.0, (a, b) => a + b.f);
  double get remainingKcal => kcalGoal - eatenKcal + exerciseKcal;

  void setExerciseKcal(int kcal) {
    if (kcal == exerciseKcal) return;
    exerciseKcal = kcal;
    notifyListeners();
  }

  void logFood(String meal, FoodItem food, double quantity) {
    final id = _ids.generate();
    meals[meal]!.add(LoggedFood(food, quantity, id: id));
    notifyListeners();
    _data?.addFood(
      FoodLogEntriesCompanion.insert(
        id: id,
        day: _today,
        meal: meal,
        name: food.name,
        serving: food.serving,
        kcal: food.kcal.toDouble(),
        protein: food.p.toDouble(),
        carbs: food.c.toDouble(),
        fat: food.f.toDouble(),
        quantity: Value(quantity),
        createdAt: DateTime.now(),
      ),
    );
  }

  void removeFood(String meal, int index) {
    final removed = meals[meal]!.removeAt(index);
    notifyListeners();
    if (removed.id.isNotEmpty) _data?.deleteFood(removed.id);
  }

  void addWater(int ml) {
    waterMl = (waterMl + ml).clamp(0, 100000);
    notifyListeners();
    _data?.setWater(_today, waterMl);
  }

  void setWaterGoal(int ml) {
    waterGoalMl = ml.clamp(1000, 8000);
    notifyListeners();
    _data?.setSetting('water_goal_ml', '$waterGoalMl');
  }

  void setKcalGoal(int kcal, {String? preset}) {
    kcalGoal = kcal.clamp(1200, 5000);
    macroPreset = preset ?? macroPreset;
    _applyMacros();
    notifyListeners();
    _data?.setSetting('kcal_goal', '$kcalGoal');
    _data?.setSetting('macro_preset', macroPreset);
  }

  void _applyMacros() {
    final pr = macroPresets[macroPreset]!;
    proteinGoal = (kcalGoal * pr[0] / 100 / 4).round();
    carbGoal = (kcalGoal * pr[1] / 100 / 4).round();
    fatGoal = (kcalGoal * pr[2] / 100 / 9).round();
  }

  // ---- fasting ----
  bool fastOn = false;
  DateTime fastStart = DateTime.now();
  int fastHours = 16;
  String? _activeFastId;

  /// Finished fasts, newest first.
  final List<FastRecord> fastHistory = [];

  Future<void> _loadFasting() async {
    final data = _data;
    if (data == null) return;
    fastHours = int.tryParse(await data.getSetting('fast_hours') ?? '') ?? 16;
    fastOn = false;
    _activeFastId = null;
    fastHistory.clear();
    for (final r in await data.getFasts()) {
      if (r.endedAt == null) {
        // Only one fast can run; a stray older open row is closed off.
        if (_activeFastId == null) {
          fastOn = true;
          fastStart = r.startedAt;
          fastHours = r.goalHours;
          _activeFastId = r.id;
        } else {
          await data.updateFast(
            r.id,
            FastingSessionsCompanion(endedAt: Value(r.startedAt)),
          );
        }
      } else {
        fastHistory.add(FastRecord(r.id, r.startedAt, r.endedAt!, r.goalHours));
      }
    }
    await _syncFastAlert();
  }

  /// Notification id for the "fast goal reached" alert; reminders use small
  /// ids (`id * 10 + weekday`), so this can't collide.
  static const _fastAlertId = 900000;

  /// Schedules (or cancels) the alert for when the running fast hits its
  /// goal. Best effort: a missing permission just means no alert.
  Future<void> _syncFastAlert() async {
    try {
      final scheduler = getIt<ReminderScheduler>();
      final goal = fastStart.add(Duration(hours: fastHours));
      if (!fastOn || !goal.isAfter(DateTime.now())) {
        await scheduler.cancelOnce(_fastAlertId);
        return;
      }
      await scheduler.scheduleOnce(
        id: _fastAlertId,
        title: 'Fast complete',
        body: 'You\'ve reached your $fastHours hour fasting goal.',
        at: goal,
      );
    } on Object {
      // Notifications unavailable or denied.
    }
  }

  void startFast() {
    if (fastOn) return;
    fastOn = true;
    fastStart = DateTime.now();
    final id = _activeFastId = _ids.generate();
    notifyListeners();
    _syncFastAlert();
    _data?.insertFast(
      FastingSessionsCompanion.insert(
        id: id,
        startedAt: fastStart,
        goalHours: fastHours,
      ),
    );
  }

  void endFast() {
    final id = _activeFastId;
    if (!fastOn || id == null) return;
    final end = DateTime.now();
    fastHistory.insert(0, FastRecord(id, fastStart, end, fastHours));
    fastOn = false;
    _activeFastId = null;
    notifyListeners();
    _syncFastAlert();
    _data?.updateFast(id, FastingSessionsCompanion(endedAt: Value(end)));
  }

  void setFastHours(int h) {
    fastHours = h;
    notifyListeners();
    _syncFastAlert();
    _data?.setSetting('fast_hours', '$h');
    final id = _activeFastId;
    if (id != null) {
      _data?.updateFast(id, FastingSessionsCompanion(goalHours: Value(h)));
    }
  }

  /// Corrects when the current fast began (e.g. it was started late).
  void setFastStart(DateTime start) {
    final id = _activeFastId;
    if (id == null || start.isAfter(DateTime.now())) return;
    fastStart = start;
    notifyListeners();
    _syncFastAlert();
    _data?.updateFast(id, FastingSessionsCompanion(startedAt: Value(start)));
  }

  void deleteFast(FastRecord r) {
    fastHistory.remove(r);
    notifyListeners();
    _data?.deleteFast(r.id);
  }

  // ---- sleep ----
  double sleepGoalHours = 8;

  void setSleepGoal(double h) {
    sleepGoalHours = h.clamp(5, 11).toDouble();
    _data?.setSetting('sleep_goal_h', '$sleepGoalHours');
    notifyListeners();
  }

  // ---- habits (saved) ----
  final List<Habit> habits = [];

  int get habitsDone => habits.where((h) => h.today).length;

  Future<void> _loadHabits() async {
    final data = _data;
    if (data == null) return;
    final rows = await data.getHabits();
    final now = DateTime.now();
    DateTime dayAt(int offset) =>
        DateTime(now.year, now.month, now.day - offset);
    final since = _dayKey(dayAt(400));
    final done = <String, Set<String>>{};
    for (final c in await data.getCompletionsSince(since)) {
      done.putIfAbsent(c.habitId, () => {}).add(c.day);
    }
    habits
      ..clear()
      ..addAll([
        for (final r in rows)
          () {
            final days = done[r.id] ?? const <String>{};
            var streak = 0;
            while (days.contains(_dayKey(dayAt(streak + 1)))) {
              streak++;
            }
            return Habit(
              id: r.id,
              name: r.name,
              tag: r.tag,
              streak: streak,
              week: [
                for (var i = 6; i >= 1; i--) days.contains(_dayKey(dayAt(i))),
              ],
              today: days.contains(_today),
            );
          }(),
      ]);
  }

  void toggleHabit(Habit h) {
    h.today = !h.today;
    notifyListeners();
    _data?.setCompletion(h.id, _today, done: h.today);
  }

  void addHabit(String name, {String tag = 'Custom'}) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final id = _ids.generate();
    habits.add(
      Habit(
        id: id,
        name: trimmed,
        tag: tag,
        streak: 0,
        week: List.filled(6, false),
        today: false,
      ),
    );
    notifyListeners();
    _data?.addHabit(
      HabitsCompanion.insert(
        id: id,
        name: trimmed,
        tag: Value(tag),
        createdAt: DateTime.now(),
      ),
    );
  }

  void removeHabit(Habit h) {
    habits.remove(h);
    notifyListeners();
    _data?.deleteHabit(h.id);
  }

  // ---- mind ----
  /// Newest first.
  final List<MindRecord> mindLog = [];

  int get mindSecondsThisWeek {
    final since = DateTime.now().subtract(const Duration(days: 7));
    return mindLog
        .where((m) => m.startedAt.isAfter(since))
        .fold(0, (a, m) => a + m.seconds);
  }

  bool mindDoneToday(String name) {
    final now = DateTime.now();
    return mindLog.any(
      (m) =>
          m.name == name &&
          m.startedAt.year == now.year &&
          m.startedAt.month == now.month &&
          m.startedAt.day == now.day,
    );
  }

  Future<void> _loadMind() async {
    final data = _data;
    if (data == null) return;
    mindLog
      ..clear()
      ..addAll([
        for (final r in await data.getMindSessions())
          MindRecord(r.id, r.name, r.category, r.startedAt, r.seconds),
      ]);
  }

  /// Saves a session. Anything under 30 seconds is ignored.
  void logMind(String name, String category, DateTime startedAt, int seconds) {
    if (seconds < 30) return;
    final id = _ids.generate();
    mindLog.insert(0, MindRecord(id, name, category, startedAt, seconds));
    notifyListeners();
    _data?.insertMind(
      MindSessionsCompanion.insert(
        id: id,
        name: name,
        category: category,
        startedAt: startedAt,
        seconds: seconds,
      ),
    );
  }

  // ---- settings mutators (saved) ----
  void setThemeMode(ThemeMode m) {
    themeMode = m;
    notifyListeners();
    _data?.setSetting('theme_mode', m.name);
  }

  void setToggle(String key, bool on) {
    final column = switch (key) {
      'autoRest' => 'auto_rest',
      'keepAwake' => 'keep_awake',
      'haptic' => 'haptic',
      'health' => 'health_auto_sync',
      _ => null,
    };
    if (column == null) return;
    switch (key) {
      case 'autoRest':
        autoRest = on;
      case 'keepAwake':
        keepAwake = on;
      case 'haptic':
        haptic = on;
      case 'health':
        syncHealth = on;
    }
    notifyListeners();
    _data?.setSetting(column, on ? '1' : '0');
  }

  void setRestSeconds(int s) {
    restSeconds = s.clamp(15, 600);
    notifyListeners();
    _data?.setSetting('rest_seconds', '$restSeconds');
  }
}

/// Rebuilds when the [WellnessStore] changes.
class WellnessBuilder extends StatelessWidget {
  const WellnessBuilder({required this.builder, super.key});

  final Widget Function(BuildContext context, WellnessStore store) builder;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: WellnessStore.instance,
    builder: (context, _) => builder(context, WellnessStore.instance),
  );
}
