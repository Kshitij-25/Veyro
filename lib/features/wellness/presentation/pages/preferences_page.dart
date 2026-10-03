import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// App preferences: appearance, units and workout/notification toggles.
class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final units = context.unitSystem;
    return WellnessBuilder(
      builder: (context, store) => VSubPage(
        title: 'Settings',
        maxWidth: 560,
        children: [
          VCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const VLabel('Appearance'),
                const SizedBox(height: 10),
                VSegmented<ThemeMode>(
                  options: const {
                    ThemeMode.system: 'System',
                    ThemeMode.light: 'Light',
                    ThemeMode.dark: 'Dark',
                  },
                  selected: store.themeMode,
                  height: 34,
                  onChanged: store.setThemeMode,
                ),
                const SizedBox(height: 14),
                const VLabel('Units'),
                const SizedBox(height: 10),
                VSegmented<UnitSystem>(
                  options: const {
                    UnitSystem.metric: 'Metric',
                    UnitSystem.imperial: 'Imperial',
                  },
                  selected: units,
                  height: 34,
                  onChanged: (u) => _setUnits(context, u),
                ),
              ],
            ),
          ),
          VCard(
            child: Column(
              children: [
                for (final t in [
                  (
                    'autoRest',
                    'Auto-start rest timer',
                    'After completing a set',
                    store.autoRest,
                  ),
                  (
                    'keepAwake',
                    'Keep screen on',
                    'During workouts and recordings',
                    store.keepAwake,
                  ),
                  (
                    'haptic',
                    'Haptics',
                    'Vibrate when a set is completed',
                    store.haptic,
                  ),
                  (
                    'health',
                    'Auto-sync Health',
                    'On launch and when you return to the app',
                    store.syncHealth,
                  ),
                ])
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: VToggleRow(
                      title: t.$2,
                      subtitle: t.$3,
                      value: t.$4,
                      onChanged: (on) => store.setToggle(t.$1, on),
                    ),
                  ),
              ],
            ),
          ),
          VCard(
            child: VStepper(
              label: 'Default rest (s)',
              value: '${store.restSeconds}',
              onMinus: () => store.setRestSeconds(store.restSeconds - 15),
              onPlus: () => store.setRestSeconds(store.restSeconds + 15),
            ),
          ),
          Text(
            'Saved on this device. For a Sunday summary, add a reminder under Reminders.',
            textAlign: TextAlign.center,
            style: VeyroText.body(12, color: context.veyro.mute),
          ),
        ],
      ),
    );
  }

  Future<void> _setUnits(BuildContext context, UnitSystem next) async {
    final cubit = context.read<ProfileCubit>();
    final profile = cubit.state.profile;
    if (profile == null || profile.unitSystem == next) return;
    await cubit.saveProfile(
      profile.copyWith(unitSystem: next, updatedAt: DateTime.now()),
    );
  }
}
