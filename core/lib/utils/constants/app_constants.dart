import 'package:flutter/material.dart';

/// Application-wide constants
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

/// App brand colors
class AppBrandColors {
  const AppBrandColors._();

  /// Moodle brand colors
  static const Color moodleOrange = Color(0xFFF98012);
}

/// String constants used throughout the app
class AppStrings {
  static const String courseTitle = 'Celebrating Cultures';
  static const String courseCategory = 'Our Community';
  static const String courseSummary = 'Course summary';
  static const String teachers = 'Teachers';
  static const String progress = '27%';
  static const String courseStartDate = 'Course start date ';
  static const String courseStartTime = 'December 18 2013,\n11:00 PM';
  static const String courseDescription =
      'An informal, optional module for Mount Orange students, staff and auxiliaries to celebrate and showcase the diversity of our traditions, languages and landscapes.';
  static const String teacherInitials = 'JS';
  static const String teacherName = 'Jeffrey Sanders';
  static const String courseBanner = 'assets/images/course_banner.png';

  static const String signInMessage = 'New sign in to your ';
  static const String mountOrange = 'Mount Orange';
  static const String account = ' account';
  static const String notificationTime = '47 min ago';
  static const String notifications = 'Notifications';
  static const String empty = '';
  static const String markAllAsRead = 'Mark all as read';

  /// Error messages
  static const String errorGeneral = 'An unexpected error occurred';
  static const String errorSomethingWentWrong = 'Oops! Something went wrong';
  static const String errorUnexpectedNotify =
      'An unexpected error occurred. Our team has been notified.';
  static const String errorDetails = 'Error Details:';
  static const String errorStackTrace = 'Stack Trace';

  /// Network error message
  static const String errorNetwork =
      'Network error. Please check your connection';

  /// Timeout error message
  static const String errorTimeout = 'Request timed out';

  /// Server error message
  static const String errorServer = 'Server error. Please try again later';

  /// Authentication error message
  static const String errorUnauthorized = 'Unauthorized access';

  /// Navigation error message
  static const String errorNavigation = 'Navigation error occurred';

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

  /// Try Again label
  static const String labelTryAgain = 'Try Again';

  /// Cancel label
  static const String labelCancel = 'Cancel';

  /// OK label
  static const String labelOk = 'OK';

  /// Post labels
  static const String labelPosts = 'Posts';
  static const String labelPostsDemo = 'Posts (JSONPlaceholder demo)';
  static const String labelCreatePost = 'Create post';
  static const String labelEditPost = 'Edit post (PUT)';
  static const String labelPatchTitle = 'Quick patch title (PATCH)';
  static const String labelTitle = 'Title';
  static const String labelBody = 'Body';
  static const String labelCreate = 'Create';
  static const String labelPatch = 'Patch';
  static const String emptyNoPosts = 'No posts';
  static const String bannerDemo =
      'Demo API: creates/edits/deletes are accepted by the server but '
      'never actually persist. Local edits stay visible across refreshes '
      'thanks to optimistic updates.';

  /// Save label
  static const String labelSave = 'Save';

  /// Delete label
  static const String labelDelete = 'Delete';

  /// Edit label
  static const String labelEdit = 'Edit';

  /// Submit label
  static const String labelSubmit = 'Submit';
  /// Go Home label
  static const String labelGoHome = 'Go Home';

  /// Auth labels
  /// Login label
  static const String labelLogin = 'Log in';
  /// Username label
  static const String labelUsername = 'Username';
  /// Password label
  static const String labelPassword = 'Password';
  /// Lost password label
  static const String labelLostPassword = 'Lost Password?';
  /// Site name label
  static const String labelSiteName = 'eLearning23';
  /// Site URL label
  static const String labelSiteUrl = 'https://lmsmobile.ahnafmuttaki.com';

  /// More page labels
  /// More label
  static const String labelMore = 'More';
  /// Calendar label
  static const String labelCalendar = 'Calendar';
  /// Site blog label
  static const String labelSiteBlog = 'Site blog';
  /// Tags label
  static const String labelTags = 'Tags';
  /// Scan QR code label
  static const String labelScanQrCode = 'Scan QR code';
  /// App settings label
  static const String labelAppSettings = 'App settings';
  /// General label
  static const String labelGeneral = 'General';
  /// Space usage label
  static const String labelSpaceUsage = 'Space usage';
  /// Synchronisation label
  static const String labelSynchronisation = 'Synchronisation';
  /// About label
  static const String labelAbout = 'About';

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

  /// Connect to Moodle screen
  static const String connectToMoodle = 'Connect to Moodle';
  static const String yourSite = 'Your site';
  static const String siteHint = 'https://campus.example.edu';
  static const String needHelp = 'Need help?';
  static const String scanQrCode = 'Scan QR code';
  static const String or = 'OR';
  static const String pleaseSelectYourAccount = 'Please select your account:';
  static const String connectToYourSite = 'Connect to your site';

  /// Site suggestion search
  static const String suggestionSectionTitle = 'Suggested site';
  static const String suggestionLoadingLabel = 'Looking up site...';
  static const String suggestionEmptyLabel = 'No matching site found';
  static const String suggestionEmptyHint =
      'Type the address of your Moodle site to see suggestions.';
  static const String suggestionErrorLabel =
      'Couldn\u2019t reach this site. Check the URL or your connection.';
  static const String suggestionRetryLabel = 'Retry';
  static const String suggestionAuthenticatedBadge = 'Signed in';
  static const String suggestionGuestBadge = 'Guest';
  static const String suggestionSignedInAs = 'Signed in as';
  static const String suggestionGuestSession = 'Guest session';
  static const String suggestionSiteLabel = 'Site';
  static const String suggestionVersionLabel = 'Version';
  static const String suggestionVersionUnavailable = '\u2014';

  /// Site verification card regions.
  static const String verificationSiteRegion = 'Site';
  static const String verificationSessionRegion = 'Session';
  static const String verificationCapabilitiesRegion = 'Capabilities';
  static const String verificationStorageRegion = 'Storage';
  static const String verificationServerRegion = 'Server';
  static const String verificationWebServicesRegion = 'Web Services';
  static const String verificationRegionBadge = 'Admin';
  static const String verificationRegionPolicyRequired =
      'Policy agreement required';
  static const String verificationRegionPolicyAgreed = 'Policy agreed';
  static const String verificationRegionLanguage = 'Language';
  static const String verificationRegionSiteId = 'Site ID';
  static const String verificationRegionCalendar = 'Calendar';
  static const String verificationRegionConcurrentLogins =
      'Concurrent logins';
  static const String verificationRegionConcurrentLoginsUnlimited =
      'Unlimited';
  static const String verificationRegionBuild = 'Build';
  static const String verificationRegionWebServiceSummary =
      'web service functions enabled';
  static const String verificationRegionViewFunctions = 'View functions';
  static const String verificationRegionQuota = 'Quota';
  static const String verificationRegionMaxFileSize = 'Max upload size';
  static const String verificationRegionDownloads = 'Downloads';
  static const String verificationRegionUploads = 'Uploads';
  static const String verificationRegionDownloadsAllowed = 'Allowed';
  static const String verificationRegionDownloadsBlocked = 'Blocked';
  static const String verificationRegionTheme = 'Theme';

  /// Feature chip labels (for `advancedfeatures[]`).
  static const String featureMessaging = 'Messaging';
  static const String featureCompletion = 'Completion tracking';
  static const String featureBadges = 'Badges';
  static const String featureNotes = 'Notes';
  static const String featureBlogs = 'Blogs';
  static const String featureTags = 'Tags';
  static const String featureComments = 'Comments';
  static const String featureCustomReports = 'Custom reports';
  static const String featureCompetencies = 'Competencies';
  static const String featureGlobalSearch = 'Global search';

  /// Reconnect screen
  static const String lostPassword = 'Lost password?';

  /// Login
  static const String login = 'Log in';

  /// Password field
  static const String password = 'Password';

  /// Reconnect title
  static const String reconnect = 'Reconnect';

  /// Reconnect site name
  static const String siteName = 'eLearning23';

  /// Reconnect site URL
  static const String siteUrl = 'https://lmsmobile.ahnafmuttaki.com';

  /// User initials
  static const String userInitials = 'SU';

  /// User name
  static const String userName = 'Student User';
}

/// Spacing constants for consistent padding/margins
///
/// Values are defined in logical pixels and can be used with
/// EdgeInsets.all(), EdgeInsets.symmetric(), etc.
/// For responsive sizing with ScreenUtil, use .w, .h, .r extensions
class AppSpacing {
  const AppSpacing._();

  /// Extra extra small spacing (2)
  static const double xxs_old = 2; // Conflict resolution: keeping both for safety if used

  /// Extra small spacing (4)
  static const double xs = 4;

  /// Small spacing (8)
  static const double sm = 8;

  /// Medium-small spacing (12)
  static const double ms = 12;

  /// Small-medium spacing (14)
  static const double smm = 14;

  /// Medium spacing (16)
  static const double md = 16;

  /// Medium-large spacing (20)
  static const double ml = 20;

  /// Large spacing (24)
  static const double lg = 24;

  /// Extra large spacing (32)
  static const double xl = 32;

  /// Extra extra large spacing (48)
  static const double xxl = 48;

  /// Custom spacing
  static const double xxs = 5;
  static const double mdSm = 10;
  static const double mdLg = 12;
  static const double xlSm = 22;
  static const double xlMd = 34;
  static const double xxlSm = 44;

  /// Custom spacing (28), used by the reconnect screen
  static const double lgMd = 28;

  /// Custom spacing (30), used by the reconnect screen
  static const double lgXs = 30;

  /// Tiny spacing (0.2), used by the reconnect screen
  static const double tiny = 0.2;
}

/// Duration constants for timeouts, debounce, and animations.
class AppDuration {
  /// Private constructor — use the static members instead.
  const AppDuration._();

  /// Debounce window for the Base URL search input.
  ///
  /// Wider than the original 500 ms because
  /// `core_webservice_get_site_info` does not accept a query parameter —
  /// it always returns the same single site regardless of what the user
  /// typed. Firing on every keystroke therefore wastes a network round
  /// trip per character. The cubit treats a long idle (this value) the
  /// same as an explicit commit (focus loss / "done" key).
  static const Duration searchDebounce = Duration(milliseconds: 1500);

  /// Animation duration for suggestion list cross-fades.
  static const Duration suggestionFade = Duration(milliseconds: 200);

  /// Default loading indicator delay before showing.
  static const Duration loadingIndicatorShow = Duration(milliseconds: 250);
}

/// App size constants
class AppSize {
  const AppSize._();

  /// Design size for ScreenUtil
  static const double designWidth = 375;
  static const double designHeight = 812;

  /// Small icon size (16)
  static const double iconSm = 16;

  /// Medium-small icon size (20)
  static const double iconMs = 20;

  /// Medium icon size (24)
  static const double iconMd = 24;

  /// Large icon size (32)
  static const double iconLg = 32;

  /// Extra large icon size (48)
  static const double iconXl = 48;

  /// Extra extra large icon size (64)
  static const double iconXXl = 64;

  /// Splash logo width
  static const double splashLogoWidth = 200;

  /// Splash logo error size
  static const double splashLogoErrorSize = 100;

  /// Logo width (380)
  static const double logoWidthDefault = 380;

  /// Button height (44)
  static const double buttonHeight = 44;

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

  /// Font sizes
  static const double fontXs = 12;
  static const double fontSm = 14;
  static const double fontMd = 16;
  static const double fontLg = 20;

  /// Layout sizes
  static const double headerHeight = 40;
  static const double logoHeight = 80;
  static const double logoWidth = 550;

  /// Common values
  static const double lineHeight = 1;
  static const double dividerThickness = .8;
  static const double letterSpacingNone = 0;
  static const double letterSpacingTight = -.2;
  static const double splashRadius = 18;
  static const double iconSettings = 25;
  static const double iconButtonMinSize = 32;
  static const double helpBorderRadius = 5;
  static const double helpVerticalPadding = 2;

  static const double helpFontSize = 15;

  static const double helpDividerWidth = 72;
  static const double helpDividerHeight = .5;
  static const double helpDividerThickness = .5;
  static const double qrButtonHeight = 42;
  static const double qrIconSize = 22;
  static const double smallIconButtonSize = 40;
  static const double qrButtonFontSize = 13;
  static const double qrButtonLetterSpacing = 1;
  static const double qrButtonRadius = 3;
  static const double borderWidthNone = 0;
  static const double horizontalPaddingNone = 0;

  /// Site suggestion widget sizes
  static const double suggestionIconSize = 22;
  static const double suggestionBadgeFontSize = 11;
  static const double suggestionTileVerticalPadding = 12;
  static const double suggestionBadgePadding = 6;
  static const double suggestionMinHeight = 56;
  static const double suggestionLabelWidth = 56;
  static const double suggestionAvatarSize = 32;
  static const double suggestionIdentityLabelMaxWidth = 96;

  /// Site verification card sizes.
  static const double verificationCardVerticalPadding = 12;
  static const double verificationRegionHeaderHeight = 28;
  static const double verificationRegionHeaderFontSize = 13;
  static const double verificationRegionGap = 4;
  static const double verificationRegionInset = 12;
  static const double verificationAvatarSize = 56;
  static const double verificationChipFontSize = 11;
  static const double verificationChipHorizontalPadding = 8;
  static const double verificationChipVerticalPadding = 4;
  static const double verificationChipGap = 6;
  static const double verificationValueFontSize = 14;
  static const double verificationKeyFontSize = 12;
  static const double verificationKeyColumnWidth = 110;
  static const double verificationBottomSheetMaxHeight = 480;
  static const double verificationIconSm = 14;
  static const double verificationIconMd = 16;
  static const double verificationIconLg = 20;

  /// Reconnect screen sizes
  static const double radiusXs = 2;
  static const double forgotPasswordUnderlineWidth = 98;
  static const double textMd = 16;
  static const double textSm = 15;
  static const double textXs = 14;
  static const double letterSpacingSm = 1;
  static const double elevationNone = 0;
  static const double suffixIconMinSize = 36;
  static const double iconSplashRadius = 18;
  static const double passwordUnderlineWidth = 0.7;
  static const double passwordFocusedUnderlineWidth = 1.1;
  static const double headerIconButtonSize = 32;
  static const double headerIconSize = 22;
  static const double headerTitleSize = 20;
  static const double headerLetterSpacing = -0.2;
  static const double logoTitleSize = 19;
  static const double borderWidth = 1;
  static const double avatarSize = 78;
  static const double avatarInitialSize = 24;
}
