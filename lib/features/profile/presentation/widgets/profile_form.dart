import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/core/utils/parsing.dart';
import 'package:fitness_trakcer/core/widgets/veyro_pickers.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/activity_level.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/fitness_goal.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/sex.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';

/// Form for creating or editing the profile; produces a [UserProfile].
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
  bool _submitted = false;

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
    final picked = await showAdaptiveDatePicker(
      context,
      initial: _birthDate ?? DateTime(now.year - 25),
      first: DateTime(now.year - 100),
      last: now,
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  void _submit() {
    _submitted = true;
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
    final v = context.veyro;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VTwoColumn(
            left: [
              VCard(
                onTap: null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    VField(
                      label: 'Name',
                      controller: _name,
                      textCapitalization: TextCapitalization.words,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 14),
                    VSegmented<UnitSystem>(
                      options: const {
                        UnitSystem.metric: 'Metric',
                        UnitSystem.imperial: 'Imperial',
                      },
                      selected: _units,
                      onChanged: _changeUnits,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: VField(
                            label: 'Height (${_units.lengthUnit})',
                            controller: _height,
                            numeric: true,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: _requiredNumber,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: VField(
                            label: 'Weight (${_units.weightUnit})',
                            controller: _weight,
                            numeric: true,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: _requiredNumber,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const VLabel('Date of birth'),
                    const SizedBox(height: 6),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _pickBirthDate,
                      child: Container(
                        height: 46,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: v.bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _birthDate == null && _submitted
                                ? VeyroColors.danger
                                : v.line,
                          ),
                        ),
                        child: Text(
                          _birthDate == null
                              ? 'Select'
                              : MaterialLocalizations.of(context)
                                    .formatMediumDate(_birthDate!),
                          style: VeyroText.body(
                            16,
                            color: _birthDate == null ? v.mute : v.ink,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const VLabel('Sex'),
                    const SizedBox(height: 6),
                    VChips<Sex>(
                      options: {for (final s in Sex.values) s: s.label},
                      selected: _sex,
                      onChanged: (s) => setState(() => _sex = s),
                      height: 40,
                    ),
                  ],
                ),
              ),
            ],
            right: [
              VCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VLabel('Activity level'),
                    const SizedBox(height: 10),
                    VChips<ActivityLevel>(
                      options: {
                        for (final a in ActivityLevel.values) a: a.label,
                      },
                      selected: _activityLevel,
                      onChanged: (a) => setState(() => _activityLevel = a),
                    ),
                    const SizedBox(height: 14),
                    const VLabel('Fitness goal'),
                    const SizedBox(height: 10),
                    VChips<FitnessGoal>(
                      options: {for (final g in FitnessGoal.values) g: g.label},
                      selected: _fitnessGoal,
                      onChanged: (g) => setState(() => _fitnessGoal = g),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          VBottomAction(
            horizontalPadding: 0,
            label: widget.submitLabel,
            busy: widget.isSubmitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
