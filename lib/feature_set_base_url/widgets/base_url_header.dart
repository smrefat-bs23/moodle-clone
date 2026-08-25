import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';

class BaseUrlHeader extends StatelessWidget {
  const BaseUrlHeader({this.showBackButton = false, super.key});

  /// Whether to show a leading back button on the left of the header.
  ///
  /// Mirrors the official Moodle mobile app — once the user has typed
  /// into the URL field the header splits from the splash layout and
  /// exposes a back affordance so the user can return to the initial
  /// "Connect to Moodle" splash.
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.headerHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showBackButton) ...[
            IconButton(
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              splashRadius: AppSize.splashRadius,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: AppSize.iconButtonMinSize,
                minHeight: AppSize.iconButtonMinSize,
              ),
              icon: const Icon(
                Icons.arrow_back,
                size: AppSize.iconSettings,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          const Text(
            AppStrings.connectToMoodle,
            style: TextStyle(
              fontSize: AppSize.fontLg,
              fontWeight: FontWeight.w500,
              color: Color(0xFF212121),
              letterSpacing: AppSize.letterSpacingTight,
              height: AppSize.lineHeight,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // Tap-only: no navigation. The ripple / press state still
              // plays so the button feels responsive.
            },
            splashRadius: AppSize.splashRadius,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: AppSize.iconButtonMinSize,
              minHeight: AppSize.iconButtonMinSize,
            ),
            icon: const Icon(
              Icons.settings,
              size: AppSize.iconSettings,
              color: Color(0xFF212121),
            ),
          ),
        ],
      ),
    );
  }
}

