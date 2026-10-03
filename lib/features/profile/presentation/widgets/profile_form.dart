import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/core/utils/parsing.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/activity_level.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/fitness_goal.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/sex.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';

/// Placeholder form for creating or editing the profile. Replace with your
/// own design; it only needs to produce a [UserProfile].
class ProfileForm extends StatefulWidget {
  const ProfileForm({
    required this.submitLabel,
    required this.onSubmit,
    this.initial,
    this.isSubmitting = false,
    super.key,
  });

  final UserProfile? initial;
  final String submitLabel;
  final bool isSubmitting;
  final ValueChanged<UserProfile> onSubmit;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _height;
  late final TextEditingController _weight;
  late UnitSystem _units;
  late Sex _sex;
  late ActivityLevel _activityLevel;
  late FitnessGoal _fitnessGoal;
  DateTime? _birthDate;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _units = initial?.unitSystem ?? UnitSystem.metric;
    _sex = initial?.sex ?? Sex.male;
    _activityLevel = initial?.activityLevel ?? ActivityLevel.lightlyActive;
    _fitnessGoal = initial?.fitnessGoal ?? FitnessGoal.maintainWeight;
    _birthDate = initial?.birthDate;
    _name = TextEditingController(text: initial?.name ?? '');
    _height = TextEditingController(
      text: initial == null
          ? ''
          : UnitConverter.lengthToDisplay(
              initial.heightCm,
              _units,
            ).toStringAsFixed(1),
    );
    _weight = TextEditingController(
      text: initial == null
          ? ''
          : UnitConverter.weightToDisplay(
              initial.weightKg,
              _units,
            ).toStringAsFixed(1),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _height.dispose();
    _weight.dispose();
    super.dispose();
  }

  void _changeUnits(UnitSystem next) {
    if (next == _units) return;
    final height = tryParseDecimal(_height.text);
    final weight = tryParseDecimal(_weight.text);
    setState(() {
      if (height != null) {
        final cm = UnitConverter.lengthFromDisplay(height, _units);
        _height.text = UnitConverter.lengthToDisplay(
          cm,
          next,
        ).toStringAsFixed(1);
      }
      if (weight != null) {
        final kg = UnitConverter.weightFromDisplay(weight, _units);
        _weight.text = UnitConverter.weightToDisplay(
          kg,
          next,
        ).toStringAsFixed(1);
      }
      _units = next;
    });
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 25),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate() || _birthDate == null) {
      setState(() {});
      return;
    }
    final now = DateTime.now();
    widget.onSubmit(
      UserProfile(
        id: UserProfile.localId,
        name: _name.text.trim(),
        birthDate: _birthDate!,
        sex: _sex,
        heightCm: UnitConverter.lengthFromDisplay(
          tryParseDecimal(_height.text)!,
          _units,
        ),
        weightKg: UnitConverter.weightFromDisplay(
          tryParseDecimal(_weight.text)!,
          _units,
        ),
        activityLevel: _activityLevel,
        fitnessGoal: _fitnessGoal,
        unitSystem: _units,
        createdAt: widget.initial?.createdAt ?? now,
        updatedAt: now,
      ),
    );
  }

  String? _requiredNumber(String? value) =>
      tryParseDecimal(value) == null ? 'Enter a number' : null;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Name'),
            textCapitalization: TextCapitalization.words,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          SegmentedButton<UnitSystem>(
            segments: const [
              ButtonSegment(value: UnitSystem.metric, label: Text('Metric')),
              ButtonSegment(
                value: UnitSystem.imperial,
                label: Text('Imperial'),
              ),
            ],
            selected: {_units},
            onSelectionChanged: (s) => _changeUnits(s.first),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Date of birth'),
            subtitle: Text(
              _birthDate == null
                  ? 'Select'
                  : MaterialLocalizations.of(context)
                        .formatMediumDate(_birthDate!),
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: _pickBirthDate,
          ),
          DropdownButtonFormField<Sex>(
            initialValue: _sex,
            decoration: const InputDecoration(labelText: 'Sex'),
            items: [
              for (final s in Sex.values)
                DropdownMenuItem(value: s, child: Text(s.label)),
            ],
            onChanged: (v) => setState(() => _sex = v ?? _sex),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _height,
            decoration: InputDecoration(
              labelText: 'Height (${_units.lengthUnit})',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: _requiredNumber,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _weight,
            decoration: InputDecoration(
              labelText: 'Weight (${_units.weightUnit})',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: _requiredNumber,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<ActivityLevel>(
            initialValue: _activityLevel,
            decoration: const InputDecoration(labelText: 'Activity level'),
            items: [
              for (final a in ActivityLevel.values)
                DropdownMenuItem(value: a, child: Text(a.label)),
            ],
            onChanged: (v) =>
                setState(() => _activityLevel = v ?? _activityLevel),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<FitnessGoal>(
            initialValue: _fitnessGoal,
            decoration: const InputDecoration(labelText: 'Goal'),
            items: [
              for (final g in FitnessGoal.values)
                DropdownMenuItem(value: g, child: Text(g.label)),
            ],
            onChanged: (v) => setState(() => _fitnessGoal = v ?? _fitnessGoal),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: widget.isSubmitting ? null : _submit,
            child: widget.isSubmitting
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Text(widget.submitLabel),
          ),
        ],
      ),
    );
  }
}
