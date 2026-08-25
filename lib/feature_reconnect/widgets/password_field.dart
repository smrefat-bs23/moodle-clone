import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscureText,
      cursorColor: const Color(0xFFF9A865),
      onChanged: widget.onChanged,
      style: const TextStyle(
        fontSize: AppSize.textMd,
        fontWeight: FontWeight.w400,
        color: Color(0xFF212121),
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: false,
        border: InputBorder.none,

        hintText: AppStrings.password,
        hintStyle: const TextStyle(
          fontSize: AppSize.textMd,
          fontWeight: FontWeight.w400,
          color: Color(0xFF212121),
        ),

        contentPadding: const EdgeInsets.only(
          top: AppSpacing.sm,
          bottom: AppSpacing.xs,
        ),

        suffixIconConstraints: const BoxConstraints(
          minWidth: AppSize.suffixIconMinSize,
          minHeight: AppSize.suffixIconMinSize,
        ),

        suffixIcon: IconButton(
          splashRadius: AppSize.iconSplashRadius,
          padding: EdgeInsets.zero,
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(
            _obscureText ? Icons.remove_red_eye : Icons.visibility_off,
            size: AppSize.iconMd,
            color: const Color(0xFF2F2F2F),
          ),
        ),

        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFD0D0D0),
            width: AppSize.passwordUnderlineWidth,
          ),
        ),

        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF9E9E9E),
            width: AppSize.passwordFocusedUnderlineWidth,
          ),
        ),
      ),
    );
  }
}
