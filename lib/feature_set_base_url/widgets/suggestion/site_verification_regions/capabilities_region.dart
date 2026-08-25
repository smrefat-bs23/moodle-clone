// ignore_for_file: comment_references, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_boilerplate_domain/feature_set_base_url/entities/site_suggestion_entity.dart';

/// "Capabilities" region: feature chips driven by the `advancedfeatures[]`
/// array in the payload. Off-flags render as muted strikethrough chips,
/// on-flags render as filled check chips. Unknown feature names are
/// surfaced as raw name chips so nothing in the payload is silently
/// dropped.
class CapabilitiesRegion extends StatelessWidget {
  const CapabilitiesRegion({required this.suggestion, super.key});

  final SiteSuggestionEntity suggestion;

  /// Maps the Moodle `advancedfeatures[].name` to its display label.
  /// Anything not in this map is rendered as the raw name (capitalised)
  /// so the UI degrades gracefully if Moodle adds a new flag.
  static const Map<String, String> _knownFeatures = {
    'usecomments': AppStrings.featureComments,
    'usetags': AppStrings.featureTags,
    'enablenotes': AppStrings.featureNotes,
    'messaging': AppStrings.featureMessaging,
    'enableblogs': AppStrings.featureBlogs,
    'enablecompletion': AppStrings.featureCompletion,
    'enablebadges': AppStrings.featureBadges,
    'enablecustomreports': AppStrings.featureCustomReports,
    'enablecompetencies': AppStrings.featureCompetencies,
    'enableglobalsearch': AppStrings.featureGlobalSearch,
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final raw = suggestion.raw['advancedfeatures'];
    final features = <_Feature>[];

    if (raw is List) {
      for (final f in raw) {
        if (f is Map) {
          final name = f['name']?.toString() ?? '';
          final value = f['value'];
          if (name.isEmpty) continue;
          final isOn = _isOn(value);
          features.add(_Feature(name: name, isOn: isOn));
        }
      }
    }

    if (features.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Text(
          AppStrings.suggestionVersionUnavailable,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    // Sort: enabled flags first, then by display label.
    features.sort((a, b) {
      if (a.isOn != b.isOn) return a.isOn ? -1 : 1;
      return _labelFor(a.name).compareTo(_labelFor(b.name));
    });

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Wrap(
        spacing: AppSize.verificationChipGap,
        runSpacing: AppSize.verificationChipGap,
        children: [
          for (final f in features) _FeatureChip(feature: f),
        ],
      ),
    );
  }

  static String _labelFor(String name) =>
      _knownFeatures[name] ??
      (name.isEmpty
          ? ''
          : '${name[0].toUpperCase()}${name.substring(1)}');

  static bool _isOn(Object? v) {
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v == null) return false;
    final s = v.toString().toLowerCase().trim();
    return s == '1' || s == 'true';
  }
}

class _Feature {
  const _Feature({required this.name, required this.isOn});
  final String name;
  final bool isOn;
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.feature});

  final _Feature feature;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = CapabilitiesRegion._labelFor(feature.name);

    final bg = feature.isOn
        ? colorScheme.secondaryContainer
        : colorScheme.surfaceContainerHighest;
    final fg = feature.isOn
        ? colorScheme.onSecondaryContainer
        : colorScheme.onSurfaceVariant.withValues(alpha: 0.6);
    final icon = feature.isOn ? Icons.check : Icons.remove;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.verificationChipHorizontalPadding,
        vertical: AppSize.verificationChipVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSize.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSize.verificationIconSm, color: fg),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSize.verificationChipFontSize,
              fontWeight: FontWeight.w600,
              color: fg,
              decoration:
                  feature.isOn ? TextDecoration.none : TextDecoration.lineThrough,
            ),
          ),
        ],
      ),
    );
  }
}
