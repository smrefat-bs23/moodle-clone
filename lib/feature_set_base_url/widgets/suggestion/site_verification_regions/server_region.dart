// ignore_for_file: comment_references, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_boilerplate_domain/feature_set_base_url/entities/site_suggestion_entity.dart';

/// "Server" region: Moodle release, version, build id, site id, calendar
/// type, and concurrent-logins limit. The release + version come from
/// the typed entity fields; everything else comes from `raw`.
class ServerRegion extends StatelessWidget {
  const ServerRegion({required this.suggestion, super.key});

  final SiteSuggestionEntity suggestion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final raw = suggestion.raw;

    final release = suggestion.release.trim();
    final version = suggestion.version.trim();
    final siteid = _readInt(raw['siteid']);
    final calendar = raw['sitecalendartype']?.toString().trim() ?? '';
    final concurrent = _readInt(raw['limitconcurrentlogins']);
    final build = _extractBuild(release);

    final rows = <Widget>[
      if (release.isNotEmpty && version.isNotEmpty)
        _ServerRow(
          label: 'Moodle',
          value: '$release  ·  $version',
          emphasised: true,
        )
      else
        _ServerRow(label: 'Moodle', value: release + version),
      if (build != null)
        _ServerRow(label: AppStrings.verificationRegionBuild, value: build),
      _ServerRow(
        label: AppStrings.verificationRegionSiteId,
        value: siteid == null
            ? AppStrings.suggestionVersionUnavailable
            : siteid.toString(),
      ),
      _ServerRow(
        label: AppStrings.verificationRegionCalendar,
        value: calendar.isEmpty
            ? AppStrings.suggestionVersionUnavailable
            : calendar,
      ),
      _ServerRow(
        label: AppStrings.verificationRegionConcurrentLogins,
        value: concurrent == null
            ? AppStrings.suggestionVersionUnavailable
            : concurrent == 0
                ? AppStrings.verificationRegionConcurrentLoginsUnlimited
                : concurrent.toString(),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows
            .map((r) => DefaultTextStyle.merge(
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  child: r,
                ))
            .toList(growable: false),
      ),
    );
  }

  /// Extracts "20260216" out of "5.0.6 (Build: 20260216)".
  static String? _extractBuild(String release) {
    final m = RegExp(r'Build:\s*([0-9]+)').firstMatch(release);
    return m?.group(1);
  }

  static int? _readInt(Object? v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }
}

class _ServerRow extends StatelessWidget {
  const _ServerRow({
    required this.label,
    required this.value,
    this.emphasised = false,
  });

  final String label;
  final String value;
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSize.verificationKeyColumnWidth,
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppSize.verificationKeyFontSize,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize:
                    emphasised ? AppSize.verificationValueFontSize : AppSize.verificationValueFontSize - 1,
                fontWeight: emphasised ? FontWeight.w600 : FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
