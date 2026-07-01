import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/app_page_route.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_reactivity.dart';
import '../../core/utils/phone_number_formatter.dart';
import '../../models/country_dial_code.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/auth_screen_shell.dart';
import '../../widgets/auth_text_field.dart';
import '../../widgets/phone_number_field.dart';
import '../../widgets/pressable_scale.dart';
import '../../widgets/primary_button.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  CountryDialCode _phoneCountry = CountryDialCodes.turkey;
  bool _obscurePassword = true;
  bool _submitting = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_submitting || !_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final normalizedPhone = PhoneNumberFormatter.normalize(
      _phoneController.text,
      country: _phoneCountry,
    );
    final result = await context.read<AuthProvider>().login(
      phone: normalizedPhone,
      password: _passwordController.text,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (!result.isSuccess) {
      AppFeedback.show(context, result.message, type: AppFeedbackType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    dependOnThemeChanges(context);

    return AuthScreenShell(
      centerContent: true,
      title: 'Kahve ritüeline dön.',
      subtitle:
          'CafePlato hesabınla puanlarına ve favorilerine kaldığın yerden ulaş.',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            PhoneNumberField(
              controller: _phoneController,
              focusNode: _phoneFocus,
              nextFocusNode: _passwordFocus,
              selectedCountry: _phoneCountry,
              onCountryChanged: (country) =>
                  setState(() => _phoneCountry = country),
              label: 'Telefon numarası',
              autofillHints: const [AutofillHints.telephoneNumber],
            ),
            const SizedBox(height: 14),
            AuthTextField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              label: 'Şifre',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onToggleObscure: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Şifrenizi girin.'
                  : null,
            ),
            const SizedBox(height: 22),
            PrimaryButton(
              text: 'Giriş Yap',
              isLoading: _submitting,
              onPressed: _login,
            ),
            const SizedBox(height: 18),
            PressableScale(
              semanticLabel: 'Kayıt Ol',
              onTap: () => AppNavigator.push(context, const RegisterScreen()),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodyMedium,
                    children: [
                      const TextSpan(text: 'Hesabın yok mu? '),
                      TextSpan(
                        text: 'Kayıt Ol',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
