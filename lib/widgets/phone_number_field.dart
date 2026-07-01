import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/utils/phone_number_formatter.dart';
import '../models/country_dial_code.dart';

class PhoneNumberField extends StatefulWidget {
  const PhoneNumberField({
    super.key,
    required this.controller,
    required this.selectedCountry,
    required this.onCountryChanged,
    this.focusNode,
    this.nextFocusNode,
    this.label = 'Telefon numarası',
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
  });

  final TextEditingController controller;
  final CountryDialCode selectedCountry;
  final ValueChanged<CountryDialCode> onCountryChanged;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final String label;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  late CountryDialCode _selectedCountry = widget.selectedCountry;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_detectCountryFromInput);
  }

  @override
  void didUpdateWidget(covariant PhoneNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_detectCountryFromInput);
      widget.controller.addListener(_detectCountryFromInput);
    }
    if (widget.selectedCountry != _selectedCountry) {
      _selectedCountry = widget.selectedCountry;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_detectCountryFromInput);
    super.dispose();
  }

  void _detectCountryFromInput() {
    final detected = PhoneNumberFormatter.detectCountry(widget.controller.text);
    if (detected == null || detected == _selectedCountry) return;
    setState(() => _selectedCountry = detected);
    widget.onCountryChanged(detected);
  }

  void _selectCountry(CountryDialCode? country) {
    if (country == null || country == _selectedCountry) return;
    setState(() => _selectedCountry = country);
    widget.onCountryChanged(country);
  }

  String? _validate(String? value) {
    final parsed = PhoneNumberFormatter.parse(
      value ?? '',
      country: _selectedCountry,
    );
    if (parsed.nationalNumber.isEmpty) {
      return 'Telefon numaranızı girin.';
    }
    if (!parsed.isValid) {
      return 'Geçerli bir telefon numarası girin.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    final border = OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: AppColors.border),
    );

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      validator: _validate,
      keyboardType: TextInputType.phone,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9\s\-\(\)\+]')),
      ],
      onFieldSubmitted: (_) => widget.nextFocusNode?.requestFocus(),
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: AppTextStyles.bodyMedium,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 108,
          maxWidth: 118,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 6),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CountryDialCode>(
              value: _selectedCountry,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
              selectedItemBuilder: (context) {
                return CountryDialCodes.all.map((country) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${country.flag} ${country.dialCode}',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  );
                }).toList();
              },
              items: CountryDialCodes.all.map((country) {
                return DropdownMenuItem(
                  value: country,
                  child: Text(
                    '${country.flag} ${country.name} ${country.dialCode}',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: _selectCountry,
            ),
          ),
        ),
        filled: true,
        fillColor: AppColors.cardBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: AppColors.primary, width: 1.4),
        ),
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: AppColors.primary),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
    );
  }
}
