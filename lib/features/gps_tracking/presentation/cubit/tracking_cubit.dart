import 'dart:async';

import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/location_permission_status.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/route_point.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity_type.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracking_snapshot.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracking_status.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/services/tracking_session.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/usecases/request_location_permission.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/usecases/save_tracked_activity.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/usecases/watch_location.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'tracking_cubit.freezed.dart';

@freezed
abstract class TrackingState with _$TrackingState {
  const factory TrackingState({
    @Default(TrackedActivityType.run) TrackedActivityType type,
    @Default(TrackingStatus.idle) TrackingStatus status,

    /// Live numbers while a session is active or paused.
    TrackingSnapshot? snapshot,
    LocationPermissionStatus? permission,
    @Default(false) bool isSaving,

    /// The most recently saved activity, until acknowledged.
    TrackedActivity? savedActivity,
    Failure? failure,
  }) = _TrackingState;
}

/// App-wide owner of the GPS session so recording continues while the user
/// navigates elsewhere in the app.
@lazySingleton
class TrackingCubit extends Cubit<TrackingState> {
  TrackingCubit(
    this._requestLocationPermission,
    this._watchLocation,
    this._saveTrackedActivity,
    this._clock,
  ) : super(const TrackingState());

  final RequestLocationPermission _requestLocationPermission;
  final WatchLocation _watchLocation;
  final SaveTrackedActivity _saveTrackedActivity;
  final Clock _clock;

  TrackingSession? _session;
  StreamSubscription<RoutePoint>? _locationSubscription;
  Timer? _ticker;

  void selectType(TrackedActivityType type) {
    if (state.status != TrackingStatus.idle) return;
    emit(state.copyWith(type: type));
  }

  Future<void> start() async {
    if (_session != null) return;
    emit(state.copyWith(failure: null, savedActivity: null));

    final permission = await _requestLocationPermission(const NoParams());
    final status = permission.dataOrNull;
    if (status == null || !status.isGranted) {
      emit(
        state.copyWith(
          permission: status,
          failure: permission.failureOrNull ?? _permissionFailure(status),
        ),
      );
      return;
    }

    _session = TrackingSession(type: state.type, now: _clock.now());
    _listenToLocation();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _publish());
    emit(state.copyWith(permission: status));
    _publish();
  }

  void pause() {
    final session = _session;
    if (session == null) return;
    session.pause(_clock.now());
    unawaited(_stopListening());
    _publish();
  }

  void resume() {
    final session = _session;
    if (session == null) return;
    session.resume(_clock.now());
    _listenToLocation();
    _publish();
  }

  /// Stops recording and saves the activity.
  Future<void> finish() async {
    final session = _session;
    if (session == null) return;
    final snapshot = session.finish(_clock.now());
    await _reset();

    emit(state.copyWith(isSaving: true));
    final result = await _saveTrackedActivity(
      SaveTrackedActivityParams(type: session.type, snapshot: snapshot),
    );
    emit(
      TrackingState(
        type: state.type,
        permission: state.permission,
        savedActivity: result.dataOrNull,
        failure: result.failureOrNull,
      ),
    );
  }

  /// Stops recording without saving.
  Future<void> discard() async {
    await _reset();
    emit(TrackingState(type: state.type, permission: state.permission));
  }

  void acknowledgeSaved() => emit(state.copyWith(savedActivity: null));

  void _listenToLocation() {
    _locationSubscription = _watchLocation(const NoParams()).listen(
      (point) {
        _session?.addPoint(point);
        _publish();
      },
      onError: (Object error) =>
          emit(state.copyWith(failure: UnexpectedFailure(error.toString()))),
    );
  }

  void _publish() {
    final session = _session;
    if (session == null || isClosed) return;
    emit(
      state.copyWith(
        status: session.status,
        snapshot: session.snapshot(_clock.now()),
      ),
    );
  }

  Failure _permissionFailure(LocationPermissionStatus? status) =>
      switch (status) {
        LocationPermissionStatus.serviceDisabled => const PermissionFailure(
          'Location services are turned off.',
        ),
        LocationPermissionStatus.deniedForever => const PermissionFailure(
          'Location permission is permanently denied. Enable it in settings.',
        ),
        _ => const PermissionFailure('Location permission is required.'),
      };

  Future<void> _stopListening() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  Future<void> _reset() async {
    _ticker?.cancel();
    _ticker = null;
    await _stopListening();
    _session = null;
  }

  @override
  Future<void> close() async {
    await _reset();
    return super.close();
  }
}
