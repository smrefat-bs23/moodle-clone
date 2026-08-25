// ignore_for_file: comment_references, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_boilerplate_domain/feature_set_base_url/entities/site_suggestion_entity.dart';

/// Header region: network avatar (or initial-letter fallback) plus the
/// user's fullname headline and "Signed in as <username>" / "Guest
/// session" sub-label.
class SiteHeaderRegion extends StatelessWidget {
  const SiteHeaderRegion({required this.suggestion, super.key});

  final SiteSuggestionEntity suggestion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isAuth = suggestion.isAuthenticated;
    final username = suggestion.username.trim();
    final fullname = suggestion.fullname.trim();

    final headline = isAuth && fullname.isNotEmpty
        ? fullname
        : isAuth && username.isNotEmpty
            ? username
            : suggestion.sitename.trim().isNotEmpty
                ? suggestion.sitename
                : suggestion.siteUrl;

    final subline = isAuth && username.isNotEmpty
        ? '${AppStrings.suggestionSignedInAs} $username'
        : isAuth
            ? AppStrings.suggestionAuthenticatedBadge
            : AppStrings.suggestionGuestSession;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _Avatar(suggestion: suggestion),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  headline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  subline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
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

/// Rounded avatar with the user's profile picture (loaded from
/// `userpictureurl`) when available, otherwise an initial-letter circle.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.suggestion});

  final SiteSuggestionEntity suggestion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pictureUrl = suggestion.raw['userpictureurl']?.toString().trim() ?? '';

    if (pictureUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          pictureUrl,
          width: AppSize.verificationAvatarSize,
          height: AppSize.verificationAvatarSize,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return SizedBox(
              width: AppSize.verificationAvatarSize,
              height: AppSize.verificationAvatarSize,
              child: Center(
                child: SizedBox(
                  width: AppSize.verificationIconMd,
                  height: AppSize.verificationIconMd,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            );
          },
          errorBuilder: (_, __, ___) => _InitialCircle(suggestion: suggestion),
        ),
      );
    }

    return _InitialCircle(suggestion: suggestion);
  }
}

/// Initial-letter circle used as the avatar fallback when
/// `userpictureurl` is empty or fails to load.
class _InitialCircle extends StatelessWidget {
  const _InitialCircle({required this.suggestion});

  final SiteSuggestionEntity suggestion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isAuth = suggestion.isAuthenticated;

    final initialSource = suggestion.fullname.trim().isNotEmpty
        ? suggestion.fullname
        : suggestion.username.trim().isNotEmpty
            ? suggestion.username
            : suggestion.sitename.trim().isNotEmpty
                ? suggestion.sitename
                : suggestion.siteUrl;

    final initial = initialSource.isEmpty
        ? '?'
        : initialSource.substring(0, 1).toUpperCase();

    return Container(
      width: AppSize.verificationAvatarSize,
      height: AppSize.verificationAvatarSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isAuth
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
        border: isAuth
            ? null
            : Border.all(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Text(
        initial,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isAuth
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}
