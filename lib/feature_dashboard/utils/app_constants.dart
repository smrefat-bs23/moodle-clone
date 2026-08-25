/// Application-wide constants used by the dashboard feature.
///
/// Originally part of `core/lib/utils/constants/app_constants.dart` (outside
/// `lib/`); relocated here to keep the dashboard feature self-contained.
class AppConstants {
  /// App name
  static const String appName = 'Flutter Boilerplate';

  /// App version
  static const String appVersion = '1.0.0';

  /// Base URL for API endpoints
  static const String baseUrl = 'https://api.example.com';

  /// Connection timeout in seconds
  static const int connectionTimeout = 30;

  /// Receive timeout in seconds
  static const int receiveTimeout = 30;

  /// Shared preferences file name
  static const String prefsFileName = 'flutter_boilerplate_prefs';

  /// Cache directory name
  static const String cacheDir = 'cache';

  /// Default page size for pagination
  static const int defaultPageSize = 20;

  /// Maximum number of retries for network requests
  static const int maxRetries = 3;

  /// Auth token key in storage
  static const String tokenKey = 'auth_token';

  /// Refresh token key in storage
  static const String refreshTokenKey = 'refresh_token';

  /// User ID key in storage
  static const String userIdKey = 'user_id';
}

/// String constants used throughout the app
class AppStrings {
  /// Error messages
  static const String errorGeneral = 'An unexpected error occurred';

  /// Network error message
  static const String errorNetwork =
      'Network error. Please check your connection';

  /// Timeout error message
  static const String errorTimeout = 'Request timeout';

  /// Server error message
  static const String errorServer = 'Server error. Please try again later';

  /// Authentication error message
  static const String errorUnauthorized = 'Unauthorized access';

  /// Validation error message
  static const String errorValidation = 'Please fix the errors in the form';

  /// Bad request error message
  static const String errorBadRequest = 'Invalid request';

  /// Success messages
  static const String successOperation = 'Operation completed successfully';

  /// Generic labels
  /// Loading label
  static const String labelLoading = 'Loading...';

  /// Error label
  static const String labelError = 'Error';

  /// Retry label
  static const String labelRetry = 'Retry';

  /// Cancel label
  static const String labelCancel = 'Cancel';

  /// OK label
  static const String labelOk = 'OK';

  /// Save label
  static const String labelSave = 'Save';

  /// Delete label
  static const String labelDelete = 'Delete';

  /// Edit label
  static const String labelEdit = 'Edit';

  /// Submit label
  static const String labelSubmit = 'Submit';

  /// Empty states
  /// No data message
  static const String emptyNoData = 'No data available';

  /// No search results message
  static const String emptySearch = 'No results found';

  /// No favorites message
  static const String emptyFavorites = 'No favorites yet';

  /// Connectivity
  /// Connectivity status label
  static const String connectivityStatus = 'Connectivity status';

  /// Online status label
  static const String connectivityOnline = 'Online';

  /// Offline status label
  static const String connectivityOffline = 'Offline';
}

/// Spacing constants for consistent padding/margins
class AppSpacing {
  const AppSpacing._();

  /// Extra small spacing (4)
  static const double xs = 4;

  /// Small spacing (8)
  static const double sm = 8;

  /// Medium spacing (12)
  static const double md = 12;

  /// Standard spacing (16)
  static const double std = 16;

  /// Large spacing (24)
  static const double lg = 24;

  /// Extra large spacing (32)
  static const double xl = 32;

  /// Extra extra large spacing (48)
  static const double xxl = 48;
}

/// Font size constants
class AppFontSize {
  const AppFontSize._();

  static const double xs = 10;
  static const double sm = 12;
  static const double md = 14;
  static const double lg = 16;
  static const double xl = 18;
  static const double xxl = 20;
  static const double h3 = 22;
  static const double h2 = 24;
  static const double h1 = 32;

  /// Custom sizes used in UI
  static const double tab = 15;
  static const double label = 13;
}

/// App size constants
class AppSize {
  const AppSize._();

  /// Extra small icon size (12)
  static const double iconXs = 12;

  /// Small icon size (16)
  static const double iconSm = 16;

  /// Small-Medium icon size (20)
  static const double iconSmMd = 20;

  /// Medium icon size (24)
  static const double iconMd = 24;

  /// Medium-Large icon size (26)
  static const double iconMdLg = 26;

  /// Large icon size (32)
  static const double iconLg = 32;

  /// Extra large icon size (48)
  static const double iconXl = 48;

  /// Extra extra large size (50)
  static const double xxl = 50;

  /// Small border radius (4)
  static const double radiusSm = 4;

  /// Medium border radius (8)
  static const double radiusMd = 8;

  /// Large border radius (12)
  static const double radiusLg = 12;

  /// Extra large border radius (16)
  static const double radiusXl = 16;

  /// Full border radius (9999)
  static const double radiusFull = 9999;

  /// Small elevation (2)
  static const double elevationSm = 2;

  /// Medium elevation (4)
  static const double elevationMd = 4;

  /// Large elevation (8)
  static const double elevationLg = 8;
}
