import 'package:drift/drift.dart' show Value;
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/core/utils/id_generator.dart';
import 'package:fitness_trakcer/features/wellness/data/datasources/wellness_local_data_source.dart';
import 'package:flutter/material.dart';

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

class Recipe {
  const Recipe(this.name, this.kcal, this.minutes, this.protein, this.tags);

  final String name;
  final int kcal;
  final int minutes;
  final int protein;
  final List<String> tags;
}

class Program {
  const Program(
    this.name,
    this.weeks,
    this.daysPerWeek,
    this.level,
    this.blurb,
  );

  final String name;
  final int weeks;
  final int daysPerWeek;
  final String level;
  final String blurb;
}

class ProgressCheckIn {
  const ProgressCheckIn(this.date, this.kg);

  final String date;
  final double kg;
}

/// Shared state for the wellness screens.
///
/// Saved in the database: water, the food diary, calorie/macro/water targets
/// and habits. Session-only (reset on restart): fasting, sleep goal, photos,
/// programs, mind sessions, devices, community and the Settings toggles.
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
    notifyListeners();
  }

  // ---- appearance & settings (session only) ----
  ThemeMode themeMode = ThemeMode.system;
  bool autoRest = true;
  bool keepAwake = true;
  bool sound = true;
  bool haptic = true;
  bool weeklyReport = true;
  bool shareActivity = true;
  bool syncHealth = true;
  int restSeconds = 90;

  // ---- nutrition (saved) ----
  static const mealNames = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
  static const foods = <FoodItem>[
    FoodItem('Oatmeal with banana', '1 bowl', 310, 9, 58, 6),
    FoodItem('Whey protein shake', '1 scoop', 130, 25, 3, 2),
    FoodItem('Grilled chicken rice bowl', '1 bowl', 640, 52, 68, 14),
    FoodItem('Greek yogurt', '170 g', 100, 17, 6, 0),
    FoodItem('Scrambled eggs', '2 eggs', 180, 12, 2, 14),
    FoodItem('Banana', '1 medium', 105, 1, 27, 0),
    FoodItem('Almonds', '28 g', 165, 6, 6, 14),
    FoodItem('Salmon fillet', '150 g', 310, 34, 0, 18),
    FoodItem('Brown rice', '1 cup', 215, 5, 45, 2),
    FoodItem('Avocado toast', '1 slice', 280, 7, 30, 15),
    FoodItem('Peanut butter', '2 tbsp', 190, 7, 7, 16),
    FoodItem('Protein bar', '1 bar', 210, 20, 22, 7),
    FoodItem('Cottage cheese', '1 cup', 180, 24, 8, 5),
    FoodItem('Sweet potato', '1 medium', 115, 2, 27, 0),
    FoodItem('Turkey sandwich', '1 sandwich', 420, 32, 42, 12),
    FoodItem('Apple', '1 medium', 95, 0, 25, 0),
  ];
  static const recipes = <Recipe>[
    Recipe('Chicken Burrito Bowl', 520, 25, 46, ['High protein']),
    Recipe('Overnight Oats', 340, 5, 14, ['Quick', 'Vegetarian']),
    Recipe('Salmon & Greens', 480, 20, 38, ['High protein', 'Quick']),
    Recipe('Lentil Curry', 430, 35, 21, ['Vegetarian']),
    Recipe('Egg White Wrap', 290, 10, 28, ['High protein', 'Quick']),
    Recipe('Tofu Stir Fry', 390, 20, 24, ['Vegetarian', 'Quick']),
  ];

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
  final Set<String> savedRecipes = {};

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

  void toggleRecipe(String name) {
    savedRecipes.contains(name)
        ? savedRecipes.remove(name)
        : savedRecipes.add(name);
    notifyListeners();
  }

  // ---- fasting ----
  bool fastOn = true;
  DateTime fastStart = DateTime.now().subtract(
    const Duration(minutes: (13 * 60) + 12),
  );
  int fastHours = 16;

  void toggleFast() {
    fastOn = !fastOn;
    fastStart = DateTime.now();
    notifyListeners();
  }

  void setFastHours(int h) {
    fastHours = h;
    notifyListeners();
  }

  // ---- sleep ----
  double sleepGoalHours = 8;
  bool windDown = true;

  void setSleepGoal(double h) {
    sleepGoalHours = h.clamp(5, 11);
    notifyListeners();
  }

  void setWindDown(bool on) {
    windDown = on;
    notifyListeners();
  }

  // ---- photos ----
  final List<ProgressCheckIn> checkIns = [
    const ProgressCheckIn('Oct 1', 80.1),
    const ProgressCheckIn('Sep 1', 82.4),
    const ProgressCheckIn('Aug 1', 84.5),
  ];

  void addCheckIn(double kg) {
    if (checkIns.any((c) => c.date == 'Oct 3')) return;
    checkIns.insert(0, ProgressCheckIn('Oct 3', kg));
    notifyListeners();
  }

  // ---- programs ----
  static const programs = <Program>[
    Program(
      'Strength Foundations',
      8,
      3,
      'Beginner',
      'Full-body barbell basics with linear progression.',
    ),
    Program(
      'PPL Hypertrophy',
      12,
      6,
      'Intermediate',
      'Push, pull and legs, each twice a week.',
    ),
    Program(
      '5K Builder',
      8,
      3,
      'Beginner',
      'Run-walk intervals building to a continuous 5K.',
    ),
    Program(
      'Home HIIT Shred',
      4,
      5,
      'All levels',
      'Bodyweight circuits, 25 minutes a day.',
    ),
  ];
  int? programIndex = 0;
  int programWeek = 3;

  void toggleProgram(int i) {
    if (programIndex == i) {
      programIndex = null;
    } else {
      programIndex = i;
      programWeek = 1;
    }
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
  final Set<String> mindDone = {};

  void toggleMind(String name) {
    mindDone.contains(name) ? mindDone.remove(name) : mindDone.add(name);
    notifyListeners();
  }

  // ---- devices & plan ----
  final Map<String, bool> devices = {
    'health': true,
    'watch': true,
    'garmin': false,
    'strava': true,
    'whoop': false,
    'oura': false,
    'fitbit': false,
    'spotify': true,
  };
  String plan = 'Yearly';

  void toggleDevice(String key) {
    devices[key] = !(devices[key] ?? false);
    notifyListeners();
  }

  void setPlan(String p) {
    plan = p;
    notifyListeners();
  }

  // ---- community ----
  final Set<int> kudos = {};
  final Set<int> joined = {1};

  void toggleKudos(int id) {
    kudos.contains(id) ? kudos.remove(id) : kudos.add(id);
    notifyListeners();
  }

  void toggleJoined(int id) {
    joined.contains(id) ? joined.remove(id) : joined.add(id);
    notifyListeners();
  }

  // ---- settings mutators ----
  void setThemeMode(ThemeMode m) {
    themeMode = m;
    notifyListeners();
  }

  void setToggle(String key, bool on) {
    switch (key) {
      case 'autoRest':
        autoRest = on;
      case 'keepAwake':
        keepAwake = on;
      case 'sound':
        sound = on;
      case 'haptic':
        haptic = on;
      case 'weekly':
        weeklyReport = on;
      case 'pub':
        shareActivity = on;
      case 'health':
        syncHealth = on;
    }
    notifyListeners();
  }

  void setRestSeconds(int s) {
    restSeconds = s.clamp(15, 600);
    notifyListeners();
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
