import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:defindia3/core/constants/app_colors.dart';
import 'package:defindia3/core/constants/app_strings.dart';
import 'package:defindia3/core/widgets/app_button.dart';
import 'package:defindia3/features/credentials/domain/entities/credential_entity.dart';
import 'package:defindia3/services/secure_storage_service.dart';

class CredentialDetailBottomSheet extends StatefulWidget {
  final CredentialEntity credential;
  final VoidCallback? onOpenAndAutofill;

  const CredentialDetailBottomSheet({
    super.key,
    required this.credential,
    this.onOpenAndAutofill,
  });

  @override
  State<CredentialDetailBottomSheet> createState() =>
      _CredentialDetailBottomSheetState();
}

class _CredentialDetailBottomSheetState
    extends State<CredentialDetailBottomSheet> {
  String? _username;
  String? _password;
  bool _loading = true;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadSecure();
  }

  Future<void> _loadSecure() async {
    final (u, p) =
    await SecureStorageService.readCredentials(widget.credential.secureId);
    if (!mounted) return;
    setState(() {
      _username = u;
      _password = p;
      _loading = false;
    });
  }

  Future<void> _copyToClipboard(String? text) async {
    if (text == null || text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.copiedToClipboard),
        duration: Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: const BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: _loading
            ? const SizedBox(
          height: 120,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
            : Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              widget.credential.siteName,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.credential.siteUrl != null) ...[
              const SizedBox(height: 4),
              Text(
                widget.credential.siteUrl!,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 16),
            _buildRow(
              label: 'Username / Email',
              value: _username ?? 'Not stored',
              onCopy: _username != null && _username!.isNotEmpty
                  ? () => _copyToClipboard(_username)
                  : null,
            ),
            const SizedBox(height: 12),
            _buildPasswordRow(),
            const SizedBox(height: 24),
            AppButton(
              label: AppStrings.openAndAutofill,
              icon: Icons.open_in_new,
              onPressed: widget.onOpenAndAutofill,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required String value,
    VoidCallback? onCopy,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onCopy != null)
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  color: AppColors.icon,
                  onPressed: onCopy,
                  tooltip: 'Copy',
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordRow() {
    final display = _passwordVisible
        ? (_password ?? 'Not stored')
        : (_password != null
        ? '•' * (_password!.length.clamp(4, 12))
        : 'Not stored');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  display,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    letterSpacing: 2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility_off : Icons.visibility,
                  size: 18,
                ),
                color: AppColors.icon,
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
                tooltip: _passwordVisible ? 'Hide' : 'Show',
              ),
              if (_password != null && _password!.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  color: AppColors.icon,
                  onPressed: () => _copyToClipboard(_password),
                  tooltip: 'Copy',
                ),
            ],
          ),
        ),
      ],
    );
  }
}
