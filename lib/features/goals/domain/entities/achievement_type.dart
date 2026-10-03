enum AchievementType {
  firstWorkout('First workout', 'Complete your first workout.'),
  tenWorkouts('Getting consistent', 'Complete 10 workouts.'),
  fiftyWorkouts('Dedicated', 'Complete 50 workouts.'),
  firstTrackedActivity('On the move', 'Record your first GPS activity.'),
  distance100Km('Century', 'Cover 100 km in recorded activities.'),
  tenThousandSteps('10K day', 'Reach 10,000 steps in a day.'),
  sevenDayStreak('Streak of seven', 'Hit a daily goal 7 days in a row.'),
  weightGoalReached('Goal weight', 'Reach your target weight.');

  const AchievementType(this.title, this.description);

  final String title;
  final String description;
}
