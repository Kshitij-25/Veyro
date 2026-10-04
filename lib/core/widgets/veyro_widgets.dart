import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Page header: big condensed uppercase title with optional kicker and action.
class VTitle extends StatelessWidget {
  const VTitle(
    this.title, {
    this.kicker,
    this.trailing,
    this.size = 52,
    super.key,
  });

  final String title;
  final String? kicker;
  final Widget? trailing;
  final double size;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (kicker != null)
                Text(
                  kicker!.toUpperCase(),
                  style: VeyroText.label(color: v.mute),
                ),
              Text(
                title.toUpperCase(),
                style: VeyroText.display(size, color: v.ink, height: 0.92),
              ),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// Rounded surface used for every grouped block.
class VCard extends StatelessWidget {
  const VCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.radius = 22,
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? context.veyro.card,
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Small uppercase caption.
class VLabel extends StatelessWidget {
  const VLabel(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: VeyroText.label(color: color ?? context.veyro.mute),
  );
}

/// Pill-shaped action button. [filled] uses the accent, otherwise [ink] or card.
enum VButtonStyle { accent, ink, card, soft }

class VButton extends StatelessWidget {
  const VButton(
    this.label, {
    required this.onPressed,
    this.style = VButtonStyle.accent,
    this.height = 40,
    this.radius,
    this.expand = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final VButtonStyle style;
  final double height;
  final double? radius;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final (bg, fg) = switch (style) {
      VButtonStyle.accent => (v.acc, VeyroColors.onAccent),
      VButtonStyle.ink => (v.ink, v.bg),
      VButtonStyle.card => (v.card, v.ink),
      VButtonStyle.soft => (v.bg, v.ink),
    };
    final button = SizedBox(
      height: height,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          minimumSize: Size(0, height),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? height / 2),
          ),
          textStyle: VeyroText.body(14, weight: FontWeight.w700),
        ),
        child: Text(label),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Round back button used in custom headers.
class VBackButton extends StatelessWidget {
  const VBackButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton.filled(
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: v.card,
          foregroundColor: v.ink,
        ),
        onPressed: onPressed,
        icon: Icon(Icons.adaptive.arrow_back, size: 22),
      ),
    );
  }
}

/// Horizontal progress bar.
class VProgressBar extends StatelessWidget {
  const VProgressBar({required this.value, this.height = 6, super.key});

  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor: v.bg,
        valueColor: AlwaysStoppedAnimation(v.acc),
      ),
    );
  }
}

/// Labelled text field on a card surface.
class VField extends StatelessWidget {
  const VField({
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.numeric = false,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  /// Large condensed numerals (height, weight).
  final bool numeric;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VLabel(label),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          style: numeric
              ? VeyroText.display(24, color: v.ink)
              : VeyroText.body(16, color: v.ink),
          decoration: InputDecoration(
            fillColor: v.bg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: v.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: v.line),
            ),
          ),
        ),
      ],
    );
  }
}

/// Two-to-four way segmented control on the page background.
class VSegmented<T> extends StatelessWidget {
  const VSegmented({
    required this.options,
    required this.selected,
    required this.onChanged,
    this.height = 38,
    super.key,
  });

  final Map<T, String> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final double height;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: v.bg,
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
                  height: height,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: e.key == selected ? v.ink : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    e.value,
                    style: VeyroText.body(
                      14,
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

/// Wrapping pill chips for single selection.
class VChips<T> extends StatelessWidget {
  const VChips({
    required this.options,
    required this.selected,
    required this.onChanged,
    this.height = 36,
    super.key,
  });

  final Map<T, String> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final double height;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final e in options.entries)
          GestureDetector(
            onTap: () => onChanged(e.key),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: e.key == selected ? v.ink : v.bg,
                borderRadius: BorderRadius.circular(height / 2),
              ),
              child: SizedBox(
                height: height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Center(
                    widthFactor: 1,
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
            ),
          ),
      ],
    );
  }
}

/// Bottom-pinned primary action with a fade from the page background.
class VBottomAction extends StatelessWidget {
  const VBottomAction({
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.horizontalPadding = 16,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0, .35],
          colors: [v.bg.withValues(alpha: 0), v.bg],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            12,
            horizontalPadding,
            12,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              onPressed: busy ? null : onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: v.acc,
                foregroundColor: VeyroColors.onAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: VeyroText.body(17, weight: FontWeight.w700),
              ),
              child: busy
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : Text(label),
            ),
          ),
        ),
      ),
    );
  }
}

/// Pops the current route, with a safe fallback when nothing can be popped.
void veyroBack(BuildContext context, {String? fallback}) {
  if (context.canPop()) {
    context.pop();
  } else if (fallback != null) {
    context.push(fallback);
  }
}

/// Standard sub-page: round back button, optional trailing actions, big
/// title, then a scrolling body. [bottom] is pinned beneath the body.
class VSubPage extends StatelessWidget {
  const VSubPage({
    required this.title,
    required this.children,
    this.action,
    this.bottom,
    this.maxWidth = 720,
    this.gap = 10,
    super.key,
  });

  final String title;
  final List<Widget> children;
  final Widget? action;
  final Widget? bottom;
  final double maxWidth;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: bottom == null,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              children: [
                SizedBox(
                  height: 52,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        VBackButton(onPressed: () => veyroBack(context)),
                        ?action,
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                    children: [
                      VTitle(title, size: 46),
                      SizedBox(height: gap + 2),
                      for (final c in children) ...[c, SizedBox(height: gap)],
                    ],
                  ),
                ),
                ?bottom,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Card shown in place of an empty list.
class VEmpty extends StatelessWidget {
  const VEmpty(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) => VCard(
    padding: const EdgeInsets.all(28),
    child: Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: VeyroText.body(14, color: context.veyro.mute),
      ),
    ),
  );
}

/// Small borderless text action (Delete, Remove ...).
class VTextAction extends StatelessWidget {
  const VTextAction(
    this.label, {
    required this.onPressed,
    this.color,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      foregroundColor: color ?? context.veyro.mute,
      minimumSize: const Size(0, 32),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    ),
    child: Text(label, style: VeyroText.body(12)),
  );
}

/// Platform switch (Cupertino on iOS) in the Veyro accent when on.
class VSwitch extends StatelessWidget {
  const VSwitch({required this.value, required this.onChanged, super.key});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeTrackColor: v.acc,
      activeThumbColor: Colors.white,
      inactiveTrackColor: v.mute.withValues(alpha: .4),
    );
  }
}

/// Confirm dialog styled like Veyro modals. Returns true when confirmed.
Future<bool> showVeyroConfirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  String cancelLabel = 'Cancel',
  bool destructive = false,
}) async {
  final v = context.veyro;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: v.card,
      insetPadding: const EdgeInsets.all(28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title.toUpperCase(),
              style: VeyroText.display(32, color: v.ink),
            ),
            const SizedBox(height: 12),
            Text(message, style: VeyroText.body(14, color: v.mute)),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: FilledButton(
                onPressed: () => Navigator.pop(context, true),
                style: FilledButton.styleFrom(
                  backgroundColor: destructive ? VeyroColors.danger : v.acc,
                  foregroundColor: destructive
                      ? Colors.white
                      : VeyroColors.onAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: VeyroText.body(16, weight: FontWeight.w700),
                ),
                child: Text(confirmLabel),
              ),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              style: TextButton.styleFrom(foregroundColor: v.ink),
              child: Text(
                cancelLabel,
                style: VeyroText.body(15, weight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  return result ?? false;
}

/// Width at which two-column layouts kick in (tablet portrait and up).
const double kVeyroWideBreakpoint = 720;

/// Lays out [left] and [right] side by side when there is room, otherwise
/// stacks them (or uses [compact] when given). Children are spaced by [gap].
/// Intended to sit inside a scrolling list.
class VTwoColumn extends StatelessWidget {
  const VTwoColumn({
    required this.left,
    required this.right,
    this.compact,
    this.gap = 12,
    this.leftFlex = 1,
    this.rightFlex = 1,
    super.key,
  });

  final List<Widget> left;
  final List<Widget> right;

  /// Children for the narrow layout; defaults to [left] followed by [right].
  final List<Widget>? compact;
  final double gap;
  final int leftFlex;
  final int rightFlex;

  Widget _column(List<Widget> children, {CrossAxisAlignment? align}) => Column(
    crossAxisAlignment: align ?? CrossAxisAlignment.stretch,
    children: [
      for (final (i, c) in children.indexed) ...[
        if (i > 0) SizedBox(height: gap),
        c,
      ],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < kVeyroWideBreakpoint) {
          return _column(compact ?? [...left, ...right]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: leftFlex, child: _column(left)),
            SizedBox(width: gap + 4),
            Expanded(flex: rightFlex, child: _column(right)),
          ],
        );
      },
    );
  }
}
