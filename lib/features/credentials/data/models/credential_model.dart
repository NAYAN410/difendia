import 'package:hive/hive.dart';
import 'package:defindia3/features/credentials/domain/entities/credential_entity.dart';

part 'credential_model.g.dart';

@HiveType(typeId: 1)
class CredentialModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String siteName;

  @HiveField(2)
  String? siteUrl;

  @HiveField(3)
  String secureId;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  CredentialModel({
    required this.id,
    required this.siteName,
    required this.secureId,
    this.siteUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CredentialModel.fromEntity(CredentialEntity e) {
    return CredentialModel(
      id: e.id,
      siteName: e.siteName,
      siteUrl: e.siteUrl,
      secureId: e.secureId,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );
  }

  CredentialEntity toEntity() {
    return CredentialEntity(
      id: id,
      siteName: siteName,
      siteUrl: siteUrl,
      secureId: secureId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
