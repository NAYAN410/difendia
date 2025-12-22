import 'package:flutter/material.dart';
import 'package:defindia3/features/credentials/domain/entities/credential_entity.dart';

String _buildFaviconUrl(String? siteUrl) {
  if (siteUrl == null || siteUrl.isEmpty) return '';
  final uri = Uri.tryParse(siteUrl);
  final normalized = (uri == null || uri.scheme.isEmpty)
      ? 'https://$siteUrl'
      : siteUrl;

  return 'https://www.google.com/s2/favicons?sz=64&domain=$normalized';
}

class CredentialTile extends StatelessWidget {
  final CredentialEntity credential;
  final VoidCallback? onTap;
  final VoidCallback? onMore;

  const CredentialTile({
    super.key,
    required this.credential,
    this.onTap,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final faviconUrl = _buildFaviconUrl(credential.siteUrl);
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      tileColor: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
        child: faviconUrl.isEmpty
            ? Text(
          credential.siteName.isNotEmpty
              ? credential.siteName[0].toUpperCase()
              : '?',
          style: TextStyle(color: theme.colorScheme.primary),
        )
            : ClipOval(
          child: Image.network(
            faviconUrl,
            width: 24,
            height: 24,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) {
              return Text(
                credential.siteName.isNotEmpty
                    ? credential.siteName[0].toUpperCase()
                    : '?',
                style: TextStyle(color: theme.colorScheme.primary),
              );
            },
          ),
        ),
      ),
      title: Text(
        credential.siteName,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: credential.siteUrl != null
          ? Text(
        credential.siteUrl!,
        style: theme.textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      )
          : null,
      trailing: IconButton(
        icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
        onPressed: onMore,
      ),
    );
  }
}
