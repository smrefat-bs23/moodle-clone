// ignore_for_file: comment_references

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_set_base_url/strings/base_url_strings.dart';
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';
import 'package:go_router/go_router.dart';

/// App settings page reached from the gear icon in the Set Base URL
/// header.
///
/// Pixel-perfect with the official Moodle app: simple back arrow +
/// title header, list rows with chevrons, and a footer version label.
class AppSettingsPage extends StatelessWidget {
  /// Creates a [AppSettingsPage].
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AppSettingsHeader(onBack: () => context.pop()),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                children: const [
                  _SettingsRow(label: BaseUrlStrings.appSettingsLanguage),
                  _SettingsRow(label: BaseUrlStrings.appSettingsTextSize),
                  _SettingsRow(label: BaseUrlStrings.appSettingsSyncOverWifi),
                  _SettingsRow(label: BaseUrlStrings.appSettingsStorage),
                  _SettingsRow(label: BaseUrlStrings.appSettingsNotifications),
                  _SettingsRow(label: BaseUrlStrings.appSettingsAbout),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppSettingsHeader extends StatelessWidget {
  const _AppSettingsHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.headerHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onBack,
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
          const Text(
            BaseUrlStrings.appSettingsTitle,
            style: TextStyle(
              fontSize: AppSize.fontLg,
              fontWeight: FontWeight.w500,
              color: Color(0xFF212121),
              letterSpacing: AppSize.letterSpacingTight,
              height: AppSize.lineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.mdLg,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: AppSize.fontMd,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF212121),
                  letterSpacing: AppSize.letterSpacingNone,
                  height: AppSize.lineHeight,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: AppSize.iconMd,
              color: Color(0xFF757575),
            ),
          ],
        ),
      ),
    );
  }
}
