import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

/// Opens the system share sheet with [text]. [context] anchors the popover on
/// iPad.
Future<void> shareSummary(BuildContext context, String text) {
  final box = context.findRenderObject() as RenderBox?;
  final origin = box == null ? null : box.localToGlobal(Offset.zero) & box.size;
  return SharePlus.instance.share(
    ShareParams(text: text, sharePositionOrigin: origin),
  );
}
