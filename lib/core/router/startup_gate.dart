import 'dart:async';

import 'package:fitness_trakcer/features/wellness/data/datasources/wellness_local_data_source.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Start-up state the router waits on: the splash has been on screen long
/// enough, and the first-run permission screens have been seen.
@lazySingleton
class StartupGate extends ChangeNotifier {
  StartupGate(this._data);

  static const _permissionsKey = 'permissions_done';
  static const _splashDuration = Duration(milliseconds: 1800);

  final WellnessLocalDataSource _data;

  bool _splashElapsed = false;
  bool _permissionsDone = false;

  bool get splashElapsed => _splashElapsed;
  bool get permissionsDone => _permissionsDone;

  /// Only phones have permissions worth asking for up front.
  static bool get _asksPermissions =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  Future<void> start() async {
    _permissionsDone =
        !_asksPermissions || await _data.getSetting(_permissionsKey) == '1';
    Timer(_splashDuration, () {
      _splashElapsed = true;
      notifyListeners();
    });
    notifyListeners();
  }

  Future<void> completePermissions() async {
    _permissionsDone = true;
    notifyListeners();
    await _data.setSetting(_permissionsKey, '1');
  }
}
