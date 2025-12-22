class CredentialEntity {
  final String id; // uuid
  final String siteName;
  final String? siteUrl;
  final String secureId; // key for secure storage (username/password)
  final DateTime createdAt;
  final DateTime updatedAt;

  const CredentialEntity({
    required this.id,
    required this.siteName,
    required this.secureId,
    this.siteUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  CredentialEntity copyWith({
    String? siteName,
    String? siteUrl,
    DateTime? updatedAt,
  }) {
    return CredentialEntity(
      id: id,
      siteName: siteName ?? this.siteName,
      siteUrl: siteUrl ?? this.siteUrl,
      secureId: secureId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
