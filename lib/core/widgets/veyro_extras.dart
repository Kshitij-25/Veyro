import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Label, round − / + buttons and a value between them.
class VStepper extends StatelessWidget {
  const VStepper({
    required this.label,
    required this.value,
    required this.onMinus,
    required this.onPlus,
    super.key,
  });

  final String label;
  final String value;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    Widget round(String t, VoidCallback? f) => SizedBox(
      width: 38,
      height: 38,
      child: IconButton.filled(
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: v.bg,
          foregroundColor: v.ink,
        ),
        onPressed: f,
        icon: Text(t, style: const TextStyle(fontSize: 20)),
      ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: VeyroText.body(14, weight: FontWeight.w600),
          ),
        ),
        Row(
          children: [
            round('−', onMinus),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 64),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: VeyroText.display(26),
              ),
            ),
            round('+', onPlus),
          ],
        ),
      ],
    );
  }
}

/// Title + subtitle with a Veyro switch.
class VToggleRow extends StatelessWidget {
  const VToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: VeyroText.body(15, weight: FontWeight.w600)),
              if (subtitle != null)
                Text(subtitle!, style: VeyroText.body(12, color: v.mute)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        VSwitch(value: value, onChanged: onChanged),
      ],
    );
  }
}

/// Horizontally scrolling single-select chips on card/background surface.
class VChipRow<T> extends StatelessWidget {
  const VChipRow({
    required this.options,
    required this.selected,
    required this.onChanged,
    this.onCard = false,
    super.key,
  });

  final Map<T, String> options;
  final T? selected;
  final ValueChanged<T> onChanged;

  /// True when the row sits inside a card (unselected uses the page bg).
  final bool onCard;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final e in options.entries)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: GestureDetector(
                onTap: () => onChanged(e.key),
                child: Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: e.key == selected ? v.ink : (onCard ? v.bg : v.card),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Text(
                    e.value,
                    style: VeyroText.body(
                      13,
                      weight: FontWeight.w600,
                      color: e.key == selected ? v.bg : v.ink,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Page-level segmented control (card background, ink selection).
class VTabs<T> extends StatelessWidget {
  const VTabs({
    required this.options,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final Map<T, String> options;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: v.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (final e in options.entries)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(e.key),
                child: Container(
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: e.key == selected ? v.ink : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    e.value,
                    style: VeyroText.body(
                      13,
                      weight: FontWeight.w600,
                      color: e.key == selected ? v.bg : v.mute,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Small card with an uppercase label and a big condensed value.
class VStatTile extends StatelessWidget {
  const VStatTile({
    required this.label,
    required this.value,
    this.onTap,
    this.valueSize = 28,
    this.suffix,
    super.key,
  });

  final String label;
  final String value;
  final String? suffix;
  final double valueSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return VCard(
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VLabel(label),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              text: value,
              children: [
                if (suffix != null)
                  TextSpan(
                    text: ' $suffix',
                    style: VeyroText.body(13, color: v.mute),
                  ),
              ],
            ),
            style: VeyroText.display(valueSize, height: 1.1),
          ),
        ],
      ),
    );
  }
}

/// Two-column grid where both cells of a row share the taller height.
class VGrid2 extends StatelessWidget {
  const VGrid2({required this.children, this.gap = 8, super.key});

  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += 2) {
      rows.add(
        Padding(
          padding: EdgeInsets.only(top: i == 0 ? 0 : gap),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: children[i]),
                SizedBox(width: gap),
                Expanded(
                  child: i + 1 < children.length
                      ? children[i + 1]
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

/// Thin row separated by a top hairline (label left, value right).
class VKeyValueRow extends StatelessWidget {
  const VKeyValueRow({
    required this.label,
    required this.value,
    this.height = 42,
    this.divider = true,
    this.valueSize = 22,
    super.key,
  });

  final String label;
  final Widget value;
  final double height;
  final bool divider;
  final double valueSize;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: divider ? Border(top: BorderSide(color: v.line)) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: VeyroText.body(14))),
          value,
        ],
      ),
    );
  }
}

/// Bottom sheet with one text/number input. Returns the entered text.
Future<String?> showVeyroInputSheet(
  BuildContext context, {
  required String title,
  required String label,
  String initial = '',
  String unit = '',
  TextInputType keyboardType = TextInputType.text,
}) {
  final v = context.veyro;
  final controller = TextEditingController(text: initial);
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: v.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        22,
        20,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title.toUpperCase(), style: VeyroText.display(32)),
          const SizedBox(height: 8),
          VLabel('$label $unit'.trim()),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            autofocus: true,
            keyboardType: keyboardType,
            inputFormatters: keyboardType == TextInputType.text
                ? null
                : [FilteringTextInputFormatter.allow(RegExp(r'[0-9.:]'))],
            style: VeyroText.display(34, color: v.ink),
            decoration: InputDecoration(
              fillColor: v.bg,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            onSubmitted: (t) => Navigator.pop(context, t),
          ),
          const SizedBox(height: 12),
          VButton(
            'Save',
            height: 54,
            radius: 16,
            expand: true,
            onPressed: () => Navigator.pop(context, controller.text),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: VeyroText.body(15, weight: FontWeight.w600, color: v.mute),
            ),
          ),
        ],
      ),
    ),
  );
}
