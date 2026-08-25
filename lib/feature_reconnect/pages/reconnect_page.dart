import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/forgot_password.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/login_button.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/password_field.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/reconnect_header.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/reconnect_logo.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/reconnect_or_divider.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/reconnect_qr_button.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/user_avatar.dart';
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';

class ReconnectPage extends StatefulWidget {
  const ReconnectPage({super.key});

  @override
  State<ReconnectPage> createState() => _ReconnectPageState();
}

class _ReconnectPageState extends State<ReconnectPage> {
  bool _hasPassword = false;

  void _onPasswordChanged(String value) {
    final hasPassword = value.trim().isNotEmpty;

    if (_hasPassword != hasPassword) {
      setState(() {
        _hasPassword = hasPassword;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.mdLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xxs),

              const ReconnectHeader(),

              const SizedBox(height: AppSpacing.md),

              const ReconnectLogo(),

              const SizedBox(height: AppSpacing.lgXs),

              const UserAvatar(),

              const SizedBox(height: AppSpacing.xlSm),

              PasswordField(onChanged: _onPasswordChanged),

              const SizedBox(height: AppSpacing.lgMd),

              LoginButton(isEnabled: _hasPassword),

              const SizedBox(height: AppSpacing.lg),

              const ForgotPassword(),

              const SizedBox(height: AppSpacing.lg),

              const ReconnectOrDivider(),

              const SizedBox(height: AppSpacing.mdLg),

              const ReconnectQrButton(),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
