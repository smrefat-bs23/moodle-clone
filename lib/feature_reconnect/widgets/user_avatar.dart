import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          width: AppSize.avatarSize,
          height: AppSize.avatarSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFE8ECEF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                AppStrings.userInitials,
                style: TextStyle(
                  fontSize: AppSize.avatarInitialSize,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF37474F),
                  letterSpacing: AppSize.letterSpacingNone,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.mdSm),
        Text(
          AppStrings.userName,
          style: TextStyle(
            fontSize: AppSize.textSm,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
            letterSpacing: AppSize.letterSpacingNone,
          ),
        ),
      ],
    );
  }
}
