import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/feature_auth/cubit/login_cubit.dart';
import 'package:flutter_boilerplate/feature_auth/cubit/login_state.dart';
import 'package:flutter_boilerplate/feature_auth/pages/login_page_app_bar.dart';
import 'package:flutter_boilerplate/feature_auth/widgets/login_form.dart';
import 'package:flutter_boilerplate/feature_auth/widgets/login_header.dart';
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Internal scaffold widget for [LoginPage].
///
/// Lives in its own file so [LoginPage] stays focused on dependency
/// injection and routing, and the visual layout (BlocListener, body) can
/// be iterated on without churning the entry-point file. The AppBar is
/// extracted into `login_page_app_bar.dart`.
class LoginPageScaffold extends StatelessWidget {
  /// Creates an instance of [LoginPageScaffold].
  const LoginPageScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
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
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildLoginPageAppBar(context),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
            child: Column(
              children: [
                SizedBox(height: AppSpacing.sm.h),
                const LoginHeader(),
                SizedBox(height: AppSpacing.lg.h),
                const LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
