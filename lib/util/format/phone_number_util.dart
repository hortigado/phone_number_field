import 'package:flutter/material.dart';
import 'package:intl_phone_number_field/intl_phone_number_field.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class IntPhoneNumberUtil {
  /* static PhoneNumberUtil phoneUtil = PhoneNumberUtil.instance;
 */
  /// [isValidNumber] checks if a [phoneNumber] is valid.
  /// Accepts [phoneNumber] and [isoCode]
  /// Returns [Future<bool>].
  static Future<bool?> isValidNumber({required String phoneNumber, required String isoCode}) async {
    if (phoneNumber.length < 2) {
      return false;
    }
    final number = PhoneNumber.parse(phoneNumber, callerCountry: IsoCode.fromJson(isoCode.toUpperCase()));
    return number.isValid();
  }

  /// [normalizePhoneNumber] normalizes a string of characters representing a phone number
  /// Accepts [phoneNumber] and [isoCode]
  /// Returns [Future<String>]
  static Future<String> normalizePhoneNumber({required String phoneNumber, String? isoCode}) async {
    final number = PhoneNumber.parse(phoneNumber, callerCountry: isoCode == null ? null : IsoCode.fromJson(isoCode.toUpperCase()));

    return number.nsn;
  }

  /// Accepts [phoneNumber] and [isoCode]
  /// Returns [Future<RegionInfo>] of all information available about the [phoneNumber]
  static Future<CountryCodeModel> getRegionInfo({required String phoneNumber, String? isoCode}) async {
    final number = PhoneNumber.parse(phoneNumber, callerCountry: isoCode == null ? null : IsoCode.fromJson(isoCode.toUpperCase()));

    final regionCode = number.isoCode;
    final countryCode = number.countryCode.toString();
    /* final formattedNumber = phoneUtil.format(number, PhoneNumberFormat.national); */
    return CountryCodeModel(
      code: regionCode.name,
      dial_code: countryCode,
      name: number.international,
    );
  }

  static Future<IntPhoneNumber> getRegionInfoFromIntPhoneNumber(
    String phoneNumber, [
    String? isoCode,
  ]) async {
    CountryCodeModel regionInfo = await IntPhoneNumberUtil.getRegionInfo(phoneNumber: phoneNumber, isoCode: isoCode);
    debugPrint("Region info: ${regionInfo.code} - ${regionInfo.dial_code} - ${regionInfo.name}");
    String internationalIntPhoneNumber = await IntPhoneNumberUtil.normalizePhoneNumber(
      phoneNumber: phoneNumber,
      isoCode: regionInfo.code,
    );
    String number = phoneNumber.replaceAll("+${regionInfo.dial_code}", "");
    debugPrint("number $number");
    return IntPhoneNumber(
      number: internationalIntPhoneNumber,
      code: regionInfo.code,
      dial_code: regionInfo.dial_code,
    );
  }
}
