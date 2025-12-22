import 'package:flutter/material.dart';
import 'package:defindia3/features/credentials/domain/entities/credential_entity.dart';
import 'package:defindia3/features/credentials/domain/utils/domain_matcher.dart';
import 'package:defindia3/features/credentials/presentation/widgets/credential_tile.dart';

class AutofillPickerBottomSheet extends StatefulWidget {
  final String currentUrlOrDomain; // e.g. "https://viaplay.com/login" or "viaplay.com"
  final String appName;            // e.g. "Viaplay"
  final List<CredentialEntity> allCredentials;
  final ValueChanged<CredentialEntity> onSelected;

  const AutofillPickerBottomSheet({
    super.key,
    required this.currentUrlOrDomain,
    required this.appName,
    required this.allCredentials,
    required this.onSelected,
  });

  @override
  State<AutofillPickerBottomSheet> createState() =>
      _AutofillPickerBottomSheetState();
}

class _AutofillPickerBottomSheetState extends State<AutofillPickerBottomSheet> {
  final TextEditingController _searchCtrl = TextEditingController();
  late List<CredentialEntity> _sorted;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
    _applySort();
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _applySort();
  }

  void _applySort() {
    _sorted = sortCredentialsForAutofill(
      currentUrlOrDomain: widget.currentUrlOrDomain,
      appName: widget.appName,
      all: widget.allCredentials,
      searchQuery: _searchCtrl.text,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Top N ko "Best matches" group maan lete hain (score-based).
    final bestMatches = <CredentialEntity>[];
    final others = <CredentialEntity>[];

    for (final cred in _sorted) {
      final score = computeMatchScore(
        currentUrlOrDomain: widget.currentUrlOrDomain,
        credential: cred,
        appName: widget.appName,
      );
      if (score >= 60 && bestMatches.length < 5) {
        bestMatches.add(cred);
      } else {
        others.add(cred);
      }
    }

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            TextField(
              controller: _searchCtrl,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search logins…',
                prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            if (bestMatches.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Best matches',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...bestMatches.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: CredentialTile(
                  credential: c,
                  onTap: () => _onSelect(c),
                ),
              )),
              const SizedBox(height: 12),
            ],
            if (others.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'All logins',
                  style: theme.textTheme.labelMedium,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 260, // scrollable list
                child: ListView.separated(
                  itemCount: others.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final cred = others[index];
                    return CredentialTile(
                      credential: cred,
                      onTap: () => _onSelect(cred),
                    );
                  },
                ),
              ),
            ],
            if (bestMatches.isEmpty && others.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('No logins found'),
              ),
          ],
        ),
      ),
    );
  }

  void _onSelect(CredentialEntity c) {
    widget.onSelected(c);
    Navigator.of(context).pop();
  }
}
