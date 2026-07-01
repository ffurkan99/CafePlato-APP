class CountryDialCode {
  const CountryDialCode({
    required this.isoCode,
    required this.name,
    required this.flag,
    required this.dialCode,
    this.minLength = 7,
    this.maxLength = 12,
    this.trunkPrefix = '0',
    this.areaCodeLength = 3,
  });

  final String isoCode;
  final String name;
  final String flag;
  final String dialCode;
  final int minLength;
  final int maxLength;
  final String trunkPrefix;
  final int areaCodeLength;

  String get dialCodeDigits => dialCode.replaceAll(RegExp(r'\D'), '');
}

class CountryDialCodes {
  const CountryDialCodes._();

  static const turkey = CountryDialCode(
    isoCode: 'TR',
    name: 'Türkiye',
    flag: '🇹🇷',
    dialCode: '+90',
    minLength: 10,
    maxLength: 10,
    areaCodeLength: 3,
  );

  static const all = <CountryDialCode>[
    turkey,
    CountryDialCode(
      isoCode: 'US',
      name: 'Amerika Birleşik Devletleri',
      flag: '🇺🇸',
      dialCode: '+1',
      minLength: 10,
      maxLength: 10,
      areaCodeLength: 3,
    ),
    CountryDialCode(
      isoCode: 'GB',
      name: 'Birleşik Krallık',
      flag: '🇬🇧',
      dialCode: '+44',
      minLength: 10,
      maxLength: 10,
      areaCodeLength: 3,
    ),
    CountryDialCode(
      isoCode: 'DE',
      name: 'Almanya',
      flag: '🇩🇪',
      dialCode: '+49',
      minLength: 7,
      maxLength: 11,
      areaCodeLength: 3,
    ),
    CountryDialCode(
      isoCode: 'FR',
      name: 'Fransa',
      flag: '🇫🇷',
      dialCode: '+33',
      minLength: 9,
      maxLength: 9,
      areaCodeLength: 1,
    ),
    CountryDialCode(
      isoCode: 'NL',
      name: 'Hollanda',
      flag: '🇳🇱',
      dialCode: '+31',
      minLength: 9,
      maxLength: 9,
      areaCodeLength: 2,
    ),
    CountryDialCode(
      isoCode: 'BE',
      name: 'Belçika',
      flag: '🇧🇪',
      dialCode: '+32',
      minLength: 8,
      maxLength: 9,
      areaCodeLength: 2,
    ),
    CountryDialCode(
      isoCode: 'AT',
      name: 'Avusturya',
      flag: '🇦🇹',
      dialCode: '+43',
      minLength: 7,
      maxLength: 12,
      areaCodeLength: 3,
    ),
    CountryDialCode(
      isoCode: 'CH',
      name: 'İsviçre',
      flag: '🇨🇭',
      dialCode: '+41',
      minLength: 9,
      maxLength: 9,
      areaCodeLength: 2,
    ),
    CountryDialCode(
      isoCode: 'IT',
      name: 'İtalya',
      flag: '🇮🇹',
      dialCode: '+39',
      minLength: 6,
      maxLength: 11,
      trunkPrefix: '',
      areaCodeLength: 3,
    ),
    CountryDialCode(
      isoCode: 'ES',
      name: 'İspanya',
      flag: '🇪🇸',
      dialCode: '+34',
      minLength: 9,
      maxLength: 9,
      trunkPrefix: '',
      areaCodeLength: 3,
    ),
    CountryDialCode(
      isoCode: 'RU',
      name: 'Rusya',
      flag: '🇷🇺',
      dialCode: '+7',
      minLength: 10,
      maxLength: 10,
      areaCodeLength: 3,
    ),
    CountryDialCode(
      isoCode: 'AZ',
      name: 'Azerbaycan',
      flag: '🇦🇿',
      dialCode: '+994',
      minLength: 9,
      maxLength: 9,
      areaCodeLength: 2,
    ),
    CountryDialCode(
      isoCode: 'CY',
      name: 'Kıbrıs',
      flag: '🇨🇾',
      dialCode: '+357',
      minLength: 8,
      maxLength: 8,
      trunkPrefix: '',
      areaCodeLength: 2,
    ),
    CountryDialCode(
      isoCode: 'AE',
      name: 'Birleşik Arap Emirlikleri',
      flag: '🇦🇪',
      dialCode: '+971',
      minLength: 8,
      maxLength: 9,
      areaCodeLength: 2,
    ),
    CountryDialCode(
      isoCode: 'SA',
      name: 'Suudi Arabistan',
      flag: '🇸🇦',
      dialCode: '+966',
      minLength: 8,
      maxLength: 9,
      areaCodeLength: 2,
    ),
    CountryDialCode(
      isoCode: 'QA',
      name: 'Katar',
      flag: '🇶🇦',
      dialCode: '+974',
      minLength: 8,
      maxLength: 8,
      trunkPrefix: '',
      areaCodeLength: 2,
    ),
    CountryDialCode(
      isoCode: 'KW',
      name: 'Kuveyt',
      flag: '🇰🇼',
      dialCode: '+965',
      minLength: 8,
      maxLength: 8,
      trunkPrefix: '',
      areaCodeLength: 2,
    ),
    CountryDialCode(
      isoCode: 'EG',
      name: 'Mısır',
      flag: '🇪🇬',
      dialCode: '+20',
      minLength: 8,
      maxLength: 10,
      areaCodeLength: 2,
    ),
    CountryDialCode(
      isoCode: 'BR',
      name: 'Brezilya',
      flag: '🇧🇷',
      dialCode: '+55',
      minLength: 10,
      maxLength: 11,
      trunkPrefix: '',
      areaCodeLength: 2,
    ),
    CountryDialCode(
      isoCode: 'CA',
      name: 'Kanada',
      flag: '🇨🇦',
      dialCode: '+1',
      minLength: 10,
      maxLength: 10,
      areaCodeLength: 3,
    ),
    CountryDialCode(
      isoCode: 'AU',
      name: 'Avustralya',
      flag: '🇦🇺',
      dialCode: '+61',
      minLength: 9,
      maxLength: 9,
      areaCodeLength: 1,
    ),
    CountryDialCode(
      isoCode: 'IN',
      name: 'Hindistan',
      flag: '🇮🇳',
      dialCode: '+91',
      minLength: 10,
      maxLength: 10,
      trunkPrefix: '',
      areaCodeLength: 3,
    ),
    CountryDialCode(
      isoCode: 'CN',
      name: 'Çin',
      flag: '🇨🇳',
      dialCode: '+86',
      minLength: 10,
      maxLength: 11,
      trunkPrefix: '',
      areaCodeLength: 3,
    ),
    CountryDialCode(
      isoCode: 'JP',
      name: 'Japonya',
      flag: '🇯🇵',
      dialCode: '+81',
      minLength: 9,
      maxLength: 10,
      areaCodeLength: 2,
    ),
  ];

  static CountryDialCode? detectFromInternationalDigits(String digits) {
    final withoutInternationalPrefix = digits.startsWith('00')
        ? digits.substring(2)
        : digits;
    final sortedCountries = [...all]
      ..sort(
        (a, b) => b.dialCodeDigits.length.compareTo(a.dialCodeDigits.length),
      );

    for (final country in sortedCountries) {
      if (withoutInternationalPrefix.startsWith(country.dialCodeDigits)) {
        return country;
      }
    }
    return null;
  }
}
