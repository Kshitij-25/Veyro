import 'dart:async';

import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/user_profile.dart';
import 'package:fitness_trakcer/features/profile/domain/usecases/save_user_profile.dart';
import 'package:fitness_trakcer/features/profile/domain/usecases/watch_user_profile.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// App-wide holder of the user's profile (and therefore their unit system).
@lazySingleton
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._watchUserProfile, this._saveUserProfile)
    : super(const ProfileState());

  final WatchUserProfile _watchUserProfile;
  final SaveUserProfile _saveUserProfile;

  StreamSubscription<UserProfile?>? _subscription;

  void start() {
    if (_subscription != null) return;
    emit(state.copyWith(status: ViewStatus.loading));
    _subscription = _watchUserProfile(const NoParams()).listen(
      (profile) => emit(
        state.copyWith(
          status: ViewStatus.success,
          profile: profile,
          failure: null,
        ),
      ),
      onError: (Object error) => emit(
        state.copyWith(status: ViewStatus.failure, failure: toFailure(error)),
      ),
    );
  }

  /// Returns whether the profile was saved.
  Future<bool> saveProfile(UserProfile profile) async {
    emit(state.copyWith(isSaving: true, failure: null));
    final result = await _saveUserProfile(profile);
    emit(state.copyWith(isSaving: false, failure: result.failureOrNull));
    return result.isSuccess;
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
