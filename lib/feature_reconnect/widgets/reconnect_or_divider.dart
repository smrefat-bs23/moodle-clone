import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';

class ReconnectOrDivider extends StatelessWidget {
  const ReconnectOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: Color(0xFFEEEEEE),
            thickness: AppSize.dividerThickness,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            AppStrings.or,
            style: TextStyle(
              fontSize: AppSize.textMd,
              fontWeight: FontWeight.w400,
              color: Color(0xFF757575),
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Color(0xFFEEEEEE),
            thickness: AppSize.dividerThickness,
          ),
        ),
      ],
    );
  }
}
