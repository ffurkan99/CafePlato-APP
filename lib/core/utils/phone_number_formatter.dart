import '../../models/country_dial_code.dart';

class ParsedPhoneNumber {
  const ParsedPhoneNumber({
    required this.country,
    required this.nationalNumber,
  });

  final CountryDialCode country;
  final String nationalNumber;

  String get e164 => '${country.dialCode}$nationalNumber';

  String? get areaCode {
    if (nationalNumber.length < country.areaCodeLength) return null;
    return nationalNumber.substring(0, country.areaCodeLength);
  }

  bool get isValid {
    return nationalNumber.length >= country.minLength &&
        nationalNumber.length <= country.maxLength;
  }
}

class PhoneNumberFormatter {
  const PhoneNumberFormatter._();

  static ParsedPhoneNumber parse(
    String input, {
    CountryDialCode country = CountryDialCodes.turkey,
  }) {
    final digits = _digitsOnly(input);
    if (digits.isEmpty) {
      return ParsedPhoneNumber(country: country, nationalNumber: '');
    }

    final isInternational =
        input.trimLeft().startsWith('+') || input.trimLeft().startsWith('00');
    if (isInternational) {
      final internationalDigits = digits.startsWith('00')
          ? digits.substring(2)
          : digits;
      final detectedCountry =
          CountryDialCodes.detectFromInternationalDigits(internationalDigits) ??
          country;
      final national = _stripCountryAndTrunkPrefix(
        internationalDigits,
        detectedCountry,
      );
      return ParsedPhoneNumber(
        country: detectedCountry,
        nationalNumber: national,
      );
    }

    final national = _stripCountryAndTrunkPrefix(digits, country);
    return ParsedPhoneNumber(country: country, nationalNumber: national);
  }

  static CountryDialCode? detectCountry(String input) {
    final trimmed = input.trimLeft();
    if (!trimmed.startsWith('+') && !trimmed.startsWith('00')) return null;
    return CountryDialCodes.detectFromInternationalDigits(_digitsOnly(input));
  }

  static String normalize(
    String input, {
    CountryDialCode country = CountryDialCodes.turkey,
  }) {
    return parse(input, country: country).e164;
  }

  static String _stripCountryAndTrunkPrefix(
    String digits,
    CountryDialCode country,
  ) {
    var national = digits;
    if (national.startsWith(country.dialCodeDigits) &&
        national.length > country.dialCodeDigits.length) {
      national = national.substring(country.dialCodeDigits.length);
    }
    if (country.trunkPrefix.isNotEmpty &&
        national.startsWith(country.trunkPrefix) &&
        national.length > country.minLength) {
      national = national.substring(country.trunkPrefix.length);
    }
    return national;
  }

  static String _digitsOnly(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }
}
