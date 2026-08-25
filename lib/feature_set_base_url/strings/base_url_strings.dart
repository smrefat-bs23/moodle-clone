// ignore_for_file: comment_references

/// String constants used by the Set Base URL feature pages.
///
/// These are local to the feature so the feature stays self-contained
/// without modifying files outside `lib/`.
class BaseUrlStrings {
  const BaseUrlStrings._();

  // Help page items.
  static const String helpItemFaq = 'Frequently asked questions';
  static const String helpItemPrivacyPolicy = 'Privacy policy';
  static const String helpItemTerms = 'Terms and conditions';
  static const String helpItemContact = 'Contact support';
  static const String helpItemAbout = 'About this app';
  static const String helpItemAcknowledgements = 'Acknowledgements';

  static const List<String> helpItems = <String>[
    helpItemFaq,
    helpItemPrivacyPolicy,
    helpItemTerms,
    helpItemContact,
    helpItemAbout,
    helpItemAcknowledgements,
  ];

  // Help page meta.
  static const String helpTitle = 'Help';
  static const String helpVersion = 'Moodle Mobile 4.5.0';

  // App settings page meta.
  static const String appSettingsTitle = 'App settings';

  // App settings page items.
  static const String appSettingsLanguage = 'Language';
  static const String appSettingsTextSize = 'Text size';
  static const String appSettingsSyncOverWifi = 'Sync over Wi-Fi only';
  static const String appSettingsStorage = 'Storage';
  static const String appSettingsNotifications = 'Notifications';
  static const String appSettingsAbout = 'About';

  // QR info dialog.
  static const String qrInfoTitle = 'Scan a QR code';
  static const String qrInfoBody =
      'Hold your device over a QR code provided by your site admin '
      'to sign in automatically.';
  static const String qrInfoGotIt = 'Got it';
}
