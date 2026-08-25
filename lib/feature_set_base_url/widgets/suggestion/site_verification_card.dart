// ignore_for_file: comment_references, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/suggestion/site_verification_regions/capabilities_region.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/suggestion/site_verification_regions/server_region.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/suggestion/site_verification_regions/session_region.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/suggestion/site_verification_regions/site_header_region.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/suggestion/site_verification_regions/site_region.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/suggestion/site_verification_regions/storage_region.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/suggestion/site_verification_regions/web_services_region.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_boilerplate_domain/feature_set_base_url/entities/site_suggestion_entity.dart';

/// Card that visualises a resolved [SiteSuggestionEntity] across seven
/// regions: Site identity, Session identity, Capabilities, Storage,
/// Server environment, and Web Services summary. The header (avatar +
/// fullname) is always visible; the remaining regions can be expanded or
/// collapsed individually so the user controls how much payload they
/// see.
///
/// Three always-visible regions: SiteHeaderRegion, SiteRegion,
/// SessionRegion. The rest default to collapsed.
class SiteVerificationCard extends StatefulWidget {
  /// Creates a [SiteVerificationCard].
  const SiteVerificationCard({required this.suggestion, super.key});

  /// The resolved site suggestion to render.
  final SiteSuggestionEntity suggestion;

  @override
  State<SiteVerificationCard> createState() => _SiteVerificationCardState();
}

class _SiteVerificationCardState extends State<SiteVerificationCard> {
  /// Tracks which of the (Optional / collapsed-by-default) regions the
  /// user has expanded. The always-visible regions are not tracked.
  bool _capabilitiesExpanded = false;
  bool _storageExpanded = false;
  bool _serverExpanded = false;
  bool _webServicesExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.radiusMd),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      // Use a `Material` as the immediate parent of `ExpansionTile` so
      // its internal `ListTile` can paint ink splashes without tripping
      // Flutter's "background color may be invisible" assertion. The
      // card's surface color comes from this Material, not from the
      // outer Container.
      child: Material(
        type: MaterialType.canvas,
        color: colorScheme.surfaceContainerLow,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.verificationRegionInset,
            vertical: AppSize.verificationCardVerticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          SiteHeaderRegion(suggestion: widget.suggestion),
          const SizedBox(height: AppSize.verificationRegionGap),
          const Divider(height: AppSize.lineHeight),
          _ExpandableRegion(
            title: AppStrings.verificationSiteRegion,
            initiallyExpanded: true,
            child: SiteRegion(suggestion: widget.suggestion),
          ),
          const SizedBox(height: AppSize.verificationRegionGap),
          _ExpandableRegion(
            title: AppStrings.verificationSessionRegion,
            initiallyExpanded: true,
            child: SessionRegion(suggestion: widget.suggestion),
          ),
          _ExpandableRegion(
            title: AppStrings.verificationCapabilitiesRegion,
            initiallyExpanded: _capabilitiesExpanded,
            onExpansionChanged: (v) =>
                setState(() => _capabilitiesExpanded = v),
            child: CapabilitiesRegion(suggestion: widget.suggestion),
          ),
          _ExpandableRegion(
            title: AppStrings.verificationStorageRegion,
            initiallyExpanded: _storageExpanded,
            onExpansionChanged: (v) => setState(() => _storageExpanded = v),
            child: StorageRegion(suggestion: widget.suggestion),
          ),
          _ExpandableRegion(
            title: AppStrings.verificationServerRegion,
            initiallyExpanded: _serverExpanded,
            onExpansionChanged: (v) => setState(() => _serverExpanded = v),
            child: ServerRegion(suggestion: widget.suggestion),
          ),
          _ExpandableRegion(
            title: AppStrings.verificationWebServicesRegion,
            initiallyExpanded: _webServicesExpanded,
            onExpansionChanged: (v) =>
                setState(() => _webServicesExpanded = v),
            child: WebServicesRegion(suggestion: widget.suggestion),
          ),
        ],
      ),
        ),
      ),
    );
  }
}

/// Tappable region header that toggles expansion of its [child] when
/// tapped. Mirrors Material's [ExpansionTile] without depending on a
/// fixed leading icon — the header just shows a title and a chevron that
/// reflects the current state.
class _ExpandableRegion extends StatelessWidget {
  const _ExpandableRegion({
    required this.title,
    required this.initiallyExpanded,
    required this.child,
    this.onExpansionChanged,
  });

  final String title;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onExpansionChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Theme(
      // Remove [ExpansionTile]'s default divider.
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        initiallyExpanded: initiallyExpanded,
        onExpansionChanged: onExpansionChanged,
        title: Text(
          title,
          style: TextStyle(
            fontSize: AppSize.verificationRegionHeaderFontSize,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
            letterSpacing: AppSize.letterSpacingNone,
            height: AppSize.lineHeight,
          ),
        ),
        trailing: Icon(
          initiallyExpanded ? Icons.expand_less : Icons.expand_more,
          size: AppSize.verificationIconLg,
          color: colorScheme.onSurfaceVariant,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: AppSize.verificationCardVerticalPadding,
              top: AppSpacing.xs,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}