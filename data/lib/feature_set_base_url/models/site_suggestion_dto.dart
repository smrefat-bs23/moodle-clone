// ignore_for_file: comment_references, sort_constructors_first

/// Data Transfer Object (DTO) for the JSON payload returned by
/// Moodle's `core_webservice_get_site_info` endpoint.
///
/// Kept separate from the domain [SiteSuggestionEntity] so the data
/// layer can evolve its parsing (e.g. handle new fields, fallback to
/// alternative keys) without touching the domain layer.
class SiteSuggestionDto {
  /// Creates a [SiteSuggestionDto] from a decoded JSON map.
  factory SiteSuggestionDto.fromJson(Map<String, dynamic> json) {
    return SiteSuggestionDto._(
      sitename: (json['sitename'] as String?) ?? '',
      siteUrl: (json['siteurl'] as String?) ?? '',
      username: (json['username'] as String?) ?? '',
      userId: _parseUserId(json['userid']),
      release: (json['release'] as String?) ?? '',
      version: (json['version'] as String?) ?? '',
      theme: (json['theme'] as String?) ?? '',
      fullname: (json['fullname'] as String?) ?? '',
      raw: json,
    );
  }

  const SiteSuggestionDto._({
    required this.sitename,
    required this.siteUrl,
    required this.username,
    required this.userId,
    required this.raw,
    required this.release,
    required this.version,
    required this.theme,
    required this.fullname,
  });

  /// Friendly name of the Moodle site.
  final String sitename;

  /// Base URL of the Moodle site.
  final String siteUrl;

  /// Username of the authenticated user.
  final String username;

  /// Numeric user id; `null` for guest sessions.
  final int? userId;

  /// Moodle release codename reported by the server.
  final String release;

  /// Moodle version number reported by the server.
  final String version;

  /// Moodle theme name reported by the server.
  final String theme;

  /// Full display name of the authenticated user.
  final String fullname;

  /// The original decoded JSON payload.
  final Map<String, dynamic> raw;

  /// Best-effort `int` conversion of `userid` — Moodle sometimes sends
  /// it as `int`, sometimes as a numeric string, sometimes as `null`.
  static int? _parseUserId(Object? raw) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    if (raw is String) {
      final parsed = int.tryParse(raw);
      if (parsed != null) return parsed;
    }
    return null;
  }
}