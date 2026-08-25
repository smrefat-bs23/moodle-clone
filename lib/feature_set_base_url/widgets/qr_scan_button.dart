import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/qr_info_dialog.dart';
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';

class QrScanButton extends StatelessWidget {
  const QrScanButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSize.qrButtonHeight,
      child: OutlinedButton.icon(
        onPressed: () {
          // Tap-only: do NOT navigate to the QR scanner page —
          // just show the informational dialog and dismiss.
          QrInfoDialog.show(context);
        },
        icon: const Icon(
          Icons.qr_code_2,
          size: AppSize.qrIconSize,
          color: Color(0xFF212121),
        ),
        label: const Text(
          AppStrings.scanQrCode,
          style: TextStyle(
            fontSize: AppSize.qrButtonFontSize,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
            letterSpacing: AppSize.qrButtonLetterSpacing,
          ),
        ),
        style: OutlinedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.white,
          side: const BorderSide(
            color: Color(0xFF1E1E1E),
            width: AppSize.borderWidthNone,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.qrButtonRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        ),
      ),
    );
  }
}
