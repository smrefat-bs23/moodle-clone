// ignore_for_file: comment_references, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/suggestion/site_verification_regions/function_list_sheet.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_boilerplate_domain/feature_set_base_url/entities/site_suggestion_entity.dart';

/// "Web Services" region: a single chip with the count of enabled
/// functions and a tap-to-open bottom sheet that lists them all.
class WebServicesRegion extends StatelessWidget {
  const WebServicesRegion({required this.suggestion, super.key});

  final SiteSuggestionEntity suggestion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final functions = (suggestion.raw['functions'] as List?) ?? const [];
    final count = functions.length;

    if (count == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Text(
          AppStrings.suggestionVersionUnavailable,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSize.radiusFull),
            onTap: () => FunctionListSheet.show(context, functions),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSize.verificationChipHorizontalPadding,
                vertical: AppSize.verificationChipVerticalPadding,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSize.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.developer_mode_outlined,
                    size: AppSize.verificationIconSm,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Text(
                    '$count ${AppStrings.verificationRegionWebServiceSummary}',
                    style: TextStyle(
                      fontSize: AppSize.verificationChipFontSize,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Icon(
                    Icons.chevron_right,
                    size: AppSize.verificationIconSm,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
