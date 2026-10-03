import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension UnitSystemContext on BuildContext {
  /// The user's chosen unit system; rebuilds when it changes.
  UnitSystem get unitSystem =>
      select((ProfileCubit cubit) => cubit.state.unitSystem);
}
