// ignore_for_file: comment_references, sort_constructors_first

/// Domain entity representing the payload returned by Moodle's
/// `core_webservice_get_site_info` web service.
library site_info_entity;

import 'package:meta/meta.dart';

/// Domain entity representing the payload returned by Moodle's
/// `core_webservice_get_site_info` web service.
@immutable
class SiteInfoEntity {
  /// Creates a [SiteInfoEntity].
  const SiteInfoEntity({
    required this.sitename,
    required this.username,
    required this.userId,
    required this.siteUrl,
    required this.raw,
  });

  /// Friendly name of the Moodle site.
  final String sitename;

  /// Username of the authenticated user (may be empty for guest sessions).
  final String username;

  /// Numeric user id of the authenticated user. `null` for guest sessions.
  final int? userId;

  /// Base URL of the Moodle site.
  final String siteUrl;

  /// Original JSON map from the Moodle response. Useful for fields not
  /// modelled here (e.g. `firstname`, `lastname`, `lang`, `functions`).
  final Map<String, dynamic> raw;

  /// Whether this response is for an authenticated (non-guest) user.
  bool get isAuthenticated => userId != null;

  /// Create an entity from the JSON map returned by Moodle.
  factory SiteInfoEntity.fromJson(Map<String, dynamic> json) {
    return SiteInfoEntity(
      sitename: (json['sitename'] as String?) ?? '',
      username: (json['username'] as String?) ?? '',
      userId: json['userid'] is int ? json['userid'] as int : null,
      siteUrl: (json['siteurl'] as String?) ?? '',
      raw: json,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SiteInfoEntity &&
        other.sitename == sitename &&
        other.username == username &&
        other.userId == userId &&
        other.siteUrl == siteUrl;
  }

  @override
  int get hashCode => Object.hash(sitename, username, userId, siteUrl);

  @override
  String toString() => 'SiteInfoEntity(sitename: $sitename, '
      'username: $username, userId: $userId, siteUrl: $siteUrl)';
}
