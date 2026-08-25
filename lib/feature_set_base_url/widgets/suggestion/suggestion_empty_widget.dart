// ignore_for_file: comment_references

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

/// Empty-state widget shown when the suggestion lookup returns no
/// results for the current query.
class SuggestionEmptyWidget extends StatelessWidget {
  /// Creates a [SuggestionEmptyWidget].
  const SuggestionEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSize.suggestionTileVerticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.suggestionEmptyLabel,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            AppStrings.suggestionEmptyHint,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}