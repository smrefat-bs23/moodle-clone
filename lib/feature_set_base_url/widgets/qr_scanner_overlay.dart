// ignore_for_file: comment_references

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';

/// Visual overlay for the QR scanner — a darkened scrim with a square
/// "viewfinder" cut out so the camera preview is visible only through
/// that region.
///
/// Implemented with [CustomPaint] so we don't have to rely on any
/// non-`lib/` assets for the cutout shape.
class QrScannerOverlay extends StatelessWidget {
  /// Creates a [QrScannerOverlay].
  const QrScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ViewfinderPainter(
        scrim: Colors.black.withValues(alpha: 0.5),
        border: Colors.white,
      ),
    );
  }
}

class _ViewfinderPainter extends CustomPainter {
  _ViewfinderPainter({required this.scrim, required this.border});

  final Color scrim;
  final Color border;

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.shortestSide * 0.7;
    final left = (size.width - side) / 2;
    final top = (size.height - side) / 2;
    final rect = Rect.fromLTWH(left, top, side, side);

    final outerPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutout = Path()..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(AppSize.radiusLg)));
    final scrimPath = Path.combine(PathOperation.difference, outerPath, cutout);

    canvas.drawPath(scrimPath, Paint()..color = scrim);

    final borderPaint = Paint()
      ..color = border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(AppSize.radiusLg)), borderPaint);
  }

  @override
  bool shouldRepaint(covariant _ViewfinderPainter oldDelegate) =>
      oldDelegate.scrim != scrim || oldDelegate.border != border;
}