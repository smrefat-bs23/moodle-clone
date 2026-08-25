// ignore_for_file: comment_references, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_boilerplate_domain/feature_set_base_url/entities/site_suggestion_entity.dart';

/// "Storage" region: file quota, max upload file size, and whether
/// downloads/uploads are allowed. Reads all values from `raw` because
/// the entity only exposes `username`/`userId` directly.
class StorageRegion extends StatelessWidget {
  const StorageRegion({required this.suggestion, super.key});

  final SiteSuggestionEntity suggestion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final quota = _readInt(suggestion.raw['userquota']);
    final maxFile = _readInt(suggestion.raw['usermaxuploadfilesize']);
    final downloads = _readInt(suggestion.raw['downloadfiles']);
    final uploads = _readInt(suggestion.raw['uploadfiles']);

    final rows = <Widget>[
      _StorageRow(
        label: AppStrings.verificationRegionQuota,
        value: quota == null
            ? AppStrings.suggestionVersionUnavailable
            : _formatBytes(quota),
      ),
      _StorageRow(
        label: AppStrings.verificationRegionMaxFileSize,
        value: maxFile == null
            ? AppStrings.suggestionVersionUnavailable
            : _formatBytes(maxFile),
      ),
      _StorageRow(
        label: AppStrings.verificationRegionDownloads,
        value: _onOffLabel(downloads, AppStrings.verificationRegionDownloadsAllowed,
            AppStrings.verificationRegionDownloadsBlocked),
      ),
      _StorageRow(
        label: AppStrings.verificationRegionUploads,
        value: _onOffLabel(uploads, AppStrings.verificationRegionDownloadsAllowed,
            AppStrings.verificationRegionDownloadsBlocked),
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

  static int? _readInt(Object? v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  static String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var value = bytes.toDouble();
    var i = 0;
    while (value >= 1024 && i < units.length - 1) {
      value /= 1024;
      i++;
    }
    final formatted = value >= 10 || i == 0
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
    return '$formatted ${units[i]}';
  }

  static String _onOffLabel(int? v, String onLabel, String offLabel) {
    if (v == null) return AppStrings.suggestionVersionUnavailable;
    return v != 0 ? onLabel : offLabel;
  }
}

class _StorageRow extends StatelessWidget {
  const _StorageRow({required this.label, required this.value});

  final String label;
  final String value;

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
                fontSize: AppSize.verificationValueFontSize - 1,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
