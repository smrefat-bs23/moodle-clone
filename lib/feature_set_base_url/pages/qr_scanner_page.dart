// ignore_for_file: comment_references

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/qr_scanner_overlay.dart';
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';
import 'package:go_router/go_router.dart';

/// QR scanner page reached from the Set Base URL page.
///
/// Pixel-perfect match with the official Moodle app: solid black
/// background, a rounded-square viewfinder cutout in the center, a
/// × close button on the top-left, a ⚡ flash button on the top-right,
/// and a hint label at the bottom.
///
/// The actual camera feed requires a native plugin (out of scope for
/// `lib/`-only changes). The viewfinder presentation here is the
/// placeholder that the camera preview will sit behind.
class QrScannerPage extends StatelessWidget {
  /// Creates a [QrScannerPage].
  const QrScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Solid black background.
          const Positioned.fill(
            child: ColoredBox(color: Colors.black),
          ),
          // Viewfinder overlay.
          const Positioned.fill(child: QrScannerOverlay()),
          // Top bar — close + flash.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: AppSize.iconLg,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.flash_on,
                        color: Colors.white,
                        size: AppSize.iconLg,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom hint.
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Center(
                  child: Text(
                    'Align the QR code inside the frame',
                    style: TextStyle(
                      fontSize: AppSize.fontSm,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.8),
                      letterSpacing: AppSize.letterSpacingNone,
                      height: AppSize.lineHeight,
                    ),
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