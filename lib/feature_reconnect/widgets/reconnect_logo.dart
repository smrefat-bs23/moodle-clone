import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';

class ReconnectLogo extends StatelessWidget {
  const ReconnectLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          AppStrings.siteName,
          style: TextStyle(
            fontSize: AppSize.logoTitleSize,
            fontWeight: FontWeight.w700,
            color: Color(0xFF212121),
            letterSpacing: AppSize.headerLetterSpacing,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          AppStrings.siteUrl,
          style: TextStyle(
            fontSize: AppSize.textSm,
            fontWeight: FontWeight.w400,
            color: Color(0xFF616161),
            letterSpacing: AppSize.letterSpacingNone,
          ),
        ),
      ],
    );
  }
}
