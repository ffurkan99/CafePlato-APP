import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/app_page_route.dart';
import '../../core/theme/theme_reactivity.dart';
import '../../core/utils/phone_number_formatter.dart';
import '../../models/country_dial_code.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auth_screen_shell.dart';
import '../../widgets/auth_text_field.dart';
import '../../widgets/phone_number_field.dart';
import '../../widgets/primary_button.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordAgain = TextEditingController();
  final _focusNodes = List.generate(6, (_) => FocusNode());
  CountryDialCode _phoneCountry = CountryDialCodes.turkey;
  bool _obscurePassword = true;
  bool _obscureAgain = true;
  bool _submitting = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    _passwordAgain.dispose();
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String? _required(String? value, String field) {
    return value == null || value.trim().isEmpty ? '$field zorunludur.' : null;
  }

  Future<void> _register() async {
    if (_submitting || !_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final normalizedPhone = PhoneNumberFormatter.normalize(
      _phone.text,
      country: _phoneCountry,
    );
    final user = UserModel(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      phone: normalizedPhone,
      email: _email.text.trim(),
      password: _password.text,
    );
    await context.read<AuthProvider>().register(user);
    if (!mounted) return;
    setState(() => _submitting = false);
    await AppNavigator.push(context, OtpScreen(phone: user.phone));
  }

  Widget _nameFields(double width) {
    final first = AuthTextField(
      controller: _firstName,
      focusNode: _focusNodes[0],
      nextFocusNode: _focusNodes[1],
      label: 'Ad',
      icon: Icons.person_outline_rounded,
      validator: (value) => _required(value, 'Ad'),
    );
    final last = AuthTextField(
      controller: _lastName,
      focusNode: _focusNodes[1],
      nextFocusNode: _focusNodes[2],
      label: 'Soyad',
      icon: Icons.badge_outlined,
      validator: (value) => _required(value, 'Soyad'),
    );
    if (width < 370) {
      return Column(children: [first, const SizedBox(height: 14), last]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        const SizedBox(width: 12),
        Expanded(child: last),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    dependOnThemeChanges(context);

    return AuthScreenShell(
      showBackButton: true,
      title: 'Aramıza katıl.',
      subtitle: 'Kısa bir kayıtla CafePlato Club deneyimini başlat.',
      child: Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                _nameFields(constraints.maxWidth),
                const SizedBox(height: 14),
                PhoneNumberField(
                  controller: _phone,
                  focusNode: _focusNodes[2],
                  nextFocusNode: _focusNodes[3],
                  selectedCountry: _phoneCountry,
                  onCountryChanged: (country) =>
                      setState(() => _phoneCountry = country),
                  label: 'Telefon',
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: _email,
                  focusNode: _focusNodes[3],
                  nextFocusNode: _focusNodes[4],
                  label: 'E-posta (opsiyonel)',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    if (email.isEmpty) return null;
                    if (!RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(email)) {
                      return 'Geçerli bir e-posta adresi girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: _password,
                  focusNode: _focusNodes[4],
                  nextFocusNode: _focusNodes[5],
                  label: 'Şifre',
                  icon: Icons.lock_outline_rounded,
                  obscureText: _obscurePassword,
                  onToggleObscure: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  validator: (value) => _required(value, 'Şifre'),
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: _passwordAgain,
                  focusNode: _focusNodes[5],
                  label: 'Şifre Tekrar',
                  icon: Icons.lock_reset_rounded,
                  obscureText: _obscureAgain,
                  textInputAction: TextInputAction.done,
                  onToggleObscure: () =>
                      setState(() => _obscureAgain = !_obscureAgain),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifre tekrar zorunludur.';
                    }
                    if (value != _password.text) return 'Şifreler eşleşmiyor.';
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                PrimaryButton(
                  text: 'Kayıt Ol',
                  isLoading: _submitting,
                  onPressed: _register,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
