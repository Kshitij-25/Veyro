# Fitness Trakcer: Product & Feature Specification

**Purpose of this document.** It describes everything the app can do today, screen by screen, so a designer (or a design tool) can design the UI without reading code. For every screen it lists what the user is trying to do, what data is available, which actions exist, and which states must be designed (loading, empty, error, permission denied, and so on).

**How to read it.** Sections 1–3 are global. Section 4 is the screen-by-screen spec. Section 5 explains the calculations behind the numbers. Section 6 lists things the logic supports but the current placeholder UI does not expose, which are good design opportunities. Section 7 lists what is deliberately *not* in the app right now.

> The current screens in the codebase are throwaway placeholders (plain Material lists, dialogs and text). Nothing about their layout or look is a requirement. Only the *functionality* here is fixed.

---

## 1. Product overview

A personal fitness tracker for **iPhone, Android phone, tablet and (secondarily) web**. It covers strength training, routines, daily movement, GPS runs/walks/rides, body measurements, goals and achievements.

**Principles that affect design**

- **Offline-first, no accounts.** Everything is stored on the device. There is no sign-in, no sync, no cloud profile. One person per device.
- **Fast logging matters most.** The most-used flow is logging sets during a workout, often one-handed, mid-workout, between sets. It should need as few taps as possible.
- **Metric or imperial.** The user picks once; every number in the app is shown and entered in their units (weight kg/lb, height cm/in, distance km/mi, pace min/km or min/mi). Internally everything is stored metric, so switching units never loses precision. Design for both unit labels.
- **Adaptive and responsive.** One codebase; layout changes by window width (see 2.2).
- **Light and dark themes** both exist (follow the system setting). The current brand seed colour is blue `#1E88E5`; it is not a requirement.
- **Material 3 on Android, platform-appropriate on iOS** (iOS back-swipe and Cupertino page transitions are on; dialogs use adaptive styles). Designers can choose a custom visual language, but gestures and permissions follow platform conventions.

**Who the user is.** Someone who trains regularly (gym and/or outdoors), wants a simple logbook rather than a social network, and cares about seeing progress.

---

## 2. App structure

### 2.1 Navigation map

```
Splash (loading)
Onboarding (first launch only, creates the profile)
└── Main shell: 4 tabs
    ├── Home            "Today" dashboard
    │   └── Profile & settings
    │       └── Reminders
    ├── Workouts
    │   ├── Active workout (live logging)
    │   ├── Workout detail (a finished workout)
    │   ├── Exercise library (browse, search, add custom, download more)
    │   ├── Routines
    │   │   └── Routine editor (create / edit)
    │   └── Personal records
    ├── Activity
    │   ├── Record an activity (GPS run / walk / cycle)
    │   └── Recorded activities (history)
    └── Progress        weight trend + body measurements
        ├── Goals
        └── Achievements
```

- Tab order is Home, Workouts, Activity, Progress.
- The exercise library is also used as a **picker**: when adding an exercise to a workout or routine, the library opens in "choose" mode and a tap returns the chosen exercise to the previous screen.
- Re-tapping the current tab returns to that tab's root. Switching to Home refreshes its summary.
- There is no deep linking and no separate web layout.

### 2.2 Responsive behaviour

| Window width | Class | Primary navigation | Dashboard grid |
| --- | --- | --- | --- |
| under 600 | Compact (phones) | Bottom navigation bar | 1 column |
| 600–839 | Medium (large phones, small tablets, foldables) | Navigation rail with labels | 2 columns |
| 840 and up | Expanded (tablets, desktop, web) | Extended navigation rail (icons + labels) | 3 columns |

- Most content is capped to a readable column (about 560–720 px) and centred on wide screens. A two-pane list/detail layout helper exists (for example workout history on the left and detail on the right) but is not used yet, so it is an open choice for tablet design.
- Design each screen for compact first, then say what changes on medium and expanded.

### 2.3 App-wide live state (matters for the shell design)

These keep running while the user moves around the app, so the shell may need to show them everywhere:

- **Active workout.** At most one workout can be in progress. It is saved after every edit, so it survives the app being closed or killed. A persistent "workout in progress" bar or chip with elapsed time that jumps back into the workout is a natural design.
- **Rest timer.** A countdown that starts when a set is marked complete (default 90 s). It can add 15 s or be skipped, and it emits a "finished" signal so the UI can play a sound or haptic. It is app-wide, so it can show as an overlay or banner on any screen.
- **GPS recording.** A recording continues while the user browses other tabs. It also keeps running with the screen locked (Android shows a foreground notification, iOS shows the blue background-location indicator). A global "recording" indicator is a natural design.
- **Profile and units.** Loaded at start-up; all screens read the unit system from it.

### 2.4 Standard states every screen should define

| State | Where it appears today | Design note |
| --- | --- | --- |
| Loading | all data screens | skeleton or spinner |
| Empty | lists with no data | friendly message plus a call to action; copy used today is in section 4 |
| Error | failed loads | message plus a Retry where offered |
| Inline error | failed saves and validation | shown as a snackbar today, with a plain-language message from the app |
| Destructive confirmation | discard workout | other deletes happen immediately with no confirm or undo today |
| Permission denied | notifications, location, health | explain why, offer a route to system settings |
| Web or unsupported platform | health data, notifications, GPS | feature shows a "not available here" path (see each section) |

---

## 3. Core concepts (shared vocabulary)

- **Profile**: name, date of birth (age is derived), sex (male/female/other), height, weight, activity level, fitness goal, unit system. Exactly one per device.
- **Exercise**: a movement in the library. Has a name, **muscle group**, **equipment** and a **tracking type** that decides which inputs a set has.
- **Workout**: a session with a name, start time, optional end time (no end time means in progress), optional notes, and an ordered list of exercises, each with ordered sets.
- **Set**: one effort. Inputs depend on the exercise's tracking type. Has flags *warm-up* and *completed*.
- **Routine**: a reusable template of exercises with target sets/reps (and optionally weight and rest), optionally scheduled on weekdays. Starting one creates a pre-filled workout.
- **Daily activity**: steps, distance and active calories for one calendar day, from Apple Health / Health Connect or typed in manually.
- **Recorded activity**: a GPS-tracked run, walk or ride with a route.
- **Body measurement**: a dated snapshot. Every field is optional, but at least one is required.
- **Goal**: a target of one of four types, measured automatically against the user's data.
- **Achievement**: a fixed badge unlocked automatically.
- **Reminder**: a repeating local notification.

**Fixed option lists the UI must present**

| Concept | Values |
| --- | --- |
| Muscle group (10) | Chest, Back, Shoulders, Biceps, Triceps, Legs, Glutes, Core, Full body, Cardio |
| Equipment (7) | Barbell, Dumbbell, Machine, Cable, Kettlebell, Bodyweight, Other |
| Exercise tracking type (4) | Weight and reps · Reps only · Duration · Distance and duration |
| Activity level (5) | Sedentary, Lightly active, Moderately active, Very active, Extremely active |
| Fitness goal (3) | Lose weight, Maintain weight, Build muscle |
| Sex (3) | Male, Female, Other |
| Recorded activity type (3) | Run, Walk, Cycle |
| Reminder type (3) | Workout, Weigh-in, Custom |
| Goal type (4) | Daily steps, Workouts per week, Weekly distance, Target weight |

---

## 4. Screens and functionality

Each entry lists: **Goal**, **Data shown**, **Actions**, **States and edge cases**, **Rules**.

### 4.1 Splash

- **Goal:** bridge the moment between launch and knowing whether a profile exists.
- **Shown:** a loading indicator only. Auto-navigates to Onboarding (no profile) or Home (profile exists). No actions.

### 4.2 Onboarding (first launch only)

- **Goal:** collect the profile in one go so the rest of the app can personalise itself.
- **Fields:**
  - Name (required)
  - Unit system toggle: Metric / Imperial
  - Date of birth (date picker)
  - Sex
  - Height (cm or in)
  - Weight (kg or lb)
  - Activity level
  - Fitness goal
- **Actions:** "Get started" submits.
- **Behaviour:**
  - Switching the unit toggle immediately converts what has already been typed in height and weight.
  - On submit, the profile is saved and **the entered weight is also recorded as the first body measurement**, so the weight chart starts with a point. The app then enters Home automatically.
- **Validation (plain-language errors):**
  - Name required.
  - Height 50–272 cm.
  - Weight 20–500 kg.
  - Age at least 13.
  - Date of birth not in the future.
  - Number fields must be numbers.
- **States:** submitting (button spinner), error snackbar.
- **Design note:** this is a one-screen form today; a multi-step wizard is fine. Activity level and fitness goal are stored but **currently only collected**. They were used for calorie targets, which are being re-planned, so explain them in neutral wording.

### 4.3 Home ("Today")

- **Goal:** one glance at today across the app.
- **Shown (cards, each can link to its tab):**
  - **Activity:** today's steps, distance, active kcal.
  - **Training:** workout in progress (name) if any, number of workouts completed this week, and routines planned for today's weekday.
  - **Weight:** latest weight (card only appears once a weight exists).
  - **Goals:** each active goal with current value / target (card only appears if goals exist).
- **Actions:** open Profile & settings (top-right person icon), pull to refresh, tap cards (not wired yet).
- **Behaviour:**
  - The summary reloads when the user returns to this tab and on pull-to-refresh.
  - Each reload also **checks for newly unlocked achievements**. The dashboard receives the list of just-unlocked achievements, but no UI shows them yet. A celebratory toast or sheet is a design opportunity.
- **States:** loading, error with Retry, populated.
- **Responsive:** 1, 2 or 3 card columns (section 2.2).

### 4.4 Profile & settings

- **Goal:** edit the profile and reach secondary features.
- **Shown:**
  - Entry rows: Reminders, Data sources & credits.
  - The profile form, identical to onboarding, pre-filled.
- **Actions:** Save (snackbar "Profile saved" or an error), open Reminders, open credits.
- **Credits dialog:** wger exercise data credit (CC-BY-SA 4.0), plus a link to open-source licences. Keep attribution visible somewhere in the final design; it is a licence requirement.
- **Rules:**
  - Same validation as onboarding.
  - Changing the unit system converts displayed values everywhere.
  - Editing weight here updates the profile only; it does **not** add a body measurement. Calorie estimates use the latest *body measurement* weight. A designer may want to merge these ideas (for example "update weight" always logs a measurement).
- **Not present yet:** theme toggle, data export, delete all data, notification master switch, about/version.

### 4.5 Reminders

- **Goal:** schedule repeating nudges.
- **Shown:** list of reminders: title, time, "Every day" or the selected weekdays (M T W T F S S), and an on/off switch.
- **Actions:**
  - New reminder: choose type (Workout, Weigh-in, Custom). The message defaults to the type's name and is editable. Choose time with a time picker, choose weekdays (none selected means every day), then save.
  - Toggle a reminder on/off.
  - Swipe to delete (no undo today).
  - Editing an existing reminder is **not** in the UI, but saving with an existing id supports it.
- **Behaviour:**
  - Enabling a reminder asks the OS for notification permission. If refused, the screen shows "Notifications are turned off, so reminders won't appear."
  - All schedules are rebuilt every app launch (they can be lost after a reboot or reinstall).
  - Android: reminders may fire a few minutes late. Web: reminders are stored but never fire, so show this honestly or hide the screen on web.
- **States:** loading, empty ("No reminders yet."), permission denied.

### 4.6 Workouts tab (root)

- **Goal:** start or resume a workout, and look back at history.
- **Shown:**
  - A "current workout" card. With nothing running it reads "No workout in progress" with a **Start** button. With a workout running it shows the name, a live elapsed timer and **Continue**.
  - History, newest first: name, date, duration, total volume lifted in the user's unit.
- **Actions:**
  - Start (creates an empty workout named "Workout" and opens the active workout).
  - Continue.
  - Tap a history row to open the workout detail.
  - Shortcuts to Routines, Exercises, Personal records.
- **States:** loading, error, empty ("No completed workouts yet.").
- **Missing in UI (logic exists):**
  - Delete a past workout (supported, no control yet).
  - Start from a routine directly on this screen. Today it is only available from the Routines list.
- **Design opportunities:** quick-start options (empty workout vs. a planned routine for today), a calendar or weekly strip, history grouping by week or month.

### 4.7 Active workout (the core screen)

- **Goal:** log a workout quickly while training.
- **Shown:**
  - The workout name and a live elapsed timer.
  - The rest timer banner, visible only while resting: time remaining, a progress bar, **+15s** and **Skip**.
  - An ordered list of **exercise cards**. Each card has the exercise name, a **set row** per set, **Add set**, and **Remove exercise**.
  - **Add exercise** at the bottom.
- **A set row shows inputs according to the exercise's tracking type:**

| Tracking type | Inputs |
| --- | --- |
| Weight and reps | weight (kg/lb), reps |
| Reps only | reps |
| Duration | minutes |
| Distance and duration | distance (km/mi), minutes |

  Every row also has: a set number (or **W** for a warm-up), a **completed** checkbox, and a delete-set control.
- **Actions:**
  - Add exercise: opens the library in choose mode. A new exercise starts with one empty set.
  - Add set: **pre-filled with the previous set's values** so repeating a set takes one tap.
  - Edit values: committed when the field loses focus or is submitted, so storage is not written per keystroke.
  - Mark set complete: starts the rest timer (90 s).
  - Remove a set.
  - Remove an exercise.
  - **Finish**: ends the workout and opens its detail.
  - **Discard**: asks for confirmation ("Everything logged in this workout will be lost."), then deletes it.
- **Rules:**
  - **Finish drops anything not completed:** sets that are not ticked and exercises with no completed sets are removed from the saved workout. Consider a warning such as "2 sets aren't completed and will be removed".
  - **Volume** counts only completed, non-warm-up sets (weight × reps).
  - Calories burned are estimated on finish (see 5.1).
  - Only one workout can be active.
  - Opening this screen with no workout shows "Start a workout".
- **Supported by logic but not in the UI yet:**
  - Rename the workout.
  - Workout-level notes.
  - Per-exercise notes.
  - Mark a set as warm-up (the **W** label already exists).
  - Per-exercise rest time. A routine stores a rest time per exercise, but the active screen currently uses a fixed 90 s.
  - Reordering exercises.
  - A "previous performance" hint per exercise.
- **Design notes:** this screen is used one-handed with sweaty hands, so aim for large tap targets, a numeric keypad, and a sticky rest timer. Consider showing running totals (sets done, volume).

### 4.8 Workout detail (a finished workout)

- **Goal:** review one completed workout.
- **Shown:** name, duration, total volume, calories burned, then each exercise with its sets (set number, weight, reps, distance or duration as relevant).
- **Actions:** none today. Opened automatically after Finish and from history.
- **Supported but not exposed:** edit values, delete, add notes, repeat the workout, save as a routine, share.
- **Design opportunities:** highlight sets that set a new personal record, per-exercise volume, a summary card shown right after Finish.

### 4.9 Exercise library

- **Goal:** find an exercise, create custom ones, and pick one for a workout or routine.
- **Shown:**
  - A search field.
  - Horizontal muscle-group filter chips (single-select, tap again to clear).
  - A list: optional thumbnail, name, "Muscle group · Equipment".
  - An attribution footer: "Downloaded exercises: wger.de, CC-BY-SA 4.0".
- **Modes:**
  - **Browse** (title "Exercises"): custom exercises show a delete control; tapping a row does nothing yet.
  - **Choose** (title "Choose exercise"): tapping a row returns it to the caller.
- **Actions:**
  - Search by name.
  - Filter by muscle group.
  - **New exercise:** name (required), muscle group. Equipment and tracking type are supported by logic (defaults: Other, Weight and reps) but not in the UI form. A designer should add them, since tracking type changes what a set looks like.
  - Delete a custom exercise.
  - **Download more exercises** (cloud icon): fetches roughly 900 exercises from the free wger catalogue and caches them on the device. A progress bar shows while it runs, then a message such as "Added 880 exercises." or "Your exercise library is already up to date." The app also does this automatically in the background at launch if the last download is older than 30 days. Offline failures are silent in the background.
- **Content:**
  - About 35 built-in exercises ship with the app.
  - Downloaded exercises usually have a name, muscle group, equipment, a description and an image URL.
  - Custom exercises are user-made.
  - When downloading, exercises whose names already exist in the library are skipped.
- **Data available for an exercise detail screen** (no such screen exists): name, muscle group, equipment, tracking type, description (downloaded ones), image (downloaded ones), source (built-in / custom / wger).
- **States:** loading, empty ("No exercises found."), error, syncing.

### 4.10 Personal records

- **Goal:** show best lifts.
- **Shown:** per exercise: heaviest weight lifted, estimated one-rep max (1RM), and (available, not shown today) max reps and the date achieved. Sorted A–Z.
- **Rules:** computed from completed, non-warm-up sets that have both weight and reps (see 5.2). Only weight-and-reps exercises produce records.
- **States:** loading, error with Retry, empty ("Finish a workout to set records.").
- **Design opportunities:** per-exercise progress charts, record dates, search and filter, a "new PR" celebration after finishing a workout.

### 4.11 Routines

**List.**
- **Shown:** name, number of exercises, scheduled weekdays.
- **Actions:** tap to edit, **Start workout** (creates a pre-filled workout and opens it), delete (immediate), New routine.
- **Rules:** starting a routine fails with "A workout is already in progress." if one is running.
- **States:** loading, empty ("No routines yet."), error.

**Editor (create or edit).**
- **Fields:**
  - Name (required).
  - Weekday chips M–Su, for the days it is planned.
  - An exercise list. For each exercise, target sets (minus and plus buttons, at least 1) and a remove control.
  - **Add exercise** (opens the library in choose mode).
- **Also supported but not in the UI:**
  - Target reps per exercise (default 10).
  - Target weight per exercise.
  - Rest seconds per exercise (default 90).
  - Routine notes.
  - Reordering.
- **Actions:** Save (closes on success). Errors: "Routine name is required.", "Add at least one exercise.", "Sets and reps must be at least 1."
- **Behaviour:** a routine scheduled for today's weekday appears on Home under Training as "Planned: …". Starting a routine creates sets pre-filled with the target reps (and target weight, if one is set); only the relevant fields are filled for the exercise's tracking type.

### 4.12 Activity tab (daily movement)

- **Goal:** see today's steps, distance and active calories, and the last 7 days.
- **Shown:**
  - A big card with today's steps, distance and kcal.
  - A health-connection tile whose appearance depends on state (below).
  - A 7-day list (newest first) of date and steps.
- **Actions:**
  - Pull to refresh (re-syncs health data).
  - **Track** button: opens GPS recording.
  - History icon: opens recorded activities.
  - Connect health, sync, or log manually (depending on state).
- **Health connection states**

| Status | Meaning | Tile |
| --- | --- | --- |
| Not granted | Health is available but the user has not allowed it | "Connect Health: import steps, distance and calories" |
| Granted | Connected | "Synced with Health" (tap to re-sync, spinner while syncing) |
| Unknown | iOS never reveals whether read access was granted | treated as "try it" |
| Unavailable | web, or no Health Connect | "Health data unavailable here: log today's activity manually" |

- **Data sources:** Apple Health on iOS; Health Connect on Android. On Android 13 and below the user needs the Health Connect app installed. Imported fields: **steps, distance, active energy**. The last 7 days are synced on open and refresh.
- **Manual entry** (when health is unavailable): steps and distance (calories also supported). It **sets** (replaces) that day's totals; it does not add to them. Negative values are rejected.
- **States:** loading, error snackbar.
- **Design opportunities:** weekly bar chart, goal ring for steps, day-by-day detail.

### 4.13 Record an activity (GPS)

- **Goal:** record a run, walk or ride.
- **Shown:**
  - A type selector (Run / Walk / Cycle), changeable only before starting.
  - A big elapsed timer.
  - Distance and current pace.
  - Controls that depend on the recording status (below).
- **Status and controls**

| Status | Controls |
| --- | --- |
| Idle | **Start** |
| Tracking | **Pause**, **Finish**, Discard |
| Paused | **Resume**, **Finish**, Discard |

- **Live data available** (design may show more than today's two numbers): elapsed time, distance, current pace (smoothed over the last ~20 s, empty until enough data), elevation gain, and the **list of GPS points forming the route** for drawing a live map.
- **Permission flow:** pressing Start asks for location permission. Failure messages the app produces:
  - "Location services are turned off."
  - "Location permission is permanently denied. Enable it in settings."
  - "Location permission is required."
  Design a clear recovery path for each.
- **Rules:**
  - Distance ignores poor-accuracy fixes (worse than 30 m), tiny movements under 1 m, and impossible speed jumps (over 12 m/s for run and walk, 25 m/s for cycle).
  - Pausing does not count distance travelled while paused.
  - **Finish** saves the activity, with calories estimated by speed (see 5.1). Sessions shorter than **10 seconds** are rejected: "This activity was too short to save."
  - Recording continues while the user visits other tabs and while the screen is locked.
  - After saving, the app exposes the saved activity (distance, time, pace, calories, elevation, route) so a **summary screen** can be shown. The current UI only shows an "Activity saved" snackbar.
- **Platform notes:** works on iOS and Android only. Web is unsupported; show a "not available" state.

### 4.14 Recorded activities (history)

- **Shown:** a list of recorded activities: type, distance, date, moving time, average pace, calories, and a delete control (immediate, no undo).
- **States:** loading, empty ("No recorded activities yet."), error.
- **Stored but unused:** route points, elevation gain, start and end times, average speed. There is **no detail screen yet**. A route map, elevation profile and splits are the obvious design opportunity.

### 4.15 Progress tab (body metrics)

- **Goal:** track weight and body measurements over time.
- **Shown:**
  - A summary card with current weight, the change over the selected period (for example "+1.2 kg over 90 days"), and BMI with its category (Underweight under 18.5, Normal under 25, Overweight under 30, Obese 30 and above).
  - A list of measurements: weight, body fat % and waist as available, with date, and a delete control.
- **Actions:**
  - **Log** (FAB): a dialog with weight, waist and body fat %.
  - Delete a measurement (immediate).
  - Open Goals or Achievements from the app bar.
- **Available in logic but not in UI:**
  - Chest, hips, arm and thigh measurements.
  - Notes on a measurement.
  - Choosing a date other than now.
  - Editing an existing measurement.
  - A selectable range. The summary uses 90 days, and the cubit supports changing it (30 / 90 / 365 and so on).
  - **The weight data series (date and weight, oldest first) for a line chart.** There is no chart yet; it is the main design opportunity of this tab.
- **Validation:**
  - At least one value is required: "Enter at least one measurement."
  - Weight 20–500 kg.
  - Body fat 2–70%.
  - Lengths 0–300 cm (the limits shown are in metric).
- **Rules:**
  - BMI uses the user's profile height and the latest weight in range.
  - Weight used for calorie estimates elsewhere is the latest measurement.
- **States:** loading, error (only if there is no data), empty ("No measurements yet.").

### 4.16 Goals

- **Goal:** set targets and see progress and streaks.
- **Goal types**

| Type | Period | Counts | Met when |
| --- | --- | --- | --- |
| Daily steps | Daily | steps for the day | steps ≥ target |
| Workouts per week | Weekly (Mon–Sun) | completed workouts that week | count ≥ target |
| Weekly distance | Weekly | total distance of recorded GPS activities | distance ≥ target |
| Target weight | Overall (one-off) | latest weight versus the start weight | reached from either direction |

- **Shown per goal:**
  - Type label.
  - A progress bar and fraction (0–100%).
  - "current of target" in the user's units.
  - A tick when achieved.
  - For daily and weekly goals, the current streak and best streak (days or weeks).
  - Delete control.
- **Actions:**
  - New goal: choose a type and a target in the user's units.
  - Delete (immediate).
  - Pull to refresh.
- **Rules:**
  - Only **one active goal per type**: "You already have an active goal of this type."
  - Target must be greater than zero.
  - **Target weight** stores the user's weight at creation as the starting point, so progress runs from start toward target (losing or gaining).
  - **Streak:** consecutive days (or weeks) the goal was met, ending now. The current in-progress period does not break the streak while it is unmet.
  - History looked at: 90 days for daily goals, 26 weeks for weekly goals.
  - Progress is measured automatically from steps, completed workouts, GPS distance and weight, so there is no manual check-in.
- **Supported but not in UI:** an optional deadline, editing a goal, deactivating without deleting.
- **States:** loading, error with Retry, empty ("Set a goal to get started.").

### 4.17 Achievements

- **Goal:** motivation.
- **Shown:** all 8 achievements, locked or unlocked, with an unlock date for unlocked ones.

| Achievement | Description |
| --- | --- |
| First workout | Complete your first workout. |
| Getting consistent | Complete 10 workouts. |
| Dedicated | Complete 50 workouts. |
| On the move | Record your first GPS activity. |
| Century | Cover 100 km in recorded activities. |
| 10K day | Reach 10,000 steps in a day. |
| Streak of seven | Hit a daily goal 7 days in a row. |
| Goal weight | Reach your target weight. |

- **Rules:** unlocks are evaluated when Home loads and when this screen opens. Once unlocked they stay unlocked. There is no progress-toward-unlock data; it is locked or unlocked only.
- **Design opportunities:** badge artwork, a celebratory moment on unlock (the data is available at the moment it happens).

---

## 5. Calculations behind the numbers

### 5.1 Calories burned (estimates, not measurements)

- **Formula:** kcal = MET × body weight (kg) × duration (hours). MET is a standard activity-intensity value.
- **Weight used:** the latest body-measurement weight; if none exists, **70 kg**.
- **Strength workouts:** MET 5.0 for the whole session duration, which is a rough average and not a per-exercise calculation.
- **GPS activities:** MET depends on the *average speed*:

| Activity | Speed (km/h) | MET |
| --- | --- | --- |
| Walk | under 4 / 4–5.5 / over 5.5 | 2.8 / 3.5 / 4.3 |
| Run | under 8 / 8–10 / 10–12 / over 12 | 8.3 / 9.8 / 11.0 / 12.5 |
| Cycle | under 16 / 16–20 / 20–25 / over 25 | 6.8 / 8.0 / 10.0 / 12.0 |

- Label these as **estimates** in the UI.

### 5.2 Strength numbers

- **Set volume** = weight × reps, completed non-warm-up sets only. Workout volume is the sum over all sets.
- **Estimated one-rep max** uses the Epley formula: weight × (1 + reps ÷ 30); with one rep or fewer it equals the weight.
- **Personal record** per exercise = the highest weight, highest reps and highest estimated 1RM seen across all completed working sets in history.

### 5.3 Pace and distance

- **Pace** is shown as `m:ss` per km or per mile (according to units); a dash placeholder appears when unknown.
- **Average speed** is available in km/h.
- Distance, elevation gain and moving time come from filtered GPS points (see 4.13).

### 5.4 Units

- Weight: kg ↔ lb. Length: cm ↔ in. Distance: km ↔ mi (stored in metres). Only the unit labels and number formatting change per user preference.

---

## 6. Capabilities the logic supports but the UI does not expose

Good places to add design value without any new backend work:

| Area | Already supported |
| --- | --- |
| Charts | weight series (Progress); steps for 7 days (Activity); goal fractions; per-exercise history is derivable |
| Maps | the full GPS route (points with altitude and accuracy) of every recorded activity |
| Active workout | rename, workout notes, exercise notes, warm-up sets, adding sets pre-filled, per-exercise rest times |
| Workout history | delete, edit, notes |
| Routines | target reps, target weight, rest seconds, notes, day scheduling |
| Exercises | description, image, equipment and tracking type on custom exercises |
| Body metrics | chest, hips, arm, thigh, notes, custom date, edit, selectable chart range |
| Goals | deadline, edit |
| Reminders | edit an existing reminder |
| Achievements | the just-unlocked list at the moment of unlock |
| Layout | a two-pane list/detail helper for tablets |

---

## 7. Not in the app right now

- **Nutrition: food diary, calories eaten, water, barcode scanning, photo meal logging.** This was built and then removed on purpose while it is re-planned. **Do not design it yet**, but leave room: the Home screen, tab bar and Goals may get nutrition back later.
- Calorie and macro *targets* (profile data that would feed them is still collected).
- Social features, sharing, leaderboards, friends.
- Accounts, cloud sync, backup/restore, data export.
- Wearable-specific features beyond what Health Connect / Apple Health provide.
- Video, audio coaching, workout plans or programs from a coach.
- Paid tiers, ads, in-app purchases.
- Localisation (English only for now); the date and time formats follow the device settings.

---

## 8. Suggested deliverables from design

1. Design system: colour (light and dark), type, spacing, components for set rows, cards, charts, empty states, dialogs and bottom sheets.
2. Compact (phone) designs for every screen in section 4, including the states in 2.4.
3. Medium and expanded variants for the shell, Home, the Workouts tab, Activity and Progress (rail navigation, multi-column Home, optional list/detail).
4. The three high-frequency flows in detail: **log a workout**, **record a GPS activity**, **log a weigh-in**.
5. Moments of delight: finishing a workout (summary and PRs), saving an activity (summary and map), unlocking an achievement.
6. Permission and edge-case screens: notifications, location, health, web fallback.
