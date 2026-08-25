import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';

class ReconnectHeader extends StatelessWidget {
  const ReconnectHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.headerHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: AppSize.headerIconButtonSize,
              minHeight: AppSize.headerIconButtonSize,
            ),
            icon: const Icon(
              Icons.arrow_back,
              size: AppSize.headerIconSize,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(width: AppSpacing.mdLg),
          const Text(
            AppStrings.reconnect,
            style: TextStyle(
              fontSize: AppSize.headerTitleSize,
              fontWeight: FontWeight.w700,
              color: Color(0xFF212121),
              letterSpacing: AppSize.headerLetterSpacing,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: AppSize.headerIconButtonSize,
              minHeight: AppSize.headerIconButtonSize,
            ),
            icon: const Icon(
              Icons.help_outline,
              size: AppSize.headerIconSize,
              color: Color(0xFF212121),
            ),
          ),
        ],
      ),
    );
  }
}
