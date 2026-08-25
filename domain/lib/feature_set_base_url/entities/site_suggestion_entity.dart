// ignore_for_file: comment_references

/// Domain entity representing a suggested Moodle site resolved from the
/// user's base URL input.
///
/// Backed by Moodle's `core_webservice_get_site_info` endpoint: when the
/// user types a URL into the input, the app calls the endpoint and, on
/// success, exposes the resolved site info as a "suggestion" the user can
/// confirm by tapping the input.
library site_suggestion_entity;

import 'package:meta/meta.dart';

/// Domain entity for a single resolved Moodle site suggestion.
@immutable
class SiteSuggestionEntity {
  /// Creates a [SiteSuggestionEntity].
  const SiteSuggestionEntity({
    required this.sitename,
    required this.siteUrl,
    required this.username,
    required this.userId,
    required this.raw,
    this.release = '',
    this.version = '',
    this.theme = '',
    this.fullname = '',
  });

  /// Friendly name of the Moodle site (e.g. "Campus LMS").
  final String sitename;

  /// Base URL of the Moodle site as reported by the server.
  final String siteUrl;

  /// Username of the authenticated user (may be empty for guest sessions).
  final String username;

  /// Numeric user id of the authenticated user. `null` for guest sessions.
  final int? userId;

  /// Moodle release codename reported by the server (e.g. "4.5").
  ///
  /// May be empty if the server doesn't expose the field.
  final String release;

  /// Moodle version number reported by the server (e.g. "2024042500").
  ///
  /// May be empty if the server doesn't expose the field.
  final String version;

  /// Moodle theme name reported by the server (e.g. "mb2nl").
  ///
  /// May be empty if the server doesn't expose the field.
  final String theme;

  /// Full display name of the authenticated user (e.g. "Student User").
  ///
  /// May be empty if the server doesn't expose the field or for guests.
  final String fullname;

  /// Original JSON map from the Moodle response.
  final Map<String, dynamic> raw;

  /// Whether the suggestion reflects an authenticated (non-guest) user.
  bool get isAuthenticated => userId != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SiteSuggestionEntity &&
        other.sitename == sitename &&
        other.siteUrl == siteUrl &&
        other.username == username &&
        other.userId == userId &&
        other.release == release &&
        other.version == version &&
        other.theme == theme &&
        other.fullname == fullname;
  }

  @override
  int get hashCode => Object.hash(
        sitename,
        siteUrl,
        username,
        userId,
        release,
        version,
        theme,
        fullname,
      );

  @override
  String toString() => 'SiteSuggestionEntity('
      'sitename: $sitename, siteUrl: $siteUrl, '
      'username: $username, fullname: $fullname, '
      'release: $release, version: $version, theme: $theme, '
      'userId: $userId)';
}
