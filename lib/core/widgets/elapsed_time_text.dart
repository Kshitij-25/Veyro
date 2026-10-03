import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:flutter/material.dart';

/// Shows the time since [since], refreshed every second.
class ElapsedTimeText extends StatelessWidget {
  const ElapsedTimeText({required this.since, this.style, super.key});

  final DateTime since;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(
        const Duration(seconds: 1),
        (_) => DateTime.now(),
      ),
      initialData: DateTime.now(),
      builder: (context, snapshot) =>
          Text(DateTime.now().difference(since).clock, style: style),
    );
  }
}
