// ignore_for_file: comment_references

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

/// Error-state widget shown when the suggestion lookup fails.
///
/// Surfaces a user-friendly message. The retry button was removed —
/// errors are transient and the user will re-trigger the lookup as
/// soon as they keep typing.
class SuggestionErrorWidget extends StatelessWidget {
  /// Creates a [SuggestionErrorWidget].
  const SuggestionErrorWidget({
    required this.message,
    this.onRetry,
    super.key,
  });

  /// User-facing error message.
  final String message;

  /// Kept for API compatibility but currently unused. Retries happen
  /// automatically when the user keeps typing.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSize.suggestionTileVerticalPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            size: AppSize.suggestionIconSize,
            color: colorScheme.error,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.suggestionErrorLabel,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.error,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  message,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}