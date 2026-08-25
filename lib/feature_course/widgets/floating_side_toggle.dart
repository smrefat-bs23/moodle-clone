import 'package:flutter/material.dart';

/// A pixel-perfect, responsive floating side-panel toggle button.
class FloatingSideToggle extends StatelessWidget {
  /// Creates a [FloatingSideToggle].
  const FloatingSideToggle({super.key});

  @override
  Widget build(BuildContext context) {
    const customShape = BorderRadius.horizontal(left: Radius.circular(24));

    return Positioned(
      // Shifted relative to screen width to match card edge exactly
      right: 4,
      top: 165,
      child: Container(
        width: 28,
        height: 48,
        decoration: const BoxDecoration(
          borderRadius: customShape,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(-1, 2),
            ),
          ],
        ),
        child: Material(
          color: const Color(0xFFD2DADC),
          borderRadius: customShape,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {},
            child: const Center(
              child: Icon(
                Icons.chevron_left,
                size: 20,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
