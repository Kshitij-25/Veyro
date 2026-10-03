import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/onboarding_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/widgets/profile_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: BlocConsumer<OnboardingCubit, OnboardingState>(
        listenWhen: (previous, current) => current.failure != null,
        listener: (context, state) =>
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.failure!.message))),
        builder: (context, state) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ContentConstraint(
            maxWidth: 560,
            child: ProfileForm(
              submitLabel: 'Get started',
              isSubmitting: state.isSubmitting,
              onSubmit: context.read<OnboardingCubit>().complete,
            ),
          ),
        ),
      ),
    );
  }
}
