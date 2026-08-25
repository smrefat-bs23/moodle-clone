// ignore_for_file: comment_references

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_set_base_url/constants/base_url_constants.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

/// The "Connect to your site" row shown beneath the URL input.
///
/// Pixel-perfect with the official Moodle mobile app: a row with a
/// 40×40 rounded square containing the pencil icon on the left, a
/// title + subtitle column in the middle, and a chevron on the right.
/// The icon container has a light grey border — matching the tile
/// style in the official Moodle app.
class ConnectToYourSiteTile extends StatelessWidget {
  /// Creates a [ConnectToYourSiteTile].
  const ConnectToYourSiteTile({
    required this.typedValue,
    this.onTap,
    super.key,
  });

  /// The URL the user has typed into the input. Displayed as the subtitle.
  final String typedValue;

  /// Optional tap callback. When supplied, the tile responds to touch
  /// with a ripple.
  final VoidCallback? onTap;

  /// Decorative icon container: 40×40 with a light-grey border.
  Widget get _iconContainer => Container(
        width: BaseUrlConstants.connectTileIconSize,
        height: BaseUrlConstants.connectTileIconSize,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            BaseUrlConstants.connectTileIconRadius,
          ),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.edit_outlined,
          size: AppSize.iconMd,
          color: Color(0xFF212121),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final tile = Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.xxs,
      ),
      child: Row(
        children: [
          _iconContainer,
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  AppStrings.connectToYourSite,
                  style: TextStyle(
                    fontSize: AppSize.fontMd,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF212121),
                    letterSpacing: AppSize.letterSpacingNone,
                    height: AppSize.lineHeight,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  typedValue,
                  style: const TextStyle(
                    fontSize: AppSize.fontSm,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF666666),
                    letterSpacing: AppSize.letterSpacingNone,
                    height: AppSize.lineHeight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(
            Icons.chevron_right,
            size: AppSize.iconMd,
            color: Color(0xFF757575),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return tile;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: tile,
      ),
    );
  }
}