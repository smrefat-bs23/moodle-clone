// ignore_for_file: comment_references, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_boilerplate_domain/feature_set_base_url/entities/site_suggestion_entity.dart';

/// "Session" region: language, admin badge, and the site-policy
/// agreement status. Driven entirely off `raw` keys the entity does not
/// expose directly.
class SessionRegion extends StatelessWidget {
  const SessionRegion({required this.suggestion, super.key});

  final SiteSuggestionEntity suggestion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isAdmin = _readBool(suggestion.raw['userissiteadmin']);
    final policyAgreed = _readInt(suggestion.raw['policyagreed']) == 1;
    final lang = (suggestion.raw['lang']?.toString() ?? '').trim();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Wrap(
        spacing: AppSize.verificationChipGap,
        runSpacing: AppSize.verificationChipGap,
        children: [
          if (isAdmin == true)
            _StatusChip(
              label: AppStrings.verificationRegionBadge,
              icon: Icons.admin_panel_settings_outlined,
              background: colorScheme.primaryContainer,
              foreground: colorScheme.onPrimaryContainer,
            ),
          _StatusChip(
            label: policyAgreed
                ? AppStrings.verificationRegionPolicyAgreed
                : AppStrings.verificationRegionPolicyRequired,
            icon: policyAgreed ? Icons.verified_outlined : Icons.warning_amber_outlined,
            background: policyAgreed
                ? colorScheme.surfaceContainerHighest
                : const Color(0xFFFFF4E5),
            foreground: policyAgreed
                ? colorScheme.onSurfaceVariant
                : const Color(0xFF8A4B00),
          ),
          if (lang.isNotEmpty)
            _StatusChip(
              label: '${AppStrings.verificationRegionLanguage}: $lang',
              icon: Icons.language_outlined,
              background: colorScheme.surfaceContainerHighest,
              foreground: colorScheme.onSurfaceVariant,
            ),
          if (isAdmin == null && !policyAgreed == false)
            Text(
              '—',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  /// Best-effort bool reader — accepts bool, int, "1"/"0", "true"/"false".
  static bool? _readBool(Object? v) {
    if (v == null) return null;
    if (v is bool) return v;
    if (v is int) return v != 0;
    if (v is num) return v != 0;
    final s = v.toString().toLowerCase().trim();
    if (s == '1' || s == 'true') return true;
    if (s == '0' || s == 'false') return false;
    return null;
  }

  static int? _readInt(Object? v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.verificationChipHorizontalPadding,
        vertical: AppSize.verificationChipVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSize.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSize.verificationIconSm, color: foreground),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSize.verificationChipFontSize,
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}