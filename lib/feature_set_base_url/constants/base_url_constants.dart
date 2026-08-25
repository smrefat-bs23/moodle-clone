// ignore_for_file: comment_references

/// Centralised constants used by the Set Base URL feature.
///
/// Kept inside `lib/` so that the feature stays self-contained without
/// touching files outside the application layer.
class BaseUrlConstants {
  const BaseUrlConstants._();

  /// Minimum number of characters required before the "Your site" label
  /// turns green (matches the official Moodle mobile app behaviour).
  static const int siteValidMinLength = 3;

  /// Pixel size for the small square icon on the Connect tile.
  static const double connectTileIconSize = 40;

  /// Radius of the small square icon on the Connect tile.
  static const double connectTileIconRadius = 4;

  /// Padding of the Connect to your site tile.
  static const double connectTileHorizontalPadding = 16;
  static const double connectTileVerticalPadding = 16;
}
