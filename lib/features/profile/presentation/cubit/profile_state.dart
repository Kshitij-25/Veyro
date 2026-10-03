import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/user_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(ViewStatus.initial) ViewStatus status,
    UserProfile? profile,
    Failure? failure,
    @Default(false) bool isSaving,
  }) = _ProfileState;

  const ProfileState._();

  bool get hasProfile => profile != null;

  /// Metric until the user picks otherwise.
  UnitSystem get unitSystem => profile?.unitSystem ?? UnitSystem.metric;
}
