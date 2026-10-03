import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/profile_state.dart';
import 'package:fitness_trakcer/features/profile/presentation/widgets/profile_form.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listenWhen: (previous, current) =>
              previous.isSaving && !current.isSaving,
          listener: (context, state) => ScaffoldMessenger.of(context)
              .showSnackBar(
                SnackBar(
                  content: Text(state.failure?.message ?? 'Profile saved'),
                ),
              ),
          builder: (context, state) {
            final profile = state.profile;
            if (profile == null) return const LoadingView();
            final v = context.veyro;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ContentConstraint(
                maxWidth: 900,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        VBackButton(
                          onPressed: () => context.go(AppRoutes.home),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const VTitle('Profile', size: 46),
                    const SizedBox(height: 12),
                    WellnessBuilder(
                      builder: (context, store) {
                        final links = <(String, String, VoidCallback)>[
                          (
                            'Settings',
                            '',
                            () => context.go(AppRoutes.preferences),
                          ),
                          (
                            'Devices & integrations',
                            '${store.devices.values.where((d) => d).length} connected',
                            () => context.go(AppRoutes.devices),
                          ),
                          (
                            'Nutrition targets',
                            '${thousands(store.kcalGoal)} kcal',
                            () => context.go(AppRoutes.nutritionTargets),
                          ),
                          (
                            'Habits & supplements',
                            '${store.habitsDone} of ${store.habits.length} today',
                            () => context.go(AppRoutes.habits),
                          ),
                          (
                            'Veyro Pro',
                            'Upgrade',
                            () => context.go(AppRoutes.pro),
                          ),
                          (
                            'Export my data',
                            '',
                            () => _notReady(
                              context,
                              'Export isn\'t available in this build.',
                            ),
                          ),
                          (
                            'Delete all data',
                            '',
                            () => _notReady(
                              context,
                              'Nothing was deleted. Wiping data isn\'t available in this build.',
                            ),
                          ),
                        ];
                        return VCard(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  'Reminders',
                                  style: VeyroText.body(
                                    16,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: v.mute,
                                ),
                                onTap: () => context.go(AppRoutes.reminders),
                              ),
                              for (final l in links) ...[
                                const Divider(),
                                ListTile(
                                  title: Text(
                                    l.$1,
                                    style: VeyroText.body(
                                      16,
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (l.$2.isNotEmpty)
                                        Text(
                                          l.$2,
                                          style: VeyroText.body(
                                            13,
                                            color: v.mute,
                                          ),
                                        ),
                                      Icon(Icons.chevron_right, color: v.mute),
                                    ],
                                  ),
                                  onTap: l.$3,
                                ),
                              ],
                              const Divider(),
                              ListTile(
                                title: Text(
                                  'Data sources & credits',
                                  style: VeyroText.body(
                                    16,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  'wger.de · CC-BY-SA 4.0',
                                  style: VeyroText.body(12.5, color: v.mute),
                                ),
                                onTap: () => _showCredits(context),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    ProfileForm(
                      initial: profile,
                      submitLabel: 'Save',
                      isSubmitting: state.isSaving,
                      onSubmit: context.read<ProfileCubit>().saveProfile,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Everything stays on this device. No account.',
                      textAlign: TextAlign.center,
                      style: VeyroText.body(12, color: v.mute),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _notReady(BuildContext context, String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));

  void _showCredits(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data sources & credits'),
        content: const SingleChildScrollView(
          child: Text(
            'Exercises: some exercises, descriptions and images come from '
            'wger (https://wger.de), licensed under CC-BY-SA 4.0. Individual '
            'authors are credited in the wger catalogue.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () => showLicensePage(context: context),
            child: const Text('Open-source licences'),
          ),
        ],
      ),
    );
  }
}
