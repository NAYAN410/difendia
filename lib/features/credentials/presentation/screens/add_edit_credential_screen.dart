import 'package:flutter/material.dart';
import 'package:defindia3/core/constants/app_colors.dart';
import 'package:defindia3/core/constants/app_strings.dart';
import 'package:defindia3/core/widgets/app_button.dart';
import 'package:defindia3/core/widgets/app_text_field.dart';
import 'package:defindia3/features/credentials/data/datasources/local_credential_data_source.dart';
import 'package:defindia3/features/credentials/data/repositories/credential_repository_impl.dart';
import 'package:defindia3/features/credentials/domain/entities/credential_entity.dart';

class AddEditCredentialScreen extends StatefulWidget {
  final CredentialEntity? existing;

  const AddEditCredentialScreen({super.key, this.existing});

  @override
  State<AddEditCredentialScreen> createState() =>
      _AddEditCredentialScreenState();
}

class _AddEditCredentialScreenState extends State<AddEditCredentialScreen> {
  final _formKey = GlobalKey<FormState>();

  final _siteNameCtrl = TextEditingController();
  final _siteUrlCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _saving = false;

  late final CredentialRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = CredentialRepository(LocalCredentialDataSource());

    final e = widget.existing;
    if (e != null) {
      _siteNameCtrl.text = e.siteName;
      _siteUrlCtrl.text = e.siteUrl ?? '';
      // username/password later load karoge, yaha simple rakha gaya hai
    }
  }

  @override
  void dispose() {
    _siteNameCtrl.dispose();
    _siteUrlCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _saving = true);

    try {
      if (widget.existing == null) {
        await _repo.add(
          siteName: _siteNameCtrl.text.trim(),
          siteUrl: _siteUrlCtrl.text.trim().isEmpty
              ? null
              : _siteUrlCtrl.text.trim(),
          username: _usernameCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
        );
      } else {
        await _repo.update(
          existing: widget.existing!,
          siteName: _siteNameCtrl.text.trim(),
          siteUrl: _siteUrlCtrl.text.trim().isEmpty
              ? null
              : _siteUrlCtrl.text.trim(),
          username: _usernameCtrl.text.trim().isEmpty
              ? null
              : _usernameCtrl.text.trim(),
          password: _passwordCtrl.text.trim().isEmpty
              ? null
              : _passwordCtrl.text.trim(),
        );
      }

      if (mounted) Navigator.of(context).pop(true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorRequired;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          isEdit
              ? AppStrings.editCredentialTitle
              : AppStrings.addCredentialTitle,
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                AppTextField(
                  controller: _siteNameCtrl,
                  label: AppStrings.fieldWebsiteName,
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _siteUrlCtrl,
                  label: AppStrings.fieldWebsiteUrl,
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _usernameCtrl,
                  label: AppStrings.fieldUsernameEmail,
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _passwordCtrl,
                  label: AppStrings.fieldPassword,
                  isPassword: true,
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: AppStrings.save,
                  onPressed: _save,
                  isLoading: _saving,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
