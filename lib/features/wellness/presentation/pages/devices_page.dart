import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/health_access_status.dart';
import 'package:fitness_trakcer/features/health_sync/presentation/cubit/health_sync_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Health sync (Apple Health / Health Connect) and how other devices reach it.
class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return VSubPage(
      title: 'Devices &\nintegrations',
      maxWidth: 720,
      children: [
        const _HealthCard(),
        const SizedBox(height: 6),
        const VLabel('Other devices and apps'),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Garmin, Oura, WHOOP, Fitbit, Withings and Samsung Health',
                style: VeyroText.body(15, weight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                _isAndroid
                    ? 'These apps can share their data with Health Connect. Turn on sharing in each app\'s settings and it shows up here after a sync: steps, distance, active energy, sleep, HRV, resting and heart rate, weight and body fat.'
                    : 'These apps can share their data with Apple Health. Turn on sharing in each app\'s settings and it shows up here after a sync: steps, distance, active energy, sleep, HRV, resting and heart rate, weight and body fat.',
                style: VeyroText.body(13, color: v.mute, height: 1.4),
              ),
              const SizedBox(height: 8),
              Text(
                'Runs, walks and rides they record are imported too; gym and other workout types aren\'t. There\'s no direct Strava or Spotify connection.',
                style: VeyroText.body(12, color: v.mute, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

class _HistoryBlock extends StatelessWidget {
  const _HistoryBlock({required this.state});

  final HealthSyncState state;

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String _month(DateTime d) => '${_months[d.month - 1]} ${d.year}';

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final cubit = context.read<HealthSyncCubit>();
    final p = state.historyProgress;
    String counts() => p == null
        ? ''
        : '${p.activityDays} days of activity · ${p.workouts} workouts · '
              '${p.recoveryDays} days of sleep and heart data · '
              '${p.bodyEntries} body entries';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: v.bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('History', style: VeyroText.body(14, weight: FontWeight.w700)),
          const SizedBox(height: 4),
          if (state.isImportingHistory) ...[
            const LinearProgressIndicator(minHeight: 4),
            const SizedBox(height: 8),
            Text(
              p == null
                  ? 'Starting…'
                  : 'Importing ${_month(p.month)}, working backwards…',
              style: VeyroText.body(13, weight: FontWeight.w600),
            ),
            if (p != null)
              Text(counts(), style: VeyroText.body(12, color: v.mute)),
            const SizedBox(height: 4),
            Text(
              'You can keep using the app. Leave it open until this finishes.',
              style: VeyroText.body(12, color: v.mute),
            ),
            const SizedBox(height: 8),
            VButton(
              'Stop',
              style: VButtonStyle.card,
              height: 36,
              onPressed: cubit.cancelHistoryImport,
            ),
          ] else ...[
            Text(
              state.historyComplete
                  ? (state.historyOldest == null
                        ? 'No older data found in Health.'
                        : 'Imported back to ${_month(state.historyOldest!)}.')
                  : 'Not imported yet. Brings in everything in Health: activity, workouts, sleep, heart data and body measurements.',
              style: VeyroText.body(13, color: v.mute, height: 1.4),
            ),
            if (p != null && state.historyComplete)
              Text(counts(), style: VeyroText.body(12, color: v.mute)),
            const SizedBox(height: 8),
            VButton(
              state.historyComplete ? 'Import again' : 'Import full history',
              style: state.historyComplete
                  ? VButtonStyle.card
                  : VButtonStyle.accent,
              height: 36,
              onPressed: cubit.importHistory,
            ),
          ],
        ],
      ),
    );
  }
}

class _HealthCard extends StatelessWidget {
  const _HealthCard();

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return BlocBuilder<HealthSyncCubit, HealthSyncState>(
      builder: (context, state) {
        final cubit = context.read<HealthSyncCubit>();
        final name = _isAndroid ? 'Health Connect' : 'Apple Health';
        final unavailable = state.access == HealthAccessStatus.unavailable;
        final unsupported =
            kIsWeb ||
            (defaultTargetPlatform != TargetPlatform.android &&
                defaultTargetPlatform != TargetPlatform.iOS);
        final report = state.report;

        String status;
        if (unsupported) {
          status = 'Health sync works in the iOS and Android apps.';
        } else if (unavailable) {
          status = 'Health Connect isn\'t installed on this device.';
        } else if (state.isConnected) {
          status = state.isSyncing
              ? 'Syncing…'
              : state.lastSync == null
              ? 'Connected'
              : 'Connected · last synced ${_ago(state.lastSync!)}';
        } else {
          status = 'Not connected';
        }

        return VCard(
          radius: 26,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: v.bg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.favorite_rounded, color: v.acc),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: VeyroText.body(17, weight: FontWeight.w700),
                        ),
                        Text(status, style: VeyroText.body(12, color: v.mute)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _isAndroid
                    ? 'Reads steps, distance, active energy, sleep, HRV, resting heart rate, weight, body fat and your runs, walks and rides. Health Connect also carries data from Samsung Health, Google Fit, Fitbit and others.'
                    : 'Reads steps, distance, active energy, sleep, HRV, resting heart rate, weight, body fat and your runs, walks and rides, including data from your Apple Watch.',
                style: VeyroText.body(13, color: v.mute, height: 1.4),
              ),
              if (state.isConnected && report != null) ...[
                const SizedBox(height: 12),
                Text(
                  '${report.activityDays} days of activity refreshed'
                  '${report.bodyEntries > 0 ? ' · ${report.bodyEntries} body entries' : ''}'
                  '${report.workouts > 0 ? ' · ${report.workouts} workouts' : ''}',
                  style: VeyroText.body(13, weight: FontWeight.w600),
                ),
                if (report.sources.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'From ${report.sources.join(', ')}',
                    style: VeyroText.body(12, color: v.mute),
                  ),
                ],
              ],
              if (state.isConnected) ...[
                const SizedBox(height: 14),
                _HistoryBlock(state: state),
              ],
              if (state.failure != null) ...[
                const SizedBox(height: 8),
                Text(
                  _friendlyError(state.failure!.message),
                  style: VeyroText.body(12, color: VeyroColors.danger),
                ),
              ],
              if (_isAndroid && !unavailable && !unsupported) ...[
                const SizedBox(height: 10),
                Text(
                  'Using Samsung Health? Open Samsung Health → Settings → Health Connect and turn on sharing for the data you want here.',
                  style: VeyroText.body(12, color: v.mute, height: 1.4),
                ),
              ],
              if (!unsupported) ...[
                const SizedBox(height: 14),
                if (unavailable)
                  VButton(
                    'Install Health Connect',
                    onPressed: cubit.installHealthConnect,
                  )
                else if (!state.isConnected)
                  VButton('Connect $name', onPressed: cubit.connect)
                else
                  Row(
                    children: [
                      Expanded(
                        child: VButton(
                          state.isSyncing ? 'Syncing…' : 'Sync now',
                          onPressed: state.isSyncing
                              ? null
                              : () => cubit.sync(days: 30),
                        ),
                      ),
                      const SizedBox(width: 10),
                      VButton(
                        'Permissions',
                        style: VButtonStyle.soft,
                        onPressed: cubit.connect,
                      ),
                    ],
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  static String _friendlyError(String raw) =>
      raw.contains('not determined') || raw.contains('Authorization')
      ? 'Health needs your permission for some data. Tap Permissions to review.'
      : 'Couldn\'t sync with Health. Try again in a moment.';

  static String _ago(DateTime at) {
    final d = DateTime.now().difference(at);
    if (d.inMinutes < 1) return 'just now';
    if (d.inMinutes < 60) return '${d.inMinutes} min ago';
    if (d.inHours < 24) return '${d.inHours} h ago';
    return '${d.inDays} d ago';
  }
}
