// ignore_for_file: comment_references

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

/// Small loading row shown beneath the Base URL input while a lookup
/// is in flight.
class SuggestionLoadingWidget extends StatelessWidget {
  /// Creates a [SuggestionLoadingWidget].
  const SuggestionLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSize.suggestionTileVerticalPadding,
      ),
      child: Row(
        children: [
          SizedBox(
            height: AppSize.suggestionIconSize,
            width: AppSize.suggestionIconSize,
            child: CircularProgressIndicator(
              strokeWidth: AppSize.dividerThickness + 1,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            AppStrings.suggestionLoadingLabel,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}