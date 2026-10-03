import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/widgets/empty_view.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New reminder',
        onPressed: () => _create(context),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<RemindersCubit, RemindersState>(
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
          if (state.status.isPending) return const LoadingView();
          if (state.reminders.isEmpty) {
            return const EmptyView(message: 'No reminders yet.');
          }
          return ContentConstraint(
            maxWidth: 720,
            child: ListView(
              children: [
                for (final reminder in state.reminders)
                  Dismissible(
                    key: ValueKey(reminder.id),
                    onDismissed: (_) =>
                        context.read<RemindersCubit>().delete(reminder.id),
                    background: const ColoredBox(color: Colors.red),
                    child: SwitchListTile.adaptive(
                      title: Text(reminder.title),
                      subtitle: Text(
                        '${TimeOfDay(hour: reminder.hour, minute: reminder.minute).format(context)} · '
                        '${reminder.isDaily ? 'Every day' : [for (final d in reminder.weekdays.toList()..sort()) _weekdayLabels[d - 1]].join(' ')}',
                      ),
                      value: reminder.isEnabled,
                      onChanged: (enabled) => context
                          .read<RemindersCubit>()
                          .setEnabled(reminder.id, enabled: enabled),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
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
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _time,
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
