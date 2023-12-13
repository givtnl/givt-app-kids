import 'package:flutter/material.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:pinput/pinput.dart';

class VoucherCodeInput extends StatefulWidget {
  const VoucherCodeInput({
    required this.onChanged,
    super.key,
  });

  final void Function(String value) onChanged;

  @override
  State<VoucherCodeInput> createState() => _VoucherCodeInputState();
}

class _VoucherCodeInputState extends State<VoucherCodeInput> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 45,
      height: 48,
      textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppTheme.backButtonColor,
      ),
    );

    return Pinput(
      controller: pinController,
      focusNode: focusNode,
      length: AuthCubit.voucherCodeLength,
      defaultPinTheme: defaultPinTheme,
      separatorBuilder: (index) {
        if (index == 2) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: 8,
            height: 2,
            color: AppTheme.defaultTextColor,
          );
        } else {
          return const SizedBox(width: 8);
        }
      },
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      onChanged: widget.onChanged,
      closeKeyboardWhenCompleted: false,
      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 9),
            width: 16,
            height: 2,
            color: AppTheme.defaultTextColor,
          ),
        ],
      ),
    );
  }
}
