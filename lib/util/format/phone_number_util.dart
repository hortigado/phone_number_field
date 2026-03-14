import 'package:dlibphonenumber/dlibphonenumber.dart' as p;
import 'package:flutter/material.dart';
import 'package:intl_phone_number_field/intl_phone_number_field.dart';
import 'package:intl_phone_number_field/models/country_code_model.dart';

class IntPhoneNumberUtil {
  static p.PhoneNumberUtil phoneUtil = p.PhoneNumberUtil.instance;

  /// [isValidNumber] checks if a [phoneNumber] is valid.
  /// Accepts [phoneNumber] and [isoCode]
  /// Returns [Future<bool>].
  static Future<bool?> isValidNumber({required String phoneNumber, required String isoCode}) async {
    if (phoneNumber.length < 2) {
      return false;
    }
    final number = phoneUtil.parse(phoneNumber, isoCode.toUpperCase());
    return phoneUtil.isValidNumber(number);
  }

  /// [normalizePhoneNumber] normalizes a string of characters representing a phone number
  /// Accepts [phoneNumber] and [isoCode]
  /// Returns [Future<String>]
  static Future<String> normalizePhoneNumber({required String phoneNumber, required String isoCode}) async {
    final number = phoneUtil.parse(phoneNumber, isoCode.toUpperCase());
    return phoneUtil.format(number, p.PhoneNumberFormat.e164);
  }

  /// Accepts [phoneNumber] and [isoCode]
  /// Returns [Future<RegionInfo>] of all information available about the [phoneNumber]
  static Future<CountryCodeModel> getRegionInfo({required String phoneNumber, String? isoCode}) async {
    final number = phoneUtil.parse(phoneNumber, isoCode);
    final regionCode = phoneUtil.getRegionCodeForNumber(number);
    final countryCode = number.countryCode.toString();
    final formattedNumber = phoneUtil.format(number, p.PhoneNumberFormat.national);
    return CountryCodeModel(
      code: regionCode!,
      dial_code: countryCode,
      name: formattedNumber,
    );
  }

  static Future<IntPhoneNumber> getRegionInfoFromIntPhoneNumber(
    String phoneNumber, [
    String isoCode = '',
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
      number: number,
      code: regionInfo.code,
      dial_code: regionInfo.dial_code,
    );
  }
}
