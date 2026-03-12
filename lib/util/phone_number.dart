import 'package:flutter/material.dart';
import 'package:intl_phone_number_field/util/format/phone_number_util.dart';

import '../intl_phone_number_field.dart';

Future<IntPhoneNumber> getRegionInfoFromIntPhoneNumber(
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
