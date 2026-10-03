import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/core/utils/parsing.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise_tracking_type.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout_set.dart';
import 'package:flutter/material.dart';

/// Placeholder row to edit one set. Values are committed when a field loses
/// focus or is submitted, so storage isn't written on every keystroke.
class SetRow extends StatelessWidget {
  const SetRow({
    required this.set,
    required this.trackingType,
    required this.units,
    required this.onChanged,
    required this.onToggleCompleted,
    required this.onDelete,
    super.key,
  });

  final WorkoutSet set;
  final ExerciseTrackingType trackingType;
  final UnitSystem units;
  final ValueChanged<WorkoutSet> onChanged;
  final VoidCallback onToggleCompleted;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 28,
          child: Text(set.isWarmup ? 'W' : '${set.position + 1}'),
        ),
        if (trackingType.tracksWeight)
          _NumberCell(
            label: units.weightUnit,
            value: set.weightKg == null
                ? null
                : UnitConverter.weightToDisplay(set.weightKg!, units),
            onCommitted: (v) => onChanged(
              set.copyWith(
                weightKg: v == null
                    ? null
                    : UnitConverter.weightFromDisplay(v, units),
              ),
            ),
          ),
        if (trackingType.tracksReps)
          _NumberCell(
            label: 'reps',
            value: set.reps?.toDouble(),
            onCommitted: (v) => onChanged(set.copyWith(reps: v?.round())),
          ),
        if (trackingType.tracksDistance)
          _NumberCell(
            label: units.distanceUnit,
            value: set.distanceMeters == null
                ? null
                : UnitConverter.distanceToDisplay(set.distanceMeters!, units),
            onCommitted: (v) => onChanged(
              set.copyWith(
                distanceMeters: v == null
                    ? null
                    : UnitConverter.distanceFromDisplay(v, units),
              ),
            ),
          ),
        if (trackingType.tracksDuration)
          _NumberCell(
            label: 'min',
            value: set.durationSeconds == null
                ? null
                : set.durationSeconds! / 60,
            onCommitted: (v) => onChanged(
              set.copyWith(
                durationSeconds: v == null ? null : (v * 60).round(),
              ),
            ),
          ),
        Checkbox(value: set.isCompleted, onChanged: (_) => onToggleCompleted()),
        IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Remove set',
          onPressed: onDelete,
        ),
      ],
    );
  }
}

class _NumberCell extends StatefulWidget {
  const _NumberCell({
    required this.label,
    required this.value,
    required this.onCommitted,
  });

  final String label;
  final double? value;
  final ValueChanged<double?> onCommitted;

  @override
  State<_NumberCell> createState() => _NumberCellState();
}

class _NumberCellState extends State<_NumberCell> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _format(widget.value));
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(_NumberCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus && oldWidget.value != widget.value) {
      _controller.text = _format(widget.value);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  String _format(double? value) {
    if (value == null) return '';
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) _commit();
  }

  void _commit() {
    final parsed = tryParseDecimal(_controller.text);
    if (parsed != widget.value) widget.onCommitted(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.center,
          decoration: InputDecoration(isDense: true, suffixText: widget.label),
          onSubmitted: (_) => _commit(),
        ),
      ),
    );
  }
}
