import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';
import 'package:go_router/go_router.dart';

class ReconnectQrButton extends StatelessWidget {
  const ReconnectQrButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSize.buttonHeight,
      child: OutlinedButton(
        onPressed: () => context.pushNamed(AppRoutes.qrScanner),
        style: OutlinedButton.styleFrom(
          elevation: AppSize.elevationNone,
          backgroundColor: Colors.white,
          side: const BorderSide(
            color: Color(0xFF9E9E9E),
            width: AppSize.borderWidth,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.radiusSm),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.qr_code_scanner,
              size: AppSize.iconSm,
              color: Color(0xFF212121),
            ),
            SizedBox(width: AppSpacing.sm),
            Text(
              AppStrings.scanQrCode,
              style: TextStyle(
                fontSize: AppSize.textXs,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212121),
                letterSpacing: AppSize.letterSpacingNone,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
