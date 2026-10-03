import 'dart:async';

import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/features/progress_photos/domain/entities/check_in.dart';
import 'package:fitness_trakcer/features/progress_photos/domain/services/photo_picker.dart';
import 'package:fitness_trakcer/features/progress_photos/domain/usecases/check_in_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'check_ins_cubit.freezed.dart';

@freezed
abstract class CheckInsState with _$CheckInsState {
  const factory CheckInsState({
    @Default(false) bool loaded,

    /// Newest first.
    @Default([]) List<CheckIn> checkIns,
    Failure? failure,
  }) = _CheckInsState;
}

/// Shared between the Progress tiles and the Photos screen.
@lazySingleton
class CheckInsCubit extends Cubit<CheckInsState> {
  CheckInsCubit(
    this._watch,
    this._create,
    this._setPhoto,
    this._removePhoto,
    this._delete,
  ) : super(const CheckInsState());

  final WatchCheckIns _watch;
  final CreateCheckIn _create;
  final SetCheckInPhoto _setPhoto;
  final RemoveCheckInPhoto _removePhoto;
  final DeleteCheckIn _delete;

  StreamSubscription<List<CheckIn>>? _subscription;

  void start() {
    _subscription ??= _watch(const NoParams()).listen(
      (list) => emit(state.copyWith(loaded: true, checkIns: list)),
      onError: (Object e) =>
          emit(state.copyWith(loaded: true, failure: toFailure(e))),
    );
  }

  Future<void> addCheckIn() async {
    final result = await _create(const NoParams());
    emit(state.copyWith(failure: result.failureOrNull));
  }

  /// Returns false when nothing was attached (cancelled or failed).
  Future<bool> setPhoto(
    String checkInId,
    PhotoAngle angle,
    PhotoSource source,
  ) async {
    final result = await _setPhoto(
      SetCheckInPhotoParams(checkInId, angle, source),
    );
    emit(state.copyWith(failure: result.failureOrNull));
    return result.dataOrNull ?? false;
  }

  Future<void> removePhoto(String checkInId, PhotoAngle angle) async {
    final result = await _removePhoto(
      RemoveCheckInPhotoParams(checkInId, angle),
    );
    emit(state.copyWith(failure: result.failureOrNull));
  }

  Future<void> delete(String checkInId) async {
    final result = await _delete(checkInId);
    emit(state.copyWith(failure: result.failureOrNull));
  }

  void clearFailure() => emit(state.copyWith(failure: null));
}
