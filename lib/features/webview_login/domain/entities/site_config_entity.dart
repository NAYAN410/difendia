class SiteConfigEntity {
  final String url;
  /// Optional specific selectors; agar null ho to generic selectors use honge.
  final String? usernameSelector; // e.g. '#email' or 'input[type="email"]'
  final String? passwordSelector; // e.g. '#password' or 'input[type="password"]'

  const SiteConfigEntity({
    required this.url,
    this.usernameSelector,
    this.passwordSelector,
  });
}
