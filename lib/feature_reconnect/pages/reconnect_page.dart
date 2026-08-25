import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/feature_auth/cubit/login_cubit.dart';
import 'package:flutter_boilerplate/feature_auth/cubit/login_state.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/forgot_password.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/login_button.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/password_field.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/reconnect_header.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/reconnect_logo.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/reconnect_or_divider.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/reconnect_qr_button.dart';
import 'package:flutter_boilerplate/feature_reconnect/widgets/user_avatar.dart';
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:flutter_boilerplate/src/injection/di.dart' as di;
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';
import 'package:flutter_boilerplate_core/utils/storage/local_storage.dart';
import 'package:go_router/go_router.dart';

/// Reconnect screen — shown when a site is saved but the user is logged
/// out. Asks only for the password; the username is read back from
/// [AppConstants.usernameKey], persisted by a prior successful login.
class ReconnectPage extends StatefulWidget {
  const ReconnectPage({super.key});

  @override
  State<ReconnectPage> createState() => _ReconnectPageState();
}

class _ReconnectPageState extends State<ReconnectPage> {
  bool _hasPassword = false;
  String _password = '';

  void _onPasswordChanged(String value) {
    _password = value;
    final hasPassword = value.trim().isNotEmpty;

    if (_hasPassword != hasPassword) {
      setState(() {
        _hasPassword = hasPassword;
      });
    }
  }

  Future<void> _onLoginPressed(BuildContext context) async {
    final (username, _) =
        await di.getIt<LocalStorage>().get<String>(AppConstants.usernameKey);
    if (!context.mounted || username == null || username.isEmpty) return;
    context.read<LoginCubit>().login(username: username, password: _password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.getIt<LoginCubit>(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          state.whenOrNull(
            success: () => context.go(AppRoutes.dashboard),
            error: (message) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            ),
          );
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.mdLg,
              ),
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

                  LoginButton(
                    isEnabled: _hasPassword,
                    onPressed: () => _onLoginPressed(context),
                  ),

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
        ),
      ),
    );
  }
}
