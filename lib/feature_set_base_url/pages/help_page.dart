// ignore_for_file: comment_references

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_set_base_url/strings/base_url_strings.dart';
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';
import 'package:go_router/go_router.dart';

/// Help page reached from the Set Base URL page.
///
/// Pixel-perfect with the official Moodle app: white background, simple
/// back arrow + title header, a list of help items with chevrons, and a
/// version label at the bottom.
class HelpPage extends StatelessWidget {
  /// Creates a [HelpPage].
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HelpHeader(onBack: () => context.pop()),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                itemCount: BaseUrlStrings.helpItems.length,
                separatorBuilder: (_, __) => const Divider(
                  height: AppSize.lineHeight,
                  thickness: AppSize.dividerThickness,
                  color: Color(0xFFE0E0E0),
                  indent: AppSpacing.md,
                  endIndent: AppSpacing.md,
                ),
                itemBuilder: (context, index) {
                  final label = BaseUrlStrings.helpItems[index];
                  return _HelpRow(label: label);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.lg,
              ),
              child: Center(
                child: Text(
                  BaseUrlStrings.helpVersion,
                  style: TextStyle(
                    fontSize: AppSize.fontXs,
                    fontWeight: FontWeight.w400,
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: AppSize.letterSpacingNone,
                    height: AppSize.lineHeight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpHeader extends StatelessWidget {
  const _HelpHeader({required this.onBack});

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
            BaseUrlStrings.helpTitle,
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

class _HelpRow extends StatelessWidget {
  const _HelpRow({required this.label});

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
