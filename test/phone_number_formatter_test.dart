import 'package:flutter_test/flutter_test.dart';
import 'package:cafe_plato/core/utils/phone_number_formatter.dart';
import 'package:cafe_plato/models/country_dial_code.dart';

void main() {
  test('normalizes Turkish local phone numbers to E.164', () {
    expect(PhoneNumberFormatter.normalize('0555 111 22 33'), '+905551112233');
    expect(PhoneNumberFormatter.normalize('5551112233'), '+905551112233');
    expect(
      PhoneNumberFormatter.normalize('+90 555 111 22 33'),
      '+905551112233',
    );
  });

  test('detects country code from international input', () {
    final parsed = PhoneNumberFormatter.parse('+49 151 23456789');

    expect(parsed.country.isoCode, 'DE');
    expect(parsed.e164, '+4915123456789');
    expect(parsed.areaCode, '151');
    expect(parsed.isValid, isTrue);
  });

  test('uses selected country when number has no international prefix', () {
    const germany = CountryDialCode(
      isoCode: 'DE',
      name: 'Almanya',
      flag: '🇩🇪',
      dialCode: '+49',
      minLength: 7,
      maxLength: 11,
      areaCodeLength: 3,
    );

    final parsed = PhoneNumberFormatter.parse(
      '0151 23456789',
      country: germany,
    );

    expect(parsed.e164, '+4915123456789');
    expect(parsed.country.isoCode, 'DE');
  });
}
