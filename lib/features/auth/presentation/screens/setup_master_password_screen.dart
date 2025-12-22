import 'package:flutter/material.dart';
import 'package:defindia3/core/constants/app_colors.dart';
import 'package:defindia3/core/constants/app_strings.dart';
import 'package:defindia3/core/widgets/app_button.dart';
import 'package:defindia3/core/widgets/app_text_field.dart';
import 'package:defindia3/features/auth/data/repositories/master_auth_repository_impl.dart';

class SetupMasterPasswordScreen extends StatefulWidget {
  const SetupMasterPasswordScreen({super.key});

  @override
  State<SetupMasterPasswordScreen> createState() =>
      _SetupMasterPasswordScreenState();
}

class _SetupMasterPasswordScreenState
    extends State<SetupMasterPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _saving = false;
  final _repo = MasterAuthRepository();

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _saving = true);
    try {
      await _repo.setMaster(_passCtrl.text.trim());
      if (mounted) Navigator.of(context).pop(true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Set Master PIN'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Set a master PIN/password to unlock your vault. '
                      'Keep it safe, it cannot be recovered.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                AppTextField(
                  controller: _passCtrl,
                  label: 'Master PIN / Password',
                  isPassword: true,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return AppStrings.errorRequired;
                    }
                    if (v.trim().length < 4) {
                      return 'Minimum 4 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _confirmCtrl,
                  label: 'Confirm PIN / Password',
                  isPassword: true,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return AppStrings.errorRequired;
                    }
                    if (v.trim() != _passCtrl.text.trim()) {
                      return 'PIN / Password does not match';
                    }
                    return null;
                  },
                ),
                const Spacer(),
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
