/// One timed step of a guided session.
class MindStep {
  const MindStep(this.title, this.cue, this.seconds);

  final String title;
  final String cue;
  final int seconds;
}

class MindSessionPlan {
  const MindSessionPlan(this.name, this.category, this.steps);

  final String name;
  final String category;
  final List<MindStep> steps;

  int get totalSeconds => steps.fold(0, (a, s) => a + s.seconds);
  int get minutes => (totalSeconds / 60).round();
}

/// Guided sessions with written cues and a timer per step; no audio.
const mindSessions = <MindSessionPlan>[
  MindSessionPlan('Morning mobility', 'Mobility', [
    MindStep(
      'Neck circles',
      'Slow circles, five each way. Keep shoulders down.',
      45,
    ),
    MindStep(
      'Shoulder rolls',
      'Roll back, then forward. Big, smooth circles.',
      45,
    ),
    MindStep(
      'Cat-cow',
      'On hands and knees, arch and round your spine with your breath.',
      60,
    ),
    MindStep(
      'Hip circles',
      'Standing, draw wide circles with your hips. Switch direction halfway.',
      60,
    ),
    MindStep(
      'World\'s greatest stretch',
      'Deep lunge, rotate your chest to the front knee. Switch sides halfway.',
      90,
    ),
    MindStep(
      'Deep squat hold',
      'Sink into a deep squat, elbows pushing knees out. Stay tall.',
      60,
    ),
    MindStep(
      'Reach and fold',
      'Reach overhead, then fold forward and let your head hang.',
      60,
    ),
  ]),
  MindSessionPlan('Post-run stretch', 'Mobility', [
    MindStep(
      'Calf stretch',
      'Heel down, leg straight, lean into a wall. Switch halfway.',
      60,
    ),
    MindStep(
      'Quad stretch',
      'Pull your heel to your glute, knees together. Switch halfway.',
      60,
    ),
    MindStep(
      'Hamstring stretch',
      'Heel forward, hinge at the hips with a flat back. Switch halfway.',
      60,
    ),
    MindStep(
      'Hip flexor lunge',
      'Kneel, tuck your pelvis and shift forward. Switch halfway.',
      60,
    ),
    MindStep(
      'Figure-four glute stretch',
      'On your back, ankle over opposite knee, pull gently. Switch halfway.',
      60,
    ),
    MindStep(
      'Child\'s pose',
      'Sit back on your heels, arms long, breathe into your back.',
      60,
    ),
  ]),
  MindSessionPlan('Guided meditation', 'Mindfulness', [
    MindStep(
      'Settle in',
      'Sit comfortably, close your eyes and let your shoulders drop.',
      60,
    ),
    MindStep(
      'Follow the breath',
      'Notice the breath at your nose or belly. Do not change it.',
      180,
    ),
    MindStep(
      'When the mind wanders',
      'It will. Notice, then gently return to the breath. No judging.',
      180,
    ),
    MindStep(
      'Widen the focus',
      'Include sounds and the feeling of your body in the room.',
      120,
    ),
    MindStep(
      'Close',
      'Take a deeper breath, wiggle your fingers and open your eyes.',
      60,
    ),
  ]),
  MindSessionPlan('Body scan', 'Mindfulness', [
    MindStep(
      'Arrive',
      'Lie down, close your eyes and take three slow breaths.',
      90,
    ),
    MindStep(
      'Feet and legs',
      'Bring attention to your feet, calves and thighs. Let them soften.',
      150,
    ),
    MindStep(
      'Hips and belly',
      'Notice your hips, lower back and belly rising and falling.',
      150,
    ),
    MindStep(
      'Chest and back',
      'Feel your ribs move as you breathe. Release any tightness.',
      150,
    ),
    MindStep(
      'Arms and hands',
      'Scan from the shoulders down to your fingertips.',
      150,
    ),
    MindStep(
      'Neck and face',
      'Unclench your jaw, soften your eyes and forehead.',
      150,
    ),
    MindStep(
      'Whole body',
      'Feel your body as one. Rest here for a moment.',
      60,
    ),
  ]),
  MindSessionPlan('Foam rolling', 'Recovery', [
    MindStep(
      'Calves',
      'Roll slowly from ankle to knee. Pause on tender spots. Switch halfway.',
      90,
    ),
    MindStep('Quads', 'Face down, roll from hip to knee. Switch halfway.', 90),
    MindStep(
      'Hamstrings',
      'Seated on the roller, roll from glute to knee. Switch halfway.',
      90,
    ),
    MindStep(
      'Glutes',
      'Cross one ankle over the opposite knee and lean into the roller. Switch halfway.',
      90,
    ),
    MindStep(
      'Upper back',
      'Arms crossed, roll from mid-back to shoulder blades.',
      90,
    ),
    MindStep(
      'Lats',
      'On your side, roll just below the armpit. Switch halfway.',
      90,
    ),
  ]),
  MindSessionPlan('Sleep wind-down', 'Sleep', [
    MindStep(
      'Slow your breathing',
      'Lie down. Breathe in for four, out for six.',
      180,
    ),
    MindStep(
      'Release your face',
      'Soften your forehead, eyes, tongue and jaw.',
      120,
    ),
    MindStep(
      'Heavy limbs',
      'Let your arms and legs feel heavy, sinking into the bed.',
      180,
    ),
    MindStep(
      'Let thoughts pass',
      'Picture each thought as a cloud drifting by. Do not follow it.',
      180,
    ),
    MindStep(
      'Drift',
      'No more instructions. Keep breathing slowly and let sleep come.',
      60,
    ),
  ]),
];
