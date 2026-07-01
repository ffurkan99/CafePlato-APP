import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_reactivity.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/auth_screen_shell.dart';
import '../../widgets/pressable_scale.dart';
import '../../widgets/primary_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phone});

  final String phone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _codeController = TextEditingController();
  String? _error;
  bool _submitting = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_submitting) return;
    if (_codeController.text.trim().isEmpty) {
      setState(() => _error = 'Doğrulama kodunu girin.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    final success = await context.read<AuthProvider>().verifyOtp(
      _codeController.text,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (success) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    dependOnThemeChanges(context);

    return AuthScreenShell(
      showBackButton: true,
      title: 'Telefonunu doğrula',
      subtitle:
          '${widget.phone} numarasına gönderilmiş gibi gösterilen demo kodu gir.',
      child: Column(
        children: [
          TextField(
            controller: _codeController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: AppTextStyles.heading2.copyWith(letterSpacing: 8),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              counterText: '',
              hintText: '••••••',
              errorText: _error,
              filled: true,
              fillColor: AppColors.cardBackground,
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.primary, width: 1.4),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            text: 'Doğrula',
            isLoading: _submitting,
            onPressed: _verify,
          ),
          const SizedBox(height: 14),
          PressableScale(
            semanticLabel: 'Kodu tekrar gönder',
            onTap: () => AppFeedback.show(
              context,
              'Demo doğrulama kodu yeniden gönderildi.',
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Kodu tekrar gönder',
                style: AppTextStyles.controlLabel.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
