import 'package:file_picker/file_picker.dart';
import 'package:fitness_trakcer/core/di/injection.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fitness_trakcer/features/data_management/domain/usecases/data_management_use_cases.dart';
import 'package:fitness_trakcer/features/health_sync/presentation/cubit/health_sync_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/profile_state.dart';
import 'package:fitness_trakcer/features/profile/presentation/widgets/profile_form.dart';
import 'package:fitness_trakcer/features/reminders/domain/usecases/reschedule_all_reminders.dart';
import 'package:fitness_trakcer/features/wellness/data/datasources/wellness_local_data_source.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

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
                            context.watch<HealthSyncCubit>().state.isConnected
                                ? 'Health connected'
                                : 'Not connected',
                            () => context.go(AppRoutes.devices),
                          ),
                          (
                            'Permissions',
                            'Health, notifications, location, camera',
                            () => context.go(AppRoutes.permissionsSettings),
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
                          ('Export my data', '', () => _export(context)),
                          ('Restore from backup', '', () => _restore(context)),
                          ('Delete all data', '', () => _deleteAll(context)),
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

  void _toast(BuildContext context, String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));

  Future<void> _export(BuildContext context) async {
    if (kIsWeb) {
      _toast(context, 'Export works in the iOS and Android apps.');
      return;
    }
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;
    final result = await getIt<ExportAllData>()(const NoParams());
    if (!context.mounted) return;
    final path = result.dataOrNull;
    if (path == null) {
      _toast(context, 'Couldn\'t create the export. Try again.');
      return;
    }
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(path)],
        subject: 'Veyro data export',
        sharePositionOrigin: origin,
      ),
    );
  }

  Future<void> _restore(BuildContext context) async {
    if (kIsWeb) {
      _toast(context, 'Restore works in the iOS and Android apps.');
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore from backup?'),
        content: const Text(
          'Pick a file made with "Export my data". Restoring replaces '
          'everything currently in the app with the contents of the file. '
          'Progress photos are not part of a backup.\n\nTip: export your '
          'current data first.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Choose file'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final picked = await FilePicker.pickFiles();
    final path = picked.isEmpty ? null : picked.first.path;
    if (path == null || !context.mounted) return;
    final dashboard = context.read<DashboardCubit>();
    final result = await getIt<RestoreAllData>()(path);
    if (!context.mounted) return;
    final failure = result.failureOrNull;
    if (failure != null) {
      _toast(
        context,
        failure is ValidationFailure
            ? failure.message
            : 'Couldn\'t restore that file. Nothing was changed.',
      );
      return;
    }
    await WellnessStore.instance.init(getIt<WellnessLocalDataSource>());
    await getIt<RescheduleAllReminders>()(const NoParams());
    await dashboard.load();
    if (context.mounted) _toast(context, 'Backup restored.');
  }

  Future<void> _deleteAll(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const _DeleteAllDialog(),
    );
    if (confirmed != true || !context.mounted) return;
    final dashboard = context.read<DashboardCubit>();
    final result = await getIt<DeleteAllData>()(const NoParams());
    if (!context.mounted) return;
    if (result.isFailure) {
      _toast(context, 'Couldn\'t delete everything. Nothing may have changed.');
      return;
    }
    // Reload what is held in memory; the profile stream sends you back to
    // onboarding on its own.
    await WellnessStore.instance.init(getIt<WellnessLocalDataSource>());
    await dashboard.load();
  }

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

/// Asks the user to type DELETE before everything is erased.
class _DeleteAllDialog extends StatefulWidget {
  const _DeleteAllDialog();

  @override
  State<_DeleteAllDialog> createState() => _DeleteAllDialogState();
}

class _DeleteAllDialogState extends State<_DeleteAllDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final armed = _controller.text.trim().toUpperCase() == 'DELETE';
    return AlertDialog(
      title: const Text('Delete all data?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This permanently erases your profile, workouts, routines, goals, body measurements, food, water, habits, fasts, sleep goal, mind sessions, progress photos, reminders and settings from this device. It can\'t be undone.\n\nData in Apple Health or Health Connect is not touched, and may sync back in if Health is connected.\n\nTip: export your data first.',
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              hintText: 'Type DELETE to confirm',
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: armed ? () => Navigator.pop(context, true) : null,
          child: Text(
            'Delete everything',
            style: TextStyle(color: armed ? VeyroColors.danger : null),
          ),
        ),
      ],
    );
  }
}
