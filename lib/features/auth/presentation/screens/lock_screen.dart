import 'package:flutter/material.dart';
import 'package:defindia3/core/constants/app_colors.dart';
import 'package:defindia3/features/auth/data/repositories/master_auth_repository_impl.dart';
import 'package:defindia3/features/auth/domain/usecases/verify_master_password.dart';
import 'package:defindia3/features/auth/presentation/widgets/pin_pad.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _repo = MasterAuthRepository();
  late final VerifyMasterPassword _verifyUsecase;
  String? _error;

  @override
  void initState() {
    super.initState();
    _verifyUsecase = VerifyMasterPassword(_repo);
  }

  Future<void> _onPinCompleted(String pin) async {
    final ok = await _verifyUsecase(pin);
    if (!mounted) return;

    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _error = 'Wrong PIN. Try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock, color: AppColors.primary, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Enter Master PIN',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This unlocks your password vault.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                if (_error != null) ...[
                  Text(
                    _error!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                PinPad(
                  length: 4,
                  onCompleted: _onPinCompleted,
                ),
                const SizedBox(height: 24),
                // TODO: yaha baad me biometric button add kar sakte ho (local_auth).
              ],
            ),
          ),
        ),
      ),
    );
  }
}
