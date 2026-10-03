import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/log_body_measurement.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/user_profile.dart';
import 'package:fitness_trakcer/features/profile/domain/usecases/save_user_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

class OnboardingState {
  const OnboardingState({this.isSubmitting = false, this.failure});

  final bool isSubmitting;
  final Failure? failure;
}

/// Saves the first profile and records the starting weight. Once the profile
/// exists the router redirects into the app on its own.
@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._saveUserProfile, this._logBodyMeasurement)
    : super(const OnboardingState());

  final SaveUserProfile _saveUserProfile;
  final LogBodyMeasurement _logBodyMeasurement;

  Future<void> complete(UserProfile profile) async {
    emit(const OnboardingState(isSubmitting: true));
    final saved = await _saveUserProfile(profile);
    if (saved.isFailure) {
      emit(OnboardingState(failure: saved.failureOrNull));
      return;
    }
    await _logBodyMeasurement(
      LogBodyMeasurementParams(weightKg: profile.weightKg),
    );
    emit(const OnboardingState());
  }
}
