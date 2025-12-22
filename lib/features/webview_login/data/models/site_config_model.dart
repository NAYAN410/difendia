import 'package:defindia3/features/webview_login/domain/entities/site_config_entity.dart';

class SiteConfigModel {
  final String url;
  final String? usernameSelector;
  final String? passwordSelector;

  const SiteConfigModel({
    required this.url,
    this.usernameSelector,
    this.passwordSelector,
  });

  SiteConfigEntity toEntity() => SiteConfigEntity(
    url: url,
    usernameSelector: usernameSelector,
    passwordSelector: passwordSelector,
  );

  factory SiteConfigModel.fromEntity(SiteConfigEntity e) {
    return SiteConfigModel(
      url: e.url,
      usernameSelector: e.usernameSelector,
      passwordSelector: e.passwordSelector,
    );
  }
}
