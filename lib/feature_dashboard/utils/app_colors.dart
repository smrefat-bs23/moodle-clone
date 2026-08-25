import 'package:flutter/material.dart';

/// Application-wide color constants used by the dashboard feature.
///
/// These were originally defined in `core/lib/utils/constants/app_colors.dart`
/// (a file outside `lib/`), but were moved here to keep the dashboard feature
/// self-contained and avoid coupling the dashboard to the `core` package.
class AppColors {
  AppColors._();

  /// Moodle specific colors
  static const Color moodleOrange = Color(0xFFD47A3A);
  static const Color moodleGrey = Color(0xFFF2F2F2);
  static const Color moodleLightOrange = Color(0xFFFFF3E0);

  /// Neutral colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color black87 = Colors.black87;
  static const Color black54 = Colors.black54;

  /// Grey shades
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  /// Other colors
  static const Color blue = Color(0xFF1976D2);
  static const Color red = Color(0xFFC62828);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFBDBDBD);
  static const Color background = Color(0xFFF2F2F2);
  static const Color surface = Colors.white;

  /// Overlay and shadows
  static const Color barrier = Colors.black54;
  static const Color shadow = Colors.black12;
  static const Color overlayGrey = Color(0xFFD1D5DB);

  /// Course-detail hero (matches the Moodle purple hero).
  static const Color courseHeroPurple = Color(0xFFB6B0FB);

  /// Info banner palette used on the course details page.
  static const Color infoBannerBlue = Color(0xFFE3F2FD);
  static const Color infoBannerIcon = Color(0xFF0D47A1);
  static const Color infoBannerText = Color(0xFF0D47A1);

  /// Darker shade of [moodleOrange] used for the active bottom-nav indicator
  /// and selected popover rows so the highlight reads as a distinct accent.
  static const Color moodleOrangeDark = Color(0xFFE76F00);

  /// Soft peach used for selected popover rows / pill backgrounds.
  static const Color peachBackground = Color(0xFFFAD7B2);

  /// Lavender placeholder used for course thumbnails when no imageUrl is set.
  /// Matches the Moodle Mobile reference design.
  static const Color courseThumbLavender = Color(0xFFC5CAE9);
}
