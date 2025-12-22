import 'package:flutter/material.dart';
import 'package:defindia3/core/constants/app_colors.dart';

class PinPad extends StatelessWidget {
  final int length;
  final ValueChanged<String> onCompleted;

  const PinPad({
    super.key,
    this.length = 4,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    String current = '';

    void addDigit(String d) {
      if (current.length >= length) return;
      current += d;
      if (current.length == length) {
        onCompleted(current);
        current = '';
      }
    }

    void backspace() {
      if (current.isEmpty) return;
      current = current.substring(0, current.length - 1);
    }

    Widget dot(int index) {
      return Container(
        width: 14,
        height: 14,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index < current.length
              ? AppColors.primary
              : AppColors.disabled,
        ),
      );
    }

    Widget numButton(String text, {VoidCallback? onTap}) {
      return InkWell(
        onTap: onTap ?? () => addDigit(text),
        borderRadius: BorderRadius.circular(32),
        child: Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            shape: BoxShape.circle,
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return StatefulBuilder(
      builder: (context, setState) {
        void addDigitState(String d) {
          setState(() {
            addDigit(d);
          });
        }

        void backspaceState() {
          setState(() {
            backspace();
          });
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(length, dot),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 32,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: [
                for (var i in ['1', '2', '3', '4', '5', '6', '7', '8', '9'])
                  numButton(i, onTap: () => addDigitState(i)),
                const SizedBox(width: 64, height: 64),
                numButton('0', onTap: () => addDigitState('0')),
                InkWell(
                  onTap: backspaceState,
                  borderRadius: BorderRadius.circular(32),
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: const Icon(
                      Icons.backspace,
                      color: AppColors.icon,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
