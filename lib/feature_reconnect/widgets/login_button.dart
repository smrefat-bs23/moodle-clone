import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key, required this.isEnabled});

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSize.buttonHeight,
      child: ElevatedButton(
        onPressed: isEnabled ? () {} : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? const Color(0xFFF9A865)
              : const Color(0xFFFCD5B5),
          disabledBackgroundColor: const Color(0xFFFCD5B5),
          disabledForegroundColor: const Color(0xFF212121),
          elevation: AppSize.elevationNone,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.radiusSm),
          ),
        ),
        child: const Text(
          AppStrings.login,
          style: TextStyle(
            fontSize: AppSize.textSm,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
            letterSpacing: AppSize.letterSpacingSm,
          ),
        ),
      ),
    );
  }
}
