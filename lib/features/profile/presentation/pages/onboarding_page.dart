import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/onboarding_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/widgets/profile_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<OnboardingCubit, OnboardingState>(
          listenWhen: (previous, current) => current.failure != null,
          listener: (context, state) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.failure!.message))),
          builder: (context, state) => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ContentConstraint(
              maxWidth: 900,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VTitle('Welcome', size: 46),
                  const SizedBox(height: 8),
                  Text(
                    'Tell us a little about you. Everything stays on this '
                    'device.',
                    style: TextStyle(fontSize: 14, height: 1.4, color: v.mute),
                  ),
                  const SizedBox(height: 14),
                  ProfileForm(
                    submitLabel: 'Get started',
                    isSubmitting: state.isSubmitting,
                    onSubmit: context.read<OnboardingCubit>().complete,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
