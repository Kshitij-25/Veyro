import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/rest_timer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Orange rest countdown with +15s / Skip; renders nothing when idle.
class RestTimerBar extends StatelessWidget {
  const RestTimerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestTimerCubit, RestTimerState>(
      builder: (context, state) {
        if (!state.isRunning) return const SizedBox.shrink();
        final cubit = context.read<RestTimerCubit>();
        Widget btn(String t, VoidCallback f, {bool dark = false}) => SizedBox(
          height: 34,
          child: FilledButton(
            onPressed: f,
            style: FilledButton.styleFrom(
              backgroundColor: dark
                  ? VeyroColors.onAccent
                  : VeyroColors.onAccent.withValues(alpha: .14),
              foregroundColor: dark ? Colors.white : VeyroColors.onAccent,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: VeyroText.body(13, weight: FontWeight.w700),
            ),
            child: Text(t),
          ),
        );
        return Container(
          height: 50,
          padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
          decoration: BoxDecoration(
            color: context.veyro.acc,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              const VLabel('Rest', color: VeyroColors.onAccent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  state.remaining.clock,
                  style: VeyroText.display(30, color: VeyroColors.onAccent),
                ),
              ),
              btn('+15s', () => cubit.addTime(const Duration(seconds: 15))),
              const SizedBox(width: 6),
              btn('Skip', cubit.skip, dark: true),
            ],
          ),
        );
      },
    );
  }
}
