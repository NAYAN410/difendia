/// App me reuse hone wale static texts.
/// Baad me agar localization add karni ho to yahi mapping ko replace kar dena.
class AppStrings {
  AppStrings._(); // private constructor

  // General
  static const String appName = 'DEF Password Vault';
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String close = 'Close';

  // Dashboard / credentials list
  static const String dashboardTitle = 'Your Logins';
  static const String searchHint = 'Search websites...';
  static const String emptyStateTitle = 'No logins yet';
  static const String emptyStateSubtitle =
      'Tap the + button to add your first website login.';

  // Add / edit credential
  static const String addCredentialTitle = 'Add Login';
  static const String editCredentialTitle = 'Edit Login';
  static const String fieldWebsiteName = 'Website name (e.g. Netflix)';
  static const String fieldWebsiteUrl = 'Website URL (optional)';
  static const String fieldUsernameEmail = 'Username / Email';
  static const String fieldPassword = 'Password';
  static const String fieldNotes = 'Notes (optional)';

  static const String openAndAutofill = 'Open & Autofill';
  static const String copiedToClipboard = 'Copied to clipboard';

  // Validation / errors
  static const String errorRequired = 'This field is required';
  static const String errorInvalidUrl = 'Please enter a valid URL';
  static const String errorGeneric = 'Something went wrong';

  // Security / warnings
  static const String warningScreenshot =
      'Avoid screenshots. Your credentials are sensitive.';
  static const String infoLocalOnly =
      'All passwords are stored locally on this device with encryption.';
}
