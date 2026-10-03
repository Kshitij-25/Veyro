import 'package:fitness_trakcer/core/di/injection.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/usecases/request_location_permission.dart';
import 'package:fitness_trakcer/features/health_sync/presentation/cubit/health_sync_cubit.dart';
import 'package:fitness_trakcer/features/reminders/domain/services/reminder_scheduler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

enum _Kind { health, notifications, location, camera }

class _Step {
  const _Step(this.kind, this.icon, this.title, this.body);

  final _Kind kind;
  final IconData icon;
  final String title;
  final String body;
}

/// One screen per permission, asked in turn: what it is for, then the
/// system prompt. Shown once after the splash, and again from Settings.
class PermissionsPage extends StatefulWidget {
  const PermissionsPage({required this.onDone, super.key});

  /// Called after the last step.
  final VoidCallback onDone;

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  late final List<_Step> _steps = [
    _Step(
      _Kind.health,
      Icons.favorite_rounded,
      defaultTargetPlatform == TargetPlatform.iOS
          ? 'Connect Apple Health'
          : 'Connect Health Connect',
      'Bring in steps, sleep, heart rate, weight and workouts from your '
      'watch and other apps. Veyro only reads your data and never writes '
      'to Health.',
    ),
    const _Step(
      _Kind.notifications,
      Icons.notifications_active_rounded,
      'Stay on track',
      'Get your workout reminders, and a heads-up when your fast reaches '
          'its goal.',
    ),
    const _Step(
      _Kind.location,
      Icons.near_me_rounded,
      'Track your runs',
      'Location is used only while you record a run, walk or ride, to '
          'measure distance and draw your route.',
    ),
    const _Step(
      _Kind.camera,
      Icons.photo_camera_rounded,
      'Scan and snap',
      'The camera scans food barcodes and takes progress photos. Photos '
          'stay on this device.',
    ),
  ];

  int _index = 0;
  bool _busy = false;

  /// Set after a refused prompt, so the screen can point to Settings.
  bool _denied = false;

  _Step get _step => _steps[_index];

  void _next() {
    if (_index == _steps.length - 1) {
      widget.onDone();
      return;
    }
    setState(() {
      _index++;
      _denied = false;
    });
  }

  Future<bool> _request(_Kind kind) async {
    switch (kind) {
      case _Kind.health:
        return getIt<HealthSyncCubit>().connect();
      case _Kind.notifications:
        return getIt<ReminderScheduler>().requestPermission();
      case _Kind.location:
        final result = await getIt<RequestLocationPermission>()(
          const NoParams(),
        );
        return result.dataOrNull?.isGranted ?? false;
      case _Kind.camera:
        return (await Permission.camera.request()).isGranted;
    }
  }

  Future<void> _allow() async {
    setState(() => _busy = true);
    var granted = false;
    try {
      granted = await _request(_step.kind);
    } on Object {
      granted = false;
    }
    if (!mounted) return;
    setState(() => _busy = false);
    if (granted) {
      _next();
    } else {
      setState(() => _denied = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final step = _step;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      for (var i = 0; i < _steps.length; i++)
                        Expanded(
                          child: Container(
                            height: 4,
                            margin: EdgeInsets.only(
                              right: i == _steps.length - 1 ? 0 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: i <= _index ? v.acc : v.line,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'STEP ${_index + 1} OF ${_steps.length}',
                    style: VeyroText.label(color: v.mute),
                  ),
                  const Spacer(),
                  Center(
                    child: Container(
                      width: 132,
                      height: 132,
                      decoration: BoxDecoration(
                        color: v.acc.withValues(alpha: .14),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(step.icon, size: 64, color: v.acc),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    step.title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: VeyroText.display(40, height: 1),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    step.body,
                    textAlign: TextAlign.center,
                    style: VeyroText.body(15.5, color: v.mute, height: 1.45),
                  ),
                  if (_denied) ...[
                    const SizedBox(height: 16),
                    Text(
                      'That was not allowed. You can turn it on later in '
                      'Settings.',
                      textAlign: TextAlign.center,
                      style: VeyroText.body(
                        13.5,
                        color: VeyroColors.danger,
                        height: 1.4,
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (_denied) ...[
                    VButton(
                      'Open Settings',
                      height: 54,
                      radius: 18,
                      expand: true,
                      onPressed: openAppSettings,
                    ),
                    const SizedBox(height: 8),
                    VButton(
                      'Continue',
                      style: VButtonStyle.card,
                      height: 54,
                      radius: 18,
                      expand: true,
                      onPressed: _next,
                    ),
                  ] else ...[
                    VButton(
                      _busy ? 'Waiting…' : 'Allow',
                      height: 54,
                      radius: 18,
                      expand: true,
                      onPressed: _busy ? null : _allow,
                    ),
                    const SizedBox(height: 8),
                    VButton(
                      'Not now',
                      style: VButtonStyle.card,
                      height: 54,
                      radius: 18,
                      expand: true,
                      onPressed: _busy ? null : _next,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
