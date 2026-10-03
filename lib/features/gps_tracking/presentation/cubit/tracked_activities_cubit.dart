import 'dart:async';

import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/usecases/delete_tracked_activity.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/usecases/watch_tracked_activities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'tracked_activities_cubit.freezed.dart';

@freezed
abstract class TrackedActivitiesState with _$TrackedActivitiesState {
  const factory TrackedActivitiesState({
    @Default(ViewStatus.initial) ViewStatus status,

    /// Newest first.
    @Default([]) List<TrackedActivity> activities,
    Failure? failure,
  }) = _TrackedActivitiesState;
}

@injectable
class TrackedActivitiesCubit extends Cubit<TrackedActivitiesState> {
  TrackedActivitiesCubit(this._watchActivities, this._deleteActivity)
    : super(const TrackedActivitiesState());

  final WatchTrackedActivities _watchActivities;
  final DeleteTrackedActivity _deleteActivity;

  StreamSubscription<List<TrackedActivity>>? _subscription;

  void start() {
    emit(state.copyWith(status: ViewStatus.loading));
    _subscription = _watchActivities(const NoParams()).listen(
      (activities) => emit(
        state.copyWith(status: ViewStatus.success, activities: activities),
      ),
      onError: (Object error) => emit(
        state.copyWith(status: ViewStatus.failure, failure: toFailure(error)),
      ),
    );
  }

  Future<void> delete(String activityId) async {
    final result = await _deleteActivity(activityId);
    emit(state.copyWith(failure: result.failureOrNull));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
