import 'dart:io';

import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/widgets/veyro_charts.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/progress_photos/domain/entities/check_in.dart';
import 'package:fitness_trakcer/features/progress_photos/domain/services/photo_picker.dart';
import 'package:fitness_trakcer/features/progress_photos/presentation/cubit/check_ins_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _months = [
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

String _date(DateTime d) {
  final base = '${_months[d.month - 1]} ${d.day}';
  return d.year == DateTime.now().year ? base : '$base, ${d.year}';
}

String _angleLabel(PhotoAngle a) => switch (a) {
  PhotoAngle.front => 'Front',
  PhotoAngle.side => 'Side',
  PhotoAngle.back => 'Back',
};

/// Progress photo check-ins, stored on this device.
class PhotosPage extends StatefulWidget {
  const PhotosPage({super.key});

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  String _view = 'Grid';
  PhotoAngle _angle = PhotoAngle.front;

  /// Check-in ids chosen for Compare; null means newest / oldest.
  String? _afterId;
  String? _beforeId;

  Future<void> _addPhoto(CheckIn checkIn, PhotoAngle angle) async {
    if (kIsWeb) {
      _toast('Adding photos works in the iOS and Android apps.');
      return;
    }
    final source = await _chooseSource();
    if (source == null || !mounted) return;
    await context.read<CheckInsCubit>().setPhoto(checkIn.id, angle, source);
  }

  Future<PhotoSource?> _chooseSource() {
    final v = context.veyro;
    return showModalBottomSheet<PhotoSource>(
      context: context,
      useRootNavigator: true,
      backgroundColor: v.card,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take photo'),
              onTap: () => Navigator.of(
                context,
                rootNavigator: true,
              ).pop(PhotoSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from library'),
              onTap: () => Navigator.of(
                context,
                rootNavigator: true,
              ).pop(PhotoSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _view_(CheckIn checkIn, PhotoAngle angle) async {
    final cubit = context.read<CheckInsCubit>();
    final action = await showDialog<String>(
      context: context,
      useRootNavigator: true,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                child: Image.file(
                  File(checkIn.photos[angle]!),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        '${_date(checkIn.takenAt)} · ${_angleLabel(angle)}',
                        style: VeyroText.body(15, color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'replace'),
                      child: const Text('Replace'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'remove'),
                      child: const Text('Remove'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (!mounted) return;
    if (action == 'replace') {
      await _addPhoto(checkIn, angle);
    } else if (action == 'remove') {
      await cubit.removePhoto(checkIn.id, angle);
    }
  }

  Future<void> _deleteCheckIn(CheckIn c) async {
    final cubit = context.read<CheckInsCubit>();
    final ok = await showVeyroConfirm(
      context,
      title: 'Delete check-in?',
      message:
          'This removes the ${_date(c.takenAt)} check-in and its photos from this device.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (ok) await cubit.delete(c.id);
  }

  void _toast(String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    String kg(double? x) => x == null
        ? 'No weight'
        : '${UnitConverter.weightToDisplay(x, units).toStringAsFixed(1)} ${units.weightUnit}';
    return BlocConsumer<CheckInsCubit, CheckInsState>(
      listenWhen: (a, b) => b.failure != null && a.failure != b.failure,
      listener: (context, state) {
        _toast(
          kIsWeb
              ? 'Something went wrong.'
              : 'Couldn\'t add the photo. Check camera and photo permissions.',
        );
        context.read<CheckInsCubit>().clearFailure();
      },
      builder: (context, state) {
        final cubit = context.read<CheckInsCubit>();
        final list = state.checkIns;
        return VSubPage(
          title: 'Progress\nphotos',
          maxWidth: 840,
          action: VButton(
            '+ Check-in',
            height: 36,
            onPressed: cubit.addCheckIn,
          ),
          children: [
            if (list.isEmpty)
              VCard(
                child: Text(
                  state.loaded
                      ? 'No check-ins yet. Tap + Check-in, then add front, side and back photos. Your current weight is saved with each one.'
                      : 'Loading…',
                  style: VeyroText.body(14, color: v.mute, height: 1.4),
                ),
              )
            else ...[
              VTabs<String>(
                options: const {'Grid': 'Grid', 'Compare': 'Compare'},
                selected: _view,
                onChanged: (t) => setState(() => _view = t),
              ),
              if (_view == 'Grid')
                for (final c in list)
                  VCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Text(
                              _date(c.takenAt).toUpperCase(),
                              style: VeyroText.display(22),
                            ),
                            const Spacer(),
                            Text(
                              kg(c.weightKg),
                              style: VeyroText.body(13, color: v.mute),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: Icon(
                                Icons.delete_outline,
                                size: 20,
                                color: v.mute,
                              ),
                              onPressed: () => _deleteCheckIn(c),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            for (final a in PhotoAngle.values) ...[
                              if (a != PhotoAngle.front)
                                const SizedBox(width: 6),
                              Expanded(
                                child: _Slot(
                                  angle: a,
                                  path: c.photos[a],
                                  height: 150,
                                  onTap: () => c.photos[a] == null
                                      ? _addPhoto(c, a)
                                      : _view_(c, a),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  )
              else
                ..._compare(list, kg),
              Text(
                'Photos stay on this device.',
                textAlign: TextAlign.center,
                style: VeyroText.body(12, color: v.mute),
              ),
            ],
          ],
        );
      },
    );
  }

  List<Widget> _compare(List<CheckIn> list, String Function(double?) kg) {
    final v = context.veyro;
    final units = context.unitSystem;
    if (list.length < 2) {
      return [
        VCard(
          child: Text(
            'Add a second check-in to compare.',
            style: VeyroText.body(14, color: v.mute),
          ),
        ),
      ];
    }
    CheckIn pick(String? id, CheckIn fallback) =>
        list.firstWhere((c) => c.id == id, orElse: () => fallback);
    final after = pick(_afterId, list.first);
    final before = pick(_beforeId, list.last);
    final options = {for (final c in list) c.id: _date(c.takenAt)};
    final diff = after.weightKg == null || before.weightKg == null
        ? null
        : UnitConverter.weightToDisplay(
            after.weightKg! - before.weightKg!,
            units,
          );
    return [
      VCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const VLabel('Angle'),
            const SizedBox(height: 8),
            VChipRow<PhotoAngle>(
              options: {for (final a in PhotoAngle.values) a: _angleLabel(a)},
              selected: _angle,
              onChanged: (a) => setState(() => _angle = a),
              onCard: true,
            ),
            const SizedBox(height: 12),
            const VLabel('Before'),
            const SizedBox(height: 8),
            VChipRow<String>(
              options: options,
              selected: before.id,
              onChanged: (id) => setState(() => _beforeId = id),
              onCard: true,
            ),
            const SizedBox(height: 12),
            const VLabel('After'),
            const SizedBox(height: 8),
            VChipRow<String>(
              options: options,
              selected: after.id,
              onChanged: (id) => setState(() => _afterId = id),
              onCard: true,
            ),
          ],
        ),
      ),
      Row(
        children: [
          for (final c in [before, after]) ...[
            if (c == after) const SizedBox(width: 8),
            Expanded(
              child: Column(
                children: [
                  _Slot(
                    angle: _angle,
                    path: c.photos[_angle],
                    height: 260,
                    onTap: () => c.photos[_angle] == null
                        ? _addPhoto(c, _angle)
                        : _view_(c, _angle),
                  ),
                  const SizedBox(height: 4),
                  Text(kg(c.weightKg), style: VeyroText.display(20)),
                ],
              ),
            ),
          ],
        ],
      ),
      if (diff != null)
        Text(
          '${diff <= 0 ? '−' : '+'}${diff.abs().toStringAsFixed(1)} ${units.weightUnit} between check-ins',
          textAlign: TextAlign.center,
          style: VeyroText.body(13, color: v.mute),
        ),
    ];
  }
}

class _Slot extends StatelessWidget {
  const _Slot({
    required this.angle,
    required this.path,
    required this.height,
    required this.onTap,
  });

  final PhotoAngle angle;
  final String? path;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final path = this.path;
    return GestureDetector(
      onTap: onTap,
      child: path == null || kIsWeb
          ? Stack(
              children: [
                VPlaceholder(_angleLabel(angle).toLowerCase(), height: height),
                Positioned.fill(
                  child: Align(
                    alignment: const Alignment(0, .55),
                    child: Icon(Icons.add_a_photo_outlined, color: v.mute),
                  ),
                ),
              ],
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                height: height,
                width: double.infinity,
                child: Image.file(
                  File(path),
                  fit: BoxFit.cover,
                  cacheWidth: 600,
                  errorBuilder: (_, _, _) =>
                      VPlaceholder('missing', height: height),
                ),
              ),
            ),
    );
  }
}
