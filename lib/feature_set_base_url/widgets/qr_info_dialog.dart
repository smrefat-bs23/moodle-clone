// ignore_for_file: comment_references

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_set_base_url/strings/base_url_strings.dart';
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';

/// Modal dialog explaining the QR code scanner.
///
/// Reached from the QR scanner page when the user taps the help icon.
class QrInfoDialog extends StatelessWidget {
  /// Creates a [QrInfoDialog].
  const QrInfoDialog({super.key});

  /// Convenience helper to show the dialog from a [BuildContext].
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => const QrInfoDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.radiusLg),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.qr_code_2,
              size: AppSize.iconXl,
              color: Color(0xFF212121),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              BaseUrlStrings.qrInfoTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppSize.fontLg,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212121),
                letterSpacing: AppSize.letterSpacingNone,
                height: AppSize.lineHeight,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              BaseUrlStrings.qrInfoBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppSize.fontSm,
                fontWeight: FontWeight.w400,
                color: Color(0xFF666666),
                letterSpacing: AppSize.letterSpacingNone,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: AppSize.qrButtonHeight,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF212121),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSize.qrButtonRadius),
                  ),
                ),
                child: const Text(
                  BaseUrlStrings.qrInfoGotIt,
                  style: TextStyle(
                    fontSize: AppSize.fontSm,
                    fontWeight: FontWeight.w600,
                    letterSpacing: AppSize.letterSpacingNone,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
