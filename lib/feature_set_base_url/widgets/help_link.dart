import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/routes/app_routes.dart';
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';
import 'package:go_router/go_router.dart';

class HelpLink extends StatelessWidget {
  const HelpLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () => context.pushNamed(AppRoutes.help),
        borderRadius: BorderRadius.circular(AppSize.helpBorderRadius),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSize.helpVerticalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.needHelp,
                style: TextStyle(
                  fontSize: AppSize.helpFontSize,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF212121),
                ),
              ),
              SizedBox(height: AppSize.helpDividerHeight),
              SizedBox(
                width: AppSize.helpDividerWidth,
                child: Divider(
                  height: AppSize.helpDividerHeight,
                  thickness: AppSize.helpDividerThickness,
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
