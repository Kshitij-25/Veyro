import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/profile_state.dart';
import 'package:fitness_trakcer/features/profile/presentation/widgets/profile_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & settings')),
      body: BlocConsumer<ProfileCubit, ProfileState>(
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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ContentConstraint(
              maxWidth: 560,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.notifications_outlined),
                    title: const Text('Reminders'),
                    onTap: () => context.go(AppRoutes.reminders),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('Data sources & credits'),
                    onTap: () => _showCredits(context),
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  ProfileForm(
                    initial: profile,
                    submitLabel: 'Save',
                    isSubmitting: state.isSaving,
                    onSubmit: context.read<ProfileCubit>().saveProfile,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
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
