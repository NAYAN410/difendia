import 'package:defindia3/features/credentials/domain/entities/credential_entity.dart';

/// Equivalent domains config (company wise extend kar sakte ho).
/// Example: viaplay.com app, viaplay.se web.
const Map<String, List<String>> kEquivalentDomains = {
  'viaplay.com': ['viaplay.se', 'viaplay.no', 'viaplay.dk'],
  'viaplay.se': ['viaplay.com', 'viaplay.no', 'viaplay.dk'],
};

String _extractBaseDomain(String host) {
  // host: "login.viaplay.com" -> "viaplay.com"
  final parts = host.split('.');
  if (parts.length <= 2) return host.toLowerCase();
  final last2 = parts.sublist(parts.length - 2).join('.');
  return last2.toLowerCase();
}

String? _extractHost(String? url) {
  if (url == null || url.isEmpty) return null;
  Uri? uri = Uri.tryParse(url);
  if (uri == null) return null;

  if (uri.host.isEmpty && uri.path.isNotEmpty) {
    // maybe "viaplay.com" without scheme
    uri = Uri.tryParse('https://${uri.path}');
  }
  return uri?.host.toLowerCase();
}

/// Score: higher = better match.
/// 100 = exact/equivalent domain match
/// 60  = base name match in domain (e.g. "viaplay-app.com")
/// 40  = login name/title contains appName
/// 0   = no relation
int computeMatchScore({
  required String currentUrlOrDomain,
  required CredentialEntity credential,
  required String appName, // e.g. "Viaplay"
}) {
  final currentHost = _extractHost(currentUrlOrDomain) ?? currentUrlOrDomain;
  final currentBase = _extractBaseDomain(currentHost);

  final credHost = _extractHost(credential.siteUrl) ?? '';
  final credBase = credHost.isNotEmpty ? _extractBaseDomain(credHost) : '';

  int score = 0;

  // 1) Exact/equivalent domain
  if (credBase.isNotEmpty) {
    if (credBase == currentBase) {
      score = 100;
    } else {
      final equivalents = kEquivalentDomains[currentBase] ?? [];
      if (equivalents.contains(credBase)) {
        score = 100;
      }
    }
  }

  // 2) Base name substring match (e.g. "viaplay" appears in either)
  if (score < 100) {
    final baseName = currentBase.split('.').first; // "viaplay"
    if (credBase.contains(baseName) || baseName.contains(credBase)) {
      score = 60;
    }
  }

  // 3) Login name/title contains app name (case-insensitive)
  if (score < 60) {
    final lowerName = credential.siteName.toLowerCase();
    if (lowerName.contains(appName.toLowerCase())) {
      score = 40;
    }
  }

  return score;
}

/// Sorted & filtered list banane ke liye helper.
List<CredentialEntity> sortCredentialsForAutofill({
  required String currentUrlOrDomain,
  required String appName,
  required List<CredentialEntity> all,
  String searchQuery = '',
}) {
  final q = searchQuery.trim().toLowerCase();

  final filtered = all.where((c) {
    if (q.isEmpty) return true;
    final inName = c.siteName.toLowerCase().contains(q);
    final inUrl = (c.siteUrl ?? '').toLowerCase().contains(q);
    return inName || inUrl;
  }).toList();

  filtered.sort((a, b) {
    final scoreA = computeMatchScore(
      currentUrlOrDomain: currentUrlOrDomain,
      credential: a,
      appName: appName,
    );
    final scoreB = computeMatchScore(
      currentUrlOrDomain: currentUrlOrDomain,
      credential: b,
      appName: appName,
    );

    if (scoreA != scoreB) {
      return scoreB.compareTo(scoreA); // higher score first
    }

    // tie-breaker: alphabetic by siteName
    return a.siteName.toLowerCase().compareTo(b.siteName.toLowerCase());
  });

  return filtered;
}
