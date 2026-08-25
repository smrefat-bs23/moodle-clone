import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(AppSize.radiusXs),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.lostPassword,
                style: TextStyle(
                  fontSize: AppSize.textMd,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF212121),
                ),
              ),
              const SizedBox(height: AppSpacing.tiny),
              SizedBox(
                width: AppSize.forgotPasswordUnderlineWidth,
                child: const Divider(
                  height: AppSize.dividerThickness,
                  thickness: AppSize.dividerThickness,
                  color: Color(0xFF212121),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
