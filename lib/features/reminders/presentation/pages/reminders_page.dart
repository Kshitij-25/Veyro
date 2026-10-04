import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/core/widgets/veyro_pickers.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/reminders/domain/entities/reminder.dart';
import 'package:fitness_trakcer/features/reminders/domain/entities/reminder_type.dart';
import 'package:fitness_trakcer/features/reminders/presentation/cubit/reminders_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return BlocConsumer<RemindersCubit, RemindersState>(
      listenWhen: (previous, current) =>
          (current.failure != null && current.failure != previous.failure) ||
          (current.notificationsDenied && !previous.notificationsDenied),
      listener: (context, state) {
        final message =
            state.failure?.message ??
            'Notifications are turned off, so reminders won\'t appear.';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      },
      builder: (context, state) {
        return VSubPage(
          title: 'Reminders',
          action: VButton(
            '+ New',
            height: 36,
            onPressed: () => _create(context),
          ),
          children: [
            if (state.notificationsDenied)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: v.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: v.acc, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifications are off',
                      style: VeyroText.body(15, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Allow notifications in Settings to receive reminders.',
                      style: VeyroText.body(13, color: v.mute),
                    ),
                  ],
                ),
              ),
            if (state.status.isPending)
              const LoadingView()
            else if (state.reminders.isEmpty)
              const VEmpty('No reminders yet.'),
            for (final reminder in state.reminders)
              VCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                radius: 20,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            TimeOfDay(
                              hour: reminder.hour,
                              minute: reminder.minute,
                            ).format(context),
                            style: VeyroText.display(34),
                          ),
                          Text(
                            reminder.title,
                            style: VeyroText.body(14, weight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              for (var d = 1; d <= 7; d++)
                                _DayDot(
                                  label: _weekdayLabels[d - 1],
                                  on:
                                      reminder.isDaily ||
                                      reminder.weekdays.contains(d),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    VTextAction(
                      'Delete',
                      onPressed: () =>
                          context.read<RemindersCubit>().delete(reminder.id),
                    ),
                    VSwitch(
                      value: reminder.isEnabled,
                      onChanged: (enabled) => context
                          .read<RemindersCubit>()
                          .setEnabled(reminder.id, enabled: enabled),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _create(BuildContext context) async {
    final cubit = context.read<RemindersCubit>();
    final reminder = await showDialog<Reminder>(
      context: context,
      builder: (context) => const _ReminderDialog(),
    );
    if (reminder != null) await cubit.save(reminder);
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({required this.label, required this.on});

  final String label;
  final bool on;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return Container(
      width: 22,
      height: 22,
      margin: const EdgeInsets.only(right: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: on ? v.ink : v.bg,
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        style: VeyroText.body(
          11,
          weight: FontWeight.w700,
          color: on ? v.bg : v.mute,
        ),
      ),
    );
  }
}

class _ReminderDialog extends StatefulWidget {
  const _ReminderDialog();

  @override
  State<_ReminderDialog> createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<_ReminderDialog> {
  ReminderType _type = ReminderType.workout;
  TimeOfDay _time = const TimeOfDay(hour: 18, minute: 0);
  final Set<int> _weekdays = {};
  final _title = TextEditingController(text: ReminderType.workout.label);

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New reminder'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<ReminderType>(
              initialValue: _type,
              items: [
                for (final t in ReminderType.values)
                  DropdownMenuItem(value: t, child: Text(t.label)),
              ],
              onChanged: (t) => setState(() {
                _type = t ?? _type;
                _title.text = _type.label;
              }),
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Message'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Time'),
              trailing: Text(_time.format(context)),
              onTap: () async {
                final picked = await showAdaptiveTimePicker(
                  context,
                  initial: _time,
                );
                if (picked != null) setState(() => _time = picked);
              },
            ),
            Wrap(
              spacing: 4,
              children: [
                for (var day = 1; day <= 7; day++)
                  FilterChip(
                    label: Text(_weekdayLabels[day - 1]),
                    selected: _weekdays.contains(day),
                    onSelected: (selected) => setState(
                      () =>
                          selected ? _weekdays.add(day) : _weekdays.remove(day),
                    ),
                  ),
              ],
            ),
            const Text('No days selected means every day.'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(
            context,
            Reminder(
              id: Reminder.unsavedId,
              type: _type,
              title: _title.text,
              hour: _time.hour,
              minute: _time.minute,
              weekdays: {..._weekdays},
            ),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
