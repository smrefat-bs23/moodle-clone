// ignore_for_file: comment_references, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_boilerplate_domain/feature_set_base_url/entities/site_suggestion_entity.dart';

/// "Site" region: sitename (title-sized), siteUrl (muted subtitle),
/// and the theme as a small chip on the right when reported.
class SiteRegion extends StatelessWidget {
  const SiteRegion({required this.suggestion, super.key});

  final SiteSuggestionEntity suggestion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final theme = suggestion.theme.trim();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: AppSize.verificationIconLg,
            color: colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  suggestion.sitename.trim().isEmpty
                      ? suggestion.siteUrl
                      : suggestion.sitename,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  suggestion.siteUrl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (theme.isNotEmpty) ...[
            const SizedBox(width: AppSpacing.sm),
            _ThemeChip(theme: theme),
          ],
        ],
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  const _ThemeChip({required this.theme});

  final String theme;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.verificationChipHorizontalPadding,
        vertical: AppSize.verificationChipVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppSize.radiusFull),
      ),
      child: Text(
        theme,
        style: TextStyle(
          fontSize: AppSize.verificationChipFontSize,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}
