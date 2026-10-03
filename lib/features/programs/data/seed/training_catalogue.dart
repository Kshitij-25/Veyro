import 'package:fitness_trakcer/features/programs/domain/entities/training_plan.dart';

PlanExercise _x(String id, int sets, int target) =>
    PlanExercise('builtin_$id', sets, target);

/// Programs built only from the built-in exercise library. The app does not
/// adjust weights between weeks; you choose the load each session.
final List<TrainingProgram> trainingPrograms = [
  TrainingProgram(
    id: 'strength_foundations',
    name: 'Strength Foundations',
    weeks: 8,
    level: 'Beginner',
    blurb: 'Full-body barbell basics, three sessions a week.',
    days: [
      PlanDay('Full body A', [
        _x('squat', 3, 5),
        _x('bench_press', 3, 5),
        _x('barbell_row', 3, 5),
      ]),
      PlanDay('Full body B', [
        _x('squat', 3, 5),
        _x('overhead_press', 3, 5),
        _x('deadlift', 1, 5),
      ]),
      PlanDay('Full body C', [
        _x('squat', 3, 5),
        _x('bench_press', 3, 5),
        _x('pull_up', 3, 6),
      ]),
    ],
  ),
  TrainingProgram(
    id: 'ppl_hypertrophy',
    name: 'PPL Hypertrophy',
    weeks: 12,
    level: 'Intermediate',
    blurb: 'Push, pull and legs, each twice a week.',
    days: [
      PlanDay('Push', [
        _x('bench_press', 4, 8),
        _x('overhead_press', 3, 10),
        _x('incline_db_press', 3, 10),
        _x('lateral_raise', 3, 15),
        _x('tricep_pushdown', 3, 12),
      ]),
      PlanDay('Pull', [
        _x('barbell_row', 4, 8),
        _x('lat_pulldown', 3, 10),
        _x('seated_row', 3, 12),
        _x('face_pull', 3, 15),
        _x('barbell_curl', 3, 12),
      ]),
      PlanDay('Legs', [
        _x('squat', 4, 8),
        _x('romanian_deadlift', 3, 10),
        _x('leg_press', 3, 12),
        _x('leg_curl', 3, 12),
        _x('calf_raise', 4, 15),
      ]),
      PlanDay('Push', [
        _x('overhead_press', 4, 8),
        _x('incline_db_press', 4, 10),
        _x('chest_fly', 3, 12),
        _x('lateral_raise', 4, 15),
        _x('skull_crusher', 3, 12),
      ]),
      PlanDay('Pull', [
        _x('deadlift', 3, 5),
        _x('pull_up', 4, 8),
        _x('seated_row', 3, 10),
        _x('hammer_curl', 3, 12),
        _x('face_pull', 3, 15),
      ]),
      PlanDay('Legs', [
        _x('front_squat', 4, 8),
        _x('hip_thrust', 3, 10),
        _x('lunge', 3, 12),
        _x('leg_extension', 3, 15),
        _x('calf_raise', 4, 15),
      ]),
    ],
  ),
  TrainingProgram(
    id: 'five_k_builder',
    name: '5K Builder',
    weeks: 8,
    level: 'Beginner',
    blurb: 'Three runs a week: easy, intervals and a long run.',
    days: [
      PlanDay('Easy run', [_x('running', 1, 0)]),
      PlanDay('Intervals', [_x('running', 6, 0)]),
      PlanDay('Long run', [_x('running', 1, 0)]),
    ],
  ),
  TrainingProgram(
    id: 'home_hiit',
    name: 'Home HIIT Shred',
    weeks: 4,
    level: 'All levels',
    blurb: 'Bodyweight circuits, five days a week.',
    days: [
      PlanDay('Burn', [
        _x('burpee', 4, 12),
        _x('push_up', 4, 15),
        _x('russian_twist', 4, 20),
        _x('plank', 3, 45),
      ]),
      PlanDay('Jump', [
        _x('jump_rope', 5, 60),
        _x('burpee', 4, 10),
        _x('crunch', 4, 20),
      ]),
      PlanDay('Core', [
        _x('plank', 4, 60),
        _x('hanging_leg_raise', 3, 10),
        _x('russian_twist', 4, 24),
        _x('crunch', 3, 25),
      ]),
      PlanDay('Push & sweat', [
        _x('push_up', 5, 15),
        _x('dip', 4, 10),
        _x('burpee', 4, 12),
        _x('jump_rope', 3, 60),
      ]),
      PlanDay('Finisher', [
        _x('burpee', 5, 15),
        _x('push_up', 3, 20),
        _x('plank', 3, 60),
        _x('russian_twist', 3, 30),
      ]),
    ],
  ),
];

final List<QuickSession> quickSessions = [
  QuickSession(
    id: 'full_body_burn',
    name: 'Full Body Burn',
    category: 'HIIT',
    minutes: 30,
    level: 'Intermediate',
    exercises: [
      _x('burpee', 4, 12),
      _x('kettlebell_swing', 4, 15),
      _x('push_up', 4, 15),
      _x('jump_rope', 4, 60),
    ],
  ),
  QuickSession(
    id: 'upper_body_strength',
    name: 'Upper Body Strength',
    category: 'Strength',
    minutes: 45,
    level: 'Intermediate',
    exercises: [
      _x('bench_press', 4, 6),
      _x('barbell_row', 4, 8),
      _x('overhead_press', 3, 8),
      _x('pull_up', 3, 8),
      _x('barbell_curl', 3, 12),
    ],
  ),
  QuickSession(
    id: 'core_express',
    name: 'Core Express',
    category: 'Core',
    minutes: 12,
    level: 'All levels',
    exercises: [
      _x('plank', 3, 45),
      _x('crunch', 3, 20),
      _x('russian_twist', 3, 20),
    ],
  ),
  QuickSession(
    id: 'leg_day_builder',
    name: 'Leg Day Builder',
    category: 'Strength',
    minutes: 50,
    level: 'Advanced',
    exercises: [
      _x('squat', 5, 5),
      _x('romanian_deadlift', 4, 8),
      _x('leg_press', 3, 12),
      _x('leg_curl', 3, 12),
      _x('calf_raise', 4, 15),
    ],
  ),
  QuickSession(
    id: 'tempo_run',
    name: 'Tempo Run',
    category: 'Cardio',
    minutes: 35,
    level: 'Intermediate',
    exercises: [_x('running', 1, 0)],
  ),
  QuickSession(
    id: 'low_impact_cardio',
    name: 'Low Impact Cardio',
    category: 'Cardio',
    minutes: 25,
    level: 'Beginner',
    exercises: [_x('cycling', 1, 0), _x('rowing', 1, 0)],
  ),
];
