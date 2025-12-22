import 'package:flutter/material.dart';
import 'package:defindia3/core/constants/app_strings.dart';
import 'package:defindia3/core/routes/app_routes.dart';
import 'package:defindia3/features/auth/data/biometric_auth_service.dart';
import 'package:defindia3/features/credentials/data/datasources/local_credential_data_source.dart';
import 'package:defindia3/features/credentials/data/repositories/credential_repository_impl.dart';
import 'package:defindia3/features/credentials/domain/entities/credential_entity.dart';
import 'package:defindia3/features/credentials/presentation/screens/credential_detail_bottomsheet.dart';
import 'package:defindia3/features/credentials/presentation/widgets/credential_tile.dart';
import 'package:defindia3/features/credentials/presentation/screens/autofill_picker_bottomsheet.dart';
import 'package:defindia3/features/webview_login/presentation/screens/webview_login_screen.dart';
import 'package:defindia3/services/secure_storage_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final CredentialRepository _repo;
  final TextEditingController _searchCtrl = TextEditingController();

  List<CredentialEntity> _items = [];
  List<CredentialEntity> _filteredItems = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _repo = CredentialRepository(LocalCredentialDataSource());
    _searchCtrl.addListener(_applySearch);
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_applySearch);
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await _repo.getAll();
    if (!mounted) return;
    setState(() {
      _items = list;
      _applySearch();
      _loading = false;
    });
  }

  void _applySearch() {
    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isEmpty) {
      _filteredItems = List.from(_items);
    } else {
      _filteredItems = _items
          .where((e) =>
      e.siteName.toLowerCase().contains(query) ||
          (e.siteUrl ?? '').toLowerCase().contains(query))
          .toList();
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _onAddPressed() async {
    final changed = await Navigator.of(context)
        .pushNamed(AppRoutes.addEditCredential) as bool?;
    if (changed == true) {
      _load();
    }
  }

  void _onEdit(CredentialEntity e) async {
    final changed = await Navigator.of(context).pushNamed(
      AppRoutes.addEditCredential,
      arguments: e,
    ) as bool?;
    if (changed == true) {
      _load();
    }
  }

  void _onDelete(CredentialEntity e) async {
    await _repo.delete(e);
    _load();
  }

  /// Global autofill picker helper (abhi tum jahan chaaho waha se call kar sakte ho).
  Future<void> _showAutofillPicker(String currentUrlOrDomain) async {
    final all = await _repo.getAll();
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return AutofillPickerBottomSheet(
          currentUrlOrDomain: currentUrlOrDomain,
          appName: 'Viaplay', // ya dynamic app/site name
          allCredentials: all,
          onSelected: (cred) async {
            final (u, p) =
            await SecureStorageService.readCredentials(cred.secureId);
            if (!mounted) return;

            if (u == null || p == null || (cred.siteUrl?.isEmpty ?? true)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                  Text('Missing username/password or URL for this login.'),
                ),
              );
              return;
            }

            Navigator.of(context).pushNamed(
              AppRoutes.webviewLogin,
              arguments: WebviewLoginArgs(
                credential: cred,
                username: u,
                password: p,
                config: null,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openDetail(CredentialEntity e) async {
    final ok = await BiometricAuthService.authenticate();
    if (!ok) {
      return;
    }

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return CredentialDetailBottomSheet(
          credential: e,
          onOpenAndAutofill: () async {
            final (u, p) =
            await SecureStorageService.readCredentials(e.secureId);
            if (!mounted) return;

            Navigator.of(context).pop();

            if (u == null || p == null || (e.siteUrl?.isEmpty ?? true)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Missing username/password or URL. Please edit this login.',
                  ),
                ),
              );
              return;
            }

            // Yaha direct selected credential se WebView login
            Navigator.of(context).pushNamed(
              AppRoutes.webviewLogin,
              arguments: WebviewLoginArgs(
                credential: e,
                username: u,
                password: p,
                config: null,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.dashboardTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.dividerColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: _searchCtrl,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: AppStrings.searchHint,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
                  isDense: true,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddPressed,
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
          ? _buildEmpty(theme)
          : _buildList(theme),
    );
  }

  Widget _buildEmpty(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, color: theme.iconTheme.color, size: 48),
            const SizedBox(height: 16),
            Text(
              AppStrings.emptyStateTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.emptyStateSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(ThemeData theme) {
    final list = _filteredItems;
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = list[index];
        return CredentialTile(
          credential: item,
          onTap: () => _openDetail(item),
          onMore: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: theme.cardColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (_) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading:
                        Icon(Icons.visibility, color: theme.iconTheme.color),
                        title: Text(
                          'View details',
                          style: theme.textTheme.bodyMedium,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _openDetail(item);
                        },
                      ),
                      ListTile(
                        leading:
                        Icon(Icons.edit, color: theme.iconTheme.color),
                        title: Text(
                          'Edit',
                          style: theme.textTheme.bodyMedium,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _onEdit(item);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete, color: Colors.red),
                        title: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _onDelete(item);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
